Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2757637E5D9
	for <linux-scsi@vger.kernel.org>; Thu, 30 Jul 2026 23:19:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785453564; cv=none; b=KUWgXVbO5XHHlWd0VDQEPiEQFX2IYOwPk0CeN7FXANkxXmukO72PBwChF/s/LCivQKFzNvGbsWJfNxmwjPIz0SuMkFtxVe1QgTcbzFMgyz3CPQajw1K2TY5sjnp2rG23ja149auOefzDd4D2GtoOIR3L7YVBM/FLQsf9rNcq2mM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785453564; c=relaxed/simple;
	bh=m9TDK/vHF6mMMjtPB8rNhL4Yt0bA5xPg0GqS3AG+E30=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=RgwBZKD90A3Gq1pE4oC3zTb344OZqVaywdr4K8cI/zTPxIRqYzliE5V+mNqXN8N4kmvjJF/7J9dClIUHvA9QaL9bfQUY3n+nGPNkfcQFkdOb/tL4O8iilwsC7v3RJk6RUzov1U3wjYnRydSffKYoncNJhoWAXKGQs8kRl30AeEE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=h5dblHXq; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="h5dblHXq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9AB751F000E9;
	Thu, 30 Jul 2026 23:19:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785453562;
	bh=RPpf4GPRPJkBL0EwoGzozzoYM+ZenIOVCM8Psle/InQ=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=h5dblHXqWu2W+O/pppzDumQqiO83EjGmKx/wiiSFnqdu+Hb5mPAFRUbC32y6k/HDA
	 QXLLPn9oVzqx9dUsZeBbjxiMAl5o85rh6fMAwirAf6OWv5C59TKuaqN84W2nRvtutR
	 YJRKSD2Y0S6sRxMN0uEf4Kly9ehsOmDUEI9tGuxY2BZukamFEjhaEJZM6+T9mVDLiV
	 4+H5T4zayT8gY/3Og3q2voZP856xZE/bwVEljl41j00dnbvE8FVTplxk9ceHmyprgp
	 aqPWfG70+7bgf8h00xJJflX29M2EUAQ2ewS66Tf1UTtnpPBBNPqyhHHXAu3Hb8IT/k
	 m4RX00+TCQHQg==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v3 47/57] scsi: qla1280: Prepare for enabling lock
 context analysis
Reply-To: sashiko-reviews@lists.linux.dev
To: "Bart Van Assche" <bvanassche@acm.org>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <2b371d3536092dce61084c62923c9a4908598049.1785451174.git.bvanassche@acm.org>
References: <cover.1785451174.git.bvanassche@acm.org>
 <2b371d3536092dce61084c62923c9a4908598049.1785451174.git.bvanassche@acm.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 30 Jul 2026 23:19:22 +0000
Message-Id: <20260730231922.9AB751F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 2 potential issue(=
s) to consider:

New issues:
- [Medium] Incomplete `__must_hold` annotations on intermediate functions c=
alling `qla1280_mailbox_command`.

Pre-existing issues:
- [High] Lost wakeups and stack pointer leak in `qla1280_poll()`.
--

--- Patch [47]: [PATCH v3 47/57] scsi: qla1280: Prepare for enabling lock c=
ontext analysis ---
commit 1c9b404ec1f5e106acf48d1ff8e578d2279ecab4
Author: Bart Van Assche <bvanassche@acm.org>

scsi: qla1280: Prepare for enabling lock context analysis
   =20
Document locking requirements with __must_hold().

> diff --git a/drivers/scsi/qla1280.c b/drivers/scsi/qla1280.c
> index cdd6fe002c324..ebc878068684b 100644
> --- a/drivers/scsi/qla1280.c
> +++ b/drivers/scsi/qla1280.c

[ ... ]

> @@ -2413,6 +2425,7 @@ qla1280_nv_write(struct scsi_qla_host *ha, uint16_t=
 data)
>   */
>  static int
>  qla1280_mailbox_command(struct scsi_qla_host *ha, uint8_t mr, uint16_t *=
mb)
> +	__must_hold(ha->host->host_lock)
>  {

[Severity: Medium]
Will static analysis tools emit false-positive lock context warnings for ot=
her
functions that call qla1280_mailbox_command() but lack the __must_hold()
annotation?

For example, intermediate functions like qla1280_set_target_parameters(),
qla1280_chip_diag(), qla1280_start_firmware(), qla1280_init_rings(), and
qla1280_nvram_config() call qla1280_mailbox_command() while the lock is
already held, but they are missing the annotation added to other callers
in this patch.

[ ... ]

> @@ -2538,6 +2551,7 @@ qla1280_poll(struct scsi_qla_host *ha)

[Severity: High]
This is a pre-existing issue, but does qla1280_poll() leak completed
SCSI commands on its stack-allocated done_q?

Looking at the qla1280_poll() implementation nearby, it allocates a local
list:

qla1280_poll(struct scsi_qla_host *ha)
{
    LIST_HEAD(done_q);
    ...
    if (data & RISC_INT)
        qla1280_isr(ha, &done_q);

    if (!list_empty(&done_q))
        qla1280_done(ha);
}

If qla1280_isr() populates this local done_q with completed commands, they
appear to be ignored when qla1280_done() is called, because qla1280_done()
only processes ha->done_q. When qla1280_poll() returns, the stack frame is
destroyed, permanently leaking these commands and leaving their list node
pointers aimed at invalid stack memory.

>   */
>  static int
>  qla1280_bus_reset(struct scsi_qla_host *ha, int bus)
> +	__must_hold(ha->host->host_lock)
>  {

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/cover.1785451174.gi=
t.bvanassche@acm.org?part=3D47
