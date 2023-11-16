Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EE11EC197A0
	for <linux-scsi@archiver.kernel.org>; Thu, 16 Nov 2023 08:45:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344538AbjKPIpr (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 16 Nov 2023 03:45:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45912 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230228AbjKPIpq (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 16 Nov 2023 03:45:46 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2E848A1
        for <linux-scsi@vger.kernel.org>; Thu, 16 Nov 2023 00:45:42 -0800 (PST)
Received: by smtp.kernel.org (Postfix) with ESMTPS id A72A8C433CC
        for <linux-scsi@vger.kernel.org>; Thu, 16 Nov 2023 08:45:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1700124341;
        bh=I2HcXNA8nxJoEkgUgXO62dbC2jUaQ/vD90JChwAMLJw=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=Yafmoia0ID/xvdb4PU/vT64O/vwXXFUxAzAAvQbLhN60CrBYCRpzraewkg8XlxDrw
         nWHEybUZsy+j2q8Q4W7OK1iEogTZd4LXufYqlVUpcAPleQHtHgjs21BQwE7fSZp/+b
         KL0U7u757hm22lZg+6zL2xnz1+pjNUbHvgyXD+0lubHsdvsQ4l99/1FlLcOuH3GThG
         gym0wLZE5ARM8zKnO6RehzpfCqfNwzyeavIkEzw/fl85eOvCaUAeYThOCyuwPC0SmW
         ZN7q6naWaPyHZb4x7lf2yKSyscnVtfTrEZyKe3ZqbK5wKvsNnH+NJThfzJlLXa3OlJ
         WFdJq/zP2N/wA==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
        id 93955C53BD6; Thu, 16 Nov 2023 08:45:41 +0000 (UTC)
From:   bugzilla-daemon@kernel.org
To:     linux-scsi@vger.kernel.org
Subject: [Bug 217599] Adaptec 71605z hangs with aacraid: Host adapter abort
 request after update to linux 6.4.0
Date:   Thu, 16 Nov 2023 08:45:41 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo scsi_drivers-aacraid@kernel-bugs.osdl.org
X-Bugzilla-Product: SCSI Drivers
X-Bugzilla-Component: AACRAID
X-Bugzilla-Version: 2.5
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: high
X-Bugzilla-Who: joop.boonen@netapp.com
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P3
X-Bugzilla-Assigned-To: scsi_drivers-aacraid@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: cc
Message-ID: <bug-217599-11613-b32MjWIJo0@https.bugzilla.kernel.org/>
In-Reply-To: <bug-217599-11613@https.bugzilla.kernel.org/>
References: <bug-217599-11613@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Bugzilla-URL: https://bugzilla.kernel.org/
Auto-Submitted: auto-generated
MIME-Version: 1.0
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=3D217599

Joop Boonen (joop.boonen@netapp.com) changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
                 CC|                            |joop.boonen@netapp.com

--- Comment #26 from Joop Boonen (joop.boonen@netapp.com) ---
We have noticed on our Server using an Adaptec ASR8805 RAID controller runn=
ing
Debian 12 i.e. Bookworm Kernel 6.1.55
That we get 100% wait states that causes the system to hang.
top - 12:57:32 up 7 min,  2 users,  load average: 5.02, 1.71, 0.65
Tasks: 451 total,   2 running, 449 sleeping,   0 stopped,   0 zombie
%Cpu0  :  0.0 us,  0.0 sy,  0.0 ni,100.0 id,  0.0 wa,  0.0 hi,  0.0 si,  0.=
0 st
%Cpu1  :  0.0 us,  0.0 sy,  0.0 ni, 81.8 id, 18.2 wa,  0.0 hi,  0.0 si,  0.=
0 st
%Cpu2  :  0.0 us,  0.0 sy,  0.0 ni,100.0 id,  0.0 wa,  0.0 hi,  0.0 si,  0.=
0 st
%Cpu3  :  0.0 us,  0.0 sy,  0.0 ni,100.0 id,  0.0 wa,  0.0 hi,  0.0 si,  0.=
0 st
%Cpu4  :  0.0 us,  0.0 sy,  0.0 ni,100.0 id,  0.0 wa,  0.0 hi,  0.0 si,  0.=
0 st
%Cpu5  :  0.0 us,  0.0 sy,  0.0 ni,100.0 id,  0.0 wa,  0.0 hi,  0.0 si,  0.=
0 st
%Cpu6  :  0.0 us,  0.0 sy,  0.0 ni,100.0 id,  0.0 wa,  0.0 hi,  0.0 si,  0.=
0 st
%Cpu7  :  0.0 us,  0.0 sy,  0.0 ni,100.0 id,  0.0 wa,  0.0 hi,  0.0 si,  0.=
0 st
%Cpu8  :  0.0 us,  0.0 sy,  0.0 ni,100.0 id,  0.0 wa,  0.0 hi,  0.0 si,  0.=
0 st
%Cpu9  :  0.0 us,  0.0 sy,  0.0 ni,100.0 id,  0.0 wa,  0.0 hi,  0.0 si,  0.=
0 st
%Cpu10 :  0.3 us,  0.3 sy,  0.0 ni, 99.3 id,  0.0 wa,  0.0 hi,  0.0 si,  0.=
0 st
%Cpu11 :  0.0 us,  0.0 sy,  0.0 ni,100.0 id,  0.0 wa,  0.0 hi,  0.0 si,  0.=
0 st
%Cpu12 :  0.0 us,  0.0 sy,  0.0 ni,100.0 id,  0.0 wa,  0.0 hi,  0.0 si,  0.=
0 st
%Cpu13 :  0.0 us,  0.0 sy,  0.0 ni,100.0 id,  0.0 wa,  0.0 hi,  0.0 si,  0.=
0 st
%Cpu14 :  0.0 us,  0.0 sy,  0.0 ni,100.0 id,  0.0 wa,  0.0 hi,  0.0 si,  0.=
0 st
%Cpu15 :  0.0 us,  0.0 sy,  0.0 ni,100.0 id,  0.0 wa,  0.0 hi,  0.0 si,  0.=
0 st
%Cpu16 :  0.0 us,100.0 sy,  0.0 ni,  0.0 id,  0.0 wa,  0.0 hi,  0.0 si,  0.=
0 st
%Cpu17 :  0.0 us,  0.0 sy,  0.0 ni,100.0 id,  0.0 wa,  0.0 hi,  0.0 si,  0.=
0 st
%Cpu18 :  0.0 us,  0.0 sy,  0.0 ni,100.0 id,  0.0 wa,  0.0 hi,  0.0 si,  0.=
0 st
%Cpu19 :  0.0 us,  0.0 sy,  0.0 ni,100.0 id,  0.0 wa,  0.0 hi,  0.0 si,  0.=
0 st
%Cpu20 :  0.0 us,  0.0 sy,  0.0 ni,100.0 id,  0.0 wa,  0.0 hi,  0.0 si,  0.=
0 st
%Cpu21 :  0.0 us,  0.0 sy,  0.0 ni,100.0 id,  0.0 wa,  0.0 hi,  0.0 si,  0.=
0 st
%Cpu22 :  0.0 us,  0.0 sy,  0.0 ni,100.0 id,  0.0 wa,  0.0 hi,  0.0 si,  0.=
0 st
%Cpu23 :  0.0 us,  0.0 sy,  0.0 ni,100.0 id,  0.0 wa,  0.0 hi,  0.0 si,  0.=
0 st
%Cpu24 :  0.0 us,  0.0 sy,  0.0 ni,100.0 id,  0.0 wa,  0.0 hi,  0.0 si,  0.=
0 st
%Cpu25 :  0.0 us,  0.0 sy,  0.0 ni,  0.0 id,100.0 wa,  0.0 hi,  0.0 si,  0.=
0 st
%Cpu26 :  0.0 us,  0.0 sy,  0.0 ni,100.0 id,  0.0 wa,  0.0 hi,  0.0 si,  0.=
0 st
%Cpu27 :  0.0 us,  0.0 sy,  0.0 ni,100.0 id,  0.0 wa,  0.0 hi,  0.0 si,  0.=
0 st
%Cpu28 :  0.0 us,  0.0 sy,  0.0 ni,100.0 id,  0.0 wa,  0.0 hi,  0.0 si,  0.=
0 st
%Cpu29 :  0.0 us,  0.0 sy,  0.0 ni,  0.0 id,100.0 wa,  0.0 hi,  0.0 si,  0.=
0 st
%Cpu30 :  0.0 us,  0.0 sy,  0.0 ni,100.0 id,  0.0 wa,  0.0 hi,  0.0 si,  0.=
0 st
%Cpu31 :  0.0 us,  0.0 sy,  0.0 ni,100.0 id,  0.0 wa,  0.0 hi,  0.0 si,  0.=
0 st
%Cpu32 :  0.0 us,  0.0 sy,  0.0 ni,  0.0 id,100.0 wa,  0.0 hi,  0.0 si,  0.=
0 st
%Cpu33 :  0.0 us,  0.0 sy,  0.0 ni,100.0 id,  0.0 wa,  0.0 hi,  0.0 si,  0.=
0 st
%Cpu34 :  0.0 us,  0.0 sy,  0.0 ni,100.0 id,  0.0 wa,  0.0 hi,  0.0 si,  0.=
0 st
%Cpu35 :  0.0 us,  0.0 sy,  0.0 ni,100.0 id,  0.0 wa,  0.0 hi,  0.0 si,  0.=
0 st
%Cpu36 :  0.0 us,  0.0 sy,  0.0 ni,100.0 id,  0.0 wa,  0.0 hi,  0.0 si,  0.=
0 st
%Cpu37 :  0.0 us,  0.0 sy,  0.0 ni,100.0 id,  0.0 wa,  0.0 hi,  0.0 si,  0.=
0 st
%Cpu38 :  0.0 us,  0.0 sy,  0.0 ni,100.0 id,  0.0 wa,  0.0 hi,  0.0 si,  0.=
0 st
%Cpu39 :  0.0 us,  0.0 sy,  0.0 ni,100.0 id,  0.0 wa,  0.0 hi,  0.0 si,  0.=
0 st
MiB Mem : 257590.5 total, 242751.4 free,  10355.7 used,   6092.0 buff/cache=
=20=20=20=20
MiB Swap:      0.0 total,      0.0 free,      0.0 used. 247234.8 avail Mem

When it's running with a < 6.1.53 Kernel we never see 100% wait states,
certainly not staining for a long time.

We also saw repeatedly:
[ 1376.837737] aacraid: Host adapter abort request.
               aacraid: Outstanding commands on (0,0,0,0):
[ 1376.841731] aacraid: Host adapter abort request.
               aacraid: Outstanding commands on (0,0,0,0):
[ 1376.842412] aacraid: Host adapter abort request.
               aacraid: Outstanding commands on (0,0,0,0):
[ 1376.843004] aacraid: Host adapter abort request.
               aacraid: Outstanding commands on (0,0,0,0):
[ 1376.843587] aacraid: Host adapter abort request.
               aacraid: Outstanding commands on (0,0,0,0):
[ 1376.844169] aacraid: Host adapter abort request.
               aacraid: Outstanding commands on (0,0,0,0):
[ 1376.844747] aacraid: Host adapter abort request.
               aacraid: Outstanding commands on (0,0,0,0):
[ 1376.845322] aacraid: Host adapter abort request.
               aacraid: Outstanding commands on (0,0,0,0):
[ 1376.845906] aacraid: Host adapter abort request.
               aacraid: Outstanding commands on (0,0,0,0):
[ 1376.846484] aacraid: Host adapter abort request.
               aacraid: Outstanding commands on (0,0,0,0):
[ 1376.847055] aacraid: Host adapter abort request.
               aacraid: Outstanding commands on (0,0,0,0):
[ 1376.847628] aacraid: Host adapter abort request.
               aacraid: Outstanding commands on (0,0,0,0):
[ 1376.848199] aacraid: Host adapter abort request.
               aacraid: Outstanding commands on (0,0,0,0):
[ 1376.848767] aacraid: Host adapter abort request.
               aacraid: Outstanding commands on (0,0,0,0):
[ 1376.849336] aacraid: Host adapter abort request.
               aacraid: Outstanding commands on (0,0,0,0):
[ 1376.849995] aacraid: Host adapter abort request.
               aacraid: Outstanding commands on (0,0,0,0):
[ 1376.850560] aacraid: Host adapter abort request.
               aacraid: Outstanding commands on (0,0,0,0):
[ 1378.789765] aacraid: Host adapter abort request.
               aacraid: Outstanding commands on (0,0,0,0):
[ 1378.889767] aacraid: Host adapter abort request.
               aacraid: Outstanding commands on (0,0,0,0):
[ 1378.890899] aacraid: Host adapter abort request.
               aacraid: Outstanding commands on (0,0,0,0):
[ 1378.892002] aacraid: Host adapter abort request.
               aacraid: Outstanding commands on (0,0,0,0):
[ 1378.893103] aacraid: Host adapter abort request.
               aacraid: Outstanding commands on (0,0,0,0):
[ 1378.897790] aacraid: Host adapter abort request.
               aacraid: Outstanding commands on (0,0,0,0):
[ 1378.898918] aacraid: Host adapter abort request.
               aacraid: Outstanding commands on (0,0,0,0):
[ 1378.900009] aacraid: Host adapter abort request.
               aacraid: Outstanding commands on (0,0,0,0):
[ 1378.901094] aacraid: Host adapter abort request.
               aacraid: Outstanding commands on (0,0,0,0):
[ 1378.902199] aacraid: Host adapter abort request.
               aacraid: Outstanding commands on (0,0,0,0):
[ 1378.903287] aacraid: Host adapter abort request.
               aacraid: Outstanding commands on (0,0,0,0):
[ 1378.904384] aacraid: Host adapter abort request.
               aacraid: Outstanding commands on (0,0,0,0):
[ 1378.905472] aacraid: Host adapter abort request.
               aacraid: Outstanding commands on (0,0,0,0):
[ 1378.906585] aacraid: Host adapter abort request.
               aacraid: Outstanding commands on (0,0,0,0):
[ 1378.907678] aacraid: Host adapter abort request.
               aacraid: Outstanding commands on (0,0,0,0):
[ 1378.945954] aacraid: Host bus reset request. SCSI hang ?
[ 1378.946602] aacraid 0000:af:00.0: outstanding cmd: midlevel-0
[ 1378.946607] aacraid 0000:af:00.0: outstanding cmd: lowlevel-0
[ 1378.946610] aacraid 0000:af:00.0: outstanding cmd: error handler-0
[ 1378.946613] aacraid 0000:af:00.0: outstanding cmd: firmware-32
[ 1378.946616] aacraid 0000:af:00.0: outstanding cmd: kernel-0
[ 1378.961850] aacraid 0000:af:00.0: Controller reset type is 3
[ 1378.962435] aacraid 0000:af:00.0: Issuing IOP reset
[ 1412.498211] aacraid 0000:af:00.0: IOP reset succeeded
[ 1412.523256] aacraid: Comm Interface type2 enabled
[ 1424.734176] aacraid 0000:af:00.0: Scheduling bus rescan
[ 1434.755589] aacraid 0000:af:00.0: DDR cache data recovered successfully

On another server that has an Adaptec ASR8405 raid controller running exact=
ly
the same Distribution and kernel we don't see this issue at all.

The only major difference is that the system that has the problem has two
sockets i.e. CPUs.
This one also has SSD drives, but I don't think this could be an issue?

We have found out that this issue exists since Kernel 6.1.53.=20
We found that Kernel 6.1.53 incorporated this patch:=20
scsi: aacraid: Reply queue mapping to CPUs based on IRQ affinity

https://www.spinics.net/lists/stable-commits/msg313381.html

I think that this ticket is related to this issue.
https://bugzilla.kernel.org/show_bug.cgi?id=3D217599

and this email/link
https://lore.kernel.org/regressions/4a639fff-445e-455b-9a31-57368d6b7021@le=
emhuis.info/

We have tested Kernel 6.1.55 like the one in Debian Bookworm with the
above-mentioned patch reverted. It worked flawlessly.

Might it be related to multiple CPU sockets i.e. CPUs. As we don't have an
issue on a single Socket system.

Both systems have an Intel Xeon CPU(s).

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=
