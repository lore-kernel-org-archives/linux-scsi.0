Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1471538B7A6;
	Thu, 23 Jul 2026 16:51:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784825496; cv=none; b=MSXQGbHP3dlMJ/hUCkqDOpyLm/zOAN+pPrOmXIsHBy5O1+kPblKm5SmJnVxRj6R7Xgo9MSeT+E+e47/A6jwU2O0+ObdNAaXATa8FXCP5lDhiXt02aa41LOpm2j5dIz7gtA0cf/bZvqjzU5hVBUHHZzztPFTaW7yjLPaxmTgdKxA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784825496; c=relaxed/simple;
	bh=gPercOy1rtSIO4cVNhw/nM2dhSOXfCao72HG0EBWubs=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=uKafUh63WxWhaolNjJarKrJq3mnTf03yt930RsJdLs4olwAhXfKAWAG7yvH3tBp73EJJKnIEWYTJ+FidqPO6qWgndJk+v0FNP5xQfR8aj5PumODzRh2SzhmJ7Jpee1v0yickMWNZmM/wRtYThDrs3vqrUtlI9zbeDpByo71gqb8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=eONXwt67; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="eONXwt67"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 618071F000E9;
	Thu, 23 Jul 2026 16:51:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784825494;
	bh=1cQvAKTizrQ2S9tYlwyVmpdE9Cmym2Z2sjJarm5pfmU=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=eONXwt67K8xjTYCd/DgpY/aDR4HdU3vc8YTYf4zzcLbKTFaSDkpL8+qw/FbyWeg+2
	 UtoLiu97w6KNQSNIl/zhh2mUbnUlZPjpKg0+aqQfO2HhFr+/9H+NRdUqLFqxuG9ccY
	 Y0jokQSIBuZf8/CEe1+zBzyllGbna8SuIi6yP3Rv4c3TAnHKm3FcvWMH2QsPFTiurF
	 jq9rHJev3jJjqxh+6lwMbeOh+ACdBsBREHL0C2907gNXSOB1Pgbg98BqJYqU+bVGlo
	 OLoqgMJDlEzsyFuHkKKQMNpq6HzhbMZhCVWTRGe5RtBdbpjVVXNePAJyGxTVAlr9z7
	 pjR1Pasf8q9/Q==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v2] scsi: storvsc: Support manual scans for all Hyper-V
 targets
Reply-To: sashiko-reviews@lists.linux.dev
To: "Laurence Oberman" <loberman@redhat.com>
Cc: linux-hyperv@vger.kernel.org, linux-scsi@vger.kernel.org
In-Reply-To: <20260723163743.1274830-1-loberman@redhat.com>
References: <20260723163743.1274830-1-loberman@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 23 Jul 2026 16:51:33 +0000
Message-Id: <20260723165134.618071F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 2 potential issue(=
s) to consider:

Pre-existing issues:
- [High] Kernel panic in fc_eh_timed_out() due to missing NULL check for fc=
_rport, contradicting the v2 changelog claim.
- [High] Use-After-Free race condition in fc_user_scan_tgt due to unpinned =
rport pointer.
--

--- Patch [1]: [PATCH v2] scsi: storvsc: Support manual scans for all Hyper=
-V targets ---
commit 7a84d34942989f4df1a7195141939c24f221c9ea
Author: Laurence Oberman <loberman@redhat.com>

scsi: storvsc: Support manual scans for all Hyper-V targets

This patch provides a storvsc-specific user_scan callback that uses the
exported scsi_scan_target() interface to allow explicit scanning of targets
without requiring synthetic fc_rports for each target.

> ---
> Changes in v2:
> - Replace the private, unexported scsi_scan_host_selected() helper with
>   the exported scsi_scan_target() interface.
> - Preserve wildcard channel and target scan behavior.
> - Verify that storvsc_eh_timed_out() does not use the FC error-handler
>   helpers; the reported missing-rport dereference is not present.

[Severity: High]
This isn't a bug introduced by this patch, but is the v2 changelog accurate
regarding storvsc_eh_timed_out()?

Looking at storvsc_eh_timed_out() in drivers/scsi/storvsc_drv.c, it appears
to explicitly route I/O timeouts to the FC transport error handler:

if (scmnd->device->host->transportt =3D=3D fc_transport_template)
        return fc_eh_timed_out(scmnd);

When fc_eh_timed_out() handles this, it extracts the fc_rport pointer:

struct fc_rport *rport =3D starget_to_rport(scsi_target(scmd->device));
if (rport->port_state =3D=3D FC_PORTSTATE_BLOCKED)

Because storvsc targets are created without an intermediate fc_rport parent,
starget_to_rport() returns NULL. Does this mean fc_eh_timed_out() will
immediately dereference a NULL pointer during an I/O timeout?


As a related observation on the FC transport layer scan paths:

[Severity: High]
This is a pre-existing issue, but does fc_user_scan_tgt() have a race
condition that could lead to a use-after-free?

In drivers/scsi/scsi_transport_fc.c:fc_user_scan_tgt(), the host lock is
dropped before scanning the target:

spin_unlock_irqrestore(shost->host_lock, flags);
scsi_scan_target(&rport->dev, channel, id, lun,
                 SCSI_SCAN_MANUAL);

If a concurrent FC link down event or port removal triggers
fc_rport_final_delete(), can the rport device be removed and freed before
or during the scsi_scan_target() execution? If so, should a reference be
acquired on rport->dev prior to dropping the lock?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260723163743.1274=
830-1-loberman@redhat.com?part=3D1
