Received: from mail-qt1-f171.google.com (mail-qt1-f171.google.com [209.85.160.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F9B340757A
	for <linux-scsi@vger.kernel.org>; Mon, 18 May 2026 14:09:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779113394; cv=none; b=gGEEach3h7X5FhxzlPDi5udp2iCUeFFoEEd63+O76OJfucIqt0fnqgmij8io+/m2TrA7AOmqoDwvnYTLWILKI10HwAh43gQQOT9grj9SUH+2lJfOcrYNqnsGmOpprAFyZTHcgjyCNKzIL25QGHeUGWWTZZfbW7DiBWQ2ZLp+NG8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779113394; c=relaxed/simple;
	bh=K2tLBVNBgk0XNMFBF2xJopcAe+AHdugRy9lU7EoXCx4=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=uLUOwprAI2gxhTUvWbkKIrjB7dX2cUJr1kT96Q4UdE/tFQ+gjkj3zzsTCMSGYrZsQ/MEaE2F1mHbhe9t8SBqydra8OGg259vaqfu8ga7IHHrPth8FuF4OVi7gGQqUM7iKzFXNJ3c8ByKpWvyIm9I2OSp8/b0CYYdZwD50BCyuPI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=ctEO3nOV; arc=none smtp.client-ip=209.85.160.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ctEO3nOV"
Received: by mail-qt1-f171.google.com with SMTP id d75a77b69052e-50d87610513so31534261cf.3
        for <linux-scsi@vger.kernel.org>; Mon, 18 May 2026 07:09:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1779113391; x=1779718191; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=u8+qzU0W1zzwMpcEaXSpQvWhLzK3bb5pvFaLvwTKH2A=;
        b=ctEO3nOVss7TtOxjMsdlS0Iynr31dC3whau7IexcAJw9cJ1IcDT3Zq1sdkcxDxgzpY
         THw0yZjH7v0cJQG55ddnqzdmFC+DG3C369hGaXgT6ZZfBvSZ3uObG6m1RVyicbsE5p8O
         vmVyL6r6pk3HPTlPptteppmToxBK1iutota/OdEmkrad+3fN9RdAHlHN7QcmASGSS3d/
         eZvlrXMFxS9Oj4oXFIMbtDaAeWIS/aBMbUGeU5wXaDzXh8ktlITM3t/xtdZr5Nvd+PyX
         y6qKHID8LKJCPnTnq0YhgQ1/5lsAUmaeAFJAN8ePPXmDcSaFQOlR4LiCxgo+aLkGLIGG
         UCig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779113391; x=1779718191;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=u8+qzU0W1zzwMpcEaXSpQvWhLzK3bb5pvFaLvwTKH2A=;
        b=jbmQXSdBMCCogmItnNs0Lr5UQ/ZmIkkXSo3FmfkNCRYDYgHvmw8szonA7iH84kadd2
         NjZHxEWVHjEGdxvn2rIKTDYmmJ5EVx6aNovzBOe9fiFN0Hh4A0Tm+yikCHbVROnsXWOV
         JSKn7gK5XWtGvwtQozy1MWL0rAtsUbJVYoLZUGjYTNRymj/E2r24uhUrSx4fvUIf2iW/
         jsw6p8m/YpBU5YPif+2Iuu/9cw5u8lNLQoggG9CPIA4UO4eafbpqscl1fvSD89L3k1/m
         tWwm9ZA56koIJbSjjtgUmgqW8RMR15roPrZACqH7E6XLB97wS36kDLSLYhNrkcywcrjk
         sk4Q==
X-Forwarded-Encrypted: i=1; AFNElJ/Kjxu7yyTgN8Kxb5Pg91eA/sABUg/24WyU/R2RA2xYNhC0xvFjkrC3iNDn78Csl4rOicWQrL4sQHuT@vger.kernel.org
X-Gm-Message-State: AOJu0Yzo4DoiO4Qb9QXobIB8k1owITlKwjG08mfaRqyojvfhDxiz846F
	P97hWjGHrNaQPmNO17aEozb07lXGX0tTb+Wo3wQMvt4EV3Y3xqDY7DOd
X-Gm-Gg: Acq92OGKN+LHvM1DFzgn3XFEwONyyTw2oXF/9CnsBMnvqTud5r5gMTvoxs10ZBzZ4rT
	Zx+wnRKTv0QcTaDCZhATGh2wa4z2rlcWge2wmUHRVMHrrdn8+5FbxQnrpd5Q4bgSvkvwxFcffym
	oNkdPDirRf9yuqsBX1EuVtKqhQVoOX7yd3FB+lhKHHK7s4v8XtOB1xayn4oE54S8HQnWhnr+fDA
	zpGc9tW7oDwhqqHMirmdz8I9I+qwUZx4DcBqsj9cJaN0HnHTr1aJ/IKs8FehbyFO4MiEmxHvzt3
	05F0m01bWwr81h+DunO64I7QOLxZBA7x8VKgqIww8j1fXHNhWnozvEeS/AWBOyiE64mSDzA73bE
	CqrbMu2Fv9kOD2RvOm2jQ9UsFPhAiGZiynH04O3BhtG/QORk5TBbPADgbuyKWR8rcTwsgaQcy21
	PswnLH7bOg4EyrMfEoQq6Sxbt3hWQ5yB1zGlvAyq56rwgf6OsuqLGSPvvFZvWKMtrwTA155D83t
	bbKAtjY7NL7GW6tFRF6tl/dEKoWn0g8Q6g2Nm2r67M=
X-Received: by 2002:a05:622a:a1b:b0:516:4f76:aebc with SMTP id d75a77b69052e-5165a0072e8mr213950371cf.1.1779113391191;
        Mon, 18 May 2026 07:09:51 -0700 (PDT)
Received: from server0.tail6e7dd.ts.net (c-68-48-65-54.hsd1.mi.comcast.net. [68.48.65.54])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-516456888f6sm139477401cf.3.2026.05.18.07.09.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 18 May 2026 07:09:50 -0700 (PDT)
From: Michael Bommarito <michael.bommarito@gmail.com>
To: "Martin K . Petersen" <martin.petersen@oracle.com>,
	"James E . J . Bottomley" <James.Bottomley@HansenPartnership.com>
Cc: Nilesh Javali <njavali@marvell.com>,
	Himanshu Madhani <himanshu.madhani@oracle.com>,
	Shyam Sundar <ssundar@marvell.com>,
	James Smart <james.smart@broadcom.com>,
	Hannes Reinecke <hare@kernel.org>,
	John Meneghini <jmeneghi@redhat.com>,
	Bryan Gurney <bgurney@redhat.com>,
	Justin Tee <justin.tee@broadcom.com>,
	Christoph Hellwig <hch@lst.de>,
	Keith Busch <kbusch@kernel.org>,
	Kees Cook <kees@kernel.org>,
	linux-scsi@vger.kernel.org,
	linux-nvme@lists.infradead.org,
	linux-hardening@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [DRAFT][PATCH] scsi: scsi_transport_fc: widen FPIN pname walker counter to u32
Date: Mon, 18 May 2026 10:09:44 -0400
Message-ID: <20260518140945.2751273-1-michael.bommarito@gmail.com>
X-Mailer: git-send-email 2.53.0
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Disclosure-Status: DO NOT SEND - patch and patch-discipline artifacts pending
Content-Transfer-Encoding: 7bit

drivers/scsi/scsi_transport_fc.c::fc_fpin_li_stats_update() and
fc_fpin_peer_congn_stats_update() walk the on-wire pname_list[]
with a u8 loop counter against the 32-bit __be32 pname_count
field, and never bound pname_count by the descriptor body the
TLV walker already validated.

The two functions are reached on every host running lpfc or
qla2xxx as soon as the fabric controller (well-known S_ID
0xFFFFFD on an FC fabric) emits an FPIN ELS for that initiator;
no host-side capability is required, the fabric is the source.

A pname_count of 256 leaves the u8 condition i < 256 true for
every value i can take, so the walker never terminates: it
takes fc_host->rport_lock once per iteration via
fc_find_rport_by_wwpn() and never releases the calling thread.

Impact: a fabric-side FPIN sender (the elected fabric controller,
a co-tenant N_Port that spoofs S_ID 0xFFFFFD after FLOGI, or a
compromised switch supervisor) can hang the FC ELS receive
thread of an lpfc or qla2xxx initiator indefinitely by emitting
one FPIN ELS frame whose Link-Integrity or Peer-Congestion
descriptor sets pname_count to 256, blocking subsequent FPIN,
RSCN, and multipath-health processing on that HBA function
until reboot.

Switch i to u32 in both walkers and clamp pname_count against
the per-descriptor available bytes (desc_len minus the offset
of pname_list[]) before the loop.  This refuses a malformed
descriptor that claims more entries than its TLV body can hold,
and is the minimum scope that covers both walkers.

I reproduced this on a KASAN-enabled x86_64 mainline kernel at
f0db6484b6ea via an out-of-tree module that allocates a real
Scsi_Host through the FC transport API (fc_attach_transport(),
scsi_host_alloc(), scsi_add_host()), builds a 2096-byte FPIN
payload with pname_count == 256, and calls the exported
fc_host_fpin_rcv() from a kernel thread.  Without the patch, a
bounded watchdog timer fires three seconds into the call with
the kthread still inside fc_find_rport_by_wwpn() (offset
0x14b/0x2b0 in [scsi_transport_fc]) under
fc_host_fpin_rcv()+0x4e8.  The patched-kernel A/B run, the
legitimate pname_count <= 4 regression run, and the checkpatch
and get_maintainer outputs are pending the final patch draft
and will be captured before send.  A reproducer is available
off-list on request.

Two in-tree forwarders reach this code: lpfc passes the full
hardware-reported payload_len with no software clamp
(drivers/scsi/lpfc/lpfc_els.c:10830); qla2xxx clamps
total_bytes to sizeof(item->iocb.iocb) == 64 in
qla27xx_copy_fpin_pkt (drivers/scsi/qla2xxx/qla_isr.c
:1170-1171), so qla2xxx delivers at most 64 bytes of FPIN
payload, but the walker bug fires regardless because the inner
walker never consults desc_len before reading pname_list[i].
qedf, bnx2fc, sw-fcoe and bfa do not forward FPIN ELS to
fc_host_fpin_rcv() in mainline.

The in-flight v10 "fc_els: use 'union fc_tlv_desc'" series from
Hannes Reinecke and John Meneghini (linux-scsi mid
20250926000200.837025-2-jmeneghi@redhat.com) touches the same
file but only changes the descriptor pointer type; the u8 i
counter is preserved verbatim in v10.  Can rebase on top of
that series if it lands first, or land this fix standalone
against current mainline.

Fixes: 3dcfe0de5a97 ("scsi: fc: Parse FPIN packets and update statistics")
Cc: stable@vger.kernel.org
Assisted-by: Claude:claude-opus-4-7
Signed-off-by: Michael Bommarito <michael.bommarito@gmail.com>
