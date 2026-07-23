Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E428721FF30
	for <linux-scsi@vger.kernel.org>; Thu, 23 Jul 2026 00:38:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784767115; cv=none; b=uJ21Xtlam3mnCDB/i/gnNOsQi9RNa40vZuZ/PS49vlm66e6aKsWDVeSVBt8lekxXooR0VoMTmQzarV2bidLWGllioSyI+gvr7WWe6onjd+GEh/ihc1w3psxNzjq8R0RjNJdxl3y9aDZk22L1Br08BNzPSdtsJVS+rOYlaY59cYk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784767115; c=relaxed/simple;
	bh=c6Tlkv01odljv3zv4j1VyxNVTjvJ6s8CMvC+A58hq1Y=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=KaYPd2D/Jii0DkstIpwjhCAJKB8pmH3g/zgbQvw00kyMvD9iWESBqRCkn54yr8xM+yy8SvwAb5WLVRu1fs+usF91PWVWOMel9GJzbk1/9fXQZCwXMFXT9xO0BBMCapA7+NlOlXJCb8g74c0pPL2NGSxFb4hm11ilgZNz5SF9z10=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=PA95vUZO; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="PA95vUZO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 648DD1F000E9;
	Thu, 23 Jul 2026 00:38:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784767113;
	bh=lPFiqb9uGV0qOOvJynKhP3JWDOgfyexnj/WbqBHavEQ=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=PA95vUZOjOxMg2o+gumLq9JnsdjnZcJq2O+LkIPCTUq56STiyJ8YcW7nMWwJOKK+v
	 NLDZ2wlamQIOes+T5qRlE4J4kDePDdP5kQHhRdLXtuVTzoM1XANlIPSisHjLgEUkm7
	 27wuRG8EHhMoPph2jMG1uQW5IkRuS8YEYJ+2BVSRSttMQNkTiiyTuRbgC4dgdpH4Xn
	 VBftA4YFggsyGoqy7veCyUdY6sIyafgfGbcGyAPH7tQz2E/v62T0lyAkY8LBxs3W4i
	 33w0yF+CkyOK8QZUepiMFtyuavrTcD72FLdCwMKOhcjEoL99tX6gb2Tb/YsmFPbjOT
	 MjVHJQIVpo8hA==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v2 17/33] ibmvfc: add NVMe/FC Port Login support
Reply-To: sashiko-reviews@lists.linux.dev
To: "Tyrel Datwyler" <tyreld@linux.ibm.com>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20260723000149.969416-18-tyreld@linux.ibm.com>
References: <20260723000149.969416-1-tyreld@linux.ibm.com>
 <20260723000149.969416-18-tyreld@linux.ibm.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 23 Jul 2026 00:38:32 +0000
Message-Id: <20260723003833.648DD1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 2 potential issue(=
s) to consider:
- [High] The newly added NVMe Port Login logic is unreachable because NVMe =
targets are never allocated.
- [High] A successful NVMe Port Login (PLOGI) will incorrectly proceed to i=
ssue a SCSI Process Login (PRLI).
--

--- Patch [17]: [PATCH v2 17/33] ibmvfc: add NVMe/FC Port Login support ---
commit dfa3e967fac7e65d31ae01b75c2fc44ab7b459fd
Author: Tyrel Datwyler <tyreld@linux.ibm.com>

ibmvfc: add NVMe/FC Port Login support

Expand the target login path to issue the NVMe/FC-specific port login
MAD for NVMe targets.

> diff --git a/drivers/scsi/ibmvscsi/ibmvfc-core.c b/drivers/scsi/ibmvscsi/=
ibmvfc-core.c
> index 66fcff7ac834b..adc146214e668 100644
> --- a/drivers/scsi/ibmvscsi/ibmvfc-core.c
> +++ b/drivers/scsi/ibmvscsi/ibmvfc-core.c
> @@ -4212,7 +4212,7 @@ static void ibmvfc_tgt_plogi_done(struct ibmvfc_eve=
nt *evt)
>  	ibmvfc_set_tgt_action(tgt, IBMVFC_TGT_ACTION_NONE);
>  	switch (status) {
>  	case IBMVFC_MAD_SUCCESS:
> -		tgt_dbg(tgt, "Port Login succeeded\n");
> +		tgt_dbg(tgt, "%s Port Login succeeded\n", proto_type[tgt->protocol]);

[Severity: High]
If an NVMe target successfully completes a Port Login (PLOGI) here, will it
incorrectly proceed to issue a SCSI Process Login (PRLI)?

After a successful PLOGI, the state machine transitions to send a PRLI:

ibmvfc_tgt_plogi_done() {
    ...
    ibmvfc_init_tgt(tgt, ibmvfc_tgt_send_prli);
    break;
    ...
}

However, ibmvfc_tgt_send_prli() seems to unconditionally issue a SCSI FCP
PRLI without checking if tgt->protocol is NVMe:

ibmvfc_tgt_send_prli() {
    ...
    prli->common.opcode =3D cpu_to_be32(IBMVFC_PROCESS_LOGIN);
    prli->common.length =3D cpu_to_be16(sizeof(*prli));
    prli->scsi_id =3D cpu_to_be64(tgt->scsi_id);
   =20
    prli->parms.type =3D IBMVFC_SCSI_FCP_TYPE;
    ...
}

Does this cause a protocol error and target initialization failure for NVMe
targets by sending them a SCSI FCP PRLI?

[ ... ]

> @@ -4288,7 +4288,10 @@ static void ibmvfc_tgt_send_plogi(struct ibmvfc_ta=
rget *tgt)
>  	} else {
>  		plogi->common.version =3D cpu_to_be32(1);
>  	}
> -	plogi->common.opcode =3D cpu_to_be32(IBMVFC_PORT_LOGIN);
> +	if (tgt->protocol =3D=3D IBMVFC_PROTO_SCSI)
> +		plogi->common.opcode =3D cpu_to_be32(IBMVFC_PORT_LOGIN);
> +	else
> +		plogi->common.opcode =3D cpu_to_be32(IBMVFC_NVMF_PORT_LOGIN);

[Severity: High]
Will this NVMe branch ever execute? Looking at ibmvfc_alloc_targets(), it
appears to only allocate SCSI targets, completely ignoring the NVMe discove=
ry
buffer:

ibmvfc_alloc_targets() {
    ...
    for (i =3D 0, rc =3D 0; !rc && i < vhost->scsi_scrqs.num_targets; i++)
        rc =3D ibmvfc_alloc_target(vhost, &vhost->scsi_scrqs.disc_buf[i]);
    ...
}

Since NVMe targets are never instantiated, does this leave the entire NVMe
target discovery and login flow as unreachable dead code?

>  	plogi->common.length =3D cpu_to_be16(sizeof(*plogi));
>  	plogi->scsi_id =3D cpu_to_be64(tgt->scsi_id);

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260723000149.9694=
16-1-tyreld@linux.ibm.com?part=3D17
