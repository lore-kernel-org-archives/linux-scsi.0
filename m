Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=170.10.133.124
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793022127;
	b=qOWS3i7hXUxuRyQorOsbsPWZ0JU0yDoAdWdTJzvdVh6hOJjbMyxR/YMONEsFQaDGBJfw
	 xPh8mrN8CPDvoKpikw+p4xWFUnlsehGwk+WooJiJ9ZWR7CuHtljRfkKIIk5r1eLa2n5Gd
	 5leiqvAz57OW5iVziqWetJuPZd724mnvDv6iSQAKkyhJs/Is0zQwm/zrNenysJZTZeVVs
	 LZEBZkNxdLLPGwKAzbfMVq/sBDcmzpPhBc/H3nWcflmPIFAg/K9OUFJHYySAiQRBDw3rI
	 AweybkoP535g5Dm/LvsroNhvV7hxJBRP8aaIBpLv7ia5jzG/IcnnwU1zix6SQNa5GbQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793022127;
	h=DMARC-Filter:DKIM-Signature:Received:X-MC-Unique:
	 X-Mimecast-MFC-AGG-ID:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:X-Received:Received:Message-ID:
	 Subject:From:To:Cc:Date:In-Reply-To:References:Content-Type:
	 Content-Transfer-Encoding:User-Agent:MIME-Version;
	bh=ed+PX3IGkbk+mTJa3PsZsNtkAoyqu1J1xwHAA2Xtd+g=;
	b=H1E57Di+bwNGd7E5WjKSOXJ/6LENfKiRWjazLHVCMqerqvTggoyzBO81bCkUB0oG58Le
	 EUEnjaZZyixsrn/OLFqH2NfLoy805cuuTMSybrnKbQrZ+/WkFp3CDEwycT0nYqViBut8a
	 0LOW0qBaPXPOzHCnCtJn0ARhpqt6b5p0JkNXHF0lJ5Eq4FUAeGPCrLGEfWspiSZULSM5o
	 b06q6eRtPQP/Mhr5XC2Dl1xQ2/irCMPR+AumwHZ89VU6O8Eo8bDJFYAReGHHH6/hdm4s4
	 7bFKbMr1uO08Hus2Ij1mIkgi5bkNmnohWi63iUqrXyocvI+2/bMD8RfG6+JkSdeex9w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=redhat.com;
	spf=pass smtp.mailfrom=redhat.com;
	dkim=pass header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=DuCB7E9I;
	dkim=pass header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=google header.b=G7ZTZeYQ;
	arc=none smtp.remote-ip=170.10.133.124
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 64CFD606A31B
	for <linux-scsi@vger.kernel.org>; Mon, 26 Oct 2026 13:42:07 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 64CFD606A31B
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=DuCB7E9I;
	dkim=pass (2048-bit key, unprotected) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=google header.b=G7ZTZeYQ
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1793022126;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ed+PX3IGkbk+mTJa3PsZsNtkAoyqu1J1xwHAA2Xtd+g=;
	b=DuCB7E9IIlpWmNJhC2RX1Pb/+Queovc3QgbjBnG/i9m2yAq4OOy3RdrUDUYVZBLb2YlPtK
	FEgRTGbjQ32c8EgFG6POCI6MTkROXIoV/pcSYSdIjKtjxMhrRniyRDQdi/fcL+fKItpqBy
	c8UJ26bwyEVrLuN+fmiLdmMAz0wTyR8=
Received: from mail-qv1-f69.google.com (mail-qv1-f69.google.com
 [209.85.219.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-626-qNJ9KTmYPPaQ_mXP61NWwg-1; Mon, 26 Oct 2026 09:42:05 -0400
X-MC-Unique: qNJ9KTmYPPaQ_mXP61NWwg-1
X-Mimecast-MFC-AGG-ID: qNJ9KTmYPPaQ_mXP61NWwg_1793022124
Received: by mail-qv1-f69.google.com with SMTP id 6a1803df08f44-917baea8e5dso73384596d6.3
        for <linux-scsi@vger.kernel.org>; Mon, 26 Oct 2026 06:42:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1793022124; x=1793626924; darn=vger.kernel.org;
        h=mime-version:user-agent:content-transfer-encoding:content-type
         :references:in-reply-to:date:cc:to:from:subject:message-id:from:to
         :cc:subject:date:message-id:reply-to:content-type;
        bh=ed+PX3IGkbk+mTJa3PsZsNtkAoyqu1J1xwHAA2Xtd+g=;
        b=G7ZTZeYQJYorU01gUtWuu+yTEdSH3kcBwNtL8ucR/cmmnfyzWMQrm/efjcpAJEV0F0
         rZUvLImHohR5jD4cvr76unwT8PKCslUhpqcYKMXPf/TKhGtox6nBr0M6m/053PzcTvnA
         Dv4gB5XNeUW4WDB0Q7W1CMMPTBVKRZBVv80H08PsePwZn6voLNoBVH3Db1czWK4GFXeF
         hsUtIzuYCXFYjBTvmhT+5ABjhRMZDlDUsC9535Bb5k5yhZC8wCPkO1HrnOYIYcvhagbt
         hyYijZyTq4K6SQMCkHnG3+l2OpV7GsiyZ6SdTsIzj6Y+r6e41mx5JzKATcXC68smlWhQ
         b7UA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793022124; x=1793626924;
        h=mime-version:user-agent:content-transfer-encoding:content-type
         :references:in-reply-to:date:cc:to:from:subject:message-id:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=ed+PX3IGkbk+mTJa3PsZsNtkAoyqu1J1xwHAA2Xtd+g=;
        b=K+0e1Zw2mKiCjWmnghnq3NAXnVudSHEiWVT/ad9nUGq4aXFI4V1W5SlH1pAkIUjjxg
         hjcPGdPuh3wdxbqeD7HDkxM4d+160U0cmUglobAr/WyQ2OglHN5bUZ8JbnY339A/BQsb
         ZeF/QBhxqB4Ah+0EsZjmzpMvzLx1Y/RjGSqIwTu3DXtrN9yfsfN8MFedPGhXdkxFCWrv
         DVknQ8j2nweVdIDDm5of3ZBL7B1yo3uo2u9FcSIp3Du1aomH4v1RTYbt6hS9IyfEhQQ/
         VFs4wtQFAQUUF5t1plzIcIlkDOc01SOWedf55SDyklgP3LV9kYgqgY1Vi4nCLc6LeiGl
         0MBg==
X-Gm-Message-State: AFq9FYKnZgPe21hTvfOdpmL639+xrY3oCeekNdyUmxS/CV/aeZqkRGbW
	wV0eW3XEZduYhuGp08L2qpsLavu8m1EdogIE9drz8mFcfhrE3kxMcHUv7I7VkO4mL0RV9DOnzvx
	+Z3p4eSeyMzZxBUfMI11d6PrcSkuYu4f9qo+ON9u/8um7vYsH5gR3x94LKNJac2BBUx1Invk=
X-Gm-Gg: AYBFou2fF+HaNh5DGRsTfXri+9a8KPBsZWQ41+ED02NAJtpG7dkJNIFCWBlk34kxbII
	CxbvJNbZvY9uoY+69UkgNOX7DOKsRqDtJZwqyob0AycN775cXIVoS483YUXULN+CCmHqLU/2eW8
	ep7K0MMkuCiwf9AQp95RSjkLhxUZDUK89KTpxxWrOMXvjG+xlnKY3BUR8vFw2Ji7xORCdDtilbP
	kJEuwa/OqNc9A5nNikc3gROlfEtpswDwUkYuJhnmCpkwlHdvczNRdZENN7aNyQS366aSWweCbqu
	CbiBP9PEy9Db1uUUfsr9/qc5B74z57aeacawjttfSskzR/w6FoPHqucsEbyuCrL5i1n+h1r6E2l
	IGV6UGzIi/u6LUSlEmlDcWIcQ8/l6SegC0Q+71F0hCUtP+hUhySfTVwU6uQl9GWr/+erkJwKXI6
	y8khnghkdNcqxNFMvgMA2blQ==
X-Received: by 2002:a05:622a:5b0d:b0:536:575b:8dd6 with SMTP id d75a77b69052e-5383af13431mr89884421cf.0.1793022124178;
        Mon, 26 Oct 2026 06:42:04 -0700 (PDT)
X-Received: by 2002:a05:622a:5b0d:b0:536:575b:8dd6 with SMTP id d75a77b69052e-5383af13431mr89883771cf.0.1793022123494;
        Mon, 26 Oct 2026 06:42:03 -0700 (PDT)
Received: from loberman-thinkpadp16gen3.rmtusma.csb ([2600:6c65:2440:d8c:aa2b:ddff:fe88:da74])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-91c47c53fdcsm72863586d6.27.2026.10.26.06.42.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 26 Oct 2026 06:42:02 -0700 (PDT)
Message-ID: <3e2a63af147ce884e84cd3aee1e456051265d7bc.camel@redhat.com>
Subject: Re: [PATCH v3 2/4] scsi: target: iscsi: Complete an aborted WRITE
 when a new R2T would be sent
From: Laurence Oberman <loberman@redhat.com>
To: sashiko-reviews@lists.linux.dev
Cc: linux-scsi@vger.kernel.org, target-devel@vger.kernel.org
Date: Mon, 26 Oct 2026 09:42:02 -0400
In-Reply-To: <sashiko-outbox-185289@kernel.org>
References: <20261026124344.745124-1-loberman@redhat.com>
	 <20261026124344.745124-3-loberman@redhat.com>
	 <sashiko-outbox-185289@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.60.2 (3.60.2-2.fc44) 
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Post: <mailto:linux-scsi@vger.kernel.org>
List-Help: <mailto:linux-scsi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-scsi+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0

On Mon, 2026-10-26 at 13:13 +0000, sashiko-bot@kernel.org wrote:
> Thank you for your contribution! Sashiko AI review found 1 potential
> issue(s) to consider:
> - [Critical] scsi: target: iscsi: UAF of OOO cmd in
> iscsit_check_dataout_payload()
> --
>=20
> commit 93e4d74df05b6ac07e171f5586d09d2036dc2494
> Author: Laurence Oberman <loberman@redhat.com>
>=20
> scsi: target: iscsi: Complete an aborted WRITE when a new R2T would
> be sent
>=20
> This commit completes an aborted WRITE command via
> iscsit_complete_aborted_cmd() in iscsit_check_dataout_payload() when
> iscsit_check_post_dataout() returns DATAOUT_SEND_R2T and no
> outstanding R2Ts
> remain.
>=20
> > diff --git a/drivers/target/iscsi/iscsi_target.c
> > b/drivers/target/iscsi/iscsi_target.c
> > index aab9237a67768..3dad7f69f3bae 100644
> > --- a/drivers/target/iscsi/iscsi_target.c
> > +++ b/drivers/target/iscsi/iscsi_target.c
> > @@ -1669,6 +1669,22 @@ iscsit_check_dataout_payload(struct
> > iscsit_cmd *cmd, struct iscsi_data *hdr,
> > =C2=A0	if ((rc =3D=3D DATAOUT_NORMAL) || (rc =3D=3D
> > DATAOUT_WITHIN_COMMAND_RECOVERY))
> > =C2=A0		return 0;
> > =C2=A0	else if (rc =3D=3D DATAOUT_SEND_R2T) {
> > +		/*
> > +		 * A new R2T would never be answered for an
> > aborted command.
> > +		 * The CMD_T_ABORTED handling in
> > __iscsit_check_dataout_hdr()
> > +		 * does not cover this: it only runs for DataOut
> > PDUs
> > +		 * belonging to R2Ts that were already issued, and
> > +		 * iscsit_dataout_update_r2t() has already
> > decremented
> > +		 * outstanding_r2ts for the burst that just
> > finished.=C2=A0 Guard
> > +		 * on outstanding_r2ts so that with
> > MaxOutstandingR2T > 1 the
> > +		 * completion is still left to the last R2T to
> > drain.
> > +		 */
> > +		if (cmd->se_cmd.transport_state & CMD_T_ABORTED) {
> > +			if (cmd->outstanding_r2ts < 1)
> > +				iscsit_complete_aborted_cmd(cmd);
> > +			return 0;
> > +		}
>=20
> [Severity: Critical]
> Can completing the command here cause a use-after-free of cmd if
> ICF_OOO_CMDSN is set?
>=20
> When ImmediateData=3DYes and InitialR2T=3DNo, a WRITE command can arrive
> with
> immediate data and expect additional unsolicited DataOut PDUs in the
> first
> burst followed by R2T-solicited data (payload_length <
> FirstBurstLength <
> se_cmd.data_length, so cmd->unsolicited_data =3D=3D 1 and
> ICF_NON_IMMEDIATE_UNSOLICITED_DATA is set).
>=20
> In drivers/target/iscsi/iscsi_target.c:iscsit_process_scsi_cmd(),
> transport_generic_new_cmd(&cmd->se_cmd) is called before CmdSN
> sequencing:
>=20
> 	cmd->sense_reason =3D transport_generic_new_cmd(&cmd->se_cmd);
> 	if (cmd->sense_reason)
> 		return 1;
>=20
> This places cmd->se_cmd on dev->queues[cpuid].state_list in
> TRANSPORT_WRITE_PENDING. When iscsit_get_immediate_data()
> subsequently calls
> iscsit_sequence_cmd() and cmd->cmd_sn > sess->exp_cmd_sn,
> drivers/target/iscsi/iscsi_target_erl1.c:iscsit_handle_ooo_cmdsn()
> queues
> an entry on sess->sess_ooo_cmdsn_list holding a raw pointer to cmd:
>=20
> 	cmd->cmd_flags			|=3D ICF_OOO_CMDSN;
> 	...
> 	ooo_cmdsn->cmd			=3D cmd;
>=20
> Because cmd->unsolicited_data is set, iscsit_get_immediate_data()
> then calls
> iscsit_set_unsolicited_dataout(cmd).
>=20
> If a concurrent TMR aborts cmd while it is still waiting on
> sess->sess_ooo_cmdsn_list, __target_check_io_state() sets
> CMD_T_ABORTED on
> cmd->se_cmd. When the final unsolicited DataOut PDU of the first
> burst
> arrives, __iscsit_check_dataout_hdr() takes the cmd->unsolicited_data
> =3D=3D 1
> path, and iscsit_dataout_post_crc_passed() clears cmd-
> >unsolicited_data =3D 0
> and returns DATAOUT_SEND_R2T.
>=20
> In this new DATAOUT_SEND_R2T branch in
> iscsit_check_dataout_payload(),
> cmd->outstanding_r2ts is 0, so iscsit_complete_aborted_cmd(cmd) is
> called
> without checking ICF_OOO_CMDSN or removing cmd from
> sess->sess_ooo_cmdsn_list (unlike the adjacent
> DATAOUT_SEND_TO_TRANSPORT
> branch, which checks cmd->cmd_flags & ICF_OOO_CMDSN).
>=20
> Once target_complete_cmd() schedules target_abort_work ->
> target_handle_abort(), cmd is completed and freed via
> iscsit_release_cmd().
> When the missing ExpCmdSN PDU later arrives,
> drivers/target/iscsi/iscsi_target_erl1.c:iscsit_execute_ooo_cmdsns()
> will
> dereference the dangling ooo_cmdsn->cmd pointer:
>=20
> 		cmd =3D ooo_cmdsn->cmd;
> 		cmd->i_state =3D cmd->deferred_i_state;
> 		ooo_count++;
> 		sess->exp_cmd_sn++;
> 		...
> 		iscsit_remove_ooo_cmdsn(sess, ooo_cmdsn);
>=20
> 		if (iscsit_execute_cmd(cmd, 1) < 0)
> 			return -1;
>=20
> Should the DATAOUT_SEND_R2T abort path also account for commands with
> ICF_OOO_CMDSN set before completing cmd?

I will drop patch 2 for this series as this turns out out be a real
issue and follow up with a v4 for the series. Dropping patch 2 will not
affect the validity of the fix with the over 300 reset loop tests we
ran which resolved the original customer issue.

Sashiko complaints for patches 1 and 4 are pre-existing and wont be
handled in this series.

It has taken many weeks to get to stable outcome for a customer that
included multiple long vmcore analysis tasks and instrumentation.


Thanks
Laurence

