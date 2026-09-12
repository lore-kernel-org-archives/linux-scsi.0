Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 87E1F47A872
	for <linux-scsi@vger.kernel.org>; Sat, 12 Sep 2026 13:37:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789220263; cv=none; b=Ho1t7EUm/p3TxwINU2jbPrQ5v1RphpocvuUChgPdPG4aQZgZIyo1WqcAHexlCc256MgDgThv1CI9KEXFrlnnvyY5nEOk8hFYnVxw0l9B/pHmjbh4eYV+qOJofqrfxWOjzwnTJmd9/4kGZzWquWtAKj3K5KIY1OJAvjC00+bJIQE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789220263; c=relaxed/simple;
	bh=GgL17MTK7yAtM32Q9FIkNHOEXYfc4JsH+D9D8TU0Mbs=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=s7yQ+62xESj796D3RKaQU/H7b0uY5gk2sk/a++WbLN9jpWHRMkYkM6S9x5v3YmDp7FY12njyyzDIfd1+cQ2I44bLB8KvPk2MJBVvOWLBseXJxD2AIAHidyHMQOrkYDqUjVNf/Tj1sgv9ehsdA+j7bzxa+lafhx22zumh6rlezac=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=EARWJ+b0; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="EARWJ+b0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 826361F00893;
	Sat, 12 Sep 2026 13:37:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789220259;
	bh=4xcdBw9l7b+YHD1TTxtRyBzPFSITKyvh3L2C/zFtZHU=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=EARWJ+b0fICks4Q2GoeIMz1gE/oxcPf2oixrnLeHxJijJtDpgr1lZceKkvReCNhRr
	 ALcWCBB+JPc6+e7axrnrK+xNwP3S87Inudj6LDLeOfIDmUfpUppFSN5kGurdYaaS0g
	 O4h4MZJ6cMUnBKktf9n0gqVc2p8qBEYaur9gErnK+w4Y6TMscWbM8Kr1LIxBLakrmj
	 a8M9hYM3F+6LMSqLj3ohmh7HnkBmzx3elQXJtDECM9voT2Ho0R/wvRlpXRln0Tihvg
	 G0ynpPvALAS2r9UXTKE7YHorh7LFWdbM2vBmpz8zVNb+aTTd4zVCGXoYiD1+1v0j2B
	 BYZInP9jatc2w==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v3] scsi: ufs: core: Keep internal commands dispatchable
 during error handling
Reply-To: sashiko-reviews@lists.linux.dev
To: "Stanley Jhu" <stanleyjhu@google.com>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20260912131625.2301486-1-stanleyjhu@google.com>
References: <20260912131625.2301486-1-stanleyjhu@google.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Sat, 12 Sep 2026 13:37:39 +0000
Message-Id: <20260912133739.826361F00893@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [High] Concurrent use-after-free of `pseudo_sdev` and its `request_queue`=
 during driver removal.
--

commit 8a56a1b6be4e0430f65c83bfe4de68c1b55a6211
Author: Stanley Jhu <stanleyjhu@google.com>

scsi: ufs: core: Keep internal commands dispatchable during error handling

This commit unquiesces the pseudo SCSI device's request queue during error
handling so internal commands can be dispatched while logical units remain
quiesced. It balances this by re-quiescing the pseudo device queue in the
unprepare phase.

Link: https://lore.kernel.org/all/6f78c4bd-a70b-402d-abfd-599091b67674@acm.=
org/

> diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
> index 234e18b5078f2..eb86db492f225 100644
> --- a/drivers/ufs/core/ufshcd.c
> +++ b/drivers/ufs/core/ufshcd.c
> @@ -6841,11 +6841,17 @@ static void ufshcd_err_handling_prepare(struct uf=
s_hba *hba)
>  	}
>  	/* Wait for ongoing ufshcd_queuecommand() calls to finish. */
>  	blk_mq_quiesce_tagset(&hba->host->tag_set);
> +	/*
> +	 * Internal commands are submitted on the pseudo SCSI device. Let them
> +	 * through so that the error handler can recover the link.
> +	 */
> +	blk_mq_unquiesce_queue(hba->host->pseudo_sdev->request_queue);

[Severity: High]
Is it possible for hba->host->pseudo_sdev and its request_queue to be freed
before we access it here?

When the driver is unbound, ufshcd_remove() calls scsi_remove_host() before
the error handler workqueue is drained and destroyed in ufshcd_hba_exit():

drivers/ufs/core/ufshcd.c:ufshcd_remove() {
        ...
        if (hba->scsi_host_added)
                scsi_remove_host(hba->host);
        ...
}

Calling scsi_remove_host() removes all attached SCSI devices, including the
pseudo_sdev, which drops its final reference and frees it.

If ufshcd_err_handler() executes concurrently, it checks
ufshcd_err_handling_should_stop() and drops the host_lock:

drivers/ufs/core/ufshcd.c:ufshcd_err_handler() {
        ...
        if (ufshcd_err_handling_should_stop(hba)) {
                // ...
        }
        spin_unlock_irqrestore(&hba->host->host_lock, flags);

        ufshcd_err_handling_prepare(hba);
        ...
}

Since ufshcd_err_handling_should_stop() might return false before teardown
flags like is_powered are set, could this race lead to a use-after-free
when we dereference hba->host->pseudo_sdev->request_queue?

>  	cancel_work_sync(&hba->eeh_work);
>  }
> =20
>  static void ufshcd_err_handling_unprepare(struct ufs_hba *hba)
>  {
> +	blk_mq_quiesce_queue_nowait(hba->host->pseudo_sdev->request_queue);

[Severity: High]
Would the same use-after-free race occur here during the unprepare phase?

>  	blk_mq_unquiesce_tagset(&hba->host->tag_set);
>  	ufshcd_release(hba);
>  	if (ufshcd_is_clkscaling_supported(hba))

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260912131625.2301=
486-1-stanleyjhu@google.com?part=3D1
