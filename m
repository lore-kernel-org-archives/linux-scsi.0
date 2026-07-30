Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A109471402
	for <linux-scsi@vger.kernel.org>; Thu, 30 Jul 2026 23:15:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785453304; cv=none; b=LlH4VhsO7qnbBmXGTztvsqWdcDrpSwYV4KdPaAavWNl4hWQugW+2mFf8nBtVP73YbYaELAGMYFa3kEH+MMgn+frDHr8yVE17lS/zODVM4F2PQmLC7CabuTYvc6ZYRILNMXuWuhx7Hvogcm5aT7csrin4Kbx3gpor/tjMalGZD78=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785453304; c=relaxed/simple;
	bh=gqI2EphiOdXCd84+tL9INPJgEEm9FxB1aVNW7l5Gb3A=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=uc4UVJQaLAlHSs6ag58csIwDcWpuSteOtPYKwH8ptoqUurNlXm6MQjiB4BXqb8Ve7lbi/Xo/zHG9lIzyJ/2guJnvYH929b+EwZ9f8K09qzipCxhoxgCeX+Dz4+8+SD+/jL+QO0KKAGpMbAzuW6wTpgPQ6FHdC55y6/iz258iQd0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=e8eJGbdT; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="e8eJGbdT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E07251F00A3A;
	Thu, 30 Jul 2026 23:15:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785453303;
	bh=HYA24B0AGkZpQVEOBlXp6PR6nZoF3uhAwnErnKeZFzo=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=e8eJGbdTEUJhwJI+aF2K3jNJQqakvaPTA95FrH6Ovy9aq6XWypGS0DXaSQ+g1fS06
	 QQTJiwJ7QV9Ovu+t/9a9kDDa2g3nal+UPkBdoW66+gMubPVbikpEGr7WqiD7NP+j5b
	 hEHMyCeXo5PTJZLkwJtpKXN/QH3IE2B1358n0sSvPLE3RFhT3s3IiKGODi6M88+HUg
	 JuX0v0MzdGCQfUBL6Pi4ZRXyF3mwtLiMIGupC8Q5AJbBDYp8HSIMbbhBYlKJT5j5Ga
	 fpR1PbfPPh0NvXP1s/8oA8hMf7gpNV5NPpNHpZxr6v7DCILtfw+DQGaFqfH+UB1HZQ
	 BYAXMhj7+SqlQ==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v3 39/57] scsi: megaraid_sas: Prepare for enabling lock
 context analysis
Reply-To: sashiko-reviews@lists.linux.dev
To: "Bart Van Assche" <bvanassche@acm.org>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <5b1efea947bc2923e205d7c920b15b356fc4eeff.1785451174.git.bvanassche@acm.org>
References: <cover.1785451174.git.bvanassche@acm.org>
 <5b1efea947bc2923e205d7c920b15b356fc4eeff.1785451174.git.bvanassche@acm.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 30 Jul 2026 23:15:02 +0000
Message-Id: <20260730231502.E07251F00A3A@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [Medium] Incorrect `__must_hold` annotations misrepresent API contracts a=
nd mask missing lock acquisitions
--

--- Patch [39]: [PATCH v3 39/57] scsi: megaraid_sas: Prepare for enabling l=
ock context analysis ---
commit e0b92da41c18eebd6dc6b3dd8f685d565a0c3f5f
Author: Bart Van Assche <bvanassche@acm.org>

scsi: megaraid_sas: Prepare for enabling lock context analysis
   =20
This commit prepares the megaraid_sas driver for lock context analysis
by documenting locking requirements with __must_hold().

> diff --git a/drivers/scsi/megaraid/megaraid_sas.h b/drivers/scsi/megaraid=
/megaraid_sas.h
> index 8ee2bfe475715..67713173793a3 100644
> --- a/drivers/scsi/megaraid/megaraid_sas.h
> +++ b/drivers/scsi/megaraid/megaraid_sas.h
> @@ -2696,15 +2696,18 @@ __le16 get_updated_dev_handle(struct megasas_inst=
ance *instance,
>  			      struct MR_DRV_RAID_MAP_ALL *drv_map);
>  void mr_update_load_balance_params(struct MR_DRV_RAID_MAP_ALL *map,
>  	struct LD_LOAD_BALANCE_INFO *lbInfo);
> -int megasas_get_ctrl_info(struct megasas_instance *instance);
> +int megasas_get_ctrl_info(struct megasas_instance *instance)
> +	__must_hold(&instance->reset_mutex);

[Severity: Medium]
Is this annotation accurate for all callers?

megasas_get_ctrl_info() is called by un-annotated and unprotected paths=20
like megasas_init_fw(). Adding __must_hold() here implies the caller is=20
responsible for holding the lock, but the caller doesn't currently acquire=
=20
it. Will this cause false positive warnings when lock context analysis is=20
enabled?

[ ... ]

> diff --git a/drivers/scsi/megaraid/megaraid_sas_base.c b/drivers/scsi/meg=
araid/megaraid_sas_base.c
> index ecd365d78ae3c..ccefe5841a17b 100644
> --- a/drivers/scsi/megaraid/megaraid_sas_base.c
> +++ b/drivers/scsi/megaraid/megaraid_sas_base.c
[ ... ]
> @@ -7789,6 +7796,7 @@ megasas_suspend(struct device *dev)
>   */
>  static int __maybe_unused
>  megasas_resume(struct device *dev)
> +	__must_hold(&((struct megasas_instance *)dev_get_drvdata(dev))->reset_m=
utex)
>  {
>  	int rval;
>  	struct Scsi_Host *host;

[Severity: Medium]
Does the generic PM core actually hold this driver-private mutex when
invoking the resume callback?

Since megasas_resume() is used as a device power management callback, its
callers outside the driver do not know about or hold reset_mutex. Will
this annotation lead to static analysis errors on the PM core invocation
path?

[ ... ]

> diff --git a/drivers/scsi/megaraid/megaraid_sas_fusion.c b/drivers/scsi/m=
egaraid/megaraid_sas_fusion.c
> index 056cbe50e19ed..a55094a31c829 100644
> --- a/drivers/scsi/megaraid/megaraid_sas_fusion.c
> +++ b/drivers/scsi/megaraid/megaraid_sas_fusion.c
> @@ -1792,6 +1792,7 @@ static inline void megasas_free_ioc_init_cmd(struct=
 megasas_instance *instance)
>   */
>  static u32
>  megasas_init_adapter_fusion(struct megasas_instance *instance)
> +	__must_hold(&instance->reset_mutex)
>  {
>  	struct fusion_context *fusion;
>  	u32 scratch_pad_1;

[Severity: Medium]
Will this annotation trigger analysis errors during adapter initialization?

megasas_init_adapter_fusion() is invoked via the init_adapter function
pointer in megasas_init_fw(). The caller does not appear to hold reset_mutex
before invoking the pointer. Should the lock acquisition be added to the=20
callers, or is this annotation overly strict here?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/cover.1785451174.gi=
t.bvanassche@acm.org?part=3D39
