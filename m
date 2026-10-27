Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793114584;
	b=AcT5rFuu4hd6Ftm4ary9u6U6oVEfXsjVWtBMK5vTs12vwRJ0bhEhBGZsmeJ63w9kTxl8
	 cOZoFUtguV6k8Ax38dz9Va2IsnpYqNhh8GydUBncbTXs76u8W1ADGg3H3QatZMi3iji0d
	 TF7/M4hwpZZ7Ny2f+RWPeSSS3FBOcyXouzSB/CTMXRWu32PSL6FVvXDHEfd5SRm/3ZU+C
	 gZ+p4ucFKANDcjjZKaKzRCdOvSIXPbKVGd6XLFVsKoCPEgQC1eMgMZLSzu1W43muypWX+
	 mpKLlaMRkRrnnkNu5utjdnHJH4NNzORi4K2yPTmQU1xmTtEGDiGUD/BbZ7AdJibwYzA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793114584;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=Q5yLPXnIEfW617Nb3A3FE6bGHMFF+4DsUlC+shp4Occ=;
	b=omEqyiRtqTOors7AeJahUkWtVVOOJWu60+LP8wAmgdbwhrz6/54WspACjG/XXjlmL/18
	 yoQrY4wc7U1MXg9McKHRFGc+sk08IK0kz0YDi4nxl3fRKcyPk/DVLS86hrsvDpMh/z+Sp
	 fE+T/ft9tkxXlirvo11r7tcLdWqkKqCdpGhAwpzytBYnZSzpabwssXMd+fsPA3LR2zkFT
	 lbxdm42YyDHsS4nXxiUfC49GbJzX/OhnhXroDL0ydyla2mtPQIwLJ3OlcZJdasEUd6u+p
	 LG86/HechWUf4utcHPhfQADFbUISlpe4dmns867DuGnVSUDg6gDBW6XcRZyAmJwA/Wg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=S3zCDgQq;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD775606A31B
	for <linux-scsi@vger.kernel.org>; Tue, 27 Oct 2026 15:23:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=S3zCDgQq
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 408A31F01825;
	Tue, 27 Oct 2026 15:23:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793114583;
	bh=Q5yLPXnIEfW617Nb3A3FE6bGHMFF+4DsUlC+shp4Occ=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=S3zCDgQqIZlSJEYYQGjI7NaVw7Jpj39Aczu5abwM1YjugPRSgor3N29s9Nwl8b/++
	 lvzPgjVvG6PjuXwHzj12IPgQ/09i3eiieXZfXrU48CI4uWpHvS7hxbWZ6npxQVJVXo
	 Skv73Jp0alMfo4ECnKoxGD3h48ryTVMDqrw05dFKsPZPyA3qlLJUg3v1RJy9GBCHax
	 G7kU/19c+eSNhAoAJmQKoutcvtOKxnBG2jdMZFQBqlooQKKdJ2XV9XN4eClFdUmeSL
	 4Jfs0nbrqoNOMUebiRY3zPsp7KEMQKvEBP1XF64XjUGJQUXOt6IaWlJJuKxlE85UAb
	 A/A39PxZytgjw==
Message-ID: <sashiko-outbox-186828@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH] scsi: qedi: fix OOB read in login/text response
 completion
Reply-To: sashiko-reviews@lists.linux.dev
To: "Henry Martin" <bsdhenrymartin@gmail.com>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20261027150752.951217-1-bsdhenrymartin@gmail.com>
References: <20261027150752.951217-1-bsdhenrymartin@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 27 Oct 2026 15:23:02 +0000
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Post: <mailto:linux-scsi@vger.kernel.org>
List-Help: <mailto:linux-scsi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-scsi+owner@vger.kernel.org>
Precedence: list

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [Medium] scsi: qedi: unclamped dlength in qedi_process_text_resp() and lo=
gin_resp()
--

commit b81ce3a14651452d3f551e4635d2337a8b305729
Author: Henry Martin <bsdhenrymartin@gmail.com>

scsi: qedi: fix OOB read in login/text response completion

This commit clamps the payload length extracted from the CQE in
qedi_process_text_resp() and qedi_process_login_resp() to
qedi_conn->gen_pdu.resp_buf_size before advancing resp_wr_ptr, preventing
an out-of-bounds read when completing the PDU to userspace.

> diff --git a/drivers/scsi/qedi/qedi_fw.c b/drivers/scsi/qedi/qedi_fw.c
> index c8af10c326532..5e20716043aee 100644
> --- a/drivers/scsi/qedi/qedi_fw.c
> +++ b/drivers/scsi/qedi/qedi_fw.c
> @@ -115,6 +115,8 @@ static void qedi_process_text_resp(struct qedi_ctx *q=
edi,
> =20
>  	pld_len =3D cqe_text_response->hdr_second_dword &
>  		  ISCSI_TEXT_RESPONSE_HDR_DATA_SEG_LEN_MASK;
> +	if (pld_len > qedi_conn->gen_pdu.resp_buf_size)
> +		pld_len =3D qedi_conn->gen_pdu.resp_buf_size;
>  	qedi_conn->gen_pdu.resp_wr_ptr =3D qedi_conn->gen_pdu.resp_buf + pld_le=
n;
> =20
>  	memset(task_ctx, '\0', sizeof(*task_ctx));
> @@ -294,6 +296,8 @@ static void qedi_process_login_resp(struct qedi_ctx *=
qedi,
>  	resp_hdr_ptr->status_detail =3D cqe_login_response->status_detail;
>  	pld_len =3D cqe_login_response->hdr_second_dword &
>  		  ISCSI_LOGIN_RESPONSE_HDR_DATA_SEG_LEN_MASK;
> +	if (pld_len > qedi_conn->gen_pdu.resp_buf_size)
> +		pld_len =3D qedi_conn->gen_pdu.resp_buf_size;
>  	qedi_conn->gen_pdu.resp_wr_ptr =3D qedi_conn->gen_pdu.resp_buf + pld_le=
n;

[Severity: Medium]
Should resp_hdr_ptr->dlength also be populated from the clamped pld_len in
both qedi_process_text_resp() and qedi_process_login_resp()?

Earlier in both functions, resp_hdr_ptr->dlength is written using the raw
unclamped 24-bit CQE value before pld_len is clamped to
qedi_conn->gen_pdu.resp_buf_size:

drivers/scsi/qedi/qedi_fw.c:qedi_process_text_resp() {
	...
	hton24(resp_hdr_ptr->dlength,
	       (cqe_text_response->hdr_second_dword &
		ISCSI_TEXT_RESPONSE_HDR_DATA_SEG_LEN_MASK));
	...
	pld_len =3D cqe_text_response->hdr_second_dword &
		  ISCSI_TEXT_RESPONSE_HDR_DATA_SEG_LEN_MASK;
	if (pld_len > qedi_conn->gen_pdu.resp_buf_size)
		pld_len =3D qedi_conn->gen_pdu.resp_buf_size;
	qedi_conn->gen_pdu.resp_wr_ptr =3D qedi_conn->gen_pdu.resp_buf + pld_len;

and similarly in qedi_process_login_resp():

drivers/scsi/qedi/qedi_fw.c:qedi_process_login_resp() {
	...
	hton24(resp_hdr_ptr->dlength,
	       (cqe_login_response->hdr_second_dword &
		ISCSI_LOGIN_RESPONSE_HDR_DATA_SEG_LEN_MASK));
	...
	pld_len =3D cqe_login_response->hdr_second_dword &
		  ISCSI_LOGIN_RESPONSE_HDR_DATA_SEG_LEN_MASK;
	if (pld_len > qedi_conn->gen_pdu.resp_buf_size)
		pld_len =3D qedi_conn->gen_pdu.resp_buf_size;
	qedi_conn->gen_pdu.resp_wr_ptr =3D qedi_conn->gen_pdu.resp_buf + pld_len;

When __iscsi_complete_pdu() calls iscsi_recv_pdu(), the netlink message is
allocated and populated with only data_size (the clamped pld_len) bytes of
payload following the header:

drivers/scsi/scsi_transport_iscsi.c:iscsi_recv_pdu() {
	int len =3D nlmsg_total_size(sizeof(*ev) + sizeof(struct iscsi_hdr) +
				   data_size);
	...
	pdu =3D (char*)ev + sizeof(*ev);
	memcpy(pdu, hdr, sizeof(struct iscsi_hdr));
	memcpy(pdu + sizeof(struct iscsi_hdr), data, data_size);

If the CQE data segment length exceeds resp_buf_size, won't this leave
resp_hdr_ptr->dlength advertising the larger unclamped length in the
embedded struct iscsi_hdr while only resp_buf_size bytes of payload are
actually present in the netlink message sent to userspace?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261027150752.9512=
17-1-bsdhenrymartin@gmail.com?part=3D1
