Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C41923264E7
	for <linux-scsi@vger.kernel.org>; Fri, 14 Aug 2026 22:00:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786744826; cv=none; b=o/tNizrX2dOCRbMJFhUdnacArjy6UVTYYeNOnYtbELYTnAixowDk66K/pwx4Xh526eR+UlRshzMrpLa70I6TNN4QDDbGqA1tf9vuUbt5qG+orhpupANWh2FBwJgfvHY2Aey/WvQkoCNM0ZJLuotnFxIZvGDQa/FaUJUIwiqec3c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786744826; c=relaxed/simple;
	bh=hIJa19rntekGgKlamqLLlnArIpS3gDdTWjKykOnun3I=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=CbS1iF3NukjhYNGWEwiVGGQAJluG2uLLPdtZiB5EnoZi3jQJhMdOuuKpKv/5cvWvek+aWcRVeuUoD3uNQaoLXVjTLnuTO2bV3pjcJi9U9XGtyK5ZjTXwIg8b+2QBbb4qNQPoWRQTmX637xcp0niajRhnCwOhIEOCfo/goJ4QoCM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ZK3MqCf8; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ZK3MqCf8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1D0F31F000E9;
	Fri, 14 Aug 2026 22:00:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786744825;
	bh=NNbHoQZqI2emv6BQs7Q4FfBavUYoQnV9HHc9wn/TIus=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=ZK3MqCf8DaXMkEcT6iUneho5N/syKJH/weU3BEJu7UJv+WqsSlBpscPBT4HdRpyKt
	 BUk2qE9E9D3XP/6H12UgtH2RlWTDFYfXybeZi/JVaTxRiIG5S9/zZ+PoZGS3FPZ5zv
	 GZR3JZJyiTFN6qi36bwkwxN99Z49gOa72nJFUTzWbtQvVueztubehUCCYSoHp5ICCS
	 LbMMhDILHlE0DtGl+Yr7u++ui5NLHhwfoEdQ5oURPTS4EMHH1WLsB5wCBfWsE+Sqs9
	 ElsPI3qm5wKVglkisjSVww3+X+WV0Z9DpNBGAB3e761rttczcMghxmjKi0NptdOKdR
	 YVQwYpYJ2eN6w==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH] ufs: core: Disable queue depth tracking support
Reply-To: sashiko-reviews@lists.linux.dev
To: "Bart Van Assche" <bvanassche@acm.org>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20260814214951.80673-1-bvanassche@acm.org>
References: <20260814214951.80673-1-bvanassche@acm.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 14 Aug 2026 22:00:24 +0000
Message-Id: <20260814220025.1D0F31F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 3 potential issue(=
s) to consider:

New issues:
- [High] Silently disabling userspace's ability to modify the UFS device qu=
eue depth via sysfs.
- [Medium] Unrelated and undocumented modification to the InfiniBand SRP ta=
rget driver (`ib_srp.c`).

Pre-existing issues:
- [High] Unresolved concurrency and IRQ-handling bug in SCSI core (`scsi_tr=
ack_queue_full`) and Block layer (`ioc_rqos_queue_depth_changed`).
--

--- Patch [1]: [PATCH] ufs: core: Disable queue depth tracking support ---
commit f181b5b33f08308dbca6a708c0dbc602ecd352b0
Author: Bart Van Assche <bvanassche@acm.org>

ufs: core: Disable queue depth tracking support

Disable queue depth tracking support because UFS devices shouldn't need
queue tracking support. The queue depth tracking code is not thread-safe,
and scsi_track_queue_full() is called from interrupt context but not all
code called by it is IRQ-safe.

>      - scsi_track_queue_full() is called from interrupt context but not a=
ll
>        code called by scsi_track_queue_full() is IRQ-safe. Here is an
>        example of a call chain that may cause interrupts to be enabled,
>        something that is not allowed from interrupt context:
>    =20
>        ufshcd_mcq_poll_cqe_lock()
>          ufshcd_compl_one_cqe()
>            scsi_done()
>              blk_mq_complete_request()
>                scsi_complete()
>                  scsi_decide_disposition()
>                    scsi_handle_queue_full()
>                      scsi_track_queue_full()
>                        scsi_change_queue_depth()
>                          blk_set_queue_depth()
>                            rq_qos_queue_depth_changed()
>                              ioc_rqos_queue_depth_changed()
>                                spin_lock_irq()
>                                spin_unlock_irq() <- enables interrupts

[Severity: High]
This is a pre-existing issue, but by only disabling queue depth tracking
locally in the UFS driver, are dozens of other SCSI drivers that set
.track_queue_depth =3D 1 still exposed to this IRQ-safety bug?

Since ioc_rqos_queue_depth_changed() unconditionally uses spin_unlock_irq(),
and scsi_track_queue_full() has no locking for sdev->last_queue_full_count,
should this concurrency and IRQ unmasking issue be addressed in the SCSI co=
re
and block layers directly?

> diff --git a/drivers/infiniband/ulp/srp/ib_srp.c b/drivers/infiniband/ulp=
/srp/ib_srp.c
> index 6b429ef63f8f3..d671a3d3359ba 100644
> --- a/drivers/infiniband/ulp/srp/ib_srp.c
> +++ b/drivers/infiniband/ulp/srp/ib_srp.c
> @@ -1044,6 +1044,10 @@ static void srp_remove_target(struct srp_target_po=
rt *target)
>  	WARN_ON_ONCE(target->state !=3D SRP_TARGET_REMOVED);
> =20
>  	srp_del_scsi_host_attr(target->scsi_host);
> +	/*
> +	 * The srp_remove_host() call decrements the rport reference count.
> +	 * Keep the rport as long as its needed.
> +	 */

[Severity: Medium]
Was this modification to the InfiniBand SRP target driver included by
accident?

The commit message only mentions disabling queue depth tracking for UFS, but
this introduces an undocumented change to srp_remove_target().

>  	srp_rport_get(target->rport);
>  	srp_remove_host(target->scsi_host);
>  	scsi_remove_host(target->scsi_host);

[ ... ]

> diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
> index d3044a3089b53..bdb926a9f2d75 100644
> --- a/drivers/ufs/core/ufshcd.c
> +++ b/drivers/ufs/core/ufshcd.c

[ ... ]

> @@ -9580,7 +9566,6 @@ static const struct scsi_host_template ufshcd_drive=
r_template =3D {
>  	.sdev_init		=3D ufshcd_sdev_init,
>  	.sdev_configure		=3D ufshcd_sdev_configure,
>  	.sdev_destroy		=3D ufshcd_sdev_destroy,
> -	.change_queue_depth	=3D ufshcd_change_queue_depth,

[Severity: High]
Does removing .change_queue_depth from the template completely disable
userspace's ability to modify the queue depth via sysfs?

Looking at sdev_store_queue_depth(), it returns -EINVAL if this callback is
missing:

drivers/scsi/scsi_sysfs.c:sdev_store_queue_depth() {
    ...
	if (!sht->change_queue_depth)
		return -EINVAL;
    ...
}

Could .change_queue_depth be set to scsi_change_queue_depth instead to
preserve the manual sysfs tuning interface?

>  	.eh_abort_handler	=3D ufshcd_abort,
>  	.eh_device_reset_handler =3D ufshcd_eh_device_reset_handler,
>  	.eh_host_reset_handler   =3D ufshcd_eh_host_reset_handler,

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260814214951.8067=
3-1-bvanassche@acm.org?part=3D1
