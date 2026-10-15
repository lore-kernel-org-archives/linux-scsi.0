Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C8AA749F13C
	for <linux-scsi@vger.kernel.org>; Thu, 15 Oct 2026 07:49:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792050549; cv=none; b=EjWubQtS+SmZumcJj9eiep63pJA+9gW5ZzOP6aAUSF1FtVM4e3Knhu8W8HGJHzAeTcG+sKpY4lxdxn8RnLwCkAsefErZKEhBFqMzQ0pQgJkhV2pF8yH+R+QwA7FlqhdLey3gI1++eIi4xmq2mPUE6I1h4vEd0DLOShC9BcwdauY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792050549; c=relaxed/simple;
	bh=wnp2RGDCu+Z5tYkxqYXqv/kCvZBx9UM+bNuGE4LAlRw=;
	h=Message-ID:From:Subject:To:Cc:In-Reply-To:References:Content-Type:
	 Date; b=U2CbgKEF0OG75jg9SfMnN2U6AxKAiLRmS2bCcIn4eLlhGxdfECQbDuMjcKP5HMgAMPtF8yS9jSeCtNltkBsuopbptDWR5IiftJIuI4ldmVTGmmKtBJyOoSuSU1ST2bF0JnwhSuQ5tYRAoGj3af5mk9Mr+jgCw0orwnfF97nU+l8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=kuS9+SWZ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="kuS9+SWZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0ED151F000C4;
	Thu, 15 Oct 2026 07:49:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792050542;
	bh=qlB8tfZeuzqBJlF9F5T2eFV98DJHVwJewp2XSeZcFg0=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=kuS9+SWZd+RdEtHudy2WoSRRplFnoqsv113NxC2pNk6qGUF/FxjbGsqiK5YqNtwWE
	 dMjnZMT/Rh5aAZ1C3WtEt3fH6Yhl88gu3IAC3YpBzrxAQOCsJRZS9EomNpBrnnPg4N
	 aqKOD/i8Fmsmiikx/YPloZvsoGVLr3twbAPtiEwqfwBB2cTB2HQo0x3b0SrDyNqW20
	 atFxP30dbAQg8StFH3x9oX4NRqdAop9jCatbLlSpVT+Clt4a7rIdVxzPelSZwqn4yI
	 JpaBUp1+VIyEv36fT0VLsc6M9vfbP8J6/urXuKv7qk2lLS01mjBA8RTlDlhfjY3iuL
	 xMtwnN6tn2n2w==
Message-ID: <sashiko-outbox-172433@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH 3/3] scsi: aic94xx: validate the EDB index in
 asd_get_tmf_resp_tasklet()
Reply-To: sashiko-reviews@lists.linux.dev
To: "Yehyeong Lee" <yhlee@isslab.korea.ac.kr>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20261015072612.4144043-4-yhlee@isslab.korea.ac.kr>
References: <20261015072612.4144043-1-yhlee@isslab.korea.ac.kr>
 <20261015072612.4144043-4-yhlee@isslab.korea.ac.kr>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 15 Oct 2026 07:49:01 +0000
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [High] scsi: aic94xx: type confusion and OOB array access due to unchecke=
d index_escb
--

commit 6e22ba829d4a35f4965fabb73864e8a26c77e6c0
Author: Yehyeong Lee <yhlee@isslab.korea.ac.kr>

scsi: aic94xx: validate the EDB index in asd_get_tmf_resp_tasklet()

This patch validates the empty data buffer index (edb_id) extracted from the
done list status block in asd_get_tmf_resp_tasklet(). It adds bounds checki=
ng
before indexing seq->edb_arr[] to prevent out-of-bounds access.

> diff --git a/drivers/scsi/aic94xx/aic94xx_tmf.c b/drivers/scsi/aic94xx/ai=
c94xx_tmf.c
> index 28ac92b041fe3..1ee6009d83051 100644
> --- a/drivers/scsi/aic94xx/aic94xx_tmf.c
> +++ b/drivers/scsi/aic94xx/aic94xx_tmf.c
> @@ -282,6 +282,12 @@ static int asd_get_tmf_resp_tasklet(struct asd_ascb =
*ascb,
>  		return res;
>  	}
> =20
> +	if (edb_id < 0 || edb_id >=3D ASD_EDBS_PER_SCB) {
> +		ASD_DPRINTK("edb_id is %d! resp_sb->flags is 0x%x\n",
> +			    edb_id, resp_sb->flags);

[Severity: High]
Does resp_sb->index_escb need validation as well?

Looking at asd_get_tmf_resp_tasklet(), the index_escb value is extracted and
passed directly to asd_tc_index_find():

drivers/scsi/aic94xx/aic94xx_tmf.c:asd_get_tmf_resp_tasklet() {
    ...
	escb =3D asd_tc_index_find(&asd_ha->seq,
				 (int)le16_to_cpu(resp_sb->index_escb));
    ...
}

Since index_escb comes from the untrusted firmware status block, could
an invalid index cause an out-of-bounds read in asd_tc_index_find() across
seq->tc_index_array?

Furthermore, could this lead to type confusion? The returned escb pointer
is used at the end of the function:

drivers/scsi/aic94xx/aic94xx_tmf.c:asd_get_tmf_resp_tasklet() {
    ...
	asd_invalidate_edb(escb, edb_id);
	return res;
}

If a normal SCB index was returned instead of an Empty SCB, could
asd_invalidate_edb() corrupt the state of normal pending tasks by assuming
the pointer points to an Empty SCB without verifying its opcode?

> +		return res;
> +	}
> +
>  	edb =3D asd_ha->seq.edb_arr[edb_id + escb->edb_index];
>  	ascb->tag =3D *(__be16 *)(edb->vaddr+4);
>  	fh =3D edb->vaddr + 16;

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261015072612.4144=
043-1-yhlee@isslab.korea.ac.kr?part=3D3
