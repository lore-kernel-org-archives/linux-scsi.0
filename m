Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 00AAF1A4F3C
	for <linux-scsi@vger.kernel.org>; Tue, 23 Jun 2026 01:49:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782179389; cv=none; b=sSxDTfM5ZdDU18LbBRJEKTCI0Y8wa3D4f09bEv/gtbN916y/5NXMlHOsXFUOw3xT17oMrUL8y2+axon/3EXsJKxnBCLRHmvLCp4kgEyKuRxqS0TAovL/IGfIQuRk9OozDIpEwdValXvBmteOdUkiZOvDyTGyOOkxrxS0KJWmR7c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782179389; c=relaxed/simple;
	bh=ttKpG3KqguLM7w2wCEMH0N4tVxyEKWFRQccquMvTAIk=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=P9JRc9cKPXkxvqCeJrS8NsM/SND2Hgft1W6IYMF7EAhoYODM1vc7yji76LVwA5hR1xOQrUm7y4GWsKBtgVpc8Leg2tcHfeT//EcVybElRefzzCrm/9AFBC/Vs8IcURi3SxkYTnvRU1BamwwQ3xbuRBKYu5n34tAtCbnJ2ibIa2g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=RIiLxOTb; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="RIiLxOTb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BE0E11F000E9;
	Tue, 23 Jun 2026 01:49:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782179388;
	bh=b8pv/MxNv8vMvQscPUIl76o/Vv3PCvYyrvlgJhuyATo=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=RIiLxOTbgRkzjSQr7AsypRq3SFx8kCTd5vZ3aDSoOJL/A3YblOYnFVl7EXkvNTXF7
	 NIDmBhhahMXIPkSV+ea8TgUGJCdwdId8xxlFIGYLY1GyIz2DTNBTOdDIMdkDAchAUc
	 GmQG6sEG22dnvsvA6bX7+9Pfe+n2XLBAnINwDx4yjJkglkveqKiqjvlAOqZKxnlgN/
	 OggdPg1Sl/fvL9orrykvEIHealHt6nz7774tusskrsus8+ZBh8VMEg4F4u02Qu3qeM
	 FmHNu+wr3z+e4dkhSbvn5cYgL/oEcmKarnaQB5tRIrB5hBPtD/Bwj1xKajdfBYfVvI
	 XkGmqzpj4YX3Q==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH 12/29] ibmvfc: add NVMe/FC Implicit Logout and Move
 Login support
Reply-To: sashiko-reviews@lists.linux.dev
To: "Tyrel Datwyler" <tyreld@linux.ibm.com>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20260623013035.3436640-13-tyreld@linux.ibm.com>
References: <20260623013035.3436640-1-tyreld@linux.ibm.com>
 <20260623013035.3436640-13-tyreld@linux.ibm.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 23 Jun 2026 01:49:47 +0000
Message-Id: <20260623014947.BE0E11F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:

Pre-existing issues:
- [High] Missing NULL pointer check on the event allocated for implicit log=
out in `ibmvfc_tgt_implicit_logout_and_del()`, leading to a crash in `ibmvf=
c_send_event()`.
--

commit d7f6f97d0c832e12c02c910b6675c0a3be2fb197
Author: Tyrel Datwyler <tyreld@linux.ibm.com>

ibmvfc: add NVMe/FC Implicit Logout and Move Login support

This patch adds protocol-specific handling for implicit logout and
move-login operations on NVMe/FC targets. It extends the existing target
relogin and migration flows by selecting NVMe/FC-specific opcodes and
updating the associated logging.

> diff --git a/drivers/scsi/ibmvscsi/ibmvfc-core.c b/drivers/scsi/ibmvscsi/=
ibmvfc-core.c
> index 53480d150042e..3e3d77e0d5172 100644
> --- a/drivers/scsi/ibmvscsi/ibmvfc-core.c
> +++ b/drivers/scsi/ibmvscsi/ibmvfc-core.c
[ ... ]
> @@ -4456,7 +4461,7 @@ static void ibmvfc_tgt_implicit_logout_and_del(stru=
ct ibmvfc_target *tgt)
>  		ibmvfc_set_tgt_action(tgt, IBMVFC_TGT_ACTION_DEL_RPORT);
>  		kref_put(&tgt->kref, ibmvfc_release_tgt);
>  	} else
> -		tgt_dbg(tgt, "Sent Implicit Logout\n");
> +		tgt_dbg(tgt, "%s Sent Implicit Logout\n", proto_type[tgt->protocol]);
>  }

[Severity: High]
This is a pre-existing issue, but does ibmvfc_tgt_implicit_logout_and_del()
need to check if evt is NULL before calling ibmvfc_send_event()?

If the reserved event pool is exhausted, __ibmvfc_tgt_get_implicit_logout_e=
vt()
can return NULL:

ibmvfc-core.c:__ibmvfc_tgt_get_implicit_logout_evt() {
        ...
        evt =3D ibmvfc_get_reserved_event(&vhost->crq);
        if (!evt)
                return NULL;
        ...
}

Unlike other callers such as ibmvfc_tgt_implicit_logout(), this function
lacks a NULL check and passes the evt pointer directly to ibmvfc_send_event=
(),
which unconditionally dereferences it:

ibmvfc-core.c:ibmvfc_send_event() {
        __be64 *crq_as_u64 =3D (__be64 *) &evt->crq;
        ...
}

Could this lead to a NULL pointer dereference under heavy queue pressure
or concurrent target teardowns?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260623013035.3436=
640-1-tyreld@linux.ibm.com?part=3D12
