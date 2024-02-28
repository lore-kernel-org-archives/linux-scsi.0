Received: from mail-yb1-f201.google.com (mail-yb1-f201.google.com [209.85.219.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7EF0C7D089
	for <linux-scsi@vger.kernel.org>; Wed, 28 Feb 2024 22:59:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709161157; cv=none; b=gepQtXgNaOHkQbBEV05xl4Zciqi+ppZW+FEQR/AbE8InD9IUSpJi1cZru0sq36DNtz7qbErznUc7XLXv7x7CcUsN8H0HXvcNKD/Qkh8Tqn5SSHeR3nYRnj+vUP9ekOA1mYl7+KKvj/FP6R210mXo7PHI3/QirbJVM5bNT5Aj9cw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709161157; c=relaxed/simple;
	bh=Io+nFxT4E7uq3oa+gTgQDLCH4N9Pav1QHW8TI2laaBw=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=FDWgRbaThMvUS5oKtxW63KCVAfuarjlimeBdkQNkDKhuWgZ62Hy/KpGAIjh0+FNcCqibJ4yGVaDmzIzvZFZJ+SMdTqY/SH2Jnq4obpkVjGHo5fnRa4H7Bb1ee+aKNjxZ4Kji+FPCWk+3na3O6xops3iCnx3CGv4YwmocYi5lr0w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--justinstitt.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=nLUK2SDY; arc=none smtp.client-ip=209.85.219.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--justinstitt.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="nLUK2SDY"
Received: by mail-yb1-f201.google.com with SMTP id 3f1490d57ef6-dcbee93a3e1so510214276.3
        for <linux-scsi@vger.kernel.org>; Wed, 28 Feb 2024 14:59:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1709161154; x=1709765954; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=029VgwupM9kp4/rJ4YhPt46NqdIF7dbcYt6+f6FCaeA=;
        b=nLUK2SDYR9f4wM3Ilp7pFo9FXe8/1mlW6Y9JWTtS2vnb8UyFJ4F6ENmtu6kwNlo+tv
         xLgQtJXUYuyVUlulP8gGRxkDuTWDpBKw4rxVA+upqsvqJvDMc4YmopoBbWkM7Xbb0chc
         xsfxeyRIleFACkEIWJKDovNYyKYlWwiLhLXO8X0psdT10HAKkMGNuZB91U3AOtBhsBMh
         ZyzW2XLm3dUq1NzGsPW6DSMzNcw1fBT1BsesthEc3Wz3RlkQogDV4fdgs2wJ0klk8AVo
         KIQhrZX4j4YOTi6gBHhSFldbkVdlu0IMTIxM1xGuivTnWG0cEgXhud5xbN6lTNCwvGhR
         0h5Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1709161154; x=1709765954;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=029VgwupM9kp4/rJ4YhPt46NqdIF7dbcYt6+f6FCaeA=;
        b=O/WkZR9IxdNwrws3og5szVw2gvJ3jygRl8a9q7T0HP/iK25DvXSEFEDw2Bok/rfSgb
         fJhK1rIquq+2tCuz4uN15J8ulhSwo0qDRMGbDKKi8J1pgk8EyzMtJTtOeKU/1ZaK+R4+
         MINMoxlmzdacKlZAk19sKSuHIhFfB+NwDM77ksGovyHrtciIrGTIaNsd5Bty6lSm3yYW
         X8EM3ORYseGQcatD7iqGPOjwCgWKTlT2BNrADCn1KbCIQNaRpGWtHBNll2zaPbnkAuur
         zrK9u5gJt9EDeLv7yC796v5Ip4Od0UT1IZh7axbkpSOD3T76nCTTqn+C3fC8Trdjq9x4
         ThvA==
X-Forwarded-Encrypted: i=1; AJvYcCUfBmnApmb7PIyS0LfHfFhY3ep3TpBU01V8V4NXbSDglz8bWBVD+VeeecgyU67mPRS9vYbSZr4qe8yBsHHuK7sGh02XRh/zZSjMwg==
X-Gm-Message-State: AOJu0Yw3Li+oTee7ljOPB5Gr+RVcqZtwCXybNkTcwsc9ZCR/GMMkcim9
	W2sFP443gDn2N18wTYMoN9eWDFZjnT3GhzSjIIbRAq/gXkfJLim1e5JrwE+r1j417y2jFzA8SMF
	J2VcDxCaPoFiHi+uIGP1WkQ==
X-Google-Smtp-Source: AGHT+IE8CHH2ZbFt2Nyjerb9VaztYwBqnbx4azSDUzSp4wm8toq0f/VGly5E8xju5L+9FltTO2cUqMOgfh06WJY45Q==
X-Received: from jstitt-linux1.c.googlers.com ([fda3:e722:ac3:cc00:2b:ff92:c0a8:23b5])
 (user=justinstitt job=sendgmr) by 2002:a05:6902:72c:b0:dbe:a0c2:df25 with
 SMTP id l12-20020a056902072c00b00dbea0c2df25mr37594ybt.8.1709161154561; Wed,
 28 Feb 2024 14:59:14 -0800 (PST)
Date: Wed, 28 Feb 2024 22:59:04 +0000
In-Reply-To: <20240228-strncpy-drivers-scsi-mpi3mr-mpi3mr_fw-c-v2-0-dacebd3fcfa0@google.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240228-strncpy-drivers-scsi-mpi3mr-mpi3mr_fw-c-v2-0-dacebd3fcfa0@google.com>
X-Developer-Key: i=justinstitt@google.com; a=ed25519; pk=tC3hNkJQTpNX/gLKxTNQKDmiQl6QjBNCGKJINqAdJsE=
X-Developer-Signature: v=1; a=ed25519-sha256; t=1709161149; l=6776;
 i=justinstitt@google.com; s=20230717; h=from:subject:message-id;
 bh=Io+nFxT4E7uq3oa+gTgQDLCH4N9Pav1QHW8TI2laaBw=; b=RavFq/Ac1ON00tNzK0x+UUTHt7q8DWcWRD3Amt47SxWlWTgw/9YR+KHa+z1aXddNPXcl9IOzo
 mupkntUL54IARZhWMJwKGdYMpLxQj6/tzar8Q3IcXDy3c5ThGNjHavE
X-Mailer: b4 0.12.3
Message-ID: <20240228-strncpy-drivers-scsi-mpi3mr-mpi3mr_fw-c-v2-4-dacebd3fcfa0@google.com>
Subject: [PATCH v2 4/7] scsi: qla4xxx: replace deprecated strncpy with strscpy
From: Justin Stitt <justinstitt@google.com>
To: Sathya Prakash Veerichetty <sathya.prakash@broadcom.com>, Kashyap Desai <kashyap.desai@broadcom.com>, 
	Sumit Saxena <sumit.saxena@broadcom.com>, Sreekanth Reddy <sreekanth.reddy@broadcom.com>, 
	"James E.J. Bottomley" <jejb@linux.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, 
	Suganath Prabu Subramani <suganath-prabu.subramani@broadcom.com>, Ariel Elior <aelior@marvell.com>, 
	Manish Chopra <manishc@marvell.com>, "David S. Miller" <davem@davemloft.net>, 
	Eric Dumazet <edumazet@google.com>, Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>, 
	Saurav Kashyap <skashyap@marvell.com>, Javed Hasan <jhasan@marvell.com>, 
	GR-QLogic-Storage-Upstream@marvell.com, Nilesh Javali <njavali@marvell.com>, 
	Manish Rangankar <mrangankar@marvell.com>, Don Brace <don.brace@microchip.com>
Cc: mpi3mr-linuxdrv.pdl@broadcom.com, linux-scsi@vger.kernel.org, 
	linux-hardening@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Kees Cook <keescook@chromium.org>, MPT-FusionLinux.pdl@broadcom.com, 
	netdev@vger.kernel.org, storagedev@microchip.com, 
	Justin Stitt <justinstitt@google.com>
Content-Type: text/plain; charset="utf-8"

Replace 3 instances of strncpy in ql4_mbx.c

No bugs exist in the current implementation as some care was taken to
ensure the write length was decreased by one to leave some space for a
NUL-byte. However, instead of using strncpy(dest, src, LEN-1) we can opt
for strscpy(dest, src, sizeof(dest)) which will result in
NUL-termination as well. It should be noted that the entire chap_table
is zero-allocated so the NUL-padding provided by strncpy is not needed.

While here, I noticed that MIN_CHAP_SECRET_LEN was not used anywhere.
Since strscpy gives us the number of bytes copied into the destination
buffer (or an -E2BIG) we can check both for an error during copying and
also for a non-length compliant secret. Add a new jump label so we can
properly clean up our chap_table should we have to abort due to bad
secret.

The third instance in this file involves some more peculiar handling of
strings:
|	uint32_t mbox_cmd[MBOX_REG_COUNT];
|	...
|	memset(&mbox_cmd, 0, sizeof(mbox_cmd));
|	...
|	mbox_cmd[0] = MBOX_CMD_SET_PARAM;
|	if (param == SET_DRVR_VERSION) {
|		mbox_cmd[1] = SET_DRVR_VERSION;
|		strncpy((char *)&mbox_cmd[2], QLA4XXX_DRIVER_VERSION,
|			MAX_DRVR_VER_LEN - 1);

mbox_cmd has a size of 8:
|	#define MBOX_REG_COUNT 8
... and its type width is 4 bytes. Hence, we have 32 bytes to work with
here. The first 4 bytes are used as a flag for the MBOX_CMD_SET_PARAM.
The next 4 bytes are used for SET_DRVR_VERSION. We now have 32-8=24
bytes remaining -- which thankfully is what MAX_DRVR_VER_LEN is equal to
|	#define MAX_DRVR_VER_LEN                    24

... and the thing we're copying into this pseudo-string buffer is
|	#define QLA4XXX_DRIVER_VERSION        "5.04.00-k6"

... which is great because its less than 24 bytes (therefore we aren't
truncating the source).

All to say, there's no bug in the existing implementation (yay!) but we
can clean the code up a bit by using strscpy().

In ql4_os.c, there aren't any strncpy() uses to replace but there are
some existing strscpy() calls that could be made more idiomatic. Where
possible, use strscpy(dest, src, sizeof(dest)). Note that
chap_rec->password has a size of ISCSI_CHAP_AUTH_SECRET_MAX_LEN
|	#define ISCSI_CHAP_AUTH_SECRET_MAX_LEN	256
... while the current strscpy usage uses QL4_CHAP_MAX_SECRET_LEN
|	#define QL4_CHAP_MAX_SECRET_LEN 100
... however since chap_table->secret was set and bounded properly in its
string assignment its probably safe here to switch over to sizeof().

|	struct iscsi_chap_rec {
	...
|		char username[ISCSI_CHAP_AUTH_NAME_MAX_LEN];
|		uint8_t password[ISCSI_CHAP_AUTH_SECRET_MAX_LEN];
	...
|	};

|	strscpy(chap_rec->password, chap_table->secret,
|		QL4_CHAP_MAX_SECRET_LEN);

Signed-off-by: Justin Stitt <justinstitt@google.com>
---
 drivers/scsi/qla4xxx/ql4_mbx.c | 17 ++++++++++++-----
 drivers/scsi/qla4xxx/ql4_os.c  | 14 +++++++-------
 2 files changed, 19 insertions(+), 12 deletions(-)

diff --git a/drivers/scsi/qla4xxx/ql4_mbx.c b/drivers/scsi/qla4xxx/ql4_mbx.c
index 249f1d7021d4..75125d2021f5 100644
--- a/drivers/scsi/qla4xxx/ql4_mbx.c
+++ b/drivers/scsi/qla4xxx/ql4_mbx.c
@@ -1641,6 +1641,7 @@ int qla4xxx_set_chap(struct scsi_qla_host *ha, char *username, char *password,
 	struct ql4_chap_table *chap_table;
 	uint32_t chap_size = 0;
 	dma_addr_t chap_dma;
+	ssize_t secret_len;
 
 	chap_table = dma_pool_zalloc(ha->chap_dma_pool, GFP_KERNEL, &chap_dma);
 	if (chap_table == NULL) {
@@ -1652,9 +1653,13 @@ int qla4xxx_set_chap(struct scsi_qla_host *ha, char *username, char *password,
 		chap_table->flags |= BIT_6; /* peer */
 	else
 		chap_table->flags |= BIT_7; /* local */
-	chap_table->secret_len = strlen(password);
-	strncpy(chap_table->secret, password, MAX_CHAP_SECRET_LEN - 1);
-	strncpy(chap_table->name, username, MAX_CHAP_NAME_LEN - 1);
+
+	secret_len = strscpy(chap_table->secret, password,
+			     sizeof(chap_table->secret));
+	if (secret_len < MIN_CHAP_SECRET_LEN)
+		goto cleanup_chap_table;
+	chap_table->secret_len = (uint8_t)secret_len;
+	strscpy(chap_table->name, username, sizeof(chap_table->name));
 	chap_table->cookie = cpu_to_le16(CHAP_VALID_COOKIE);
 
 	if (is_qla40XX(ha)) {
@@ -1679,6 +1684,8 @@ int qla4xxx_set_chap(struct scsi_qla_host *ha, char *username, char *password,
 		memcpy((struct ql4_chap_table *)ha->chap_list + idx,
 		       chap_table, sizeof(struct ql4_chap_table));
 	}
+
+cleanup_chap_table:
 	dma_pool_free(ha->chap_dma_pool, chap_table, chap_dma);
 	if (rval != QLA_SUCCESS)
 		ret =  -EINVAL;
@@ -2281,8 +2288,8 @@ int qla4_8xxx_set_param(struct scsi_qla_host *ha, int param)
 	mbox_cmd[0] = MBOX_CMD_SET_PARAM;
 	if (param == SET_DRVR_VERSION) {
 		mbox_cmd[1] = SET_DRVR_VERSION;
-		strncpy((char *)&mbox_cmd[2], QLA4XXX_DRIVER_VERSION,
-			MAX_DRVR_VER_LEN - 1);
+		strscpy((char *)&mbox_cmd[2], QLA4XXX_DRIVER_VERSION,
+			MAX_DRVR_VER_LEN);
 	} else {
 		ql4_printk(KERN_ERR, ha, "%s: invalid parameter 0x%x\n",
 			   __func__, param);
diff --git a/drivers/scsi/qla4xxx/ql4_os.c b/drivers/scsi/qla4xxx/ql4_os.c
index 675332e49a7b..17cccd14765f 100644
--- a/drivers/scsi/qla4xxx/ql4_os.c
+++ b/drivers/scsi/qla4xxx/ql4_os.c
@@ -799,10 +799,10 @@ static int qla4xxx_get_chap_list(struct Scsi_Host *shost, uint16_t chap_tbl_idx,
 
 		chap_rec->chap_tbl_idx = i;
 		strscpy(chap_rec->username, chap_table->name,
-			ISCSI_CHAP_AUTH_NAME_MAX_LEN);
-		strscpy(chap_rec->password, chap_table->secret,
-			QL4_CHAP_MAX_SECRET_LEN);
-		chap_rec->password_length = chap_table->secret_len;
+			sizeof(chap_rec->username));
+		chap_rec->password_length = strscpy(chap_rec->password,
+						    chap_table->secret,
+						    sizeof(chap_rec->password));
 
 		if (chap_table->flags & BIT_7) /* local */
 			chap_rec->chap_type = CHAP_TYPE_OUT;
@@ -6291,8 +6291,8 @@ static void qla4xxx_get_param_ddb(struct ddb_entry *ddb_entry,
 
 	tddb->tpgt = sess->tpgt;
 	tddb->port = conn->persistent_port;
-	strscpy(tddb->iscsi_name, sess->targetname, ISCSI_NAME_SIZE);
-	strscpy(tddb->ip_addr, conn->persistent_address, DDB_IPADDR_LEN);
+	strscpy(tddb->iscsi_name, sess->targetname, sizeof(tddb->iscsi_name));
+	strscpy(tddb->ip_addr, conn->persistent_address, sizeof(tddb->ip_addr));
 }
 
 static void qla4xxx_convert_param_ddb(struct dev_db_entry *fw_ddb_entry,
@@ -7792,7 +7792,7 @@ static int qla4xxx_sysfs_ddb_logout(struct iscsi_bus_flash_session *fnode_sess,
 	}
 
 	strscpy(flash_tddb->iscsi_name, fnode_sess->targetname,
-		ISCSI_NAME_SIZE);
+		sizeof(flash_tddb->iscsi_name));
 
 	if (!strncmp(fnode_sess->portal_type, PORTAL_TYPE_IPV6, 4))
 		sprintf(flash_tddb->ip_addr, "%pI6", fnode_conn->ipaddress);

-- 
2.44.0.rc1.240.g4c46232300-goog

