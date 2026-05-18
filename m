Received: from mail-qt1-f177.google.com (mail-qt1-f177.google.com [209.85.160.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD9A23624A6
	for <linux-scsi@vger.kernel.org>; Mon, 18 May 2026 14:12:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779113525; cv=none; b=oa72UrOj1NnUMeIs+2myAPipZezXuYNcF+FaxYcuia4SShaB0mLTL36bpGXsyBVxjjku0Zg16f5OdACu87X5DxOzXwR2uEMVKKrCSNyFXAHTQc6kHO8I4jP0UEdI8oQKJ5VqPj9LKCyLTjCxQHK1LJmIxyTIbFlzWtBeIXF5j5o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779113525; c=relaxed/simple;
	bh=R0bDz5xXv7cK3D9/l6XxxhBFaS2XdHhC7foj/ghYO0c=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=uBOcxteXB94qiWL7SCOsDcb+uKx6WoXHIK8xqwnlH0Jx59AUEvhwsXwpIyZoHMLn/1FznEvSxX0pAJUD/4D0g9vlfumI1dwHK024F1OTBgSQnmNUnRGCwEiaabU/bfUH2s8c5R6HSJXdRRR8CSRsJz+avvpzxzWIyfkSmaL+nCA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=jTwUrKO3; arc=none smtp.client-ip=209.85.160.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="jTwUrKO3"
Received: by mail-qt1-f177.google.com with SMTP id d75a77b69052e-50e5dbd8e0eso30570851cf.1
        for <linux-scsi@vger.kernel.org>; Mon, 18 May 2026 07:12:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1779113523; x=1779718323; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=3hAxJYcA8HN4kHRjw3qqXzBCvoBXSW6qtBUU2euYFdg=;
        b=jTwUrKO3T2QAJOOAhTaRsefF5Uuh61ORb5pcvL6wCfdyjoojEMPeyLBholqfWK237Q
         HnqYrcagfxXdclGWJcIWGaO2xh2Wkpo1bCjMjBYHWr2IdjgoVmgvIWcywvgznpI7ms51
         Xaa5+fXa7y06jztYrcabpKAk9KVSq7u/ZCIk2EhVR6vrfIiUGSsnm6cs3NcI5SfctWeN
         1mMjS/n027nfPUFm4TTu3jVMfElcKXPx71r0zIDiZqwqMQwmbBPFZRskDuvz4E/Sn0ty
         qFJF9XfSyVv7aky2ZTuqKwKync/TWWlhciuYrPTOq7Fd+kOhVRsws5h1h1JgsfrPl6S5
         9e/w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779113523; x=1779718323;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=3hAxJYcA8HN4kHRjw3qqXzBCvoBXSW6qtBUU2euYFdg=;
        b=TheEpZz3NRkugIjxoTdWPZTQ3rSePIR4y/UnVjm0JAiPJgwKbaBDQVT+R8MVXezm9z
         A2xvUWE4K/jPDN1xAcBzTMFdBKZhm79K8/dKzKiyj3C6a3NozGZlLkw/YmMnHqP+jsJy
         ipG6tUyr2ZJbkkRf3OKbx36i9WiDO6stOVFnMIpJo5Vyms6+eLVGg/IiCaSorqEQf3m/
         4ON0mH3Q8eybH+N+BCQ5+KCfiThw1MaLlJaQ9AabnYvZvG2KdslzEE2RAwPkO5WtKQbE
         Qh8dM/oUyMJ44PX+hBVy1V1kIzAtn7Cyp0H1xf6D9MyBB1r3Mj359QBhsup6+ysZQEpy
         weBQ==
X-Forwarded-Encrypted: i=1; AFNElJ+BrlzbOeG6l/qJPDaOmKoDTU6XKOfkpuZHRoZ1O1y+IvXLT1rqPqxxyotd8F3fhRtkVp6N3DP3aWpe@vger.kernel.org
X-Gm-Message-State: AOJu0YzA8BWtRLYIhBUX+jdv2JSF+Pbpvqj6CdoZW4BqtiI3Lvj/SCCO
	E1Z1ZWCRggNL7udWfWFHLQwAGR4ulpjcsy2iDUC/J3W4H/REd1HoQiG0
X-Gm-Gg: Acq92OGS0PYWWWPeGWW0EUclS5bqqj1NzFVGwhzKp5aqrMmYsDeFKJ5FfA+otjsZTDH
	RLHegnNEPXZ+LKtWyItJkYmy3ANoaZO0lCcBj3PcYoH1MBBIMi0yauVcTB2kmA5oqGXaZN8wcsC
	zEvajEo2lYiicqQK2lUsWxZwICg3hbCHypvRle1cUvD+XZBNx82Jl7oLCoCZ97snGprtScFRd6j
	pmuXQnXg2kWhhl829wUn6tmmKafpNWYHVORSCOOoTevk/Qcmb41tZsRi1uqq223a0GcZmazZ4up
	wYeb3jITqbJJKrEGlBCscpb9UQFgl5T60MGjac36+y2YwnPL9QvsHkzkQ7geXHMyDWM072KMA7j
	ba2F36uVOdb1GC6B2Ji8wNVOv8TBcm4plJNglwCKw3k+7oG5AtQR0ZtOquKqEtCmEr6Q/uVhvVA
	rfsD8NTefW/WhrZ9ZCkpku8/Jm7mz80NXLwn3umjnPUPLBObTsrSJ+K0X6kx7O+b6NKYQEIW1fh
	9VMrb2mzYbxDZc/5tq3+Qu4F2/NMSCt6iGVSFYFW1M=
X-Received: by 2002:a05:622a:4d91:b0:50f:b904:454 with SMTP id d75a77b69052e-51659fbdb54mr208922781cf.11.1779113522005;
        Mon, 18 May 2026 07:12:02 -0700 (PDT)
Received: from server0.tail6e7dd.ts.net (c-68-48-65-54.hsd1.mi.comcast.net. [68.48.65.54])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-51645688c13sm132490731cf.1.2026.05.18.07.12.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 18 May 2026 07:12:01 -0700 (PDT)
From: Michael Bommarito <michael.bommarito@gmail.com>
To: Hannes Reinecke <hare@suse.de>,
	"Martin K . Petersen" <martin.petersen@oracle.com>,
	"James E . J . Bottomley" <James.Bottomley@HansenPartnership.com>,
	Hannes Reinecke <hare@kernel.org>
Cc: Robert Love <robert.w.love@intel.com>,
	Vasu Dev <vasu.dev@intel.com>,
	Joe Eykholt <jeykholt@cisco.com>,
	Saurav Kashyap <skashyap@marvell.com>,
	Javed Hasan <jhasan@marvell.com>,
	Nilesh Javali <njavali@marvell.com>,
	Karan Tilak Kumar <kartilak@cisco.com>,
	Sesidhar Baddela <sebaddel@cisco.com>,
	Arun Easi <aeasi@cisco.com>,
	Kees Cook <kees@kernel.org>,
	linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [DRAFT][PATCH] scsi: fcoe: reject FIP descriptors with zero fip_dlen in CVL walker
Date: Mon, 18 May 2026 10:11:49 -0400
Message-ID: <20260518141150.2755252-1-michael.bommarito@gmail.com>
X-Mailer: git-send-email 2.53.0
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Disclosure-Status: DO NOT SEND - patch and patch-discipline artifacts pending
Content-Transfer-Encoding: 7bit

drivers/scsi/fcoe/fcoe_ctlr.c::fcoe_ctlr_recv_clr_vlink() advances
the descriptor cursor by an attacker-supplied fip_dlen without
ever requiring dlen >= sizeof(struct fip_desc) in the default
branch.  The named descriptor cases (FIP_DT_MAC, FIP_DT_NAME,
FIP_DT_VN_ID) check their per-type minimum lengths, but a
FIP_DT_NON_CRITICAL descriptor (fip_dtype >= 128, which the
standard requires receivers to silently ignore) skips that check
entirely.

The function is reached on every host that has selected an FCoE
Forwarder and logged into the fabric: any L2 peer on the FCoE
control VLAN that spoofs the elected FCF source MAC, or wins
FIP election, can deliver a CVL frame; FIP frames are not
cryptographically authenticated.

A FIP CVL frame with one FIP_DT_NON_CRITICAL descriptor whose
fip_dlen == 0 leaves desc and rlen unchanged after one loop
iteration, so the loop condition rlen >= sizeof(*desc) stays
true forever and fcoe_ctlr_recv_work never returns.

Impact: an unauthenticated L2 peer on the FCoE control VLAN can
hang fcoe_ctlr_recv_work on an fcoe, qedf, or bnx2fc initiator
indefinitely by emitting one FIP CVL frame whose single
descriptor has fip_dtype == FIP_DT_NON_CRITICAL and
fip_dlen == 0, blocking every subsequent FIP frame (FCF
keepalives, FLOGI, FDISC, real CVLs) on that controller and,
once the fabric ages out the session, leaving FCoE storage on
the affected initiator unavailable until reboot.

Reject the descriptor in the default branch when fip_dlen *
FIP_BPW is less than sizeof(struct fip_desc), i.e. when the
attacker-supplied length cannot even cover the descriptor
header.  This is the same lower-bound that the named cases
already apply and is the minimum scope that closes the loop.

I reproduced this on a KASAN-enabled x86_64 mainline kernel at
f0db6484b6ea via an out-of-tree module that initialises a real
struct fcoe_ctlr through fcoe_ctlr_init(FIP_MODE_FABRIC),
installs a fcoe_fcf with fcf_mac and switch_name, sets
ctlr->state = FIP_ST_ENABLED and lp->port_id, then queues a
crafted FIP CVL skb whose single descriptor has fip_dtype ==
FIP_DT_NON_CRITICAL and fip_dlen == 0, and calls the exported
fcoe_ctlr_recv() from the init thread.  Without the patch, a
bounded watchdog timer fires three seconds into the call with
the workqueue still inside fcoe_ctlr_recv_work (RIP
fcoe_ctlr_recv_work+0x1161/0x34d0 in [libfcoe]).  The
patched-kernel A/B run, the legitimate non-critical-descriptor
regression (fip_dlen == 1) run, and the checkpatch and
get_maintainer outputs are pending the final patch draft and
will be captured before send.  A reproducer is available
off-list on request.

Three driver-private walkers in qedf and fnic share the same
algorithmic invariant (qedf_fcoe_process_vlan_resp at
drivers/scsi/qedf/qedf_fip.c:90, qedf CVL walker at
qedf_fip.c:233, fnic_fcoe_process_vlan_resp at
drivers/scsi/fnic/fip.c:117).  Those are companion fixes for a
separate posting; they need the same dlen lower bound in their
own walker bodies and live-evidence on qedf or fnic hardware.

Fixes: 97c8389d54b9 ("[SCSI] fcoe, libfcoe: Add support for FIP. FCoE discovery and keep-alive.")
Cc: stable@vger.kernel.org
Assisted-by: Claude:claude-opus-4-7
Signed-off-by: Michael Bommarito <michael.bommarito@gmail.com>
