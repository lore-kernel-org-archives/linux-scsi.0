Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1AB9D4CB8C8;
	Tue,  8 Sep 2026 09:03:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788858213; cv=none; b=Jeif8a1OmUj2fPTVIRbNUH6C+v9HsM5rwMquD9vGkQJzeZPAJAbhIo+SzonY0DlG0v2o4AMEvPnuQ8yXY0ZU38va++U8pIbnoVQAmtxoNPcrI3E9RJPeArjWb+eyAyoGUz7LKEAUvuw2AZL6AFwJjgO50SKinEwIgQUiCLdfMV0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788858213; c=relaxed/simple;
	bh=d0BKpYQYyUXxmNO//sJDHXDYxWDloNJnwLbFh4ZAr9k=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EcsbcbO09wiE80Rw/PtEFFfNH5AvuO/p7qUfpirTXLM2hWx2Yq9Qu1QHZ29zpLn+44PgLQSkrE+OKrtGtf7xr7w+xYE4GM58JxPoGhQPu5Mt2UAJ2WcV0+7H9SXa5GWHDTAc1LrDzXG6J1Yp2jll5hmd0Iz63HtYZOKBgGGwQyc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=F0hdl/nO; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="F0hdl/nO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 41EB51F00A3E;
	Tue,  8 Sep 2026 09:03:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788858206;
	bh=jIegZQxuGFSajv7jyflim0CL+uooKIi0PxCUCQBYci8=;
	h=From:To:Subject:Date:In-Reply-To:References;
	b=F0hdl/nOB2j6Le485IujfueGDf/ZzTyRyGBgb/PbT5FA4mgpgzJoKfbUtPVaAhTeB
	 QCkqGQ8bb5TKuJnMGJRPdbrwlT4teS6I5Pc9YDlTNSrglkda4XxKsHEfginhgHLqRx
	 1WbBkrQ7xYsLmlziScd4i61JLkLLX4p7H0kXfUKs6eVYOqImAorULEvFKxT4+PK6B2
	 AlOvncd2wo/mkQBEZu132FwLQu4EmM76RDSGWiTztmqBOgk6rzsLYY5E8SZziB9pJ/
	 B72iYiaPHKYoInFteAt3LV8LbwnZN8X0s0AmfKWZKb/4l9KsmHB2iulyXDz60Z86ir
	 LQTcD3LDYD2fA==
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
Subject: [PATCH v6 03/40] scsi: constants: rename internal struct field names
Date: Tue,  8 Sep 2026 18:02:31 +0900
Message-ID: <20260908090308.1085097-4-dlemoal@kernel.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260908090308.1085097-1-dlemoal@kernel.org>
References: <20260908090308.1085097-1-dlemoal@kernel.org>
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
Reviewed-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
Reviewed-by: Hannes Reinecke <hare@kernel.org>
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

