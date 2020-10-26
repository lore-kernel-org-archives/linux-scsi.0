Return-Path: <SRS0=a792=EB=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AD709C2D0A3
	for <linux-scsi@archiver.kernel.org>; Mon, 26 Oct 2020 16:07:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6A01A20760
	for <linux-scsi@archiver.kernel.org>; Mon, 26 Oct 2020 16:07:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1603728450;
	bh=vganNX6Aeeca1D9Zt1my2hxu7xQPLJXxYto20gsAqo0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=CiaA83Tgi9PVflJAYYXCJptRlFnV6qR0dZ3RP3AWI9xzu4IuEhq4JBijSEV+3VSUk
	 kRdk36Cb6N82gdrprN9GM+BRrQNz+WQEjjTooF23GuLBQVpCSrxioP/L3JMOalmvDY
	 2WtO8WCLRl8FWW0DdvKQHF56RBrd+V3PdVjpXZ8A=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1784977AbgJZQH1 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 26 Oct 2020 12:07:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:53602 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1784973AbgJZQH1 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 26 Oct 2020 12:07:27 -0400
Received: from localhost.localdomain (unknown [192.30.34.233])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C9E6A2072C;
        Mon, 26 Oct 2020 16:07:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603728446;
        bh=vganNX6Aeeca1D9Zt1my2hxu7xQPLJXxYto20gsAqo0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1JfCOLY9SvloVZ7+VHlhbeq3ImiDk8ALfrpC+f8AM4JD73vQlYnUc4z8iNx8R38sT
         aLTmMkqrsTy3DAVrkVLFvw0hKt7Zm+2ejkcM4+UN2b6U1shwszLQEEFnd7SrPgqbsq
         b07hBv3gQCHXQlJNwKhNdhlgmhBpFs1Fg5kOU+DA=
From:   Arnd Bergmann <arnd@kernel.org>
To:     Hannes Reinecke <hare@suse.de>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     Arnd Bergmann <arnd@arndb.de>, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 2/2] libfc: work around Warray-bounds warning
Date:   Mon, 26 Oct 2020 17:06:13 +0100
Message-Id: <20201026160705.3706396-2-arnd@kernel.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20201026160705.3706396-1-arnd@kernel.org>
References: <20201026160705.3706396-1-arnd@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Arnd Bergmann <arnd@arndb.de>

Building libfc with gcc -Warray-bounds identifies a number of
cases in one file where a strncpy() is performed into a single-byte
character array:

In file included from include/linux/bitmap.h:9,
                 from include/linux/cpumask.h:12,
                 from include/linux/smp.h:13,
                 from include/linux/lockdep.h:14,
                 from include/linux/spinlock.h:59,
                 from include/linux/debugobjects.h:6,
                 from include/linux/timer.h:8,
                 from include/scsi/libfc.h:11,
                 from drivers/scsi/libfc/fc_elsct.c:17:
In function 'strncpy',
    inlined from 'fc_ct_ms_fill.constprop' at drivers/scsi/libfc/fc_encode.h:235:3:
include/linux/string.h:290:30: warning: '__builtin_strncpy' offset [56, 135] from the object at 'pp' is out of the bounds of referenced subobject 'value' with type '__u8[1]' {aka 'unsigned char[1]'} at offset 56 [-Warray-bounds]
  290 | #define __underlying_strncpy __builtin_strncpy
      |                              ^
include/linux/string.h:300:9: note: in expansion of macro '__underlying_strncpy'
  300 |  return __underlying_strncpy(p, q, size);
      |         ^~~~~~~~~~~~~~~~~~~~

This is not a bug because the 1-byte array is used as an odd way
to express a variable-length data field here. I tried to convert
it to a flexible-array member, but in the end could not figure out
why the sizeof(struct fc_fdmi_???) are used the way they are, and
how to properly convert those.

Work around this instead by abstracting the string copy
in a slightly higher-level function fc_ct_hdr_fill() helper
that strscpy() and memset() to achieve the same result as
strncpy() but does not require a zero-terminated input
and does not get checked for the array overflow because
gcc (so far) does not understand the behavior of strscpy().

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 drivers/scsi/libfc/fc_encode.h | 30 +++++++++++++++++++-----------
 1 file changed, 19 insertions(+), 11 deletions(-)

diff --git a/drivers/scsi/libfc/fc_encode.h b/drivers/scsi/libfc/fc_encode.h
index 18203cae04b2..602c97a651bc 100644
--- a/drivers/scsi/libfc/fc_encode.h
+++ b/drivers/scsi/libfc/fc_encode.h
@@ -163,6 +163,14 @@ static inline int fc_ct_ns_fill(struct fc_lport *lport,
 	return 0;
 }
 
+static inline void fc_ct_ms_fill_attr(struct fc_fdmi_attr_entry *entry,
+				    const char *in, size_t len)
+{
+	int copied = strscpy(entry->value, in, len);
+	if (copied > 0)
+		memset(entry->value, copied, len - copied);
+}
+
 /**
  * fc_ct_ms_fill() - Fill in a mgmt service request frame
  * @lport: local port.
@@ -232,7 +240,7 @@ static inline int fc_ct_ms_fill(struct fc_lport *lport,
 		put_unaligned_be16(FC_FDMI_HBA_ATTR_MANUFACTURER,
 				   &entry->type);
 		put_unaligned_be16(len, &entry->len);
-		strncpy((char *)&entry->value,
+		fc_ct_ms_fill_attr(entry,
 			fc_host_manufacturer(lport->host),
 			FC_FDMI_HBA_ATTR_MANUFACTURER_LEN);
 
@@ -244,7 +252,7 @@ static inline int fc_ct_ms_fill(struct fc_lport *lport,
 		put_unaligned_be16(FC_FDMI_HBA_ATTR_SERIALNUMBER,
 				   &entry->type);
 		put_unaligned_be16(len, &entry->len);
-		strncpy((char *)&entry->value,
+		fc_ct_ms_fill_attr(entry,
 			fc_host_serial_number(lport->host),
 			FC_FDMI_HBA_ATTR_SERIALNUMBER_LEN);
 
@@ -256,7 +264,7 @@ static inline int fc_ct_ms_fill(struct fc_lport *lport,
 		put_unaligned_be16(FC_FDMI_HBA_ATTR_MODEL,
 				   &entry->type);
 		put_unaligned_be16(len, &entry->len);
-		strncpy((char *)&entry->value,
+		fc_ct_ms_fill_attr(entry,
 			fc_host_model(lport->host),
 			FC_FDMI_HBA_ATTR_MODEL_LEN);
 
@@ -268,7 +276,7 @@ static inline int fc_ct_ms_fill(struct fc_lport *lport,
 		put_unaligned_be16(FC_FDMI_HBA_ATTR_MODELDESCRIPTION,
 				   &entry->type);
 		put_unaligned_be16(len, &entry->len);
-		strncpy((char *)&entry->value,
+		fc_ct_ms_fill_attr(entry,
 			fc_host_model_description(lport->host),
 			FC_FDMI_HBA_ATTR_MODELDESCR_LEN);
 
@@ -280,7 +288,7 @@ static inline int fc_ct_ms_fill(struct fc_lport *lport,
 		put_unaligned_be16(FC_FDMI_HBA_ATTR_HARDWAREVERSION,
 				   &entry->type);
 		put_unaligned_be16(len, &entry->len);
-		strncpy((char *)&entry->value,
+		fc_ct_ms_fill_attr(entry,
 			fc_host_hardware_version(lport->host),
 			FC_FDMI_HBA_ATTR_HARDWAREVERSION_LEN);
 
@@ -292,7 +300,7 @@ static inline int fc_ct_ms_fill(struct fc_lport *lport,
 		put_unaligned_be16(FC_FDMI_HBA_ATTR_DRIVERVERSION,
 				   &entry->type);
 		put_unaligned_be16(len, &entry->len);
-		strncpy((char *)&entry->value,
+		fc_ct_ms_fill_attr(entry,
 			fc_host_driver_version(lport->host),
 			FC_FDMI_HBA_ATTR_DRIVERVERSION_LEN);
 
@@ -304,7 +312,7 @@ static inline int fc_ct_ms_fill(struct fc_lport *lport,
 		put_unaligned_be16(FC_FDMI_HBA_ATTR_OPTIONROMVERSION,
 				   &entry->type);
 		put_unaligned_be16(len, &entry->len);
-		strncpy((char *)&entry->value,
+		fc_ct_ms_fill_attr(entry,
 			fc_host_optionrom_version(lport->host),
 			FC_FDMI_HBA_ATTR_OPTIONROMVERSION_LEN);
 
@@ -316,7 +324,7 @@ static inline int fc_ct_ms_fill(struct fc_lport *lport,
 		put_unaligned_be16(FC_FDMI_HBA_ATTR_FIRMWAREVERSION,
 				   &entry->type);
 		put_unaligned_be16(len, &entry->len);
-		strncpy((char *)&entry->value,
+		fc_ct_ms_fill_attr(entry,
 			fc_host_firmware_version(lport->host),
 			FC_FDMI_HBA_ATTR_FIRMWAREVERSION_LEN);
 
@@ -411,7 +419,7 @@ static inline int fc_ct_ms_fill(struct fc_lport *lport,
 				   &entry->type);
 		put_unaligned_be16(len, &entry->len);
 		/* Use the sysfs device name */
-		strncpy((char *)&entry->value,
+		fc_ct_ms_fill_attr(entry,
 			dev_name(&lport->host->shost_gendev),
 			strnlen(dev_name(&lport->host->shost_gendev),
 				FC_FDMI_PORT_ATTR_HOSTNAME_LEN));
@@ -425,12 +433,12 @@ static inline int fc_ct_ms_fill(struct fc_lport *lport,
 				   &entry->type);
 		put_unaligned_be16(len, &entry->len);
 		if (strlen(fc_host_system_hostname(lport->host)))
-			strncpy((char *)&entry->value,
+			fc_ct_ms_fill_attr(entry,
 				fc_host_system_hostname(lport->host),
 				strnlen(fc_host_system_hostname(lport->host),
 					FC_FDMI_PORT_ATTR_HOSTNAME_LEN));
 		else
-			strncpy((char *)&entry->value,
+			fc_ct_ms_fill_attr(entry,
 				init_utsname()->nodename,
 				FC_FDMI_PORT_ATTR_HOSTNAME_LEN);
 		break;
-- 
2.27.0

