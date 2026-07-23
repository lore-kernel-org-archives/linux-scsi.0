Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 16CF01A9F8D
	for <linux-scsi@vger.kernel.org>; Thu, 23 Jul 2026 00:42:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784767375; cv=none; b=hOEvGSWwTXbY0lUsc4wWgIF1Eo2JsOg0micSeHDs3DKaRk/V9pGto8GsAB2bE7naihYTgT8UXOtqyyHN5TN/6hppP7fXrtlM96pjlydgXX+W/+cy3CI15cPPdDMe9WdtcP4aKb7WJoV7GOiX6E3kKSf4zEAXmRoHXEaNPAgeWW4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784767375; c=relaxed/simple;
	bh=PKNS/E/gDTrfh/yYDJfqljOnpNY1UWXtLO9jY6cjWlg=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=LWLTT7Nkulirce8kDg+QlToubAXseMzqdkm8dwdCpefWpvI8pj7EIqM8gDLvQs/Wv9l761w019mmybI0MOtvkUddQ+5gqxScKdGs89AQDbZ1+uAcMOQCdFL5nTq2MFkm9VaCYjllCSfh/2hbOHOxhKA8WdB7W+GTuNFPds++CH8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=RIMS85uL; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="RIMS85uL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 81E821F000E9;
	Thu, 23 Jul 2026 00:42:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784767373;
	bh=jHikZqEcpe0jf+haRslMY6XoZWDYA0mvlxk9AiIF8j0=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=RIMS85uLTk85xxEQP0Qy/brAACRQHVFkNNJc54ixct/5Cx0lNpsdEfpxxWnSgeWL4
	 JJhsnCptO+OA2nUYPWt0M3Jz+CIkhTKpbmuVbU7cWIWXCxQ3Ys200vux3Np2WbE5O2
	 lAmsR7PrBGlVyNYwTI++8Tn5Y9BfrDFYxiKyhwzMf7Uqmnqk0rrN3EOrxpa6OP42YX
	 QCFfMuOupkytx7715xqNo30Nfy96iEXMOCtNpBu8jAmSKxK9pSxR6VyOhPOVgKvEA5
	 vBbnZ1+pibSvKE2VLS4gBgL6ZigWvxDCq8TScfQf3f8ymn7E84kITd2WxpZBqeSHXD
	 +onQkIPw7kdPw==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v2 01/33] ibmvfc: don't call locked done variant for
 MADs on send failure
Reply-To: sashiko-reviews@lists.linux.dev
To: "Tyrel Datwyler" <tyreld@linux.ibm.com>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20260723000149.969416-2-tyreld@linux.ibm.com>
References: <20260723000149.969416-1-tyreld@linux.ibm.com>
 <20260723000149.969416-2-tyreld@linux.ibm.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 23 Jul 2026 00:42:53 +0000
Message-Id: <20260723004253.81E821F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 3 potential issue(=
s) to consider:

New issues:
- [High] The patch introduces an uninitialized function pointer dereference=
 when a Task Management Function (TMF) fails to send. It assigns `evt->done=
 =3D evt->_done;` in the failure path of `ibmvfc_send_event()` when `evt->c=
mnd` is NULL, assuming all such events are Management Datagrams (MADs). How=
ever, TMF events like `ibmvfc_reset_device` and `ibmvfc_abort_task_set` lac=
k a SCSI command but use `IBMVFC_CMD_FORMAT`. For `IBMVFC_CMD_FORMAT`, `ibm=
vfc_init_event()` leaves `evt->_done` completely uninitialized. Overwriting=
 `evt->done` with the uninitialized `evt->_done` and executing it causes a =
kernel panic or use-after-free (by executing a stale callback from a previo=
us allocation).

Pre-existing issues:
- [High] In the failure path of `ibmvfc_send_event()`, when an event withou=
t a SCSI command (`evt->cmnd =3D=3D NULL`) fails to send, the code writes a=
n error status to `evt->xfer_iu->mad_common.status`. However, TMF events us=
e `struct ibmvfc_cmd` rather than `struct ibmvfc_mad_common`. Because they =
share the `ibmvfc_iu` union, writing to `mad_common.status` (offset 12) cor=
rupts the `payload_len` field of the `ibmvfc_cmd` structure and leaves the =
actual `cmd.status` field (offset 24) as 0 (success). This causes callers l=
ike `ibmvfc_reset_device` to silently ignore transport failures.
- [High] `ibmvfc_cancel_all_mq()` ignores the return value of `ibmvfc_send_=
event()`. If the transmit fails because the queue is closed (`H_CLOSED`), `=
ibmvfc_send_event()` immediately frees the event and returns `SCSI_MLQUEUE_=
HOST_BUSY` without ever triggering completion. Because the return value is =
ignored, the caller blindly adds the already-freed event to the `cancelq` l=
ist and blocks on `wait_for_completion(&evt->comp)`. This causes a permanen=
t thread hang on a completion that will never occur, and creates a severe u=
se-after-free vulnerability by linking a freed object into an active list.
--

--- Patch [1]: [PATCH v2 01/33] ibmvfc: don't call locked done variant for =
MADs on send failure ---
commit 5ca8f4e826ff5d72e9b72e057f69819222a9934b
Author: Tyrel Datwyler <tyreld@linux.ibm.com>
ibmvfc: don't call locked done variant for MADs on send failure

This commit modifies the error path for Management Datagram (MAD) sends
when h_send_crq fails with an error other than H_CLOSED. It updates the
fallback logic to use the saved unlocked evt->_done completion handler.

> diff --git a/drivers/scsi/ibmvscsi/ibmvfc.c b/drivers/scsi/ibmvscsi/ibmvf=
c.c
> index 3dd2adda195ee..0a5f73df8d7d2 100644
> --- a/drivers/scsi/ibmvscsi/ibmvfc.c
> +++ b/drivers/scsi/ibmvscsi/ibmvfc.c

[ ... ]

> @@ -1774,8 +1774,10 @@ static int ibmvfc_send_event(struct ibmvfc_event *=
evt,
>                  if (evt->cmnd) {
>                          evt->cmnd->result =3D DID_ERROR << 16;
>                          evt->done =3D ibmvfc_scsi_eh_done;
> -               } else
> +               } else {
>                          evt->xfer_iu->mad_common.status =3D cpu_to_be16(=
IBMVFC_MAD_CRQ_ERROR);

[Severity: High]
This is a pre-existing issue, but does writing to mad_common.status here
corrupt the command structure for TMF events?

Since TMF events like ibmvfc_reset_device() don't have a scsi_cmnd, they
fall into this else block. However, they use struct ibmvfc_cmd rather than
struct ibmvfc_mad_common.

Because these share the ibmvfc_iu union:

drivers/scsi/ibmvscsi/ibmvfc.h:union ibmvfc_iu {
        struct ibmvfc_mad_common mad_common;
        ...
        struct ibmvfc_cmd cmd;
}

Writing to mad_common.status (offset 12) inadvertently modifies the
payload_len field of the cmd structure, leaving cmd.status (offset 24)
as 0. Callers then check cmd.status and might incorrectly assume the device
reset was successfully received.

> +                       evt->done =3D evt->_done;

[Severity: High]
Could this assignment result in executing an uninitialized function pointer?

When a Task Management Function (TMF) fails to send, such as in
ibmvfc_reset_device(), the event has evt->cmnd set to NULL but uses
IBMVFC_CMD_FORMAT.

During initialization:

drivers/scsi/ibmvscsi/ibmvfc.c:ibmvfc_init_event() {
        ...
        if (format =3D=3D IBMVFC_CMD_FORMAT)
                evt->done =3D done;
        else {
                evt->_done =3D done;
        ...
}

Because evt->_done is left uninitialized for IBMVFC_CMD_FORMAT, overwriting
evt->done with evt->_done in this error path could cause a kernel panic
when evt->done(evt) is subsequently called.

> +               }
> =20
>                  evt->done(evt);
>          } else {

[Severity: High]
This is a pre-existing issue, but is the return value of ibmvfc_send_event()
handled safely inside ibmvfc_cancel_all_mq()?

If h_send_crq() returns H_CLOSED, ibmvfc_send_event() immediately frees the
event and returns SCSI_MLQUEUE_HOST_BUSY:

drivers/scsi/ibmvscsi/ibmvfc.c:ibmvfc_send_event() {
        ...
        if (rc =3D=3D H_CLOSED) {
                ...
                ibmvfc_free_event(evt);
                return SCSI_MLQUEUE_HOST_BUSY;
        }
        ...
}

However, ibmvfc_cancel_all_mq() ignores the return value:

drivers/scsi/ibmvscsi/ibmvfc.c:ibmvfc_cancel_all_mq() {
        ...
        ibmvfc_send_event(evt, vhost, default_timeout);
        list_add_tail(&evt->cancel, &cancelq);
        ...
        wait_for_completion(&evt->comp);
        ...
}

Could this lead to linking a freed event into the active cancel list and
permanently waiting on its completion?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260723000149.9694=
16-1-tyreld@linux.ibm.com?part=3D1
