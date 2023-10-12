Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E17A5CDB46E
	for <linux-scsi@archiver.kernel.org>; Thu, 12 Oct 2023 17:53:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1441930AbjJLRxl (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 12 Oct 2023 13:53:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58120 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1441919AbjJLRxk (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 12 Oct 2023 13:53:40 -0400
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1C2C8CA
        for <linux-scsi@vger.kernel.org>; Thu, 12 Oct 2023 10:53:38 -0700 (PDT)
Received: from pps.filterd (m0360072.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 39CHjeRX002994;
        Thu, 12 Oct 2023 17:53:31 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : references : content-type : in-reply-to : sender :
 content-transfer-encoding : mime-version; s=pp1;
 bh=LgQrTS/6rZAgjUr58FbY1TrZYXHrJFsnm1gUhWJ/CXo=;
 b=p/jLiRAidr20W+3t1fT84twkMPOnMDA+oexVOttwrj4LNgmy7rmb4RjIQbYpimdYQ5OK
 nnV9yqvEegaTv1xrJ/AvrRzYE7UkIFftHGJFLL3tHN8Wu8IVnxAeey5Bw2xOkoJn6e94
 mQWzKe/dA9binsX72tWdQv8f5ha9+r+UpnZ++lh7jW0Oqguc4WDI2H1y41VJFLFEjpFK
 0c4SxEDP+oF/VOwwkrVRXXuTfdq0z36mQwSEJK8fZho6nhSwmcu+upCbYUTmuljYtl0r
 NQqLEoXv7CFE/mk2LnAgx7hUP7V9471z+3PHgaO6eIDov2ALLJIVuPftbb2WF/jvlThX wA== 
Received: from ppma21.wdc07v.mail.ibm.com (5b.69.3da9.ip4.static.sl-reverse.com [169.61.105.91])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3tpnfsg2pd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 12 Oct 2023 17:53:29 +0000
Received: from pps.filterd (ppma21.wdc07v.mail.ibm.com [127.0.0.1])
        by ppma21.wdc07v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 39CHarhY026364;
        Thu, 12 Oct 2023 17:49:12 GMT
Received: from smtprelay03.fra02v.mail.ibm.com ([9.218.2.224])
        by ppma21.wdc07v.mail.ibm.com (PPS) with ESMTPS id 3tkjnnsamk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 12 Oct 2023 17:49:12 +0000
Received: from smtpav06.fra02v.mail.ibm.com (smtpav06.fra02v.mail.ibm.com [10.20.54.105])
        by smtprelay03.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 39CHn9th16712220
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 12 Oct 2023 17:49:09 GMT
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 61EE020049;
        Thu, 12 Oct 2023 17:49:09 +0000 (GMT)
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 4055420040;
        Thu, 12 Oct 2023 17:49:09 +0000 (GMT)
Received: from p1gen4-pw042f0m (unknown [9.179.23.150])
        by smtpav06.fra02v.mail.ibm.com (Postfix) with ESMTPS;
        Thu, 12 Oct 2023 17:49:09 +0000 (GMT)
Received: from bblock by p1gen4-pw042f0m with local (Exim 4.96.1)
        (envelope-from <bblock@linux.ibm.com>)
        id 1qqzo4-0047P1-2L;
        Thu, 12 Oct 2023 19:49:08 +0200
Date:   Thu, 12 Oct 2023 19:49:08 +0200
From:   Benjamin Block <bblock@linux.ibm.com>
To:     Hannes Reinecke <hare@suse.de>
Cc:     "Martin K. Petersen" <martin.petersen@oracle.com>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        linux-scsi@vger.kernel.org, Christoph Hellwig <hch@lst.de>,
        Steffen Maier <maier@linux.ibm.com>
Subject: Re: [PATCH 01/15] zfcp: do not wait for rports to become unblocked
 after host reset
Message-ID: <20231012174908.GC31157@p1gen4-pw042f0m.fritz.box>
References: <20231002154927.68643-1-hare@suse.de>
 <20231002154927.68643-2-hare@suse.de>
 <20231012135452.GB31157@p1gen4-pw042f0m.fritz.box>
 <58658f0c-c5e9-4321-8bd1-13223472eb1b@suse.de>
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <58658f0c-c5e9-4321-8bd1-13223472eb1b@suse.de>
Sender: Benjamin Block <bblock@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: LCA_fDcG8eY4CHGzSpey0RBXMRuKNL9Z
X-Proofpoint-ORIG-GUID: LCA_fDcG8eY4CHGzSpey0RBXMRuKNL9Z
Content-Transfer-Encoding: 8bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.267,Aquarius:18.0.980,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2023-10-12_09,2023-10-12_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015 mlxscore=0
 priorityscore=1501 adultscore=0 bulkscore=0 suspectscore=0 phishscore=0
 impostorscore=0 spamscore=0 malwarescore=0 mlxlogscore=999
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2309180000 definitions=main-2310120148
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Thu, Oct 12, 2023 at 04:23:47PM +0200, Hannes Reinecke wrote:
> On 10/12/23 15:54, Benjamin Block wrote:
> > On Mon, Oct 02, 2023 at 05:49:13PM +0200, Hannes Reinecke wrote:
> >> zfcp_scsi_eh_host_reset_handler() would call fc_block_rport() to
> >> wait for all rports to become unblocked after host reset.
> >> But after host reset it might happen that the port is gone, hence
> >> fc_block_rport() might fail due to a missing port.
> >> But that's a perfectly legal operation; on FC remote ports might
> >> come and go.
> >> In the same vein FC HBAs are able to deal with ports being temporarily
> >> blocked, so really there is not point in waiting for all ports
> >> to become unblocked during host reset.
> > 
> > But in scsi_transport_fc.c we have this documented:
> > 
> >      * fc_block_scsi_eh - Block SCSI eh thread for blocked fc_rport
> >      * @cmnd: SCSI command that scsi_eh is trying to recover
> >      *
> >      * This routine can be called from a FC LLD scsi_eh callback. It
> >      * blocks the scsi_eh thread until the fc_rport leaves the
> >      * FC_PORTSTATE_BLOCKED, or the fast_io_fail_tmo fires. This is
> >      * necessary to avoid the scsi_eh failing recovery actions for blocked
> >                  ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
> >      * rports which would lead to offlined SCSI devices.
> >        ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
> > 
> > So I don't understand what the real expectation by the SCSI EH call back for
> > host reset is then.
> > 
> > Is it that all objects (host/target ports/luns) are operational again once we
> > return to the EH thread, or is it ok that some parts are still being
> > recovered (as with our host reset handler, rports might still be blocked after
> > `zfcp_erp_wait()` finishes, because of how this is organized internally).
> > 
> > If it's the later, I'd think this change is fine. But then I'd wonder why this
> > function exists in the first place? Is it because in other EH steps it's more
> > important that rports are ready after the step (e.g. because a TUR is send
> > after, and if that fails, things get escalate unnecessarily)?
> >
>
> Thing is, fc_block_scsi_eh() is assumed to be called from eh callbacks
> _before_ any TMFs are to be sent.
> Typically you would call them in eh_device_reset() or eh_target_reset()
> to ensure that you can sent TMFs in the first place; no point in attempting
> to send TMFs is the port is blocked.

Ok. Interesting. We don't really care about the state of the rport when
sending TMFs or Aborts, as those commands are sent outside the normal
queuecommand flow (we just check "internal bits"), in case of Aborts we even
hand this off to firmware. Consequently we don't really care about their state
before trying to send either.

> Your particular case is arguably a mis-use of fc_block_scsi_eh() as
> it is called _after_ host reset is initiated, essentially serving as
> a completion point to ensure that all rports are back online.
> 
> However, for the FC transport implementation rport lifetimes are
> decoupled from SCSI Host lifetimes; rports may (and do!) come and
> go during the lifetime of a SCSI host.

Ye, Ack. We can't control Fabric events.

> Consequently there is no
> difference between a host with all rports blocked (eg during RSCN
> processing) and a host just coming on-line after SCSI EH where rports
> are still in the process of getting ready.
> 
> Hence the use of fc_block_scsi_eh() after host reset is not required,
> and we can make our life easier by just dropping the call.
> 
> > Oh.. speaking of that, we do send a TUR after host reset as well
> > (`scsi_eh_test_devices()`). So doesn't this break then if one or more rports
> > are sill blocked after host reset returns?
> >      At least `zfcp_scsi_queuecommand()` will bail very early if the rport is
> > not ready (we call `fc_remote_port_chkready()` as more or less first thing),
> > and so `scsi_send_eh_cmnd()` that is used for the TUR will fail; then it might
> > be retried one time, but this is a tight loop without any delay, so I'd guess
> > this has a good chance to fail as well.
> >      And then we'd offline the whole host as further escalation, which would
> > *REALLY* suck (with no automatic recovery no less).
> > 
> > My impression from look at the code that follows `scsi_try_host_reset()` in
> > `scsi_error.c` really is, it rather expects things to be ready to be used
> > after, right there and then (admittedly, this is probably already today
> > problematic, as things might go back to not working concurrently because of
> > some fabric event.. but anyway, we can life with that off-chance it seems).
> > 
> > Or do I miss something?
> > 
>
> Ah, right. True, when the rports are not ready (ie still being blocked)
> sending a TEST UNIT READY will fail, with probably unintended consequences.
> 
> But: if host reset would return FAST_IO_FAIL everything would be dandy

Ok, so that would mean, we finish all commands left in the EH work_q with
`scsi_eh_finish_cmd()`, and not populate the local `check_list` at all, which
in turns means, we don't do anything in `scsi_eh_test_devices()` (no state
checks, not TURs).

> as then we would just check if the devices are online (by virtue of
> scsi_eh_flush_done_q() in scsi_unjam_host()), which they really should
> as no-one should have set them offline by then.

When returning to `scsi_unjam_host()` directly after we return from
`scsi_eh_host_reset()` we call into `scsi_eh_flush_done_q()` and go over all
commands that are now in the done-queue (everything, if host reset returned
FAST_IO_FAIL).

In there we delete the commands from the EH list, and then check whether we
ought to retry the command on the same SDEV or return it to some upper layer
(i.e. hopefully dm-multipath for our installations).

The former depends on whether the SDEV is online again. If everything is fine
in the SAN (not cable pulled or something), I think this should be the case,
but IFF we assume the rport is still blocked because the async registration
(`zfcp_scsi_rport_work()`) hasn't finished yet (the original point for using
`fc_block_scsi_eh()`), then the SDEV might still be in state
SDEV_TRANSPORT_OFFLINE.
    This can happen during adapter recovery (where we block, IOW call
`fc_remote_port_delete()` on all rports) if fast-io-fail-tmo runs out, and
`fc_terminate_rport_io()` is called.
    That is undone when we call `fc_remote_port_add()` to 'unblock' the rport.
This would then set all SDEVs into RUNNING again. And there we have the
interaction with `fc_block_scsi_eh()` again.

Hmm. I think I could life with both though. If someone drives I/O directly on
the SDEV, and it fails after EH because of some unfortunate timing, that's bad
luck, and something was actually wrong in the SAN if fast-io-fail-tmo runs out
during recovery. They ought to use dm-multipath.
    And if they do, the commands are re-issued from that layer. I think that
should be fine.

So I think we can work with returning FAST_IO_FAIL from
`zfcp_scsi_eh_host_reset_handler()`, and removing the call to
`fc_block_scsi_eh()`.
    We (Steffen and/or I) might still want to look into some other solution
for only returning from that when we know the async rport registrations have
ran at least once after adapter recovery. But as far as your patchset goes, I
don't think that is a gate.


-- 
Best Regards, Benjamin Block        /        Linux on IBM Z Kernel Development
IBM Deutschland Research & Development GmbH    /   https://www.ibm.com/privacy
Vors. Aufs.-R.: Gregor Pillen         /         Geschäftsführung: David Faller
Sitz der Ges.: Böblingen     /    Registergericht: AmtsG Stuttgart, HRB 243294
