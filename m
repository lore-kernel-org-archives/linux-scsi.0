Received: from proxmox-new.maurer-it.com (proxmox-new.maurer-it.com [94.136.29.106])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 039D624728A;
	Wed, 30 Apr 2025 12:13:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=94.136.29.106
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746015240; cv=none; b=tYfSTqEQgfv0x4s17Db4EA2OGANnMpKRHC8KGPx7WAh85nTukPw+52RyJ8uAmIESUi+WbK0wkOTJjsAI8KHq8CbiCGHTvMhAdsLmUlMAr5ekNNzt0XxptSqmF6jwCYr16YO/OpHAHWH2S/nh3hX5t/LBjL6KRo8PhrQkD1qm+nM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746015240; c=relaxed/simple;
	bh=fqwzzezm3ldL5MIdfh+XeitEWc4pBnImFbeoykoqmVo=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=UKE7LJWbYZowUiDIPF/xilOJdSJ0B6VL91vd43v0GEZv/0ksI+H28PEKttyZNBVi8sFPQUBrvvqKEIY4mct54AOuJz190h65Cv9qezffHKHewpQkDtBVlSKqa7Zp8UQrysW4NmWHUu8n8nG1cXQvC57P0Y2gxu4C1pX2cDBPGos=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=proxmox.com; spf=pass smtp.mailfrom=proxmox.com; arc=none smtp.client-ip=94.136.29.106
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=proxmox.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=proxmox.com
Received: from proxmox-new.maurer-it.com (localhost.localdomain [127.0.0.1])
	by proxmox-new.maurer-it.com (Proxmox) with ESMTP id 652E847A72;
	Wed, 30 Apr 2025 14:13:55 +0200 (CEST)
Message-ID: <3dee186c-285e-4c1c-b879-6445eb2f3edf@proxmox.com>
Date: Wed, 30 Apr 2025 14:13:53 +0200
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v7 08/19] scsi: detect support for command duration limits
To: Niklas Cassel <nks@flawful.org>, Jens Axboe <axboe@kernel.dk>,
 "Martin K. Petersen" <martin.petersen@oracle.com>,
 "James E.J. Bottomley" <jejb@linux.ibm.com>
Cc: Bart Van Assche <bvanassche@acm.org>, Christoph Hellwig <hch@lst.de>,
 Hannes Reinecke <hare@suse.de>, Damien Le Moal <dlemoal@kernel.org>,
 linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org,
 linux-block@vger.kernel.org, Niklas Cassel <niklas.cassel@wdc.com>,
 Mira Limbeck <m.limbeck@proxmox.com>
References: <20230511011356.227789-1-nks@flawful.org>
 <20230511011356.227789-9-nks@flawful.org>
Content-Language: en-US
From: Friedrich Weber <f.weber@proxmox.com>
In-Reply-To: <20230511011356.227789-9-nks@flawful.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

Hi,

One of our users reports that, in their setup, hotplugging new disks doesn't
work anymore with recent kernels (details below). The issue appeared somewhere
between kernels 6.4 and 6.5, and they bisected the change to this patch:

  624885209f31 (scsi: core: Detect support for command duration limits)

The issue is also reproducible on a mainline kernel 6.14.4 build from [1]. When
hotplugging a disk under 6.14.4, the following is logged (I've redacted some
identifiers, let me know in case I've been too overzealous with that):

Apr 28 16:41:13 pbs-disklab kernel: mpt3sas_cm0: handle(0xa) sas_address(0xREDACTED_SAS_ADDR) port_type(0x1)
Apr 28 16:41:13 pbs-disklab kernel: scsi 5:0:1:0: Direct-Access     WDC      REDACTED_SN  C5C0 PQ: 0 ANSI: 7
Apr 28 16:41:13 pbs-disklab kernel: scsi 5:0:1:0: SSP: handle(0x000a), sas_addr(0xREDACTED_SAS_ADDR), phy(2), device_name(REDACTED_DEVICE_NAME)
Apr 28 16:41:13 pbs-disklab kernel: scsi 5:0:1:0: enclosure logical id (REDACTED_LOGICAL_ID), slot(0) 
Apr 28 16:41:13 pbs-disklab kernel: scsi 5:0:1:0: enclosure level(0x0000), connector name(     )
Apr 28 16:41:13 pbs-disklab kernel: scsi 5:0:1:0: qdepth(254), tagged(1), scsi_level(8), cmd_que(1)
Apr 28 16:41:13 pbs-disklab kernel: scsi 5:0:1:0: Power-on or device reset occurred
Apr 28 16:41:16 pbs-disklab kernel: mpt3sas_cm0: log_info(0x31110e05): originator(PL), code(0x11), sub_code(0x0e05)
Apr 28 16:41:18 pbs-disklab kernel: mpt3sas_cm0: log_info(0x31130000): originator(PL), code(0x13), sub_code(0x0000)
Apr 28 16:41:18 pbs-disklab kernel: sd 5:0:1:0: Attached scsi generic sg1 type 0
Apr 28 16:41:18 pbs-disklab kernel: sd 5:0:1:0: [sdb] Test Unit Ready failed: Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK
Apr 28 16:41:18 pbs-disklab kernel: sd 5:0:1:0: [sdb] Read Capacity(16) failed: Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK
Apr 28 16:41:18 pbs-disklab kernel: sd 5:0:1:0: [sdb] Sense not available.
Apr 28 16:41:18 pbs-disklab kernel: sd 5:0:1:0: [sdb] Read Capacity(10) failed: Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK
Apr 28 16:41:18 pbs-disklab kernel: sd 5:0:1:0: [sdb] Sense not available.
Apr 28 16:41:18 pbs-disklab kernel: sd 5:0:1:0: [sdb] 0 512-byte logical blocks: (0 B/0 B)
Apr 28 16:41:18 pbs-disklab kernel: sd 5:0:1:0: [sdb] 0-byte physical blocks
Apr 28 16:41:18 pbs-disklab kernel: sd 5:0:1:0: [sdb] Test WP failed, assume Write Enabled
Apr 28 16:41:18 pbs-disklab kernel: sd 5:0:1:0: [sdb] Asking for cache data failed
Apr 28 16:41:18 pbs-disklab kernel: sd 5:0:1:0: [sdb] Assuming drive cache: write through
Apr 28 16:41:18 pbs-disklab kernel:  end_device-5:1: add: handle(0x000a), sas_addr(0xREDACTED_SAS_ADDR)
Apr 28 16:41:18 pbs-disklab kernel: mpt3sas_cm0: handle(0x000a), ioc_status(0x0022) failure at drivers/scsi/mpt3sas/mpt3sas_transport.c:225/_transport_set_identify()!
Apr 28 16:41:18 pbs-disklab kernel: sd 5:0:1:0: [sdb] Attached SCSI disk
Apr 28 16:41:18 pbs-disklab kernel: mpt3sas_cm0: mpt3sas_transport_port_remove: removed: sas_addr(0xREDACTED_SAS_ADDR)
Apr 28 16:41:18 pbs-disklab kernel: mpt3sas_cm0: removing handle(0x000a), sas_addr(0xREDACTED_SAS_ADDR)
Apr 28 16:41:18 pbs-disklab kernel: mpt3sas_cm0: enclosure logical id(REDACTED_LOGICAL_ID), slot(0)
Apr 28 16:41:18 pbs-disklab kernel: mpt3sas_cm0: enclosure level(0x0000), connector name(     )

and the block device isn't accessible afterwards. It does seem to be visible
after a reboot.

lspci on this host shows:

02:00.0 Serial Attached SCSI controller [0107]: Broadcom / LSI SAS3008 PCI-Express Fusion-MPT SAS-3 [1000:0097] (rev 02)
	Subsystem: Broadcom / LSI SAS9300-8i [1000:30e0]
	Kernel driver in use: mpt3sas
	Kernel modules: mpt3sas

The HBA is placed on a PCIe 3.0 x8 slot (not bifurcated) and connected via
SFF-8643 to a simple 2U 12xLFF SAS3 Supermicro box. The user can also reproduce
the issue with other HBAs with e.g. the SAS3108 and SAS3816 chipsets.

The device doesn't seem to support CDL. So if I see correctly, the only
effective change introduced by the patch are the four scsi_cdl_check_cmd (and
thus scsi_report_opcode) calls to check for CDL support. Hence we wondered
whether may be the cause of the issue. We ran a few tests to verify:

- disabling "REPORT SUPPORTED OPERATION CODES" by passing
  `scsi_mod.dev_flags=WDC:REDACTED_SN:536870912` (the flag being
  BLIST_NO_RSOC) resolves the issue (hotplug works again), but I imagine
  disabling RSOC altogether isn't a good workaround. This test was not done
  on a mainline kernel, but I don't think it would make a difference.

- we patched out the four calls to scsi_cdl_check_cmd and unconditionally set
  cdl_supported to 0, see [2] for the patch (on top of 6.14.4). This resolves
  the issue.

- I suspected that particularly the two latter scsi_cdl_check_cmd calls with a
  nonzero service action might be problematic, so we patched them out
  specifically but kept the other two calls without a service action, see [3]
  for the patch (on top of 6.14.4). But with this patch, hotplug still does
  not work.

- the RSOC commands themselves don't seem to be problematic per se. We asked
  the user to boot a (non-mainline) kernel with the `scsi_mod.dev_flags`
  parameter to disable RSOC as above, hotplug the disk (this succeeds), and
  then query the four opcodes/service actions using `sg_opcodes`, and this
  looks okay [4] (reporting that CDL is not supported).

I wonder whether these results might suggest the RSOC queries are problematic
not in general, but at this particular point (during device initialization) in
this particular hardware setup? If this turns out to be the case -- would it be
feasible to suppress these RSOC queries if CDL is not enabled via sysfs?

If you have any ideas for further troubleshooting, we're happy to gather more
data. I'll be AFK for a few weeks, but Mira (in CC) will take over in the
meantime.

Thanks!

Friedrich

[1] https://kernel.ubuntu.com/mainline/v6.14.4/

[2]

diff --git a/drivers/scsi/scsi.c b/drivers/scsi/scsi.c
index a77e0499b738..022b2f9706a4 100644
--- a/drivers/scsi/scsi.c
+++ b/drivers/scsi/scsi.c
@@ -658,11 +658,7 @@ void scsi_cdl_check(struct scsi_device *sdev)
        }

        /* Check support for READ_16, WRITE_16, READ_32 and WRITE_32 commands */
-       cdl_supported =
-               scsi_cdl_check_cmd(sdev, READ_16, 0, buf) ||
-               scsi_cdl_check_cmd(sdev, WRITE_16, 0, buf) ||
-               scsi_cdl_check_cmd(sdev, VARIABLE_LENGTH_CMD, READ_32, buf) ||
-               scsi_cdl_check_cmd(sdev, VARIABLE_LENGTH_CMD, WRITE_32, buf);
+       cdl_supported = 0;
        if (cdl_supported) {
                /*
                 * We have CDL support: force the use of READ16/WRITE16.

[3]

diff --git a/drivers/scsi/scsi.c b/drivers/scsi/scsi.c
index a77e0499b738..6b0f36f5415e 100644
--- a/drivers/scsi/scsi.c
+++ b/drivers/scsi/scsi.c
@@ -660,9 +660,8 @@ void scsi_cdl_check(struct scsi_device *sdev)
        /* Check support for READ_16, WRITE_16, READ_32 and WRITE_32 commands */
        cdl_supported =
                scsi_cdl_check_cmd(sdev, READ_16, 0, buf) ||
-               scsi_cdl_check_cmd(sdev, WRITE_16, 0, buf) ||
-               scsi_cdl_check_cmd(sdev, VARIABLE_LENGTH_CMD, READ_32, buf) ||
-               scsi_cdl_check_cmd(sdev, VARIABLE_LENGTH_CMD, WRITE_32, buf);
+               scsi_cdl_check_cmd(sdev, WRITE_16, 0, buf);
+       cdl_supported = 0;
        if (cdl_supported) {
                /*
                 * We have CDL support: force the use of READ16/WRITE16.

[4]

root@pbs-disklab:~# sg_opcodes -o 0x88 /dev/sdb

Opcode=0x88
Command_name: Read(16)
Command is supported [conforming to SCSI standard]
No command duration limit mode page
Multiple Logical Units (MLU): not reported
Usage data: 88 fe ff ff ff ff ff ff ff ff ff ff ff ff 00 00

root@pbs-disklab:~# sg_opcodes -o 0x8a /dev/sdb

Opcode=0x8a
Command_name: Write(16)
Command is supported [conforming to SCSI standard]
No command duration limit mode page
Multiple Logical Units (MLU): not reported
Usage data: 8a fa ff ff ff ff ff ff ff ff ff ff ff ff 00 00

root@pbs-disklab:~# sg_opcodes -o 0x7f,0x9 /dev/sdb

Opcode=0x7f  Service_action=0x0009
Command_name: Read(32)
Command is supported [conforming to SCSI standard]
No command duration limit mode page
Multiple Logical Units (MLU): not reported
Usage data: 7f 00 00 00 00 00 00 ff 00 09 fe 00 ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff

root@pbs-disklab:~# sg_opcodes -o 0x7f,0xb /dev/sdb

Opcode=0x7f  Service_action=0x000b
Command_name: Write(32)
Command is supported [conforming to SCSI standard]
No command duration limit mode page
Multiple Logical Units (MLU): not reported
Usage data: 7f 00 00 00 00 00 00 ff 00 0b fa 00 ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff

