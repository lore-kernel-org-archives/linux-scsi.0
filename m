Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9CCE4346AC3
	for <linux-scsi@vger.kernel.org>; Mon, 27 Jul 2026 07:48:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785138516; cv=none; b=Rit6Lq1WbBRIWtgr2ORqBRZiicrnWAu357u238NtnWWZFLxs7WigfaoyNggio8WoR7zVpeFjnDB4IPMIuYSa051RDq0Two0tW9lcvH9xQiYCPb2NWpcQqOuYrg3Yd6f705wJoXWt/phP68YnNB5nxchBhIBiHAWZr3ftvRuNdAE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785138516; c=relaxed/simple;
	bh=TtQD77Xaj+2CML2a/P2W6gtupKxifzSuZIeUbgh65Mo=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=Qr6SKgbpWUVAVCohRTkZjqQv2mC9Mo982fZBMAIRz2mQStdWK5vEB4yaoJcGD7r/0YFK+UnUzXpBGF1m/6tbWu+VWM+BTfEl+cOB64kYHZ5qL8P2aT4cwq9JS1vwgFAJmcztrZ7govKcrQFAJwuDCDGS7JVDvJ4IYrLwW241Srw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=IWvoWhms; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="IWvoWhms"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5F29C1F000E9;
	Mon, 27 Jul 2026 07:48:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785138515;
	bh=ec7B69RHcauGy1bStYYmqiZoctwq7GXt49T4lN4OhU0=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=IWvoWhms1/UqmNM9pdFI7mdCUJTgUHtCpUGc0EvvxQuTB31m3InG3Ooak5uqFnCHj
	 ++OkjY/7tGpdDd8BKlDWH5Dy5eP/QoNHEJEhmGcivcA9kxVugTwaEPrxFY7fCBvB2A
	 q3RLPDRMb/iqYcs5BCESXeTK4ehcK4l/QwSO7IDmxrm/RSz5sPPtJffAhGtHe4IeZf
	 ZMkh0PtOFOpR4wysdwGeKwplzNbA1vwkIVR5b4kNg7OTFoOMVQB5THLvlx/fRIbwMt
	 kcxEcJ3+igc0sJIvoPn4+mL1FZC+9GdJB+M0/s+cTTAklOFhT7lrupsfS8pXJEqSeR
	 uoZlWIcdmWWfQ==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH] scsi: snic: Fix scsi host leak on workqueue allocation
 failure
Reply-To: sashiko-reviews@lists.linux.dev
To: "Chen Changcheng" <chenchangcheng@kylinos.cn>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20260727073438.209673-1-chenchangcheng@kylinos.cn>
References: <20260727073438.209673-1-chenchangcheng@kylinos.cn>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Mon, 27 Jul 2026 07:48:34 +0000
Message-Id: <20260727074835.5F29C1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 3 potential issue(=
s) to consider:

Pre-existing issues:
- [High] Hardware resources are torn down before removing the SCSI host on =
the `snic_probe()` error path, leading to race condition and use-after-free.
- [High] Missing `list_del(&snic->list)` on the `snic_probe()` error path l=
eaves a dangling pointer in the global `snic_glob->snic_list`, causing memo=
ry corruption.
- [High] Missing `cancel_work_sync(&snic->link_work)` on the `snic_probe()`=
 error path allows asynchronously queued work to dereference a freed `snic`=
 object.
--

--- Patch [1]: [PATCH] scsi: snic: Fix scsi host leak on workqueue allocati=
on failure ---
commit 862e6c3dc0ab1bdd6e8457040994057a804388df
Author: Chen Changcheng <chenchangcheng@kylinos.cn>

scsi: snic: Fix scsi host leak on workqueue allocation failure

This commit fixes a memory leak where a failed workqueue allocation in
snic_add_host() leaves the Scsi_Host registered in sysfs as a zombie
device. It undoes the successful scsi_add_host() by calling
scsi_remove_host() on the error path before returning.

> --- a/drivers/scsi/snic/snic_main.c
> +++ b/drivers/scsi/snic/snic_main.c
> @@ -305,6 +305,7 @@ snic_add_host(struct Scsi_Host *shost, struct pci_dev=
 *pdev)
>  	if (!shost->work_q) {
>  		SNIC_HOST_ERR(shost, "Failed to Create ScsiHost wq.\n");
> =20
> +		scsi_remove_host(shost);
>  		ret =3D -ENOMEM;
>  	}

[Severity: High]
This is a pre-existing issue, but does this error path in snic_probe()
create a race condition?

If snic_disc_start() fails, the driver jumps to err_get_conf:

drivers/scsi/snic/snic_main.c:snic_probe() {
    ...
err_get_conf:
        snic_free_all_untagged_reqs(snic);
        for (i =3D 0; i < snic->intr_count; i++)
                svnic_intr_mask(&snic->intr[i]);
        snic_free_intr(snic);
err_req_intr:
        svnic_dev_disable(snic->vdev);
    ...
        snic_del_host(snic->shost);
}

The host is already fully registered via snic_add_host() and the state
is SNIC_ONLINE. The hardware and interrupts are torn down, but
snic_del_host() is delayed until the end. Could a concurrent sysfs scan
or SCSI error handler queue commands to the disabled hardware during
this window?

[Severity: High]
This isn't a bug introduced by this patch, but does the err_free_snic
error path in snic_probe() leave a dangling pointer?

The snic structure is added to the global list during probe:

drivers/scsi/snic/snic_main.c:snic_probe() {
    ...
        spin_lock_irqsave(&snic_glob->snic_list_lock, flags);
        list_add_tail(&snic->list, &snic_glob->snic_list);
        spin_unlock_irqrestore(&snic_glob->snic_list_lock, flags);
    ...
}

If a subsequent step like snic_add_host() fails, the snic structure is
freed via scsi_host_put():

drivers/scsi/snic/snic_main.c:snic_probe() {
    ...
err_free_snic:
        snic_stats_debugfs_remove(snic);
        scsi_host_put(shost);
}

Will the lack of list_del(&snic->list) before freeing cause memory
corruption on subsequent device probes when list_add_tail() accesses
the freed structure?

[Severity: High]
This is a pre-existing issue, but can the snic_probe() error path
result in a use-after-free from asynchronously queued work?

Interrupts are requested and unmasked before configuring IO:

drivers/scsi/snic/snic_main.c:snic_probe() {
    ...
        for (i =3D 0; i < snic->intr_count; i++)
                svnic_intr_unmask(&snic->intr[i]);
    ...
}

A link event could trigger snic_handle_link_event(), which queues
snic->link_work. If a subsequent probe step fails, the err_free_snic
path masks interrupts and frees the snic structure:

drivers/scsi/snic/snic_main.c:snic_probe() {
    ...
err_free_snic:
        snic_stats_debugfs_remove(snic);
        scsi_host_put(shost);
}

Because the error path does not call cancel_work_sync(&snic->link_work)
or flush the workqueue, could the pending work item execute later and
dereference the freed snic object?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260727073438.2096=
73-1-chenchangcheng@kylinos.cn?part=3D1
