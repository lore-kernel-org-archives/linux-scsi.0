Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F03BE2AE7A
	for <linux-scsi@vger.kernel.org>; Wed, 24 Jun 2026 05:13:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782278013; cv=none; b=W/pK1BkSVLoIo8l9eEs/e5FNCk+WVD01brr5zTVe0lN5HBDcv/64xYCm6vCeHS+2HN9kFef/h0QZU9luTNdOfzsF/TsdGtSiSlyEYAUiYvUCxI3MOyj2U8RbfiEDNdBbS6mFdxyO3U5ptov/ox6YXc2lVLWaNHD5zm+LjpDdxy4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782278013; c=relaxed/simple;
	bh=xMEi8ZfXn6KOHUgWI+CPVPEtD70J1MSlaxldYaMDBd8=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=JZhnwlBX2UlR2MbndjdRM4kJ7XKsekXYgUGxppeyKR46ANS4EBKZ2iXrTknV88oW16r618BbGPyCni987F9efPlzZIMWuUGAqynm0TfFd63S/DVKh1Ou06hpuKp8Y25613uYzIDXnazGgtSIsHk5W0a2RuOra7mK2C4PafLlg/0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=CaR789kx; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="CaR789kx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AEF7C1F000E9;
	Wed, 24 Jun 2026 05:13:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782278011;
	bh=W8uVC8L8BFoWWoZuK0Gc7w6r1F8yHiByH4o7a/QlDzk=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=CaR789kxW9lkFkCCwhwgRDp5J8liy6FR4uvINfdw3tt+j4bo0R8/3LqH1oj8QPFjs
	 sQWyl/ItF1bz+mLA/BBXmbbWgYHVhE97mfedNCOdy7KoHv+Fy3Psnl6EzfdRsEjpbj
	 aXFOCsn9PQuLf323/6FnHdT2EPmi+dDSsmmjev+3mjotzs743t+SBOxah29wBwT/py
	 I0xotNQVPqQELqNrVmKjuJZsFq5706/675dGwLUe0CAc7tGr3q1rxPoFW790HQ5Mxu
	 8taU5/HXgQ96cBJrBStCAM17n3jaJ/E3b2/VB0LkSwOob1Zzdaz+DF896UCjACUvfi
	 +F3Mic2xiXjMA==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v5 10/13] scsi: fnic: Abort timed-out NVMe LS requests
Reply-To: sashiko-reviews@lists.linux.dev
To: "Karan Tilak Kumar" <kartilak@cisco.com>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20260624044334.3079-11-kartilak@cisco.com>
References: <20260624044334.3079-1-kartilak@cisco.com>
 <20260624044334.3079-11-kartilak@cisco.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 24 Jun 2026 05:13:31 +0000
Message-Id: <20260624051331.AEF7C1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 2 potential issue(=
s) to consider:

New issues:
- [Critical] Data Race / List Corruption and Use-After-Free due to incorrec=
tly dropping fnic_lock before sending ABTS.

Pre-existing issues:
- [High] Use-After-Free in the timer callback due to missing timer_delete_s=
ync() before freeing memory.
--

commit da372c5b4e5660f32542c6cb182b777f4f2e3531
Author: Karan Tilak Kumar <kartilak@cisco.com>

scsi: fnic: Abort timed-out NVMe LS requests

Add an FDLS helper that sends ABTS frames for outstanding NVMe LS
requests. Use the active LS request OXID when building the ABTS frame,
send it through the FCoE transmit path, and call it from LS timeout
and abort handling.

> diff --git a/drivers/scsi/fnic/fnic_nvme.c b/drivers/scsi/fnic/fnic_nvme.c
> index 16e2f0add5ce6..c4de6606c0b2f 100644
> --- a/drivers/scsi/fnic/fnic_nvme.c
> +++ b/drivers/scsi/fnic/fnic_nvme.c

[ ... ]

> @@ -1248,6 +1252,23 @@ void nvfnic_ls_rsp_recv(struct fnic_iport_s *iport,
>  	spin_lock_irqsave(&fnic->fnic_lock, fnic->lock_flags);
>  }

[Severity: High]
This isn't a bug introduced by this patch, but does the timer cancellation =
in
nvfnic_ls_rsp_recv() have a use-after-free race with the timer callback?

In nvfnic_ls_rsp_recv(), the code calls the non-synchronous timer_delete():

    timer_delete(&nvfnic_ls_req->ls_req_timer);
    ...
    spin_unlock_irqrestore(&fnic->fnic_lock, fnic->lock_flags);
    lsreq->done(lsreq, status);

Because timer_delete() doesn't wait for the timer callback to finish on oth=
er
CPUs, if nvfnic_ls_req_timeout() is concurrently executing and spinning to
acquire fnic_lock, couldn't the lock be dropped here, allowing lsreq->done()
to immediately free the memory, while the timer callback proceeds to access=
 it?

[ ... ]

> @@ -1290,6 +1310,19 @@ void nvfnic_ls_req_timeout(struct timer_list *t)
>  		FNIC_NVME_DBG(KERN_ERR, fnic,
>  			      "tport: 0x%x lsreq: 0x%x sending abort\n",
>  			      tport->fcid, nvfnic_ls_req->oxid);
> +		nvfnic_ls_req->state =3D FNIC_LS_REQ_CMD_ABTS_PENDING;
> +		spin_unlock_irqrestore(&fnic->fnic_lock, fnic->lock_flags);
> +
> +		if (fdls_send_ls_req_abts(iport, tport, nvfnic_ls_req->oxid) =3D=3D 0)=
 {

[Severity: Critical]
Does dropping fnic_lock here before calling fdls_send_ls_req_abts() expose =
the
driver to list corruption?

fdls_send_ls_req_abts() calls fnic_send_fcoe_frame(), which eventually calls
fdls_send_fcoe_frame(). That function appears to perform a lockless=20
list_add_tail(&frame_elem->links, &fnic->tx_queue), relying on the caller
to hold fnic_lock.

Additionally, does dropping the lock here expose the tport pointer to
concurrent deletion, potentially causing a use-after-free?

> +			timeout =3D FNIC_LS_REQ_TMO_MSECS(ls_req->timeout);
> +			mod_timer(&nvfnic_ls_req->ls_req_timer,
> +				  round_jiffies(jiffies + msecs_to_jiffies(timeout)));
> +			return;
> +		}

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260624044334.3079=
-1-kartilak@cisco.com?part=3D10
