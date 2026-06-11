Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5FD023E022A
	for <linux-scsi@vger.kernel.org>; Thu, 11 Jun 2026 11:21:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781176916; cv=none; b=pdr7uq7hs0pxFEDaeCnAuZc535JoGy2Kcy2BxmL9w3+W3rqc3QbHyzKeArtnPQ3yAm3Bh24xhRplHW/mDesRCRKdEJNJ81/HuLSc7UJi3sNWc7G/D5S62P9V9J1P3P+8PHR9giIOCzJzuXQQz5/94HR3qQ8UV8r8cbwTytEag4Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781176916; c=relaxed/simple;
	bh=zTXzeRbsAySNExeDAgC5s5oqfZjCoxStM4wJXTlvc5I=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=fV8VdaBDIGHs0G8Iohj53TQM8BYurPdD4oCcoDzhfFKpj7HKHwHQnYxDjegGjMTIblp8ot78mcpLm72hadEfdy/5JyXv4G+6Hzoc/NX+y8OCU5l2SqN0kEiNSnoycyHM/su3aEQG91YYNF98l2yf3rqniAZ6w86L/X28eGiixPg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Bl025dUi; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Bl025dUi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E81801F00893;
	Thu, 11 Jun 2026 11:21:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781176915;
	bh=tec8RFZcrXdFGtrltST8PX7dTyh34prTR0ucfobfKxU=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=Bl025dUi7AQIqgAWKI++bXg1Jq+5MndAQHslY2N+OnSSO5bD3hrKgSiNFQ53SHUfJ
	 w8UZzZbo42s5tSw79i4xTKRfJt4jnfknx4nQ0wWedG2QWLHvmV8qaXcfeF2hIbMnc1
	 0Z2sIb37nq0D+DuJhmBgSTFEnJ05EZyc4rNzASDHE4a/GVeVmg04+QRRcAm1sFZXuG
	 6GoHTznRHvrWw4FuSps2UqY2C5U1krrmhVdUTKLf0MSxDMkRiI1ipFP0T1hwG3Ju6l
	 jqYqHW36M1k3beKnjL12QFp5RnvsLyOZxbr0YhaoUndaKzhzqoqFxf+lcvER0QC8cx
	 4DuBL3UzW2lUA==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH] scsi: qla2xxx: fix refcount leak in
 qla24xx_async_prli()
Reply-To: sashiko-reviews@lists.linux.dev
To: "WenTao Liang" <vulab@iscas.ac.cn>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20260611110919.74911-1-vulab@iscas.ac.cn>
References: <20260611110919.74911-1-vulab@iscas.ac.cn>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 11 Jun 2026 11:21:54 +0000
Message-Id: <20260611112154.E81801F00893@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [High] Double-decrement (underflow) of `vha->vref_count` on the error pat=
h of `qla24xx_async_prli()`.
--

commit 96156510fc7447ae3d281225a3388973efa74abd
Author: WenTao Liang <vulab@iscas.ac.cn>

scsi: qla2xxx: fix refcount leak in qla24xx_async_prli()

This commit attempts to fix a vha refcount leak in the error path of
qla24xx_async_prli by explicitly calling QLA_VHA_MARK_NOT_BUSY(vha) after
releasing the command kref.

> diff --git a/drivers/scsi/qla2xxx/qla_init.c b/drivers/scsi/qla2xxx/qla_i=
nit.c
> index e746c9274cded..8dd717dfcc144 100644
> --- a/drivers/scsi/qla2xxx/qla_init.c
> +++ b/drivers/scsi/qla2xxx/qla_init.c
> @@ -1352,6 +1352,7 @@ qla24xx_async_prli(struct scsi_qla_host *vha, fc_po=
rt_t *fcport)
>  done_free_sp:
>  	/* ref: INIT */
>  	kref_put(&sp->cmd_kref, qla2x00_sp_release);
> +	QLA_VHA_MARK_NOT_BUSY(vha);

[Severity: High]
Does this result in a double-decrement of the vha refcount?

Looking at the release callback chain, kref_put() calls qla2x00_sp_release(=
),
which unconditionally calls sp->free(sp).

During initialization, qla2x00_init_async_sp() sets the free callback to
qla2x00_sp_free(), which then calls qla2x00_rel_sp(). Finally,
qla2x00_rel_sp() calls QLA_VHA_MARK_NOT_BUSY(sp->vha).

If the refcount is already decremented by the kref_put() callback chain:

kref_put()
  qla2x00_sp_release()
    qla2x00_sp_free()
      qla2x00_rel_sp()
        QLA_VHA_MARK_NOT_BUSY()

Does adding an explicit call here cause an underflow?

>  	fcport->flags &=3D ~FCF_ASYNC_SENT;
>  	return rval;
>  }

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260611110919.7491=
1-1-vulab@iscas.ac.cn?part=3D1
