Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F3F4F17BEBF
	for <linux-scsi@vger.kernel.org>; Tue, 23 Jun 2026 01:52:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782179521; cv=none; b=QPZ0979KNA5cSEYO3np7vtl9zRPdpVLp72M77zpymyjAS3ht8f9y9sFegEfodNVR/6Q90OhaNNWfc4iRP3tBB1b9vdp/iw+IT3io7EtZ7saoEiaGzc/UXAkyiB3DBS6077tuiPRZ8dMI33TAq6Z7gl93CHV0za4mO5oARh+3ie8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782179521; c=relaxed/simple;
	bh=0HQeQB4G43Vbm1lrE2/x4bxu9QH1soZvBELHLU0Ies0=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=a/dwG4qMh35myhHXPMjBGJz6/WGg0UKVmf52JmjZhmjNMiwyERNcyHIpYRVFantN3V2MJZH6Cl/r5DsN5oNVnJVvzad8zDgP1Avm6te/XRWQ9c0e3JLCGsZUjuU0z3iQYIlYdzahunelHOPfjcQ8zyq91nY0k02gHOhL1fJIhcU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=g26Ww1Ud; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="g26Ww1Ud"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7A9701F000E9;
	Tue, 23 Jun 2026 01:52:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782179520;
	bh=fBbZlQ3Kv/wHHoQ8YQsSipd7BW70Bo4IfN48hitG5IU=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=g26Ww1Ud9HcpSrbUOZFhoKQN98pDVMvVu3E354+UvDy2t7Q0RRYZ3RMXzv1P4gA7t
	 b7JeX1nYk8imOGmp135VHEAYudH1hmcXOP8JW2g2PV+DUQzE7hJkZAMSzBIHKKKVO/
	 tDVjfKWkXlw+S+WxvidMUe2rFKcmQlXYtDxGCPV8bfzL18dtH/9Z8LvTR5MYV1OMvt
	 Un5GHN1b8K5cCab8ycYDSsPUmvYrqXyxe+Pla5GZ93SmBBtASmDLtNWowt94GQSzRJ
	 VFY2VFAgRqomnMDFr4ZjxhhtiVJsE7RyTgQ30z5E/P/ql28Eo5yLY64uCGUmyS9cxl
	 0nPlbC2ptkCXw==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH 14/29] ibmvfc: add NVMe/FC Process Login support
Reply-To: sashiko-reviews@lists.linux.dev
To: "Tyrel Datwyler" <tyreld@linux.ibm.com>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20260623013035.3436640-15-tyreld@linux.ibm.com>
References: <20260623013035.3436640-1-tyreld@linux.ibm.com>
 <20260623013035.3436640-15-tyreld@linux.ibm.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 23 Jun 2026 01:52:00 +0000
Message-Id: <20260623015200.7A9701F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:

Pre-existing issues:
- [High] Self-deadlock on `host_lock` if a management CRQ event fails to se=
nd.
--

commit ee31c1669f64561bd4a4e52947529fea4cf6545e
Author: Tyrel Datwyler <tyreld@linux.ibm.com>

ibmvfc: add NVMe/FC Process Login support

This commit extends the PRLI handling code to support NVMe/FC targets.
It adds NVMe-specific service parameters and sets the remote-port roles
upon successful process login. The existing SCSI PRLI flow is preserved.

> diff --git a/drivers/scsi/ibmvscsi/ibmvfc-core.c b/drivers/scsi/ibmvscsi/=
ibmvfc-core.c
> index 2c54d0b9add49..b45cd0183fb51 100644
> --- a/drivers/scsi/ibmvscsi/ibmvfc-core.c
> +++ b/drivers/scsi/ibmvscsi/ibmvfc-core.c
[ ... ]
> @@ -4172,25 +4190,30 @@ static void ibmvfc_tgt_send_prli(struct ibmvfc_ta=
rget *tgt)
[ ... ]
>  	ibmvfc_set_tgt_action(tgt, IBMVFC_TGT_ACTION_INIT_WAIT);
>  	if (ibmvfc_send_event(evt, vhost, default_timeout)) {

[Severity: High]
This is a pre-existing issue, but can this call path trigger a deadlock?

When ibmvfc_tgt_send_prli() is called by the target's job step from
ibmvfc_do_work(), the host_lock is already held.

If ibmvfc_send_event() fails (e.g. due to a hypercall failure), it
synchronously invokes the completion callback evt->done(evt).

Because the event was initialized with IBMVFC_MAD_FORMAT via
ibmvfc_init_event(), evt->done is set to ibmvfc_locked_done(), which
attempts to acquire the host_lock again:

    spin_lock_irqsave(evt->vhost->host->host_lock, flags);

Would this cause a hard deadlock on the CPU if the underlying hardware
encounters an error and fails to send the process login?

>  		vhost->discovery_threads--;
>  		ibmvfc_set_tgt_action(tgt, IBMVFC_TGT_ACTION_NONE);
>  		kref_put(&tgt->kref, ibmvfc_release_tgt);
>  	} else
> -		tgt_dbg(tgt, "Sent process login\n");
> +		tgt_dbg(tgt, "%s Sent process login\n", proto_type[tgt->protocol]);
>  }

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260623013035.3436=
640-1-tyreld@linux.ibm.com?part=3D14
