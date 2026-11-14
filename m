Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794674677;
	b=HQ3sNcyjvosptdtZd8k7OT5yHwlJJfQcYe8MwZNli6cv3pq4FeK2SFJfB3IaAMf0pxTT
	 0A3w1M3sf81UTCtB+nHHl/f7pS6HN0JuNEfcokJZP7gxam93RLInpOoDhjze/4JfDfKJq
	 6SQt8WzcvUHjd2OIEoIhJn8c4blXjhGQMVFUjijsKbYPAAHwenDiO1aAAO7mlupchnnJ5
	 uHPxrSQ6xgSJYNRMxWymBDMhGlcpjoIwuSsp6d1dj5aONBNZhdDZQs1/GtSNkQS96nnjJ
	 WPWhaNh9PLThaRohA2/aKqWdVq1kLdcJAcooITobqeTGAs1d21IvO7vaZ9uE+BHNXMg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794674677;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=pbh8AtwTyjhRrlmKQ6swY9DkeM3L8ZOy3RmWBEu+nRg=;
	b=WR3V3gNxqdep87HT1AHwZTLLGMRQtd3YQ8nKxZrFA7m3yfYe7OVV5kjfBbdPjfyd3756
	 VXfFB+vxxTNlq16eIm3KUj0vLfGxZVlSgqaUu7L76lETVZx/mrJviA02Frx0umA8ydZ5M
	 IJvHayepX1eUhXnXKB4JEf4LDssjTwR3GgxBML4P2KngNJ5H4qnJZd/8T9Vu1c5Hc9IrN
	 k5/znxIxfXrSZEO0y4imS9QRWlKlT7hb1g70s+n65htlXecmLrIBqhiZoSLkqQstnV26I
	 9l4JA8vOjk86IxK9z/TAY9QqFTIV33w4ljL9XOTjsyFnX5dAQJ5yfEU5mudoE+/zLRA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=iotS4cj0;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B0B2606A329;
	Sat, 14 Nov 2026 16:44:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=iotS4cj0
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E3D611F000C4;
	Sat, 14 Nov 2026 16:44:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794674677;
	bh=pbh8AtwTyjhRrlmKQ6swY9DkeM3L8ZOy3RmWBEu+nRg=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=iotS4cj09mmnXWK+hviMuPo2ERFCAqJ85d0ItPSAo7uBvA49m1goB11scNASl4dt9
	 +U9nqkjUCHoBhekXrE8H6slWbLE/kEXLQdGnoCerNT02ewrJq8Agq1PRHqLk3npYK0
	 Uz66ad4oTyTO9N+vZ0yBdA932LQ04tK6cDhJli1Fa9ByYFgl64lKwOrQ0xX3wcleEI
	 Fp6Nt2el+dTOtFGIIEemeq4DIiN7mSTZSvflAR5cw9573gdKulWsznFQVlx30Iizf3
	 Q7mgB62hwFyNZ2ECNvUuun+QGRoV3rjKzT+2uicnYd1I7xNMSpPJ6/o1GLTClEEkch
	 Dp/KAg7F4KUOQ==
Message-ID: <sashiko-outbox-214783@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH] scsi: target: iscsi: do not reject the command on a
 Data-Out overflow
Reply-To: sashiko-reviews@lists.linux.dev
To: "Yehyeong Lee" <yhlee@isslab.korea.ac.kr>
Cc: target-devel@vger.kernel.org, linux-scsi@vger.kernel.org
In-Reply-To: <20261114161931.941441-1-yhlee@isslab.korea.ac.kr>
References: <20261114161931.941441-1-yhlee@isslab.korea.ac.kr>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Sat, 14 Nov 2026 16:44:36 +0000
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Post: <mailto:linux-scsi@vger.kernel.org>
List-Help: <mailto:linux-scsi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-scsi+owner@vger.kernel.org>
Precedence: list

Thank you for your contribution! Sashiko AI review found 1 potential
issue to consider:
- [Critical] scsi: target: iscsi: NULL deref in isert_post_recv() via
  iscsit_add_reject()
--

commit b4583fae14731c9492a924f04662a5a7049c19bd
Author: Yehyeong Lee <yhlee@isslab.korea.ac.kr>

scsi: target: iscsi: do not reject the command on a Data-Out overflow

This commit changes __iscsit_check_dataout_hdr() to reject an overflowing
Data-Out PDU with iscsit_add_reject() instead of iscsit_reject_cmd() so
that the command's reference is not dropped while it remains on
conn_cmd_list.

> diff --git a/drivers/target/iscsi/iscsi_target.c b/drivers/target/iscsi/i=
scsi_target.c
> index 03d618cd76721..884c9678b4ed9 100644
> --- a/drivers/target/iscsi/iscsi_target.c
> +++ b/drivers/target/iscsi/iscsi_target.c
> @@ -1485,7 +1485,12 @@ __iscsit_check_dataout_hdr(struct iscsit_conn *con=
n, void *buf,
>  		pr_err("DataOut Offset: %u, Length %u greater than iSCSI Command EDTL =
%u, protocol error.\n",
>  		       be32_to_cpu(hdr->offset), payload_length,
>  		       cmd->se_cmd.data_length);
> -		return iscsit_reject_cmd(cmd, ISCSI_REASON_BOOKMARK_INVALID, buf);
> +		/*
> +		 * Reject the PDU, not the command: iscsit_reject_cmd() would
> +		 * drop its last reference while it is on conn_cmd_list.
> +		 */
> +		return iscsit_add_reject(conn, ISCSI_REASON_BOOKMARK_INVALID,
> +					 buf);
>  	}
> =20
>  	if (cmd->unsolicited_data) {

[Severity: Critical]
Does this cause a NULL pointer dereference in isert_post_recv() on iSER
connections when an unsolicited Data-Out PDU overflows the command's EDTL?

isert_handle_iscsi_dataout() calls iscsit_check_dataout_hdr() ->
__iscsit_check_dataout_hdr().  iscsit_add_reject() allocates a fresh
command with iscsit_allocate_cmd() rather than isert_allocate_cmd(),
leaving the transport-private struct isert_cmd zeroed with rx_desc,
iscsit_cmd, and conn all NULL, and returns -1 so
isert_handle_iscsi_dataout() returns without reposting the incoming
rx_desc.

When the TX thread processes the queued ISTATE_SEND_REJECT response via
isert_response_queue() -> isert_put_reject() -> isert_post_response(), it
passes that NULL isert_cmd->rx_desc to isert_post_recv():

drivers/infiniband/ulp/isert/ib_isert.c:isert_post_response() {
	ret =3D isert_post_recv(isert_conn, isert_cmd->rx_desc);
	...
}

drivers/infiniband/ulp/isert/ib_isert.c:isert_post_recv() {
	if (!rx_desc->in_use) {
	...
}

This dereferences rx_desc when it is NULL, leaks the original receive
descriptor, and leaves isert_cmd->iscsit_cmd and isert_cmd->conn NULL for
isert_send_done() and isert_do_control_comp().

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261114161931.9414=
41-1-yhlee@isslab.korea.ac.kr?part=3D1
