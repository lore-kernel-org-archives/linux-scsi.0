Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A521BE6F
	for <linux-scsi@vger.kernel.org>; Mon, 26 Aug 2024 03:20:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.187
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724642411; cv=none; b=hjLait4o65C7m5LOCbZaG9wReYYaZfaJdjtGC3QEAJWvudUaxc5oSvmH+YJt4zvocbrPHM+x1AteC5JasbA+VaYbR1ivcliEDUDe0+2deu4jAOuNRcttG3BwoqbhtRGLj0/JTq4vWnmkhPogm+E9B6CXZbLBOx3U5szoKTtFB0g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724642411; c=relaxed/simple;
	bh=R5p6S9XzeSTEM9RnQKvsW2aPh/+uxAwngAm9u3xj9M0=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=CmESBhjYlIikGmw8/bIBhLga0e7UT7ECsTDbBZ36/JDckmxmd/8H7Z7tXyX1o2nVS6HFsQUrCcRK2QedMpAqf6idjAg8NN4DoC+d5GTys5ZakZB2AvU6cOxHJLVyyaN/yC0eG5SblzvmcMAars3FLjzfkY3iqbgXb3L9I4eZcN4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.187
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.163.48])
	by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4WsbWF2lBqzpVrV;
	Mon, 26 Aug 2024 11:19:21 +0800 (CST)
Received: from kwepemd200011.china.huawei.com (unknown [7.221.188.251])
	by mail.maildlp.com (Postfix) with ESMTPS id C479518006C;
	Mon, 26 Aug 2024 11:20:06 +0800 (CST)
Received: from cgs.huawei.com (10.244.148.83) by
 kwepemd200011.china.huawei.com (7.221.188.251) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1258.34; Mon, 26 Aug 2024 11:20:06 +0800
From: Gaosheng Cui <cuigaosheng1@huawei.com>
To: <James.Bottomley@HansenPartnership.com>, <martin.petersen@oracle.com>,
	<cuigaosheng1@huawei.com>
CC: <linux-scsi@vger.kernel.org>
Subject: [PATCH -next] scsi: core: Remove obsoleted declaration for scsi_driverbyte_string
Date: Mon, 26 Aug 2024 11:20:05 +0800
Message-ID: <20240826032005.4007834-1-cuigaosheng1@huawei.com>
X-Mailer: git-send-email 2.25.1
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: dggems706-chm.china.huawei.com (10.3.19.183) To
 kwepemd200011.china.huawei.com (7.221.188.251)

The scsi_driverbyte_string() have been removed since
commit 54c29086195f ("scsi: core: Drop the now obsolete driver_byte
definitions"), and now it is useless, so remove it.

Signed-off-by: Gaosheng Cui <cuigaosheng1@huawei.com>
---
 include/scsi/scsi_dbg.h | 7 -------
 1 file changed, 7 deletions(-)

diff --git a/include/scsi/scsi_dbg.h b/include/scsi/scsi_dbg.h
index 7b196d234626..bd29cdb513a5 100644
--- a/include/scsi/scsi_dbg.h
+++ b/include/scsi/scsi_dbg.h
@@ -24,7 +24,6 @@ extern const char *scsi_extd_sense_format(unsigned char, unsigned char,
 					  const char **);
 extern const char *scsi_mlreturn_string(int);
 extern const char *scsi_hostbyte_string(int);
-extern const char *scsi_driverbyte_string(int);
 #else
 static inline bool
 scsi_opcode_sa_name(int cmd, int sa,
@@ -76,12 +75,6 @@ scsi_hostbyte_string(int result)
 	return NULL;
 }
 
-static inline const char *
-scsi_driverbyte_string(int result)
-{
-	return NULL;
-}
-
 #endif
 
 #endif /* _SCSI_SCSI_DBG_H */
-- 
2.25.1

