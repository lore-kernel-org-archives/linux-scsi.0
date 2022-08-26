Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 20EABECAAD2
	for <linux-scsi@archiver.kernel.org>; Fri, 26 Aug 2022 07:01:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244935AbiHZHBV (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 26 Aug 2022 03:01:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45654 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244978AbiHZHAx (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 26 Aug 2022 03:00:53 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4EC15CD7A2
        for <linux-scsi@vger.kernel.org>; Fri, 26 Aug 2022 00:00:42 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id BB57CCE2E34
        for <linux-scsi@vger.kernel.org>; Fri, 26 Aug 2022 07:00:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 129ADC43148
        for <linux-scsi@vger.kernel.org>; Fri, 26 Aug 2022 07:00:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1661497239;
        bh=iqkllj6q7EVP/HvcAp/NVNV11je429V6TXIQpPfIHqg=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=Mjc+JQ7acYvEwzgzERPR7axfYL7Ce8Cn0UAaKljdGolF4aJHANVZE5OE0b4VuqSIV
         qr/HcdSqx8h9M47gu9doEUIA84ZTV5XlG21I6PqwJtyEwDCRLlZVi0D4ClKf5F4Qtz
         hYg0lPnudu8EO5KH62WQYzosXfolQCTvk5vuWLoiAmT/tb61vSeCJbbThEBqz8PnCN
         W00GIveFFyjjl2tslcpTyx1u00UuYf4qJok62J7ISlu9rxCpdhjB8mKJoR1Pu70Dne
         UiPMwuAj2jtg0njX3o967ccP4Uuu1eu/3lt+hEVBlVceCcrJzL3+sHaCHm04r0WLTf
         BcxecLOx6KqNg==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
        id 03B81C433EA; Fri, 26 Aug 2022 07:00:39 +0000 (UTC)
From:   bugzilla-daemon@kernel.org
To:     linux-scsi@vger.kernel.org
Subject: [Bug 215880] Resume process hangs for 5-6 seconds starting sometime
 in 5.16
Date:   Fri, 26 Aug 2022 07:00:38 +0000
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
Message-ID: <bug-215880-11613-KMetxdJz9f@https.bugzilla.kernel.org/>
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

--- Comment #39 from damien.lemoal@opensource.wdc.com ---
On 8/26/22 07:15, bugzilla-daemon@kernel.org wrote:
> https://bugzilla.kernel.org/show_bug.cgi?id=3D215880
>=20
> --- Comment #38 from damien.lemoal@opensource.wdc.com ---
> On 8/26/22 05:31, bugzilla-daemon@kernel.org wrote:
>> https://bugzilla.kernel.org/show_bug.cgi?id=3D215880
>>
>> --- Comment #37 from Bart Van Assche (bvanassche@acm.org) ---
>> On 8/25/22 13:01, bugzilla-daemon@kernel.org wrote:
>>> https://bugzilla.kernel.org/show_bug.cgi?id=3D215880
>>>
>>> --- Comment #36 from jason600 (jason600.groome@gmail.com) ---
>>> (In reply to Bart Van Assche from comment #27)
>>>> Thanks for testing! The patches from the sd-resume branch have been po=
sted
>>>> on the linux-scsi mailing list. See also
>>>>
>>>>
>>>>
>>>> https://lore.kernel.org/linux-scsi/20220628222131.14780-1-bvanassche@a=
cm.org/
>>>> T/#t
>>>
>>> Hi Bart, just an update for you. I noticed this had been removed from t=
he
>>> 6.0-rc1 for freezing after suspend.
>>>
>>> I've been compiling my kernel with this fix on various 5.18 kernels (wi=
th
>>> opensuse tumbleweed), it has worked fine, no freezing on resume as othe=
rs
>>> have
>>> mentioned.
>>>
>>> Yesterday, I updated to 5.19.2 kernel, applied the fix, recompiled, and=
 it
>>> froze after the first suspend. Rebooted and the same thing happened aga=
in.
>>> I
>>> recompiled the kernel with the fix, just to make sure i didn't mess it =
up,
>>> and
>>> the same happened again.
>>>
>>> When you originally did this fix, you based it on 5.18, and indeed, it
>>> works
>>> fine on 5.18 for me. There were a lot of changes to the drivers/scsi/sd=
.c
>>> file
>>> for 5.19, presumably it was those changes that made this fix start free=
zing
>>> after suspend.
>>>
>>> Perhaps you could check if the other people that experienced freezing w=
ere
>>> using either 5.19 or 6.0-rc1.
>>
>> Multiple people reported issues with freezes during suspend with kernel=
=20
>> v6.0-rc1. Please take a look at the following report:=20
>>
>> https://lore.kernel.org/all/dd6844e7-f338-a4e9-2dad-0960e25b2ca1@redhat.=
com/.=20
>> It shows that if zoned ATA disks are present that blk_mq_freeze_queue()=
=20
>> may be called from inside ata_scsi_dev_rescan() on the context of a work=
=20
>> queue. ATA rescanning happens from inside the SCSI error handler. So=20
>> there is potential for a lockup because of the following:
>> * Execution of the START command being postponed because the SCSI error=
=20
>> handler is active.
>> * blk_mq_freeze_queue() waiting for the START command to finish.
>> * The START completion handler not being executed because it got queued=
=20
>> on the same work queue as the ATA rescan work.

Checking the code, the dev pm resume call chain for ATA look like this.

ata_port_resume() -> ata_port_request_pm() -> ata_port_schedule_eh() ->
scsi_error_handler() thread runs -> shost->transportt->eh_strategy_handler
=3D=3D ata_scsi_error() -> ata_scsi_port_error_handler() ->
ata_eh_handle_port_resume() -> ap->ops->port_resume() =3D=3D
ahci_port_resume() for AHCI adapters.

There are no commands issued to the device by this chain, only
registers/port settings being changed. So this should always complete
quickly and in itself not be the reason for the START_STOP command issued
by the sd driver to get stuck.

After calling ata_eh_handle_port_resume(), ata_scsi_port_error_handler()
will trigger a reset through ata_std_error_handler() -> ata_do_eh() and
that will cause the device rescan in EH context. Device rescan will
definitely spin up the device so the START_STOP command that sd_resume()
issues seems rather useless...

As a hack, it would be good to try something like this:

diff --git a/drivers/ata/libata-scsi.c b/drivers/ata/libata-scsi.c
index 29e2f55c6faa..1bc92c04f048 100644
--- a/drivers/ata/libata-scsi.c
+++ b/drivers/ata/libata-scsi.c
@@ -1081,6 +1081,7 @@ int ata_scsi_dev_config(struct scsi_device *sdev,
struct ata_device *dev)
        } else {
                sdev->sector_size =3D ata_id_logical_sector_size(dev->id);
                sdev->manage_start_stop =3D 1;
+               sdev->no_start_on_resume =3D 1;
        }

        /*
diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index 8f79fa6318fe..4c28ca4d038b 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -3761,7 +3761,7 @@ static int sd_suspend_runtime(struct device *dev)
 static int sd_resume(struct device *dev)
 {
        struct scsi_disk *sdkp =3D dev_get_drvdata(dev);
-       int ret;
+       int ret =3D 0;

        if (!sdkp)      /* E.g.: runtime resume at the start of sd_probe() =
*/
                return 0;
@@ -3770,7 +3770,8 @@ static int sd_resume(struct device *dev)
                return 0;

        sd_printk(KERN_NOTICE, sdkp, "Starting disk\n");
-       ret =3D sd_start_stop_device(sdkp, 1);
+       if (!sdkp->device->no_start_on_resume)
+               ret =3D sd_start_stop_device(sdkp, 1);
        if (!ret)
                opal_unlock_from_suspend(sdkp->opal_dev);
        return ret;
diff --git a/include/scsi/scsi_device.h b/include/scsi/scsi_device.h
index 3113471ca375..92e141536c6c 100644
--- a/include/scsi/scsi_device.h
+++ b/include/scsi/scsi_device.h
@@ -192,6 +192,7 @@ struct scsi_device {
        unsigned no_start_on_add:1;     /* do not issue start on add */
        unsigned allow_restart:1; /* issue START_UNIT in error handler */
        unsigned manage_start_stop:1;   /* Let HLD (sd) manage start/stop */
+       unsigned no_start_on_resume:1; /* Do not issue START_STOP_UNIT on
resume */
        unsigned start_stop_pwr_cond:1; /* Set power cond. in START_STOP_UN=
IT
*/
        unsigned no_uld_attach:1; /* disable connecting to upper level driv=
ers
*/
        unsigned select_no_atn:1;

I am not sure at all this is correct though. This actually may break other
suspend/resume flavors. If we could somehow synchronize scsi pm resume to
run *after* ata pm resume, all problems should go away I think.

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=
