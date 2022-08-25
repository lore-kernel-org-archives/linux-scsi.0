Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A3BB7ECAAA3
	for <linux-scsi@archiver.kernel.org>; Thu, 25 Aug 2022 22:15:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232671AbiHYWPp (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 25 Aug 2022 18:15:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49554 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230308AbiHYWPo (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 25 Aug 2022 18:15:44 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 115BF5D0CB
        for <linux-scsi@vger.kernel.org>; Thu, 25 Aug 2022 15:15:43 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A1AD761CAC
        for <linux-scsi@vger.kernel.org>; Thu, 25 Aug 2022 22:15:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 12F23C43147
        for <linux-scsi@vger.kernel.org>; Thu, 25 Aug 2022 22:15:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1661465742;
        bh=E4Nww5KNxuOcIBwE0j3eM9OjgA4T22vmWv5mLMkbxso=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=WVfWEFCbv+PYQgExFViVwm1eWzCXHYPopgE/6CQgpbgKI08UQ0OwyRDO7s4fsybtJ
         +Kkajej3iEu6WloCQZ7KcE6rq2EuJFahqyDzhptp7zgSNBlZedEE94hA7z/HadbBZt
         Pl1Y9Z6LuB905LIiMpxmqQmaRgW1+5jzsMBZhMeWUNaV2P3jZFrY9CUhp6hluL3We/
         Y8ZmuKmQ3Up/bsCLHQySRVdBuqG77MuMZSem8TnVW5ONppCLUjPkwa1OvbZ2RSM/G/
         1w+Zzhfo+p1VTc+Bu7aCIFl0aPidniM8KfCRywrY0ojRuBUhmEqMBH8ihCv3tD2oEK
         c7uf1wwH7fuGg==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
        id 02FD7C0422E; Thu, 25 Aug 2022 22:15:42 +0000 (UTC)
From:   bugzilla-daemon@kernel.org
To:     linux-scsi@vger.kernel.org
Subject: [Bug 215880] Resume process hangs for 5-6 seconds starting sometime
 in 5.16
Date:   Thu, 25 Aug 2022 22:15:41 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo scsi_drivers-other@kernel-bugs.osdl.org
X-Bugzilla-Product: SCSI Drivers
X-Bugzilla-Component: Other
X-Bugzilla-Version: 2.5
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: normal
X-Bugzilla-Who: damien.lemoal@opensource.wdc.com
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P1
X-Bugzilla-Assigned-To: scsi_drivers-other@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: 
Message-ID: <bug-215880-11613-KbhwEWfVXy@https.bugzilla.kernel.org/>
In-Reply-To: <bug-215880-11613@https.bugzilla.kernel.org/>
References: <bug-215880-11613@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Bugzilla-URL: https://bugzilla.kernel.org/
Auto-Submitted: auto-generated
MIME-Version: 1.0
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=3D215880

--- Comment #38 from damien.lemoal@opensource.wdc.com ---
On 8/26/22 05:31, bugzilla-daemon@kernel.org wrote:
> https://bugzilla.kernel.org/show_bug.cgi?id=3D215880
>=20
> --- Comment #37 from Bart Van Assche (bvanassche@acm.org) ---
> On 8/25/22 13:01, bugzilla-daemon@kernel.org wrote:
>> https://bugzilla.kernel.org/show_bug.cgi?id=3D215880
>>
>> --- Comment #36 from jason600 (jason600.groome@gmail.com) ---
>> (In reply to Bart Van Assche from comment #27)
>>> Thanks for testing! The patches from the sd-resume branch have been pos=
ted
>>> on the linux-scsi mailing list. See also
>>>
>>>
>>> https://lore.kernel.org/linux-scsi/20220628222131.14780-1-bvanassche@ac=
m.org/
>>> T/#t
>>
>> Hi Bart, just an update for you. I noticed this had been removed from the
>> 6.0-rc1 for freezing after suspend.
>>
>> I've been compiling my kernel with this fix on various 5.18 kernels (with
>> opensuse tumbleweed), it has worked fine, no freezing on resume as others
>> have
>> mentioned.
>>
>> Yesterday, I updated to 5.19.2 kernel, applied the fix, recompiled, and =
it
>> froze after the first suspend. Rebooted and the same thing happened agai=
n. I
>> recompiled the kernel with the fix, just to make sure i didn't mess it u=
p,
>> and
>> the same happened again.
>>
>> When you originally did this fix, you based it on 5.18, and indeed, it w=
orks
>> fine on 5.18 for me. There were a lot of changes to the drivers/scsi/sd.c
>> file
>> for 5.19, presumably it was those changes that made this fix start freez=
ing
>> after suspend.
>>
>> Perhaps you could check if the other people that experienced freezing we=
re
>> using either 5.19 or 6.0-rc1.
>=20
> Multiple people reported issues with freezes during suspend with kernel=20
> v6.0-rc1. Please take a look at the following report:=20
> https://lore.kernel.org/all/dd6844e7-f338-a4e9-2dad-0960e25b2ca1@redhat.c=
om/.=20
> It shows that if zoned ATA disks are present that blk_mq_freeze_queue()=20
> may be called from inside ata_scsi_dev_rescan() on the context of a work=
=20
> queue. ATA rescanning happens from inside the SCSI error handler. So=20
> there is potential for a lockup because of the following:
> * Execution of the START command being postponed because the SCSI error=20
> handler is active.
> * blk_mq_freeze_queue() waiting for the START command to finish.
> * The START completion handler not being executed because it got queued=20
> on the same work queue as the ATA rescan work.
>=20
> Unfortunately I do not know enough about the ATA core to proceed. I need=
=20
> help from an ATA expert.

I will have a look today.

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=
