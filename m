Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D2532472544
	for <linux-scsi@vger.kernel.org>; Fri, 21 Aug 2026 09:50:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787305810; cv=none; b=RQvlSVAOO+RtC0ScrJP3scy0BWpJd0C3iYl2FLKBVOBVLJt6/nsGTWI4Qb8phr/4HgDF+8vyU0YiPr8ZTrqo+Lwa4nbJIVqX20lGy9nWQEQijkKSDiUUC/a8gXbdsPIxUad4UL0kza7lDUrnHT/i6JX08Qo/mios6BZbXIKl3C4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787305810; c=relaxed/simple;
	bh=tE1eTgPvbETi71etP0N6Nc7llkF5AhoVx9YEuk9v93s=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=FR7fAvKLkvb75fH3TxU0x3FYbL2IpK1aJN+t9jBIETJScWv0EjiPimx9olBV8k19lrLTo8qFz4Pd++dATQCtNAmAx0tCjVYZnkB2/wDO4/w6JyZRlUyKl2ZrriCqcyt0c9fbPhDcfDRTPZeKBITyWMSE7LlKf/hC+kWIR2P0zQQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=BWro1YQn; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="BWro1YQn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5FDAE1F00A3A;
	Fri, 21 Aug 2026 09:49:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787305798;
	bh=i/H06YGu1C972pql8ZzGLDiWz8OXUlwSWVc4sJzFl40=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=BWro1YQn4r2APhTIsI7OU4viZxj8bhf8HpsfIoHXmgtdRDQgww44cKAIUw6w1WsaB
	 89C+2AaAIM/nkeM6CWhW/cY/qFM77UhSt1ihIAlfxT2oeiyg1sD+Rd+RJ/pbJG2Bd6
	 LH8GkIK/t2ykham64wEAi0BhFbZJ7KAYbyUiIg2AyibeXIimhc9tRUrGqB4ADLq8ov
	 sqMQLqrCmdnfs2pktflkLjq0br/FRm/nG8vESLyneVTl1tVQJqbZS/LWvbrXwoH9/k
	 q4xx0WA7pc/ir/rwC/dVRw1vjgP2ZfygduS7lGRVhAE0MCQiY2gWBWCZOr3VG4A9HD
	 e6TIz0BDmJg4A==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH -next 2/2] scsi: iscsi: Fix use-after-free in
 iscsi_conn_release() for cleanup_work
Reply-To: sashiko-reviews@lists.linux.dev
To: "Ye Bin" <yebin@huaweicloud.com>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20260821092435.1632931-3-yebin@huaweicloud.com>
References: <20260821092435.1632931-1-yebin@huaweicloud.com>
 <20260821092435.1632931-3-yebin@huaweicloud.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 21 Aug 2026 09:49:57 +0000
Message-Id: <20260821094958.5FDAE1F00A3A@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 3 potential issue(=
s) to consider:

New issues:
- [High] Adding `cancel_work_sync(&conn->cleanup_work)` inside `iscsi_conn_=
release()` introduces a guaranteed AB-BA deadlock with `session->eh_mutex` =
when the final connection reference is dropped by the SCSI error handler.

Pre-existing issues:
- [Critical] ep->conn is never cleared when a connection is destroyed, lead=
ing to a Use-After-Free in iscsi_if_ep_disconnect().
- [High] LLD-specific background tasks (e.g., `transport_timer`, `xmitwork`=
) are not canceled before `iscsi_conn_release()` frees the connection memor=
y, leading to a Use-After-Free.
--

--- Patch [2]: [PATCH -next 2/2] scsi: iscsi: Fix use-after-free in iscsi_c=
onn_release() for cleanup_work ---
commit 16664476ef28f32b2b58204098a289184054f45c
Author: Ye Bin <yebin10@huawei.com>

scsi: iscsi: Fix use-after-free in iscsi_conn_release() for cleanup_work

This patch attempts to resolve a use-after-free by canceling the pending or
running cleanup_work task before freeing the connection memory in
iscsi_conn_release().

> diff --git a/drivers/scsi/scsi_transport_iscsi.c b/drivers/scsi/scsi_tran=
sport_iscsi.c
> index aea319c1e72fe..cdc337b0fc26a 100644
> --- a/drivers/scsi/scsi_transport_iscsi.c
> +++ b/drivers/scsi/scsi_transport_iscsi.c
> @@ -2128,6 +2128,13 @@ static void iscsi_conn_release(struct device *dev)
>  	struct device *parent =3D conn->dev.parent;
> =20
>  	ISCSI_DBG_TRANS_CONN(conn, "Releasing conn\n");
> +	/*
> +	 * iscsi_conn_error_event() may have queued conn->cleanup_work without
> +	 * holding a reference to the connection. Cancel any pending or
> +	 * running work before freeing the connection to prevent a
> +	 * use-after-free.
> +	 */
> +	cancel_work_sync(&conn->cleanup_work);

[Severity: High]
Could this cancel_work_sync() introduce an AB-BA deadlock with
session->eh_mutex?

If a concurrent session teardown drops the main connection references, the
SCSI error handler might drop the final reference while still holding the
eh_mutex:

drivers/scsi/libiscsi.c:iscsi_eh_abort() {
    mutex_lock(&session->eh_mutex);
    ...
    iscsi_put_conn(conn->cls_conn);
    mutex_unlock(&session->eh_mutex);
}

When iscsi_put_conn() triggers iscsi_conn_release(), it will block here
waiting for the workqueue to finish. However, if the worker thread is
already running, it attempts to acquire the exact same mutex:

drivers/scsi/libiscsi.c:iscsi_conn_stop() {
    mutex_lock(&session->eh_mutex);
    ...
}

Would this cause the error handler and the workqueue to wait on each other
indefinitely?

> +	kfree(conn);

[Severity: High]
This is a pre-existing issue, but does freeing the connection here without
canceling LLD-specific background tasks leave a use-after-free risk?

When a session is abruptly torn down, the teardown iterates over active
connections and drops the final reference:

drivers/scsi/scsi_transport_iscsi.c:iscsi_iter_destroy_conn_fn() {
    ...
    iscsi_remove_conn(iscsi_dev_to_conn(dev));
    iscsi_put_conn(iscsi_dev_to_conn(dev));
}

Because this bypasses the transport's destroy_conn callback (such as
iscsi_conn_teardown), asynchronous tasks like conn->transport_timer and
conn->xmitwork are never canceled.

Could this regression allow these timers or work tasks to execute later and
dereference the freed connection memory?

[Severity: Critical]
This is a pre-existing issue, but is there another use-after-free possible
when an endpoint disconnects after a connection is destroyed?

If a session is forcefully destroyed via iscsi_remove_session(), the
connection is freed in iscsi_conn_release() as seen above. However,
ep->conn does not appear to be cleared when this happens.

If userspace then issues an ISCSI_UEVENT_TRANSPORT_EP_DISCONNECT command,
the kernel reads the dangling ep->conn pointer:

drivers/scsi/scsi_transport_iscsi.c:iscsi_if_ep_disconnect() {
    conn =3D ep->conn;
    if (!conn) {
        ...
    }
   =20
    mutex_lock(&conn->ep_mutex);
}

Could this regression allow a userspace netlink command to trigger a
use-after-free by acquiring the mutex on the freed connection memory?

>  	put_device(parent);
>  }

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260821092435.1632=
931-1-yebin@huaweicloud.com?part=3D2
