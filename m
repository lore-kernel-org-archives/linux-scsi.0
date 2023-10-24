Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BE6C5C25B47
	for <linux-scsi@archiver.kernel.org>; Wed, 25 Oct 2023 07:07:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232469AbjJYHHj (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 25 Oct 2023 03:07:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32842 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230009AbjJYHHi (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 25 Oct 2023 03:07:38 -0400
Received: from phobos.denx.de (phobos.denx.de [IPv6:2a01:238:438b:c500:173d:9f52:ddab:ee01])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D920DE5
        for <linux-scsi@vger.kernel.org>; Wed, 25 Oct 2023 00:07:35 -0700 (PDT)
Received: from [127.0.0.1] (p578adb1c.dip0.t-ipconnect.de [87.138.219.28])
        (using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: marex@denx.de)
        by phobos.denx.de (Postfix) with ESMTPSA id CF35587179;
        Wed, 25 Oct 2023 09:07:30 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=denx.de;
        s=phobos-20191101; t=1698217652;
        bh=LEPArud3iOvIj3yfHCApd+2wR2s9ZN/taOl2hnkpgzo=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=aSqSKjgv4lbVE5KFBkrwh0toDDWhV9zaPS4C8EDYy2I3GJueC2+NtYSQ797uETM3k
         ybjYO3x6lQkRcKiSrQ2bBKxM342QShSWWc/z35PdSyPGvZfGW8I6kAkz0hFtUuEA5b
         VxKzNbIbMfD9/XuujrrcRBFLomvwhqlifhDE8gNAbZiA9a4wGGCcM520xv3CvZqixI
         Zh+8YCJIsRDwDc24PpR420dgqisSXRgpByum/ewbRo/iqO387Dul+yQohw6ZXP3IvF
         06yaRot/0GtMvyEjsByXQ/gA2dmJy1zEaEH3hYY7p8jcUiCmoYhjLPlvH+P1XAxmQq
         LC7/ibzvn641Q==
Message-ID: <76abf633-5e11-4e92-95ba-d3fcf47a964f@denx.de>
Date:   Tue, 24 Oct 2023 14:31:50 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] [RFC] scsi: mvsas: Try to enable MSI
To:     John Garry <john.g.garry@oracle.com>, linux-scsi@vger.kernel.org
Cc:     "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Bart Van Assche <bvanassche@acm.org>,
        Damien Le Moal <dlemoal@kernel.org>,
        Jason Yan <yanaijie@huawei.com>
References: <20231022200329.60844-1-marex@denx.de>
 <4da00d15-2715-bd87-daed-16b348535782@oracle.com>
Content-Language: en-US
From:   Marek Vasut <marex@denx.de>
In-Reply-To: <4da00d15-2715-bd87-daed-16b348535782@oracle.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Virus-Scanned: clamav-milter 0.103.8 at phobos.denx.de
X-Virus-Status: Clean
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 10/24/23 12:46, John Garry wrote:
> On 22/10/2023 21:03, Marek Vasut wrote:
>> This seems to be needed on OCZ RevoDrive 3 X2 / RevoDrive 350
>> OCZ Technology Group, Inc. RevoDrive 3 X2 PCIe SSD 240 GB (Marvell SAS 
>> Controller) [1b85:1021] (rev 02)
>>
> 
> By chance do you have any documentation on this controller

None what-so-ever, only this ancient oczpcie mvsas driver fork, which I 
injected hunk by hunk into existing mvsas, tested, etc. until I got to 
this one PCIe MSI line thing which made that controller work.

> which tells us that it requires MSI?

The situation is even worse in that OCZ got assimilated by Toshiba and 
all information about this device disappeared from toshiba website long 
ago. It is still in archive.org, but whatever software they released is 
non-trivial to even get working at all, and tbh even this drive itself 
is weird piece of hardware.

>> Without MSI enabled, the controller fails as follows:
>> "
>> mvsas 0000:00:02.0: mvsas: PCI-E x0, Bandwidth Usage: UnKnown Gbps
>> scsi host0: mvsas
>> sas: Enter sas_scsi_recover_host busy: 0 failed: 0
>> ata1.00: qc timeout after 5000 msecs (cmd 0xec)
>> ata1.00: failed to IDENTIFY (I/O error, err_mask=0x4)
>> ata1.00: qc timeout after 10000 msecs (cmd 0xec)
>> ata1.00: failed to IDENTIFY (I/O error, err_mask=0x4)
>> ata1.00: qc timeout after 30000 msecs (cmd 0xec)
>> ata1.00: failed to IDENTIFY (I/O error, err_mask=0x4)
>> sas: --- Exit sas_scsi_recover_host: busy: 0 failed: 0 tries: 1
>> sas: sas_probe_sata: for direct-attached device 0000000000000000 
>> returned -19
>> sas: Enter sas_scsi_recover_host busy: 0 failed: 0
>> ata2.00: qc timeout after 5000 msecs (cmd 0xec)
>> ata2.00: failed to IDENTIFY (I/O error, err_mask=0x4)
>> ata2.00: qc timeout after 10000 msecs (cmd 0xec)
>> ata2.00: failed to IDENTIFY (I/O error, err_mask=0x4)
>> ata2.00: qc timeout after 30000 msecs (cmd 0xec)
>> ata2.00: failed to IDENTIFY (I/O error, err_mask=0x4)
>> sas: --- Exit sas_scsi_recover_host: busy: 0 failed: 0 tries: 1
>> sas: sas_probe_sata: for direct-attached device 0100000000000000 
>> returned -19
>> "
>>
>> With this patch, the controller detects the two SSD drives on it:
>> "
>> mvsas 0000:00:02.0: mvsas: PCI-E x0, Bandwidth Usage: UnKnown Gbps
>> scsi host0: mvsas
>> sas: Enter sas_scsi_recover_host busy: 0 failed: 0
>> ata1.00: ATA-8: OCZ-REVODRIVE350, 2.50, max UDMA/133
>> ata1.00: 234441648 sectors, multi 1: LBA48 NCQ (depth 32)
>> ata1.00: configured for UDMA/133
>> sas: --- Exit sas_scsi_recover_host: busy: 0 failed: 0 tries: 1
>> scsi 0:0:0:0: Direct-Access     ATA      OCZ-REVODRIVE350 2.50 PQ: 0 
>> ANSI: 5
>> sas: Enter sas_scsi_recover_host busy: 0 failed: 0
>> ata2.00: ATA-8: OCZ-REVODRIVE350, 2.50, max UDMA/133
>> ata2.00: 234441648 sectors, multi 1: LBA48 NCQ (depth 32)
>> ata2.00: configured for UDMA/133
>> sas: --- Exit sas_scsi_recover_host: busy: 0 failed: 0 tries: 1
>> scsi 0:0:1:0: Direct-Access     ATA      OCZ-REVODRIVE350 2.50 PQ: 0 
>> ANSI: 5
>> scsi 0:0:0:0: Attached scsi generic sg0 type 0
>> sd 0:0:0:0: [sda] 234441648 512-byte logical blocks: (120 GB/112 GiB)
>> sd 0:0:1:0: [sdb] 234441648 512-byte logical blocks: (120 GB/112 GiB)
>> sd 0:0:1:0: Attached scsi generic sg1 type 0
>> sd 0:0:0:0: [sda] Write Protect is off
>> sd 0:0:1:0: [sdb] Write Protect is off
>> sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't 
>> support DPO or FUA
>> sd 0:0:1:0: [sdb] Write cache: enabled, read cache: enabled, doesn't 
>> support DPO or FUA
>> sd 0:0:0:0: [sda] Preferred minimum I/O size 512 bytes
>> sd 0:0:1:0: [sdb] Preferred minimum I/O size 512 bytes
>> sd 0:0:0:0: [sda] Attached SCSI disk
>> sd 0:0:1:0: [sdb] Attached SCSI disk
>> "
>>
>> I am not sure whether this is the correct fix, or whether this should
>> be a controller specific quirk instead, considering how this is likely
>> a legacy controller driver.
> 
> pci_enable_msi() switches from pin-based interrupts to MSI. So currently 
> the driver relies on pin-based. As such, I would be more inclined to 
> quirk the driver for this controller.

Indeed.

I'll send a V2 with the quirk and return value check when time permits, 
considering there seem to be few users, I don't think there is much urgency.

Thanks !
