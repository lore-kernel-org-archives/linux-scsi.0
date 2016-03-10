From: Tom Yan <tom.ty89@gmail.com>
Subject: Fwd: [PATCH 1/1] sd: do not let LBPME bit stop the VPDs speak
Date: Thu, 10 Mar 2016 16:15:57 +0800
Message-ID: <CAGnHSEmNreG1X78TU9RSO9UyuOPr=1urCbL-EWe7S9Q=tC8wcQ@mail.gmail.com>
References: <56df97e0.d08d420a.58e8f.3162@mx.google.com>
	<CAGnHSEnLA+WRMuPCLHc=U5m6M5XG-CGbP4gcmh4WJ9QeWwDm0A@mail.gmail.com>
	<CAGnHSE=Ct7vFas3K-DDwU68W+R=ADx7Tx36LBBk3gxeDFZG3Ow@mail.gmail.com>
	<yq1io0vqd0e.fsf@sermon.lab.mkp.net>
	<CAGnHSEng46jz66wkhiA73vvgfFzNx+3R4WeBLbyBrhD5UR6NBw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-yk0-f194.google.com ([209.85.160.194]:34502 "EHLO
	mail-yk0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752681AbcCJIP7 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 10 Mar 2016 03:15:59 -0500
Received: by mail-yk0-f194.google.com with SMTP id w83so2062047ykf.1
        for <linux-scsi@vger.kernel.org>; Thu, 10 Mar 2016 00:15:58 -0800 (PST)
In-Reply-To: <CAGnHSEng46jz66wkhiA73vvgfFzNx+3R4WeBLbyBrhD5UR6NBw@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Hmm, is it originated from:

(2^32-1) - (2^32-1)%512 = 4294966784 bytes = 8388607 (512-byte) blocks
= 0x7fffff

for the byte count (of a bio?) is limited by a 32-bit representation
(2^32-1) as well just like the block count in the two scsi commands?

What about SD_MAX_XFER_BLOCKS then?

On 10 March 2016 at 10:32, Martin K. Petersen
<martin.petersen@oracle.com> wrote:
>>>>>> "Tom" == Tom Yan <tom.ty89@gmail.com> writes:
>
> Tom> Btw, why SD_MAX_WS16_BLOCKS (which is used for both SD_LBP_WS16 and
> Tom> SD_LBP_UNMAP) is set to 0x7fffff (23-bit) instead of 0xffffffff
> Tom> (32-bit, 4-byte)?
>
> This limit represents the largest block range we can describe using a
> single bio.
>
> --
> Martin K. Petersen      Oracle Linux Engineering
