Received: from fgw22-4.mail.saunalahti.fi (fgw22-4.mail.saunalahti.fi [62.142.5.109])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 211B8202C27
	for <linux-scsi@vger.kernel.org>; Thu, 13 Feb 2025 09:26:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=62.142.5.109
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739438820; cv=none; b=LYXqtFIZS5/5BoPP56vdIcEDxE2+drtJTMbxF4HHHvLW03j3EjK0mDYvq/cLFXoF19dBAX7nUhkSan8H0hyAp0arteG16tvJCRKgKJIF6+yWoJC/bGvr6nTsVPuRd60zgVOyHurFUTwcofPFAhkZt867NKtlAWfWKu8IlaC5xXY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739438820; c=relaxed/simple;
	bh=ctSt3PU/y7Efv3KN2C20hb49uYKOL4AOQkHGR1Siml4=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=Br1CVzRi/3JGeRr0uR2C57bfJvOHgR0BzpF5RzjUUo6aIpVIaSN3g3LLMrsdqPOZcDRPTLaDbOxp6jbx6YSipRpytW+HcClflwHIZI7hRd7z2AF6B//cl9IE/erBYL0vISqyOHGtFnwCKr18VETrFF0hKiLL4Wt+etHx5iRg1LY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=kolumbus.fi; spf=pass smtp.mailfrom=kolumbus.fi; dkim=pass (2048-bit key) header.d=kolumbus.fi header.i=@kolumbus.fi header.b=iM92DcV1; arc=none smtp.client-ip=62.142.5.109
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=kolumbus.fi
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kolumbus.fi
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kolumbus.fi header.i=@kolumbus.fi header.b="iM92DcV1"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=kolumbus.fi; s=elisa1;
	h=content-transfer-encoding:content-type:mime-version:message-id:date:subject:
	 cc:to:from:from:to:cc:reply-to:subject:date:in-reply-to:references:
	 list-archive:list-subscribe:list-unsubscribe:content-type:
	 content-transfer-encoding:message-id;
	bh=j3M9u/zgiktae9Zl/x49EzDO+MTs+UdVR1gdFZYAu6k=;
	b=iM92DcV1uHIDp+wEkA1+CmlZZUPuc0i+RzvTAFekfQ1irUGzfTsIyhR0XXFiWgn2Ik0cScQ5m9emH
	 +26bFJxicyZ/pomhNwHHfiCfLNfWlTgsTEZOcVLMGAPbStfB3b5uNrnkL8kQP8e9jrFr0/MijAJ9KE
	 ms6fA/5jxoZ9ZDqwT1AWucx+lBicpDiEraTKpu9B0JF0/2YrGKZzqPx0EV2zZmmtWjLziYJENnmhMF
	 REsohTVLrXeeUw4sfT3Zkovuaz4f5wPiJsViTA/sjKxNqQOrP2dzrhVCedju6qomwWE7rUENB1OM2W
	 8ztVkxGWVl8DIFzkNPN9cQBTnlKd51Q==
Received: from kaipn1.makisara.private (85-156-116-90.elisa-laajakaista.fi [85.156.116.90])
	by fgw22.mail.saunalahti.fi (Halon) with ESMTPSA
	id a52e450f-e9ec-11ef-838a-005056bdf889;
	Thu, 13 Feb 2025 11:26:47 +0200 (EET)
From: =?UTF-8?q?Kai=20M=C3=A4kisara?= <Kai.Makisara@kolumbus.fi>
To: linux-scsi@vger.kernel.org,
	dgilbert@interlog.com
Cc: martin.petersen@oracle.com,
	James.Bottomley@HansenPartnership.com,
	jmeneghi@redhat.com,
	=?UTF-8?q?Kai=20M=C3=A4kisara?= <Kai.Makisara@kolumbus.fi>
Subject: [PATCH v2 0/7] scsi: scsi_debug: Add more tape support
Date: Thu, 13 Feb 2025 11:26:29 +0200
Message-ID: <20250213092636.2510-1-Kai.Makisara@kolumbus.fi>
X-Mailer: git-send-email 2.48.1
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Currently, the scsi_debug driver can create tape devices and the st
driver attaches to those. Nothing much can be done with the tape devices
because scsi_debug does not have support for the tape-specific commands
and features. These patches add some more tape support to the scsi_debug
driver. The end result is simulated drives with a tape having one or two
partitions (one partition is created initially).

The tape is implemented as fixed number (10 000) of 8-byte units.
The first four bytes of a unit contain the type of the unit (data
block, filemark or end-of-data mark). If the units is a data block,
the first four bytes also contain the block length and the remaining
four bytes the first bytes of written data. This allows the user
to use tags to see that the read block is what it was supposed to be.

The following SCSI operations are added or modified:
FORMAT MEDIUM
- added
LOCATE
- added
MODE SELECT
- modified to allow use without page(s) (just header and block descriptor)
  - store density and block size
- partition page added
MODE SENSE
- modified to allow use without page(s) (just header and block descriptor)
  - set density and block size
- partition page added
READ BLOCK LIMITS
- added
READ POSITION
- added
READ
- added tape support for READ (6)
REWIND
- modified to set the tape position
SPACE
- added
START STOP (LOAD)
- modified to return New Medium Unit Attention if tape loaded (not
  according to the standard, but enables testing this UA)
WRITE
- added tape support for WRITE (6)
WRITE FILEMARKS
- added

Changes RFC -> v1:
- rebased to v6.14-rc1
- virtual tape initialization is rewritten and the tape is made shorter
  (10 000 units)
- only one partition is created initially
- tape block allocation is moved to sdev_configure()
- tape blocks are freed in sdev_destroy()
- block size must be multiple of four (SSC standard)
- granularity set to four in READ BLOCK LIMITS
- long LBA not allowed for tapes in MODE SELECT/SENSE
- READ POSITION checks allocation length
- new patch 7 adds support for re-partitioning the tape

Changes v1 -> v2:
- Fixes for bugs reported by the Kernel Test Robot:
  2/7: changed 'len +=' to 'len =' in resp_mode_sense()
  3/7: changed 'for (;' to 'for (i = 0;' in partition_tape()
  4/7: initialized i to zero in resp_space()

Kai Mäkisara (7):
  scsi: scsi_debug: First fixes for tapes
  scsi: scsi_debug: Add READ BLOCK LIMITS and modify LOAD for tapes
  scsi: scsi_debug: Add write support with block lengths  and 4 bytes of
    data
  scsi: scsi_debug: Add read support and update locate for tapes
  scsi: scsi_debug: Add compression mode page for tapes
  scsi: scsi_debug: Reset tape setting at device reset
  scsi: scsi_debug: Add support for partitioning the tape

 drivers/scsi/scsi_debug.c | 775 +++++++++++++++++++++++++++++++++++++-
 1 file changed, 761 insertions(+), 14 deletions(-)

-- 
2.43.0

