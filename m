Received: from fgw23-4.mail.saunalahti.fi (fgw23-4.mail.saunalahti.fi [62.142.5.110])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B7D019F11B
	for <linux-scsi@vger.kernel.org>; Tue, 28 Jan 2025 14:24:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=62.142.5.110
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738074252; cv=none; b=IB1rwUOMokqpUlHU5aB6TL4mawBmIeVo9DQVkBQ7WckCYPleIHe3FRCFQpSciL+Hm+CqQK4zQM7v/lfKnArYrgfP6kS3R4uDh/Trq9d6y2RhQlXSogybltAI2CsTEOcuuD3l/L8vJwxyc7zzoX+MjN0Hp4Xz5mf0qMj3wQWhfqE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738074252; c=relaxed/simple;
	bh=sJGIW4ZAkuXSzDz53oMMezy3x4Lf4jDHnkssjFWBsAo=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=enX3PWUR98oowywx2Mz3FahQ6Yjyl8QEnzdBgRdzMkcXp3VRycGMwyooq+VsEHXrm12ixTy0ymX89oRW2taiq3PcCaM4xg7vIq1XPyyjyYgEZEZmak9IRlzGx+P0UNlCi7glUjx48yyQOdYlMj4OR+JHIvUXe8/qu+0Wxw7pi+Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=kolumbus.fi; spf=pass smtp.mailfrom=kolumbus.fi; dkim=pass (2048-bit key) header.d=kolumbus.fi header.i=@kolumbus.fi header.b=lNBt+ppJ; arc=none smtp.client-ip=62.142.5.110
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=kolumbus.fi
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kolumbus.fi
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kolumbus.fi header.i=@kolumbus.fi header.b="lNBt+ppJ"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=kolumbus.fi; s=elisa1;
	h=content-transfer-encoding:content-type:mime-version:message-id:date:subject:
	 cc:to:from:from:to:cc:reply-to:subject:date:in-reply-to:references:
	 list-archive:list-subscribe:list-unsubscribe:content-type:
	 content-transfer-encoding:message-id;
	bh=zcwejwtb/bLCJ6dXr7NYQC/Q6Cp6NdOgaaYBZ2cxtBQ=;
	b=lNBt+ppJNNMVhVEC75B34dlKa5+zFCvuQ1yLZhHG5iuDYAFPk3gUq3Vin/dAgSTedamNrW0JgRRS/
	 VVZ46o3jEPBa5+H5S20SGR7h8URN0moWAAa4PJ0S8Lo0UmmZS9KWGbVYDmv81ThhB/YIshWaX43Vl6
	 /yCIv2PNInKcNp4iCwU9uOg2tHIRnHIDEI4AWa1cyrOXA4feyKG+hJxsrYZHArJ+0ghoZ/9qCjItNh
	 oH+YGJvsIWeZBWroepGrUZ9lrc5zWkq5tzk1t1ANt7JjTNPwM50HklGjSWz57AuItt/djEvLfGOryJ
	 LfGZqwSj8JLjv0HK9XV+nqsW6ZTuv7Q==
Received: from kaipn1.makisara.private (85-156-116-90.elisa-laajakaista.fi [85.156.116.90])
	by fgw23.mail.saunalahti.fi (Halon) with ESMTPSA
	id 5f92bef6-dd83-11ef-a25c-005056bdfda7;
	Tue, 28 Jan 2025 16:22:59 +0200 (EET)
From: =?UTF-8?q?Kai=20M=C3=A4kisara?= <Kai.Makisara@kolumbus.fi>
To: linux-scsi@vger.kernel.org,
	dgilbert@interlog.com
Cc: jmeneghi@redhat.com,
	=?UTF-8?q?Kai=20M=C3=A4kisara?= <Kai.Makisara@kolumbus.fi>
Subject: [RFC PATCH 0/6] scsi: scsi_debug: Add more tape support
Date: Tue, 28 Jan 2025 16:22:44 +0200
Message-ID: <20250128142250.163901-1-Kai.Makisara@kolumbus.fi>
X-Mailer: git-send-email 2.47.1
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

These changes to the scsi_debug driver have been made to support testing
of the st driver. This is a RFC to see if there is interest to add
this to the kernel scsi_debug driver.

Currently, the scsi_debug driver can create tape devices and the st
driver attaches to those. Nothing much can be done with the tape devices
because scsi_debug does not have support for the tape-specific commands
and features. These patches add some more tape support to the scsi_debug
driver. The end result is simulated drives with a tape having two
partitions (i.e., partitioning can't be changed).

The tape partitions are implemented as fixed number of 8-byte
units (partition zero 100 000 units and partition one 1000 units).
The first four bytes of a unit contains the type of the unit (data
block, filemark or end-of-data mark). If the units is a data block,
the first four bytes contain the block length and the remaining
four bytes the first four bytes of written data. This allows the user
to use tags to see that the read block is what it was supposed to be.

The following SCSI operations are added or modified:
LOCATE
- added
MODE SELECT
- modified to allow use without page(s) (just header and block descriptor)
  - store density and block size
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

Kai Mäkisara (6):
  scsi: scsi_debug: First fixes for tapes
  scsi: scsi_debug: Add READ BLOCK LIMITS and modify LOAD for tapes
  scsi: scsi_debug: Add tape write support with block lengths  and
    4 bytes of data
  scsi: scsi_debug: Add read support and update locate for tapes
  scsi: scsi_debug: Add compression mode page for tapes
  scsi: scsi_debug: Reset tape setting at device reset

 drivers/scsi/scsi_debug.c | 630 +++++++++++++++++++++++++++++++++++++-
 1 file changed, 618 insertions(+), 12 deletions(-)

-- 
2.43.0

