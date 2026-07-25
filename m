Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6BFDA246782
	for <linux-scsi@vger.kernel.org>; Sat, 25 Jul 2026 17:20:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785000035; cv=none; b=tbLxlDr/m+wS5+vLo2SM+6bPvDv0aMRxqLVYFbZjGQVf0Lul3E5fGhDzBxdvvElujedrnGs6TAfasrxtgG/wpsKP2+UpsdAU6887Lt1JgFYJHMB2Wm35x6kyAASYOfuP9D8DGEypMZuYf+cGsyZKmeGpca/Gfi2QuT/PmMOGnpE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785000035; c=relaxed/simple;
	bh=Ml3yGGWkzwYusPxn3m4KVbdrjpatBfh9GB5a9k5ETq0=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=NVzS9BMkwkpQIeflfQJb0miop3dL9Re/LwrUXUk6uAh1WPWXrjOEHiGZu86EAp11liWCq2/0g6VWWR3eD4nvB/8QW0xv104MSG0CLJkaih5DH9SbVk6B9kzV2kTee6QvjW3EgOashOHVNGOaGs3xRHfrdGuNzWw0s0WVlcB1kx8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=OMWrt1nj; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="OMWrt1nj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 073071F000E9;
	Sat, 25 Jul 2026 17:20:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785000034;
	bh=YuTIFl/qQhcc/x6YUPtv8QXIeVbB5RaMP7HTs6TId4I=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=OMWrt1njTT7wNFvyhQH6X1Mnvu5O9WXCDE0rlo7okATobO6N50Qs1dtuz6FZ8bY/2
	 w5S3GhAx2gO5uygOcicW5ol4HLcYOrFWEoZChO8memqaw69AHEcqsgEUIyt3Twj7sq
	 Zxx1URrc0r/h/y9iqsjKcMEj30sJQ4HETz1yrRbqZ2OhIljFD3UpRA2CQey2zhrVXi
	 Z043g3C9NDHQB42QazIPIM3EY34K+GOZW4M88tZmpj+bOuCI5G91AbmDJoiHnyK9P2
	 bB1t9AEnSoix/+ehki5uK1DUnBcz51OQaXYTQ+d5eNA31gRjwvNVayvQPT+ghxqM/W
	 rHSeqfCR1ToUQ==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v2] scsi: target: Fix NULL se_tpg dereference in
 target_complete()
Reply-To: sashiko-reviews@lists.linux.dev
To: "Yehyeong Lee" <yhlee@isslab.korea.ac.kr>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20260725165818.769963-1-yhlee@isslab.korea.ac.kr>
References: <20260725165818.769963-1-yhlee@isslab.korea.ac.kr>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Sat, 25 Jul 2026 17:20:33 +0000
Message-Id: <20260725172034.073071F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 2 potential issue(=
s) to consider:

Pre-existing issues:
- [Critical] The patch masks a KASAN NULL pointer dereference in `target_co=
mplete()` but leaves a severe Use-After-Free vulnerability. The original NU=
LL dereference was a symptom of a teardown race where commands outlive the =
session because `iscsit_setup_scsi_cmd()` and `iscsit_handle_task_mgt_cmd()=
` ignore the `-ESHUTDOWN` error returned by `target_get_sess_cmd()`. This b=
ypasses `cmd_cnt` tracking entirely, allowing `target_wait_for_cmds()` to c=
omplete early. Consequently, `transport_free_session()` frees `se_sess->ses=
s_cmd_map` (which contains the memory for `cmd`) and `se_sess->cmd_cnt`. By=
 replacing the NULL dereference with a `READ_ONCE()` check, the patch allow=
s `target_complete()` to proceed and execute `INIT_WORK(&cmd->work, ...)` a=
nd `queue_work_on()` on a freed `cmd` structure, corrupting memory. Further=
more, `target_release_cmd_kref()` will eventually call `percpu_ref_put()` o=
n the freed `cmd_cnt`.
- [High] The commit deliberately leaves identical, known NULL pointer deref=
erences and BUG_ON crashes unpatched in other active command paths, creatin=
g a reliable remote Denial-of-Service vector. While the patch mitigates the=
 NULL dereference in `target_complete()`, the commit message explicitly ack=
nowledges that `target_submit()`, `target_init_cmd()`, and `target_submit_t=
mr()` are exposed to the exact same teardown race where `se_sess->se_tpg` i=
s cleared. `target_submit()` dereferences `se_tpg->se_tpg_tfo` locklessly w=
ithout a NULL check, while `target_init_cmd()` and `target_submit_tmr()` co=
ntain `BUG_ON(!se_tpg)` assertions. `transport_lookup_cmd_lun()` also acces=
ses `se_sess->se_tpg->tpg_virt_lun0` locklessly.
--

--- Patch [1]: [PATCH v2] scsi: target: Fix NULL se_tpg dereference in targ=
et_complete() ---
commit 3e9112f38426c64acec2836a61cb50a5d659490b
Author: Yehyeong Lee <yhlee@isslab.korea.ac.kr>

scsi: target: Fix NULL se_tpg dereference in target_complete()

This patch attempts to fix a NULL pointer dereference in target_complete()
by using READ_ONCE to load se_sess->se_tpg and gracefully falling back to a
NULL wwn if it is absent. The issue occurs when an EXTENDED COPY worker or
isert completion outlives session deregistration, resulting in an oops when
accessing cmd->se_sess->se_tpg->se_tpg_wwn.

> target_submit() reads the same chain (se_sess->se_tpg->se_tpg_tfo) and is
> exposed to the identical NULL.  That path has not been reproduced here and
> is left for a separate change.
>
[ ... ]
>
> The BUG_ON(!se_tpg) in target_init_cmd() and target_submit_tmr() can be
> reached by the same teardown race on fabrics that use those helpers.
> iscsit does not - it calls __target_init_cmd() directly and has its own
> TMF path - so those paths could not be reproduced or tested here, and
> converting a deliberate assertion into graceful failure looked like a
> decision for the maintainers rather than something to fold into this fix.

[Severity: High]
This is a pre-existing issue, but does leaving these paths unfixed
leave the kernel vulnerable to remote denial-of-service during session
teardown?

If a misbehaving initiator continues submitting commands during teardown,
or if fabric drivers process commands concurrently, paths like
target_submit() will dereference se_tpg locklessly:

drivers/target/target_core_transport.c:target_submit() {
    ...
    const struct target_core_fabric_ops *tfo =3D se_cmd->se_sess->se_tpg->s=
e_tpg_tfo;
    ...
}

Similarly, transport_lookup_cmd_lun() accesses se_tpg without a NULL check:

drivers/target/target_core_device.c:transport_lookup_cmd_lun() {
    ...
    se_lun =3D se_sess->se_tpg->tpg_virt_lun0;
    ...
}

Can a remote initiator trigger these NULL pointer dereferences or hit the
BUG_ON(!se_tpg) in target_init_cmd() and target_submit_tmr() during this ra=
ce?

> diff --git a/drivers/target/target_core_transport.c b/drivers/target/targ=
et_core_transport.c
> index fad03a15c969e..0b292e3866911 100644
> --- a/drivers/target/target_core_transport.c
> +++ b/drivers/target/target_core_transport.c
> @@ -904,7 +904,8 @@ static bool target_cmd_interrupted(struct se_cmd *cmd)
> =20
>  static void target_complete(struct se_cmd *cmd, int success)
>  {
> -	struct se_wwn *wwn =3D cmd->se_sess->se_tpg->se_tpg_wwn;
> +	struct se_portal_group *se_tpg =3D READ_ONCE(cmd->se_sess->se_tpg);
> +	struct se_wwn *wwn =3D se_tpg ? se_tpg->se_tpg_wwn : NULL;

[Severity: Critical]
This isn't a bug introduced by this patch, but does bypassing the NULL
dereference here expose a use-after-free on the cmd structure?

The original NULL dereference appears to be a symptom of a teardown race
where commands outlive the session. If iscsit_setup_scsi_cmd() and
iscsit_handle_task_mgt_cmd() ignore the -ESHUTDOWN error returned by
target_get_sess_cmd() during teardown:

drivers/target/iscsi/iscsi_target.c:iscsit_setup_scsi_cmd() {
    ...
    target_get_sess_cmd(&cmd->se_cmd, true);
    ...
}

This bypasses cmd_cnt tracking, allowing target_wait_for_cmds() to
complete early. Consequently, transport_free_session() frees
se_sess->sess_cmd_map (which contains the cmd memory) and cmd_cnt:

drivers/target/target_core_transport.c:transport_free_session() {
    ...
    kvfree(se_sess->sess_cmd_map);
    if (se_sess->cmd_cnt)
        target_free_cmd_counter(se_sess->cmd_cnt);
    ...
}

By allowing target_complete() to proceed past the se_tpg check, does this
execute INIT_WORK(&cmd->work, ...) and queue_work_on() on a freed cmd
structure further down in target_complete()?

Additionally, target_release_cmd_kref() will eventually call
percpu_ref_put() on the freed cmd_cnt. Can remote initiators reach
this memory corruption during connection churn?

>  	struct se_dev_attrib *da;
>  	u8 compl_type;
>  	int cpu;

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260725165818.7699=
63-1-yhlee@isslab.korea.ac.kr?part=3D1
