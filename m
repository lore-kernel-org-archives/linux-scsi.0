Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 48512259CBB;
	Wed, 30 Apr 2025 13:39:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746020364; cv=none; b=BUW4hg24faqgA3ZD75x+qTE0E5jDKzbtZDmx+OG0X36tMRQfs5UxPvdVc0J58aKMFlThOkX/NKFVugazHM0a3k+h8/0x45qZW3ELGBQLzRVC0XfGz4F2Jyry54kFlb1f2MY1iO9LMQ3BYLfckWYZJ6GxITnBzQOI8O+/9JJe1ww=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746020364; c=relaxed/simple;
	bh=KEuV8R6Ekk5KvPU2aRYN+FHiJyfEAMqCH7PMCfSx17w=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=DMBkM7Sf2pJjtWI/Ate7pJ7v2czs3Qre0noqO8hFQf664bL49XpPKUp5r2TD9XA6ZbNIVdUPVB3nwcZMonHvVUMuZnlgR2Dse9BxLQ/2v5Xg2HWD3LFmBsIHeT2a/rtlbUinQ8RBt5KMw2O2AgUCNADW1PUqhVzymGM4n7ed6pc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=T/mZ4A8o; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="T/mZ4A8o"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 91BB3C4CEE9;
	Wed, 30 Apr 2025 13:39:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1746020363;
	bh=KEuV8R6Ekk5KvPU2aRYN+FHiJyfEAMqCH7PMCfSx17w=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=T/mZ4A8oV53kCxEXMLM5FHEzKvus1EBQ2mE9jR7lNIJRsMEu2G5JD3rvbdEQksFPo
	 Xbl8fQURYq7aIF55iiuW8/qJf1Yjbo89fQy4JgcfxNyHZaqUB2280QBsH9EEdJnDCq
	 lwrpjuMkuZgBzMmw3H4HGeo0t7JfPye/sPN0HS8Olhqbrg5BnquQqQBmlAa8AR4AS1
	 ZTI8IZ4OIfJmtLrx6sMauu43x+FKerWSzyZNMagg0UsLjco1fmqzaBrDDvhO5b8OIW
	 PxvDq7ybf6YJSO+i4+5xErq8rnl75ztABJwTp2IbwmJwEvkJXF+ufGoSfWuyiRtFMw
	 0f5Mgu8j055pw==
Message-ID: <6fb8499a-b5bc-4d41-bf37-32ebdea43e9a@kernel.org>
Date: Wed, 30 Apr 2025 08:39:20 -0500
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v7 08/19] scsi: detect support for command duration limits
To: Friedrich Weber <f.weber@proxmox.com>, Niklas Cassel <nks@flawful.org>,
 Jens Axboe <axboe@kernel.dk>, "Martin K. Petersen"
 <martin.petersen@oracle.com>, "James E.J. Bottomley" <jejb@linux.ibm.com>
Cc: Bart Van Assche <bvanassche@acm.org>, Christoph Hellwig <hch@lst.de>,
 Hannes Reinecke <hare@suse.de>, linux-scsi@vger.kernel.org,
 linux-ide@vger.kernel.org, linux-block@vger.kernel.org,
 Niklas Cassel <niklas.cassel@wdc.com>, Mira Limbeck <m.limbeck@proxmox.com>
References: <20230511011356.227789-1-nks@flawful.org>
 <20230511011356.227789-9-nks@flawful.org>
 <3dee186c-285e-4c1c-b879-6445eb2f3edf@proxmox.com>
Content-Language: en-US
From: Damien Le Moal <dlemoal@kernel.org>
Organization: Western Digital Research
In-Reply-To: <3dee186c-285e-4c1c-b879-6445eb2f3edf@proxmox.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 2025/04/30 7:13, Friedrich Weber wrote:
> Hi,
> 
> One of our users reports that, in their setup, hotplugging new disks doesn't
> work anymore with recent kernels (details below). The issue appeared somewhere
> between kernels 6.4 and 6.5, and they bisected the change to this patch:
> 
>   624885209f31 (scsi: core: Detect support for command duration limits)
> 
> The issue is also reproducible on a mainline kernel 6.14.4 build from [1]. When
> hotplugging a disk under 6.14.4, the following is logged (I've redacted some
> identifiers, let me know in case I've been too overzealous with that):
> 
> Apr 28 16:41:13 pbs-disklab kernel: mpt3sas_cm0: handle(0xa) sas_address(0xREDACTED_SAS_ADDR) port_type(0x1)
> Apr 28 16:41:13 pbs-disklab kernel: scsi 5:0:1:0: Direct-Access     WDC      REDACTED_SN  C5C0 PQ: 0 ANSI: 7
> Apr 28 16:41:13 pbs-disklab kernel: scsi 5:0:1:0: SSP: handle(0x000a), sas_addr(0xREDACTED_SAS_ADDR), phy(2), device_name(REDACTED_DEVICE_NAME)
> Apr 28 16:41:13 pbs-disklab kernel: scsi 5:0:1:0: enclosure logical id (REDACTED_LOGICAL_ID), slot(0) 
> Apr 28 16:41:13 pbs-disklab kernel: scsi 5:0:1:0: enclosure level(0x0000), connector name(     )
> Apr 28 16:41:13 pbs-disklab kernel: scsi 5:0:1:0: qdepth(254), tagged(1), scsi_level(8), cmd_que(1)
> Apr 28 16:41:13 pbs-disklab kernel: scsi 5:0:1:0: Power-on or device reset occurred
> Apr 28 16:41:16 pbs-disklab kernel: mpt3sas_cm0: log_info(0x31110e05): originator(PL), code(0x11), sub_code(0x0e05)

This decodes to:

Code:     	00110000h	PL_LOGINFO_CODE_RESET See Sub-Codes below (PL_LOGINFO_SUB_CODE)
Sub Code: 	00000E00h	PL_LOGINFO_SUB_CODE_DISCOVERY_SATA_ERR

> Apr 28 16:41:18 pbs-disklab kernel: mpt3sas_cm0: log_info(0x31130000): originator(PL), code(0x13), sub_code(0x0000)
> Apr 28 16:41:18 pbs-disklab kernel: sd 5:0:1:0: Attached scsi generic sg1 type 0
> Apr 28 16:41:18 pbs-disklab kernel: sd 5:0:1:0: [sdb] Test Unit Ready failed: Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK
> Apr 28 16:41:18 pbs-disklab kernel: sd 5:0:1:0: [sdb] Read Capacity(16) failed: Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK
> Apr 28 16:41:18 pbs-disklab kernel: sd 5:0:1:0: [sdb] Sense not available.
> Apr 28 16:41:18 pbs-disklab kernel: sd 5:0:1:0: [sdb] Read Capacity(10) failed: Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK
> Apr 28 16:41:18 pbs-disklab kernel: sd 5:0:1:0: [sdb] Sense not available.
> Apr 28 16:41:18 pbs-disklab kernel: sd 5:0:1:0: [sdb] 0 512-byte logical blocks: (0 B/0 B)
> Apr 28 16:41:18 pbs-disklab kernel: sd 5:0:1:0: [sdb] 0-byte physical blocks
> Apr 28 16:41:18 pbs-disklab kernel: sd 5:0:1:0: [sdb] Test WP failed, assume Write Enabled
> Apr 28 16:41:18 pbs-disklab kernel: sd 5:0:1:0: [sdb] Asking for cache data failed
> Apr 28 16:41:18 pbs-disklab kernel: sd 5:0:1:0: [sdb] Assuming drive cache: write through
> Apr 28 16:41:18 pbs-disklab kernel:  end_device-5:1: add: handle(0x000a), sas_addr(0xREDACTED_SAS_ADDR)
> Apr 28 16:41:18 pbs-disklab kernel: mpt3sas_cm0: handle(0x000a), ioc_status(0x0022) failure at drivers/scsi/mpt3sas/mpt3sas_transport.c:225/_transport_set_identify()!
> Apr 28 16:41:18 pbs-disklab kernel: sd 5:0:1:0: [sdb] Attached SCSI disk
> Apr 28 16:41:18 pbs-disklab kernel: mpt3sas_cm0: mpt3sas_transport_port_remove: removed: sas_addr(0xREDACTED_SAS_ADDR)
> Apr 28 16:41:18 pbs-disklab kernel: mpt3sas_cm0: removing handle(0x000a), sas_addr(0xREDACTED_SAS_ADDR)
> Apr 28 16:41:18 pbs-disklab kernel: mpt3sas_cm0: enclosure logical id(REDACTED_LOGICAL_ID), slot(0)
> Apr 28 16:41:18 pbs-disklab kernel: mpt3sas_cm0: enclosure level(0x0000), connector name(     )
> 
> and the block device isn't accessible afterwards. It does seem to be visible
> after a reboot.
> 
> lspci on this host shows:
> 
> 02:00.0 Serial Attached SCSI controller [0107]: Broadcom / LSI SAS3008 PCI-Express Fusion-MPT SAS-3 [1000:0097] (rev 02)
> 	Subsystem: Broadcom / LSI SAS9300-8i [1000:30e0]
> 	Kernel driver in use: mpt3sas
> 	Kernel modules: mpt3sas
> 
> The HBA is placed on a PCIe 3.0 x8 slot (not bifurcated) and connected via
> SFF-8643 to a simple 2U 12xLFF SAS3 Supermicro box. The user can also reproduce
> the issue with other HBAs with e.g. the SAS3108 and SAS3816 chipsets.
> 
> The device doesn't seem to support CDL. So if I see correctly, the only
> effective change introduced by the patch are the four scsi_cdl_check_cmd (and
> thus scsi_report_opcode) calls to check for CDL support. Hence we wondered
> whether may be the cause of the issue. We ran a few tests to verify:
> 
> - disabling "REPORT SUPPORTED OPERATION CODES" by passing
>   `scsi_mod.dev_flags=WDC:REDACTED_SN:536870912` (the flag being
>   BLIST_NO_RSOC) resolves the issue (hotplug works again), but I imagine
>   disabling RSOC altogether isn't a good workaround. This test was not done
>   on a mainline kernel, but I don't think it would make a difference.

So it seems that the HBA SAT is choking on the report supported opcode command.
I have several mpt3sas HBAs and I have never seen this issue running the latest
FW version for these (EOL) HBAs. So I am tempted to say that an HBA FW update
should resolve the issue, BUT, I do not recall doing any drive hotplug tests
though. This issue may trigger only with hotplug and not with a cold start...
Can you confirm that ?

> 
> - we patched out the four calls to scsi_cdl_check_cmd and unconditionally set
>   cdl_supported to 0, see [2] for the patch (on top of 6.14.4). This resolves
>   the issue.
> 
> - I suspected that particularly the two latter scsi_cdl_check_cmd calls with a
>   nonzero service action might be problematic, so we patched them out
>   specifically but kept the other two calls without a service action, see [3]
>   for the patch (on top of 6.14.4). But with this patch, hotplug still does
>   not work.
> 
> - the RSOC commands themselves don't seem to be problematic per se. We asked
>   the user to boot a (non-mainline) kernel with the `scsi_mod.dev_flags`
>   parameter to disable RSOC as above, hotplug the disk (this succeeds), and
>   then query the four opcodes/service actions using `sg_opcodes`, and this
>   looks okay [4] (reporting that CDL is not supported).
> 
> I wonder whether these results might suggest the RSOC queries are problematic
> not in general, but at this particular point (during device initialization) in
> this particular hardware setup? If this turns out to be the case -- would it be
> feasible to suppress these RSOC queries if CDL is not enabled via sysfs?

I would be tempted to say that indeed it is the RSOC command handling in the HBA
SAT that has issues. But your command line checks [4] tend to indicate
otherwise. The issue may trigger only with timing differences with hotplug though.

The other possible problem may be that the RSOC command translation is actually
fine but ends up generating an ATA command that the drive is not happy about,
either because of a drive FW bug or because of the timing the drive receives
that command. Given that this is a WD drive, I can probably check that if you
can send to me the drive model and FW rev (sending that information off-list is
fine).

> If you have any ideas for further troubleshooting, we're happy to gather more
> data. I'll be AFK for a few weeks, but Mira (in CC) will take over in the
> meantime.

Checking the HBA FW version would be a start, and also if you can confirm if
this issue happens only on hotplug or also during cold boot would be nice. I am
traveling right now and will not be able to test hot-plugging drives on my
setups until end of next week.

> 
> Thanks!
> 
> Friedrich
> 
> [1] https://kernel.ubuntu.com/mainline/v6.14.4/
> 
> [2]
> 
> diff --git a/drivers/scsi/scsi.c b/drivers/scsi/scsi.c
> index a77e0499b738..022b2f9706a4 100644
> --- a/drivers/scsi/scsi.c
> +++ b/drivers/scsi/scsi.c
> @@ -658,11 +658,7 @@ void scsi_cdl_check(struct scsi_device *sdev)
>         }
> 
>         /* Check support for READ_16, WRITE_16, READ_32 and WRITE_32 commands */
> -       cdl_supported =
> -               scsi_cdl_check_cmd(sdev, READ_16, 0, buf) ||
> -               scsi_cdl_check_cmd(sdev, WRITE_16, 0, buf) ||
> -               scsi_cdl_check_cmd(sdev, VARIABLE_LENGTH_CMD, READ_32, buf) ||
> -               scsi_cdl_check_cmd(sdev, VARIABLE_LENGTH_CMD, WRITE_32, buf);
> +       cdl_supported = 0;
>         if (cdl_supported) {
>                 /*
>                  * We have CDL support: force the use of READ16/WRITE16.
> 
> [3]
> 
> diff --git a/drivers/scsi/scsi.c b/drivers/scsi/scsi.c
> index a77e0499b738..6b0f36f5415e 100644
> --- a/drivers/scsi/scsi.c
> +++ b/drivers/scsi/scsi.c
> @@ -660,9 +660,8 @@ void scsi_cdl_check(struct scsi_device *sdev)
>         /* Check support for READ_16, WRITE_16, READ_32 and WRITE_32 commands */
>         cdl_supported =
>                 scsi_cdl_check_cmd(sdev, READ_16, 0, buf) ||
> -               scsi_cdl_check_cmd(sdev, WRITE_16, 0, buf) ||
> -               scsi_cdl_check_cmd(sdev, VARIABLE_LENGTH_CMD, READ_32, buf) ||
> -               scsi_cdl_check_cmd(sdev, VARIABLE_LENGTH_CMD, WRITE_32, buf);
> +               scsi_cdl_check_cmd(sdev, WRITE_16, 0, buf);
> +       cdl_supported = 0;
>         if (cdl_supported) {
>                 /*
>                  * We have CDL support: force the use of READ16/WRITE16.
> 
> [4]
> 
> root@pbs-disklab:~# sg_opcodes -o 0x88 /dev/sdb
> 
> Opcode=0x88
> Command_name: Read(16)
> Command is supported [conforming to SCSI standard]
> No command duration limit mode page
> Multiple Logical Units (MLU): not reported
> Usage data: 88 fe ff ff ff ff ff ff ff ff ff ff ff ff 00 00
> 
> root@pbs-disklab:~# sg_opcodes -o 0x8a /dev/sdb
> 
> Opcode=0x8a
> Command_name: Write(16)
> Command is supported [conforming to SCSI standard]
> No command duration limit mode page
> Multiple Logical Units (MLU): not reported
> Usage data: 8a fa ff ff ff ff ff ff ff ff ff ff ff ff 00 00
> 
> root@pbs-disklab:~# sg_opcodes -o 0x7f,0x9 /dev/sdb
> 
> Opcode=0x7f  Service_action=0x0009
> Command_name: Read(32)
> Command is supported [conforming to SCSI standard]
> No command duration limit mode page
> Multiple Logical Units (MLU): not reported
> Usage data: 7f 00 00 00 00 00 00 ff 00 09 fe 00 ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
> 
> root@pbs-disklab:~# sg_opcodes -o 0x7f,0xb /dev/sdb
> 
> Opcode=0x7f  Service_action=0x000b
> Command_name: Write(32)
> Command is supported [conforming to SCSI standard]
> No command duration limit mode page
> Multiple Logical Units (MLU): not reported
> Usage data: 7f 00 00 00 00 00 00 ff 00 0b fa 00 ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
> 


-- 
Damien Le Moal
Western Digital Research
