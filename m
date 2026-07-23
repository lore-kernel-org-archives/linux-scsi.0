Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD6BF524F
	for <linux-scsi@vger.kernel.org>; Thu, 23 Jul 2026 01:00:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784768451; cv=none; b=TBNaFi+fvzaTicCQ2eVEk/WDeIpSBi0tXHXWHFyTM3WcRDwKDikHdQHA4KcxKIiWfYMyGBqRmYncDt8/faefh2CLcFpikPumaTaKg1VpiuN6T/eLWpojdyNsE6uIwYuqSq8ex5aLYJd4vXHFnJlpxRVVy8zRwJPr/lb9kVNPwkA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784768451; c=relaxed/simple;
	bh=mBVSiZb+A3nA8Inr93bYsJjKtVsnd0iGSdo8d8EUPho=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=FPUZyQ79nDq3vJ647CwZZ1ZxLhKU0SNVcRBc11ax3I7HrL/fcXWh40HmCsYTbYF5RXcgp+fIKP1A5vR2OPxR6zG4scXTHrngXU920TrzYggfH4jmncsVgQqU/3985CmgNVdnTStjr36RMloMNPDZ4kFIDj85Eyg5EKouEdLF/eM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Y3yhF1xN; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Y3yhF1xN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2A4451F000E9;
	Thu, 23 Jul 2026 01:00:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784768450;
	bh=ptRcuUGX2K9DAPelb/OsdQjf2F4eu+0WSsQRipE7ftk=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=Y3yhF1xNhpgSKtp5IoQsC/6j/Eba8hkqi5xXZZJsJSj9hWZQLv6pvzN4Iq3NgazmW
	 e3+7KQBZVjYS1waLLSPWoYQpLl1wr2/w8d+gckTtMJ8AII6mZx5zScFnaniYCbvfZh
	 9oBfLx/O7szQIOljneq1kLmLJE4YIcaz6GrZFe3a7jj+dqbl43cTXfdcKkVnD4+bz2
	 qB2vzyEb0Jld/0Jqk1myO0819H9a6n20W0v+NGDl/hio1Z93R20AQdzWriOMF2adzr
	 rY563QSETVCAGuwgWEx7m93UzMCcZZr2WfkNWvbsWjW+i5WO/rHdMJe6R534268ezK
	 R7gGfBmzXKtGw==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v2 29/33] ibmvfc: implement nvme-fc LS submission
 transport callback
Reply-To: sashiko-reviews@lists.linux.dev
To: "Tyrel Datwyler" <tyreld@linux.ibm.com>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20260723000149.969416-30-tyreld@linux.ibm.com>
References: <20260723000149.969416-1-tyreld@linux.ibm.com>
 <20260723000149.969416-30-tyreld@linux.ibm.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 23 Jul 2026 01:00:49 +0000
Message-Id: <20260723010050.2A4451F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:

Pre-existing issues:
- [High] timer_delete is used instead of timer_delete_sync during event pur=
ging, leading to a Use-After-Free in the timer callback during driver unloa=
d.
--

--- Patch [29]: [PATCH v2 29/33] ibmvfc: implement nvme-fc LS submission tr=
ansport callback ---
commit 307222be453ed384bc1c2ec92213263c1df79a6a
Author: Tyrel Datwyler <tyreld@linux.ibm.com>

ibmvfc: implement nvme-fc LS submission transport callback
   =20
NVMe FC Link Service commands are required to use the ibmvfc_passthru MAD.
This patch initializes a passthru mad for the target port and sends FC4_LS
commands via the primary CRQ.

> diff --git a/drivers/scsi/ibmvscsi/ibmvfc-nvme.c b/drivers/scsi/ibmvscsi/=
ibmvfc-nvme.c
> index ecf9f4c0549c2..cf72f0682297b 100644
> --- a/drivers/scsi/ibmvscsi/ibmvfc-nvme.c
> +++ b/drivers/scsi/ibmvscsi/ibmvfc-nvme.c
[ ... ]
> @@ -62,10 +62,99 @@ static void ibmvfc_nvme_delete_queue(struct nvme_fc_l=
ocal_port *lport, unsigned
[ ... ]
>  static int ibmvfc_nvme_ls_req(struct nvme_fc_local_port *lport,
>  			      struct nvme_fc_remote_port *rport,
>  			      struct nvmefc_ls_req *ls_req)
>  {
> +	struct ibmvfc_host *vhost =3D lport->private;
> +	struct ibmvfc_target *tgt =3D rport->private;
> +	struct ibmvfc_passthru_mad *mad;
> +	struct ibmvfc_event *evt;
[ ... ]
> +	ibmvfc_dbg(vhost, "nvme_ls_req\n");
> +	if (ibmvfc_send_event(evt, vhost, IBMVFC_FC4_LS_PLUS_CANCEL_TIMEOUT)) {

[Severity: High]
This isn't a bug introduced by this patch, but calling ibmvfc_send_event() =
sets
up a timer for the event.

During driver removal, the driver calls ibmvfc_purge_requests(), which fails
pending commands and cancels their timers using the non-synchronous
timer_delete():

drivers/scsi/ibmvscsi/ibmvfc-core.c:ibmvfc_fail_request() {
	...
	timer_delete(&evt->timer);
	...
}

If a timer is already executing concurrently on another CPU, timer_delete()
returns immediately without waiting for it to finish. The driver unload seq=
uence
then proceeds to call ibmvfc_free_mem(), which completely frees the event p=
ool.

Meanwhile, the still-executing ibmvfc_timeout callback dereferences the fre=
ed
evt structure:

drivers/scsi/ibmvscsi/ibmvfc-core.c:ibmvfc_timeout() {
	struct ibmvfc_event *evt =3D container_of(timer, struct ibmvfc_event, time=
r);
	struct ibmvfc_host *vhost =3D evt->vhost;
	...
}

Can this lead to a use-after-free during driver unload if there are pending
requests that time out concurrently? Should the teardown path use
timer_delete_sync() to wait for executing timers to finish before freeing t=
he
event pool?

> +		kref_put(&tgt->kref, ibmvfc_release_tgt);
> +		return -ENXIO;
> +	}
> +
>  	return 0;
>  }

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260723000149.9694=
16-1-tyreld@linux.ibm.com?part=3D29
