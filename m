Received: from mail-dl1-f51.google.com (mail-dl1-f51.google.com [74.125.82.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 54DBB3B2D1D
	for <linux-scsi@vger.kernel.org>; Sun,  4 Oct 2026 03:41:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.82.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791085282; cv=none; b=jc16DthjdAX3zqcsuyex3Kr9dgEDgic927Gd5AcHLEDt2nHN8kTJ+FYAOTLgmQyP76Dr5LB++6NWoOv69joNUZOaripR8AvMSDY9pJqR063L2dcq/uT6zFFrORtnC53vn0Tjc3XwUUf6YnHxDPlLwuXbxqjF9qkeJ/7ZDwX0tOA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791085282; c=relaxed/simple;
	bh=YwMfJfhS8WebAaG44mb8R4k8SEc/1J/CFXwbQ9opnDk=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=BQQEpG7KrkYVPFmQt/L8uqwNowWEPPCTLXqWMLgXxbQSOOGGQrd5tuyIWgwognD14Kv39oTt4/xLXMUchVFJjF4Y06fmyPgeYALkqXBT6PsMP45xsCIRwyWoSEPKHYUxlwtZt0MHCPVO4HJrukwbE/g+GTPX5UPhSvDsEQkqc/0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=trailofbits.com; spf=pass smtp.mailfrom=trailofbits.com; dkim=pass (2048-bit key) header.d=trailofbits.com header.i=@trailofbits.com header.b=iM52JNMg; arc=none smtp.client-ip=74.125.82.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=trailofbits.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=trailofbits.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=trailofbits.com header.i=@trailofbits.com header.b="iM52JNMg"
Received: by mail-dl1-f51.google.com with SMTP id a92af1059eb24-1419d3416ceso1169087c88.0
        for <linux-scsi@vger.kernel.org>; Sat, 03 Oct 2026 20:41:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=trailofbits.com; s=google; t=1791085280; x=1791690080; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=ueRz9cc1D5SmO9hExT7+LDHNk+3Y+rU2JJ/JFsE/Ps0=;
        b=iM52JNMgXFOiZyoEfN3YDwpmyoq5o+hb+R+MmEW/LBwlAWaqbIxtLbkvNtagasa11k
         Ppuw1Qoujn2U0s2lucS4wdB3Jw+LPuY3Y5G+Tto5I5uuhIYihcdJ8X3uErKkiolibmGE
         ANHbUQZf9AXwkG5kA7bu+7ctf9QyuFQz8eiyJbPUda2P4QTfjbFPboOifs6EgYFMFSs4
         G+UUfDSZY1fHuRjjwH5b68+MZH7rtJ5/cfxu/gUUhi3bLGPiukTlESG7TeJ4FhTsXena
         fF+vyB77TJhfD4k/2yF+/P/PPLVRENUYwe5nb3Xnj2cTXW2rjrSM3NmtsxckAz+Tlxzs
         0voQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791085280; x=1791690080;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=ueRz9cc1D5SmO9hExT7+LDHNk+3Y+rU2JJ/JFsE/Ps0=;
        b=SxbLTYhyHErFx0+ZgrqZMHLEpGmhkOsge1hLUo825sdEVofZ5X+UziapLIgY4EWCad
         0lWim5HxtODwrSyONy27dPADuBLX4rafPvq6q1FQ7nf84asWtLBw1LdlEmcSC1MtGVaj
         DEqKnKSCUzA0UxTeSqpubQf5Ggw6FyJrqbUr/ZuRGHS3b7YSfXYJs8sl4JGuF0FFWKuN
         6hHbivnx8wyjJbaAqbEJXf+QPQhOWny3TgUdSmsUSZjiuFmtNyjXjhJaMUZFK5x8mGAs
         nidXLtEXgMgxeloIMPeMDvy0Hqcb9v3R8WfnWdikfpg2EnfAxZc2hbXJV1tkawFBJvQu
         b/8w==
X-Forwarded-Encrypted: i=1; AKwUvBwf7FRGAccWyPqXHSfSA6TzeuR3wBKDpbzlVj7jmjYoEjkOW2CVdmfAFrsS8Kcs6+/y+vImj5doMr3A@vger.kernel.org
X-Gm-Message-State: AFuF++kBafV/0CnG63YNE1Mdz9jx9iq5Z8g3770PX/5SXTClip8vroqQ
	Rc+WTf3YnINYb0cOU9VBHlv4DljJp5ZUAXuD+Os6fTCi/jx3LRpLWeMiCM2MeWJesTE=
X-Gm-Gg: AYBFou3gqbVv4OZLbYdyKK4YkJm4KupSPj3+syta55lpAyHzdkUQvzkzEnwhdn1o0fB
	fmuChDnLG3hMbF0XlFUskhWzHLA2MfiOI4IEIH9mKbpG/pJJ+EKC/5PWdAh+l8HHiE2SwpARNMS
	zgJ+96iuUEZGY01kFeEbJiWOi5CW2eQzrXsSCHbyK9tnjg6UXKjFKrXNzbUs4n0l4lkAyxKzTg/
	9Y93zMt+O6Y6Z8TbFQVFTM6k0QtEaB2Ro6dWAkZ6UL58Uka5wm3RVWiM/286w1t7IvVMnyzzkRA
	Im2kX0WZkC+FXv6zQxf+U7akbaW5znR4aER/PbVfkWZH6EaPXgdSUQP4SwEh/2XAxZYedxk0mt/
	9gBVvDTtfpmiRWoXw4BhM91YsBY4CGptegeagZPJEeL1x0lZeqz0X12oPVW/AO6vEG53/aG8pAK
	6ZuOoo7/V8tGifJ5TCoDd2LC+/KY7TKbkYHrMJ/SGNu0atmzRt39moKBFDyihelTXXFGWcPd+q9
	o3DMguuthY7CBq2Lt2/BUL8fO6qIiVDGNtrTRZmJgjElmPXR+UpwwU9N+07B/EG4CX7uS4=
X-Received: by 2002:a05:7022:28f:b0:143:298e:913d with SMTP id a92af1059eb24-151c4356cf8mr5292396c88.47.1791085280240;
        Sat, 03 Oct 2026 20:41:20 -0700 (PDT)
Received: from localhost.localdomain ([2603:8001:5f01:8bab:a817:e330:2fc8:fa47])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-3512718d9edsm1246801eec.19.2026.10.03.20.41.19
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Sat, 03 Oct 2026 20:41:19 -0700 (PDT)
From: Artem Dinaburg <artem@trailofbits.com>
To: Justin Tee <justin.tee@broadcom.com>,
	Paul Ely <paul.ely@broadcom.com>
Cc: "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	James Smart <James.Smart@Emulex.Com>,
	James Bottomley <James.Bottomley@SteelEye.com>,
	"Martin K . Petersen" <mkp@kernel.org>,
	linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Artem Dinaburg <artem@trailofbits.com>
Subject: [RFC PATCH 0/3] scsi: lpfc: Fix mailbox timeout ownership races
Date: Sat,  3 Oct 2026 23:41:08 -0400
Message-ID: <cover.1790968549.git.artem@trailofbits.com>
X-Mailer: git-send-email 2.55.0
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hi Justin and Paul,

While preparing a 6.6.y backport of
commit ede596b1434b ("scsi: lpfc: Handle mailbox timeouts in
lpfc_get_sfp_info"), I may have found two ownership problems in the
synchronous mailbox timeout handoff. I am attaching patches just in
case; I do not have the correct hardware (nor can I emulate it 
in QEMU) to validate the issue is actually reachable.

These patches were developed with AI assistance, and each carries the
required attribution trailer.

Patch 1 fixes lpfc_get_sfp_info_wait(). After MBX_TIMEOUT it no longer
reads the mailbox, which the late completion may already have freed, and
it cleans up after any other failed issue instead of leaking the mailbox
or reporting a zeroed A2 page as success. It is correct on its own with
the current wait/wake code.

Patch 2 fixes the generic wait/wake handoff. A completion that loaded the
wake callback before the waiter timed out finds no waiter and leaks the
mailbox. Because the wake flag is set before hbalock is taken, a waiter
that times out in that window can also return success and free the
mailbox before the callback reads it. The wake callback now decides
ownership under hbalock and runs the default completion itself when the
waiter is gone.

Patch 3 adds a hardware-independent KUnit suite for the wait/wake paths
and for lpfc_get_sfp_info_wait() itself. The issue failure cases fail
without patch 1 and the stale-callback cases fail without patch 2. The
tests check mailbox ownership only, not an SFP transaction or a timeout
on an adapter.

I built lpfc from x86_64 allmodconfig with CONFIG_SCSI_LPFC=m and
CONFIG_WERROR=y after each patch, and ran the KUnit suite in x86_64 QEMU
with and without KASAN. KASAN only covers the paths the suite runs. I do
not have LPFC hardware, so I have not exercised the SFP transaction on an
adapter.

Patch 2 changes the completion path for every lpfc_sli_issue_mbox_wait()
caller. I am not sure if this is the correct approach or if there should
be a different fix.

Thanks,
Artem Dinaburg

Artem Dinaburg (3):
  scsi: lpfc: Do not touch the SFP mailbox after a wait timeout
  scsi: lpfc: Resolve synchronous mailbox wait ownership under hbalock
  scsi: lpfc: Add KUnit tests for mailbox wait ownership

 drivers/scsi/Kconfig                 |  16 ++
 drivers/scsi/lpfc/.kunitconfig       |   9 +
 drivers/scsi/lpfc/Makefile           |   2 +
 drivers/scsi/lpfc/lpfc_els.c         |  12 +-
 drivers/scsi/lpfc/lpfc_sli.c         |  29 +--
 drivers/scsi/lpfc/tests/mbox_kunit.c | 362 +++++++++++++++++++++++++++
 6 files changed, 410 insertions(+), 20 deletions(-)
 create mode 100644 drivers/scsi/lpfc/.kunitconfig
 create mode 100644 drivers/scsi/lpfc/tests/mbox_kunit.c


base-commit: 5e0f8396d4805a3e7f753fa58c8c55f1f3cc2160
-- 
2.43.0
