Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 46AE33EEAF9
	for <linux-scsi@vger.kernel.org>; Sun, 27 Sep 2026 13:10:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790514638; cv=none; b=h5slehl/W2v3YF1VsMOHccydI8W9qGtFuczpVq09eWc3KssD5ujA+mgI/nC14DVQ7trUyweczhTFjNTRXZZkhuHnu+Y2+w3E0zITYb/bksWKyTPdnaqdQflcGKaD6clE5HWNIRVveoKtlnsTXY6+eQeuNsXR0cD2PCmfTRUSMV0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790514638; c=relaxed/simple;
	bh=W725X9lwweF4muneSKFfTgsCyumyb35zOXcNpd5sgcs=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=aGpdifGnui0/p4UD9cm+AoNjgi6PV3nOVmICbv5C0sfBZUWges2/NKzD8Z/per/KbuiWiJPD7lyaUMI8+rnNRSLk8Ll5Tq4HmyOdnKS2gAm/+mW3zydn1A5Hcnf27ZuicgZ0uE7sq7pYkX34ZpmzOL/QGrqx8GoaSRnN2cB6Xco=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Ljx+mVr/; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Ljx+mVr/"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1790514633;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=a9sg3sornMILCtBtAqhBokpdcwg2Qs8tbu+4UT4js9o=;
	b=Ljx+mVr//ipg5DM4oy/xeVA+ET+TqKnGU4L7H4moym0mgujIvXaC031m65m9eUtyljWKId
	a/CMAm7yjogzGKUnPAxB23IjoY+5rDS8/jHpQpZZ9OBUD5wbMHKeN5bD2zL55/BX/zY3jD
	lDWqBJMTlydjd82MgLwcPPWts8HXQA8=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-567-Xjf5n3ETN4i6UZZ5tSclqA-1; Sun,
 27 Sep 2026 09:10:31 -0400
X-MC-Unique: Xjf5n3ETN4i6UZZ5tSclqA-1
X-Mimecast-MFC-AGG-ID: Xjf5n3ETN4i6UZZ5tSclqA_1790514631
Received: from mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.93])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 22D131955DB8
	for <linux-scsi@vger.kernel.org>; Sun, 27 Sep 2026 13:10:31 +0000 (UTC)
Received: from loberman-thinkpadp16gen3.redhat.corp (headnet03.pony-001.prod.iad2.dc.redhat.com [10.2.32.114])
	by mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 3C0D3180036E;
	Sun, 27 Sep 2026 13:10:30 +0000 (UTC)
From: Laurence Oberman <loberman@redhat.com>
To: linux-scsi@vger.kernel.org
Cc: jmeneghi@redhat.com,
	emilne@redhat.com,
	bgurney@redhat.com
Subject: [PATCH 0/2] scsi: st: Fix drive settings and position after reset recovery with MTLOAD/MTRETEN
Date: Sun, 27 Sep 2026 09:10:17 -0400
Message-ID: <20260927131019.4188777-1-loberman@redhat.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.93

After a device reset st blocks tape access until one of MTREW, MTOFFL,
MTLOAD, MTRETEN, MTERASE, MTSEEK or MTEOM clears the reset condition.
Testing the reset handling on scsi_debug and on IBM LTO drives found two
problems when the condition is cleared with MTLOAD or MTRETEN.

1. Changed block size and density are silently lost

   A reset returns the drive's block size and density to their defaults.
   Commit 7081dc75df79 ("scsi: st: Restore some drive settings after
   reset") re-applies the values set by the user, but only for MTREW,
   MTSEEK and MTEOM.  Because check_tape() reads the drive's block size
   with MODE SENSE on every open, the driver follows the drive back to
   its default after the reset.  An application that set fixed-block
   mode with MTSETBLK and recovers with MTLOAD or MTRETEN keeps writing
   without any error, but in variable-length blocks.

   Patch 1 restores the changed settings for MTLOAD and MTRETEN as well.
   Both may make the drive report a new medium, and the new session
   started by check_tape() clears the "changed" flags and applies the
   mode defaults.  The values are therefore saved before the operation
   and re-applied after check_tape() has run.  scsi_debug reports a new
   medium after MTRETEN and MTLOAD; the IBM drives do not.  The series
   was tested against both behaviours.

2. MTIOCGET reports file/block -1 at BOT after reset + MTLOAD

   Commit 0b120edb37dc ("scsi: st: Add MTIOCGET and MTLOAD to ioctls
   allowed after device reset") allows MTLOAD because the tape location
   is known after it, but the position is not recorded:
   reset_state() sets -1/-1, and do_load_unload() leaves it there unless
   check_tape() starts a new session.  With drives that do not report a
   new medium for an already loaded cartridge (IBM LTO), MTIOCGET keeps
   reporting -1/-1 and no BOT.

   Patch 2 records file/block 0 after a successful load when the current
   partition is 0.

MTOFFL is deliberately not changed: the medium is unloaded, and a
different one may be loaded next, for which the mode defaults should
apply.

Immediate mode: with MT_ST_NOWAIT, MTRETEN returns before the
retension completes, so patch 1 does not restore the settings there
rather than waiting for the drive.

Testing (v7.3-rc2, scsi_debug and IBM LTO drives on FC):

                            R03.load       R04.load      R04.retension  R04.offline
                            (pos. after    (MTSETBLK     (MTSETBLK      (MTSETBLK
                             reset+LOAD)    after LOAD)   after RETEN)   after OFFL)
unpatched:
  scsi_debug                ok (0:0)       discarded     discarded      discarded
  IBM ULTRIUM-TD5 (LTO-5)   -1:-1          discarded     discarded      discarded
  IBM ULT3580-TDA           -1:-1          discarded     discarded      discarded
patched:
  scsi_debug (2 hosts)      ok             restored      restored       discarded (*)
  IBM ULTRIUM-TD5 (LTO-5)   ok             restored      restored       discarded (*)
  IBM ULT3580-TDA           ok             restored      restored       discarded (*)

(*) unchanged by design, see above.

For the position test, "ok" on patched kernels means that MTIOCPOS
returns 0 and the first block read without repositioning is block 0 of
file 0; it is not based on MTIOCGET alone.  The restore after
MTREW/MTSEEK/MTEOM from 7081dc75df79 is unaffected on all devices.
Every test ends with a byte-exact read-back of the whole tape.

The tests are part of a tape validation harness (reset detection, the
blocked-operation matrix, recovery operations, interrupted I/O, SCSI EH
via scsi_debug error injection):
https://gitlab.com/loberman/tapetest (developed with AI assistance)

Laurence Oberman (2):
  scsi: st: Restore changed drive settings after reset also for MTLOAD and MTRETEN
  scsi: st: Record the tape position after a successful MTLOAD

 drivers/scsi/st.c | 53 +++++++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 53 insertions(+)

