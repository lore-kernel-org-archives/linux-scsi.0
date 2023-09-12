Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4A0F0CA0ECA
	for <linux-scsi@archiver.kernel.org>; Tue, 12 Sep 2023 06:13:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229461AbjILGNi (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 12 Sep 2023 02:13:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38776 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229703AbjILGNh (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 12 Sep 2023 02:13:37 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 61F8AE7A;
        Mon, 11 Sep 2023 23:13:33 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F3B9BC433C8;
        Tue, 12 Sep 2023 06:13:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1694499213;
        bh=rGDXoUj19sOg4nTlCS7fV5QpXUfu/FDzl8p0wl2lY1Y=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=QHNIk7YOHnaEY0DrYuk/07uDhdGX3aPofjB3wUNpK28LAgm2gB35s8NHo3GVROOlk
         QJQZ+NpTCdNMlP7orXYnTWn1iDxUUXCSsV5x9VNmHm+YDSNrh9+DVBbI5Y69yolHaC
         9DaLhSVoyUbFiRiC6cukeOs8koXj7ytkHeFOk5nK5qRj2q32GtpacEQLF2M5/8Zvv/
         DhO/JgVCvrnR1blbvGhQ3WgEWlsT9iDyJLPTeabKToCA7/Sm3U9QCHTtwZu16WCrGo
         r/8j1Em8Gq0Rr3TNXpAYYLyCePIy7Pb3dm+YrguLLoJsuYGahdLwAS7m1khykjxgot
         Eoc8AjB45MEVg==
Message-ID: <b3af36cd-a126-24ac-739c-5d1a192c2b2b@kernel.org>
Date:   Tue, 12 Sep 2023 15:13:30 +0900
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.13.0
Subject: Re: [PATCH 03/19] ata: libata-scsi: link ata port and scsi device
Content-Language: en-US
To:     John Garry <john.g.garry@oracle.com>,
        Hannes Reinecke <hare@suse.de>, linux-ide@vger.kernel.org
Cc:     linux-scsi@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Rodrigo Vivi <rodrigo.vivi@intel.com>,
        Paul Ausbeck <paula@soe.ucsc.edu>,
        Kai-Heng Feng <kai.heng.feng@canonical.com>,
        Joe Breuer <linux-kernel@jmbreuer.net>
References: <20230911040217.253905-1-dlemoal@kernel.org>
 <20230911040217.253905-4-dlemoal@kernel.org>
 <e8ca70d1-9c88-4a80-83e4-a65f4bbe6b72@suse.de>
 <8874a3d5-355e-c354-fd85-0dfa7ab77b54@kernel.org>
 <5825b4b9-0bc8-4c27-d576-070c7113e1f8@oracle.com>
 <f56e4e80-1905-0dcd-fb59-aaba7a9f8adb@kernel.org>
 <764fa7a6-109f-0ea5-5d25-3e39874e9c8a@oracle.com>
From:   Damien Le Moal <dlemoal@kernel.org>
Organization: Western Digital Research
In-Reply-To: <764fa7a6-109f-0ea5-5d25-3e39874e9c8a@oracle.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 9/12/23 00:15, John Garry wrote:
> On 11/09/2023 12:48, Damien Le Moal wrote:
>>> For hisi_sas v3, RPM is supported and a link was required to be added in
>>> that driver between the sdev and those host controller device - see
>>> 16fd4a7c59. And that is for a similar reason here. I see that we already
>>> have an ancestry for libata between ata_dev -> ata_link -> ata_port ->
>>> ata_host dev, so it seems reasonable to add ata_dev  <-> sdev dependency
>>> here.
>> libata creates a link between ata_port and sdev. This is not very natural, but
>> as I said in the cover letter, the power management model is weird as everything
>> is per port, even if a port has multiple devices. Nevertheless, I tried to apply
>> the same for libsas but failed: if I add the link creation in the slave_alloc
>> method, I fail to get the scsi disks to show up (no /dev/sdX device files). Not
>> sure why. That was with my pm8001 adapter, which is the only libsas one I have.
>>
>> Side note: having an ata_debug (ata equivalent of scsi_debug) driver that could
>> act as a pure libata driver or as a libsas adapter would really be awesome for
>> this kind of tests 😄
> 
> hmm... maybe scsi_debug could be modified to support ATA devices (with 
> libata).
> 
> Regardless, I'm happy to check the code change which you attempted if 
> shared.

I had a closer look at what the hisi_sas driver is doing. The link it creates
with device_add_link() is between the scsi device gendev and the hisi_hba->dev,
that is, the HBA device. So nothing to do with libata port of device.

Trying to mimic what libata is now doing, I tried this:

diff --git a/drivers/scsi/libsas/sas_ata.c b/drivers/scsi/libsas/sas_ata.c
index 12e2653846e3..91d76258e6ea 100644
--- a/drivers/scsi/libsas/sas_ata.c
+++ b/drivers/scsi/libsas/sas_ata.c
@@ -624,6 +624,26 @@ int sas_ata_init(struct domain_device *found_dev)
        return rc;
 }

+int sas_ata_slave_configure(struct scsi_device *sdev)
+{
+       struct domain_device *dev = sdev_to_domain_dev(sdev);
+       struct ata_port *ap = dev->sata_dev.ap;
+       struct device *sdev_dev = &sdev->sdev_gendev;
+       struct device_link *link;
+
+       ata_sas_slave_configure(sdev, ap);
+
+       link = device_link_add(sdev_dev, &ap->tdev,
+                              DL_FLAG_PM_RUNTIME | DL_FLAG_RPM_ACTIVE);
+       if (!link && pm_runtime_enabled(sdev_dev)) {
+               dev_err(sdev_dev,
+                       "add device link failed, disabling runtime PM for the
host\n");
+               pm_runtime_disable(sdev_dev);
+       }
+
+       return 0;
+}
+
 void sas_ata_task_abort(struct sas_task *task)
 {
        struct ata_queued_cmd *qc = task->uldd_task;
diff --git a/drivers/scsi/libsas/sas_internal.h b/drivers/scsi/libsas/sas_internal.h
index a6dc7dc07fce..82c6d8e1e8c7 100644
--- a/drivers/scsi/libsas/sas_internal.h
+++ b/drivers/scsi/libsas/sas_internal.h
@@ -58,6 +58,8 @@ void sas_enable_revalidation(struct sas_ha_struct *ha);
 void sas_queue_deferred_work(struct sas_ha_struct *ha);
 void __sas_drain_work(struct sas_ha_struct *ha);

+int sas_ata_slave_configure(struct scsi_device *sdev);
+
 void sas_deform_port(struct asd_sas_phy *phy, int gone);

 void sas_porte_bytes_dmaed(struct work_struct *work);
diff --git a/drivers/scsi/libsas/sas_scsi_host.c
b/drivers/scsi/libsas/sas_scsi_host.c
index 9047cfcd1072..b6c419aa563e 100644
--- a/drivers/scsi/libsas/sas_scsi_host.c
+++ b/drivers/scsi/libsas/sas_scsi_host.c
@@ -810,10 +810,8 @@ int sas_slave_configure(struct scsi_device *scsi_dev)

        BUG_ON(dev->rphy->identify.device_type != SAS_END_DEVICE);

-       if (dev_is_sata(dev)) {
-               ata_sas_slave_configure(scsi_dev, dev->sata_dev.ap);
-               return 0;
-       }
+       if (dev_is_sata(dev))
+               return sas_ata_slave_configure(scsi_dev);

        sas_read_port_mode_page(scsi_dev);

This does not change the drive discovery, all drives connected to the HBA are
found and identified:

[   52.974154] scsi host12: pm80xx
[   54.445986] sas: phy-12:4 added to port-12:0, phy_mask:0x10 (50010860002f5644)
[   54.449019] sas: DOING DISCOVERY on port 0, pid:423
[   54.461108] sas: Enter sas_scsi_recover_host busy: 0 failed: 0
[   54.465601] sas: ata13: end_device-12:0: dev error handler
[   54.618588] ata13.00: ATA-11: WDC  WUH721818ALN604, PCGNW232, max UDMA/133
[   56.295486] ata13.00: 4394582016 sectors, multi 0: LBA48 NCQ (depth 32)
[   56.306849] ata13.00: Features: NCQ-sndrcv NCQ-prio
[   56.320849] ata13.00: configured for UDMA/133
[   56.324504] sas: --- Exit sas_scsi_recover_host: busy: 0 failed: 0 tries: 1
[   56.340346] scsi 12:0:0:0: Direct-Access     ATA      WDC  WUH721818AL W232
PQ: 0 ANSI: 5
[   56.347160] sas: DONE DISCOVERY on port 0, pid:423, result:0
[   56.348161] sas: phy-12:5 added to port-12:1, phy_mask:0x20 (50010860002f5645)
[   56.351291] sas: DOING DISCOVERY on port 1, pid:423
[   56.363285] sas: Enter sas_scsi_recover_host busy: 0 failed: 0
[   56.368788] sas: ata13: end_device-12:0: dev error handler
[   56.368859] sas: ata14: end_device-12:1: dev error handler
[   56.522903] ata14.00: ATA-11: WDC  WUH721818ALN604, PCGNWTW2, max UDMA/133
[   58.402015] ata14.00: 4394582016 sectors, multi 0: LBA48 NCQ (depth 32)
[   58.406207] ata14.00: Features: NCQ-sndrcv NCQ-prio
[   58.420254] ata14.00: configured for UDMA/133
[   58.423222] sas: --- Exit sas_scsi_recover_host: busy: 0 failed: 0 tries: 1
[   58.438869] scsi 12:0:1:0: Direct-Access     ATA      WDC  WUH721818AL WTW2
PQ: 0 ANSI: 5
[   58.445619] sas: DONE DISCOVERY on port 1, pid:423, result:0
[   58.446687] sas: phy-12:6 added to port-12:2, phy_mask:0x40 (50010860002f5646)
[   58.449803] sas: DOING DISCOVERY on port 2, pid:423
[   58.461732] sas: Enter sas_scsi_recover_host busy: 0 failed: 0
[   58.465369] sas: ata13: end_device-12:0: dev error handler
[   58.465426] sas: ata14: end_device-12:1: dev error handler
[   58.465432] sas: ata15: end_device-12:2: dev error handler
[   58.622345] ata15.00: ATA-12: WDC  WUH722222ALN604, LNGNW1TZ, max UDMA/133
[   59.540468] ata15.00: 5371330560 sectors, multi 0: LBA48 NCQ (depth 32)
[   59.588217] ata15.00: Features: NCQ-sndrcv NCQ-prio CDL
[   59.697588] ata15.00: configured for UDMA/133
[   59.700514] sas: --- Exit sas_scsi_recover_host: busy: 0 failed: 0 tries: 1
[   59.716067] scsi 12:0:2:0: Direct-Access     ATA      WDC  WUH722222AL W1TZ
PQ: 0 ANSI: 5
[   59.723838] sas: DONE DISCOVERY on port 2, pid:423, result:0
[   59.724893] sas: phy-12:7 added to port-12:3, phy_mask:0x80 (50010860002f5647)
[   59.727852] sas: DOING DISCOVERY on port 3, pid:423
[   59.739699] sas: Enter sas_scsi_recover_host busy: 0 failed: 0
[   59.743344] sas: ata13: end_device-12:0: dev error handler
[   59.743402] sas: ata14: end_device-12:1: dev error handler
[   59.743405] sas: ata15: end_device-12:2: dev error handler
[   59.743429] sas: ata16: end_device-12:3: dev error handler
[   59.898839] ata16.00: ATA-11: WDC  WSH722020ALN604, PCGMW803, max UDMA/133
[   62.348080] ata16.00: 4882956288 sectors, multi 0: LBA48 NCQ (depth 32)
[   62.353731] ata16.00: Features: NCQ-sndrcv NCQ-prio
[   62.370011] ata16.00: configured for UDMA/133
[   62.373532] sas: --- Exit sas_scsi_recover_host: busy: 0 failed: 0 tries: 1
[   62.389238] scsi 12:0:3:0: Direct-Access-ZBC ATA      WDC  WSH722020AL W803
PQ: 0 ANSI: 7
[   62.396642] sas: DONE DISCOVERY on port 3, pid:423, result:0

But no scsi disk added:

# lsscsi
[12:0:0:0]   disk    ATA      WDC  WUH721818AL W232  -
[12:0:1:0]   disk    ATA      WDC  WUH721818AL WTW2  -
[12:0:2:0]   disk    ATA      WDC  WUH722222AL W1TZ  -
[12:0:3:0]   zbc     ATA      WDC  WSH722020AL W803  -

(no /dev/sdX device).
While not printed on this run, I often see messages like

scsi 12:0:0:0: deferred probe error

No idea why... I do not see where that comes from.

This is all with pm8001 driver.

-- 
Damien Le Moal
Western Digital Research

