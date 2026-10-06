Received: from nick.sneptech.io (nick.sneptech.io [178.62.38.78])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D46804EFFCA;
	Tue,  6 Oct 2026 23:42:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=178.62.38.78
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791330135; cv=none; b=cphwppFIf45oUuacexW23W+CNXY3aZTRKL/MUmq6G0LEH2t41ofcbvTfeHSuWBoTmZMJ1WniSP7km8f0Mgk/mixqEo8DcKolbNHY6jbmjaw31n2vAvnBvb5A1IORXyFAqQlk3AQ7NNp4Afij3bLkdbcofwDPsb1oWY5cJtBmcPA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791330135; c=relaxed/simple;
	bh=3O8fH2LIfmIhPDnJmlPEoxNl6jTqW4tIIpu+G0yrriE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Fv2N6xQQ0CPqGSSlZWTxaoa3sQKTnhRY4nMiyEf/2dW7OPANyp9cIctZKVyeECMVZTRGTnJMh88CaoqSX6qXYh7eGnHG2v8IbqfQn9JXi3YGgKd5a1Spj2fjihz6ZbRA9sJB7CAeHY52QDdkR1KI41MZjuTc+Ra3Ti6LqmhKNPM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=philpem.me.uk; spf=pass smtp.mailfrom=philpem.me.uk; dkim=pass (1024-bit key) header.d=philpem.me.uk header.i=@philpem.me.uk header.b=pbDRO8Fn; arc=none smtp.client-ip=178.62.38.78
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=philpem.me.uk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=philpem.me.uk
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=philpem.me.uk header.i=@philpem.me.uk header.b="pbDRO8Fn"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=philpem.me.uk;
	s=mail; t=1791330126;
	bh=3O8fH2LIfmIhPDnJmlPEoxNl6jTqW4tIIpu+G0yrriE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pbDRO8FnSmkJE7Cr37xC1xaNGXgp632t3I2+aUgj5Xj4EZH7ysg4qfwJtTUUmDrX7
	 YhXK1H2b8B2TJOug44tx9MkSfRGeup9VbGye7nRDBTne7gP3vgjI573Ivp2Lsebjrn
	 LG2NASXxSTFTqG7JrrGr8Df2YkhyXbGBhcAsDRsQ=
Received: from wolf.philpem.me.uk (81-187-163-148.ip4.reverse-dns.uk [81.187.163.148])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits))
	(No client certificate requested)
	(Authenticated sender: mailrelay_wolf@philpem.me.uk)
	by nick.sneptech.io (Postfix) with ESMTPSA id 0F82ABE602;
	Tue,  6 Oct 2026 23:42:06 +0000 (UTC)
Received: from cheetah.homenet.philpem.me.uk (cheetah.homenet.philpem.me.uk [10.0.0.32])
	by wolf.philpem.me.uk (Postfix) with ESMTPSA id B83AF5FC05;
	Wed,  7 Oct 2026 00:42:05 +0100 (BST)
From: Phil Pemberton <philpem@philpem.me.uk>
To: linux-ide@vger.kernel.org,
	linux-scsi@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
	Damien Le Moal <dlemoal@kernel.org>,
	Niklas Cassel <cassel@kernel.org>,
	"James E . J . Bottomley" <James.Bottomley@HansenPartnership.com>,
	"Martin K . Petersen" <mkp@kernel.org>,
	Hannes Reinecke <hare@kernel.org>,
	Phil Pemberton <philpem@philpem.me.uk>,
	"Martin K . Petersen" <martin.petersen@oracle.com>
Subject: [PATCH v9 11/11] scsi: scsi_devinfo: add COMPAQ PD-1 multi-LUN ATAPI device quirk
Date: Wed,  7 Oct 2026 00:42:01 +0100
Message-ID: <20261006234202.1139018-12-philpem@philpem.me.uk>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20261006234202.1139018-1-philpem@philpem.me.uk>
References: <20261006234202.1139018-1-philpem@philpem.me.uk>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The COMPAQ PD-1 and Panasonic LF-1195C combine a CD-ROM on LUN 0 with
a phase-change rewritable (PD) drive on LUN 1.

Add a COMPAQ PD-1 quirk with BLIST_FORCELUN to enable multi-LUN scanning
and BLIST_SINGLELUN to serialize commands across LUNs. Set BLIST_NO_LUN_1F
to skip unpopulated LUNs, which report PQ=0/PDT=0x1f.

Reviewed-by: Damien Le Moal <dlemoal@kernel.org>
Reviewed-by: Hannes Reinecke <hare@kernel.org>
Reviewed-by: Martin K. Petersen <martin.petersen@oracle.com>
Assisted-by: LLM
Signed-off-by: Phil Pemberton <philpem@philpem.me.uk>
---
 drivers/scsi/scsi_devinfo.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/scsi/scsi_devinfo.c b/drivers/scsi/scsi_devinfo.c
index 5e37461e61e8..f9196b0d6f4d 100644
--- a/drivers/scsi/scsi_devinfo.c
+++ b/drivers/scsi/scsi_devinfo.c
@@ -150,6 +150,8 @@ static struct {
 	{"COMPAQ", "MSA1000", NULL, BLIST_SPARSELUN | BLIST_NOSTARTONADD},
 	{"COMPAQ", "MSA1000 VOLUME", NULL, BLIST_SPARSELUN | BLIST_NOSTARTONADD},
 	{"COMPAQ", "HSV110", NULL, BLIST_REPORTLUN2 | BLIST_NOSTARTONADD},
+	{"COMPAQ", "PD-1", NULL, BLIST_FORCELUN | BLIST_SINGLELUN |
+				 BLIST_NO_LUN_1F},
 	{"DDN", "SAN DataDirector", "*", BLIST_SPARSELUN},
 	{"DEC", "HSG80", NULL, BLIST_REPORTLUN2 | BLIST_NOSTARTONADD},
 	{"DELL", "PV660F", NULL, BLIST_SPARSELUN},
-- 
2.43.0

