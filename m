Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0B71553C3D7
	for <linux-scsi@vger.kernel.org>; Tue, 29 Sep 2026 17:18:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790702306; cv=none; b=rmUZfJ5E9LPhJrDY7DHKsB2l+AETo03JX7bDpZIUff15nHcEVX7sx+0sD1uX4w1BPVQS20eAgwNHPZTDjaGBCgh+T1rfnzL/IvXfwgRh6vof3ljb8AqTo9AcB6y8GUseAj8UGRQBynQFEZtneZ4tglaAZrMYDZv4O04LfH/2xZA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790702306; c=relaxed/simple;
	bh=N/e/XZn/mQXhy3cMhi4/srvTB4PUg8UOUy1aLj9mTs0=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=A1HpptU4U2yBwMB6I5WjO1D+MU3GEREn7ny6JX8OCkFbud05nMzBi1KeGUR/OavU0W+iSlCR2D48gFDfzvYCSktTUCEJ3fh9Nj8jUrEB53JpUtBtAraCly9Ew1u54g9YgwYaEoWI8Thh4UFHbmoKVXqern6Ik6Dki7PAcj6m844=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=bdrufZg5; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="bdrufZg5"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1790702303;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=jwLBB22QvwgnF3xJZNJHQO6p+vp7gF1PS1SJ5j+f3fY=;
	b=bdrufZg5avq4rIs9ZfBGtVON7R0PlIdNl53a3VscmNxqG9WAFUs5U4t3WtZ6XECXPcr5CL
	UBK50hMMhSd598vs3EY/NeNgGRthvUT7pEuXM0njhmD106TiQI0JefGGdMrTplESOMAcAv
	cLX/XnpZ2g9HQKyO5N3CNLxyTBNNwTo=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-389-ZVZ0QN-GN9SrWSNUrD-FgA-1; Tue,
 29 Sep 2026 13:18:20 -0400
X-MC-Unique: ZVZ0QN-GN9SrWSNUrD-FgA-1
X-Mimecast-MFC-AGG-ID: ZVZ0QN-GN9SrWSNUrD-FgA_1790702299
Received: from mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.93])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id D4C881955F56;
	Tue, 29 Sep 2026 17:18:18 +0000 (UTC)
Received: from loberman-thinkpadp16gen3.redhat.corp (headnet05.pony-001.prod.iad2.dc.redhat.com [10.2.32.117])
	by mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id A7E5D180057E;
	Tue, 29 Sep 2026 17:18:17 +0000 (UTC)
From: Laurence Oberman <loberman@redhat.com>
To: linux-scsi@vger.kernel.org
Cc: "Martin K . Petersen" <mkp@kernel.org>,
	"James E . J . Bottomley" <James.Bottomley@HansenPartnership.com>,
	Kai Makisara <Kai.Makisara@kolumbus.fi>,
	John Meneghini <jmeneghi@redhat.com>,
	emilne@redhat.com,
	bgurney@redhat.com
Subject: [PATCH v3 0/4] scsi: st: Restore drive settings and state after reset and MTLOAD
Date: Tue, 29 Sep 2026 13:18:09 -0400
Message-ID: <20260929171813.844733-1-loberman@redhat.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.93

After a device reset st blocks tape access until one of MTREW, MTOFFL,
MTLOAD, MTRETEN, MTERASE, MTSEEK or MTEOM clears the reset condition.
Testing the reset handling on scsi_debug and on IBM LTO drives found that
several settings and parts of the driver state do not survive the reset
or an MTLOAD.

1. Changed block size and density are lost after MTLOAD or MTRETEN

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

   A LOAD positions the medium at the beginning of partition 0.
   check_tape() records that only when it starts a new session, which
   requires a new-medium unit attention.  Drives that do not report one
   for an already loaded cartridge (IBM LTO) are left with the state from
   before the load:

   - After a reset, MTIOCGET keeps reporting file/block -1 and no BOT,
     although commit 0b120edb37dc ("scsi: st: Add MTIOCGET and MTLOAD to
     ioctls allowed after device reset") allows MTLOAD because the tape
     location is known after it.
   - After reading to EOD, a read following MTLOAD fails with EIO.
   - If partition 1 was selected, st still records partition 1, so a
     later MTSETPART 1 is not performed and I/O goes to partition 0.

   Patch 2 sets the partition to 0, the position to BOT and resets the
   EOF state after a successful load, as the new-session path in
   check_tape() and MTREW do.

3. The drive buffering mode is lost after a reset

   A reset also returns the drive's buffered mode to its default, and
   check_tape() reads it back on every open, so a mode set with
   MTSETDRVBUFFER is lost - with every recovery operation, including
   MTREW.  Unlike density and block size there was no "changed" state to
   restore it from.  Patch 3 records the value set with MTSETDRVBUFFER
   and restores it in both restore paths, before density and block size.

4. The door is not locked again after a reset

   With auto-lock, st locks the door at the first read or write.  A reset
   clears the drive's medium removal prevention, but st kept its locked
   state and never locked the door again.  Patch 4 marks the door
   unlocked when a reset is recognized, so the next access locks it.

MTOFFL is deliberately not changed: the medium is unloaded, and a
different one may be loaded next, for which the mode defaults should
apply.

Immediate mode: with MT_ST_NOWAIT, MTRETEN returns before the
retension completes, so patch 1 does not restore the settings there
rather than waiting for the drive.

The SCSI tape driver is currently marked Orphan in MAINTAINERS.

Testing (v7.3-rc2, scsi_debug and IBM LTO drives on FC):

Block size after reset + recovery (patch 1):

                            R04.load       R04.retension  R04.offline
unpatched:
  scsi_debug                discarded      discarded      discarded
  IBM ULTRIUM-TD5 (LTO-5)   discarded      discarded      discarded
  IBM ULT3580-TDA           discarded      discarded      discarded
patched:
  scsi_debug                restored       restored       discarded (*)
  IBM ULTRIUM-TD5 (LTO-5)   restored       restored       discarded (*)
  IBM ULT3580-TDA           restored       restored       discarded (*)

(*) unchanged by design, see above.

State after MTLOAD (patch 2):

  R03.load: position after reset + MTLOAD
    IBM LTO-5 and ULT3580-TDA  unpatched: MTIOCGET -1:-1    v3: ok (0:0)
    scsi_debug                 unpatched and v3: ok (new session)
  B09: read after MTLOAD at EOD, no reset
    IBM ULT3580-TDA            v1: read() fails with EIO    v2, v3: ok
    scsi_debug                 v1, v2, v3: ok (new session)
  X04: MTLOAD while in partition 1, then MTSETPART 1 and read
    IBM ULTRIUM-TD5 (LTO-5)    v2: MTIOCGET still reports partition 1,
                                   MTSETPART 1 not performed, read in
                                   partition 0 fails with EIO
                               v3: ok
    scsi_debug                 v2, v3: ok (new session)

Drive buffering mode after reset (patch 3), read from the drive with
MODE SENSE through the sg node, mode 0 set with MTSETDRVBUFFER:

  R15: reset + MTREW / MTLOAD / MTRETEN
    IBM ULTRIUM-TD5 (LTO-5)    patches 1-2: drive back in mode 1
                               v3:          mode 0 restored
    scsi_debug                 does not implement buffered mode

Door lock after reset (patch 4), auto-lock on, same open file:

  R16: read (locks), reset, recover, read
    IBM ULTRIUM-TD5 (LTO-5)    patches 1-2: door not locked again
                               v3:          locked again
    scsi_debug                 v3:          locked again

For the position tests, "ok" means that MTIOCPOS returns 0 and the
first block read without repositioning is block 0 of file 0; it is not
based on MTIOCGET alone.  The restore after MTREW/MTSEEK/MTEOM from
7081dc75df79 is unaffected on all devices.  Every test ends with a
byte-exact read-back of the whole tape.

The tests are part of a tape validation harness (reset detection, the
blocked-operation matrix, recovery operations, interrupted I/O, SCSI EH
via scsi_debug error injection); B09, X04, R15 and R16 were added for
the review comments on v1 and v2:
https://gitlab.com/loberman/tapetest (developed with AI assistance)

Changes since v2:
- Patch 2: after a successful load, set the partition to 0 for all
  partitions, not only when the current partition is 0 (Kai Mäkisara).
- New patch 3: restore the drive buffering mode after reset (Kai
  Mäkisara).
- New patch 4: relock the door after reset (Kai Mäkisara).
- Patch 1: unchanged.

Changes since v1:
- Patch 2: also reset the EOF state (and at_sm, last_block_valid) after
  the load, as MTREW does (found by Sashiko).

v2: https://marc.info/?l=linux-scsi&m=179060186958028&w=2
v1: https://marc.info/?l=linux-scsi&m=179051462299046&w=2

Laurence Oberman (4):
  scsi: st: Restore changed drive settings after reset also for MTLOAD
    and MTRETEN
  scsi: st: Record the tape position after a successful MTLOAD
  scsi: st: Restore the drive buffering mode after reset
  scsi: st: Relock the door after a reset

 drivers/scsi/st.c | 83 +++++++++++++++++++++++++++++++++++++++++++++--
 drivers/scsi/st.h |  2 ++
 2 files changed, 82 insertions(+), 3 deletions(-)

-- 
2.55.0

