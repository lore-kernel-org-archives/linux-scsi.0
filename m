From: Tom Yan <tom.ty89@gmail.com>
Subject: Re: [PATCH 1/1] sd: do not let LBPME bit stop the VPDs speak
Date: Wed, 9 Mar 2016 11:30:58 +0800
Message-ID: <CAGnHSEnLA+WRMuPCLHc=U5m6M5XG-CGbP4gcmh4WJ9QeWwDm0A@mail.gmail.com>
References: <56df97e0.d08d420a.58e8f.3162@mx.google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-yw0-f195.google.com ([209.85.161.195]:33672 "EHLO
	mail-yw0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750898AbcCIDnG (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 8 Mar 2016 22:43:06 -0500
Received: by mail-yw0-f195.google.com with SMTP id g6so1933265ywb.0
        for <linux-scsi@vger.kernel.org>; Tue, 08 Mar 2016 19:43:06 -0800 (PST)
In-Reply-To: <56df97e0.d08d420a.58e8f.3162@mx.google.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Example device, JMicron JMS567 UAS SATA bridge:

[tom@localhost ~]$ sudo sg_readcap -16 /dev/sdc
Read Capacity results:
   Protection: prot_en=0, p_type=0, p_i_exponent=0
   Logical block provisioning: lbpme=0, lbprz=0
   Last logical block address=468862127 (0x1bf244af), Number of
logical blocks=468862128
   Logical block length=512 bytes
   Logical blocks per physical block exponent=3 [so physical block
length=4096 bytes]
   Lowest aligned logical block address=0
Hence:
   Device size: 240057409536 bytes, 228936.6 MiB, 240.06 GB

[tom@localhost ~]$ sudo sg_vpd -a /dev/sdc
Supported VPD pages VPD page:
  Supported VPD pages [sv]
  Unit serial number [sn]
  Device identification [di]
  Block limits (SBC) [bl]
  Logical block provisioning (SBC) [lbpv]
Unit serial number VPD page:
  Unit serial number: 1504380500000432
Device Identification VPD page:
  Addressed logical unit:
    designator type: NAA,  code set: Binary
      0x3015043805000004
    designator type: T10 vendor identification,  code set: ASCII
      vendor id: JMicron
      vendor specific: Generic         1504380500000432
Block limits VPD page (SBC):
  Write same non-zero (WSNZ): 0
  Maximum compare and write length: 0 blocks
  Optimal transfer length granularity: 8 blocks
  Maximum transfer length: 65535 blocks
  Optimal transfer length: 65535 blocks
  Maximum prefetch length: 65535 blocks
  Maximum unmap LBA count: 65472
  Maximum unmap block descriptor count: 1
  Optimal unmap granularity: 1
  Unmap granularity alignment valid: 0
  Unmap granularity alignment: 0
  Maximum write same length: 0x0 blocks
  Maximum atomic transfer length: 0
  Atomic alignment: 0
  Atomic transfer length granularity: 0
  Maximum atomic transfer length with atomic boundary: 0
  Maximum atomic boundary size: 0
Logical block provisioning VPD page (SBC):
  Unmap command supported (LBPU): 1
  Write same (16) with unmap bit supported (LBWS): 0
  Write same (10) with unmap bit supported (LBWS10): 0
  Logical block provisioning read zeros (LBPRZ): 0
  Anchored LBAs supported (ANC_SUP): 0
  Threshold exponent: 1
  Descriptor present (DP): 0
  Minimum percentage: 0
  Provisioning type: 0
  Threshold percentage: 0

On 9 March 2016 at 11:26,  <tom.ty89@gmail.com> wrote:
> From: Tom Yan <tom.ty89@gmail.com>
>
> Some devices have details of their support on unmapping on the
> Block Limits and/or Logical Block Provisioning VPDs while they
> do not set the LBPME bit to 1. Though this is required by the
> SCSI standards, the VPDs are giving even more concrete details
> about the support, so they should be used even when the bit
> is set to 0.
>
> Signed-off-by: Tom Yan <tom.ty89@gmail.com>
>
> diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
> index d749da7..a0d7c73 100644
> --- a/drivers/scsi/sd.c
> +++ b/drivers/scsi/sd.c
> @@ -2670,9 +2670,6 @@ static void sd_read_block_limits(struct scsi_disk *sdkp)
>
>                 sdkp->max_ws_blocks = (u32)get_unaligned_be64(&buffer[36]);
>
> -               if (!sdkp->lbpme)
> -                       goto out;
> -
>                 lba_count = get_unaligned_be32(&buffer[20]);
>                 desc_count = get_unaligned_be32(&buffer[24]);
>
> @@ -2747,9 +2744,6 @@ static void sd_read_block_provisioning(struct scsi_disk *sdkp)
>         unsigned char *buffer;
>         const int vpd_len = 8;
>
> -       if (sdkp->lbpme == 0)
> -               return;
> -
>         buffer = kmalloc(vpd_len, GFP_KERNEL);
>
>         if (!buffer || scsi_get_vpd_page(sdkp->device, 0xb2, buffer, vpd_len))
> --
> 2.7.2
>
