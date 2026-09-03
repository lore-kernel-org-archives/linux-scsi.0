Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 12BC437883D;
	Thu,  3 Sep 2026 03:42:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788406942; cv=none; b=pdyUF4H9sVTI9i3VAuJh+4YinAyrpFHUoojGo1E+PVpdxSpu0mH5mLJ2Hh6imVQfUzGABC44ar4av29nZ1+tLCH1+lMffaYCCmWsGE9a+xw6ZkUXeplTVhCs9+Er/HSwiosuqEupJs7FPoMcBwRCAxkWtyD0PNE4mOXNs2xCD70=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788406942; c=relaxed/simple;
	bh=AY/LFUzKJf9Nh/fTD9q7gzfd6v1/zmNuj89d5o+n0ZQ=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hEuRfEJRuo6g4HB3ilD8EBU8hNRTKqmczyhu+fjm4c+TrqqvFC1pMPVF1AVGiTmCm+kWqkcLPBVEtViCtLdhov9Cgm2glJbnzsxQC27EvSMX40eF4Lwyrzcw0/x1162brqoJr2dvzAzBtt3DXg/O+mpW9uRcm+rZ6dzbcO3aD68=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=MxvFMH6b; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="MxvFMH6b"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4004A1F000E9;
	Thu,  3 Sep 2026 03:42:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788406940;
	bh=0udnZc7ugionbCdSxj3ONlbTAQ4MVlX9BGpsCvjqTA8=;
	h=From:To:Subject:Date:In-Reply-To:References;
	b=MxvFMH6bYIWNnVyVYIzn5ilMkwDQqU/eGlibLKp16vMZDwnK8o1NbnGsUiaYEx/k8
	 ouLBA1VrYyscFl6EsSLeUl4Pn5+TYJcD5vWrmn1t6VqE/1gafzYzK3Xqr0lBaqhHni
	 2dfZ66/m3mbARbEnKr0mgyQcN1cAbZyI78f5zftRGy1XXlEPeVaKAM0QraqtpWtnRm
	 lwyxltbmGJdStVzQW7U+aN1BhBUyzySdJJPr0TByaogCXU42qVUbJeXXG1A/pmfDEm
	 xCsdRRlciqIBZfXuasiF3PiAgxmAibhvegyCqxd8m5HV1zpT8mQxpJdWCgVxxL0m9V
	 q6aLMBknQEf1g==
From: Damien Le Moal <dlemoal@kernel.org>
To: "Martin K . Petersen" <martin.petersen@oracle.com>,
	"James E . J . Bottomley" <James.Bottomley@HansenPartnership.com>,
	linux-scsi@vger.kernel.org,
	linux-ide@vger.kernel.org,
	Niklas Cassel <cassel@kernel.org>,
	linux-usb@vger.kernel.org,
	Alan Stern <stern@rowland.harvard.edu>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	linux-s390@vger.kernel.org,
	Heiko Carstens <hca@linux.ibm.com>
Subject: [PATCH v2 03/40] scsi: constants: rename internal struct field names
Date: Thu,  3 Sep 2026 12:41:24 +0900
Message-ID: <20260903034201.112211-4-dlemoal@kernel.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260903034201.112211-1-dlemoal@kernel.org>
References: <20260903034201.112211-1-dlemoal@kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

To make the code more clear, rename the code12 field of struct error_info
to the more natural name "code" and the fields code1, code2_min and
code2_max of struct error_info2 to the more explicit asc, ascq_min and
ascq_max.

No functional change intended.

Signed-off-by: Damien Le Moal <dlemoal@kernel.org>
---
 drivers/scsi/constants.c | 22 ++++++++++++----------
 1 file changed, 12 insertions(+), 10 deletions(-)

diff --git a/drivers/scsi/constants.c b/drivers/scsi/constants.c
index 340785536998..4b97f574fe8c 100644
--- a/drivers/scsi/constants.c
+++ b/drivers/scsi/constants.c
@@ -292,7 +292,7 @@ bool scsi_opcode_sa_name(int opcode, int service_action,
 }
 
 struct error_info {
-	unsigned short code12;	/* 0x0302 looks better than 0x03,0x02 */
+	unsigned short code;	/* 0x0302 looks better than 0x03,0x02 */
 	unsigned short size;
 };
 
@@ -318,9 +318,11 @@ static const char *additional_text =
 	;
 
 struct error_info2 {
-	unsigned char code1, code2_min, code2_max;
-	const char * str;
-	const char * fmt;
+	u8		asc;
+	u8		ascq_min;
+	u8		ascq_max;
+	const char	*str;
+	const char	*fmt;
 };
 
 static const struct error_info2 additional2[] =
@@ -377,20 +379,20 @@ EXPORT_SYMBOL(scsi_sense_key_string);
 const char *
 scsi_extd_sense_format(unsigned char asc, unsigned char ascq, const char **fmt)
 {
-	int i;
-	unsigned short code = ((asc << 8) | ascq);
+	u16 code = scsi_sense_code(asc, ascq);
 	unsigned offset = 0;
+	int i;
 
 	*fmt = NULL;
 	for (i = 0; i < ARRAY_SIZE(additional); i++) {
-		if (additional[i].code12 == code)
+		if (additional[i].code == code)
 			return additional_text + offset;
 		offset += additional[i].size;
 	}
 	for (i = 0; additional2[i].fmt; i++) {
-		if (additional2[i].code1 == asc &&
-		    ascq >= additional2[i].code2_min &&
-		    ascq <= additional2[i].code2_max) {
+		if (additional2[i].asc == asc &&
+		    ascq >= additional2[i].ascq_min &&
+		    ascq <= additional2[i].ascq_max) {
 			*fmt = additional2[i].fmt;
 			return additional2[i].str;
 		}
-- 
2.55.0

