Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794128910;
	b=DLdf4rOvzt+Tsl8Zu9VPu5gB/7xvZ6NoM+IdGxeAca32Z0FyN4zRt+phrL6hO1yPzTeB
	 /xL2XUzcMAtl/soE/CjMnYFIOaTCQ9FVzqp9R4pFefFONne6Ah8aMdFIiTyZ0/FJiQcVp
	 rDBkeSH+ENYzVWwqbdGy5s98267ezfc21OE6ePyYEQE1IzzAMwnyLx9D73jS5e93A1lQ/
	 ZoyMTIgE0lNYiEpf/T3f05GRX6+0+HBlqaFEoLSh00Ee0JwGB0RbfdUyITru4q1hFG5og
	 qRoOgPzfQrM8UUEAcY5d8i9Ml17g3huLsBiuJ3j+vitVE0jrATXj76BRD2ohzOlG7Kg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794128910;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=546d4m+75ADeCIu+ConIln9i6BSV/gezJ3/9S+DMFYY=;
	b=gMG2ZA6Rj2tnJYelXnzvcWsOwKYX2qf9bGaRl8nz3oXI7qfk5aFl6sPdeI0pFrw9OGwd
	 79XXCuilTtWN36Md27aE/7mz50bFpkV9TVcRKp+Sn4SDFFa57Mnmb5Z4T4CGHs67HfaoN
	 +KVYvdA6le7aFVW7/hbS77NkxflSc3k09/ilS7VbFM4fsve1eYfkYWBas3l8YBEestbXu
	 evidBxof+86O2R+xMTohHpimn4KtzY/M9+X9jjL2w9o+FwMupDYul6eGq4X06vtixgCVw
	 P3EgwIRKYNGFGAsicuJeMnOsk2s7I1ix0da08RRB984NbCCpTYNJcpANtDTO6ggh7Hg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=m63ueYnm;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 07EF6606A320
	for <linux-scsi@vger.kernel.org>; Sun,  8 Nov 2026 09:08:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=m63ueYnm
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 629A01F0089F;
	Sun,  8 Nov 2026 09:08:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794128909;
	bh=546d4m+75ADeCIu+ConIln9i6BSV/gezJ3/9S+DMFYY=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=m63ueYnmHtDH9F1jBHXaTwz3hBoLbijZ7VbBI/vBnXWWxTpsU32CZa9U+1EKv+W3n
	 JlvrZhHYZdOZnd/dAboepXBfWIGGaHJwk4pnSUf/FA9hHUErmeD5I3YpOrrxJe0VO+
	 EJyt0s3ohCLHIw3hQ1gkpGxGGOMXx3KVxnnhpdgT96TbSwTDSR7lGEgFLce3X9/rhn
	 59pzmDhlezuXldAWQRWiUhY/1OrZ1ZMpiGbK6o5coszF6yvWSNEeY9sfcN4HYYp0aY
	 yqmo3LMSjfsuikpSepfv1iRxV8A7Fn9JtbyG49raJ3D3bTlVBrzMzQ41KpJphEJk0S
	 sJlWQFQks6jfg==
Message-ID: <sashiko-outbox-203654@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH] scsi: libfc: Fix rport kref leak in
 fc_rport_enter_ready()
Reply-To: sashiko-reviews@lists.linux.dev
To: "Weidong Wang" <weidongw@illinois.edu>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20261108-h123-send-v1-1-b7672ff849f0@illinois.edu>
References: <20261108-h123-send-v1-1-b7672ff849f0@illinois.edu>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Sun, 08 Nov 2026 09:08:28 +0000
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Post: <mailto:linux-scsi@vger.kernel.org>
List-Help: <mailto:linux-scsi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-scsi+owner@vger.kernel.org>
Precedence: list

Thank you for your contribution! Sashiko AI review found no new issues
in this patch, but noticed 1 related pre-existing issue it does not
introduce:
- [Medium] scsi: libfc: reference leak in fc_rport_work() [1]
--

commit f18e1c7bd3d9738ea4413b32cfed69e7594a5a24
Author: Weidong Wang <weidongw@illinois.edu>

scsi: libfc: Fix rport kref leak in fc_rport_enter_ready()

This commit avoids taking a reference on rdata->kref in
fc_rport_enter_ready() when rdata->event is already pending and
rdata->event_work will not be queued.

> diff --git a/drivers/scsi/libfc/fc_rport.c b/drivers/scsi/libfc/fc_rport.c
> index c25979d96808a..7b093854462e4 100644
> --- a/drivers/scsi/libfc/fc_rport.c
> +++ b/drivers/scsi/libfc/fc_rport.c
> @@ -550,10 +550,11 @@ static void fc_rport_enter_ready(struct fc_rport_pr=
iv *rdata)
> =20
>  	FC_RPORT_DBG(rdata, "Port is Ready\n");
> =20
> -	kref_get(&rdata->kref);
> -	if (rdata->event =3D=3D RPORT_EV_NONE &&
> -	    !queue_work(rport_event_queue, &rdata->event_work))
> -		kref_put(&rdata->kref, fc_rport_destroy);
> +	if (rdata->event =3D=3D RPORT_EV_NONE) {
> +		kref_get(&rdata->kref);
> +		if (!queue_work(rport_event_queue, &rdata->event_work))
> +			kref_put(&rdata->kref, fc_rport_destroy);
> +	}
> =20
>  	rdata->event =3D RPORT_EV_READY;
>  }

[Severity: Medium]
This problem wasn't introduced by this patch, but doesn't the RPORT_EV_READY
handler in fc_rport_work() also leak the workqueue reference taken here when
fc_remote_port_add() fails [1]?

drivers/scsi/libfc/fc_rport.c:fc_rport_work() {
	switch (event) {
	case RPORT_EV_READY:
		...
		kref_get(&rdata->kref);
		mutex_unlock(&rdata->rp_mutex);

		if (!rport) {
			FC_RPORT_DBG(rdata, "No rport!\n");
			rport =3D fc_remote_port_add(lport->host, 0, &ids);
		}
		if (!rport) {
			FC_RPORT_DBG(rdata, "Failed to add the rport\n");
			fc_rport_logoff(rdata);
			kref_put(&rdata->kref, fc_rport_destroy);
			return;
		}
		...
		kref_put(&rdata->kref, fc_rport_destroy);
		break;
	...
	}
	kref_put(&rdata->kref, fc_rport_destroy);
}

The error path drops the local reference taken before unlocking rp_mutex,
and then returns directly instead of breaking out to the final kref_put() at
the end of fc_rport_work(), permanently leaking rdata.

[1] https://sashiko.dev/#/bug/linux-f352567a-e977-44cd-9965-6ccd520fb22b

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261108-h123-send-=
v1-1-b7672ff849f0@illinois.edu?part=3D1
