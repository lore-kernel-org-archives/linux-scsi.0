Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4FDE1257844
	for <linux-scsi@vger.kernel.org>; Wed, 24 Jun 2026 05:11:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782277915; cv=none; b=Tw7ajmOD5gG+GP75QNGYqGC/mdDPJwXJ4suPoT0kmyixCbroEjmOYCt9Bo5CFuSvVuwF5kxarfKAPSw/6qlyQW3LHytAn5PJuT1oX7nYKU2d2d7Z16Ju2jNLgLlZEMttklUAHre7lsQUaKrTt+wnO+X1LRwEgcu+3Cd7v+kAd+0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782277915; c=relaxed/simple;
	bh=Rg5RAUHhY6tzMh9cShOyVCZUoMeNcNGtmDaTr5uRh8A=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=WWFJhF0Ew/v+0QlVGbx0dqbyoPLj2wdvsJcOFMQ0gSbFw8dwaERJZNVVDosdAadtZeJ9JUnIl4KMMaN2Ikeb/iUSinJQgEg5h9dst+9aVqwWRDh4Rjwm1upVRUWa0AkaL8lcTnnu23sG2GLDPRxF7hKEdRJtbEnWLyNqwgT+Wv8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=BRyIoEjd; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="BRyIoEjd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C379C1F000E9;
	Wed, 24 Jun 2026 05:11:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782277914;
	bh=Jk950GfrXqHGByyhipFTOzS+5sSEW2cqHsn21R2pkWU=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=BRyIoEjdrCEVQVGvfSnHCl199U0RFCC0d+5GdkixUhi8/mHVnjtPVo3FTqf/2EO+y
	 998UAku68Zy1lF8C0QEjzQo8CQvJw8PGyaS4TeBOqUWnvEJXepegbicuGG+Vu4OSn/
	 0pEJUia5DFueSGi3Msrmhu5ABKbeyVCAi47So+yZhMrWceIx/8BHwXcuApXyqBU0AO
	 pAha76OAVZ8LEb5LxnygzRQfLnNmC38BvsEEsBUukRjrRkmgb+cGb7JwYUMqm+iIQM
	 HUEWOC3E/gku6a4xna6qip1vIA0WHKDfon374r2MBDArgMbrRMQa/UwhcoRKPbLBEO
	 I5iyKSVcs0qWQ==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v5 07/13] scsi: fnic: Route completions and resets by
 initiator role
Reply-To: sashiko-reviews@lists.linux.dev
To: "Karan Tilak Kumar" <kartilak@cisco.com>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20260624044334.3079-8-kartilak@cisco.com>
References: <20260624044334.3079-1-kartilak@cisco.com>
 <20260624044334.3079-8-kartilak@cisco.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 24 Jun 2026 05:11:53 +0000
Message-Id: <20260624051153.C379C1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 3 potential issue(=
s) to consider:

New issues:
- [High] Asynchronous NVMe IO completion work queued during driver teardown=
 executes after the fnic structure is freed, leading to a Use-After-Free.

Pre-existing issues:
- [Critical] The firmware reset completion handler calls `schedule_timeout(=
)` from a hardirq context, leading to a "scheduling while atomic" kernel pa=
nic.
- [High] Using a shared struct member (`fnic->lock_flags`) to store IRQ sta=
te for `spin_lock_irqsave` violates locking semantics and can corrupt IRQ s=
tate across CPUs.
--

commit 0746859ac4c31fbfb285f20a291564287cfa0119
Author: Karan Tilak Kumar <kartilak@cisco.com>

scsi: fnic: Route completions and resets by initiator role

Dispatch FCPIO command, response, and ITMF completions to the FCP or
NVMe handlers based on the configured role. Read the NVMe queue-depth
and timeout retry fields from firmware config, clean up NVMe I/O on
firmware reset, and skip SCSI-only cleanup for initiator roles.

[ ... ]
> diff --git a/drivers/scsi/fnic/fnic_scsi.c b/drivers/scsi/fnic/fnic_scsi.c
> index 04ab384033b19..9607684bc6107 100644
> --- a/drivers/scsi/fnic/fnic_scsi.c
> +++ b/drivers/scsi/fnic/fnic_scsi.c
[ ... ]
> @@ -734,6 +735,8 @@ static int fnic_fcpio_fw_reset_cmpl_handler(struct fn=
ic *fnic,
>  	/* Clean up all outstanding io requests */
>  	if (IS_FNIC_FCP_INITIATOR(fnic))
>  		fnic_cleanup_io(fnic, SCSI_NO_TAG);

[Severity: Critical]
This is a pre-existing issue, but does calling fnic_cleanup_io() from a
hardware interrupt context trigger a "scheduling while atomic" panic?

If a hardware interrupt handler like fnic_isr_msix_wq_copy() processes
a FCPIO_RESET_CMPL event:

fnic_wq_copy_cmpl_handler() ->
    fnic_fcpio_fw_reset_cmpl_handler() ->
        fnic_cleanup_io() ->
            schedule_timeout(msecs_to_jiffies(100))

Calling schedule_timeout() yields the CPU to the scheduler, which is
invalid from hardirq context. Will this crash the system upon firmware
reset completion?

> +	else if (IS_FNIC_NVME_INITIATOR(fnic))
> +		nvfnic_cleanup_all_nvme_ios(fnic);
> =20
>  	atomic64_set(&fnic->fnic_stats.fw_stats.active_fw_reqs, 0);
>  	atomic64_set(&fnic->fnic_stats.io_stats.active_ios, 0);
[ ... ]
> @@ -1457,11 +1461,22 @@ static int fnic_fcpio_cmpl_handler(struct vnic_de=
v *vdev,
>  		break;
> =20
>  	case FCPIO_ICMND_CMPL: /* fw completed a command */
> -		fnic_fcpio_icmnd_cmpl_handler(fnic, cq_index, desc);
> +		if (IS_FNIC_FCP_INITIATOR(fnic))
> +			fnic_fcpio_icmnd_cmpl_handler(fnic, cq_index, desc);
> +		else if (IS_FNIC_NVME_INITIATOR(fnic))
> +			nvfnic_fcpio_nvme_fast_cmpl_handler(fnic, desc);
> +		break;
> +
> +	case FCPIO_NVME_ERSP_HW_CMPL: /* fw completed NVMe ERSP */
> +		if (IS_FNIC_NVME_INITIATOR(fnic))
> +			nvfnic_fcpio_ersp_cmpl_handler(fnic, desc, 1);

[Severity: High]
This is a pre-existing issue, but does calling these NVMe completion handle=
rs
corrupt IRQ state across CPUs?

Looking at nvfnic_fcpio_nvme_fast_cmpl_handler() and
nvfnic_fcpio_ersp_cmpl_handler() in fnic_nvme.c, they both use a shared
structure member to save IRQ state:

    spin_lock_irqsave(&fnic->fnic_lock, fnic->lock_flags);

Because fnic->lock_flags is shared rather than a local stack variable,
concurrent threads acquiring the lock on different CPUs will overwrite
each other's saved IRQ states. When spin_unlock_irqrestore() is called,
the wrong IRQ state is restored.

>  		break;
> =20
>  	case FCPIO_ITMF_CMPL: /* fw completed itmf (abort cmd, lun reset)*/
> -		fnic_fcpio_itmf_cmpl_handler(fnic, cq_index, desc);
> +		if (IS_FNIC_FCP_INITIATOR(fnic))
> +			fnic_fcpio_itmf_cmpl_handler(fnic, cq_index, desc);
> +		else if (IS_FNIC_NVME_INITIATOR(fnic))
> +			nvfnic_fcpio_nvme_itmf_cmpl_handler(fnic, desc);
>  		break;
[ ... ]
> @@ -1650,6 +1665,15 @@ void fnic_wq_copy_cleanup_handler(struct vnic_wq_c=
opy *wq,
>  	unsigned long start_time =3D 0;
>  	uint16_t hwq;
> =20
> +	/*
> +	 * Clean up outstanding NVMe requests if firmware reset did not
> +	 * complete them before WQ copy cleanup.
> +	 */
> +	if (IS_FNIC_NVME_INITIATOR(fnic)) {
> +		nvfnic_cleanup_all_nvme_ios(fnic);
> +		return;
> +	}
> +

[Severity: High]
Can this unconditional cleanup lead to a use-after-free during driver
teardown?

The fnic_remove() sequence calls nvfnic_nvme_unload() which flushes
fnic->nvme_io_cmpl_work. It then calls fnic_cleanup() which invokes this
handler:

fnic_remove()
    nvfnic_nvme_unload()
        flush_work(&fnic->nvme_io_cmpl_work);
    fnic_cleanup()
        fnic_wq_copy_cleanup_handler()
            nvfnic_cleanup_all_nvme_ios()
                io_req->done()

If there are uncompleted requests, nvfnic_cleanup_all_nvme_ios() will
forcibly complete them, and io_req->done() queues new async work referencing
&fnic->nvme_io_cmpl_work.

Since fnic_remove() then frees the fnic structure without another flush,
won't the asynchronously executing work item dereference the freed fnic
pointer?

>  	/* get the tag reference */
>  	fcpio_tag_id_dec(&desc->hdr.tag, &id);
>  	id &=3D FNIC_TAG_MASK;

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260624044334.3079=
-1-kartilak@cisco.com?part=3D7
