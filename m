Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5BB4C3C4552
	for <linux-scsi@vger.kernel.org>; Fri,  3 Jul 2026 11:26:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783077975; cv=none; b=qU8ljK87aBM0ZPcjNXD7qgRmScX4gGBcEqpk4PyqIF5A8YGRbnfrczqPaArofi82XSH+KHqqp1sVc1G0Aql+QIgdPvfhIW4rrQSVJ+4xSN21gGFS7C7mfn4eZsDMibvzOW/vt5yK32wzaQu3ntFLQT7hdTV47cFe3Tl+M7xOzH8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783077975; c=relaxed/simple;
	bh=abyZE+fP4YShSnVhfntIZHJjpAz55CZK3vk3nt2QMto=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=F/L1FMXMH+p9XuzdpxgyRh4VgTla5f+WVyBQNFkNMArBs1HKAHqI1DbWDTVtfwV63JDmoeZrDJHm3PLD9yIWHPekUki6hXkBd8d+kSqbPmv8KlOlzyTE5svzzubffJ22L7gNz7b9NUVHSZabSTFvq76jNXvtgSMW0K+g+iK0stE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=BFss7JPQ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="BFss7JPQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 525E51F000E9;
	Fri,  3 Jul 2026 11:26:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783077963;
	bh=LnxbWnFw0KTYGleESATOsnFsWZwQD+SSRkUdv/e4Q8U=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=BFss7JPQXw4q6E++6TJIe4aZs8xaaDuKMd8e/vFJK7yZPdswfs7RP7TCOwlcIiDl/
	 ekiCKV7MJ6BhP1ic4qA+Fp3WLP3WkrXrd//y0dVijNTOTiwFFzXsExVMAtVrZLJJeW
	 /U6CV4BiijtmOkSTTgY2KwSizE/ynilKmBiAAwUST0h/AOUNLVj2Z4pEpgLFqg5sjJ
	 S+oku9AWq0neHW9IgNozNdj4M9yD0jX5obV5jOLgpIxoTXKhOgj8nc02xputnh8uWe
	 pGVSkAWKls4hrJsec/9vYpzC4qUqjeD1ZEUmkE+aiqOC22jahjgKq3eaxvPtWHeHT1
	 l7kBBI+kchE8A==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v3 05/17] scsi-multipath: clone each bio
Reply-To: sashiko-reviews@lists.linux.dev
To: "John Garry" <john.g.garry@oracle.com>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20260703103402.3725011-6-john.g.garry@oracle.com>
References: <20260703103402.3725011-1-john.g.garry@oracle.com>
 <20260703103402.3725011-6-john.g.garry@oracle.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 03 Jul 2026 11:26:02 +0000
Message-Id: <20260703112603.525E51F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 2 potential issue(=
s) to consider:
- [High] Destroying the bio pool before draining inflight IOs during teardo=
wn leads to memory corruption.
- [High] Manual cleanup on the dev_set_name() error path after put_device()=
 causes deterministic double-free and use-after-free vulnerabilities.
--

commit 31da3ef05c72ae055a7ebbed278c14967c624ea3
Author: John Garry <john.g.garry@oracle.com>

scsi-multipath: clone each bio

For failover handling, we will take the approach to resubmit each
bio. Unlike NVMe, for SCSI there is no guarantee that any bio submitted
is either all or none completed. As such, for failover handling clone
and submit each bio.

> diff --git a/drivers/scsi/scsi_multipath.c b/drivers/scsi/scsi_multipath.c
> index 6159803d4cbb8..ca4ab720c19af 100644
> --- a/drivers/scsi/scsi_multipath.c
> +++ b/drivers/scsi/scsi_multipath.c
> @@ -96,6 +96,7 @@ static void scsi_mpath_head_release(struct device *dev)
>  		container_of(dev, struct scsi_mpath_head, dev);
>  	struct mpath_head *mpath_head =3D &scsi_mpath_head->mpath_head;
> =20
> +	bioset_exit(&scsi_mpath_head->bio_pool);

[Severity: High]
Does destroying the bio pool here before draining inflight IOs lead to memo=
ry
corruption?

If a device is removed, the final reference to the scsi_mpath_head might be
dropped before the underlying request queue is frozen. Because the queue is
not yet drained, inflight cloned bios can still complete after the pool is
destroyed. When they do, scsi_mpath_clone_end_io() calls bio_put(), which
will attempt to return the clone to this destroyed bio_pool, causing a
use-after-free.

>  	ida_free(&scsi_multipath_dev_ida, scsi_mpath_head->index);
>  	mpath_head_uninit(mpath_head);

[ ... ]

> @@ -270,6 +300,8 @@ static struct scsi_mpath_head *scsi_mpath_alloc_head(=
void)
>  	ida_free(&scsi_multipath_dev_ida, scsi_mpath_head->index);
>  out_put_head:
>  	mpath_put_head(&scsi_mpath_head->mpath_head);
> +out_bioset_exit:
> +	bioset_exit(&scsi_mpath_head->bio_pool);
>  out_free:
>  	kfree(scsi_mpath_head);

[Severity: High]
Can this error cleanup path cause a double-free vulnerability?

If dev_set_name() fails earlier in scsi_mpath_alloc_head(), the code will
call put_device() which drops the kobject reference count and synchronously
invokes scsi_mpath_head_release().

scsi_mpath_head_release() completely tears down and frees the scsi_mpath_he=
ad
structure, but the error path then continues through these manual cleanup
steps, executing bioset_exit() and kfree() on the already freed pointer.

>  	return NULL;
>  }

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260703103402.3725=
011-1-john.g.garry@oracle.com?part=3D5
