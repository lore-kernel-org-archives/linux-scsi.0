Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9CBB9346AFB
	for <linux-scsi@vger.kernel.org>; Mon,  7 Sep 2026 11:45:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788781531; cv=none; b=loOKrn5M4JzGJsxNZS+ig+cJ34hV0MAcopoWK+ykOr1nQNq+mDrK10sgxBNbVJFu0y6/bmydym+UWEurr2NQ8mI3SiC39ubhQ5eEgVv1FwOiKrLci+5kd6yp61HPyQXSwVduNQ+mjBSZpn7f24G41qd+itPvOSlBtjCk+StoJrE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788781531; c=relaxed/simple;
	bh=cRWZvco0zZpy1quaCQuCFMSnucTXjCOcvSRSO1kNGiM=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=bWWFdQl0y4FFFWCtXyQS/xtEKRTiWFvLBgmXNIgdzNno1abE50loQ2NF7dPTnIN2iU+umyMgACX9v9IecNmV+4ZAuJp7sn4o6Vu5LGwxLeUCIxEUTE1sDuQeKNxZG4BqWSkCIYvkrWHVOTv4/dLPHGml6cnZ2s30/9dj7Saap+g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=GHBcyqtB; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="GHBcyqtB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 211B01F00A3A;
	Mon,  7 Sep 2026 11:45:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788781530;
	bh=wpUrABcjbxbXCAd9ecat4k7DJ1ZTNuYP1BFXHafY8JM=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=GHBcyqtBgrjfNa1bVf759UTy5Xc75cX2MIBeg250d+XERRTkcpb0ko8kj9mECDtbW
	 lAO8y7MAJ3XZV2C35pSwjR4Y4TmooDYVxhFAsnIpXTzzBpLDG49fJ4JLYIjXvop6sp
	 tNkn54K6pBPos/YfWLij3Ovh8iAL3Q5D82Jt8TDgNKJgGMrj7hfuKb4h6WcNvoSeQ7
	 u7yBAQ2PqB/MFtIAajZyyUxay/bPp2RpajB70Xck76h7TJNXXJCdI+tnLYIhzd0nDz
	 8cPSg5uHlz0wAPC7cr0Iwq4kyewbaJjIUhLR9xQydTHijnCuIZ4zmt0HRdwfQzlYMX
	 0bYc4CvBOCHfg==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v8 15/27] scsi-multipath: clone each bio
Reply-To: sashiko-reviews@lists.linux.dev
To: "John Garry" <john.g.garry@oracle.com>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20260907105021.1763236-16-john.g.garry@oracle.com>
References: <20260907105021.1763236-1-john.g.garry@oracle.com>
 <20260907105021.1763236-16-john.g.garry@oracle.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Mon, 07 Sep 2026 11:45:29 +0000
Message-Id: <20260907114530.211B01F00A3A@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [Critical] Failure to copy the updated `bi_sector` from the clone back to=
 the master bio breaks `REQ_OP_ZONE_APPEND` completions.
--

commit 7a2bc90e62297f99675ed0e03f2410ced58b148e
Author: John Garry <john.garry@linux.dev>

scsi-multipath: clone each bio

This commit updates SCSI failover handling by cloning each original bio
before submission. Since SCSI has no guarantee that submitted bios are
entirely completed or not at all, this ensures the original bio can be
safely resubmitted upon failure.

> diff --git a/drivers/scsi/scsi_multipath.c b/drivers/scsi/scsi_multipath.c
> index 7164bc61e65e1..68fe50f62158c 100644
> --- a/drivers/scsi/scsi_multipath.c
> +++ b/drivers/scsi/scsi_multipath.c

[ ... ]

> @@ -237,7 +238,34 @@ static int scsi_multipath_sdev_init(struct scsi_devi=
ce *sdev)
>  	return 0;
>  }
> =20
> +static void scsi_mpath_clone_end_io(struct bio *clone)
> +{
> +	struct bio *master_bio =3D clone->bi_private;
> +
> +	master_bio->bi_status =3D clone->bi_status;
> +	bio_put(clone);
> +	bio_endio(master_bio);
> +}

[Severity: Critical]
Does this completion function need to propagate the appended sector location
for REQ_OP_ZONE_APPEND bios?

When a filesystem issues a REQ_OP_ZONE_APPEND bio to a zoned multipath
device, the lower layers choose where exactly within the zone the data is
written and update clone->bi_iter.bi_sector upon completion.

Since scsi_mpath_clone_end_io() only copies clone->bi_status and omits
copying the updated clone->bi_iter.bi_sector back to
master_bio->bi_iter.bi_sector before calling bio_endio(master_bio), will
this cause filesystems like btrfs or f2fs to record incorrect data locations
resulting in data corruption?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260907105021.1763=
236-1-john.g.garry@oracle.com?part=3D15
