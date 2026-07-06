Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A4A72397B15
	for <linux-scsi@vger.kernel.org>; Mon,  6 Jul 2026 07:42:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783323773; cv=none; b=GqWt1oRSdMUVC7J3BJ40+58v5f5G7HCx+TZrMh1T9DFkgU0QhsUGadNGMdWr4SlgWQrQXjqHIQdNgr4K5wLF0DwuHPA86RpxQhtFZNSxCZd5hcKf/9E/1lGiRZoynlQjOEIh4EwBhoZDSYEHuFJWDkR5aPX6AexIiLtjtbF8tFM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783323773; c=relaxed/simple;
	bh=niwAlge9L5fgkqo6euxhAO8hLThDkKjRjbkIzPS9bJ0=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=gOj/dje2pK6wKvipGXbc/WX+uku4WkdN7ORlaR9G6nycbdciiudV9nbUTHRRzOT3h02ACQVrLdsukqCcZpwhkb3ytWne5aD0bY464yM5BbEbjejeoLB25vKg1s+qWMfnvbmo5u1UJE985UagKP9pBNkEQXfEb/au/7zmhF4Elrk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=KIvkUdqn; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="KIvkUdqn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C77281F000E9;
	Mon,  6 Jul 2026 07:42:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783323765;
	bh=E0D2WIrkCZ6obwEn3v9eageniG4GwRsYNM5l90qPzAA=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=KIvkUdqnENI14evSzLaBdh0r5pN7X3ycCkuOLUrR3hrm0o5HNwSqiU91LKLdKC29Y
	 AbyImfx+URHxde/q8RVq129YMJ0H/M40zQoNq2pzAoJR/QMwgOFLLTz5fW8cKs8LcA
	 Ju2IRaJ5kkys27501VqiH7OCrEcZwEmyfVoT9ZXrsr8LcZRxVkkCpzTcezYIGeJX7T
	 1YiTUqkvZuD6aLBbWgCZoRrvvTu9JMYbQRr6LEnVOnH1Twd0urRn2bWwncEWquWWYj
	 u5h89xBaNR3eeCmhJUwDjvpt8PNym2q1y1/0Sf2oRpCiUnUo1BlDDTiUi9/902d1GD
	 apyfH4lTAbWAA==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH] scsi: ses: unregister the enclosure before freeing its
 device state
Reply-To: sashiko-reviews@lists.linux.dev
To: "Bryam Vargas" <hexlabsecurity@proton.me>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20260706-b4-disp-cf600574-v1-1-be4f324ff44c@proton.me>
References: <20260706-b4-disp-cf600574-v1-1-be4f324ff44c@proton.me>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Mon, 06 Jul 2026 07:42:44 +0000
Message-Id: <20260706074244.C77281F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:

Pre-existing issues:
- [High] The enclosure device is published to sysfs and the global list bef=
ore its private data pointers are initialized, allowing concurrent accesses=
 to trigger a NULL pointer dereference.
--

commit c0db7f74419376e5dfdb039e9a143c3b6a8d01bf
Author: Bryam Vargas <hexlabsecurity@proton.me>

scsi: ses: unregister the enclosure before freeing its device state

ses_intf_remove_enclosure() frees ses_dev and the page1/page2/page10
buffers it owns before calling enclosure_unregister(). This leaves the
component sysfs attributes live over freed memory, meaning a concurrent
read or write could trigger a use-after-free. This patch reorders the
teardown to unregister first, then free.

Fixes: 9927c68864e9 ("[SCSI] ses: add new Enclosure ULD")
Closes: https://sashiko.dev/#/patchset/20260706-b4-disp-29a05ca3-v1-1-49591=
f469f60@proton.me?part=3D1
Cc: stable@vger.kernel.org

> diff --git a/drivers/scsi/ses.c b/drivers/scsi/ses.c
> index 4c348645b04ee..a3039a3ede56c 100644
> --- a/drivers/scsi/ses.c
> +++ b/drivers/scsi/ses.c
> @@ -869,18 +870,24 @@ static void ses_intf_remove_enclosure(struct scsi_d=
evice *sdev)
>  		return;
> =20
>  	ses_dev =3D edev->scratch;
> -	edev->scratch =3D NULL;

[Severity: High]
This is a pre-existing issue, but since we are looking at sysfs race
conditions involving edev->scratch, could a similar race occur during
initialization in ses_intf_add()?

When ses_intf_add() registers the enclosure:

drivers/scsi/ses.c:ses_intf_add() {
	edev =3D enclosure_register(cdev->parent, dev_name(&sdev->sdev_gendev),
				  components, &ses_enclosure_callbacks);
	if (IS_ERR(edev)) {
		err =3D PTR_ERR(edev);
		goto err_free;
	}

	kfree(hdr_buf);

	edev->scratch =3D ses_dev;
	...
}

The enclosure_register() call makes the device visible to userspace and
could trigger a read of the id sysfs attribute before edev->scratch is
assigned.

If that happens, would the id_show callback lead to a NULL pointer
dereference here?

drivers/scsi/ses.c:ses_show_id() {
	struct ses_device *ses_dev =3D edev->scratch;
	unsigned long long id =3D get_unaligned_be64(ses_dev->page1+8+4);
	...
}

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260706-b4-disp-cf=
600574-v1-1-be4f324ff44c@proton.me?part=3D1
