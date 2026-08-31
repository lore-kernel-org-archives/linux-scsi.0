Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 924443515E3;
	Mon, 31 Aug 2026 02:05:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788141910; cv=none; b=hXNREPs8b0cGb8NqMG6+r8FMO4opuC3CjEHxTRyM0Wys6ru261pNCZR1BqhdlEYksl4PQ8OtUGnG2R/834FsDg1z75gmz7+l4YGQzHrsB73wqT4v4Xr00yCiusek5d0LGP0G/2nQE1eysvVQdTjEFCExlb9n2Kmn1LCckjadzMQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788141910; c=relaxed/simple;
	bh=AY/LFUzKJf9Nh/fTD9q7gzfd6v1/zmNuj89d5o+n0ZQ=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WGpUKrHXI2G0CKhzxzreuOeBd1RRSbXKwbvZ0ZOS5mixkp0LYT/XRR7XhU/Ujei32c7D2QqfJ6HBx27t3ujQ3VjZzrG4/4W4G260zTnS6l8lFBpq0Pn9MmuxODDz4ks1Niow9rH1U7K7JwYsjL3F6eUX4/dTDlXue5oXpOvRSR8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Gr+nfRA5; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Gr+nfRA5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 112A11F00A3D;
	Mon, 31 Aug 2026 02:05:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788141909;
	bh=0udnZc7ugionbCdSxj3ONlbTAQ4MVlX9BGpsCvjqTA8=;
	h=From:To:Subject:Date:In-Reply-To:References;
	b=Gr+nfRA5vo12zLbZQW8g6FKgGwO4gk0xIuAMpmh5jLybb94hvToxrBpr+lGL3lhY4
	 PfIQA81U3asLQYpoVWMQoqZkOqSo3Txo39YPe7ftTeY/yyIPC3QURtv47xt5qLdRtJ
	 +dpMoQcNKyFQmzMWQz3JZuPX+sfkC/RSSrlQXCd6dHJZzYIaGH4dpP8dv6dgSK+GU3
	 dvMpuUeVX7XPDLmg8me8kMSxRUiodWfD2SH8e+2VzdapoQ7mtNWWIIqoaiTIqwK2qP
	 r9jbjPuhVKAzWcO6XwhiOX2J9W5PrOvYW6ySZayGTHx43sE6koK3IxPhnseZ0fgffk
	 VimcD2hF+k0Sg==
From: Damien Le Moal <dlemoal@kernel.org>
To: "Martin K . Petersen" <martin.petersen@oracle.com>,
	"James E . J . Bottomley" <James.Bottomley@HansenPartnership.com>,
	linux-scsi@vger.kernel.org,
	linux-ide@vger.kernel.org,
	Niklas Cassel <cassel@kernel.org>,
	linux-usb@vger.kernel.org,
	Alan Stern <stern@rowland.harvard.edu>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH 03/37] scsi: constants: rename internal struct field names
Date: Mon, 31 Aug 2026 11:04:17 +0900
Message-ID: <20260831020451.585944-4-dlemoal@kernel.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260831020451.585944-1-dlemoal@kernel.org>
References: <20260831020451.585944-1-dlemoal@kernel.org>
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

