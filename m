Received: from proxmox-new.maurer-it.com (proxmox-new.maurer-it.com [94.136.29.106])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0222B145B2C
	for <linux-scsi@vger.kernel.org>; Tue,  4 Jun 2024 12:12:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=94.136.29.106
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717503177; cv=none; b=MdTdfxo6yuJPPtmTxaeeGLZXk/f3i1PNZVeCSrW5CvTsrKBraJvd7GzZyfnIJu825QuCzECnKe8mtK11PSvIuk9mPnFSmiIQqCvRyehEMHH6s719rEdrWTOhOhrZqEHlCmf2pbthRW7rQ4XgPlP790PrYH+K0q1UUcPptaPj854=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717503177; c=relaxed/simple;
	bh=N1PGGLkgNx/Qg5KiueDfowkUExO7LEOOquIjvgNzbdg=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=QlRWJzEaeTSlinsmo9jnN/v+jw3knKoyUyXEp42P5Jj0y6CG6Jn38IZ67VtaCSs5c5yRJB+vP3BQoZNaMpQnAItqpxYexU3GpxmqgJvuEQL0JQ+fgazd46HnGlp1or2bWJz0Jh3n7rN/M7mvE5jHH6GDEvftG7/ejnaluROj4v8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=proxmox.com; spf=pass smtp.mailfrom=proxmox.com; arc=none smtp.client-ip=94.136.29.106
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=proxmox.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=proxmox.com
Received: from proxmox-new.maurer-it.com (localhost.localdomain [127.0.0.1])
	by proxmox-new.maurer-it.com (Proxmox) with ESMTP id ECA4942BDA;
	Tue,  4 Jun 2024 14:12:45 +0200 (CEST)
Message-ID: <449d764e-6e56-43c4-a461-e63a91ab19dc@proxmox.com>
Date: Tue, 4 Jun 2024 14:12:43 +0200
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 02/14] scsi: core: Query VPD size before getting full page
Content-Language: en-US
To: "Martin K. Petersen" <martin.petersen@oracle.com>,
 linux-scsi@vger.kernel.org
Cc: "Maciej W . Rozycki" <macro@orcam.me.uk>
References: <20220302053559.32147-1-martin.petersen@oracle.com>
 <20220302053559.32147-3-martin.petersen@oracle.com>
From: Aaron Lauterer <a.lauterer@proxmox.com>
In-Reply-To: <20220302053559.32147-3-martin.petersen@oracle.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Hi!

On a customer system, we found that after commit

  c92a6b5d63359dd6d2ce6ea88ecd8e31dd769f6b (scsi: core: Query VPD size 
before getting full page)

`qemu-img convert` writing to a certain HDD would be very slow when zero 
blocks are involved. What the commit seems to have changed is make it 
possible to issue `fallocate` calls with 
"FALLOC_FL_KEEP_SIZE|FALLOC_FL_PUNCH_HOLE" flags.
Without the `fallocate` support, it would use an alternative method to 
write out zeroes that is considerably faster.

The question is if allowing `fallocate` in this case is an intentional 
effect of commit c92a6b5d?

The target is an HDD behind a MegaRAID controller configured as JBOD. We 
see the same behavior if LVM is used on top of the disk.

These calls are rather slow on this system, especially when the offset 
is not aligned to 4k.

2 MiB fallocate 4k aligned:
---
root@pve1:~# time fallocate --punch-hole --keep-size -l 2M /dev/sda 
--offset 4M

real    0m0.030s
user    0m0.001s
sys     0m0.000s
---

2 MiB fallocate at 4 MiB - 512 byte:
---
root@pve1:~# time fallocate --punch-hole --keep-size -l 2M /dev/sda 
--offset 4294966784

real    0m0.707s
user    0m0.000s
sys     0m0.001s
---

In our case, `qemu-img convert` introduces a misalignment of -512 bytes 
every 2 GiB because it handles up to INT_MAX (2^31-1) 512 byte sectors 
at a time.
Improving the alignment in `qemu-img convert` is another approach we are 
considering.

During boot (no matter which of the tested kernel versions) we see the 
following log line:
---
Jun 03 15:28:32 pve1 kernel: pci 0000:01:00.0: [Firmware Bug]: disabling 
  VPD access (can't determine size of non-standard VPD format)
---

That PCI address is the controller to which the disk is connected:
---
root@pve1:~# lspci -nnk -s 01:00.0
01:00.0 RAID bus controller [0104]: Broadcom / LSI MegaRAID SAS-3 3008 
[Fury] [1000:005f] (rev 02)
         Subsystem: Broadcom / LSI MegaRAID SAS-3 3008 [Fury] [1000:9343]
         Kernel driver in use: megaraid_sas
         Kernel modules: megaraid_sas
---
The system in question is using a MegaRAID 9341-4i controller with the 
following firmware versions:
FW Package Build = 24.21.0-0159
BIOS Version = 6.36.00.3_4.19.08.00_0x06180206
FW Version = 4.680.01-8576


A test with kernel 6.10-rc2 did show that fallocate support is still 
detected.

I found the following other bug report that looks similar [0] from 
February. But the mentioned patch [1] (if this is the correct one) seems 
to be already included in recent kernel versions.

The sg_vpd info, as was requested in [0] for this system follows. [2]
We checked the output of `sg_vpd -a /dev/sda` and the output does not 
differ between a kernel that allows fallocate and one that doesn't.

If you need additional information or tests, please let me know. I have 
access to the affected system.

Thanks and kind regards,
Aaron

[0] 
https://lore.kernel.org/all/20240210011831.47f55oe67utq2yr7@altlinux.org/T/#mb37c7d063c07d356d11111231fac4c048d7678e5

[1] 
https://lore.kernel.org/linux-scsi/20240214221411.2888112-1-martin.petersen@oracle.com/

[2]
root@pve1:~# sg_readcap -l /dev/sda
Read Capacity results:
    Protection: prot_en=0, p_type=0, p_i_exponent=0
    Logical block provisioning: lbpme=0, lbprz=0
    Last LBA=7814037167 (0x1d1c0beaf), Number of logical blocks=7814037168
    Logical block length=512 bytes
    Logical blocks per physical block exponent=3 [so physical block 
length=4096 bytes]
    Lowest aligned LBA=0
Hence:
    Device size: 4000787030016 bytes, 3815447.8 MiB, 4000.79 GB, 4.00 TB


root@pve1:~# sg_vpd -l /dev/sda
Supported VPD pages VPD page:
    [PQual=0  Peripheral device type: disk]
   0x00  Supported VPD pages [sv]
   0x80  Unit serial number [sn]
   0x83  Device identification [di]
   0x87  Mode page policy [mpp]
   0x89  ATA information (SAT) [ai]
   0x8a  Power condition [pc]
   0xb0  Block limits (SBC) [bl]
   0xb1  Block device characteristics (SBC) [bdc]
   0xb2  Logical block provisioning (SBC) [lbpv]


root@pve1:~# sg_vpd -p 0xb0 /dev/sda
Block limits VPD page (SBC):
   Write same non-zero (WSNZ): 0
   Maximum compare and write length: 0 blocks [Command not implemented]
   Optimal transfer length granularity: 0 blocks [not reported]
   Maximum transfer length: 0 blocks [not reported]
   Optimal transfer length: 0 blocks [not reported]
   Maximum prefetch transfer length: 0 blocks [ignored]
   Maximum unmap LBA count: 0 [Unmap command not implemented]
   Maximum unmap block descriptor count: 0 [Unmap command not implemented]
   Optimal unmap granularity: 0 blocks [not reported]
   Unmap granularity alignment valid: false
   Unmap granularity alignment: 0 [invalid]
   Maximum write same length: 0 blocks [not reported]
   Maximum atomic transfer length: 0 blocks [not reported]
   Atomic alignment: 0 [unaligned atomic writes permitted]
   Atomic transfer length granularity: 0 [no granularity requirement
   Maximum atomic transfer length with atomic boundary: 0 blocks [not 
reported]
   Maximum atomic boundary size: 0 blocks [can only write atomic 1 block]


root@pve1:~# sg_vpd -p 0xb1 /dev/sda
Block device characteristics VPD page (SBC):
   Nominal rotation rate: 7200 rpm
   Product type: Not specified
   WABEREQ=0
   WACEREQ=0
   Nominal form factor: 3.5 inch
   ZONED=0
   RBWZ=0
   BOCS=0
   FUAB=0
   VBULS=0
   DEPOPULATION_TIME=0 (seconds)


root@pve1:~# sg_vpd -p 0xb2 /dev/sda
Logical block provisioning VPD page (SBC):
   Unmap command supported (LBPU): 0
   Write same (16) with unmap bit supported (LBPWS): 0
   Write same (10) with unmap bit supported (LBPWS10): 0
   Logical block provisioning read zeros (LBPRZ): 0
   Anchored LBAs supported (ANC_SUP): 0
   Threshold exponent: 0 [threshold sets not supported]
   Descriptor present (DP): 0
   Minimum percentage: 0 [not reported]
   Provisioning type: 0 (not known or fully provisioned)
   Threshold percentage: 0 [percentages not supported]


On  2022-03-02  06:35, Martin K. Petersen wrote:
> We currently default to 255 bytes when fetching VPD pages during discovery.
> However, we have had a few devices that are known to wedge if the requested
> buffer exceeds a certain size. See commit af73623f5f10 ("[SCSI] sd: Reduce
> buffer size for vpd request") which works around one example of this
> problem in the SCSI disk driver.
> 
> With commit d188b0675b21 ("scsi: core: Add sysfs attributes for VPD pages
> 0h and 89h") we now risk triggering the same issue in the generic midlayer
> code.
> 
> The problem with the ATA VPD page in particular is that the SCSI portion of
> the page is trailed by 512 bytes of verbatim ATA Identify Device
> information.  However, not all controllers actually provide the additional
> 512 bytes and will lock up if one asks for more than the 64 bytes
> containing the SCSI protocol fields.
> 
> Instead of picking a new, somewhat arbitrary, number of bytes for the VPD
> buffer size, start fetching the 4-byte header for each page. The header
> contains the size of the page as far as the device is concerned. We can use
> the reported size to specify the correct allocation length when
> subsequently fetching the full page.
> 
> The header validation is done by a new helper function scsi_get_vpd_size()
> and both scsi_get_vpd_page() and scsi_get_vpd_buf() now rely on this to
> query the page size.
> 
> In addition, scsi_get_vpd_page() is simplified to mirror the logic in
> scsi_get_vpd_page(). This involves removing the Supported VPD Pages lookup
> prior to attempting to query a page. There does not appear any evidence,
> even in the oldest SCSI specs, that this step is required. We already rely
> on scsi_get_vpd_page() throughout the stack and this function never
> consulted the Supported VPD Pages. Since this has not caused any problems
> it should be safe to remove the precondition from scsi_get_vpd_page().
> 
> Instrumented runs also revealed that the Supported VPD Pages lookup had
> little effect since the device page index often was larger than the
> supplied buffer size. As a result, inquiries frequently bypassed the index
> check and went through the "If we ran off the end of the buffer, give us
> the benefit of the doubt" code path which assumed the page was present
> despite not being listed. The revised code takes both the page size
> reported by the device as well as the size of the buffer provided by the
> scsi_get_vpd_page() caller into account.
> 
> Fixes: d188b0675b21 ("scsi: core: Add sysfs attributes for VPD pages 0h and 89h")
> Reported-by: Maciej W. Rozycki <macro@orcam.me.uk>
> Tested-by: Maciej W. Rozycki <macro@orcam.me.uk>
> Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>

