Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 53FB62F1FED;
	Wed, 22 Jul 2026 06:57:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784703446; cv=none; b=N7H6TU4XMhl2pjyuLIgeG0B1lkUp9SPtn1vZEgdB5xtOykMmM/wXLTQCnh5dt8azHQ6vcWcuxM7WNW9fD4/UBhHRHWJSv2mzb/ReZSOCBdwS0fKQ3OcndupXj0HTgXesFr9mEg5Kwr9JIzG31See/H9sarw9+ML3mtkkuUlyyJw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784703446; c=relaxed/simple;
	bh=idOhC2kM0LA3x9rq6tHuZAwc4IkgFPSYYdw3KPz5+cg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=YKvrKQVylKpWCAcXC7vy1HCcpYhDgzaMxZYchoDeSr2fxjDBu6jj9IUwtjMLdiYOC9q5BRqObvaNbxva0wztjqUguyyqbJY9yWDMWd6ka3yMiWgafsQ45p+ZaI3kaZlJIdknVQh7wbb6dHvvwQMFYURwtD0eaTlerd+mu/mjyHI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=nlSQL2yK; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="nlSQL2yK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 12C5D1F000E9;
	Wed, 22 Jul 2026 06:57:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784703444;
	bh=uvLr2bIZaZ/P+7+C+WwwC26fvKhOnqIx1EOEaGVWkNY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=nlSQL2yKw4jECWYh/3q77D345kLAT5DZ+UYrepvcR3hrzRTtL0sML61oOGOs/pQmO
	 bf2vG9lt/JYEy/X6l0WtEx0Qm6IoHGBZcdQn6a5iThZMXJBYRV300szKGiaRFOuptv
	 OD8NVfztzhcNa++aDbqUg3M3o1uS+LEpiStEW9HKJJ1XZ2O7gtYe2XDnsmZDxzpkWJ
	 Y9s8UnNyMVPV4x6kg0yzwO8N03ZoYRY+VTltsAkw+2kqiUe+iwESYSDLukJWReH5OW
	 j3NRjqSMccWfVZvG8C2IRMbLNNDkOz4ohQENbGWObLs5GXGcGmgOX6Fq6Sp3LRzYHP
	 HdX3PQTaRaSWg==
Date: Wed, 22 Jul 2026 09:57:19 +0300
From: Leon Romanovsky <leon@kernel.org>
To: sashiko-reviews@lists.linux.dev
Cc: linux-scsi@vger.kernel.org
Subject: Re: [PATCH] scsi: target: Clear cmd_cnt when initial counter
 enrollment fails
Message-ID: <20260722065719.GS110966@unreal>
References: <20260722-reference-count-underflow-in-target-v1-1-63ab664f12fd@nvidia.com>
 <20260722064842.B67F41F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20260722064842.B67F41F000E9@smtp.kernel.org>

On Wed, Jul 22, 2026 at 06:48:42AM +0000, sashiko-bot@kernel.org wrote:
> Thank you for your contribution! Sashiko AI review found 2 potential issue(s) to consider:
> 
> Pre-existing issues:
> - [Critical] iSCSI target ignores target_get_sess_cmd() failure, causing reference count underflow and use-after-free
> - [High] qla2xxx target driver leaks cmd_cnt->refcnt references on every SRR processing event

Interesting, I run clade review with Chris's prompts and got this
verdict:

False positives eliminated during analysis: (1) “fix belongs in target_get_sess_cmd()” — refuted by the qla2xxx SRR additional-reference case;
(2) “iscsi/qla2xxx callers left unfixed” — refuted by iscsi teardown ordering and by qla2xxx/tcm_fc/efct using tag/pool free rather than target_release_cmd_kref.

Thanks

> --
> 
> --- Patch [1]: [PATCH] scsi: target: Clear cmd_cnt when initial counter enrollment fails ---
> commit 91357eb9be8775486a1fba8ba21b9b933e790d5b
> Author: Leon Romanovsky <leon@kernel.org>
> 
> scsi: target: Clear cmd_cnt when initial counter enrollment fails
> 
> When target_get_sess_cmd() fails during session shutdown, the command keeps
> the se_cmd->cmd_cnt pointer without owning a reference. Final release through
> target_release_cmd_kref() then issues an unmatched percpu_ref_put(). This
> commit clears se_cmd->cmd_cnt whenever the initial target_get_sess_cmd()
> fails so release performs exactly one matching put per acquired reference.
> 
> > diff --git a/drivers/target/target_core_transport.c b/drivers/target/target_core_transport.c
> > index fad03a15c969e..dcfe945949167 100644
> > --- a/drivers/target/target_core_transport.c
> > +++ b/drivers/target/target_core_transport.c
> 
> [ ... ]
> 
> > @@ -1763,7 +1764,11 @@ int target_init_cmd(struct se_cmd *se_cmd, struct se_session *se_sess,
> >  	 * necessary for fabrics using TARGET_SCF_ACK_KREF that expect a second
> >  	 * kref_put() to happen during fabric packet acknowledgement.
> >  	 */
> > -	return target_get_sess_cmd(se_cmd, flags & TARGET_SCF_ACK_KREF);
> > +	ret = target_get_sess_cmd(se_cmd, flags & TARGET_SCF_ACK_KREF);
> > +	if (ret)
> > +		se_cmd->cmd_cnt = NULL;
> > +
> > +	return ret;
> >  }
> 
> [Severity: Critical]
> This is a pre-existing issue, but I noticed the iSCSI target driver manually
> calls target_get_sess_cmd() and ignores its return value.
> 
> If target_get_sess_cmd() fails (e.g. during session shutdown), it drops the
> cmd_kref back down to 1. Since iscsit_setup_scsi_cmd() ignores this failure:
> 
> drivers/target/iscsi/iscsi_target.c:iscsit_setup_scsi_cmd() {
>     ...
>     target_get_sess_cmd(&cmd->se_cmd, true);
>     ...
> }
> 
> The same happens in the TMR path:
> 
> drivers/target/iscsi/iscsi_target.c:iscsit_handle_task_mgt_cmd() {
>     ...
>     target_get_sess_cmd(&cmd->se_cmd, true);
>     ...
> }
> 
> When the command completes, iscsit_send_status() calls target_put_sess_cmd(),
> which drops the cmd_kref to 0 and prematurely frees the command. This triggers
> an unmatched percpu_ref_put(&cmd_cnt->refcnt) and underflows the session
> reference. Later, iscsit_free_cmd() causes a second target_put_sess_cmd() on
> the freed command, resulting in a use-after-free.
> 
> Can this be triggered by a remote unprivileged initiator sending commands
> concurrently with session teardown?
> 
> 
> [Severity: High]
> This isn't a bug introduced by this patch, but looking at how the qla2xxx
> driver uses target_get_sess_cmd(), could there be a reference leak during SRR
> processing?
> 
> The qla2xxx driver uses target_get_sess_cmd() to acquire an extra reference
> for Sequence Retransmission Request (SRR) processing:
> 
> drivers/scsi/qla2xxx/tcm_qla2xxx.c:tcm_qla2xxx_get_cmd_ref() {
>     ...
>     return target_get_sess_cmd(&cmd->se_cmd, true);
> }
> 
> This increments both cmd_kref and cmd_cnt->refcnt:
> 
> drivers/target/target_core_transport.c:target_get_sess_cmd() {
>     ...
>     if (se_cmd->cmd_cnt) {
>         if (!percpu_ref_tryget_live(&se_cmd->cmd_cnt->refcnt))
>     ...
> }
> 
> However, when releasing the extra reference, the driver only drops cmd_kref:
> 
> drivers/scsi/qla2xxx/tcm_qla2xxx.c:tcm_qla2xxx_put_cmd_ref() {
>     ...
>     target_put_sess_cmd(&cmd->se_cmd);
> }
> 
> The extra cmd_cnt->refcnt increment is never balanced because
> target_release_cmd_kref() is only called once at the end of the command
> lifecycle.
> 
> Does this permanently leak cmd_cnt->refcnt references and cause
> target_wait_for_sess_cmds() to hang infinitely during session teardown?
> 
> -- 
> Sashiko AI review · https://sashiko.dev/#/patchset/20260722-reference-count-underflow-in-target-v1-1-63ab664f12fd@nvidia.com?part=1
