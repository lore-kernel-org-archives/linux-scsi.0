Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 23B1B4570E0
	for <linux-scsi@vger.kernel.org>; Fri, 31 Jul 2026 18:11:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785521497; cv=none; b=Mc1tJKKqRjcF2lVazW8eScyhAP56o21TQleJT+M4EfOsVt0ievHCrwHOMZe7jpykLAMxSbMYlUG6bqz6+Qijj1WJkQHIGJ6NfsxWv50HIf/V1d6u/mME9F4J1Sc5DUnDpPFUYMN4Bqv0Sa6umRig7w1GR5EWCfRVSgpwL4TGeRE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785521497; c=relaxed/simple;
	bh=1wqT6fgguWPW4M9eF0kbyBrjvDXIuS6oN5OqwiNNiOA=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=uCcpCiMkd70VZXzO9F2iENQMoqoUeLicMTYVNuSqt2M7K3YCdlk322lhylmzRHaLsJAkPIlcLaFNqKR/HoiNv6yfCVbKdPggydlJ8q1YW6cRol9/NQLOl50HsOxt9th+DuzRoVBy/eB6YDG/nfdWl28WxJUOEfwBpTE4WuVnKPk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=VqOljwuE; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=JorHWUZP; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="VqOljwuE";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="JorHWUZP"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1785521488;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=1wqT6fgguWPW4M9eF0kbyBrjvDXIuS6oN5OqwiNNiOA=;
	b=VqOljwuEhtV5CAFM2lsY3QNhUI5BXG4ITTZ7Zj5mqghCUHz/a5cuMb5KZi2WmsbavwI8nm
	7RakAXCP4QKeloMN3GCcUyvo3CFWw18dtqji2jwtBIs6BoiKkj9OEpqSEZKczV1alDiyzp
	eXGg6ix2rmyryDFN/3EXl8eHBZBVUpo=
Received: from mail-yx1-f70.google.com (mail-yx1-f70.google.com
 [74.125.224.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-230-Z-3d5iJ3My-7JArtjyqFLQ-1; Fri, 31 Jul 2026 14:11:27 -0400
X-MC-Unique: Z-3d5iJ3My-7JArtjyqFLQ-1
X-Mimecast-MFC-AGG-ID: Z-3d5iJ3My-7JArtjyqFLQ_1785521487
Received: by mail-yx1-f70.google.com with SMTP id 956f58d0204a3-66937c2e6d7so3580561d50.0
        for <linux-scsi@vger.kernel.org>; Fri, 31 Jul 2026 11:11:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1785521487; x=1786126287; darn=vger.kernel.org;
        h=mime-version:user-agent:content-transfer-encoding:content-type
         :references:in-reply-to:date:cc:to:from:subject:message-id:from:to
         :cc:subject:date:message-id:reply-to:content-type;
        bh=1wqT6fgguWPW4M9eF0kbyBrjvDXIuS6oN5OqwiNNiOA=;
        b=JorHWUZPjPMick8f6P8mCUXNWrRedl1D7kMT2GhI6Gaa4kwe/+dnn3pQa9i2qoBqc5
         u21Eons98NvtyGwbyLLm930LVKOSp8h3U+4Qax7CEaWROtejrjMIviKEjBQpRN6+8cjg
         d7Y2q77Og0Se93fq8izR6mFAwSiF3dlaUVanlM6e8Tzh5fpESZoF8yhnUHuzAfeElQLj
         mb/0VvkZpkpvVMil2ynGrfGpt9WP+m0oDDT7/5Pwnt7WKtUiVUK4J4xSlwFenGl9ybkp
         fRsJjRmTlLc/jGj1Qkf/4bsmr3r76s+XOlb/GMWLpoIV3/ve3aPFu1fTckZmKeWRjx4M
         ldRg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785521487; x=1786126287;
        h=mime-version:user-agent:content-transfer-encoding:content-type
         :references:in-reply-to:date:cc:to:from:subject:message-id:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=1wqT6fgguWPW4M9eF0kbyBrjvDXIuS6oN5OqwiNNiOA=;
        b=XX5qVU3Wm8LzNXXTucZVlEJu0al39dwLl0p2yRyq3/uAQUmPmdLggm6ec11Wc6wE2I
         erJt/9Fu8rVjTnwTLSW8y6mQ8ZRtxqG72OZnKkKgpyuqFPjUGdDjd+QJzb29MwqzO+es
         1gJSp1bEy4gzB4G2bXQ/Yq/QoyndNsmwbtg1kVIp28sFrkQcaaPRDlaZ5Zta8qWHshtA
         cVL/zqRWwLOLvDwkZFjK9YoL3OKGRq8165OaORKBCpYoPoIYkOvedG0DjSvWacpGVjgT
         6rXELsNDxSDb0E6oVLFU3+VoJtQvRIGWvYoPbrxvLoPLkvINhylUYHOejArR72R6v/WD
         my1g==
X-Forwarded-Encrypted: i=1; AHgh+RrafqLg19LbinLFCdRKxqnqVDTr+beH0IxwRk73LS/86bPcUI6FKgrhi+CkJ4oz4H6noLS+Nwf/ZxCS@vger.kernel.org
X-Gm-Message-State: AOJu0YyOC6L24OxbfF7YIFAzNnYpuOieK0BrqoCXlLHTeQp7+3mf9P92
	AxqBpLGKKy08TgHwCgbmNtMgtYn1O4RiJ1+k6ueDcRznitTvkjRfL5GpiTnH3b1F3Ob99EGJ+xL
	pYMmJFyL61p9yKDUvYGbt060zY7UhVyPDjGbdZt38Xi/23rqX54U3WCaSMJk5iFI8HPOVwuM=
X-Gm-Gg: AR+sD12COzlPlnOhzolFt0zu4DZrdFeXdRpMQ4xbyAewN6KbfT/hMFpiIi2pn9MvhGt
	jEG6MU+0WedWHbhNHoKIVw6An8Y+ulCkAwqbPgupFjsVDHyVg6xK5aPKzknnO4tAUGU6VythNM+
	CflGriqGQIBICmPFvmDVY2OBPFureW7XdfzkgfzdWgwMyEZRDjb8ogY8d+72LiTyUC8kd19Klq/
	6B8ovGsQo9hFLtZP4PEOUUI78OEbjXvQE+dMQv4Nwh5gocdBisHTe/mi1K9dZUfzPe1pHyYEs3U
	dR3DcMfmupF+wPb0dGMSulWJ1zVz1WeqDdaoAzWIPqEQ0IPsTWAouBMzqUYoTPGQ0IV+on8SFUM
	KDx7sa51/lbhJIgwrnYPvkTyZ9ImAfOtd4ltA
X-Received: by 2002:a53:a692:0:b0:668:9230:e271 with SMTP id 956f58d0204a3-6694f05de2amr854656d50.19.1785521486606;
        Fri, 31 Jul 2026 11:11:26 -0700 (PDT)
X-Received: by 2002:a53:a692:0:b0:668:9230:e271 with SMTP id 956f58d0204a3-6694f05de2amr854635d50.19.1785521486115;
        Fri, 31 Jul 2026 11:11:26 -0700 (PDT)
Received: from loberman-thinkpadp16gen3.rmtusma.csb ([2600:6c65:2440:d8c:dbb1:97f1:a6e6:766b])
        by smtp.gmail.com with ESMTPSA id 956f58d0204a3-66948e49c3csm1056816d50.7.2026.07.31.11.11.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 31 Jul 2026 11:11:25 -0700 (PDT)
Message-ID: <80785a3bccc6505c28c71271b004e0b5f3fd3b3f.camel@redhat.com>
Subject: Re: [PATCH v2] scsi: storvsc: Support manual scans for all Hyper-V
 targets
From: Laurence Oberman <loberman@redhat.com>
To: sashiko-reviews@lists.linux.dev
Cc: linux-hyperv@vger.kernel.org, linux-scsi@vger.kernel.org
Date: Fri, 31 Jul 2026 14:11:24 -0400
In-Reply-To: <20260723165134.618071F000E9@smtp.kernel.org>
References: <20260723163743.1274830-1-loberman@redhat.com>
	 <20260723165134.618071F000E9@smtp.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.58.3 (3.58.3-1.fc43) 
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

On Thu, 2026-07-23 at 16:51 +0000, sashiko-bot@kernel.org wrote:
> Thank you for your contribution! Sashiko AI review found 2 potential
> issue(s) to consider:
>=20
> Pre-existing issues:
> - [High] Kernel panic in fc_eh_timed_out() due to missing NULL check
> for fc_rport, contradicting the v2 changelog claim.
> - [High] Use-After-Free race condition in fc_user_scan_tgt due to
> unpinned rport pointer.
> --
>=20
> --- Patch [1]: [PATCH v2] scsi: storvsc: Support manual scans for all
> Hyper-V targets ---
> commit 7a84d34942989f4df1a7195141939c24f221c9ea
> Author: Laurence Oberman <loberman@redhat.com>
>=20
> scsi: storvsc: Support manual scans for all Hyper-V targets
>=20
> This patch provides a storvsc-specific user_scan callback that uses
> the
> exported scsi_scan_target() interface to allow explicit scanning of
> targets
> without requiring synthetic fc_rports for each target.
>=20
> > ---
> > Changes in v2:
> > - Replace the private, unexported scsi_scan_host_selected() helper
> > with
> > =C2=A0 the exported scsi_scan_target() interface.
> > - Preserve wildcard channel and target scan behavior.
> > - Verify that storvsc_eh_timed_out() does not use the FC error-
> > handler
> > =C2=A0 helpers; the reported missing-rport dereference is not present.
>=20
> [Severity: High]
> This isn't a bug introduced by this patch, but is the v2 changelog
> accurate
> regarding storvsc_eh_timed_out()?
>=20
> Looking at storvsc_eh_timed_out() in drivers/scsi/storvsc_drv.c, it
> appears
> to explicitly route I/O timeouts to the FC transport error handler:
>=20
> if (scmnd->device->host->transportt =3D=3D fc_transport_template)
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 return fc_eh_timed_out(scmnd);
>=20
> When fc_eh_timed_out() handles this, it extracts the fc_rport
> pointer:
>=20
> struct fc_rport *rport =3D starget_to_rport(scsi_target(scmd->device));
> if (rport->port_state =3D=3D FC_PORTSTATE_BLOCKED)
>=20
> Because storvsc targets are created without an intermediate fc_rport
> parent,
> starget_to_rport() returns NULL. Does this mean fc_eh_timed_out()
> will
> immediately dereference a NULL pointer during an I/O timeout?
>=20
>=20
> As a related observation on the FC transport layer scan paths:
>=20
> [Severity: High]
> This is a pre-existing issue, but does fc_user_scan_tgt() have a race
> condition that could lead to a use-after-free?
>=20
> In drivers/scsi/scsi_transport_fc.c:fc_user_scan_tgt(), the host lock
> is
> dropped before scanning the target:
>=20
> spin_unlock_irqrestore(shost->host_lock, flags);
> scsi_scan_target(&rport->dev, channel, id, lun,
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0 SCSI_SCAN_MANUAL);
>=20
> If a concurrent FC link down event or port removal triggers
> fc_rport_final_delete(), can the rport device be removed and freed
> before
> or during the scsi_scan_target() execution? If so, should a reference
> be
> acquired on rport->dev prior to dropping the lock?

I do not see any of F/C related calls in what I modified or in the code
I worked on so for me v2 is the correct and final version of this.

Thanks
Laurence

