Received: from proxmox-new.maurer-it.com (proxmox-new.maurer-it.com [94.136.29.106])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 93A724C85;
	Tue,  3 Jun 2025 11:34:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=94.136.29.106
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748950484; cv=none; b=Bxn970Uty6VDjm8RXq/qHd5uoendXKc5WZW00qXCF35Fq69ysRoxz6y1Q8OUTAsJvXawktG9sMoxCflcgUEyixHfmByd8pJ8QTevnGta6U4Rm+wE9DJnsA+hpnN6oTEbYtGfv4MzJk64IGbqQB1doCtGbDw++trqM8liqg1F8AI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748950484; c=relaxed/simple;
	bh=rVdIeCbr95s9nRU81bxbasBbtb/HneBs3SbYEQ2k9I4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=b0kamKNO7gzn3gheXOa6h78wJnzPN5+BuOk/iXVzHpU4bZ2/tLNevjxIumiJoa4k8fUgChM9TnvFpB/bm2sKCVPq50AfPJKqXe+NQu6xEvHhiF+Ogy7CI8NDJ/Oaaj9k79Cv2p33hB8fDj28xKl6uOY+llEHQXUFZWoPSw3FAlM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=proxmox.com; spf=pass smtp.mailfrom=proxmox.com; arc=none smtp.client-ip=94.136.29.106
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=proxmox.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=proxmox.com
Received: from proxmox-new.maurer-it.com (localhost.localdomain [127.0.0.1])
	by proxmox-new.maurer-it.com (Proxmox) with ESMTP id 1ABDE4454F;
	Tue,  3 Jun 2025 13:28:26 +0200 (CEST)
Message-ID: <a927b51b-1b34-4d4f-9447-d8c559127707@proxmox.com>
Date: Tue, 3 Jun 2025 13:28:23 +0200
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v7 08/19] scsi: detect support for command duration limits
To: Damien Le Moal <dlemoal@kernel.org>, Mira Limbeck
 <m.limbeck@proxmox.com>, Niklas Cassel <nks@flawful.org>,
 Jens Axboe <axboe@kernel.dk>, "Martin K. Petersen"
 <martin.petersen@oracle.com>, "James E.J. Bottomley" <jejb@linux.ibm.com>,
 Kashyap Desai <kashyap.desai@broadcom.com>,
 Sumit Saxena <sumit.saxena@broadcom.com>,
 Shivasharan S <shivasharan.srikanteshwara@broadcom.com>,
 Chandrakanth patil <chandrakanth.patil@broadcom.com>,
 Sathya Prakash Veerichetty <sathya.prakash@broadcom.com>,
 Sreekanth Reddy <sreekanth.reddy@broadcom.com>,
 megaraidlinux.pdl@broadcom.com, mpi3mr-linuxdrv.pdl@broadcom.com
Cc: Bart Van Assche <bvanassche@acm.org>, Christoph Hellwig <hch@lst.de>,
 Hannes Reinecke <hare@suse.de>, linux-scsi@vger.kernel.org,
 linux-ide@vger.kernel.org, linux-block@vger.kernel.org,
 Niklas Cassel <niklas.cassel@wdc.com>
References: <20230511011356.227789-1-nks@flawful.org>
 <20230511011356.227789-9-nks@flawful.org>
 <3dee186c-285e-4c1c-b879-6445eb2f3edf@proxmox.com>
 <6fb8499a-b5bc-4d41-bf37-32ebdea43e9a@kernel.org>
 <2e7d6a7e-4a82-4da5-ab39-267a7400ca49@proxmox.com>
 <b1d9e928-a7f3-4555-9c0a-5b83ba87a698@kernel.org>
Content-Language: en-US
From: Friedrich Weber <f.weber@proxmox.com>
In-Reply-To: <b1d9e928-a7f3-4555-9c0a-5b83ba87a698@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 09/05/2025 01:45, Damien Le Moal wrote:
> On 5/8/25 6:36 PM, Mira Limbeck wrote:
>> On 4/30/25 15:39, Damien Le Moal wrote:
>>> On 2025/04/30 7:13, Friedrich Weber wrote:
>>>> Hi,
>>>>
>>>> One of our users reports that, in their setup, hotplugging new disks doesn't
>>>> work anymore with recent kernels (details below). The issue appeared somewhere
>>>> between kernels 6.4 and 6.5, and they bisected the change to this patch:
>>>>
>>>>   624885209f31 (scsi: core: Detect support for command duration limits)
>>>>
>>>> The issue is also reproducible on a mainline kernel 6.14.4 build from [1]. When
>>>> hotplugging a disk under 6.14.4, the following is logged (I've redacted some
>>>> identifiers, let me know in case I've been too overzealous with that):
>>>>
>>>> Apr 28 16:41:13 pbs-disklab kernel: mpt3sas_cm0: handle(0xa) sas_address(0xREDACTED_SAS_ADDR) port_type(0x1)
>>>> Apr 28 16:41:13 pbs-disklab kernel: scsi 5:0:1:0: Direct-Access     WDC      REDACTED_SN  C5C0 PQ: 0 ANSI: 7
>>>> Apr 28 16:41:13 pbs-disklab kernel: scsi 5:0:1:0: SSP: handle(0x000a), sas_addr(0xREDACTED_SAS_ADDR), phy(2), device_name(REDACTED_DEVICE_NAME)
>>>> Apr 28 16:41:13 pbs-disklab kernel: scsi 5:0:1:0: enclosure logical id (REDACTED_LOGICAL_ID), slot(0) 
>>>> Apr 28 16:41:13 pbs-disklab kernel: scsi 5:0:1:0: enclosure level(0x0000), connector name(     )
>>>> Apr 28 16:41:13 pbs-disklab kernel: scsi 5:0:1:0: qdepth(254), tagged(1), scsi_level(8), cmd_que(1)
>>>> Apr 28 16:41:13 pbs-disklab kernel: scsi 5:0:1:0: Power-on or device reset occurred
>>>> Apr 28 16:41:16 pbs-disklab kernel: mpt3sas_cm0: log_info(0x31110e05): originator(PL), code(0x11), sub_code(0x0e05)
>>>
>>> This decodes to:
>>>
>>> Code:     	00110000h	PL_LOGINFO_CODE_RESET See Sub-Codes below (PL_LOGINFO_SUB_CODE)
>>> Sub Code: 	00000E00h	PL_LOGINFO_SUB_CODE_DISCOVERY_SATA_ERR
>>>
>>>> Apr 28 16:41:18 pbs-disklab kernel: mpt3sas_cm0: log_info(0x31130000): originator(PL), code(0x13), sub_code(0x0000)
>>>> Apr 28 16:41:18 pbs-disklab kernel: sd 5:0:1:0: Attached scsi generic sg1 type 0
>>>> Apr 28 16:41:18 pbs-disklab kernel: sd 5:0:1:0: [sdb] Test Unit Ready failed: Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK
>>>> Apr 28 16:41:18 pbs-disklab kernel: sd 5:0:1:0: [sdb] Read Capacity(16) failed: Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK
>>>> Apr 28 16:41:18 pbs-disklab kernel: sd 5:0:1:0: [sdb] Sense not available.
>>>> Apr 28 16:41:18 pbs-disklab kernel: sd 5:0:1:0: [sdb] Read Capacity(10) failed: Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK
>>>> Apr 28 16:41:18 pbs-disklab kernel: sd 5:0:1:0: [sdb] Sense not available.
>>>> Apr 28 16:41:18 pbs-disklab kernel: sd 5:0:1:0: [sdb] 0 512-byte logical blocks: (0 B/0 B)
>>>> Apr 28 16:41:18 pbs-disklab kernel: sd 5:0:1:0: [sdb] 0-byte physical blocks
>>>> Apr 28 16:41:18 pbs-disklab kernel: sd 5:0:1:0: [sdb] Test WP failed, assume Write Enabled
>>>> Apr 28 16:41:18 pbs-disklab kernel: sd 5:0:1:0: [sdb] Asking for cache data failed
>>>> Apr 28 16:41:18 pbs-disklab kernel: sd 5:0:1:0: [sdb] Assuming drive cache: write through
>>>> Apr 28 16:41:18 pbs-disklab kernel:  end_device-5:1: add: handle(0x000a), sas_addr(0xREDACTED_SAS_ADDR)
>>>> Apr 28 16:41:18 pbs-disklab kernel: mpt3sas_cm0: handle(0x000a), ioc_status(0x0022) failure at drivers/scsi/mpt3sas/mpt3sas_transport.c:225/_transport_set_identify()!
>>>> Apr 28 16:41:18 pbs-disklab kernel: sd 5:0:1:0: [sdb] Attached SCSI disk
>>>> Apr 28 16:41:18 pbs-disklab kernel: mpt3sas_cm0: mpt3sas_transport_port_remove: removed: sas_addr(0xREDACTED_SAS_ADDR)
>>>> Apr 28 16:41:18 pbs-disklab kernel: mpt3sas_cm0: removing handle(0x000a), sas_addr(0xREDACTED_SAS_ADDR)
>>>> Apr 28 16:41:18 pbs-disklab kernel: mpt3sas_cm0: enclosure logical id(REDACTED_LOGICAL_ID), slot(0)
>>>> Apr 28 16:41:18 pbs-disklab kernel: mpt3sas_cm0: enclosure level(0x0000), connector name(     )
>>>>
>>>> and the block device isn't accessible afterwards. It does seem to be visible
>>>> after a reboot.
>>>>
>>>> lspci on this host shows:
>>>>
>>>> 02:00.0 Serial Attached SCSI controller [0107]: Broadcom / LSI SAS3008 PCI-Express Fusion-MPT SAS-3 [1000:0097] (rev 02)
>>>> 	Subsystem: Broadcom / LSI SAS9300-8i [1000:30e0]
>>>> 	Kernel driver in use: mpt3sas
>>>> 	Kernel modules: mpt3sas
>>>>
>>>> The HBA is placed on a PCIe 3.0 x8 slot (not bifurcated) and connected via
>>>> SFF-8643 to a simple 2U 12xLFF SAS3 Supermicro box. The user can also reproduce
>>>> the issue with other HBAs with e.g. the SAS3108 and SAS3816 chipsets.
>>>>
>>>> The device doesn't seem to support CDL. So if I see correctly, the only
>>>> effective change introduced by the patch are the four scsi_cdl_check_cmd (and
>>>> thus scsi_report_opcode) calls to check for CDL support. Hence we wondered
>>>> whether may be the cause of the issue. We ran a few tests to verify:
>>>>
>>>> - disabling "REPORT SUPPORTED OPERATION CODES" by passing
>>>>   `scsi_mod.dev_flags=WDC:REDACTED_SN:536870912` (the flag being
>>>>   BLIST_NO_RSOC) resolves the issue (hotplug works again), but I imagine
>>>>   disabling RSOC altogether isn't a good workaround. This test was not done
>>>>   on a mainline kernel, but I don't think it would make a difference.
>>>
>>> So it seems that the HBA SAT is choking on the report supported opcode command.
>>> I have several mpt3sas HBAs and I have never seen this issue running the latest
>>> FW version for these (EOL) HBAs. So I am tempted to say that an HBA FW update
>>> should resolve the issue, BUT, I do not recall doing any drive hotplug tests
>>> though. This issue may trigger only with hotplug and not with a cold start...
>>> Can you confirm that ?
>>>
>> Yes, a cold boot works. With hotplug it enters a broken state and any
>> subsequent reboots don't fix the issue.
>> Removing power is needed to fix the issue again.
>>
>> They mentioned the following tests:
>>
>> - Get the 20TB disk in a faulty state by booting kernels 6.5 and above
>> (6.14.X in this case, diskcaddy light on server keeps blinking, dmesg
>> shows power-reset)
>> - Reboot server, reboot into same kernel (6.14.X)
>> - Disk remains in faulty state, does not attached to system or show up
>> under any path (lsblk, df, blkid)
>>
>> and
>>
>> - Get 20TB disk into faulty state by hotswapping on kern 6.5 and above.
>> - Shut off machine, remove from power & reattach.
>> - Start machine
>> - 20TB disk mounts during boot, accessible in OS as block-device after.
>>
>>
>>>>
>>>> - we patched out the four calls to scsi_cdl_check_cmd and unconditionally set
>>>>   cdl_supported to 0, see [2] for the patch (on top of 6.14.4). This resolves
>>>>   the issue.
>>>>
>>>> - I suspected that particularly the two latter scsi_cdl_check_cmd calls with a
>>>>   nonzero service action might be problematic, so we patched them out
>>>>   specifically but kept the other two calls without a service action, see [3]
>>>>   for the patch (on top of 6.14.4). But with this patch, hotplug still does
>>>>   not work.
>>>>
>>>> - the RSOC commands themselves don't seem to be problematic per se. We asked
>>>>   the user to boot a (non-mainline) kernel with the `scsi_mod.dev_flags`
>>>>   parameter to disable RSOC as above, hotplug the disk (this succeeds), and
>>>>   then query the four opcodes/service actions using `sg_opcodes`, and this
>>>>   looks okay [4] (reporting that CDL is not supported).
>>>>
>>>> I wonder whether these results might suggest the RSOC queries are problematic
>>>> not in general, but at this particular point (during device initialization) in
>>>> this particular hardware setup? If this turns out to be the case -- would it be
>>>> feasible to suppress these RSOC queries if CDL is not enabled via sysfs?
>>>
>>> I would be tempted to say that indeed it is the RSOC command handling in the HBA
>>> SAT that has issues. But your command line checks [4] tend to indicate
>>> otherwise. The issue may trigger only with timing differences with hotplug though.
>>>
>>> The other possible problem may be that the RSOC command translation is actually
>>> fine but ends up generating an ATA command that the drive is not happy about,
>>> either because of a drive FW bug or because of the timing the drive receives
>>> that command. Given that this is a WD drive, I can probably check that if you
>>> can send to me the drive model and FW rev (sending that information off-list is
>>> fine).
>>>
>>>> If you have any ideas for further troubleshooting, we're happy to gather more
>>>> data. I'll be AFK for a few weeks, but Mira (in CC) will take over in the
>>>> meantime.
>>>
>>> Checking the HBA FW version would be a start, and also if you can confirm if
>>> this issue happens only on hotplug or also during cold boot would be nice. I am
>>> traveling right now and will not be able to test hot-plugging drives on my
>>> setups until end of next week.
>>>
>>
>> They provided controller information via `sas3ircu` and `storcli`:
>>
>> sas3ircu:
>>
>>   Controller type                         : SAS3008
>>   BIOS version                            : 8.37.00.00
>>   Firmware version                        : 16.00.16.00
> 
> Is this the latest available FW for this HBA ? (see below)

It seems 16.00.16.00 is even newer than the latest version available on
the Broadcom website, which is a bit strange -- I only found [1] there
which has an older 16.00.14.00 (3008_FW_PH16.00.14.00.rar).

>>
>> storcli:
>>
>> Firmware Package Build = 24.18.0-0021
>> Firmware Version = 4.670.00-6500
>> CPLD Version = 26515-00A
>> Bios Version = 6.34.01.0_4.19.08.00_0x06160200
>> HII Version = 03.23.06.00
>> Ctrl-R Version = 5.18-0400
>> Preboot CLI Version = 01.07-05:#%0000
>> NVDATA Version = 3.1611.00-0005
>> Boot Block Version = 3.07.00.00-0003
>> Driver Name = megaraid_sas
>> Driver Version = 07.727.03.00-rc1
> 
> Unfortunately, I do not have any megaraid model so I cannot test/recreate. I
> only have mpt3sas (9300, 9400 and 9500 series HBAs) and mpi3mr models (9600 HBA
> series).

We just realized this is actually the firmware information for a
different unrelated controller on the same host (a LSI MegaRAID SAS-3
3108 using the megaraid_sas driver). But the megaraid_sas one is not
used in our tests, so please ignore the storcli output we provided.
Sorry for the confusion.

The controller we're testing with is the SAS3008 I mentioned initially,
with firmware version 16.00.16.00 as reported by sas3ircu above.

FWIW, the user reports they have also seen the same issue with a
SAS3-9500-8e Tri-mode HBA.

>> And the disk information from `smartctl --xall`
>>
>> 20T:
>>
>> === START OF INFORMATION SECTION ===
>> Vendor:               WDC
>> Product:              WUH722020BL5204
>> Revision:             C5C0
>> Compliance:           SPC-5
>> User Capacity:        20,000,588,955,648 bytes [20.0 TB]
>> Logical block size:   512 bytes
>> Physical block size:  4096 bytes
>> LU is fully provisioned
>> Rotation Rate:        7200 rpm
>> Form Factor:          3.5 inches
>> Logical Unit id:      <id>
>> Serial number:        <S/N>
>> Device type:          disk
>> Transport protocol:   SAS (SPL-4)
>> Local Time is:        Thu May  1 15:23:35 2025 CEST
>> SMART support is:     Available - device has SMART capability.
>> SMART support is:     Enabled
>> Temperature Warning:  Enabled
>> Read Cache is:        Enabled
>> Writeback Cache is:   Enabled
>>
>> 18T:
>>
>> === START OF INFORMATION SECTION ===
>> Vendor:               WDC
>> Product:              WUH721818AL5204
>> Revision:             C8C2
>> Compliance:           SPC-5
>> User Capacity:        18,000,207,937,536 bytes [18.0 TB]
>> Logical block size:   512 bytes
>> Physical block size:  4096 bytes
>> LU is fully provisioned
>> Rotation Rate:        7200 rpm
>> Form Factor:          3.5 inches
>> Logical Unit id:      <id>
>> Serial number:        <S/N>
>> Device type:          disk
>> Transport protocol:   SAS (SPL-4)
>> Local Time is:        Thu May  1 15:25:27 2025 CEST
>> SMART support is:     Available - device has SMART capability.
>> SMART support is:     Enabled
>> Temperature Warning:  Enabled
>> Read Cache is:        Enabled
>> Writeback Cache is:   Enabled
>>
>> The 18T disk is not affected by this issue. Hotplug works as expected
>> with it.
> 
> I do not think that the drives are relevant for this issue. How the HBA react
> to a command error from the drive resulting from the HBA command translation
> likely is the issue.

I see, but it is certainly strange that 18T vs 20T drives do seem to
make a difference (hotplug works with 18T and doesn't work with 20T).

>> If you need any additional information, please let us know!
> 
> Adding the Broadcom folks to this thread, since as suspected, this seems to be
> an HBA issue. I strongly suspect that it relates to a recent very similar issue
> I have seen with the mpi3mr driver and a 9600 Broadcom HBA: any hotplug of a
> drive would completely crash the HBA and a full power cycle was needed to
> recover. A simple reboot would not be sufficient. I think the latest HBA FW
> version fixes that problem.
> 
> Broadcom team,
> 
> Any comment ?
> 

[1] https://www.supermicro.com/wdl/driver/SAS/Broadcom/3008/Firmware/

