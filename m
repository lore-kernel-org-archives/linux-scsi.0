Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 330B436D50D
	for <linux-scsi@vger.kernel.org>; Thu, 30 Jul 2026 23:23:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785453823; cv=none; b=aylu8FpQMrs2cQFLj6GsbvfazlqVtPvhHtIUD01zHLBurxriGiQtpbicUc3e+PhMbPVcpKql1HkuIbN1PCi5pi7nPqYrwneIu8otFZczsvQd7pHfikaGQI6ueOtLHfDoc0iv/JLIZoNIvELRI9Ae+GLaVFbXSK5pRAyDxSb9t/E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785453823; c=relaxed/simple;
	bh=ZKq5SBlQrm/wzdm7JcnOxRRs4OD2+gSxRl9X96iT6o0=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=LoGU98cd/XCrD/D5FtMxbolhNBwlsey1M5G4njow4opIjElZnTD2ofqULIp0io3gkNGcgdz371x9wIpOEBgvThYgKFK6QZ2E8IRM9SXPBhnwqgZwiPjkvqM3NH7+F4LktrHQEqzbwcu+8RtcDow6u/hDpaSy0QDAJUwJ/q5uBWg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=JQ43THuV; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="JQ43THuV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 992A51F000E9;
	Thu, 30 Jul 2026 23:23:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785453821;
	bh=CCOKhiuanI7Vowa4FtWoYZ/y/7HmYorHKZYZlrTg1tk=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=JQ43THuVjgHpIRZeEgNwfmr+Axh5EFIUsfcRSNIAzA7bKTPvqayL253dg8nk6DgK4
	 QXzyI/01lYtaUNFbK5vACPmbrDmh8ddoQJOG2OXzrdu7wPs5NYgnU3carfGdk/eb2F
	 p39FzjAgSt2Ac9ABn6ZmMutocH8oTzuJ7Yov0K22RXbE7gmCn6SKcNdIxbDjBIzlMT
	 Kndo5sBSmV9+sasMDyQKJwfFq5SxWdhX6FYMVHcAgSDmsTgGTyXQMUwJyhAOvPHRHJ
	 5DbqjMAs0X5kmWbaM6//GipzSPR+jWjt4CXqOAT1XPsfRHAQ4HEfoWNmMe3/4/4lXp
	 GCXTVfLMpzW+g==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v3 51/57] scsi: iSCSI transport: Prepare for enabling
 lock context analysis
Reply-To: sashiko-reviews@lists.linux.dev
To: "Bart Van Assche" <bvanassche@acm.org>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <068c1230f0c04356f01d9c46eada7c48b1001e99.1785451174.git.bvanassche@acm.org>
References: <cover.1785451174.git.bvanassche@acm.org>
 <068c1230f0c04356f01d9c46eada7c48b1001e99.1785451174.git.bvanassche@acm.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 30 Jul 2026 23:23:41 +0000
Message-Id: <20260730232341.992A51F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 2 potential issue(=
s) to consider:

Pre-existing issues:
- [Critical] Dropping a lock without holding a reference allows concurrent =
teardown to free the connection object, leading to a Use-After-Free.
- [High] Pre-existing memory leak of `iscsi_endpoint` if userspace sends `I=
SCSI_UEVENT_STOP_CONN` before `ISCSI_UEVENT_TRANSPORT_EP_DISCONNECT` during=
 connection recovery.
--

--- Patch [51]: [PATCH v3 51/57] scsi: iSCSI transport: Prepare for enablin=
g lock context analysis ---
commit f51c8db89420b5a402dacd38c1b68b13f9794c32
Author: Bart Van Assche <bvanassche@acm.org>

scsi: iSCSI transport: Prepare for enabling lock context analysis

Document locking requirements with __must_hold().

> diff --git a/drivers/scsi/scsi_transport_iscsi.c b/drivers/scsi/scsi_tran=
sport_iscsi.c
> index 8aa76f813bcdb..ade69c7b65b47 100644
> --- a/drivers/scsi/scsi_transport_iscsi.c
> +++ b/drivers/scsi/scsi_transport_iscsi.c
> @@ -2243,6 +2243,7 @@ static void iscsi_ep_disconnect(struct iscsi_cls_co=
nn *conn, bool is_active)
>  static void iscsi_if_disconnect_bound_ep(struct iscsi_cls_conn *conn,
>  					 struct iscsi_endpoint *ep,
>  					 bool is_active)
> +	__must_hold(&conn->ep_mutex)

[Severity: High]
This isn't a bug introduced by this patch, but could this lead to a memory =
leak
of the iscsi_endpoint?

If userspace sends ISCSI_UEVENT_STOP_CONN during connection recovery,
iscsi_if_stop_conn() unconditionally clears ISCSI_CLS_CONN_BIT_CLEANUP:

drivers/scsi/scsi_transport_iscsi.c:iscsi_if_stop_conn()
    ...
    clear_bit(ISCSI_CLS_CONN_BIT_CLEANUP, &conn->flags);
    ...

Then, when ISCSI_UEVENT_TRANSPORT_EP_DISCONNECT is handled here in
iscsi_if_disconnect_bound_ep(), the bit check fails:

drivers/scsi/scsi_transport_iscsi.c:iscsi_if_disconnect_bound_ep()
    ...
    if (!test_bit(ISCSI_CLS_CONN_BIT_CLEANUP, &conn->flags)) {
        spin_unlock_irq(&conn->lock);
        iscsi_ep_disconnect(conn, is_active);
    } else {
    ...

This bypasses the iscsi_put_endpoint() call in the else block, which appears
to permanently leak the endpoint if the cleanup work previously took a
reference.


[Severity: Critical]
This is a pre-existing issue, but does dropping this mutex allow a
use-after-free of the connection object?

When the else block is taken in this function:

drivers/scsi/scsi_transport_iscsi.c:iscsi_if_disconnect_bound_ep()
    ...
    } else {
        spin_unlock_irq(&conn->lock);
        ISCSI_DBG_TRANS_CONN(conn, "flush kernel conn cleanup.\n");
        mutex_unlock(&conn->ep_mutex);

        flush_work(&conn->cleanup_work);
        /* ... */
        iscsi_put_endpoint(ep);
        mutex_lock(&conn->ep_mutex);
    }

iscsi_if_ep_disconnect() does not take a reference on conn (which is not
refcounted by the endpoint). If a concurrent hardware teardown destroys the
connection and drops its last reference during flush_work(), wouldn't
mutex_lock(&conn->ep_mutex) re-acquire the lock on freed memory?

>  {
>  	/* Check if this was a conn error and the kernel took ownership */
>  	spin_lock_irq(&conn->lock);

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/cover.1785451174.gi=
t.bvanassche@acm.org?part=3D51
