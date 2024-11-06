Received: from fgw20-4.mail.saunalahti.fi (fgw20-4.mail.saunalahti.fi [62.142.5.107])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 05E63186E26
	for <linux-scsi@vger.kernel.org>; Wed,  6 Nov 2024 09:57:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=62.142.5.107
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730887075; cv=none; b=ROo5TryYbWBowETHadjHMQLfi4qFHSDobAJc8T744ZupL2RHuQoj1mlh6trSh4MOcC4HBF8cq9jIZfyO1q569DouWrUUqXamNhJJPL4XMLViUETWOeydJ0w/RrOttOv9naq8ZVz1ddqCDJJGf3TWR6ySWWEcqkRH0o3+EOrtiWs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730887075; c=relaxed/simple;
	bh=RWXAs+xGbv96ovhcDjbgWYW8lDg5HT3I6al9RGvKeN4=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=EtwgScyvm7xt0//s6DI16A+Rhh752ZZz+llQFTl0IRA60X9fOf85qdkarnbiBWMinku+68hRwu7IZv+0CXh3qDgAe1nhNMQcEo+ehviXSyJCCJT2xZWM794/SYfIJWk13vNEuKp3EqegSLk6N7tLQbw4KImaPoW+PKnKH+lgn1s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=kolumbus.fi; spf=pass smtp.mailfrom=kolumbus.fi; dkim=pass (2048-bit key) header.d=kolumbus.fi header.i=@kolumbus.fi header.b=uCZjOXmU; arc=none smtp.client-ip=62.142.5.107
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=kolumbus.fi
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kolumbus.fi
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kolumbus.fi header.i=@kolumbus.fi header.b="uCZjOXmU"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=kolumbus.fi; s=elisa1;
	h=content-transfer-encoding:content-type:mime-version:message-id:date:subject:
	 cc:to:from:from:to:cc:reply-to:subject:date:in-reply-to:references:
	 list-archive:list-subscribe:list-unsubscribe:content-type:
	 content-transfer-encoding:message-id;
	bh=oYl0x9Rl9hcbJkhmfBZBYdFIqz6Jf29TOVeF86M13+o=;
	b=uCZjOXmUK4KMbI7uqv/la6jzq9klc7ix0MSJpEaugisGLBLz/Nz+2zJgMhk00lN88+2VdI4n8GMH8
	 FIM6OGwsPAA0EQeLr3pVsHxE9tONURSPodV4bcb0FizFSaz9v5GVjTb63csn5vA9RUt9mwkJbrTtTu
	 KbeqCs/SIdkt9lmV76LfU4K1TrMW8xc+o30jzdD4rKuS2VDPfd2KX5Y/w4ldVDND+ML+V8D7oKhKgf
	 uIESENyCjqDK39Tvc3Tgx+6Fe/y3deNVIhm2kzgmvL3mQTtAFSuuKezwf5jAT63id0bZ3Iplv99xhN
	 lZ2aDKRYccaqU9+bJ5/EZTgKMp0Plpg==
Received: from kaipn1.makisara.private (85-156-116-90.elisa-laajakaista.fi [85.156.116.90])
	by fgw20.mail.saunalahti.fi (Halon) with ESMTPSA
	id 8f38091f-9c25-11ef-9ac8-005056bd6ce9;
	Wed, 06 Nov 2024 11:57:40 +0200 (EET)
From: =?UTF-8?q?Kai=20M=C3=A4kisara?= <Kai.Makisara@kolumbus.fi>
To: linux-scsi@vger.kernel.org,
	jmeneghi@redhat.com
Cc: martin.petersen@oracle.com,
	James.Bottomley@HansenPartnership.com,
	loberman@redhat.com,
	=?UTF-8?q?Kai=20M=C3=A4kisara?= <Kai.Makisara@kolumbus.fi>
Subject: [PATCH v2 0/3] scsi: st: Device reset patches
Date: Wed,  6 Nov 2024 11:57:20 +0200
Message-ID: <20241106095723.63254-1-Kai.Makisara@kolumbus.fi>
X-Mailer: git-send-email 2.47.0
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

These three patches were developed in response to Bugzilla report
https://bugzilla.kernel.org/show_bug.cgi?id=219419

After device reset, the tape driver allows only operations tha don't
write or read anything from tape. The reason for this is that many
(most ?) drives rewind the tape after reset and the subsequent reads
or writes would not be at the tape location the user expects. Reading
and writing is allowed again when the user does something to position the
tape (e.g., rewind).

The Bugzilla report considers the case when a user, after reset, tries
to read the drive status with MTIOCGET ioctl, but it fails. MTIOCGET
does not return much useful data after reset, but it can be allowed.
MTLOAD positions the tape and it should be allowed. The second patch
adds these to the set of allowed operations after device reset. 

The first patch fixes a bug seen when developing the second patch.

V2: The third patch is added to fix a bug that resulted in not
blocking writes if reset occurs while the device file is not open.

Kai Mäkisara (3):
  scsi: st: Don't modify unknown block number in MTIOCGET
  scsi: st: Add MTIOCGET and MTLOAD to ioctls allowed after device reset
  scsi: st: New session only when Unit Attention for new tape

 drivers/scsi/st.c | 36 ++++++++++++++++++++++++++----------
 1 file changed, 26 insertions(+), 10 deletions(-)

-- 
2.43.0

