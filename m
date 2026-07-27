Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE95A35F60F
	for <linux-scsi@vger.kernel.org>; Mon, 27 Jul 2026 15:07:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785164848; cv=none; b=YqCqtWAmetQgfIJPQodSFBxq7RS9dGTtDuvMZkQ7EJ2l7c4o9Qw3HlcyfkHQPJZ0TX+721wg0XD8cAzbX0Xf2i+CH2dnN1Nik/kacyycsi7VKYorA/3+KmPuJSsIdD6c8eZ4GGWqHaFZzYAH3QEsV3H3+WkH7c3yLPP8DtucFGU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785164848; c=relaxed/simple;
	bh=uH/nNbGONBc5zIlvc1ratQjQXQXnZaHYcj9WZX9BNag=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=AAUmH+zGsGLQMvWLnwmPeVlGPeOX/Pz9eAYqYeJ8y4BrqR5cB5wZo13EWFPELkqkULqxzLJEu3mPsnU5OqyzAWlb5AQTZIv6nH1CQNhBOlLu+Ef08uymgZOq+c6bFHas26yR8adzG8FxO8p9/0IrQnaooVK9HAf0OqjyiXx74qk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ogLpCVaT; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ogLpCVaT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9FF041F00A3A;
	Mon, 27 Jul 2026 15:07:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785164847;
	bh=QyckZrh//JUCDnQiuOfzh/LFkhTT3dhT0O7l0fgEs0w=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=ogLpCVaTEJ2b13X/p8OIU+7C4fb5cZ3/6WfC8ZZ+ApRSCO9D+NJyVje5rGQKDNabp
	 TMhaUo3mpFMmm1s3MInv/Ct/oHnW3hME76KFMO7myNEFeI9pAXS1iUl0/xVKwelJDF
	 Dvssr3K/HYXG0379AHqUuOB/jBcChjcG/Te+OmyAfrPnvtTYgFyWuI/ewDCuNCTJcJ
	 Le/5Ry3ens6usJzVH55VhRuBbB8R/Nn6hyB+oz6QeBS0Ink/aHo+4tOxR7DK8QaRiD
	 WXR+T8kMgsZnGItxBWy4L4G8IVOiwGvsXwPAIayOmO3PhwLVm6aK3EJYUCphBkyItb
	 blHWV1upr18+w==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v5 13/27] scsi-multipath: provide sysfs link from to
 scsi_device
Reply-To: sashiko-reviews@lists.linux.dev
To: "John Garry" <john.g.garry@oracle.com>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20260727144234.3802948-14-john.g.garry@oracle.com>
References: <20260727144234.3802948-1-john.g.garry@oracle.com>
 <20260727144234.3802948-14-john.g.garry@oracle.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Mon, 27 Jul 2026 15:07:27 +0000
Message-Id: <20260727150727.9FF041F00A3A@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:

Pre-existing issues:
- [High] Missing cancellation of mpath_head->requeue_work causes Use-After-=
Free when tearing down the multipath head.
--

--- Patch [13]: [PATCH v5 13/27] scsi-multipath: provide sysfs link from to=
 scsi_device ---
commit 7fc63465ac8f13d95c759573374eebed7fbf19d2
Author: John Garry <john.garry@linux.dev>

scsi-multipath: provide sysfs link from to scsi_device

This commit provides a sysfs link from a scsi_mpath_device to member
scsi_devices. It adds functions to create and remove these multipath
sysfs links.

[ ... ]

> diff --git a/drivers/scsi/scsi_sysfs.c b/drivers/scsi/scsi_sysfs.c
> index 799569b74b535..ce51fcc002bbf 100644
> --- a/drivers/scsi/scsi_sysfs.c
> +++ b/drivers/scsi/scsi_sysfs.c

[ ... ]

> @@ -1495,6 +1498,8 @@ void __scsi_remove_device(struct scsi_device *sdev)
> =20
>  		if (IS_ENABLED(CONFIG_BLK_DEV_BSG) && sdev->bsg_dev)
>  			bsg_unregister_queue(sdev->bsg_dev);
> +		if (sdev->scsi_mpath_dev)
> +			scsi_mpath_remove_sysfs_link(sdev);
>  		device_unregister(&sdev->sdev_dev);

[Severity: High]
This is a pre-existing issue, but does the teardown of the multipath head
during device removal miss cancelling mpath_head->requeue_work?

Writing to the iopolicy sysfs attribute invokes
scsi_mpath_device_iopolicy_store(), which schedules the work:

drivers/scsi/scsi_multipath.c:scsi_mpath_device_iopolicy_store() {
    ...
    mpath_schedule_requeue_work(mpath_head);
    ...
}

If the SCSI device is removed concurrently (triggering
scsi_mpath_remove_device() and dropping the final reference), the release
function frees the containing structure without ensuring the work is cancel=
led:

drivers/scsi/scsi_multipath.c:scsi_mpath_head_release() {
    ...
    mpath_head_uninit(mpath_head);
    kfree(scsi_mpath_head);
}

Should mpath_head_uninit() in lib/multipath.c call cancel_work_sync()
to prevent a use-after-free when the requeue work executes on the freed
scsi_mpath_head memory?

[ ... ]

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260727144234.3802=
948-1-john.g.garry@oracle.com?part=3D13
