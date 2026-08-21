Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5243C432BD9
	for <linux-scsi@vger.kernel.org>; Fri, 21 Aug 2026 09:48:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787305684; cv=none; b=PA0kD09mbU9DEkfsFNMLhDbfZmEhVukrp/WSXX5a1R37cvHFm7LAHpqi2Z4PNglilOpw1XO1vHSA+ZVgDsk+hSHxzJcoWQ1FYlR2jeL5TUJgUscOHPGXjKvuKxi5kjErbMDoaBTyDAPU9ATIhrrD0bEuR/+r4yzv9A/nZf80l8o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787305684; c=relaxed/simple;
	bh=vuaHieavW4ubzKnxKhdBjrMqgoWkYksqMjdPWQE50XE=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=L3LhrkW8IoNXw4D3z2umcgpH/PghLpYmqsQ28fdo5EJOsUTij8EmNPcdcYxwS5s8N0GChZOyqlQHpJIvh37tFXbKa7kBjSAM+mxb9UWbIzD0gK/BFnJv3uwddfq3R7ts4NoLHbxbmpxI1F2UV4xuQCNUFSN4QRgEKN9qh0BXvJw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=JyGX4quA; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="JyGX4quA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 45F171F00A3A;
	Fri, 21 Aug 2026 09:47:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787305677;
	bh=9Yv2c/YtB7hKkBUO5MMlb9kv13yBQTgrK+nBiCOulsI=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=JyGX4quAIylkP8UCLfVo9xpO0w+4mwpGB6ejHJ8/B9B78XUA3O60jgfArOUQwrpfa
	 obByaGQNfsBzQBgAdpITjpfe9aYxMsRFmugekfG5s17mYSOF75Kai/sT+L8sM5of5a
	 /90tgMiCB8sn2rLNzfpMG3a23CBMsX1YpQXJCqbJvdRuPt2fykTm79yhhuHSrY79Ar
	 OzfvlRT9+h55wM9Uj2vtqmwG9OBA7kCqM+XBpyBoMi/0LtBR69wezkvUR8s2A3U/Mx
	 Cz7KrwRvFNMkK18ok/WJ+gXXQpiPAc4tSRMEyhvZvXkKr1WZhz4lEoXArFNqjeLmPi
	 71QVmjIibt6jw==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH -next 1/2] scsi: iscsi: fix NULL pointer dereference in
 iscsi_sw_tcp_release_conn()
Reply-To: sashiko-reviews@lists.linux.dev
To: "Ye Bin" <yebin@huaweicloud.com>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20260821092435.1632931-2-yebin@huaweicloud.com>
References: <20260821092435.1632931-1-yebin@huaweicloud.com>
 <20260821092435.1632931-2-yebin@huaweicloud.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 21 Aug 2026 09:47:56 +0000
Message-Id: <20260821094757.45F171F00A3A@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [High] The patch introduces an endpoint (`struct iscsi_endpoint`) referen=
ce leak by unconditionally clearing `ISCSI_CLS_CONN_BIT_CLEANUP` in `iscsi_=
if_stop_conn()` during a `STOP_CONN_TERM`, causing the subsequent endpoint =
disconnect to incorrectly skip releasing the workqueue's reference.
--

--- Patch [1]: [PATCH -next 1/2] scsi: iscsi: fix NULL pointer dereference =
in iscsi_sw_tcp_release_conn() ---
commit 15cab28507a9da46dab7d098d970770bae480083
Author: Ye Bin <yebin10@huawei.com>

scsi: iscsi: fix NULL pointer dereference in iscsi_sw_tcp_release_conn()

This commit addresses a NULL pointer dereference in iscsi_sw_tcp_release_co=
nn()
by ensuring the ISCSI_CLS_CONN_BIT_CLEANUP bit is set during STOP_CONN_TERM.
This prevents concurrent execution of iscsi_stop_conn().

> diff --git a/drivers/scsi/scsi_transport_iscsi.c b/drivers/scsi/scsi_tran=
sport_iscsi.c
> index 8aa76f813bcdb..aea319c1e72fe 100644
> --- a/drivers/scsi/scsi_transport_iscsi.c
> +++ b/drivers/scsi/scsi_transport_iscsi.c
> @@ -2278,35 +2280,36 @@ static int iscsi_if_stop_conn(struct iscsi_cls_co=
nn *conn, int flag)

[ ... ]

> -		/*
> -		 * Only clear for recovery to avoid extra cleanup runs during
> -		 * termination.
> -		 */
> -		spin_lock_irq(&conn->lock);
> -		clear_bit(ISCSI_CLS_CONN_BIT_CLEANUP, &conn->flags);
> -		spin_unlock_irq(&conn->lock);
> -	}
> +	} else {
> +		iscsi_stop_conn(conn, flag);
> +	}
> +
> +	spin_lock_irq(&conn->lock);
> +	clear_bit(ISCSI_CLS_CONN_BIT_CLEANUP, &conn->flags);
> +	spin_unlock_irq(&conn->lock);

[Severity: High]
Does this unconditionally clear ISCSI_CLS_CONN_BIT_CLEANUP during
STOP_CONN_TERM?

The original code avoided clearing this bit during termination, as the remo=
ved
comment explicitly noted.

If a connection error queues iscsi_cleanup_conn_work_fn(), which unbinds the
endpoint (setting conn->ep =3D NULL), and then userspace initiates terminat=
ion
via iscsi_if_stop_conn(conn, STOP_CONN_TERM), iscsi_if_disconnect_bound_ep()
won't be called here because conn->ep is NULL.

When this bit is subsequently cleared unconditionally, and userspace later =
issues
an event to disconnect the endpoint, will iscsi_if_disconnect_bound_ep() sk=
ip
releasing the workqueue's reference?

drivers/scsi/scsi_transport_iscsi.c:iscsi_if_disconnect_bound_ep() {
    ...
	if (!test_bit(ISCSI_CLS_CONN_BIT_CLEANUP, &conn->flags)) {
		spin_unlock_irq(&conn->lock);
		iscsi_ep_disconnect(conn, is_active);
	} else {
		...
		iscsi_put_endpoint(ep);
    ...
}

Could this cause a resource leak of struct iscsi_endpoint over time?

> +
>  	ISCSI_DBG_TRANS_CONN(conn, "iscsi if conn stop done.\n");
>  	return 0;
>  }

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260821092435.1632=
931-1-yebin@huaweicloud.com?part=3D1
