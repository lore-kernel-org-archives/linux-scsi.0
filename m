Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A45F309F08
	for <linux-scsi@vger.kernel.org>; Thu, 30 Jul 2026 23:29:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785454183; cv=none; b=ogz1yGFOHTrbiP1aBJBGGA31zv0lOCy0/XoRWjOgDg3/ZVmHP+KD7uZNgGjtVKiML5zhMtBG3mghldTc8n8LKw7bl3UaduuY4dXgUsUdf8prT2PZv2jZl508qicuCvFfQ8j+CjFf22jKNAk8LGZabiR/KDd+PEG1Zt4dHaA0lRo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785454183; c=relaxed/simple;
	bh=e57PPO/b57QHcmwDuXhUKQGp37ia9S4AhAPdbP08I9E=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=Am0AyObGTXDHD0RiNw8rh1SPiSyllRfmhjewjwVBgZ8WYSHiJGQFNxF+VPk6Q9+aTkflH2RS2mVLNuG82fUbalx7IPX+sbGtBmDne6UBWyQYjYokEe0NoFOA6AsFRKzMOP/X5eSznb1jmclu7BsguwlSkd4hoDIu+2ymIF2PQHw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=bQJhvxcp; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="bQJhvxcp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3A7851F000E9;
	Thu, 30 Jul 2026 23:29:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785454182;
	bh=IjsPE5GBCx4COy2x0P7Cb23PNDNpw0NdZMGu0Z+rYZU=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=bQJhvxcp/egWDmQ7K14914IV1IH9fOOXa8RP0kyM2peQ3KFdRTT6W1eg4tcKAtbm/
	 Zc3Ugbox0CJiQgetCT0CqVG4KQsazHXt7iqjH9sqszt0qID/d6CGZzcZyyPFEhFhx7
	 L4Vvd7tifOgbnY4Yq3Ma6HA8iH/NxYhfKi+tBwqeNmSyDno0zEVwhg/sIkjB5cKOUi
	 MNbKMn79SEEuu82pJqejBlBA9yyDmAj1fDARfDtn0ALTJXr1nFFhwG71I0XcM6mGQ2
	 ubbkWekfIQyAXJTsaF8btgzelW8v1JkQvaGWEmnD37fC1w3+cHyLM5SiuovZnAcEgA
	 wjVD1TKPczi3w==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v3 21/57] scsi: bnx2i: Enable lock context analysis
Reply-To: sashiko-reviews@lists.linux.dev
To: "Bart Van Assche" <bvanassche@acm.org>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <0198362bf861b804f2f02e3be6f3d5e16c6238e9.1785451174.git.bvanassche@acm.org>
References: <cover.1785451174.git.bvanassche@acm.org>
 <0198362bf861b804f2f02e3be6f3d5e16c6238e9.1785451174.git.bvanassche@acm.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 30 Jul 2026 23:29:41 +0000
Message-Id: <20260730232942.3A7851F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 3 potential issue(=
s) to consider:

Pre-existing issues:
- [High] bnx2i_cleanup_task() calls wait_for_completion_timeout() while lib=
iscsi holds session->frwd_lock, causing a scheduling while atomic bug.
- [High] Unbounded copy in bnx2i_process_reject_mesg allows a malicious iSC=
SI target to cause a kernel heap buffer overflow.
- [High] Missing bounds check in bnx2i_process_login_resp and bnx2i_process=
_text_resp leads to out-of-bounds writes of padding zeros.
--

--- Patch [21]: [PATCH v3 21/57] scsi: bnx2i: Enable lock context analysis =
---
commit ba1d4ba847bd9f8639c38b0ed041d30d68619de6
Author: Bart Van Assche <bvanassche@acm.org>

scsi: bnx2i: Enable lock context analysis

Document locking requirements with __must_hold(). Use
__assume_ctx_lock() to inform the compiler about aliases for
synchronization objects.

> diff --git a/drivers/scsi/bnx2i/bnx2i_hwi.c b/drivers/scsi/bnx2i/bnx2i_hw=
i.c
> index 4fb68ec8e9b08..5d927880d2971 100644
> --- a/drivers/scsi/bnx2i/bnx2i_hwi.c
> +++ b/drivers/scsi/bnx2i/bnx2i_hwi.c
[ ... ]
> @@ -1443,6 +1444,7 @@ static int bnx2i_process_login_resp(struct iscsi_se=
ssion *session,
> =20
>  	login =3D (struct bnx2i_login_response *) cqe;
>  	spin_lock(&session->back_lock);
> +	__assume_ctx_lock(&conn->session->back_lock);
>  	task =3D iscsi_itt_to_task(conn,
>  				 login->itt & ISCSI_LOGIN_RESPONSE_INDEX);
>  	if (!task)

[Severity: High]
This isn't a bug introduced by this patch, but there appears to be a missing
bounds check when processing login responses.

In bnx2i_process_login_resp(), the payload length is added to resp_buf to
compute resp_wr_ptr:

	bnx2i_conn->gen_pdu.resp_wr_ptr =3D
					bnx2i_conn->gen_pdu.resp_buf + pld_len;

Could an untrusted iSCSI target send an oversized LOGIN response PDU where
pld_len exceeds the 8192 byte capacity of gen_pdu.resp_buf? If so, could th=
is
loop write out-of-bounds padding zeros?

	if (pad_len) {
		int i =3D 0;
		for (i =3D 0; i < pad_len; i++) {
			bnx2i_conn->gen_pdu.resp_wr_ptr[0] =3D 0;
			bnx2i_conn->gen_pdu.resp_wr_ptr++;
		}
	}

[ ... ]
> @@ -1511,6 +1513,7 @@ static int bnx2i_process_text_resp(struct iscsi_ses=
sion *session,
> =20
>  	text =3D (struct bnx2i_text_response *) cqe;
>  	spin_lock(&session->back_lock);
> +	__assume_ctx_lock(&conn->session->back_lock);
>  	task =3D iscsi_itt_to_task(conn, text->itt & ISCSI_LOGIN_RESPONSE_INDEX=
);
>  	if (!task)
>  		goto done;

[Severity: High]
This is a pre-existing issue, but similar to the login response processing,
there seems to be a missing bounds check here in bnx2i_process_text_resp().

If the payload length exceeds the buffer size, could the padding logic write
past the buffer?

	bnx2i_conn->gen_pdu.resp_wr_ptr =3D bnx2i_conn->gen_pdu.resp_buf +
					  pld_len;
[ ... ]
	if (pad_len) {
		int i =3D 0;
		for (i =3D 0; i < pad_len; i++) {
			bnx2i_conn->gen_pdu.resp_wr_ptr[0] =3D 0;
			bnx2i_conn->gen_pdu.resp_wr_ptr++;
		}
	}

[ ... ]
> @@ -1803,6 +1810,7 @@ static void bnx2i_process_reject_mesg(struct iscsi_=
session *session,
>  		bnx2i_unsol_pdu_adjust_rq(bnx2i_conn);
> =20
>  	spin_lock(&session->back_lock);
> +	__assume_ctx_lock(&conn->session->back_lock);
>  	hdr =3D (struct iscsi_reject *) &bnx2i_conn->gen_pdu.resp_hdr;
>  	memset(hdr, 0, sizeof(struct iscsi_hdr));
>  	hdr->opcode =3D reject->op_code;

[Severity: High]
This is a pre-existing issue, but is there a risk of a kernel heap buffer
overflow in bnx2i_process_reject_mesg()?

When receiving an iSCSI REJECT message, the CQE's data_length is passed
directly to bnx2i_get_rq_buf():

	if (reject->data_length) {
		bnx2i_get_rq_buf(bnx2i_conn, conn->data, reject->data_length);
		bnx2i_put_rq_buf(bnx2i_conn, 1);
	}

In bnx2i_get_rq_buf(), this executes a memcpy into the statically sized
conn->data buffer:

	memcpy(ptr, (u8 *) bnx2i_conn->ep->qp.rq_cons_qe, len);

If an untrusted iSCSI target sends an oversized REJECT PDU, will this write
past the bounds of the 8192 byte buffer?

> diff --git a/drivers/scsi/bnx2i/bnx2i_iscsi.c b/drivers/scsi/bnx2i/bnx2i_=
iscsi.c
> index 6c80e5b514fda..c868eada72c3e 100644
> --- a/drivers/scsi/bnx2i/bnx2i_iscsi.c
> +++ b/drivers/scsi/bnx2i/bnx2i_iscsi.c
> @@ -1154,6 +1154,7 @@ static void bnx2i_cpy_scsi_cdb(struct scsi_cmnd *sc=
, struct bnx2i_cmd *cmd)
>  }
> =20
>  static void bnx2i_cleanup_task(struct iscsi_task *task)
> +	__must_hold(&task->conn->session->back_lock)
>  {
>  	struct iscsi_conn *conn =3D task->conn;
>  	struct bnx2i_conn *bnx2i_conn =3D conn->dd_data;

[Severity: High]
This isn't a bug introduced by this patch, but does bnx2i_cleanup_task() sl=
eep
while atomic?

During error handling, such as in iscsi_conn_stop() or iscsi_eh_device_rese=
t(),
libiscsi acquires the session->frwd_lock and calls fail_scsi_tasks().

If fail_scsi_tasks() drops the task reference count to 0 via
__iscsi_put_task(), it synchronously invokes iscsi_free_task(), which calls
bnx2i_cleanup_task().

While bnx2i_cleanup_task() drops the back_lock, the implicitly held frwd_lo=
ck
remains locked when it waits for the completion:

	if (task->state =3D=3D ISCSI_TASK_ABRT_TMF) {
		bnx2i_send_cmd_cleanup_req(hba, task->dd_data);

		spin_unlock_bh(&conn->session->back_lock);
		wait_for_completion_timeout(&bnx2i_conn->cmd_cleanup_cmpl,
				msecs_to_jiffies(ISCSI_CMD_CLEANUP_TIMEOUT));
		spin_lock_bh(&conn->session->back_lock);
	}

Could this cause a scheduling while atomic bug when wait_for_completion_tim=
eout
is called with frwd_lock still held?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/cover.1785451174.gi=
t.bvanassche@acm.org?part=3D21
