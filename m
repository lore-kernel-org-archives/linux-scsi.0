Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB1AF3033E6;
	Tue,  1 Sep 2026 14:52:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788274327; cv=none; b=NCRot0JsPoaa2TRHOhGNzcbKEDNE2hyFhedk7Dcux4rH7wVFKs5eNOykqCLyX9F2LCct8SMhcDzltx8JS5DycAAkvsYpoYJJ7MPskEEQtZMja/TCk+koANRZd0Nd+QpsL2N3MYHw51g6H7efpIpoc4fcZByryHWJuBteftHan8I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788274327; c=relaxed/simple;
	bh=++Nkrtb9G83eAfRK8r7pLE/otME2J543yovmcn3FXhY=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=Z7PMs4yp8sOSabXzkSY1LFT/qJS6SLjF39RxOQhpjmQZ24Dvp9SMEmzczrKLpRRCupersx0rwSgBZz8kPTspTDehllFVIEev+Fae3TDMADqQaUTwtqj4EUaERJnACQGjXBf1HEG+4Qwfy/HM8iX0OmZP4XSAaKNkDdIiHYxWsY0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=LhooG6FN; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="LhooG6FN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2BF551F000E9;
	Tue,  1 Sep 2026 14:52:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788274324;
	bh=79HIs6HXLCzBzznIG5wPwyDIsUn5245KJUHkybTJ+Eg=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=LhooG6FNbLTF12ldUNi/FmxNnNjVmVZKY5pHeV1x0az67zaCeRoQ+yzpJ88kC4LS/
	 YLyWjyohExohbhVHckA9vxyL5l2wTtzWj17JTFQcAgOLJOio97SJ581Nj8ncqCMPux
	 cnZL1VAty7NRWMeQf5CADOnBsqVNsonV1KoIJFMrcH9KvRQVufanneUXpkX9hnwxi3
	 g9zuec0qEiAEt/MrxlNfPuhXIXkkxqHwyOiv/3AsQR2IDJ0+2ixuSWAE0bNvoOnXqV
	 lv+651xKg/rYS3pgvgXe9RM2DgjXC0gqk4IVTv6H7oCXp9kshyBjtydWh6/4I1U9Xx
	 ulciQa9DzdGgg==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH RFC 1/1] leds: add ASUS Aura SCSI driver for ROG NVMe
 enclosures
Reply-To: sashiko-reviews@lists.linux.dev
To: "Liang Haowen" <nbg2974@gmail.com>
Cc: lee@kernel.org, linux-leds@vger.kernel.org, linux-scsi@vger.kernel.org
In-Reply-To: <202609012200.RFC1.lhw@gmail.com>
References: <202609012200.RFC0.lhw@gmail.com>
 <202609012200.RFC1.lhw@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 01 Sep 2026 14:52:03 +0000
Message-Id: <20260901145204.2BF551F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 7 potential issue(=
s) to consider:
- [High] Incorrect teardown order in device detach and error paths leads to=
 Use-After-Free via the workqueue.
- [High] Bypassing `scsi_alloc_request` leaves critical `scsi_cmnd` fields =
uninitialized.
- [High] Missing serialization for the multi-step ENE hardware command sequ=
ence allows concurrent workers to interleave and corrupt hardware state.
- [Low] Undefined macro `kzalloc_obj` is used for memory allocation.
- [Low] `blk_rq_map_kern` is called with insufficient arguments.
- [Low] The driver prints a success log message on probe/attach.
- [Low] The commit message violates the LED subsystem capitalization and pr=
efix rules.
--

commit 241d70bc8fb77ca0865693a679d9c3bdc51ad240
Author: Liang Haowen <nbg2974@gmail.com>

leds: add ASUS Aura SCSI driver for ROG NVMe enclosures

This commit adds a SCSI driver for ASUS ROG external NVMe enclosures to
support Aura LEDs. The driver exposes each LED as a multicolor LED class
device and communicates with the ENE controller using vendor SCSI commands.

> leds: add ASUS Aura SCSI driver for ROG NVMe enclosures

[Severity: Low]
Does this commit message subject follow the LED subsystem guidelines?
The guidelines specify that the description after the subsystem prefix shou=
ld
be capitalized and include the driver name, such as:
leds: asus-aura-scsi: Add ASUS Aura SCSI driver for ROG NVMe enclosures

> diff --git a/drivers/leds/leds-asus-aura-scsi.c b/drivers/leds/leds-asus-=
aura-scsi.c
> new file mode 100644
> index 0000000000000..c913501ba96a2
> --- /dev/null
> +++ b/drivers/leds/leds-asus-aura-scsi.c
[ ... ]
> +static int ene_write(struct scsi_device *sdev, u16 reg,
> +		     const void *data, u8 arg_count)
> +{
> +	struct request *rq;
> +	struct scsi_cmnd *scmd;
> +	u8 cdb[ENE_CDB_LEN];
> +	int ret;
> +
> +	ene_build_cdb(cdb, reg, arg_count);
> +
> +	rq =3D blk_mq_alloc_request(sdev->request_queue, REQ_OP_DRV_OUT, 0);
> +	if (IS_ERR(rq))
> +		return PTR_ERR(rq);

[Severity: High]
Does bypassing scsi_alloc_request() here leave critical scsi_cmnd fields
uninitialized? Using blk_mq_alloc_request() directly skips
scsi_initialize_rq(), which means PDU fields like jiffies_at_alloc, rcu,
and retries remain uninitialized. When blk_execute_rq() runs, this might
trigger false timeouts or undefined behavior in the SCSI midlayer.

> +
> +	scmd =3D blk_mq_rq_to_pdu(rq);
> +	scmd->cmd_len =3D ENE_CDB_LEN;
> +	memcpy(scmd->cmnd, cdb, ENE_CDB_LEN);
> +
> +	if (arg_count) {
> +		ret =3D blk_rq_map_kern(rq,
> +				      (void *)data, arg_count, GFP_KERNEL);

[Severity: Low]
Can this blk_rq_map_kern() call compile? It seems to be missing the required
first parameter for the request queue (struct request_queue *q), passing
only 4 arguments instead of the mandatory 5.

> +		if (ret)
> +			goto out;
> +	}
[ ... ]
> +static void asus_aura_led_work(struct work_struct *work)
> +{
> +	struct asus_aura_led *led =3D
> +		container_of(work, struct asus_aura_led, work);
> +	struct scsi_device *sdev =3D led->zone->sdev;
> +	u8 apply =3D ENE_APPLY;
> +	u8 save =3D ENE_SAVE;
> +	u8 mode =3D ENE_MODE_STATIC;
> +	int ret;
> +
> +	if (!scsi_device_online(sdev))
> +		return;
> +
> +	/* Mode first: without it the device ignores the whole sequence. */
> +	ret =3D ene_write(sdev, ENE_REG_MODE, &mode, 1);
> +	if (ret)
> +		goto err;
> +
> +	ret =3D ene_write(sdev, ENE_REG_COLORS + led->index * ENE_RGB_LEN,
> +			led->rgb, ENE_RGB_LEN);

[Severity: High]
Could concurrent sysfs writes to different LEDs on the same device corrupt
the hardware state here? Because there are 4 LEDs on the same device,
multiple workers could interleave their ene_write() block requests to the
same endpoint without a shared mutex, potentially breaking the strict
multi-step sequence required by the ENE controller.

> +	if (ret)
> +		goto err;
[ ... ]
> +static int asus_aura_attach(struct scsi_device *sdev)
> +{
> +	struct asus_aura_zone *zone;
> +	int i, ret;
> +
> +	if (strncmp(sdev->vendor, ARION_INQ_VENDOR, strlen(ARION_INQ_VENDOR)) ||
> +	    strncmp(sdev->model, ARION_INQ_MODEL, strlen(ARION_INQ_MODEL)))
> +		return SCSI_DH_DEV_UNSUPP;
> +
> +	zone =3D kzalloc_obj(*zone, GFP_KERNEL);

[Severity: Low]
Is kzalloc_obj() a valid macro in the kernel API? It appears this will cause
a build failure, and should likely be standard kzalloc(sizeof(*zone),
GFP_KERNEL) instead.

> +	if (!zone)
> +		return SCSI_DH_NOMEM;
> +	zone->sdev =3D sdev;
> +
> +	for (i =3D 0; i < ARION_NUM_LEDS; i++) {
> +		ret =3D asus_aura_register_led(zone, i);
> +		if (ret)
> +			goto err_free;
> +	}
> +
> +	sdev->handler_data =3D zone;
> +	sdev_printk(KERN_INFO, sdev,
> +		    "asus_aura: %d per-LED multicolor LEDs registered\n",
> +		    ARION_NUM_LEDS);

[Severity: Low]
Is it okay to print this success log message on probe? The LED subsystem
guidelines specify that drivers should avoid logging success messages, and
only log errors or warnings.

> +	return SCSI_DH_OK;
> +
> +err_free:
> +	while (i--) {
> +		cancel_work_sync(&zone->leds[i].work);
> +		led_classdev_multicolor_unregister(&zone->leds[i].mc_cdev);

[Severity: High]
Could this teardown order introduce a use-after-free risk? Unregistering the
LED sets its brightness to 0, which invokes asus_aura_set() and queues a
new work item onto the system workqueue. Since cancel_work_sync() has
already been called, a dangling work item might remain when kfree(zone)
is executed shortly after.

> +		kfree(zone->leds[i].mc_cdev.led_cdev.name);
> +	}
> +	kfree(zone);
> +	return SCSI_DH_NOMEM;
> +}
> +
> +static void asus_aura_detach(struct scsi_device *sdev)
> +{
> +	struct asus_aura_zone *zone =3D sdev->handler_data;
> +	int i;
> +
> +	if (!zone)
> +		return;
> +	for (i =3D 0; i < ARION_NUM_LEDS; i++) {
> +		cancel_work_sync(&zone->leds[i].work);
> +		led_classdev_multicolor_unregister(&zone->leds[i].mc_cdev);

[Severity: High]
Similar to the error path in asus_aura_attach(), does unregistering the LED
after cancel_work_sync() leave a dangling work item? The unregister call
might queue new work via asus_aura_set(), leading to a use-after-free when
the memory is subsequently freed.

> +		kfree(zone->leds[i].mc_cdev.led_cdev.name);
> +	}
> +	kfree(zone);

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/202609012200.RFC1.l=
hw@gmail.com?part=3D1
