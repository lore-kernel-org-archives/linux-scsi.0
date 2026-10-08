Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2F0A636A350
	for <linux-scsi@vger.kernel.org>; Thu,  8 Oct 2026 06:24:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791440701; cv=none; b=b62QyIobCHMNUC9J08fWfi1T8HfI9mherLiMD1W41AF9qhWW0IUvZsxCX6JjbRdGqSKyjUkPh3RyDZU3sygTB2ced9t6JbVPrXuxeRCTrA21Y43PO++1+b36woRtpFBm3dVBRifmSoa3bf9CCsuxXJqzl22W8e5NEGcD7LYRcGA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791440701; c=relaxed/simple;
	bh=BuZY/tRaOjNegCy9NIYVfqAnoxpBMlAYTulrsI0bQJc=;
	h=Message-ID:From:Subject:To:Cc:In-Reply-To:References:Content-Type:
	 Date; b=sKM2ayM6OTf8tD1uk1HdjaccNaIjqaXTzat0cNuiPgaCAWfh+PyKoBZiX6U0G/aH1ehI2DJczRdnoeiJu6T0j13daeYViyEdIXiGx6aqIkh1pGuP24kk/TxPOUvXZ4J8ClSV9AlQGhkSBvlcPaB2IVbMjDXEQObACmWVZKmLafo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Ewh8AtLj; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Ewh8AtLj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A6D501F000FF;
	Thu,  8 Oct 2026 06:24:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791440699;
	bh=GSIeoubnZtbM1LLXsxtWI5wk8y3LXeyNMOrxHEQFHAE=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=Ewh8AtLjj2amRsQ+1hGf4a1iEdSmj/kbm9bKd3nmLcsf9IDygIfrb/daFKJXOCMf3
	 xn0/qJdjUE5dxb1dEkfyxbmjCC6NVnNenoGgutwjFrspkvQ30daTuPgV7qfQbEwetS
	 JUT0V96JIqA8rRArpRSug8CSI15hlURhUiAc0X1I9fYkcPUvfaFIMxDc2RKCeYDeP6
	 0hg04iWgj4QkyC+7Ed0HMeT0oMOPgA/q4urtiMLRwfl/gf55BiDmWNcfrRwENZuoip
	 TA6Fxf+WDNJQfKjPIxBJBQcH4ktPDu4cEJTMmgRMt4ozgeYTzZs9j/w5B60/rcL1Gw
	 U3VX5IfnGV/Jw==
Message-ID: <sashiko-outbox-163686@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH] target: iscsi: reject ImmediateData on non-WRITE
 commands
Reply-To: sashiko-reviews@lists.linux.dev
To: "sung byeongchan" <tjdqudcks0424@naver.com>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20261008060347.175260-1-tjdqudcks0424@naver.com>
References: <20261008060347.175260-1-tjdqudcks0424@naver.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 08 Oct 2026 06:24:59 +0000
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [High] iscsi: PDU injection via unconsumed immediate data on reject
--

commit 8092717f025cfe28cadafc17843da9c3d45dd5dc
Author: sung byeongchan <tjdqudcks0424@naver.com>

target: iscsi: reject ImmediateData on non-WRITE commands

This commit modifies iscsit_setup_scsi_cmd() to reject non-WRITE commands
that contain ImmediateData.

> diff --git a/drivers/target/iscsi/iscsi_target.c b/drivers/target/iscsi/i=
scsi_target.c
> index 124ff269b8e75..b8e26e00cd462 100644
> --- a/drivers/target/iscsi/iscsi_target.c
> +++ b/drivers/target/iscsi/iscsi_target.c
> @@ -1098,6 +1098,12 @@ int iscsit_setup_scsi_cmd(struct iscsit_conn *conn=
, struct iscsit_cmd *cmd,
>  					     ISCSI_REASON_BOOKMARK_INVALID, buf);
>  	}
> =20
> +	if (payload_length && !(hdr->flags & ISCSI_FLAG_CMD_WRITE)) {
> +		pr_err("Immediate data for non-WRITE command\n");
> +		return iscsit_add_reject_cmd(cmd,
> +					     ISCSI_REASON_PROTOCOL_ERROR, buf);
> +	}
> +
>  	cdb =3D hdr->cdb;

[Severity: High]
Does rejecting the command here leave attacker-controlled data in the recei=
ve
buffer?

When iscsit_setup_scsi_cmd() returns the rejection, the caller
iscsit_handle_scsi_cmd() handles the error by returning 0:

iscsit_handle_scsi_cmd() {
    ...
	rc =3D iscsit_setup_scsi_cmd(conn, cmd, buf);
	if (rc < 0)
		return 0;
    ...
}

This fails to consume the payload_length bytes from the TCP socket and leav=
es
it open for further reading.

Because iscsi_target_rx_opcode() returns 0, the receive loop in
iscsit_get_rx_pdu() continues and reads the next ISCSI_HDR_LEN bytes from t=
he
unconsumed immediate data:

iscsit_get_rx_pdu() {
    ...
		ret =3D rx_data(conn, &iov, 1, ISCSI_HDR_LEN);
		if (ret !=3D ISCSI_HDR_LEN) {
    ...
		ret =3D iscsi_target_rx_opcode(conn, buffer);
		if (ret < 0)
			break;
    ...
}

Could an attacker use this unconsumed immediate data to inject arbitrary iS=
CSI
PDUs that bypass deep packet inspection?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261008060347.1752=
60-1-tjdqudcks0424@naver.com?part=3D1
