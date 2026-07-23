Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1DF5A1DF254
	for <linux-scsi@vger.kernel.org>; Thu, 23 Jul 2026 00:36:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784766968; cv=none; b=pwO0sHQOPfjNUYDw0GNWGvHSYmsOko/nPqb7xtY/phtqEHGFvfdSxccNNPRK1jg6XhOyDUgdRmcV9QPkXMuSI8bH8IMC/r//nsnMtPA3+wneHlHmoABAkc4c5SDYjAirilQh2OsB175SuBT4vJu5Bfia5QMXgeRJTlgYymjbTW0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784766968; c=relaxed/simple;
	bh=CtmC++0IWcb/5NCqJQVLwn4UdTTNfUWiCnXiQOKfS3E=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=LxcHuQLz74zWwkE4BCKOI1T+yq8ULnpdlrxrWya3z7r84GTcthZemhXR3jUJDkc+h3Oy8rEh3iMADbKcxtMPeBd7s3sgrOrf5o2GRc9QfmyunbJ988hZTQKLB2NOgALejXwqCc7IbGVO67MVyUUDJyzR6LGQBw/8rNtLK86mZkM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=MfX+EyKG; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="MfX+EyKG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9D7231F000E9;
	Thu, 23 Jul 2026 00:36:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784766966;
	bh=acyXVHv2VgpeIoMIH/02FBRIeO7B+k0Loemp4c2EuG0=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=MfX+EyKG8wsvr8U8AX+mXjnG54jzvtn3e9MVSM/2aW99YTmf5LzqOtC/QOiwf+upP
	 BMPz9109yU95Rsr335oV45nBY7b56Rxn5SZA4sffxYBXP6tK2EUkkm6gtqMiGrDD0p
	 u2AEK4aKQXtiPYZ5lQBXuhWmxK13Qb9XtrFTeSkKVs/VI3kkEW9Ot24yk1ActKmX7M
	 REvIrguGaosRztNEJ1XJVSk9QBIIibE2+1pBvmSdY+BdvZbLEVxKj14Qd1zMLdAaw4
	 0S0Zp1P8n+hP18S5SjDx/4iQVvlOIRc/7sAtIpJQMFnevQy6uXsbKpvGMg2FB2qBJi
	 rYWy5qWWtRLZA==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v2 16/33] ibmvfc: add NVMe/FC Implicit Logout and Move
 Login support
Reply-To: sashiko-reviews@lists.linux.dev
To: "Tyrel Datwyler" <tyreld@linux.ibm.com>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20260723000149.969416-17-tyreld@linux.ibm.com>
References: <20260723000149.969416-1-tyreld@linux.ibm.com>
 <20260723000149.969416-17-tyreld@linux.ibm.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 23 Jul 2026 00:36:06 +0000
Message-Id: <20260723003606.9D7231F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 2 potential issue(=
s) to consider:

New issues:
- [High] The Move Login completion handler incorrectly schedules a SCSI-spe=
cific Process Login (PRLI) for NVMe targets, breaking the target initializa=
tion state machine.

Pre-existing issues:
- [High] Event completion handlers modify shared host and target state with=
out holding `host_lock`, causing data races with the worker thread.
--

--- Patch [16]: [PATCH v2 16/33] ibmvfc: add NVMe/FC Implicit Logout and Mo=
ve Login support ---
commit 3f8ab5b8122810e98caf8a4efbdac3e6f3574d85
Author: Tyrel Datwyler <tyreld@linux.ibm.com>

ibmvfc: add NVMe/FC Implicit Logout and Move Login support

This commit adds protocol-specific opcodes and debug logging for implicit
logout and move login operations on NVMe/FC targets. It extends the existing
target login and migration flows to distinguish between SCSI and NVMe target
protocols.

> diff --git a/drivers/scsi/ibmvscsi/ibmvfc-core.c b/drivers/scsi/ibmvscsi/=
ibmvfc-core.c
> index 1d2a88e9fe941..66fcff7ac834b 100644
> --- a/drivers/scsi/ibmvscsi/ibmvfc-core.c
> +++ b/drivers/scsi/ibmvscsi/ibmvfc-core.c
> @@ -4318,7 +4318,7 @@ static void ibmvfc_tgt_implicit_logout_done(struct =
ibmvfc_event *evt)
> =20
>  	switch (status) {
>  	case IBMVFC_MAD_SUCCESS:
> -		tgt_dbg(tgt, "Implicit Logout succeeded\n");
> +		tgt_dbg(tgt, "%s Implicit Logout succeeded\n", proto_type[tgt->protoco=
l]);

[Severity: High]
This is a pre-existing issue, but it appears that event completion handlers
like ibmvfc_tgt_implicit_logout_done() and ibmvfc_tgt_move_login_done()
modify shared host and target state without holding host_lock.

Can this cause data races with the worker thread?

The handlers are invoked locklessly during CRQ draining:

ibmvfc_drain_sub_crq() {
    ...
    spin_unlock_irqrestore(scrq->q_lock, flags);
    list_for_each_entry_safe(evt, temp, &evt_doneq, queue_list) {
        ...
        evt->done(evt);
    }
}

The evt->done() call executes ibmvfc_tgt_implicit_logout_done() which does:

    vhost->discovery_threads--;
    ibmvfc_set_tgt_action(tgt, IBMVFC_TGT_ACTION_NONE);

If vhost->discovery_threads is decremented locklessly while the worker thre=
ad
(ibmvfc_do_work) increments it under host_lock, could we lose decrements?

If we do, the count could artificially inflate and eventually hit the
disc_threads limit, permanently aborting future target discovery and login
operations.

[ ... ]
> @@ -4486,7 +4491,8 @@ static void ibmvfc_tgt_move_login_done(struct ibmvf=
c_event *evt)
>  	ibmvfc_set_tgt_action(tgt, IBMVFC_TGT_ACTION_NONE);
>  	switch (status) {
>  	case IBMVFC_MAD_SUCCESS:
> -		tgt_dbg(tgt, "Move Login succeeded for new scsi_id: %llX\n", tgt->new_=
scsi_id);
> +		tgt_dbg(tgt, "%s Move Login succeeded for new scsi_id: %llX\n",
> +			proto_type[tgt->protocol], tgt->new_scsi_id);

[Severity: High]
Does this code inadvertently schedule a SCSI-specific process login for NVMe
targets?

Just below this debug statement in ibmvfc_tgt_move_login_done(), a
successful move login unconditionally initializes the target with
ibmvfc_tgt_send_prli:

    case IBMVFC_MAD_SUCCESS:
        ...
        ibmvfc_init_tgt(tgt, ibmvfc_tgt_send_prli);
        break;

However, ibmvfc_tgt_send_prli() hardcodes the SCSI FCP type and opcode
without any fallback for NVMe targets:

    prli->common.opcode =3D cpu_to_be32(IBMVFC_PROCESS_LOGIN);
    ...
    prli->parms.type =3D IBMVFC_SCSI_FCP_TYPE;

Since this patch adds support for distinguishing NVMe/FC targets during move
login, will an NVMe target fail to complete the login sequence here when it
receives an invalid SCSI-specific Process Login MAD?

>  		tgt->ids.node_name =3D wwn_to_u64(rsp->service_parms.node_name);
>  		tgt->ids.port_name =3D wwn_to_u64(rsp->service_parms.port_name);
>  		tgt->scsi_id =3D tgt->new_scsi_id;

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260723000149.9694=
16-1-tyreld@linux.ibm.com?part=3D16
