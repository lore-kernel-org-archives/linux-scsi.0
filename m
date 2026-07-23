Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B647C438FFD
	for <linux-scsi@vger.kernel.org>; Thu, 23 Jul 2026 10:27:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784802438; cv=none; b=Qb7BLZd2RG+0fjlLpiPYk0h2Qku7S8vhI1vBqFLRdmYcvJ/JJkYfL1X9KoCPKFgn3eCJsAdbNk+OD1MF4C0cZ7B5BIaST//ucd6K5WwK5aAtDd+hShnsz5hWaJ74LvEoRWgcLVUqy6U9iu43/nSu56LtiKMMiwZddVO64+FoQw8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784802438; c=relaxed/simple;
	bh=Kra+cfefwZcAZUUTXVZuzR2SYirTXxNpWlXeTtA+1Aw=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=UhE7Fz6cLDCUT2AUaMTkpvZoBJt/eks//iiLV8nye4Ab+ITmFcXn/9X9n1+K0iBS+/T58XpyStApX1QBkqHaPbps7v6fYntQGZAldzfUlnmxbEvHQhOCb+UHz3oqT+kppTFRHFQW2G1y7z02Bm3OmSbU/0fwx5siso3YHpIWcnQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=LI8tDqKN; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="LI8tDqKN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 30BAC1F000E9;
	Thu, 23 Jul 2026 10:27:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784802437;
	bh=/m2IezLkcLc+ZGSaAE4KNoQiTmnPbdBb+ElCNA3nWac=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=LI8tDqKN6RtgGjoKlQIBNVgmjsaDTmk7JDvPfb69Nv76jyB1xLvpA36w7S0Bg+Znu
	 psNqMClAg7KqG96wEmlcfCgpOTjbn66CmLFQ4nL7O/4A/gSrUX9lbotixkRuLc0mDg
	 bwxAeME+tyP/7Kuu1Ja0qU+5LfwKHuNaLY117YO2Eo0DHCy4Zjh79uxBY8mVOvNzzQ
	 Fcq4PzEP9VEVkZPyXguaAISoyukZaWpmqErgHcR8gs2bcxeKbrfl3nr9Rd/kVIHTdT
	 ghxeFvarNqOWyvijq0APo/l7PW1T0Q3XIZjtG1jFpYr5ZUj+DQfiM8ger1Pepnogsl
	 JogKCTGz298/g==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v4 16/28] scsi-multipath: clone each bio
Reply-To: sashiko-reviews@lists.linux.dev
To: "John Garry" <john.g.garry@oracle.com>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20260723093627.2327456-17-john.g.garry@oracle.com>
References: <20260723093627.2327456-1-john.g.garry@oracle.com>
 <20260723093627.2327456-17-john.g.garry@oracle.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 23 Jul 2026 10:27:16 +0000
Message-Id: <20260723102717.30BAC1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 4 potential issue(=
s) to consider:
- [Critical] NULL pointer dereference due to missing mandatory template cal=
lbacks
- [High] Missing failover handling in clone completion
- [High] Bio allocation deadlock due to missing BIOSET_NEED_RESCUER
- [Medium] Memory leak due to missing ida_destroy()
--

--- Patch [16]: [PATCH v4 16/28] scsi-multipath: clone each bio ---
commit a74e2254f4409451e96518ce4d539e122559fac1
Author: John Garry <john.garry@linux.dev>

scsi-multipath: clone each bio
   =20
For failover handling, we will take the approach to resubmit each
bio.

However, unlike NVMe, for SCSI there is no guarantee that any bio submitted
is either all or none completed.

As such, for SCSI, for failover handling we will take the approach to
just re-submit the original bio. For this, clone and submit each bio.

> diff --git a/drivers/scsi/scsi_multipath.c b/drivers/scsi/scsi_multipath.c
> index 6228ff4be4ff7..9a4b35c597778 100644
> --- a/drivers/scsi/scsi_multipath.c
> +++ b/drivers/scsi/scsi_multipath.c
> @@ -97,6 +97,7 @@ static void scsi_mpath_head_release(struct device *dev)
>  		container_of(dev, struct scsi_mpath_head, dev);
>  	struct mpath_head *mpath_head =3D &scsi_mpath_head->mpath_head;
> =20
> +	bioset_exit(&scsi_mpath_head->bio_pool);
>  	ida_free(&scsi_multipath_dev_ida, scsi_mpath_head->index);
>  	mpath_head_uninit(mpath_head);
>  	kfree(scsi_mpath_head);

[Severity: Medium]
Will this leak memory if the embedded IDA isn't destroyed?

Even though empty IDAs free their bitmaps, the XArray API contract requires
calling ida_destroy() or xa_destroy() to ensure all internally allocated
memory is fully released. Can we add a call to
ida_destroy(&scsi_mpath_head->ida) before freeing the structure?

[ ... ]
> @@ -229,7 +230,34 @@ static int scsi_multipath_sdev_init(struct scsi_devi=
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

[Severity: High]
Does this skip all multipath failover logic on error?

When an underlying SCSI path fails, the error status is unconditionally
propagated to the master bio and completed. Should this be checking
blk_path_error() and requeueing the master bio to the requeue_list for a
retry on an alternate path instead?

[ ... ]
> +static struct mpath_head_template smpdt =3D {
> +	.clone_bio =3D scsi_mpath_clone_bio,
>  };

[Severity: Critical]
Will this trigger a NULL pointer dereference?

The template omits the .is_disabled, .is_optimized, .available_path, and
.remove_head callbacks. The libmultipath core does not check if these are
NULL before calling them. For example, submitting any bio to the device
triggers __mpath_find_path() which calls:

lib/multipath.c:mpath_path_is_disabled() {
    return mpath_head->mpdt->is_disabled(mpath_device);
}

Should these mandatory callbacks be implemented in the template?

> =20
>  static struct scsi_mpath_head *scsi_mpath_alloc_head(void)
> @@ -252,6 +280,9 @@ static struct scsi_mpath_head *scsi_mpath_alloc_head(=
void)
>  	scsi_mpath_head->index =3D ida_alloc(&scsi_multipath_dev_ida, GFP_KERNE=
L);
>  	if (scsi_mpath_head->index < 0)
>  		goto out_uninit_head;
> +	if (bioset_init(&scsi_mpath_head->bio_pool, BIO_POOL_SIZE,
> +			0, BIOSET_PERCPU_CACHE))

[Severity: High]
Could this cause a system deadlock?

The bioset is initialized without the BIOSET_NEED_RESCUER flag. Later,
scsi_mpath_clone_bio() allocates from this pool via bio_alloc_clone(). Since
this allocation occurs inside submit_bio_noacct(), an exhausted mempool will
block waiting for completions.

Without BIOSET_NEED_RESCUER, the block layer's deadlock avoidance cannot
intervene. Should BIOSET_NEED_RESCUER be added to the flags here?

> +		goto out_ida_free;
>  	kref_init(&scsi_mpath_head->ref);
> =20
>  	device_initialize(&scsi_mpath_head->dev);

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260723093627.2327=
456-1-john.g.garry@oracle.com?part=3D16
