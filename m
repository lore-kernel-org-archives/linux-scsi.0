Received: from 013.lax.mailroute.net (013.lax.mailroute.net [199.89.1.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 75C262C11CB
	for <linux-scsi@vger.kernel.org>; Wed, 14 Jan 2026 17:51:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768413074; cv=none; b=VCwO7vpRl03bgQZAGZwynokc94FcweAeakwkn1z4Btzhw/QT7P6z4v/2bqBgu/yprE94M7laiEQqZ1M1ew5j4Ob4R1CRf7MxiqI9ySY/BRhcgdfvRqMiX0CUlg8FSWfVkJytl2XVk2FarFcya60axUyEVgZqZuzYz9VPNy0kdGI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768413074; c=relaxed/simple;
	bh=cUbEl06eszlmmUvns45jQtx+1UVSNph7VLjI/6xrIVk=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=l9sbLQLMc3MmAaUP4sxwvzI5zS8nysU0bTlA/pyOjOZM0Rrfaw49woBlouRTGlA6Xd9u3+zeYSb1W4NNqU9hCgcAeE6/Ce61ERdA0+GSC6+tM7DOHwIGJdgzzuc09c+CFFh4eAYXEIosfeqxXF2j/o/0q23qHHx7Iz15IBNMT24=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=FOwJFlxz; arc=none smtp.client-ip=199.89.1.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="FOwJFlxz"
Received: from localhost (localhost [127.0.0.1])
	by 013.lax.mailroute.net (Postfix) with ESMTP id 4drtvb0J51zllCWt;
	Wed, 14 Jan 2026 17:51:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:mime-version:x-mailer:message-id:date
	:date:subject:subject:from:from:received:received; s=mr01; t=
	1768413066; x=1771005067; bh=Kbo5wNgoB+yd1RDaWt4T+IkvXBXRmrGK+iH
	8g4+kzmk=; b=FOwJFlxz1IDznrcbZXHPrDo07a77TWOys7flMm6d/DmP9/U0Key
	x2vU7+57jESMDzXDIa/eIxfHqKHIohyJa8t2pvQckACb1RKZLgRqUUp/V70dIv/H
	K7AUuIqMZOB1A3GEQnKSpRUxsqwwsZG3CjqJSAVzcxG0OKqwoY0QWaDjqIKI7Pqv
	i2OMV4SeVvX+NgVI/758zeuXqvyGLUbEuPFNUM86HFL/bh4JAZzKvTDtOOqJUZJ+
	jzGwHB+yuEEYCTiP0kqel2i1eU8Dqy5Rl5qhu+Ib774PcxicLKahtVZmkuX4gym7
	T711zyyYu/kfInjGkuAYzaGusZbsCcK9eAg==
X-Virus-Scanned: by MailRoute
Received: from 013.lax.mailroute.net ([127.0.0.1])
 by localhost (013.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id jsU62Z6rpPGT; Wed, 14 Jan 2026 17:51:06 +0000 (UTC)
Received: from bvanassche.mtv.corp.google.com (unknown [104.135.180.219])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 013.lax.mailroute.net (Postfix) with ESMTPSA id 4drtvY2mXgzllCWj;
	Wed, 14 Jan 2026 17:51:04 +0000 (UTC)
From: Bart Van Assche <bvanassche@acm.org>
To: "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org,
	Bart Van Assche <bvanassche@acm.org>
Subject: [PATCH v6 0/5] Clean up the SCSI disk driver source code
Date: Wed, 14 Jan 2026 09:50:48 -0800
Message-ID: <20260114175054.4118163-1-bvanassche@acm.org>
X-Mailer: git-send-email 2.52.0.457.g6b5491de43-goog
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable

Hi Martin,

This patch series removes multiple forward declarations from the SCSI dis=
k (sd)
driver and also makes error messages easier to find with grep. Please con=
sider
this patch series for the next merge window.

Thanks,

Bart.

Changes compared to v5:
 - Rebased the patch series.

Changes compared to v4:
 - Added Johannes' Reviewed-by tag.
 - See also https://lore.kernel.org/linux-scsi/20260106190749.2549070-1-b=
vanassche@acm.org/

Changes compared to v3:
 - Rebased the patch series.
 - See also
   https://lore.kernel.org/linux-scsi/20251121182112.3485615-1-bvanassche=
@acm.org/.

Changes compared to v2:
 - Rebased the patch series and dropped a patch that is no longer needed.
 - See also
   https://lore.kernel.org/linux-scsi/20240805234250.271828-1-bvanassche@=
acm.org/.

Changes compared to v1:
 - Reduced function argument indentation (whitespace only change).
 - See also
   https://lore.kernel.org/linux-scsi/20240730210042.266504-1-bvanassche@=
acm.org/.

Bart Van Assche (5):
  scsi: sd: Move the sd_remove() function definition
  scsi: sd: Move the sd_config_discard() function definition
  scsi: sd: Move the scsi_disk_release() function definition
  scsi: sd: Move the sd_fops definition
  scsi: sd: Do not split error messages

 drivers/scsi/sd.c | 276 ++++++++++++++++++++++------------------------
 1 file changed, 132 insertions(+), 144 deletions(-)

