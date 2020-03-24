Return-Path: <SRS0=zrch=5J=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 00954C43331
	for <linux-scsi@archiver.kernel.org>; Tue, 24 Mar 2020 13:49:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id BE160206F6
	for <linux-scsi@archiver.kernel.org>; Tue, 24 Mar 2020 13:49:52 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="VSMlJZD+"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727468AbgCXNtw (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 24 Mar 2020 09:49:52 -0400
Received: from us-smtp-delivery-74.mimecast.com ([63.128.21.74]:47186 "EHLO
        us-smtp-delivery-74.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727384AbgCXNtw (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 24 Mar 2020 09:49:52 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1585057790;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=ECLh7HfTZ/bNu6zgzf5pTV4jqh6yXmjQ8900fO31hZw=;
        b=VSMlJZD+AFAmsXBY6JgbQc6NwgmUWs2OnYLQJynGE1D5tst4K1j4c8RBNM+wnTuInUnS3c
        90qfdZg2MIwqC1l4n2VcOCoZLeZszG5gcAesvP5wRO2qrMhnjcyH0WMDKXhuU/JvIZWjSu
        Kl9I6dSQjqGNGsfd3/MTrJEAeQq0LVs=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-168-wsahTCaUPtS5aseDAw_d0A-1; Tue, 24 Mar 2020 09:49:49 -0400
X-MC-Unique: wsahTCaUPtS5aseDAw_d0A-1
Received: by mail-wm1-f72.google.com with SMTP id y1so1243350wmj.3
        for <linux-scsi@vger.kernel.org>; Tue, 24 Mar 2020 06:49:48 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ECLh7HfTZ/bNu6zgzf5pTV4jqh6yXmjQ8900fO31hZw=;
        b=HH3wg54pEGi70pY4nVCNHu9mSeLtITUz5i5O7RhmLALhFPv1jRIZMswjEmAlDgRbx5
         GtCi7KHga+YKmKG+7gRNYBcRaUsR8jJUoHSjWwvjj02vf37+WzaBvln5/56C6DXRPPeU
         DGwAp1Dd00IYmibsM9+xeOcOt3LuVl29nttnMmvIjqRpEoIbgzurNQiXGJtoVvxcpbN5
         9XENG8FqMcm6G1KslynpilBSvuoOLmRQkRXzlCAGjkRIhJxWGuHrwuz5+UhnSh10yRJH
         76J/Fn0hAsLKC+oaQlAU1IxmRj6ii3cn7PMLD4XyfYlYXzUi3xkfFryoS6e6z/GKE2/o
         ijLA==
X-Gm-Message-State: ANhLgQ3sErlOwjlXa0pSgBtZrQQzYbp3Fs/wSdi+ktklQCdvxCAoSbLz
        oSTm1jEh5vxpAkZaFbVKQ/M9MkWjtrX8ZvefyGiFIjK+kyOBJViMOpbDcEgey85uGRIqEomUZof
        XXcAODfhbqafk3OJCdC7LK+/MjKF1PGbm1CXSNw==
X-Received: by 2002:a1c:ac88:: with SMTP id v130mr5897925wme.34.1585057787555;
        Tue, 24 Mar 2020 06:49:47 -0700 (PDT)
X-Google-Smtp-Source: ADFU+vs+4ZBpvvKxzFbh8/9uU/e8h1PRzLeFWP4k+yrjAb+79bpv52O6qYHH56z2okyq8oYJO1to9DvFUJkSWsdjdqI=
X-Received: by 2002:a1c:ac88:: with SMTP id v130mr5897893wme.34.1585057787210;
 Tue, 24 Mar 2020 06:49:47 -0700 (PDT)
MIME-Version: 1.0
References: <33fb522e-4f61-1b76-914f-c9e6a3553c9b@gmail.com>
 <yq1o8sowfzn.fsf@oracle.com> <accd7d25-ee35-11b9-e49b-76e20d9550f2@gmail.com>
 <yq1pnd4tbxm.fsf@oracle.com> <1eb896cd-2be1-4225-88d8-5ee590fe063b@gmail.com>
 <yq1eetkrtf6.fsf@oracle.com> <58904bc3-4186-7f9c-dc3c-707aa3d92bfb@gmail.com>
 <46035460-9d63-2a9a-d37b-514640f8732f@gmail.com> <yq14kugrou0.fsf@oracle.com>
 <44de25f9-2d57-e90d-7773-b060ccd55358@gmail.com> <yq1v9mwq82t.fsf@oracle.com>
 <4f6eb89d-57e4-a229-2e95-29fe4a691381@gmail.com> <yq1blonrgoo.fsf@oracle.com>
In-Reply-To: <yq1blonrgoo.fsf@oracle.com>
From:   Bryan Gurney <bgurney@redhat.com>
Date:   Tue, 24 Mar 2020 09:49:36 -0400
Message-ID: <CAHhmqcSL9UNGv3-4zdh-XaCYq1e6w36rZbJVTEnmaR36=FUawQ@mail.gmail.com>
Subject: Re: Invalid optimal transfer size 33553920 accepted when
 physical_block_size 512
To:     "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     Bernhard Sulzer <micraft.b@gmail.com>, linux-scsi@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Sun, Mar 22, 2020 at 9:43 PM Martin K. Petersen
<martin.petersen@oracle.com> wrote:
>
>
> Bernhard,
>
> > There does not seem to be a change in capaticy detected - you got a
> > almost complete section of dmesg from me. Anyway, here's the whole
> > thing after plugging in:
>
> OK, got a workaround. Will send tomorrow.
>

Hi Martin,

I might be able to help test this, as I have a USB drive enclosure
that is exhibiting the same kernel message of "Optimal transfer size
33553920 bytes not a multiple of physical block size (4096 bytes)".  I
noticed this as I was using the enclosure to random overwrite a batch
of old drives, and I started seeing that message in a terminal running
"journalctl -kf" after I had connected a couple of Advanced Format
(4096 byte physical, 512 byte logical) drives.

Here's an example of the USB enclosure with a 512e drive plugged in:

$ sudo sg_inq /dev/sdc
standard INQUIRY:
  PQual=0  Device_type=0  RMB=0  LU_CONG=0  version=0x06  [SPC-4]
  [AERC=0]  [TrmTsk=0]  NormACA=0  HiSUP=0  Resp_data_format=2
  SCCS=0  ACC=0  TPGS=0  3PC=0  Protect=0  [BQue=0]
  EncServ=0  MultiP=0  [MChngr=0]  [ACKREQQ=0]  Addr16=0
  [RelAdr=0]  WBus16=0  Sync=0  [Linked=0]  [TranDis=0]  CmdQue=1
  [SPI: Clocking=0x0  QAS=0  IUS=0]
    length=76 (0x4c)   Peripheral device type: disk
 Vendor identification: TOSHIBA
 Product identification: MK1059GSM
 Product revision level: 0
 Unit serial number: 1000000000CA

$ sudo sg_readcap -16 /dev/sdc
Read Capacity results:
   Protection: prot_en=0, p_type=0, p_i_exponent=0
   Logical block provisioning: lbpme=0, lbprz=0
   Last logical block address=1953525167 (0x74706daf), Number of
logical blocks=1953525168
   Logical block length=512 bytes
   Logical blocks per physical block exponent=3 [so physical block
length=4096 bytes]
   Lowest aligned logical block address=0
Hence:
   Device size: 1000204886016 bytes, 953869.7 MiB, 1000.20 GB
$ sudo sg_readcap -H -16 /dev/sdc
 00     00 00 00 00 74 70 6d af  00 00 02 00 00 03 00 00
 10     00 00 00 00 00 00 00 00  00 00 00 00 00 00 00 00

$ sudo sg_vpd -p 0xb0 /dev/sdc
Block limits VPD page (SBC):
  Write same non-zero (WSNZ): 0
  Maximum compare and write length: 0 blocks
  Optimal transfer length granularity: 8 blocks
  Maximum transfer length: 65535 blocks
  Optimal transfer length: 65535 blocks
  Maximum prefetch length: 65535 blocks
  Maximum unmap LBA count: 0
  Maximum unmap block descriptor count: 0
  Optimal unmap granularity: 0
  Unmap granularity alignment valid: 0
  Unmap granularity alignment: 0
  Maximum write same length: 0x0 blocks
  Maximum atomic transfer length: 0
  Atomic alignment: 0
  Atomic transfer length granularity: 0
  Maximum atomic transfer length with atomic boundary: 0
  Maximum atomic boundary size: 0
$ sudo sg_vpd -H -p 0xb0 /dev/sdc
Block limits VPD page (SBC):
 00     00 b0 00 3c 00 00 00 08  00 00 ff ff 00 00 ff ff    ...<............
 10     00 00 ff ff 00 00 00 00  00 00 00 00 00 00 00 00    ................
 20     00 00 00 00 00 00 00 00  00 00 00 00 00 00 00 00    ................
 30     00 00 00 00 00 00 00 00  00 00 00 00 00 00 00 00    ................

...and here's the same drive, plugged in directly to a Serial ATA port
on the mainboard:

$ sudo sg_inq /dev/sdb
standard INQUIRY:
  PQual=0  Device_type=0  RMB=0  LU_CONG=0  version=0x05  [SPC-3]
  [AERC=0]  [TrmTsk=0]  NormACA=0  HiSUP=0  Resp_data_format=2
  SCCS=0  ACC=0  TPGS=0  3PC=0  Protect=0  [BQue=0]
  EncServ=0  MultiP=0  [MChngr=0]  [ACKREQQ=0]  Addr16=0
  [RelAdr=0]  WBus16=0  Sync=0  [Linked=0]  [TranDis=0]  CmdQue=1
  [SPI: Clocking=0x0  QAS=0  IUS=0]
    length=96 (0x60)   Peripheral device type: disk
 Vendor identification: ATA
 Product identification: TOSHIBA MK1059GS
 Product revision level: 1U
 Unit serial number:            91GCPH6RT

$ sudo sg_readcap -16 /dev/sdb
Read Capacity results:
   Protection: prot_en=0, p_type=0, p_i_exponent=0
   Logical block provisioning: lbpme=0, lbprz=0
   Last logical block address=1953525167 (0x74706daf), Number of
logical blocks=1953525168
   Logical block length=512 bytes
   Logical blocks per physical block exponent=3 [so physical block
length=4096 bytes]
   Lowest aligned logical block address=0
Hence:
   Device size: 1000204886016 bytes, 953869.7 MiB, 1000.20 GB
$ sudo sg_readcap -H -16 /dev/sdb
 00     00 00 00 00 74 70 6d af  00 00 02 00 00 03 00 00
 10     00 00 00 00 00 00 00 00  00 00 00 00 00 00 00 00

$ sudo sg_vpd -p 0xb0 /dev/sdb
Block limits VPD page (SBC):
  Write same non-zero (WSNZ): 0
  Maximum compare and write length: 0 blocks
  Optimal transfer length granularity: 8 blocks
  Maximum transfer length: 0 blocks
  Optimal transfer length: 0 blocks
  Maximum prefetch length: 0 blocks
  Maximum unmap LBA count: 0
  Maximum unmap block descriptor count: 0
  Optimal unmap granularity: 0
  Unmap granularity alignment valid: 0
  Unmap granularity alignment: 0
  Maximum write same length: 0x0 blocks
  Maximum atomic transfer length: 0
  Atomic alignment: 0
  Atomic transfer length granularity: 0
  Maximum atomic transfer length with atomic boundary: 0
  Maximum atomic boundary size: 0
$ sudo sg_vpd -H -p 0xb0 /dev/sdb
Block limits VPD page (SBC):
 00     00 b0 00 3c 00 00 00 08  00 00 00 00 00 00 00 00    ...<............
 10     00 00 00 00 00 00 00 00  00 00 00 00 00 00 00 00    ................
 20     00 00 00 00 00 00 00 00  00 00 00 00 00 00 00 00    ................
 30     00 00 00 00 00 00 00 00  00 00 00 00 00 00 00 00    ................


Thanks,

Bryan

