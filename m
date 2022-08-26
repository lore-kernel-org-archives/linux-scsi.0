Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9914BECAAA3
	for <linux-scsi@archiver.kernel.org>; Fri, 26 Aug 2022 07:00:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245130AbiHZHAv (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 26 Aug 2022 03:00:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44328 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245036AbiHZHAi (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 26 Aug 2022 03:00:38 -0400
Received: from esa1.hgst.iphmx.com (esa1.hgst.iphmx.com [68.232.141.245])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5D257C22A8
        for <linux-scsi@vger.kernel.org>; Fri, 26 Aug 2022 00:00:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1661497233; x=1693033233;
  h=message-id:date:mime-version:subject:to:references:from:
   in-reply-to:content-transfer-encoding;
  bh=Bymjw7s5DRQN65wfSlJcztt69mkzVnJm/9thMg1fI9o=;
  b=IZtbETPS96a2RABhfBEzeWiCi1NCIrajse4mvT5nA1WaHd+wOhEWfUqD
   a7Y+hV0BJfsp9BFx1/vNwIMrxGvidzb6vsIsmN9aHMPKnlqrnWx5dpg5w
   dGAyeR8H2i3O5UfJD+DJJW1Mr5ycr7z28lYA0RrQbIg/DdgDRS1F8dhYG
   u8rnRwNWBtZTBHhNIB6c+f+2ZCBpBS7pRuFGsI71eIrDsdqZV5zU3zIy6
   MUEeszuapJ3BVIM8QGHsiIJQeubnQfWugPtmQT+bKkq+1xd511ZITNi9Q
   hg7ibYW4RBtOhl0KPe1C0U0xD0Eh4aQ80ay9nV9IPOhMemHgCVvaQHFsU
   A==;
X-IronPort-AV: E=Sophos;i="5.93,264,1654531200"; 
   d="scan'208";a="321820312"
Received: from uls-op-cesaip02.wdc.com (HELO uls-op-cesaep02.wdc.com) ([199.255.45.15])
  by ob1.hgst.iphmx.com with ESMTP; 26 Aug 2022 15:00:31 +0800
IronPort-SDR: 0Q0Ys591Phh/eV0YwTsAdwYiPkVHcqb8pCPwwZhbMubpDmTS7gVtavjdnujGIBiPVSJyGkdw2f
 Wgy4R3VjhKQvNM/Z6qxrsKqwQz8YmHCzBhQ6fyc6D3hNsyqRG64qkqsIaBosoyQIIlYwq8/qge
 9KazXau3wqETW2ND9GOtYGymcBlppan8YxhMA/A6p1ZrVROF8+uGVK0o5CV0my6C3IrUz3Vjeq
 qvcpm//bizxq2ebr7oS+IKiJprFGTHNWRVwGt8oz+jQFnUwSvYsrbJvuBeRO+iAGywgSSMEKUL
 5i/m6+l02vgQ8PTzZQLrkAmc
Received: from uls-op-cesaip01.wdc.com ([10.248.3.36])
  by uls-op-cesaep02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 25 Aug 2022 23:15:43 -0700
IronPort-SDR: TynHGyJagiRIYyz72vYb5BiymWfe0pFu8TjAJGqdFmAH9LisOM1Zozc7mh71xaGjHWQZqoq9HH
 1uxR+UzsBlshAgNj4PolqtwsBFFJ8Ftpi0siN+KfHn5yVr7x2IVl0+zu65w4T2pqRLjFGFUkwt
 Gf4pK8ysWGnQlltcJXvNyP5ZlI32NumhA6iFjErz/Pnqc6xnjDNvdMcROtLUDR0G/nZBCLRX8K
 LrCQokquv4gC9VdjMcRTkk7BAOcsrfQlToSua3dGUx+BAkIfE7OIrVpMNt5ZkZ64L64nZ1TwW7
 0q4=
WDCIronportException: Internal
Received: from usg-ed-osssrv.wdc.com ([10.3.10.180])
  by uls-op-cesaip01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 26 Aug 2022 00:00:31 -0700
Received: from usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTP id 4MDW1n5JBVz1Rwnl
        for <linux-scsi@vger.kernel.org>; Fri, 26 Aug 2022 00:00:29 -0700 (PDT)
Authentication-Results: usg-ed-osssrv.wdc.com (amavisd-new); dkim=pass
        reason="pass (just generated, assumed good)"
        header.d=opensource.wdc.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=
        opensource.wdc.com; h=content-transfer-encoding:content-type
        :in-reply-to:organization:from:references:to:content-language
        :subject:user-agent:mime-version:date:message-id; s=dkim; t=
        1661497229; x=1664089230; bh=Bymjw7s5DRQN65wfSlJcztt69mkzVnJm/9t
        hMg1fI9o=; b=Jr7X9BpPIiHZ/BQTJWZbDlqkK0mOFurs9Dv5J88Kbate6zvXMtY
        rtrQSXPek75WsMsjUqTvN6RtECMXlHpG5YhwqlKySLE2NzsXWOmrRn3DzMwtsjGu
        tK8/BzTNVvHVjSsxNopd7OjS1wgFpwr5NXL4zTgeMRXsWLkChcPG6vMiQ6rqZjpS
        2jkbEv3q6qdfZQovNEJIc/LY8fJKrI3t46Q0lpUFAESJnBWND0IBTfOneGWdI0IQ
        F4NipGmLKTEmhu3LxsePSBptPOsIQrSwsFc0R8EPK8/svgBRd27nANVwGMe8LzGZ
        AXvr7ttqr+Rv5MG3R6NLCNun9RgZj9/NnzQ==
X-Virus-Scanned: amavisd-new at usg-ed-osssrv.wdc.com
Received: from usg-ed-osssrv.wdc.com ([127.0.0.1])
        by usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id fZFn5K4an8kS for <linux-scsi@vger.kernel.org>;
        Fri, 26 Aug 2022 00:00:29 -0700 (PDT)
Received: from [10.225.163.46] (unknown [10.225.163.46])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTPSA id 4MDW1m5Bv6z1RtVk;
        Fri, 26 Aug 2022 00:00:28 -0700 (PDT)
Message-ID: <f4c15945-44ff-551c-a46c-3c16ff9ee456@opensource.wdc.com>
Date:   Fri, 26 Aug 2022 16:00:27 +0900
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.12.0
Subject: Re: [Bug 215880] Resume process hangs for 5-6 seconds starting
 sometime in 5.16
Content-Language: en-US
To:     bugzilla-daemon@kernel.org, linux-scsi@vger.kernel.org
References: <bug-215880-11613@https.bugzilla.kernel.org/>
 <bug-215880-11613-KbhwEWfVXy@https.bugzilla.kernel.org/>
From:   Damien Le Moal <damien.lemoal@opensource.wdc.com>
Organization: Western Digital Research
In-Reply-To: <bug-215880-11613-KbhwEWfVXy@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 8/26/22 07:15, bugzilla-daemon@kernel.org wrote:
> https://bugzilla.kernel.org/show_bug.cgi?id=215880
> 
> --- Comment #38 from damien.lemoal@opensource.wdc.com ---
> On 8/26/22 05:31, bugzilla-daemon@kernel.org wrote:
>> https://bugzilla.kernel.org/show_bug.cgi?id=215880
>>
>> --- Comment #37 from Bart Van Assche (bvanassche@acm.org) ---
>> On 8/25/22 13:01, bugzilla-daemon@kernel.org wrote:
>>> https://bugzilla.kernel.org/show_bug.cgi?id=215880
>>>
>>> --- Comment #36 from jason600 (jason600.groome@gmail.com) ---
>>> (In reply to Bart Van Assche from comment #27)
>>>> Thanks for testing! The patches from the sd-resume branch have been posted
>>>> on the linux-scsi mailing list. See also
>>>>
>>>>
>>>> https://lore.kernel.org/linux-scsi/20220628222131.14780-1-bvanassche@acm.org/
>>>> T/#t
>>>
>>> Hi Bart, just an update for you. I noticed this had been removed from the
>>> 6.0-rc1 for freezing after suspend.
>>>
>>> I've been compiling my kernel with this fix on various 5.18 kernels (with
>>> opensuse tumbleweed), it has worked fine, no freezing on resume as others
>>> have
>>> mentioned.
>>>
>>> Yesterday, I updated to 5.19.2 kernel, applied the fix, recompiled, and it
>>> froze after the first suspend. Rebooted and the same thing happened again. I
>>> recompiled the kernel with the fix, just to make sure i didn't mess it up,
>>> and
>>> the same happened again.
>>>
>>> When you originally did this fix, you based it on 5.18, and indeed, it works
>>> fine on 5.18 for me. There were a lot of changes to the drivers/scsi/sd.c
>>> file
>>> for 5.19, presumably it was those changes that made this fix start freezing
>>> after suspend.
>>>
>>> Perhaps you could check if the other people that experienced freezing were
>>> using either 5.19 or 6.0-rc1.
>>
>> Multiple people reported issues with freezes during suspend with kernel 
>> v6.0-rc1. Please take a look at the following report: 
>> https://lore.kernel.org/all/dd6844e7-f338-a4e9-2dad-0960e25b2ca1@redhat.com/. 
>> It shows that if zoned ATA disks are present that blk_mq_freeze_queue() 
>> may be called from inside ata_scsi_dev_rescan() on the context of a work 
>> queue. ATA rescanning happens from inside the SCSI error handler. So 
>> there is potential for a lockup because of the following:
>> * Execution of the START command being postponed because the SCSI error 
>> handler is active.
>> * blk_mq_freeze_queue() waiting for the START command to finish.
>> * The START completion handler not being executed because it got queued 
>> on the same work queue as the ATA rescan work.

Checking the code, the dev pm resume call chain for ATA look like this.

ata_port_resume() -> ata_port_request_pm() -> ata_port_schedule_eh() ->
scsi_error_handler() thread runs -> shost->transportt->eh_strategy_handler
== ata_scsi_error() -> ata_scsi_port_error_handler() ->
ata_eh_handle_port_resume() -> ap->ops->port_resume() ==
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
 		sdev->sector_size = ata_id_logical_sector_size(dev->id);
 		sdev->manage_start_stop = 1;
+		sdev->no_start_on_resume = 1;
 	}

 	/*
diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index 8f79fa6318fe..4c28ca4d038b 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -3761,7 +3761,7 @@ static int sd_suspend_runtime(struct device *dev)
 static int sd_resume(struct device *dev)
 {
 	struct scsi_disk *sdkp = dev_get_drvdata(dev);
-	int ret;
+	int ret = 0;

 	if (!sdkp)	/* E.g.: runtime resume at the start of sd_probe() */
 		return 0;
@@ -3770,7 +3770,8 @@ static int sd_resume(struct device *dev)
 		return 0;

 	sd_printk(KERN_NOTICE, sdkp, "Starting disk\n");
-	ret = sd_start_stop_device(sdkp, 1);
+	if (!sdkp->device->no_start_on_resume)
+		ret = sd_start_stop_device(sdkp, 1);
 	if (!ret)
 		opal_unlock_from_suspend(sdkp->opal_dev);
 	return ret;
diff --git a/include/scsi/scsi_device.h b/include/scsi/scsi_device.h
index 3113471ca375..92e141536c6c 100644
--- a/include/scsi/scsi_device.h
+++ b/include/scsi/scsi_device.h
@@ -192,6 +192,7 @@ struct scsi_device {
 	unsigned no_start_on_add:1;	/* do not issue start on add */
 	unsigned allow_restart:1; /* issue START_UNIT in error handler */
 	unsigned manage_start_stop:1;	/* Let HLD (sd) manage start/stop */
+	unsigned no_start_on_resume:1; /* Do not issue START_STOP_UNIT on resume */
 	unsigned start_stop_pwr_cond:1;	/* Set power cond. in START_STOP_UNIT */
 	unsigned no_uld_attach:1; /* disable connecting to upper level drivers */
 	unsigned select_no_atn:1;

I am not sure at all this is correct though. This actually may break other
suspend/resume flavors. If we could somehow synchronize scsi pm resume to
run *after* ata pm resume, all problems should go away I think.


-- 
Damien Le Moal
Western Digital Research
