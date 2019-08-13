Return-Path: <SRS0=/G9W=WJ=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=0.2 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED,USB_DRIVES autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 396D1C32750
	for <linux-scsi@archiver.kernel.org>; Tue, 13 Aug 2019 20:59:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0CB7120840
	for <linux-scsi@archiver.kernel.org>; Tue, 13 Aug 2019 20:59:03 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=lucidpixels.com header.i=@lucidpixels.com header.b="RwjDgHIB"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726373AbfHMU67 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 13 Aug 2019 16:58:59 -0400
Received: from mail-oi1-f173.google.com ([209.85.167.173]:44504 "EHLO
        mail-oi1-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726066AbfHMU66 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 13 Aug 2019 16:58:58 -0400
Received: by mail-oi1-f173.google.com with SMTP id k22so676049oiw.11
        for <linux-scsi@vger.kernel.org>; Tue, 13 Aug 2019 13:58:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=lucidpixels.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=VLXSFRnf/VIzQ21AcmSK772oG4DlhLGeRGOKcwe7z2Y=;
        b=RwjDgHIBooTMtsgMMMv7jZGN7mBlZ1nzEENknrebjwK9A6Wp6aUeAHB1auBdMY68VA
         Tji92esv4uo8l5MCJ1BP+2/nW2CAjQNhhWztMtyYpCOmGt+A4E9wEAhQUXYAkxe0EB04
         t8K5QC/AwYNiOGiB8eVzxFSiQo1JBhxcKwuQI=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=VLXSFRnf/VIzQ21AcmSK772oG4DlhLGeRGOKcwe7z2Y=;
        b=KZnsmShSAgamrznP3qql/vsHplm1IAO2qdySDKgh8LtDBygFDrDXRIwBQ817U77Gcu
         fUKOooRlWhdRUMKsFa/BJQ2NqoVU74aXiI7GaPE2B8oJq2X5s20tqKzu1Ol7UtpMkedJ
         miTeBGDOloN2zJS9tsad5NQN4TIC/RllmjUF4x4dg5F5pfd37LB6q4vdeYxBB0kfSp/2
         jOgVjr9b6lGNAv8TVwB6Z1RcgH/NDDlsYPwJTXB0xdroEaIHjk3LLf2DYuLS9Nyj+qXG
         XyDojV/K8OHBenJ8Q3+AqQCzZnQWttBHqj+UseFhBfU+t1d7P/CAk9ZeNLQ/nRFEy/a3
         iiBw==
X-Gm-Message-State: APjAAAVmG2AMjP9cKcAnEI1u58SyXJXrZpAp0aDESqOdyTtxzQ9+bU0r
        PT0jaPPvQPg8oh3a+L71U9KJZ2MmCTL2dXMpRKXYmQ==
X-Google-Smtp-Source: APXvYqwT9kvM1vnuNFGjd4qoVslPyJL8Ssw80+EBOGlrtoa0kEl6HdgrfAcXq6R3Lzz2qlWEvzcuAzUCWlqlYvNUaPc=
X-Received: by 2002:aca:1109:: with SMTP id 9mr2984466oir.100.1565729936999;
 Tue, 13 Aug 2019 13:58:56 -0700 (PDT)
MIME-Version: 1.0
References: <006d01d549db$54e42140$feac63c0$@lucidpixels.com>
 <yq1ftmcct1j.fsf@oracle.com> <002d01d54dc3$17c278c0$47476a40$@lucidpixels.com>
 <yq1r25p7qzp.fsf@oracle.com> <BYAPR04MB58166DE7AFE1081CEDF674BDE7D20@BYAPR04MB5816.namprd04.prod.outlook.com>
In-Reply-To: <BYAPR04MB58166DE7AFE1081CEDF674BDE7D20@BYAPR04MB5816.namprd04.prod.outlook.com>
From:   Justin Piszcz <jpiszcz@lucidpixels.com>
Date:   Tue, 13 Aug 2019 16:58:46 -0400
Message-ID: <CAO9zADxursoc-tLjhCdJauzw4t_kokgOyg0kHC8b9kaBH8oUqA@mail.gmail.com>
Subject: Re: 5.2.x kernel: WD 8TB USB Drives: Unaligned partial completion
 (resid=78, sector_sz=512)
To:     Damien Le Moal <Damien.LeMoal@wdc.com>
Cc:     "Martin K. Petersen" <martin.petersen@oracle.com>,
        LKML <linux-kernel@vger.kernel.org>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Tue, Aug 13, 2019 at 6:48 AM Damien Le Moal <Damien.LeMoal@wdc.com> wrote:
>
> On 2019/08/12 19:12, Martin K. Petersen wrote:
> >
> > Justin,
> >
> >>> Attached 2 x brand new Western Digital 8TB USB 3.0 drives awhile back
> >>> and ran some file copy tests and was getting these warnings-- is
> >>> there any way to avoid these warnings?  I did confirm with parted
> >>> that the partition was aligned but this appears to be something
> >>> related to the firmware on the device according to [1] and [2]?
> >
> >> sg_vpd_bdc.txt
> >> Block device characteristics VPD page (SBC):
> >>   Nominal rotation rate: 5400 rpm
> >>   Product type: Not specified
> >>   WABEREQ=0
> >>   WACEREQ=0
> >>   Nominal form factor: 3.5 inch
> >>   ZONED=0
> >
> > Damien: What can we do to limit the messages in cases like this? Would
> > it make sense to make the residual warning conditional on sd_is_zoned()?
> >
>
> Justin,
>
> Can you send the output of "lsscsi" for these drives ? I need the exact disk
> model ref name and FW version to see if there is an update for this problem, if
> it is a known one. If it is not, I will signal it and get a fix started.
>

Requested lsscsi output:


[7:0:0:0]    disk    WD       My Book 25EE     4004  /dev/sdf
[7:0:0:1]    enclosu WD       SES Device       4004  -
[8:0:0:0]    disk    WD       My Book 25EE     4004  /dev/sdg
[8:0:0:1]    enclosu WD       SES Device       4004  -

Host: scsi7 Channel: 00 Target: 00 Lun: 00
  Vendor: WD       Model: My Book 25EE     Rev: 4004
  Type:   Direct-Access                    ANSI SCSI revision: 06
Host: scsi7 Channel: 00 Target: 00 Lun: 01
  Vendor: WD       Model: SES Device       Rev: 4004
  Type:   Enclosure                        ANSI SCSI revision: 06
Host: scsi8 Channel: 00 Target: 00 Lun: 00
  Vendor: WD       Model: My Book 25EE     Rev: 4004
  Type:   Direct-Access                    ANSI SCSI revision: 06
Host: scsi8 Channel: 00 Target: 00 Lun: 01
  Vendor: WD       Model: SES Device       Rev: 4004
  Type:   Enclosure                        ANSI SCSI revision: 06

[7:0:0:0]    disk    WD       My Book 25EE     4004  /dev/sdf
  state=running queue_depth=1 scsi_level=7 type=0 device_blocked=0 timeout=30
[7:0:0:1]    enclosu WD       SES Device       4004  -
  state=running queue_depth=1 scsi_level=7 type=13 device_blocked=0 timeout=30
[8:0:0:0]    disk    WD       My Book 25EE     4004  /dev/sdg
  state=running queue_depth=1 scsi_level=7 type=0 device_blocked=0 timeout=30
[8:0:0:1]    enclosu WD       SES Device       4004  -
  state=running queue_depth=1 scsi_level=7 type=13 device_blocked=0 timeout=30

[7:0:0:0]    disk    none                              /dev/sdf
[7:0:0:1]    enclosu 5000cca252e63312  -
[8:0:0:0]    disk    none                              /dev/sdg
[8:0:0:1]    enclosu 5000cca252e6a2f9  -

[7:0:0:0]    disk    WD       My Book 25EE     4004  /dev/sdf   8.00TB
[7:0:0:1]    enclosu WD       SES Device       4004  -               -
[8:0:0:0]    disk    WD       My Book 25EE     4004  /dev/sdg   8.00TB
[8:0:0:1]    enclosu WD       SES Device       4004  -               -


[7:0:0:0]    disk    usb:1-1.2:1.0                   /dev/sdf
[7:0:0:1]    enclosu usb:1-1.2:1.0                   -
[8:0:0:0]    disk    usb:1-1.1:1.0                   /dev/sdg
[8:0:0:1]    enclosu usb:1-1.1:1.0                   -

# smartctl -a /dev/sdg
/dev/sdg: Unknown USB bridge [0x1058:0x25ee (0x4004)]

# smartctl -a /dev/sdf
/dev/sdf: Unknown USB bridge [0x1058:0x25ee (0x4004)]

Regards,

Justin.
