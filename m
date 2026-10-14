Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2AE691F3B85;
	Wed, 14 Oct 2026 15:00:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791990016; cv=none; b=ML18bWfDCaD9DbWt2E4UTLE0X+keuEjf960BkuyUlqrr+X54HIhVEBhB7vO/P0ZZ96XC4ZvZHTKKtDONm1XjWz8zZs26KQzbIKxenJtxYcfCm/m1cTL9V+oysKdLRPKNtNIULXjIDkaqOenlw4yVc69NUovcgGyXG81o2wlwUMQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791990016; c=relaxed/simple;
	bh=ke/2ubPgcD4uljjhw1EDzSsu8P1Heq/bPGT/LFG+iVs=;
	h=Message-ID:From:Subject:To:Cc:In-Reply-To:References:Content-Type:
	 Date; b=oIWeWwQv1qfB+/nFF1FJYm4f2h/Wy17p5k9Eqto0gAcitcjSzA/ZAQNDIytwodKqzCN9HXCdNZeAhsxhdoz66GeGhAaJe1HPOArnCdqUy/vDi46KrLZUm6wii2YAlbb/cc59DSi7SG0DNETLei2iPXLPDdvbQKRTy/qH07HkWhc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=OgoLck+g; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="OgoLck+g"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 612421F000C4;
	Wed, 14 Oct 2026 15:00:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791990014;
	bh=8iq+dUOnhZXAufxWAWOvKTl7juwS5H8tI/7ar8tAWJo=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=OgoLck+grRfPwlFIY+gvhYf3uMr/zg88mqt3NY0xrWoQmjzoQIAwY0s2pwGCuxPlp
	 xvAXIdackSI1hAvWq8W6cN879OBg8tNoYF2jaYJRaapiJxLyc17Mv/FXOsZtRtRe2c
	 uFLFPXLhuofFL8DOvbRPTWu7Lv80t9bC2e7kFf/FMCc/S15rkNi9xLGsKLFKjJCb1j
	 Q+8UFCn6trL7hAIZQtSBT0o17pdxSDIRQh4T5c2CjCxJgWv15MhkPrVIg4og3mDTQ3
	 OIm6lKIFVVA08U/w8jmsKDpF715TU5Vt5SNu5Xpei2+L+9IfX0ZwBGXOAlhaPTWckm
	 lNeJ8CyxK4jHA==
Message-ID: <sashiko-outbox-171452@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH 2/2] scsi: target: iscsi: Complete an aborted WRITE when
 a new R2T would be sent
Reply-To: sashiko-reviews@lists.linux.dev
To: "Laurence Oberman" <loberman@redhat.com>
Cc: linux-scsi@vger.kernel.org, target-devel@vger.kernel.org
In-Reply-To: <20261014143932.39453-3-loberman@redhat.com>
References: <20261014143932.39453-1-loberman@redhat.com>
 <20261014143932.39453-3-loberman@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 14 Oct 2026 15:00:13 +0000
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [High] iscsi: workqueue corruption via double completion of aborted cmd
--

commit 1cef49db01d5c1eb5e9670fc6f016dfd14ddd5cd
Author: Laurence Oberman <loberman@redhat.com>

scsi: target: iscsi: Complete an aborted WRITE when a new R2T would be sent

iscsit_check_dataout_payload() hands a command to iscsit_get_dataout() to
request the next burst whenever iscsit_check_post_dataout() returns
DATAOUT_SEND_R2T, without checking CMD_T_ABORTED first. This patch guards
for aborted commands by stopping the dataout timer and completing the comma=
nd.

> diff --git a/drivers/target/iscsi/iscsi_target.c b/drivers/target/iscsi/i=
scsi_target.c
> index aab9237a67768..87b215b18034e 100644
> --- a/drivers/target/iscsi/iscsi_target.c
> +++ b/drivers/target/iscsi/iscsi_target.c
> @@ -1669,6 +1669,25 @@ iscsit_check_dataout_payload(struct iscsit_cmd *cm=
d, struct iscsi_data *hdr,
>  	if ((rc =3D=3D DATAOUT_NORMAL) || (rc =3D=3D DATAOUT_WITHIN_COMMAND_REC=
OVERY))
>  		return 0;
>  	else if (rc =3D=3D DATAOUT_SEND_R2T) {
[ ... ]
> +		if (cmd->se_cmd.transport_state & CMD_T_ABORTED) {
> +			if (cmd->outstanding_r2ts < 1) {
> +				iscsit_stop_dataout_timer(cmd);
> +				target_complete_cmd(&cmd->se_cmd,
> +						    SAM_STAT_TASK_ABORTED);

[Severity: High]
Can calling target_complete_cmd() directly on an aborted command bypass the
synchronization wrapper iscsit_complete_aborted_cmd()?

Because this bypasses iscsit_claim_completion_locked(), could concurrent
session teardown or other abort paths also claim the command and call
target_complete_cmd()?

This concurrent modification could lead to target_cmd_interrupted() executi=
ng
INIT_WORK(&cmd->work, target_abort_work) and queue_work() concurrently on an
already active work item, which might destroy the workqueue linked list.

There is also a preexisting location in the header parsing path that exposes
the same unsynchronized completion race, which appears to have been copied
here and left unfixed:

drivers/target/iscsi/iscsi_target.c:__iscsit_check_dataout_hdr() {
    ...
		if (se_cmd->transport_state & CMD_T_ABORTED) {
			if (hdr->flags & ISCSI_FLAG_CMD_FINAL &&
			    --cmd->outstanding_r2ts < 1) {
				iscsit_stop_dataout_timer(cmd);
				target_complete_cmd(se_cmd, SAM_STAT_TASK_ABORTED);
			}
    ...
}

Would it be safer to use iscsit_complete_aborted_cmd() in both places to
ensure the completion is safely claimed?

> +			}
> +			return 0;
> +		}
> +
>  		iscsit_set_dataout_sequence_values(cmd);

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261014143932.3945=
3-1-loberman@redhat.com?part=3D2
