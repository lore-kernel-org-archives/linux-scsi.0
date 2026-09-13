Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC33426ED41
	for <linux-scsi@vger.kernel.org>; Sun, 13 Sep 2026 13:19:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789305597; cv=none; b=Fn2mQHqkhMdMDuMsZ+mskwyTeDEscT00iUZMsoFYR7jWpUaxR688Aw86HzgRSDX8b/S/igSJNJhhU4O0I5cvy+Rg3yPVrG5vu6LJ1/l9pQxbjF9UgfKNJPCiJ5vvkSGvaTfKZqRB2Trdf42gT/7wNjFcrCehYXBl0lrNtKiTM78=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789305597; c=relaxed/simple;
	bh=ZzJNHGyZkBkgGT6BMd5dolbZNA9Mx2RsGVL6sX7AbSA=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=R5pa1djMN9GvO5Drmjsuys1nwXto+UX4YHKHNYWwhRsuwtfF6x2Vu8KZLHZTuN9jlIWEIVTJYMXrnNHa3QsVZklIlMEdS9rKsg2tDtHT9jbMLX3/MU66nhvEvSl1M0SGDy4LlfSolsy/5jS+R0DmQvYdYPWUn+j7V6fqNMxfwxI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=X0kWsoKK; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="X0kWsoKK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5D7241F000FF;
	Sun, 13 Sep 2026 13:19:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789305596;
	bh=estTVy51L1KfvbdqgaFUwr0lSMKYxGSow3bCgT05yEQ=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=X0kWsoKKIHOWi6xggFIkDspwQddCAQ/AfWhrU0zsQsvxEN5YOTrpotx/MZbEYZfHm
	 EM8ShvvNDM2jZCOJ5Flv0o8JV+FQG6sNoWcVJQdzF7RQC5P9BUNJZdZGL4hbbK0kHs
	 9aZsdE4AC6Lwn4ssqDoEeWxrUiZS1q7af5fz+2SxYVB2dq+rt9TaFvC3XDBnB6Vk+r
	 6HhBqy7+CZ8aoNugW/r1l/WGV13lGAm/aWERnuPFFpirGfu5ytBJdwbQBR+z0g5SIk
	 AWB8feaqeRNmBAU5+L9EMEyJWGhE9oioWSNQpMAUOV4kY5hcxkEhEAgQu4RGgnipby
	 ZZxWpne0uQxQg==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH] scsi: rdac: preserve controller allocation errors
Reply-To: sashiko-reviews@lists.linux.dev
To: "Slavin Liu" <bolin.liu@seu.edu.cn>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20260913125138.109871-1-bolin.liu@seu.edu.cn>
References: <20260913125138.109871-1-bolin.liu@seu.edu.cn>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Sun, 13 Sep 2026 13:19:55 +0000
Message-Id: <20260913131956.5D7241F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 3 potential issue(=
s) to consider:

Pre-existing issues:
- [High] Missing list removal and RCU synchronization in the error path of =
`rdac_bus_attach()` leaves a dangling pointer in an RCU-protected list, lea=
ding to a Use-After-Free.
- [High] A TOCTOU race condition in `rdac_bus_detach()` locklessly checks `=
ms_queued` and skips flushing the workqueue, leading to a use-after-free of=
 both `h` and `h->ctlr` by the executing worker.
- [High] Trusting an unvalidated device-provided length `array_uniq_id_len`=
 causes a stack buffer overflow.
--

commit e14e62a313924b45dff06969688b649c337e4e48
Author: Slavin Liu <bolin.liu@seu.edu.cn>
Subject: scsi: rdac: preserve controller allocation errors

This commit fixes an issue in initialize_controller() where an allocation
failure was being overwritten with SCSI_DH_OK. It updates the logic to only
set success after obtaining and linking the controller, ensuring the caller
doesn't proceed with a NULL controller.

> diff --git a/drivers/scsi/device_handler/scsi_dh_rdac.c b/drivers/scsi/de=
vice_handler/scsi_dh_rdac.c
> index 88c8e36b221e2..ed02e1737bd79 100644
> --- a/drivers/scsi/device_handler/scsi_dh_rdac.c
> +++ b/drivers/scsi/device_handler/scsi_dh_rdac.c
> @@ -455,9 +455,9 @@ static int initialize_controller(struct scsi_device *=
sdev,
>  		else {
>  			h->sdev =3D sdev;
>  			list_add_rcu(&h->node, &h->ctlr->dh_list);
> +			err =3D SCSI_DH_OK;
>  		}
>  		spin_unlock(&list_lock);
> -		err =3D SCSI_DH_OK;

[Severity: High]
This is a pre-existing issue, but looking at how this node is published to
the RCU list in initialize_controller(), could this lead to a use-after-free
in the error path?

If a subsequent step like check_ownership() fails during rdac_bus_attach() =
in
drivers/scsi/device_handler/scsi_dh_rdac.c, the clean_ctlr error path is
taken:

rdac_bus_attach() {
    ...
	err =3D initialize_controller(sdev, h, array_name, array_id);
	if (err !=3D SCSI_DH_OK)
		goto failed;

	err =3D check_ownership(sdev, h);
	if (err !=3D SCSI_DH_OK)
		goto clean_ctlr;
    ...
clean_ctlr:
	spin_lock(&list_lock);
	kref_put(&h->ctlr->kref, release_controller);
	spin_unlock(&list_lock);

failed:
	kfree(h);
	return err;
}

The clean_ctlr path drops the controller reference and frees h, but it
doesn't call list_del_rcu(&h->node) or synchronize_rcu(). If the controller
is shared and stays alive, h->node remains in ctlr->dh_list after h is free=
d,
leaving a dangling pointer in an RCU-protected list.

[Severity: High]
This isn't a bug introduced by this patch, but is there a stack buffer
overflow when parsing the VPD page in get_lun_info() inside
drivers/scsi/device_handler/scsi_dh_rdac.c?

The array_id buffer is allocated on the stack in rdac_bus_attach() with a
fixed length of 16 bytes (UNIQUE_ID_LEN):

rdac_bus_attach() {
    ...
	char array_id[UNIQUE_ID_LEN];
    ...
	err =3D get_lun_info(sdev, h, array_name, array_id);
    ...
}

In get_lun_info(), the copy length is taken directly from the unvalidated
hardware response:

get_lun_info() {
    ...
		memset(array_id, 0, UNIQUE_ID_LEN);
		memcpy(array_id, inqp->array_unique_id, inqp->array_uniq_id_len);
    ...
}

If a malfunctioning or malicious SCSI device returns an array_uniq_id_len
greater than 16 (up to 255), won't this memcpy() write past the bounds of
the fixed-size stack buffer?

[Severity: High]
This is a pre-existing issue, but does rdac_bus_detach() in
drivers/scsi/device_handler/scsi_dh_rdac.c have a race condition with
send_mode_select() that could result in memory corruption?

When queue_mode_select() starts a mode select operation, send_mode_select()
clears ms_queued before executing the long-running command:

send_mode_select() {
    ...
	spin_lock(&ctlr->ms_lock);
	list_splice_init(&ctlr->ms_head, &list);
	ctlr->ms_queued =3D 0;
	ctlr->ms_sdev =3D NULL;
	spin_unlock(&ctlr->ms_lock);
    ...
	rc =3D scsi_execute_cmd(sdev, cdb, opf, &h->ctlr->mode_select, data_size,
    ...
}

If a device is removed concurrently, rdac_bus_detach() checks ms_queued
locklessly to decide whether it needs to flush the workqueue:

rdac_bus_detach() {
    ...
	if (h->ctlr && h->ctlr->ms_queued)
		flush_workqueue(kmpath_rdacd);
    ...
	list_del_rcu(&h->node);
	kref_put(&h->ctlr->kref, release_controller);
    ...
	kfree(h);
}

If rdac_bus_detach() runs after ms_queued is set to 0 but before the SCSI
command completes, it skips flush_workqueue() and proceeds to free both h a=
nd
the controller. Won't the executing worker thread then dereference the freed
handler data and controller?

>  	}
>  	return err;
>  }

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260913125138.1098=
71-1-bolin.liu@seu.edu.cn?part=3D1
