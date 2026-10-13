Received: from mail-4319.protonmail.ch (mail-4319.protonmail.ch [185.70.43.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 77BA23CB2DC
	for <linux-scsi@vger.kernel.org>; Tue, 13 Oct 2026 14:24:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.70.43.19
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791901481; cv=none; b=XW8I71tdRtMymZzUeUHxhI+ullskboVyIoaRaOyZUrTTK4yeDnG7/DZedJbHu8qMhm9wHWvFzIxit4zhUwqfw2M1AenrWXJITe+bMYaT47NM09EoeEbErM3uYBHMBME0BqlXgELN6lXaZL2CUUp2E2f6jKieRyrVEsSqI6guEv4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791901481; c=relaxed/simple;
	bh=GECG0OYcrsc0uVdMyNS7MyorpM9jCqak8NIjpDhOsnE=;
	h=Date:To:From:Cc:Subject:Message-ID:MIME-Version:Content-Type; b=ERm6vrEPEOTDaHb45maBjV/yo40aMp6iBDJwRbes9r2GaQWlow6iz+AUJ5lQvt7jdmjGfZrLUv2zlEdLeLVcGpkjG7yv4AeQDUoV5JA19m6Hah5o0Za74X35SgZ8c9CPM35LU3p4Fj/hsrySCtULz4Qzenv+dCu9BydGDLUIQVI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=proton.me; spf=pass smtp.mailfrom=proton.me; dkim=pass (2048-bit key) header.d=proton.me header.i=@proton.me header.b=Ncd3lawI; arc=none smtp.client-ip=185.70.43.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=proton.me
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=proton.me
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=proton.me header.i=@proton.me header.b="Ncd3lawI"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=proton.me;
	s=protonmail2; t=1791901468; x=1792160668;
	bh=2ADIR1/pMfMbspIb2zmte608SpHUYWvhPnXUCuGx7tw=;
	h=Date:To:From:Cc:Subject:Message-ID:Feedback-ID:From:To:Cc:Date:
	 Subject:Reply-To:Feedback-ID:Message-ID:BIMI-Selector;
	b=Ncd3lawIhkj4j7Bq0+rH6Matt/+Esy45vEABGXEK94mOy+366k5HLKlPo1p75VfYH
	 ag/M178UdJA0HVg+Cg9ir0vYCnzfRSZuC2jhIb4RpZSwb8CkFevFpgYo3YeJj9EdeU
	 1QnguEFf06qy2KHWrfQYHQ4PJdN+faMyXlC1mY0ul/y8Y6pKDM+zYUEL7tRbykuy0f
	 AKa3P6nUxOpCH0K+7RZHoUEWX5PtG0J0rHRo3Hk4TnzvWya/LM4XCuWPojflgzN41G
	 OEd/nkIgtNlAyMcIiHKftKLgm+hVpT9ggplXfEl5KN9kisXhscg1G6ODWyGHhgIXnR
	 3e/rP2oBa8r5g==
Date: Tue, 13 Oct 2026 14:24:26 +0000
To: "target-devel@lists.linux-foundation.org" <target-devel@lists.linux-foundation.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
From: kerhunt <kerhunt@proton.me>
Cc: "bostroesser@gmail.com" <bostroesser@gmail.com>
Subject: [REPORT] vhost-scsi: vhost_scsi_drop_tpg() ignores vhost_scsi_drop_nexus() -EBUSY and frees the TPG
Message-ID: <IhzzcHM6Wfy1s5niAAGs4eWMKJQuqfQTYyMYPRimnGWl6HsNDcWG-SO39S83dumonPmakhypJEvfAEAVkA8SDwbSMAWpBoLGGbBNmbWQLQQ=@proton.me>
Feedback-ID: 227694322:user:proton
X-Pm-Message-ID: ce4b56c782b18ecbb7e9c982978cea0101d5a8ef
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

Hi target-devel,

In vhost_scsi_drop_tpg() (drivers/vhost/scsi.c), the return value
of vhost_scsi_drop_nexus() is ignored. drop_nexus() refuses the
teardown with -EBUSY while tpg->tv_tpg_port_count or
tpg->tv_tpg_vhost_count is nonzero (scsi.c:2374-2388 in 6.12.y),
but the caller proceeds unconditionally to core_tpg_deregister()
and kfree(tpg):

    vhost_scsi_drop_nexus(tpg);   /* return ignored =E2=80=94 may be -EBUSY=
 */
    core_tpg_deregister(se_tpg);
    kfree(tpg);                   /* freed while nexus may remain */

This mirrors the pattern in drivers/xen/xen-scsiback.c
(scsiback_drop_tpg()), reported separately to the Xen security
team, where the same ignored-refusal-then-free shape exists.

The mitigating mechanism visible in this file is the configfs
dependency taken in the vhost ioctl attach path
(target_depend_item() on the TPG group, scsi.c:2074-2076), which
should prevent removal of the TPG while the vhost ioctl has it
attached. However, the drop path itself does not verify this, and
if any fabric sequence reaches drop_tpg() with live port/vhost
counts (frontend disconnect racing configfs removal, error paths
releasing the dependency early), the TPG is freed while its nexus
and session references are still in use =E2=80=94 vhost_scsi_get_cmd()
and the completion worker dereference tpg->tpg_nexus and the raw
vq pointers afterwards (scsi.c:630-658, 561-614).

Confirmed on linux-6.12.112 (7aba70ab) and mainline HEAD
24a19b953e2a =E2=80=94 no fix found in mainline as of this writing.

Questions for the maintainers:

1. Can the dependency mechanism guarantee drop_tpg() is never
   reached with nonzero port/vhost counts across all fabric
   sequences (including error unwind), or is the ignored -EBUSY
   a reachable hazard?

2. If reachable: is propagating the drop_nexus() return (making
   drop_tpg() fail/defer the free) the preferred fix, or is a
   session-lifetime reference the intended design?

Found by static analysis of the 6.12.y stable tree,
cross-verified against mainline. Happy to test patches.
Please credit "kerhunt <kerhunt@proton.me>".

Best regards,
kerhunt
