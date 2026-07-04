Received: from cstnet.cn (smtp25.cstnet.cn [159.226.251.25])
	(using TLSv1.2 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C97E6208D0;
	Sat,  4 Jul 2026 01:05:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=159.226.251.25
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783127126; cv=none; b=CL9WJ/nNlaYTnwtTXs9QL95lpytwvC/PsO8GftHsdX20cHOWHEP8uV5K39vAWVmGu3uNjSb4nuf2rBSf+XubPAUrqX5A8aN6qNAD9O6DqxB5Z7Nzk5o3NhbThQIU9wqXbxsI555Tl8ZqjVGQZ5+RlTu3uVFYKvNPUkRB19Cm8co=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783127126; c=relaxed/simple;
	bh=BwzzBXIBWIkwqtOfFOfqLkVwvbI0NAjW7KWjZfiJBUo=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=bE1sUX0jhN5ofbIq0KRP5sstmDzcDiyTr7gzKrwenb9mAQ8ALC2WxJ6UmDcTjMi0Wc98xjlYoidT6HAMdmwHwuHkWYjhD24mrnTHQbxusdZWl3QGwK2hzEEgJWRupjhl8k7m5vnWuVgTxPAwWUH725zvAdJ/M0Nfui1XEt2jaw4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=iscas.ac.cn; spf=pass smtp.mailfrom=iscas.ac.cn; arc=none smtp.client-ip=159.226.251.25
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=iscas.ac.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=iscas.ac.cn
Received: from localhost.localdomain (unknown [111.196.245.140])
	by APP-05 (Coremail) with SMTP id zQCowAC3Gt5KXEhqV3rEFg--.5395S2;
	Sat, 04 Jul 2026 09:05:14 +0800 (CST)
From: Pengpeng Hou <pengpeng@iscas.ac.cn>
To: Adam Radford <aradford@gmail.com>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Pengpeng Hou <pengpeng@iscas.ac.cn>
Subject: [PATCH] scsi: 3w-9xxx: bound firmware error string parsing
Date: Sat,  4 Jul 2026 09:05:12 +0800
Message-ID: <20260704010512.71912-1-pengpeng@iscas.ac.cn>
X-Mailer: git-send-email 2.50.1
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:zQCowAC3Gt5KXEhqV3rEFg--.5395S2
X-Coremail-Antispam: 1UD129KBjvJXoWxGryxCFy8KF43urW5CF13CFg_yoW5Ww17pw
	40gasxJr1UJw15ArnxW34UAr45Ga92yFZYg345Za4Iqr4UGrn0vFW2kr18uFyjgrnrAw4x
	Xrs5K39xCFs7A3DanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUkK14x267AKxVWUJVW8JwAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
	rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2ocxC64kIII0Yj41l84x0c7CEw4AK67xGY2AK02
	1l84ACjcxK6xIIjxv20xvE14v26r1I6r4UM28EF7xvwVC0I7IYx2IY6xkF7I0E14v26r4j
	6F4UM28EF7xvwVC2z280aVAFwI0_Gr1j6F4UJwA2z4x0Y4vEx4A2jsIEc7CjxVAFwI0_Gr
	1j6F4UJwAS0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC0VAKzVAqx4xG6I80ewAv
	7VC0I7IYx2IY67AKxVWUJVWUGwAv7VC2z280aVAFwI0_Jr0_Gr1lOx8S6xCaFVCjc4AY6r
	1j6r4UM4x0Y48IcxkI7VAKI48JM4x0x7Aq67IIx4CEVc8vx2IErcIFxwCY1x0262kKe7AK
	xVWUAVWUtwCF04k20xvY0x0EwIxGrwCFx2IqxVCFs4IE7xkEbVWUJVW8JwC20s026c02F4
	0E14v26r1j6r18MI8I3I0E7480Y4vE14v26r106r1rMI8E67AF67kF1VAFwI0_JF0_Jw1l
	IxkGc2Ij64vIr41lIxAIcVC0I7IYx2IY67AKxVWUJVWUCwCI42IY6xIIjxv20xvEc7CjxV
	AFwI0_Jr0_Gr1lIxAIcVCF04k26cxKx2IYs7xG6r1j6r1xMIIF0xvEx4A2jsIE14v26r1j
	6r4UMIIF0xvEx4A2jsIEc7CjxVAFwI0_Jr0_GrUvcSsGvfC2KfnxnUUI43ZEXa7VUjuHq7
	UUUUU==
X-CM-SenderInfo: pshqw1xhqjqxpvfd2hldfou0/

3w-9xxx parses two NUL-separated firmware strings from
err_specific_desc[].  Both the AEN path and the sense-print path call
strlen() on the firmware buffer before forcing a terminator at the
end of the fixed array.  If firmware provides an unterminated first
string, strlen() can walk beyond err_specific_desc[].

Terminate the fixed firmware field before parsing it, use strnlen()
within the field bounds, and only expose the optional second string
when it starts inside the same array.

Signed-off-by: Pengpeng Hou <pengpeng@iscas.ac.cn>
---
 drivers/scsi/3w-9xxx.c | 30 +++++++++++++++++++++++++-----
 1 file changed, 25 insertions(+), 5 deletions(-)

--- a/drivers/scsi/3w-9xxx.c
+++ b/drivers/scsi/3w-9xxx.c
@@ -377,6 +377,7 @@
 	unsigned short aen;
 	char host[16];
 	char *error_str;
+	size_t desc_len, error_len;
 
 	tw_dev->aen_count++;
 
@@ -404,11 +405,21 @@
 	tw_dev->error_sequence_id++;
 
 	/* Check for embedded error string */
-	error_str = &(header->err_specific_desc[strlen(header->err_specific_desc)+1]);
-
 	header->err_specific_desc[sizeof(header->err_specific_desc) - 1] = '\0';
-	event->parameter_len = strlen(header->err_specific_desc);
-	memcpy(event->parameter_data, header->err_specific_desc, event->parameter_len + (error_str[0] == '\0' ? 0 : (1 + strlen(error_str))));
+	desc_len = strnlen(header->err_specific_desc,
+			   sizeof(header->err_specific_desc));
+	error_str = "";
+	error_len = 0;
+	if (desc_len + 1 < sizeof(header->err_specific_desc)) {
+		error_str = &header->err_specific_desc[desc_len + 1];
+		error_len = strnlen(error_str,
+				    sizeof(header->err_specific_desc) -
+				    desc_len - 1);
+	}
+
+	event->parameter_len = desc_len;
+	memcpy(event->parameter_data, header->err_specific_desc,
+	       desc_len + (error_len ? 1 + error_len : 0));
 	if (event->severity != TW_AEN_SEVERITY_DEBUG)
 		printk(KERN_WARNING "3w-9xxx:%s AEN: %s (0x%02X:0x%04X): %s:%s.\n",
 		       host,
@@ -993,11 +1004,20 @@
 	unsigned short error;
 	int retval = 1;
 	char *error_str;
+	char *desc;
+	size_t desc_len;
 
 	full_command_packet = tw_dev->command_packet_virt[request_id];
 
 	/* Check for embedded error string */
-	error_str = &(full_command_packet->header.err_specific_desc[strlen(full_command_packet->header.err_specific_desc) + 1]);
+	desc = full_command_packet->header.err_specific_desc;
+	desc[sizeof(full_command_packet->header.err_specific_desc) - 1] = '\0';
+	desc_len = strnlen(desc,
+			   sizeof(full_command_packet->header.err_specific_desc));
+	if (desc_len + 1 < sizeof(full_command_packet->header.err_specific_desc))
+		error_str = &desc[desc_len + 1];
+	else
+		error_str = "";
 
 	/* Don't print error for Logical unit not supported during rollcall */
 	error = le16_to_cpu(full_command_packet->header.status_block.error);

