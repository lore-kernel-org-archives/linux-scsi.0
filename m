Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B1D6C3CF962
	for <linux-scsi@vger.kernel.org>; Tue, 23 Jun 2026 12:18:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782217121; cv=none; b=DHGObkPsuk2kaB6lXluMi92UrjsULXHJR6KWR1Osn7jft9quYpohEpyGjmP9ErJZ+3akehqIDmMavOKJtnkzsyt/63j4wMSnQh9mRt7zKsoDgOxk0BUao70ek6kjPVBXdxWdnvCQiMfUM8Hxw1OmJJ2yO1O4n9eh0itZngHVgOs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782217121; c=relaxed/simple;
	bh=mImXQ1+6+lsVgc/M++SPUP4s6R7iuhG3GaN+BgJF4pw=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=lKRrcuwsiE0QzVuJvSM4Y+Brdy+KHF20l45HP5RrMWjpkRzl+gQCP1A2bTdZihDArPAyrbX//TLq1fwsi4G4DMa86CRTqatytT18qjdPhZn1y4ZMW6Dji7n7KKxmG6bagXSxthmEk6KaR6k76WdbPNKXHNldFscI548nlB78vao=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=KhFTRDHh; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="KhFTRDHh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 300121F000E9;
	Tue, 23 Jun 2026 12:18:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782217120;
	bh=cX+H8RQowmdU6XU1xJKeZPLxeb49tCJu0cH5KvOEm/o=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=KhFTRDHhKC4U3D56xIFf31eib3jEQDUAuzqCIaq62ooJRFi9BatohmCxTtmmXw58R
	 1V7EfTJJ3VIL7UjqZwf6+CE8RZlBGblFQwcGDireWMIbrNfFIYUzdoj8OwQ9TCqnPv
	 OxNKXkydkQ8wq++nbTR7XfeQxuCte8u//xlL4c9AxVI0/vuWDEG6RR7BvAUfF+l1bV
	 LB/PqC6xYr9v4S1QqBWwV5FhxLs7K5xiB/k93U48t/+Q9g/1YxRow0M8nOxka80MHw
	 kESGrmKHFFadf6MgTbE54e69cpalLDWlBW2LzZkgOTyhDwyK8VpyC+j8JXt8sIok2F
	 9nvEGmlguA5Mw==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH] scsi: ufs: core: Fix UFS RPMB device teardown order
Reply-To: sashiko-reviews@lists.linux.dev
To: "Ao Sun" <ao.sun@transsion.com>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20260623120440.13883-1-ao.sun@transsion.com>
References: <20260623120440.13883-1-ao.sun@transsion.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 23 Jun 2026 12:18:39 +0000
Message-Id: <20260623121840.300121F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 2 potential issue(=
s) to consider:

Pre-existing issues:
- [High] Allocating a structure embedding a `struct device` via `devm_kzall=
oc()` creates a fundamental lifetime mismatch. The patch exacerbates this b=
y adding `devm_kfree()` to the `release` callback, triggering a fatal Use-A=
fter-Free if the device release is delayed.
- [High] If `ufs_rpmb_probe()` exits early, `hba->rpmbs` is never initializ=
ed, leading to a guaranteed NULL-pointer dereference in `ufs_rpmb_remove()`=
 during driver teardown.
--

commit 79815281175f9750b2f8b1eccd86223bc783c72a
Author: Ao Sun <ao.sun@transsion.com>

scsi: ufs: core: Fix UFS RPMB device teardown order

This commit modifies the teardown order of the UFS RPMB device by
unregistering the child RPMB device ahead of the parent device in the
remove path. It also moves the memory deallocation for the ufs_rpmb
structure to the parent release callback.

Link: https://lore.kernel.org/all/20260618064142.8C30E1F000E9@smtp.kernel.o=
rg/

> diff --git a/drivers/ufs/core/ufs-rpmb.c b/drivers/ufs/core/ufs-rpmb.c
> index ffad049872b9a..dcb7e521284f1 100644
> --- a/drivers/ufs/core/ufs-rpmb.c
> +++ b/drivers/ufs/core/ufs-rpmb.c
> @@ -128,7 +128,7 @@ static void ufs_rpmb_device_release(struct device *de=
v)
>  {
>  	struct ufs_rpmb_dev *ufs_rpmb =3D dev_get_drvdata(dev);
> =20
> -	rpmb_dev_unregister(ufs_rpmb->rdev);
> +	devm_kfree(ufs_rpmb->hba->dev, ufs_rpmb);

[Severity: High]
This is a pre-existing issue, but does allocating a structure embedding a
struct device via devm_kzalloc() create a lifetime mismatch?

This patch exacerbates the issue by adding devm_kfree() to the release
callback. If a user holds a sysfs attribute open during driver unbind,
devres will automatically free ufs_rpmb. Later, when the sysfs file is
closed and the final kobject reference is dropped, ufs_rpmb_device_release()
executes and dereferences the already-freed ufs_rpmb pointer to read
ufs_rpmb->hba->dev, leading to a use-after-free.

>  }

[ ... ]

> @@ -244,6 +245,7 @@ void ufs_rpmb_remove(struct ufs_hba *hba)
>  		/* Remove from list first */
>  		list_del(&ufs_rpmb->node);
>  		/* Unregister device */
> +		rpmb_dev_unregister(ufs_rpmb->rdev);
>  		device_unregister(&ufs_rpmb->dev);
>  	}

[Severity: High]
This isn't a bug introduced by this patch, but if ufs_rpmb_probe() exits
early before calling INIT_LIST_HEAD(&hba->rpmbs), won't hba->rpmbs remain
zero-initialized?

If the driver is unbound later, ufs_rpmb_remove() is called on that
zero-initialized list:

drivers/ufs/core/ufs-rpmb.c:ufs_rpmb_remove() {
        if (list_empty(&hba->rpmbs))
                return;

        list_for_each_entry_safe(ufs_rpmb, tmp, &hba->rpmbs, node) {
...

Since head->next is NULL on a zero-initialized list, list_empty()
evaluates to false. This means list_for_each_entry_safe() will dereference
NULL->next during initialization, causing an immediate kernel panic.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260623120440.1388=
3-1-ao.sun@transsion.com?part=3D1
