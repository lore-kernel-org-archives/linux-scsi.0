Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=199.89.1.16
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793400175;
	b=GLFYM1+LV2Ver8gO7Iw2SS7sVbJ/yotIHqhqqsRo+K/Q5EsRF25IJJ36tekEMG/R+qfG
	 hJ/Rgl2tO6w5mQFWjv+Pb4JAGUL5Q7ed1onsSWzlBuNYhloXQxh6Knr1Bz4e8hLABzWPI
	 oLqh8yf8GS+hSxAXMfcls2YLcuFNOnmsbDg13aMiK/0DDnJ4KHorHgIyS6ARHZuAjtHvj
	 bRj52V6QVMMYo9lbn+gqJygwa+KuXw6nEnRuOyljhqtPE/D2rwCTab8nr1uobu6p8uXxd
	 DljOQVqMcW62oByBY/istvJ9I94pgeOZFSVJL/r+PamlmVY+iJWU6IkwzXspb9kqy0A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793400175;
	h=DMARC-Filter:Received:DKIM-Signature:X-Virus-Scanned:Received:
	 Received:From:To:Cc:Subject:Date:Message-ID:X-Mailer:MIME-Version:
	 Content-Transfer-Encoding;
	bh=fhHCBxEres0msVwankQhYngGqwsvEZ2YkXppJAC254Q=;
	b=hucNymlgjNPYFCDVD8RuGdW3/FOgpeQinlb16d7D9XzAZ32cT1CGTYRNsmFyYo/begcD
	 fsuJFLUZ5Ma2OPi8ijGnfRraONqSTEnGx/3495rSnTtWksBO12ePqLXoZt0/MJHsf+Dud
	 FJlW88KR5oxC7ngIyHRnKBGp80fX2dRNakRKiH8ytm4C3w1stxbtjIA2D4vUwhLAFvLVc
	 aGo1PUuMHlZyOeWIxabe77rv9aZLPipzdP6fiKqaX8/oNEEprhetWWrDtFJGs1dPXuh6E
	 zcp0142VZSpl/K3wfQKYsU1KsuaINbJEodeHkImltNZBnmjTqB1ibkXuHQGX2D2lrSg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=acm.org;
	spf=pass smtp.mailfrom=acm.org;
	dkim=pass header.d=acm.org header.i=@acm.org header.a=rsa-sha256 header.s=mr01 header.b=F9oHwSNf;
	arc=none smtp.remote-ip=199.89.1.16
Received: from 013.lax.mailroute.net (013.lax.mailroute.net [199.89.1.16])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 61C63606A31C
	for <linux-scsi@vger.kernel.org>; Fri, 30 Oct 2026 22:42:55 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 61C63606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=acm.org header.i=@acm.org header.a=rsa-sha256 header.s=mr01 header.b=F9oHwSNf
Received: from localhost (localhost [127.0.0.1])
	by 013.lax.mailroute.net (Postfix) with ESMTP id 4jGbht5b6kzlfvqJ;
	Fri, 30 Oct 2026 22:42:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:mime-version:x-mailer:message-id:date
	:date:subject:subject:from:from:received:received; s=mr01; t=
	1793400172; x=1795992173; bh=fhHCBxEres0msVwankQhYngGqwsvEZ2YkXp
	pJAC254Q=; b=F9oHwSNfLXJwCU4auIfDIz/vxDhZKHr7pNbBRyEi03xmZkdIv0g
	DTPGIX4kPOsJlQEdt3dU8Ag8/YLOSbO9xnwUTFoxVwJXua1SnL+liBjqRPBfd2Mw
	6bGPMXSiY8u7ycXvG0Fnxf0oCAw/Pr8bWzObnLT7NR3JyGGyXjizz1nSS61jRJk7
	GnKPT4HMqLF0saz9l0WC5fXGcKVKbIp47LAtYlD+Kcu1mcs3BosNGi1KDvKAzLsZ
	mgjjey2tFg69vp4zv09ba4q2ct8hNVzMkyrmfmTxOAb9kdYga985znZNWy0B0+5q
	AX6RtEk3z8Ru6csruyPFLlGbJNIDYA6hKeg==
X-Virus-Scanned: by MailRoute
Received: from 013.lax.mailroute.net ([127.0.0.1])
 by localhost (013.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id N906c8Z1SbZY; Fri, 30 Oct 2026 22:42:52 +0000 (UTC)
Received: from bvanassche.c.googlers.com.com (57.237.82.34.bc.googleusercontent.com [34.82.237.57])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 013.lax.mailroute.net (Postfix) with ESMTPSA id 4jGbhr0YnJzlfvq2;
	Fri, 30 Oct 2026 22:42:51 +0000 (UTC)
From: Bart Van Assche <bvanassche@acm.org>
To: "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org,
	Alexey Charkov <alchark@flipper.net>,
	Bart Van Assche <bvanassche@acm.org>
Subject: [PATCH 0/5] Recover from persistent UNIT ATTENTION conditions
Date: Fri, 30 Oct 2026 15:42:34 -0700
Message-ID: <cover.1793400000.git.bvanassche@acm.org>
X-Mailer: git-send-email 2.56.0.317.g454f8302e1-goog
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Post: <mailto:linux-scsi@vger.kernel.org>
List-Help: <mailto:linux-scsi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-scsi+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable

Hi Martin,

Some SCSI targets do not clear a power-on or reset UNIT ATTENTION
condition for all commands. BIWIN BWU2A05* UFS devices, for example,
keep reporting UNIT ATTENTION for WRITE commands while TEST UNIT READY,
READ and SYNCHRONIZE CACHE clear the condition. Today such WRITE
commands are retried until the command runtime limit is exceeded. A
quirk has been proposed for these devices [1]. This patch series instead
makes the SCSI core recover from persistent UNIT ATTENTION conditions,
so that no per-device quirk list has to be maintained:
- Patches 1 and 2 prepare the SCSI error handler for the changes in
  the later patches.
- Patch 3 makes the SCSI error handler send TEST UNIT READY to clear
  UNIT ATTENTION conditions before it falls back to resetting the
  device.
- Patch 4 makes scsi_decide_disposition() invoke the error handler if
  a command receives the same UNIT ATTENTION repeatedly. The behavior
  of the exported scsi_check_sense() function, used by libata, is not
  changed.
- Patch 5 limits the number of retries in scsi_io_completion_action()
  of commands that keep receiving UNIT ATTENTION.

Please consider this patch series for the next merge window.

[1] https://lore.kernel.org/linux-scsi/20261028-biwin-tua-quirk-v1-1-767a=
12c9b9cc@flipper.net/

Thanks,

Bart.

Bart Van Assche (5):
  scsi: core: Introduce scsi_cmd_needs_stu()
  scsi: core: Simplify scsi_eh_ready_devs()
  scsi: core: Clear UNIT ATTENTION conditions with TEST UNIT READY
  scsi: core: Escalate persistent UNIT ATTENTION conditions
  scsi: core: Limit retries of commands that receive UNIT ATTENTION

 drivers/scsi/scsi_error.c | 255 +++++++++++++++++++++++++++++++++++---
 drivers/scsi/scsi_lib.c   |   5 +
 include/scsi/scsi_cmnd.h  |   7 ++
 3 files changed, 249 insertions(+), 18 deletions(-)

