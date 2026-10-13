Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B40661862
	for <linux-scsi@vger.kernel.org>; Tue, 13 Oct 2026 00:03:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791849803; cv=none; b=a46r81bmFjDwfQUw97zuVTB9H5LuaTxpDBoW46gCnf09uuWnFPya/kTNOHtE8HpYMWomPgmHzDR5+NfmUfM9pxzrgT7LoSZnM4whQWq75fJdvT3KHYUIuPwGy8YpZMMSjjI33zHbNqtWEeBH8nJnyHF1tLsPNSrspVvZFNU0DJ8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791849803; c=relaxed/simple;
	bh=nKVlVRgUt6fR95hPt1EgdK+0QiT3Bodca6pScSnhZyg=;
	h=Message-ID:From:Subject:To:Cc:In-Reply-To:References:Content-Type:
	 Date; b=O0qQHNoLSNUe/vSn/A9P7Y8gQiLtY0wgtXIOjR/BqifKglFt0CpWS8sNHTdtjATr6GHgvnwxgXAMxKqlcmJ2hzeXZALZC07m9lJtJj91stEwiXygLHaHrchF8gvGf4gqfncpGBUqmJN8/3bKBz4Kv51lqxO7V3LBqRT63oA76t4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=YF+wUo2i; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="YF+wUo2i"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6AA2B1F0089B;
	Tue, 13 Oct 2026 00:03:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791849802;
	bh=bp2FpOUtagmCImK4XdtntTIrq08znyx6Kh7Jwta/QP4=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=YF+wUo2iFbbQcG3vuLcpjWXIA3Ju074flBDObV+cNIlYgGlgNdgnJef50h/6seiSb
	 jZEyplITG0ne8us9MgJsOiq2GTRUdBpCQ4m9vFBXPuHZpy6nel/boBRKKqllOZbElu
	 EzMglQl6vC1fP7PKeVAmHXay7fnLowg20oHVze5UQQ1jsdeQM9FtbxyelWV1Ay8WN6
	 2BhqJkpnK1qMi+WDUFQuk/FVA1DgZUZNGr3iOG2qFSIOj/uQpW4478E/UNtOrkJH6w
	 So//YoYG9fxuPgcYLpK6ZnugOcgoR/nzcIwNIh21qKJEySo3RIQ4GXkQ0SrfzmfeDp
	 gmLaUTOiO9UgQ==
Message-ID: <sashiko-outbox-168765@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v6 1/8] lpfc: Fix use-after-free in
 lpfc_cmpl_ct_cmd_vmid
Reply-To: sashiko-reviews@lists.linux.dev
To: "Nigel Kirkland" <nkirkland2304@gmail.com>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20261013001648.62289-2-nkirkland2304@gmail.com>
References: <20261013001648.62289-1-nkirkland2304@gmail.com>
 <20261013001648.62289-2-nkirkland2304@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 13 Oct 2026 00:03:21 +0000
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [Medium] scsi: lpfc: evaluation of uninitialized response payload on tran=
sport error
--

commit c46419e38a4d473126adc74a9b8003eb31bdd1e9
Author: Nigel Kirkland <nkirkland2304@gmail.com>

lpfc: Fix use-after-free in lpfc_cmpl_ct_cmd_vmid

This commit resolves a use-after-free issue in lpfc_cmpl_ct_cmd_vmid by
removing an early call to lpfc_ct_free_iocb for SLI_CTAS_DALLAPP_ID command=
s.
The previous code freed the IOCB and then continued to access the response
buffer.

> diff --git a/drivers/scsi/lpfc/lpfc_ct.c b/drivers/scsi/lpfc/lpfc_ct.c
> index 0734ab3be3e30..f709e50875770 100644
> --- a/drivers/scsi/lpfc/lpfc_ct.c
> +++ b/drivers/scsi/lpfc/lpfc_ct.c
> @@ -3576,8 +3576,6 @@ lpfc_cmpl_ct_cmd_vmid(struct lpfc_hba *phba, struct=
 lpfc_iocbq *cmdiocb,
>  	int i;
> =20
>  	cmd =3D be16_to_cpu(ctcmd->CommandResponse.bits.CmdRsp);
> -	if (cmd =3D=3D SLI_CTAS_DALLAPP_ID)
> -		lpfc_ct_free_iocb(phba, cmdiocb);
> =20
>  	if (lpfc_els_chk_latt(vport) || get_job_ulpstatus(phba, rspiocb)) {
>  		if (cmd !=3D SLI_CTAS_DALLAPP_ID)

[Severity: Medium]
Does this code evaluate uninitialized memory if there is a transport error?

If get_job_ulpstatus() indicates a transport error, the device did not popu=
late
the response buffer. Since the error handler is intentionally bypassed for
SLI_CTAS_DALLAPP_ID:

drivers/scsi/lpfc/lpfc_ct.c:lpfc_cmpl_ct_cmd_vmid() {
	if (lpfc_els_chk_latt(vport) || get_job_ulpstatus(phba, rspiocb)) {
		if (cmd !=3D SLI_CTAS_DALLAPP_ID)
			goto free_res;
	}
	...

The code will then fall through to the next check:

	if (be16_to_cpu(rsp) =3D=3D SLI_CT_RESPONSE_FS_RJT) {
	...

And evaluate rsp, ctrsp->ReasonCode, and ctrsp->Explanation from the outp->=
virt
buffer. Since lpfc_alloc_ct_rsp() allocates this buffer via lpfc_mbuf_alloc=
()
without zero-initialization, this reads uninitialized memory.

Could this lead to non-deterministic behavior, such as spuriously retrying =
the
command or incorrectly assuming success and deregistering all VMID app IDs?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261013001648.6228=
9-1-nkirkland2304@gmail.com?part=3D1
