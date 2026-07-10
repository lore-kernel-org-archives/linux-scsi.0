Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4DA2731352D
	for <linux-scsi@vger.kernel.org>; Fri, 10 Jul 2026 05:17:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783660626; cv=none; b=MqP0SXQ1vHhTl/vl07tTwSHRgvFdAN+jQQblgUCeNSqjWibLNCcDY4xyMysaYvmuvKOP2u9ONvp/PdJYS51P+C/Hi4ybEZ9fp65Qj+GUnRzZYq7wspQ0U9amHiLbcQhDnGlB1I4tfU9ihLm7BLPumWcBEM0kE6Pr4YMCpIc1/Z4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783660626; c=relaxed/simple;
	bh=5wywzApX6wZ8veKiVUEh9kl9d37mgyz4UE+udseL2gY=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=qePqrnpLv7crbJRpwqFeyADU6/GHoYddvYihi2g7LQVzqFUtksPuGjEEME9RfdumP4gc9WYwB5OYMsw7EuVBfHk0wwjbarGm4mb8HtwTaSDFt+vBV1k67nLqHHdDHGkvWWezmbP/l5Hs9ixM5+Os4eetVchNrFdwR+LjEHC6U1s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=lfKR8Lho; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="lfKR8Lho"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A25541F000E9;
	Fri, 10 Jul 2026 05:17:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783660624;
	bh=NUSRwpx4/SpqRTtalXRTMXMNSgobvmiWWfrqei/Rs14=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=lfKR8Lhokqws5RXI1fe4sb9PcX0PPSgRxTYb0LA47jyM/KbrQlYCNl0w4KNYPSJKl
	 OEmRn/KoO5/UigKPG8zrlVeu8Aqg1uTIeD4Amfx8wNh6jI78QwuT9SZNcNAcHR3GSq
	 kjr+waeUjlBhzwYHA5rtKdbGl+M43Euz7TtEs5wT9xrnHt+2XzhKo0Lst6biZbSHtu
	 rKVL1vkxxvD3PpEw5jYmQ4+Bs9e1VAjhIZfQTHtY54csAvsDsMGfNfdnHrsyprTC06
	 gn5VQPKFNuRubEc0FlAO00p555nu5RvIJP71aBS2W5DK71w5VQoL4jNf3KKDWp3oFK
	 fv4bLGF3yLu1A==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH] scsi: libiscsi_tcp: bound SCSI Response data segment to
 the connection buffer
Reply-To: sashiko-reviews@lists.linux.dev
To: "HyeongJun An" <sammiee5311@gmail.com>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20260710050645.1194212-1-sammiee5311@gmail.com>
References: <20260710050645.1194212-1-sammiee5311@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 10 Jul 2026 05:17:04 +0000
Message-Id: <20260710051704.A25541F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:

Pre-existing issues:
- [Medium] In `iscsi_scsi_cmd_rsp()`, an incorrect bounds check allows a ma=
licious or compromised iSCSI target to leak up to 2 bytes of uninitialized =
kernel memory (or previous packet data) into the SCSI sense buffer via a cr=
afted `CHECK_CONDITION` response.
--

--- Patch [1]: [PATCH] scsi: libiscsi_tcp: bound SCSI Response data segment=
 to the connection buffer ---
commit 997ca9836cebc0e8267dfdbdc7d5ae21d710b9fd
Author: HyeongJun An <sammiee5311@gmail.com>

scsi: libiscsi_tcp: bound SCSI Response data segment to the connection buff=
er

iscsi_tcp_hdr_dissect() receives the data segment of several PDU types
into the fixed-size conn->data buffer. This commit applies bounds
checking for the SCSI Command Response path before copying the data
segment to prevent overflowing the 8192-byte buffer.

> diff --git a/drivers/scsi/libiscsi_tcp.c b/drivers/scsi/libiscsi_tcp.c
> index 60cb6dc3c6f09..ef28543def9e8 100644
> --- a/drivers/scsi/libiscsi_tcp.c
> +++ b/drivers/scsi/libiscsi_tcp.c
> @@ -720,6 +720,18 @@ iscsi_tcp_hdr_dissect(struct iscsi_conn *conn, struc=
t iscsi_hdr *hdr)
>  		spin_unlock(&conn->session->back_lock);
>  		break;
>  	case ISCSI_OP_SCSI_CMD_RSP:
> +		/*
> +		 * Sense/response data is received into conn->data, so bound
> +		 * it to that buffer like the responses handled below.
> +		 */
> +		if (tcp_conn->in.datalen > ISCSI_DEF_MAX_RECV_SEG_LEN) {

[Severity: Medium]
This is a pre-existing issue, but while looking at how sense data is read
from conn->data, I noticed a potential out-of-bounds read in
drivers/scsi/libiscsi.c:iscsi_scsi_cmd_rsp():

        senselen =3D get_unaligned_be16(data);
        if (datalen < senselen)
                goto invalid_datalen;

        memcpy(sc->sense_buffer, data + 2,
               min_t(uint16_t, senselen, SCSI_SENSE_BUFFERSIZE));

Does this code read past the end of the received data? If datalen is exactly
equal to senselen, the memcpy copies from data + 2, which could read 2 bytes
past the valid data in the buffer and expose uninitialized or stale memory
into the SCSI sense buffer. Should the bounds check be datalen < senselen +=
 2?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260710050645.1194=
212-1-sammiee5311@gmail.com?part=3D1
