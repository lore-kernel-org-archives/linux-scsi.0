Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 90FC33E639E
	for <linux-scsi@vger.kernel.org>; Tue,  2 Jun 2026 13:25:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780406754; cv=none; b=rQhqBnOKbwheD0PrmpXOwH3aypWhQt7i6cRJhTrW4HbMsMOvdsTCIq9IFdDlkH9pLYhZZ6n1HBCHVm9s44ho8l+Oj6txhZ4uVaVJ+YfwCH6cAhVCqWujZduwdL/dA9F0/PwQhTvfoEDJsnwUjEWaH63Sp0Hnp135Nz72VybavUY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780406754; c=relaxed/simple;
	bh=u2oSW9MvpNEfUu+vOchA11/s/8BkpmK5TUgWdjd+XJQ=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=RGNNyf1eSiHrO00bcyPx5/0j++7DNkPqisI1miVGUE29gF77rYdGONMeTjnhb3weH2+CkJQtvaXXYUeZ/bU3VMM4T0y1GZeZOFH0UzdFM+XcuuGnEn8mvbNt42XS21InnnZTCFMkC36tQriQiSreZ+MoGElCOtgVtkTQBl7FiXg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=gDsjXweo; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=GNqyL1fz; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="gDsjXweo";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="GNqyL1fz"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1780406751;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=QDur5Cc1IxYhEdUOcsZXvMnW9H4MCreBRcibLRysFd4=;
	b=gDsjXweoz76ZBpXnS6tvFln69QzN3dWgaRsLphiEGz1AF6SWNk8Yjm46Vu2sEvj8+b5qiy
	zhH3g3ogfP+pfXUMOjLbtmhUtgZdOUfyvAhIpZGAVloJMosebVDOj3yS+PVc1a1ZqIXO/s
	iTYMoEI5WTyXVX/XuwsU8JzfT8POMpU=
Received: from mail-qk1-f200.google.com (mail-qk1-f200.google.com
 [209.85.222.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-206-Ew7EdEDoOAmZ-TpI4jkT6g-1; Tue, 02 Jun 2026 09:25:50 -0400
X-MC-Unique: Ew7EdEDoOAmZ-TpI4jkT6g-1
X-Mimecast-MFC-AGG-ID: Ew7EdEDoOAmZ-TpI4jkT6g_1780406749
Received: by mail-qk1-f200.google.com with SMTP id af79cd13be357-914b616c670so1441896085a.2
        for <linux-scsi@vger.kernel.org>; Tue, 02 Jun 2026 06:25:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1780406749; x=1781011549; darn=vger.kernel.org;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:from:to:cc:subject
         :date:message-id:reply-to;
        bh=QDur5Cc1IxYhEdUOcsZXvMnW9H4MCreBRcibLRysFd4=;
        b=GNqyL1fzhwysqSMA2jYwm2ldfFpHYlbZLFsyeco6CPH1xR5LWs3+5NCuleq37ax8oD
         HuRSFG4W2tbLqrQuxXXVXOKF5/QqYFw+LO7mcJjjrdscCYksRwivZhuxWArjkkEv0jak
         1LBRQ66lU++jYQ22U9zWdii8+tjQndE/J3xf9x/3lY9xGH/tP8fFo+mij3tRSbHb9VYs
         VRQ+/9f5X44vqScpIud7Wk1trLw42J0T/b7dfcF99KrUsM0IAFzPBB0KYIzvvnvYjG1Z
         hNyzqAzEMwOZ4luxCjYS99KiTn2TYl59RAerZc0gswA3lX8H9tU0E15pmUrNYpYNMMpY
         fvZw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780406749; x=1781011549;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=QDur5Cc1IxYhEdUOcsZXvMnW9H4MCreBRcibLRysFd4=;
        b=h3BU+KVb9h6GNoiUGPKXGno/8HNKyUbzBQD9u/U/cxUKastzM1bxSvftsXwxPk11IQ
         8Unn1gTHxLDEPSVhIdZykPoeBwHaH01FKBQFrWrikTnfz/hbwiCjJHq6ueT/Ynn/d2me
         bY09dqFXLDjieCE+/6rQH7d80z+OZn9PIZL0laoLq1gSJBGYTHl+pU5Q6XozGvsPWzvo
         F13f9bf6spZvhthfaObc5DCCZ5GfqcpniQjSy47EPoFwROP/IKF2fJ3WgSJcJJupUHeh
         toh57hSxtw9hJrsgPGkK/oUhbzODg9Nhe7gkZZ5+Zepz5s8LYlPHCks+jpUadWK64GrZ
         lwcA==
X-Gm-Message-State: AOJu0Yw/kZSbl7tmH420wFr+VbiXG2a8H7hNCID8muclc997cpRr8WCD
	VdMCziuBuMpNGBnyOwHcqM51UUAKWqUO7/79O74x/4ofhAMcbNL8AKp02lHvx2mKkth6Zuu43Ht
	nafbCkVoy8+eDgMqY9EdhCKlKzO4SG/cYVvQ5FNo1fF88UTJVTHN69x/5Yh4SZ7HTXqfBtY+ZX3
	/nxTEk16xgEo+d03flfUZel1rra83qAXhqPPqjkK1E1+5U9Xk=
X-Gm-Gg: Acq92OG48ePp5KW9eidFQ0Hrt+jsId/wdJethomXvwc7YdQjJ/mmJfSN5YJ9DhMhJJA
	/NlwMpYcUTSuWPuwtJAPCBkXq/G7TQf+W4N4Ci5HSUkm6yE3RieoJt7boTjhe6E9fmN5O/Gq9n/
	5RmtqXwmp2OHRd7t3ugZT+TiHqLNex7tO69r4Z+QQvycNdruoEabVsZvjvC0bdkSkQ76NY5HQj8
	fY2twXSqQbpboh9ISElbPRuqWflOxIB1F5O4OAf/JoSNkVdZBpSnskcuE3IVKbXG4LxQc9X92Om
	6uKt/cqqLQHRpkoM6zWb0w9j7skgogIJ711461RSmd6GOOV3PqkuR25pJEsRvdk1iwwULi72INL
	a6OVr9jf7dyJpGNtd4soVduKjVTUVMm/+m1IAguqIc3ctLFaij1ag6aR5f8qXhtozeXEx
X-Received: by 2002:a05:620a:4113:b0:915:6820:b791 with SMTP id af79cd13be357-9156820b842mr1021458185a.1.1780406749287;
        Tue, 02 Jun 2026 06:25:49 -0700 (PDT)
X-Received: by 2002:a05:620a:4113:b0:915:6820:b791 with SMTP id af79cd13be357-9156820b842mr1021450285a.1.1780406748610;
        Tue, 02 Jun 2026 06:25:48 -0700 (PDT)
Received: from loberman-thinkpadp16gen3.rmtusma.csb ([2600:6c65:2440:d8c:aa2b:ddff:fe88:da74])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-9153262b95esm1324488185a.37.2026.06.02.06.25.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 02 Jun 2026 06:25:45 -0700 (PDT)
Message-ID: <6427abedf14272e5e35eb732262a067bc8fb8870.camel@redhat.com>
Subject: Re: [PATCH v2 0/2] scsi: Replace FC-specific jammer with
 transport-agnostic fault injector
From: Laurence Oberman <loberman@redhat.com>
To: linux-scsi@vger.kernel.org
Cc: James.Bottomley@HansenPartnership.com, martin.petersen@oracle.com
Date: Tue, 02 Jun 2026 09:25:43 -0400
In-Reply-To: <20260506140934.1005361-1-loberman@redhat.com>
References: <20260506140934.1005361-1-loberman@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.58.3 (3.58.3-1.fc43) 
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

On Wed, 2026-05-06 at 10:09 -0400, Laurence Oberman wrote:
> This two-patch series replaces the FC-specific SCSI command jammer
> introduced in commit 54a5e73f4d6e ("tcm_qla2xxx Add SCSI command
> jammer/discard capability") with a transport-agnostic initiator-side
> fault injection module.
>=20
> The original implementation required LIO configured in target mode
> with a QLogic qla2xxx HBA, limiting it to FC environments only.
> tcm_qla2xxx target mode has effectively been retired, making the
> original approach no longer viable as a general-purpose test tool.
>=20
> The replacement module (scsi_jammer) operates on the initiator side
> at the queuecommand level of the SCSI mid-layer. It intercepts
> commands before they reach any HBA driver by saving and replacing
> the queuecommand function pointer of the selected Scsi_Host at
> runtime. This makes it equally effective for FC, FCoE, iSCSI, SAS,
> and any other transport that presents a Scsi_Host, with no
> target-side configuration required.
>=20
> Three injection modes simulate different fabric failure scenarios:
> =C2=A0 - drop:=C2=A0=C2=A0=C2=A0 immediate DID_NO_CONNECT (dead path / ca=
ble pull)
> =C2=A0 - timeout: delayed completion beyond SCSI timeout (slow drain)
> =C2=A0 - flap:=C2=A0=C2=A0=C2=A0 periodic arm/disarm (repeated RSCN event=
s)
>=20
> The flap mode is particularly useful for testing dm-multipath path
> reinstatement logic in addition to initial failover.
>=20
> An optional jam_tur_passthrough knob lets TEST UNIT READY commands
> pass through to the real driver while all other commands are jammed.
> This simulates the real-world slow-drain failure mode where the path
> appears alive to dm-multipath path checkers but data I/O is stalled.
>=20
> Safety: commands are never silently dropped; every intercepted
> command is completed via scsi_done() either immediately or from a
> workqueue timer. The initiator will not panic or be left with
> orphaned commands regardless of when the module is unloaded.
>=20
> This patch series was developed with the assistance of Claude AI
> (Anthropic). The design, testing, and sign-off responsibility
> remain with the author.
>=20
> Tested on x86_64 with Emulex lpfc FC HBA, dm-multipath,
> Linux 7.0.0+. All three injection modes and TUR passthrough
> verified against active multipath configurations.
>=20
> Note to reviewers: checkpatch reports 4 CHECKs on patch 2/2,
> all of which are false positives:
> =C2=A0 - "Alignment should match open parenthesis": checkpatch
> =C2=A0=C2=A0=C2=A0 miscounts tabs for enum return types; alignment is cor=
rect.
> =C2=A0 - "Lines should not end with a '('": common kernel pattern.
> =C2=A0 - "Macro argument reuse '_var'" (x2): READ_ONCE/WRITE_ONCE
> =C2=A0=C2=A0=C2=A0 are specifically designed to be safe with macro argume=
nt
> =C2=A0=C2=A0=C2=A0 reuse; this is a known false positive for these access=
ors.
>=20
> Changes since v1:
> =C2=A0 - Patch 2: Add jam_tur_passthrough control to pass TEST UNIT
> =C2=A0=C2=A0=C2=A0 READY commands through while jamming all other command=
s.
> =C2=A0=C2=A0=C2=A0 Simulates slow-drain where path appears alive to multi=
path
> =C2=A0=C2=A0=C2=A0 but data I/O is stalled.
> =C2=A0 - Patch 1: unchanged
> =C2=A0 - Fix duplicate flap_work_fn forward declaration in patch 2
>=20
> Laurence Oberman (2):
> =C2=A0 scsi: tcm_qla2xxx: Remove FC-specific SCSI command jammer
> =C2=A0 scsi: Add transport-agnostic initiator-side fault injector
>=20
> =C2=A0MAINTAINERS=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0 |=C2=A0=C2=A0 6 +
> =C2=A0drivers/scsi/Kconfig=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 |=C2=A0 22 +
> =C2=A0drivers/scsi/Makefile=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 |=C2=A0=C2=A0 1 +
> =C2=A0drivers/scsi/qla2xxx/Kconfig=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 |=
=C2=A0=C2=A0 9 -
> =C2=A0drivers/scsi/qla2xxx/tcm_qla2xxx.c |=C2=A0 23 -
> =C2=A0drivers/scsi/qla2xxx/tcm_qla2xxx.h |=C2=A0=C2=A0 1 -
> =C2=A0drivers/scsi/scsi_jammer.c=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0 | 657
> +++++++++++++++++++++++++++++
> =C2=A07 files changed, 686 insertions(+), 33 deletions(-)
> =C2=A0create mode 100644 drivers/scsi/scsi_jammer.c

Hello

A gentle ping, any interest in looking at this series. If there is no
interest,  then we should at least retire my old 2016 version that uses
tcm_qla2xxx as that is no longer functional

Thanks a lot Laurence

