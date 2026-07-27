Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C25E8635D
	for <linux-scsi@vger.kernel.org>; Mon, 27 Jul 2026 06:05:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785132325; cv=none; b=pyFNo1XuEKKjs3vyEcbjq6s84v/38XcQPdnnU0C5ipAs1X7JiKv1Zxzmi1AU1BuiXbzMOikvvlbBlsvawtegJry5fl1fljKX0ZwC2sP5mDAbgScL92VGSsnw874Cj4BFw3USZVoIdvEj0+hv9hqKafRJD4VKkIParRF1IvwNOkw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785132325; c=relaxed/simple;
	bh=6TMhjLp0pArAKb5TQF0Kc817l12SBr5Mpj9P4RwTu7o=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=ZCfqc3CkfhzYJBmTfdGmgLOUTqjHdtVfns/AfF9NlpWjVizjeq1bYKDXQXgrY6ZqTg6MYblGndEKx7B+6TheH4ktQjTVVXVnIJYpVhbWr+Yujw52VgYySx4phPD5rvJYa6L329oRL4Eu6qW2IMGT1EnQ7O0aLClrmnEPoVWjq+I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Cb4SijOa; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Cb4SijOa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E9E5B1F000E9;
	Mon, 27 Jul 2026 06:05:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785132324;
	bh=8F8Cv8VJnKWBx7SEBOPk3oIda3Vsti+v6y+ujLCfQtk=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=Cb4SijOa1cW+d0WCchTXaA2cAQj+/8arhER1S2Thg+d5ph30fKUMddaIb+R3dr71U
	 vs0UfKRac+faHTB/uzgLMSiktaBoO2My9v40SvOGW4+onEglyuiB3BT/F0/e9QdG9I
	 ayOgOexTjz+ddUPYBGUaILfDBHhfuTCdSq7esk+e0f28zghEtrxnMYq7BzHllYkq9B
	 DeOC5bshabBgd1qMDQ2adr+snA7DoTmikzi5Ot/z0HJ/4ciAfawDdxtE5Utb7fXRdx
	 a+2zw8VVM6elKq5qJZ6ZK0CfN52hQ+647JnlVlbPOP/bQzLPInGyMObzdb1g/0j9jN
	 dlz/V/BaCcOJw==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v2] scsi: core: pair EH runtime PM get and put
Reply-To: sashiko-reviews@lists.linux.dev
To: "Hongjie Fang" <hongjiefang@asrmicro.com>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20260727055615.2287217-1-hongjiefang@asrmicro.com>
References: <20260727055615.2287217-1-hongjiefang@asrmicro.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Mon, 27 Jul 2026 06:05:23 +0000
Message-Id: <20260727060523.E9E5B1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 2 potential issue(=
s) to consider:

Pre-existing issues:
- [High] Lockless modification of the `eh_noresume` bitfield causes a read-=
modify-write data race that can silently corrupt adjacent critical bitfield=
s.
- [High] If `scsi_autopm_get_host()` persistently fails, the SCSI EH kthrea=
d enters a 100% CPU uninterruptible infinite loop.
--

--- Patch [1]: [PATCH v2] scsi: core: pair EH runtime PM get and put ---
commit 78d8d003e96d61ac7f551e9faf3bb914d7c82cad
Author: Hongjie Fang <hongjiefang@asrmicro.com>

scsi: core: pair EH runtime PM get and put

This commit fixes a race condition where a power-management error path alte=
rs
shost->eh_noresume while the SCSI EH thread is running. It ensures that
runtime PM get and put operations in the error handler are correctly paired
by snapshotting shost->eh_noresume per iteration.

> diff --git a/drivers/scsi/scsi_error.c b/drivers/scsi/scsi_error.c
> index 984ddcb4786d6..d4c53e6657625 100644
> --- a/drivers/scsi/scsi_error.c
> +++ b/drivers/scsi/scsi_error.c
> @@ -2213,7 +2214,8 @@ int scsi_error_handler(void *data)
>  		 * what we need to do to get it up and online again (if we can).
>  		 * If we fail, we end up taking the thing offline.
>  		 */
> -		if (!shost->eh_noresume && scsi_autopm_get_host(shost) !=3D 0) {
> +		eh_noresume =3D shost->eh_noresume;

[Severity: High]
This isn't a bug introduced by this patch, but does the lockless modificati=
on
of the eh_noresume bitfield elsewhere cause a read-modify-write data race
that can silently corrupt adjacent bitfields?

For instance, eh_noresume is defined as a bitfield sharing a machine word
with other critical flags:

include/scsi/scsi_host.h:struct Scsi_Host {
    ...
    unsigned host_self_blocked:1;
    unsigned reverse_ordering:1;
    unsigned tmf_in_progress:1;
    unsigned async_scan:1;
    unsigned eh_noresume:1;
    ...
}

When ufshcd_set_dev_pwr_mode() locklessly modifies hba->host->eh_noresume =
=3D 1
after dropping host_lock, could concurrent modifications to other bitfields
in the same word (like host_self_blocked during scsi_block_requests()) cause
lost state updates due to non-atomic read-modify-write operations?

> +		if (!eh_noresume && scsi_autopm_get_host(shost) !=3D 0) {
>  			SCSI_LOG_ERROR_RECOVERY(1,
>  				shost_printk(KERN_ERR, shost,
>  					     "scsi_eh_%d: unable to autoresume\n",
>  					     shost->host_no));
>  			continue;

[Severity: High]
This is a pre-existing issue, but if scsi_autopm_get_host() persistently
fails, does this continue statement cause the SCSI EH kthread to enter an
uninterruptible infinite loop?

If scsi_autopm_get_host() fails (e.g. -ENODEV due to dead hardware) and the
code skips scsi_unjam_host() by executing continue, shost->host_failed
remains non-zero. The loop restarts and checks its wait condition:

drivers/scsi/scsi_error.c:scsi_error_handler() {
    ...
    if ((shost->host_failed =3D=3D 0 && shost->host_eh_scheduled =3D=3D 0) =
||
        shost->host_failed !=3D atomic_read(&shost->host_busy)) {
        ...
        schedule();
        continue;
    }
    ...
}

Because host_failed is not 0 and host_failed =3D=3D host_busy, this conditi=
on
evaluates to false, skipping schedule(). Will the thread then immediately
retry scsi_autopm_get_host(), fail again, and spin a CPU core infinitely
without yielding?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260727055615.2287=
217-1-hongjiefang@asrmicro.com?part=3D1
