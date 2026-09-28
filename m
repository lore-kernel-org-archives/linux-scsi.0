Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C5EF54BE430
	for <linux-scsi@vger.kernel.org>; Mon, 28 Sep 2026 13:25:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790601952; cv=none; b=m7K700UEOU8eS7Pcxx7RNweO2/NR+/Bhzjg8oNFRO4oxqyqYUc9fdm2dDKk6dBKR+0t4MjuqCAYIjYQDkbyC4TGMENs5X1nKYPo47n0GV5TD/dF7zKSyq4MtnFGf26rOJfQ/ilZ11trxrSMiQgE3I9j3GaSI2fAcZiXtkSm+bxk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790601952; c=relaxed/simple;
	bh=66RrIPoEuKGVSV0P9QiBC6T+mQqeRRWCBVgkM6TkqTs=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=Oj1wpV+IHn2Ax5L+qTkRoFPKMsGV9vjGvtu46tcFnMxbV+wCmpc4vFvRlmRMdpvBrP/oqPpJVKCEAq4FLRn2JpWGtteItsy4cIspAMB8qimWIuU/qP018mi1h58JG0vNqIvULyGl4az2WSEN407mhi58zcx3ltLEhnKUBlt1CJc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=HWLZ9G8N; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="HWLZ9G8N"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1790601949;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=QcuczEbnyM4qk0SNH2gMwela3lN19NZoxCZsp5t+ssg=;
	b=HWLZ9G8NDyjLQhFI2Kw3B60aTeahiaep1ycKrGJ0B+/SalKl6P3sPdlOK14Km3fMaPNVnH
	4BDUAogiB6iU34maTGqbVzsu+qudqzOIeH58IL0bNY2fG9txqYURSsH+KswgC7eBXAki5T
	nPWQ7JzLL+9+DM8tXY6kT8ffI/Cg8LI=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-400-_9cLMYLzPImY7UQNAd3V9w-1; Mon,
 28 Sep 2026 09:25:46 -0400
X-MC-Unique: _9cLMYLzPImY7UQNAd3V9w-1
X-Mimecast-MFC-AGG-ID: _9cLMYLzPImY7UQNAd3V9w_1790601945
Received: from mx-prod-int-10.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-10.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.95])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id BCF4D1933E8E;
	Mon, 28 Sep 2026 13:25:44 +0000 (UTC)
Received: from loberman-thinkpadp16gen3.redhat.corp (headnet04.pony-001.prod.iad2.dc.redhat.com [10.2.32.116])
	by mx-prod-int-10.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 3E4DF768;
	Mon, 28 Sep 2026 13:25:43 +0000 (UTC)
From: Laurence Oberman <loberman@redhat.com>
To: linux-scsi@vger.kernel.org
Cc: "Martin K . Petersen" <mkp@kernel.org>,
	"James E . J . Bottomley" <James.Bottomley@HansenPartnership.com>,
	Kai Makisara <Kai.Makisara@kolumbus.fi>,
	John Meneghini <jmeneghi@redhat.com>,
	emilne@redhat.com,
	bgurney@redhat.com
Subject: [PATCH v2 0/2] scsi: st: Fix drive settings and position after reset recovery with MTLOAD/MTRETEN
Date: Mon, 28 Sep 2026 09:25:37 -0400
Message-ID: <20260928132539.56876-1-loberman@redhat.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.6 on 10.30.177.95

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

2. Tape state is not reset after MTLOAD of an already loaded medium

   Commit 0b120edb37dc ("scsi: st: Add MTIOCGET and MTLOAD to ioctls
   allowed after device reset") allows MTLOAD because the tape location
   is known after it, but the position is not recorded:
   reset_state() sets -1/-1, and do_load_unload() leaves it there unless
   check_tape() starts a new session.  With drives that do not report a
   new medium for an already loaded cartridge (IBM LTO), MTIOCGET keeps
   reporting -1/-1 and no BOT.  Without a reset, the EOF state is also
   left as it was: after reading to EOD, a read following MTLOAD fails
   with EIO although the tape is at BOT.

   Patch 2 sets the position to BOT and resets the EOF state after a
   successful load when the current partition is 0, as MTREW does.

MTOFFL is deliberately not changed: the medium is unloaded, and a
different one may be loaded next, for which the mode defaults should
apply.

Immediate mode: with MT_ST_NOWAIT, MTRETEN returns before the
retension completes, so patch 1 does not restore the settings there
rather than waiting for the drive.

The SCSI tape driver is currently marked Orphan in MAINTAINERS.  Kai is
Cc'ed as the author of the reset handling these patches build on.

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

MTLOAD of an already loaded tape at EOD, no reset (B09: read after load):

  IBM ULT3580-TDA   v1: read() fails with EIO   v2: ok
  scsi_debug        v1: ok (new session)        v2: ok

For the position tests, "ok" means that MTIOCPOS returns 0 and the
first block read without repositioning is block 0 of file 0; it is not
based on MTIOCGET alone.  The restore after MTREW/MTSEEK/MTEOM from
7081dc75df79 is unaffected on all devices.  Every test ends with a
byte-exact read-back of the whole tape.

The tests are part of a tape validation harness (reset detection, the
blocked-operation matrix, recovery operations, interrupted I/O, SCSI EH
via scsi_debug error injection):
https://gitlab.com/loberman/tapetest (developed with AI assistance)

Changes since v1:
- Patch 2: also reset the EOF state (and at_sm, last_block_valid) after
  the load, as MTREW does (found by Sashiko).  v2 retested on scsi_debug
  and IBM ULT3580-TDA.
- Patch 1: unchanged.

v1: https://marc.info/?l=linux-scsi&m=179051462299046&w=2

Laurence Oberman (2):
  scsi: st: Restore changed drive settings after reset also for MTLOAD
    and MTRETEN
  scsi: st: Record the tape position after a successful MTLOAD

 drivers/scsi/st.c | 59 +++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 59 insertions(+)

-- 
2.55.0

