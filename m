Return-Path: <SRS0=mSyi=4B=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.0 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 90D6DC3B189
	for <linux-scsi@archiver.kernel.org>; Thu, 13 Feb 2020 21:10:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 52DBB24670
	for <linux-scsi@archiver.kernel.org>; Thu, 13 Feb 2020 21:10:31 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=wizzup.org header.i=@wizzup.org header.b="c4lAL5sT"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728100AbgBMVK2 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 13 Feb 2020 16:10:28 -0500
Received: from a80-127-99-228.adsl.xs4all.nl ([80.127.99.228]:51610 "EHLO
        hetgrotebos.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727705AbgBMVK1 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 13 Feb 2020 16:10:27 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=wizzup.org;
         s=mail; h=Content-Type:In-Reply-To:MIME-Version:Date:Message-ID:From:
        References:Cc:To:Subject:Sender:Reply-To:Content-Transfer-Encoding:Content-ID
        :Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:
        Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe
        :List-Post:List-Owner:List-Archive;
        bh=4gojb3BfFcxJOeoqlbsxb4brCvYi43S2aCFYxrKefRA=; b=c4lAL5sTTQDVp+aLDlEJQCFfE9
        5UVvFss3fMBHjH+54M6Q79jCQPtSvoiESRHLG5yscImqV+jxzfk/rEbZmPw82Ki6n4ZW/VG+i8GKs
        yQxcMGikNgm8IjRWuqDiTadMElfgbpun1HBVxxYrAj+tmcHrv5x9tznY4TqvSLkxMnM7EBfudmgdY
        KWQLNM4ZAR0GuiXL3BZDffQdcWR4U/uZFYa0wbZkHpN5HN9QgenGbGllvEFpZPZytrC9zcZ4ObYXx
        xSoUkv+o+ykFNEQZXYdo42RnLl1wyoKmgXwROQxXTnWACx/cqoyT4XNAdZ7bE9q9i6jq/I9HOvDyN
        +G4Fyj0w==;
Received: from deepwater.fritz.box ([192.168.178.25] helo=[0.0.0.0])
        by hetgrotebos.org with esmtpsa  (TLS1.3) tls TLS_AES_128_GCM_SHA256
        (Exim 4.93)
        (envelope-from <merlijn@wizzup.org>)
        id 1j2Lke-0002LM-6n; Thu, 13 Feb 2020 21:10:24 +0000
Subject: Re: [RFC PATCH] scsi: sr: get rid of sr global mutex
To:     linux-scsi@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Arnd Bergmann <arnd@arndb.de>, linux-kernel@vger.kernel.org
References: <20200212164445.1171-1-merlijn@wizzup.org>
From:   Merlijn Wajer <merlijn@wizzup.org>
Autocrypt: addr=merlijn@wizzup.org; prefer-encrypt=mutual; keydata=
 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
 /XslHw==
Message-ID: <d4089af4-916d-9c29-786b-629506ff9031@wizzup.org>
Date:   Thu, 13 Feb 2020 22:11:26 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.0
MIME-Version: 1.0
In-Reply-To: <20200212164445.1171-1-merlijn@wizzup.org>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="cOpIReCRqUS0dM2IAW7xUvgdsrVnd7PzM"
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--cOpIReCRqUS0dM2IAW7xUvgdsrVnd7PzM
Content-Type: multipart/mixed; boundary="MtmV2JiIiLWTCnfRuGBzZNZaAQ1iEVVGs"

--MtmV2JiIiLWTCnfRuGBzZNZaAQ1iEVVGs
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
Content-Transfer-Encoding: quoted-printable

Hi,

I was wondering if or what changes the maintainers would like me to make
in order to get this merged.

This regression was introduced back in 2010 and it recently took me just
under a week to find the root cause. The Internet Archive is digitising
hundreds of thousands of CDs, in an effort to preserve whatever is on
those CDs, and not being able to digitise more than one CD per machine
is a real pain.

My hope is that once I can massage the patch into something that can be
approved, we can also send the patch to the various stable trees.

Digging through some old email threads I also found a suggestion to move
the lock instead to the cdrom device. Would that be preferred to having
the lock per sr instance?

Merlijn

On 12/02/2020 17:44, Merlijn Wajer wrote:
> When replacing the Big Kernel Lock in commit:
> <2a48fc0ab24241755dc93bfd4f01d68efab47f5a> ("block: autoconvert trivial=
 BKL
> users to private mutex") , the lock was replaced with a sr-wide lock.
>=20
> This causes very poor performance when using multiple sr devices, as th=
e
> sr driver was not able to execute more than one command to one drive at=

> any given time, even when there were many CD drives available.
>=20
> Replace the global mutex with per-sr-device mutex.
>=20
> Someone tried this patch at the time, but it never made it
> upstream, due to possible concerns with race conditions, but it's not
> clear the patch actually caused those:
>=20
> https://www.spinics.net/lists/linux-scsi/msg63706.html
> https://www.spinics.net/lists/linux-scsi/msg63750.html
>=20
> Also see
>=20
> http://lists.xiph.org/pipermail/paranoia/2019-December/001647.html
>=20
> Signed-off-by: Merlijn Wajer <merlijn@wizzup.org>
> ---
>  drivers/scsi/sr.c | 16 +++++++++-------
>  drivers/scsi/sr.h |  2 ++
>  2 files changed, 11 insertions(+), 7 deletions(-)
>=20
> diff --git a/drivers/scsi/sr.c b/drivers/scsi/sr.c
> index 38ddbbfe5..6809fdcfd 100644
> --- a/drivers/scsi/sr.c
> +++ b/drivers/scsi/sr.c
> @@ -77,7 +77,6 @@ MODULE_ALIAS_SCSI_DEVICE(TYPE_WORM);
>  	 CDC_CD_R|CDC_CD_RW|CDC_DVD|CDC_DVD_R|CDC_DVD_RAM|CDC_GENERIC_PACKET|=
 \
>  	 CDC_MRW|CDC_MRW_W|CDC_RAM)
> =20
> -static DEFINE_MUTEX(sr_mutex);
>  static int sr_probe(struct device *);
>  static int sr_remove(struct device *);
>  static blk_status_t sr_init_command(struct scsi_cmnd *SCpnt);
> @@ -535,9 +534,9 @@ static int sr_block_open(struct block_device *bdev,=
 fmode_t mode)
>  	scsi_autopm_get_device(sdev);
>  	check_disk_change(bdev);
> =20
> -	mutex_lock(&sr_mutex);
> +	mutex_lock(&cd->lock);
>  	ret =3D cdrom_open(&cd->cdi, bdev, mode);
> -	mutex_unlock(&sr_mutex);
> +	mutex_unlock(&cd->lock);
> =20
>  	scsi_autopm_put_device(sdev);
>  	if (ret)
> @@ -550,10 +549,10 @@ static int sr_block_open(struct block_device *bde=
v, fmode_t mode)
>  static void sr_block_release(struct gendisk *disk, fmode_t mode)
>  {
>  	struct scsi_cd *cd =3D scsi_cd(disk);
> -	mutex_lock(&sr_mutex);
> +	mutex_lock(&cd->lock);
>  	cdrom_release(&cd->cdi, mode);
>  	scsi_cd_put(cd);
> -	mutex_unlock(&sr_mutex);
> +	mutex_unlock(&cd->lock);
>  }
> =20
>  static int sr_block_ioctl(struct block_device *bdev, fmode_t mode, uns=
igned cmd,
> @@ -564,7 +563,7 @@ static int sr_block_ioctl(struct block_device *bdev=
, fmode_t mode, unsigned cmd,
>  	void __user *argp =3D (void __user *)arg;
>  	int ret;
> =20
> -	mutex_lock(&sr_mutex);
> +	mutex_lock(&cd->lock);
> =20
>  	ret =3D scsi_ioctl_block_when_processing_errors(sdev, cmd,
>  			(mode & FMODE_NDELAY) !=3D 0);
> @@ -594,7 +593,7 @@ static int sr_block_ioctl(struct block_device *bdev=
, fmode_t mode, unsigned cmd,
>  	scsi_autopm_put_device(sdev);
> =20
>  out:
> -	mutex_unlock(&sr_mutex);
> +	mutex_unlock(&cd->lock);
>  	return ret;
>  }
> =20
> @@ -700,6 +699,7 @@ static int sr_probe(struct device *dev)
>  	disk =3D alloc_disk(1);
>  	if (!disk)
>  		goto fail_free;
> +	mutex_init(&cd->lock);
> =20
>  	spin_lock(&sr_index_lock);
>  	minor =3D find_first_zero_bit(sr_index_bits, SR_DISKS);
> @@ -1009,6 +1009,8 @@ static void sr_kref_release(struct kref *kref)
> =20
>  	put_disk(disk);
> =20
> +	mutex_destroy(&cd->lock);
> +
>  	kfree(cd);
>  }
> =20
> diff --git a/drivers/scsi/sr.h b/drivers/scsi/sr.h
> index a2bb7b8ba..339c624e0 100644
> --- a/drivers/scsi/sr.h
> +++ b/drivers/scsi/sr.h
> @@ -20,6 +20,7 @@
> =20
>  #include <linux/genhd.h>
>  #include <linux/kref.h>
> +#include <linux/mutex.h>
> =20
>  #define MAX_RETRIES	3
>  #define SR_TIMEOUT	(30 * HZ)
> @@ -51,6 +52,7 @@ typedef struct scsi_cd {
>  	bool ignore_get_event:1;	/* GET_EVENT is unreliable, use TUR */
> =20
>  	struct cdrom_device_info cdi;
> +	struct mutex lock;
>  	/* We hold gendisk and scsi_device references on probe and use
>  	 * the refs on this kref to decide when to release them */
>  	struct kref kref;
>=20



--MtmV2JiIiLWTCnfRuGBzZNZaAQ1iEVVGs--

--cOpIReCRqUS0dM2IAW7xUvgdsrVnd7PzM
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEARYIAB0WIQRM5LT7NbLF9yb6a/UGN09rynK8WgUCXkW7fgAKCRAGN09rynK8
Wq47AQDoioDeHAkd135GF9+HheMMyMFIhIUaXDa5xAaVrvlNigD7BIw/LF4e1WCR
7JlNXms0nICiHo1J2pPGG5XJ0hd8bAw=
=fjoK
-----END PGP SIGNATURE-----

--cOpIReCRqUS0dM2IAW7xUvgdsrVnd7PzM--
