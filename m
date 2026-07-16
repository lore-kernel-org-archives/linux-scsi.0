Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA78D3955F1
	for <linux-scsi@vger.kernel.org>; Thu, 16 Jul 2026 07:15:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784186115; cv=none; b=pqCEoeAPFC6oaL5m+gX7z+NrHLcmiDZYKkNFIfmDU85cz5pKqp+0kp2JFpyayr8Sv67mA7JoIOeu7r+3CWzh9vY1vTsVFSh54JQJ5LlENLzaAktAYjnr1bW/aFJGNCHmtRJkmQc9CfMCNZlqQhsWvt7BTibHwr1fBUIvTrq1KSg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784186115; c=relaxed/simple;
	bh=70SCtOcSL5VVeZXyYaWUiOtIxyGnXGa5DJsk1jEFwEY=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=ecFThts+M5IhpNMk/0NynIB19h9V00fcw48HkII+imUPGzWldFig2Cqx7VbHv0UmCXynrvktj+5YQF+v7KQ/aaBy+6vO4VIyXZ11S9nKew39uLd7O81nqaC8r/y7O1rKn3vOJ4vNAqedFNGGalDyJs0dlVygUqkKoU+vTuERIPI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=GTYZ0Hi6; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="GTYZ0Hi6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4F0871F00A3A;
	Thu, 16 Jul 2026 07:15:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784186114;
	bh=nkmUFktggnTmPsbKhImmEjdZSshoDYbI8yjp1yIua+c=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=GTYZ0Hi632hICEfSnGqdo4MZTjLU3HAPVuZi0c3W2onEA8xpKCqJb61UaC7xXYLF/
	 w+qiY00i1HGlOmdiCHQ6EgTOvQLDRlJGLVfTHJWKyjnLzw4YvXgatY9pcqJ88MBkGS
	 vVFwun6+TWtV/eabQEe5U8HhhhAvrux+qsl0sMestVqQ9IkUxfJO3cbrsF0jnGVNTa
	 aZn1F5SLuJAQXtV8StWT4xJe/FBafgbBXqgTYS7TLp9icxGKz+HVFyIKG16UtzJBi0
	 Wd3Mc2KTioEsyjtUbcWgW2yRLBGQcpRLPkknNoeffl16jEK6waVDr8pVPaagxZlVGV
	 P2UFvFFVIORvQ==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v2] scsi: libiscsi_tcp: bound SCSI Response data segment
 to the connection buffer
Reply-To: sashiko-reviews@lists.linux.dev
To: "HyeongJun An" <sammiee5311@gmail.com>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20260716065848.1653431-1-sammiee5311@gmail.com>
References: <20260710050645.1194212-1-sammiee5311@gmail.com>
 <20260716065848.1653431-1-sammiee5311@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 16 Jul 2026 07:15:13 +0000
Message-Id: <20260716071514.4F0871F00A3A@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:

Pre-existing issues:
- [High] This problem wasn't introduced by this patch, but the iSCSI TCP re=
ceive path acquires `session->back_lock` using plain `spin_lock()`, which c=
an deadlock if a softirq preempts the workqueue.
--

--- Patch [1]: [PATCH v2] scsi: libiscsi_tcp: bound SCSI Response data segm=
ent to the connection buffer ---
commit 03e41264108be30b9b653aa5ed7bc2fa484238e9
Author: HyeongJun An <sammiee5311@gmail.com>

scsi: libiscsi_tcp: bound SCSI Response data segment to the connection buff=
er
   =20
This commit bounds the data segment of SCSI Command Responses to the connec=
tion
buffer in iscsi_tcp_hdr_dissect(). It groups the opcode with LOGIN_RSP and
other response types to apply the existing bounds check.

> diff --git a/drivers/scsi/libiscsi_tcp.c b/drivers/scsi/libiscsi_tcp.c
> index e90805ba868fb..7223bb18b0480 100644
> --- a/drivers/scsi/libiscsi_tcp.c
> +++ b/drivers/scsi/libiscsi_tcp.c
> @@ -752,13 +752,6 @@ iscsi_tcp_hdr_dissect(struct iscsi_conn *conn, struc=
t iscsi_hdr *hdr)
>  		rc =3D __iscsi_complete_pdu(conn, hdr, NULL, 0);
>  		spin_unlock(&conn->session->back_lock);
>  		break;
> -	case ISCSI_OP_SCSI_CMD_RSP:
> -		if (tcp_conn->in.datalen) {
> -			iscsi_tcp_data_recv_prep(tcp_conn);
> -			return 0;
> -		}
> -		rc =3D iscsi_complete_pdu(conn, hdr, NULL, 0);

[Severity: High]
This isn't a bug introduced by this patch, but can the plain spin_lock()
used here and in the receive path cause a self-deadlock?

If the iscsi_recv_from_iscsi_q module parameter is enabled, packet reception
is routed to the workqueue which runs in process context:

drivers/scsi/iscsi_tcp.c:iscsi_sw_tcp_recv_data_work() {
    ...
    lock_sock(sk);
    iscsi_sw_tcp_recv_data(conn);
    release_sock(sk);
}

When iscsi_tcp_hdr_dissect() handles ISCSI_OP_SCSI_DATA_IN, it takes
the back_lock using a plain spin_lock():

drivers/scsi/libiscsi_tcp.c:iscsi_tcp_hdr_dissect() {
    ...
    case ISCSI_OP_SCSI_DATA_IN:
        spin_lock(&conn->session->back_lock);
    ...
}

Similarly, the iscsi_complete_pdu() function being removed from this specif=
ic
case statement, but still called for these operations, takes back_lock with
a plain spin_lock():

drivers/scsi/libiscsi.c:iscsi_complete_pdu() {
    ...
    spin_lock(&conn->session->back_lock);
    rc =3D __iscsi_complete_pdu(conn, hdr, data, datalen);
    spin_unlock(&conn->session->back_lock);
    ...
}

If a softirq (like a block completion or timer) interrupts the workqueue
thread while this lock is held, and the softirq attempts to acquire the same
lock using spin_lock_bh() (e.g., in the iscsi_queuecommand error path),
would it spin forever?

Does the workqueue handler need to disable bottom halves before entering the
receive path?

> -		break;
>  	case ISCSI_OP_R2T:
>  		if (ahslen) {
>  			rc =3D ISCSI_ERR_AHSLEN;

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260716065848.1653=
431-1-sammiee5311@gmail.com?part=3D1
