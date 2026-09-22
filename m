Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 92DDF3ADB97
	for <linux-scsi@vger.kernel.org>; Tue, 22 Sep 2026 03:21:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790047318; cv=none; b=EBBoVt71ws9RfBycNjc9lil8JT/vlNK1wd0QGS84MVkV+rU7JWrDrw1UQhwCEiylyY2jpJkVk5ThzicCfvqSWlDHrOEJaa5xFQDavMReQO66RlkG3lZrw6jkhf9NxZ8m8yYhOdw6xjquRRKssRthXs8oCIfY715aQRqJWFxuwuU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790047318; c=relaxed/simple;
	bh=K5SH3GhVN/Poc9mJqZcdUca5OPB6NMQWzUgwbejCCDY=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=dRiwGG5yLrmp6+HhG+eR1e8p1ZjDTyO3KAYU0RS0NU68HjOgqOoqcDViG6KRl/hfksdHstvxy/ByyYxL5YIg03So+Gu+8+mYVMqYAHrI0Q0M93qEli24T3/zfhHmqy6P3MMi+R1qRfrk730vOJTjnkNj/V1E/71zezKEsBDAH+E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=SIHw4/jA; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="SIHw4/jA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E6AC01F000FF;
	Tue, 22 Sep 2026 03:21:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790047317;
	bh=2HRGUJ3fWUZzMza0yU+ZnylcbaR3WIORvCv/GxyAH4Y=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=SIHw4/jAgec9CJLDxy5sfNNe9mEXecHRQRjyEK7yZVIKIbCiFVdgsjchTrdN/4PKh
	 O36llbjjHtOl42lHTz83eyI4LjP7FeQYmFakTGK5nGgvV3bnySd/F4jLwtrlarkQSI
	 +3DVt4DpPVsQB65ucW/xZgNNSmhMbeSJC5OsJaXjfr6qeraEclTNpRM/Q9/nyiNZFP
	 l0/uUkJO+wARnXEpGFYHOEcajw4XG9gQXWislVL0aMerFtfwFxL7FlHlQYHhQPJiAL
	 Ibe6XYRahk7R4GUexqw+vLDT3CqVLVr4YHvCkXdyZbu7ekf2EnHE7sO2uSXrnDaOtA
	 5T/ABjbPDn0AA==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v2] usb: uas: quiesce SCSI before stopping endpoints on
 unbind
Reply-To: sashiko-reviews@lists.linux.dev
To: "Jiayi Li" <lijiayi@kylinos.cn>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20260922031102.141043-1-lijiayi@kylinos.cn>
References: <20260922031102.141043-1-lijiayi@kylinos.cn>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 22 Sep 2026 03:21:56 +0000
Message-Id: <20260922032156.E6AC01F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [High] usb: uas: 30-second hang and 100% CPU livelock on physical unplug
--

commit fb8eab9b3967bb30e72e5cba65984f12ee6267cd
Author: Jiayi Li <lijiayi@kylinos.cn>

usb: uas: quiesce SCSI before stopping endpoints on unbind

This patch reorders the teardown sequence in uas_disconnect() to remove
the SCSI host and cancel scanning before setting the resetting flag and
killing anchored URBs. The goal is to quiesce SCSI before stopping endpoints
on unbind.

Link: https://lore.kernel.org/lkml/20260920012358.3362053-1-lijiayi@kylinos=
.cn/

> diff --git a/drivers/usb/storage/uas.c b/drivers/usb/storage/uas.c
> index 2651629812694..971a9dc012e9b 100644
> --- a/drivers/usb/storage/uas.c
> +++ b/drivers/usb/storage/uas.c
> @@ -1217,6 +1217,14 @@ static void uas_disconnect(struct usb_interface *i=
ntf)
>  	struct uas_dev_info *devinfo =3D (struct uas_dev_info *)shost->hostdata;
>  	unsigned long flags;
> =20
> +	/*
> +	 * Prevent SCSI scanning (if it hasn't started yet)
> +	 * or wait for the SCSI-scanning routine to stop.
> +	 */
> +	cancel_work_sync(&devinfo->scan_work);
> +
> +	scsi_remove_host(shost);
> +

[Severity: High]
Will moving scsi_remove_host() before devinfo->resetting =3D 1 and
uas_zap_pending() cause a 30-second hang and 100% CPU livelock on
physical unplug?

On physical unplug, usbcore detects the disconnect and calls
usb_disable_device(), which kills all active URBs with status -ESHUTDOWN
before calling uas_disconnect().

URB completion handlers like uas_stat_cmplt() handle -ESHUTDOWN by jumping
to bail, intentionally bypassing the clearing of the COMMAND_INFLIGHT flag
and leaving the SCSI commands stuck in-flight:

drivers/usb/storage/uas.c:uas_stat_cmplt() {
    ...
    if (status) {
        if (status !=3D -ENOENT && status !=3D -ECONNRESET && status !=3D -=
ESHUTDOWN)
            dev_err(&urb->dev->dev, "stat urb: status %d\n", status);
        goto bail;
    }
    ...
}

scsi_remove_host() synchronously waits for all in-flight SCSI commands to
complete. Because the commands are stuck in-flight until uas_zap_pending()
forcefully completes them, scsi_remove_host() will block indefinitely.

During this hang, any commands in IS_IN_WORK_LIST repeatedly trigger
uas_do_work(). Since the device is detached, uas_submit_urbs() fails.
Because devinfo->resetting is still 0 at this point, the work is
unconditionally requeued:

drivers/usb/storage/uas.c:uas_do_work() {
    ...
    err =3D uas_submit_urbs(cmnd, cmnd->device->hostdata);
    if (!err)
        cmdinfo->state &=3D ~IS_IN_WORK_LIST;
    else
        queue_work(workqueue, &devinfo->work);
    ...
}

Will this cause the workqueue thread to livelock, burning 100% CPU for
30 seconds until the SCSI error handler timeout finally aborts the commands?

>  	spin_lock_irqsave(&devinfo->lock, flags);
>  	devinfo->resetting =3D 1;
>  	spin_unlock_irqrestore(&devinfo->lock, flags);

[ ... ]

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260922031102.1410=
43-1-lijiayi@kylinos.cn?part=3D1
