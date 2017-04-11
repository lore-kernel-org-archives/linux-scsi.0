From: Mauricio Faria de Oliveira <mauricfo@linux.vnet.ibm.com>
Subject: Re: [PATCH 0/4] scsi: scsi_dh_alua: handle target port unavailable
 state
Date: Mon, 10 Apr 2017 22:21:44 -0300
Message-ID: <948a9a8f-209e-a3f4-2891-69f85f443a69@linux.vnet.ibm.com>
References: <1491873481-23900-1-git-send-email-mauricfo@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:50409 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1752214AbdDKBVy (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 10 Apr 2017 21:21:54 -0400
Received: from pps.filterd (m0098419.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.20/8.16.0.20) with SMTP id v3B1IkgB038398
        for <linux-scsi@vger.kernel.org>; Mon, 10 Apr 2017 21:21:53 -0400
Received: from e24smtp05.br.ibm.com (e24smtp05.br.ibm.com [32.104.18.26])
        by mx0b-001b2d01.pphosted.com with ESMTP id 29rm8x2e81-1
        (version=TLSv1.2 cipher=AES256-SHA bits=256 verify=NOT)
        for <linux-scsi@vger.kernel.org>; Mon, 10 Apr 2017 21:21:53 -0400
Received: from localhost
        by e24smtp05.br.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <linux-scsi@vger.kernel.org> from <mauricfo@linux.vnet.ibm.com>;
        Mon, 10 Apr 2017 22:21:51 -0300
Received: from d24av05.br.ibm.com (d24av05.br.ibm.com [9.18.232.44])
        by d24relay03.br.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id v3B1Lm1F66060346
        for <linux-scsi@vger.kernel.org>; Mon, 10 Apr 2017 22:21:48 -0300
Received: from d24av05.br.ibm.com (localhost [127.0.0.1])
        by d24av05.br.ibm.com (8.14.4/8.14.4/NCO v10.0 AVout) with ESMTP id v3B1Lnrd004169
        for <linux-scsi@vger.kernel.org>; Mon, 10 Apr 2017 22:21:50 -0300
In-Reply-To: <1491873481-23900-1-git-send-email-mauricfo@linux.vnet.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: hare@suse.de, martin.petersen@oracle.com
Cc: linux-scsi@vger.kernel.org, bart.vanassche@sandisk.com

On 04/10/2017 10:17 PM, Mauricio Faria de Oliveira wrote:
> For documentation purposes, I'll reply to this cover letter with the analysis
> of such cases of this problem, and the accompanying messages from kernel logs.

Here it goes, for anyone interested.
Scenario: 4 LUNs, 2 target port groups (PGs), 2 paths per PG.

mpatha (360050764008100dac000000000000100) dm-0 IBM,2145
size=40G features='2 queue_if_no_path retain_attached_hw_handler' 
hwhandler='1 alua' wp=rw
|-+- policy='service-time 0' prio=0 status=active
| |- 1:0:1:0 sdf 8:80  active undef running
| `- 2:0:1:0 sdn 8:208 active undef running
`-+- policy='service-time 0' prio=0 status=enabled
   |- 1:0:0:0 sdb 8:16  active undef running
   `- 2:0:0:0 sdj 8:144 active undef running

This LUN's active port group becomes Unavailable.
The ongoing I/O requests sense it via SCSI command errors.

	Apr  6 07:14:56 ltcalpine-lp2 kernel: sd 1:0:1:0: [sdf] tag#0 Add. 
Sense: Logical unit not accessible, target port in unavailable state
	Apr  6 07:14:56 ltcalpine-lp2 kernel: sd 2:0:1:0: [sdn] tag#0 Add. 
Sense: Logical unit not accessible, target port in unavailable state

Accordingly, dm-mpath fails both paths:

	Apr  6 07:14:56 ltcalpine-lp2 kernel: device-mapper: multipath: Failing 
path 8:80.
	Apr  6 07:14:56 ltcalpine-lp2 kernel: device-mapper: multipath: Failing 
path 8:208.

The SCSI command error has gone through alua_check_sense().
It scheduled an alua_rtpg(), which confirms its port group
(for 1:0:1:0) and the other (for 2:0:0:0) are unavailable.

	Apr  6 07:14:56 ltcalpine-lp2 kernel: sd 2:0:0:0: alua: port group 01 
state U non-preferred
	Apr  6 07:14:56 ltcalpine-lp2 kernel: sd 1:0:1:0: alua: port group 00 
state U non-preferred supports tolusna

Failing over, dm-mpath switched path groups, to the other/enabled port 
group.

Notice that further SCSI command errors _happen_, but are not _reported_,
as alua_rtpg() has set pg->state = unavailable before more I/O requests
eventually reached alua_prep_fn(), which sets them with RQF_QUIET.

Accordingly, dm-mpath fails both paths:

	Apr  6 07:14:56 ltcalpine-lp2 kernel: device-mapper: multipath: Failing 
path 8:144.
	Apr  6 07:14:56 ltcalpine-lp2 kernel: device-mapper: multipath: Failing 
path 8:16.

The path checkers are running, and constantly receiving senses of 
unavailable state
(seen through debug messages), and alua_rtpg() rechecks are scheduled, 
but no
repeated messages for 'state U' are printed, as it has not changed at all.

After a few minutes, both port groups become active 
(optimized/non-optimized),
and dm-mpath reinstate all paths:

	Apr  6 07:21:01 ltcalpine-lp2 kernel: device-mapper: multipath: 
Reinstating path 8:16.
	Apr  6 07:21:01 ltcalpine-lp2 kernel: device-mapper: multipath: 
Reinstating path 8:80.
	Apr  6 07:21:01 ltcalpine-lp2 kernel: device-mapper: multipath: 
Reinstating path 8:144.
	Apr  6 07:21:01 ltcalpine-lp2 kernel: device-mapper: multipath: 
Reinstating path 8:208.

The dm-mpath reinstate calls alua_activate() -> alua_rtpg() for both 
paths in the active port group.
The first alua_rtpg() worker is still running when the second 
alua_rtpg() is scheduled,
so pg->rtpg_sdev does not change, and it's reported as 1:0:1:0 twice 
(but called for 1:0:1:0 and 2:0:1:0).

	Apr  6 07:21:01 ltcalpine-lp2 kernel: sd 2:0:0:0: alua: port group 01 
state N non-preferred
	Apr  6 07:21:01 ltcalpine-lp2 kernel: sd 1:0:1:0: alua: port group 00 
state A non-preferred supports tolusna
	Apr  6 07:21:01 ltcalpine-lp2 kernel: sd 2:0:0:0: alua: port group 01 
state N non-preferred
	Apr  6 07:21:01 ltcalpine-lp2 kernel: sd 1:0:1:0: alua: port group 00 
state A non-preferred supports tolusna



...


mpathb (360050764008100dac000000000000101) dm-1 IBM,2145
size=40G features='2 queue_if_no_path retain_attached_hw_handler' 
hwhandler='1 alua' wp=rw
|-+- policy='service-time 0' prio=0 status=active
| |- 1:0:0:1 sdc 8:32  active undef running
| `- 2:0:0:1 sdk 8:160 active undef running
`-+- policy='service-time 0' prio=0 status=enabled
   |- 1:0:1:1 sdg 8:96  active undef running
   `- 2:0:1:1 sdo 8:224 active undef running


Similarly,

	Apr  5 19:59:52 ltcalpine-lp2 kernel: sd 2:0:0:1: [sdk] tag#2 Add. 
Sense: Logical unit not accessible, target port in unavailable state
	Apr  5 19:59:52 ltcalpine-lp2 kernel: sd 1:0:0:1: [sdc] tag#5 Add. 
Sense: Logical unit not accessible, target port in unavailable state

	Apr  5 19:59:52 ltcalpine-lp2 kernel: device-mapper: multipath: Failing 
path 8:160.
	Apr  5 19:59:52 ltcalpine-lp2 kernel: device-mapper: multipath: Failing 
path 8:32.

In this case alua_rtpg() does not print messages for the 'other' port group
(without 'supports'), because the other PG worker was running at the time.
There was an alua_rtpg() scheduled due to alua_check_sense() for 2:0:0:1,
and another for alua_activate() of 1:0:1:1 (from the 'enabled' path group).

	Apr  5 19:59:52 ltcalpine-lp2 kernel: sd 2:0:0:1: alua: port group 00 
state U non-preferred supports tolusna
	Apr  5 19:59:52 ltcalpine-lp2 kernel: sd 1:0:1:1: alua: port group 01 
state U non-preferred supports tolusna

	Apr  5 19:59:52 ltcalpine-lp2 kernel: device-mapper: multipath: Failing 
path 8:96.
	Apr  5 19:59:52 ltcalpine-lp2 kernel: device-mapper: multipath: Failing 
path 8:224.

After a few minutes,

	Apr  5 20:53:01 ltcalpine-lp2 kernel: device-mapper: multipath: 
Reinstating path 8:96.
	Apr  5 20:53:01 ltcalpine-lp2 kernel: device-mapper: multipath: 
Reinstating path 8:224.

	Apr  5 20:53:01 ltcalpine-lp2 kernel: sd 2:0:0:1: alua: port group 00 
state A non-preferred
	Apr  5 20:53:01 ltcalpine-lp2 kernel: sd 1:0:1:1: alua: port group 01 
state N non-preferred supports tolusna
	Apr  5 20:53:01 ltcalpine-lp2 kernel: sd 2:0:0:1: alua: port group 00 
state A non-preferred
	Apr  5 20:53:01 ltcalpine-lp2 kernel: sd 1:0:1:1: alua: port group 01 
state N non-preferred supports tolusna

	Apr  5 20:53:06 ltcalpine-lp2 kernel: device-mapper: multipath: 
Reinstating path 8:32.
	Apr  5 20:53:06 ltcalpine-lp2 kernel: device-mapper: multipath: 
Reinstating path 8:160.


...


mpathc (360050764008100dac000000000000141) dm-2 IBM,2145
size=40G features='2 queue_if_no_path retain_attached_hw_handler' 
hwhandler='1 alua' wp=rw
|-+- policy='service-time 0' prio=0 status=active
| |- 1:0:0:2 sdd 8:48  active undef running
| `- 2:0:0:2 sdl 8:176 active undef running
`-+- policy='service-time 0' prio=0 status=enabled
   |- 1:0:1:2 sdh 8:112 active undef running
   `- 2:0:1:2 sdp 8:240 active undef running

With this one, no SCSI command error messages because
the path checkers noticed the unavailable state first.

	Apr  5 19:59:52 ltcalpine-lp2 kernel: device-mapper: multipath: Failing 
path 8:176.
	Apr  5 19:59:52 ltcalpine-lp2 kernel: device-mapper: multipath: Failing 
path 8:48.

In this case alua_rtpg() does not print messages for the 'other' port group
(same reason as described in previous case). Both port groups are 
unavailable.

	Apr  5 19:59:52 ltcalpine-lp2 kernel: sd 2:0:0:2: alua: port group 00 
state U non-preferred supports tolusna
	Apr  5 19:59:52 ltcalpine-lp2 kernel: sd 1:0:1:2: alua: port group 01 
state U non-preferred supports tolusna

	Apr  5 19:59:52 ltcalpine-lp2 kernel: device-mapper: multipath: Failing 
path 8:240.
	Apr  5 19:59:52 ltcalpine-lp2 kernel: device-mapper: multipath: Failing 
path 8:112.

After a few minutes, they return to active (opt/non-opt) state.

	Apr  5 20:53:01 ltcalpine-lp2 kernel: device-mapper: multipath: 
Reinstating path 8:112.
	Apr  5 20:53:01 ltcalpine-lp2 kernel: sd 2:0:0:2: alua: port group 00 
state A non-preferred
	Apr  5 20:53:01 ltcalpine-lp2 kernel: sd 1:0:1:2: alua: port group 01 
state N non-preferred supports tolusna
	Apr  5 20:53:04 ltcalpine-lp2 kernel: device-mapper: multipath: 
Reinstating path 8:176.
	Apr  5 20:53:04 ltcalpine-lp2 kernel: sd 2:0:1:2: alua: port group 01 
state N non-preferred
	Apr  5 20:53:04 ltcalpine-lp2 kernel: sd 2:0:0:2: alua: port group 00 
state A non-preferred supports tolusna
	Apr  5 20:53:05 ltcalpine-lp2 kernel: device-mapper: multipath: 
Reinstating path 8:48.
	Apr  5 20:53:05 ltcalpine-lp2 kernel: sd 2:0:1:2: alua: port group 01 
state N non-preferred
	Apr  5 20:53:05 ltcalpine-lp2 kernel: sd 1:0:0:2: alua: port group 00 
state A non-preferred supports tolusna
	Apr  5 20:53:06 ltcalpine-lp2 kernel: device-mapper: multipath: 
Reinstating path 8:240.

...

mpathd (360050764008100dac000000000000142) dm-3 IBM,2145
size=40G features='2 queue_if_no_path retain_attached_hw_handler' 
hwhandler='1 alua' wp=rw
|-+- policy='service-time 0' prio=0 status=active
| |- 1:0:1:3 sdi 8:128 active undef running
| `- 2:0:1:3 sdq 65:0  active undef running
`-+- policy='service-time 0' prio=0 status=enabled
   |- 1:0:0:3 sde 8:64  active undef running
   `- 2:0:0:3 sdm 8:192 active undef running

Similarly to the cases above, with some duplicated messages for the RTPG 
information
because alua_activate() schedules both ALUA_PG_RUN_[RS]TPG, so 
alua_rtpg_work() first
runs ALUA_PG_RUN_RTPG / alua_rtpg() which prints the message once, and 
then goes into
ALUA_PG_RUN_STPG / alua_stpg(), but as this storage system only supports 
implict TGPS,
it falls into SCSI_DH_RETRY, which schedules another 
ALUA_PG_RUN_RTPG/alua_rtpg() and
it prints the message again.

	Apr  6 07:14:56 ltcalpine-lp2 kernel: sd 2:0:1:3: [sdq] tag#5 Add. 
Sense: Logical unit not accessible, target port in unavailable state
	Apr  6 07:14:56 ltcalpine-lp2 kernel: device-mapper: multipath: Failing 
path 65:0.
	Apr  6 07:14:56 ltcalpine-lp2 kernel: sd 1:0:1:3: [sdi] tag#8 Add. 
Sense: Logical unit not accessible, target port in unavailable state
	Apr  6 07:14:56 ltcalpine-lp2 kernel: device-mapper: multipath: Failing 
path 8:128.

	Apr  6 07:14:56 ltcalpine-lp2 kernel: sd 2:0:0:3: alua: port group 01 
state U non-preferred
	Apr  6 07:14:56 ltcalpine-lp2 kernel: sd 1:0:1:3: alua: port group 00 
state U non-preferred supports tolusna

	Apr  6 07:14:56 ltcalpine-lp2 kernel: device-mapper: multipath: Failing 
path 8:192.
	Apr  6 07:14:56 ltcalpine-lp2 kernel: device-mapper: multipath: Failing 
path 8:64.

	Apr  6 07:47:25 ltcalpine-lp2 kernel: device-mapper: multipath: 
Reinstating path 8:192.
	Apr  6 07:47:25 ltcalpine-lp2 kernel: sd 2:0:1:3: alua: port group 00 
state A non-preferred
	Apr  6 07:47:25 ltcalpine-lp2 kernel: sd 2:0:0:3: alua: port group 01 
state N non-preferred supports tolusna
	Apr  6 07:47:25 ltcalpine-lp2 kernel: sd 2:0:1:3: alua: port group 00 
state A non-preferred
	Apr  6 07:47:25 ltcalpine-lp2 kernel: sd 2:0:0:3: alua: port group 01 
state N non-preferred supports tolusna
	Apr  6 07:47:26 ltcalpine-lp2 kernel: device-mapper: multipath: 
Reinstating path 8:64.
	Apr  6 07:47:26 ltcalpine-lp2 kernel: device-mapper: multipath: 
Reinstating path 8:128.
	Apr  6 07:47:26 ltcalpine-lp2 kernel: device-mapper: multipath: 
Reinstating path 65:0.
	Apr  6 07:47:26 ltcalpine-lp2 kernel: sd 2:0:1:3: alua: port group 00 
state A non-preferred
	Apr  6 07:47:26 ltcalpine-lp2 kernel: sd 1:0:0:3: alua: port group 01 
state N non-preferred supports tolusna
	Apr  6 07:47:26 ltcalpine-lp2 kernel: sd 2:0:1:3: alua: port group 00 
state A non-preferred
	Apr  6 07:47:26 ltcalpine-lp2 kernel: sd 1:0:0:3: alua: port group 01 
state N non-preferred supports tolusna
	Apr  6 07:47:26 ltcalpine-lp2 kernel: sd 2:0:0:3: alua: port group 01 
state N non-preferred
	Apr  6 07:47:26 ltcalpine-lp2 kernel: sd 1:0:1:3: alua: port group 00 
state A non-preferred supports tolusna
	Apr  6 07:47:26 ltcalpine-lp2 kernel: sd 2:0:0:3: alua: port group 01 
state N non-preferred
	Apr  6 07:47:26 ltcalpine-lp2 kernel: sd 1:0:1:3: alua: port group 00 
state A non-preferred supports tolusna



-- 
Mauricio Faria de Oliveira
IBM Linux Technology Center
