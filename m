Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0623B33374F
	for <linux-scsi@vger.kernel.org>; Wed, 22 Jul 2026 06:48:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784702924; cv=none; b=YQGWbiEYne2L+nNLc523WbxljAPuvFyJ7z5FX+nXjF9TCnPyHezyfrIiew6IHgQq9f/M4xcjrZnkgtMYlWrZG5GfFvWvWuVxJ/YL3HoCClPvEu1Q73lqDULBCoLDHP3KrmftfVwVFDkSGaAZg1JvHF4D0OmopWds+kuIXxBz5Hs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784702924; c=relaxed/simple;
	bh=cpTp24N6VA15tbkDgTWq1ot6Xst+jIoWs14uF5zr3R8=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=f1jwGfLT92dlZ5zJ+L/H9ojuXl72Wa/y+o0gLgGcSiOyB0R6ydoTVqJPgnj7Uh0l7JM/p2BFEvL+Zk8ComToPacwzS0J0ieW2Zb4ODDxBnW4JsalxGwMUdMJ5q78Whyk+AW4i15+s/Tn9lCgGDq+nF9R84x96qhfgk5G5Dxy2UI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=aGDa4Ead; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="aGDa4Ead"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B67F41F000E9;
	Wed, 22 Jul 2026 06:48:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784702922;
	bh=NkxyrTbnjg8afQ/38ZUMyKYkJtoTzQoxURo5nG5GKQg=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=aGDa4Eadl+7GpATI57gq84mW0zgNw+Z+tFuCFB+8WcERIdbbISClWhgdb8QMXJ559
	 AkKVc6mZuJGMRn9cff+dqyKVSUbF+RdC5Sc74vNf8m1Qa5MJ2Fqe1OFnPl9cRC3JrH
	 7Mg68uU3nyWHKoy8JZiP2Q8tiUZBUIeW2bikY4gkHMMXojNiAvgjfzzRdHu0H+zgBB
	 gyAASgVXymzLyPLu+w1goP54Zjmw2+5uW1SQ7rDcl7/Q5/aP3S4SFSjU2OPo/LZmxw
	 qDZWY5ClDej+TNCr331IM6mvZl1pwnRvpQC3jyzbBKC8mAcPS31/ProyrOkc8lCBIe
	 fiR0CDgdzwQKA==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH] scsi: target: Clear cmd_cnt when initial counter
 enrollment fails
Reply-To: sashiko-reviews@lists.linux.dev
To: "Leon Romanovsky" <leon@kernel.org>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20260722-reference-count-underflow-in-target-v1-1-63ab664f12fd@nvidia.com>
References: <20260722-reference-count-underflow-in-target-v1-1-63ab664f12fd@nvidia.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 22 Jul 2026 06:48:42 +0000
Message-Id: <20260722064842.B67F41F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 2 potential issue(=
s) to consider:

Pre-existing issues:
- [Critical] iSCSI target ignores target_get_sess_cmd() failure, causing re=
ference count underflow and use-after-free
- [High] qla2xxx target driver leaks cmd_cnt->refcnt references on every SR=
R processing event
--

--- Patch [1]: [PATCH] scsi: target: Clear cmd_cnt when initial counter enr=
ollment fails ---
commit 91357eb9be8775486a1fba8ba21b9b933e790d5b
Author: Leon Romanovsky <leon@kernel.org>

scsi: target: Clear cmd_cnt when initial counter enrollment fails

When target_get_sess_cmd() fails during session shutdown, the command keeps
the se_cmd->cmd_cnt pointer without owning a reference. Final release throu=
gh
target_release_cmd_kref() then issues an unmatched percpu_ref_put(). This
commit clears se_cmd->cmd_cnt whenever the initial target_get_sess_cmd()
fails so release performs exactly one matching put per acquired reference.

> diff --git a/drivers/target/target_core_transport.c b/drivers/target/targ=
et_core_transport.c
> index fad03a15c969e..dcfe945949167 100644
> --- a/drivers/target/target_core_transport.c
> +++ b/drivers/target/target_core_transport.c

[ ... ]

> @@ -1763,7 +1764,11 @@ int target_init_cmd(struct se_cmd *se_cmd, struct =
se_session *se_sess,
>  	 * necessary for fabrics using TARGET_SCF_ACK_KREF that expect a second
>  	 * kref_put() to happen during fabric packet acknowledgement.
>  	 */
> -	return target_get_sess_cmd(se_cmd, flags & TARGET_SCF_ACK_KREF);
> +	ret =3D target_get_sess_cmd(se_cmd, flags & TARGET_SCF_ACK_KREF);
> +	if (ret)
> +		se_cmd->cmd_cnt =3D NULL;
> +
> +	return ret;
>  }

[Severity: Critical]
This is a pre-existing issue, but I noticed the iSCSI target driver manually
calls target_get_sess_cmd() and ignores its return value.

If target_get_sess_cmd() fails (e.g. during session shutdown), it drops the
cmd_kref back down to 1. Since iscsit_setup_scsi_cmd() ignores this failure:

drivers/target/iscsi/iscsi_target.c:iscsit_setup_scsi_cmd() {
    ...
    target_get_sess_cmd(&cmd->se_cmd, true);
    ...
}

The same happens in the TMR path:

drivers/target/iscsi/iscsi_target.c:iscsit_handle_task_mgt_cmd() {
    ...
    target_get_sess_cmd(&cmd->se_cmd, true);
    ...
}

When the command completes, iscsit_send_status() calls target_put_sess_cmd(=
),
which drops the cmd_kref to 0 and prematurely frees the command. This trigg=
ers
an unmatched percpu_ref_put(&cmd_cnt->refcnt) and underflows the session
reference. Later, iscsit_free_cmd() causes a second target_put_sess_cmd() on
the freed command, resulting in a use-after-free.

Can this be triggered by a remote unprivileged initiator sending commands
concurrently with session teardown?


[Severity: High]
This isn't a bug introduced by this patch, but looking at how the qla2xxx
driver uses target_get_sess_cmd(), could there be a reference leak during S=
RR
processing?

The qla2xxx driver uses target_get_sess_cmd() to acquire an extra reference
for Sequence Retransmission Request (SRR) processing:

drivers/scsi/qla2xxx/tcm_qla2xxx.c:tcm_qla2xxx_get_cmd_ref() {
    ...
    return target_get_sess_cmd(&cmd->se_cmd, true);
}

This increments both cmd_kref and cmd_cnt->refcnt:

drivers/target/target_core_transport.c:target_get_sess_cmd() {
    ...
    if (se_cmd->cmd_cnt) {
        if (!percpu_ref_tryget_live(&se_cmd->cmd_cnt->refcnt))
    ...
}

However, when releasing the extra reference, the driver only drops cmd_kref:

drivers/scsi/qla2xxx/tcm_qla2xxx.c:tcm_qla2xxx_put_cmd_ref() {
    ...
    target_put_sess_cmd(&cmd->se_cmd);
}

The extra cmd_cnt->refcnt increment is never balanced because
target_release_cmd_kref() is only called once at the end of the command
lifecycle.

Does this permanently leak cmd_cnt->refcnt references and cause
target_wait_for_sess_cmds() to hang infinitely during session teardown?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260722-reference-=
count-underflow-in-target-v1-1-63ab664f12fd@nvidia.com?part=3D1
