Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 27A61346A07
	for <linux-scsi@vger.kernel.org>; Thu, 23 Jul 2026 11:07:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784804859; cv=none; b=sbcasGJ4sSm4kDVUfcRGQnl6eUYM2wxkEvF4lsQvGunPhdiueEojZ2oELexfr0d727Sz8aGNlr3K2pMsBPXiGyCwGN3hEtwCNAchWZh9l+sejygloWmuwouob+sH/fOkgCELTrANjjC6Kb5Q9PZFzsQFki0EUGGWMxnB33VBLds=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784804859; c=relaxed/simple;
	bh=wIdU2lZCCjitgPaonOw0uaIzw/srhRKfx7tXIEbnoD4=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=JWJegFOfYYpg5Ueq2UT3+NZ0YhE3EJcjMdM3V6Vk7XVh7/9kzI9Orrsvh18+ksMgeO3Q8knVzewKcE+epkTdXO+nWTnT58NFJ+ajABRs7PFNvrMdIyRsG7JipP/WvAz+ZCJYMkaPcnbHhhCNiEBy5fDFY/YEG7bAIUVkxYr9QJg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D313D1F000E9;
	Thu, 23 Jul 2026 11:07:37 +0000 (UTC)
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v4 26/28] scsi: sd: add mpath_dev file
Reply-To: sashiko-reviews@lists.linux.dev
To: "John Garry" <john.g.garry@oracle.com>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20260723093627.2327456-27-john.g.garry@oracle.com>
References: <20260723093627.2327456-1-john.g.garry@oracle.com>
 <20260723093627.2327456-27-john.g.garry@oracle.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 23 Jul 2026 11:07:33 +0000
Message-Id: <20260723110737.D313D1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [High] Reading the `mpath_dev` sysfs attribute can cause a use-after-free=
 of the multipath `gendisk` and `scsi_mpath_head` objects during SCSI path =
removal.
--

--- Patch [26]: [PATCH v4 26/28] scsi: sd: add mpath_dev file ---
commit 4a0e7acbc6d2b78e6b014dfe6924983c812cc80e
Author: John Garry <john.g.garry@oracle.com>
scsi: sd: add mpath_dev file

This commit adds a mpath_dev file so the multipath disk can be looked up
from the per-path gendisk directory. This allows utilities like lsscsi to
find the multipath disk even when the gendisk for the per-path scsi_device
is missing.

> diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
> index d5a37b1b312c3..f8c9096e6c43c 100644
> --- a/drivers/scsi/sd.c
> +++ b/drivers/scsi/sd.c
[ ... ]
> @@ -4059,6 +4059,53 @@ static int sd_mpath_revalidate_head(struct scsi_di=
sk *sdkp)
> =20
>  	return ret;
>  }
> +
> +static ssize_t sd_mpath_dev_show(struct device *dev,
> +			struct device_attribute *attr, char *page)
> +{
> +	struct gendisk *gd =3D dev_to_disk(dev);
> +	struct scsi_disk *sdkp =3D gd->private_data;
> +	struct scsi_device *sdev =3D sdkp->device;
> +	struct scsi_mpath_device *scsi_mpath_dev =3D sdev->scsi_mpath_dev;
> +	struct scsi_mpath_head *scsi_mpath_head =3D scsi_mpath_dev->scsi_mpath_=
head;
> +	struct mpath_head *mpath_head =3D &scsi_mpath_head->mpath_head;
> +	struct gendisk *disk =3D mpath_head->disk;

[Severity: High]
Can a concurrent read of this sysfs file cause a use-after-free during devi=
ce
removal?

Looking at sd_remove() in drivers/scsi/sd.c, it tears down the multipath
structures before removing the sysfs interfaces:

sd_remove() {
    if (sdp->scsi_mpath_dev)
        sd_mpath_remove(sdkp);
    ...
    device_del(&sdkp->disk_dev);
    del_gendisk(sdkp->disk);
}

Since del_gendisk() happens after sd_mpath_remove(), there is a window where
the mpath_dev sysfs file is still accessible but the underlying multipath
structures have been freed.

Could an unprivileged user read the mpath_dev file during this window and
dereference freed memory for scsi_mpath_head and mpath_head->disk?

> +	struct device *disk_dev =3D disk_to_dev(disk);
> +
> +	return print_dev_t(page, disk_dev->devt);
> +}

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260723093627.2327=
456-1-john.g.garry@oracle.com?part=3D26
