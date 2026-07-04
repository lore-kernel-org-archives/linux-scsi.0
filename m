Received: from cstnet.cn (smtp25.cstnet.cn [159.226.251.25])
	(using TLSv1.2 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 03006208D0;
	Sat,  4 Jul 2026 01:06:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=159.226.251.25
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783127186; cv=none; b=Q2GdSJPSoxaYnajPzQ79qee2MfPN4FW0qZ6kukR/3zRh10Ay1cIWiOflj8okQiQk0MTtERdKGrBraNxCfxHF3O9xUt7SBl/Nf+fFivVQxBqa9Gb+8LvZOYXQ+8SwYentCgPf1ohABKvw9nvaToH2VrQiHwXy4Xm/eyh7RJ8Dunw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783127186; c=relaxed/simple;
	bh=F89fdDAs+kAGb936oj/nK0HqJpAaWQWF4Eruo4NSst0=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=RsaCS2DOpWJ8O+R8KaD2Er/0C6PiRkVH/SwQZ/9bCGKPHWDTIP+uXkLwzbRlbwNJ8it3+E+NeeAgkQBa2OlZyUvml0h4HoSfT47kZG/YM1HU1DBGeoL6zcC6owd+b7bX+tDoHHKNyfFcUIii6YEDTHTo1/3Qa/i4J4EUNhJeI2Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=iscas.ac.cn; spf=pass smtp.mailfrom=iscas.ac.cn; arc=none smtp.client-ip=159.226.251.25
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=iscas.ac.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=iscas.ac.cn
Received: from localhost.localdomain (unknown [111.196.245.140])
	by APP-05 (Coremail) with SMTP id zQCowAD3RMiNXEhqLIPEFg--.57380S2;
	Sat, 04 Jul 2026 09:06:21 +0800 (CST)
From: Pengpeng Hou <pengpeng@iscas.ac.cn>
To: Adam Radford <aradford@gmail.com>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Pengpeng Hou <pengpeng@iscas.ac.cn>
Subject: [PATCH] scsi: 3w-sas: bound firmware error string parsing
Date: Sat,  4 Jul 2026 09:06:19 +0800
Message-ID: <20260704010619.81878-1-pengpeng@iscas.ac.cn>
X-Mailer: git-send-email 2.50.1
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:zQCowAD3RMiNXEhqLIPEFg--.57380S2
X-Coremail-Antispam: 1UD129KBjvJXoWxJF4kKw1kJw18Ar48CF1rJFb_yoW5XrW8pw
	4FgasxJryUJw13ArnxJw1UAr45Cas2yFWFg34rZ34IqrWUGr1YyFySkr18uFyUKryxAw42
	qrsYk39xCF1kArJanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUkE14x267AKxVWUJVW8JwAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
	rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2ocxC64kIII0Yj41l84x0c7CEw4AK67xGY2AK02
	1l84ACjcxK6xIIjxv20xvE14v26r4j6ryUM28EF7xvwVC0I7IYx2IY6xkF7I0E14v26r4j
	6F4UM28EF7xvwVC2z280aVAFwI0_Gr1j6F4UJwA2z4x0Y4vEx4A2jsIEc7CjxVAFwI0_Gr
	1j6F4UJwAS0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC0VAKzVAqx4xG6I80ewAv
	7VC0I7IYx2IY67AKxVWUGVWUXwAv7VC2z280aVAFwI0_Jr0_Gr1lOx8S6xCaFVCjc4AY6r
	1j6r4UM4x0Y48IcxkI7VAKI48JM4x0x7Aq67IIx4CEVc8vx2IErcIFxwCY1x0262kKe7AK
	xVWUAVWUtwCF04k20xvY0x0EwIxGrwCFx2IqxVCFs4IE7xkEbVWUJVW8JwC20s026c02F4
	0E14v26r1j6r18MI8I3I0E7480Y4vE14v26r106r1rMI8E67AF67kF1VAFwI0_JF0_Jw1l
	IxkGc2Ij64vIr41lIxAIcVC0I7IYx2IY67AKxVWUJVWUCwCI42IY6xIIjxv20xvEc7CjxV
	AFwI0_Gr0_Cr1lIxAIcVCF04k26cxKx2IYs7xG6r1j6r1xMIIF0xvEx4A2jsIE14v26r1j
	6r4UMIIF0xvEx4A2jsIEc7CjxVAFwI0_Gr0_Gr1UYxBIdaVFxhVjvjDU0xZFpf9x0JUBmh
	wUUUUU=
X-CM-SenderInfo: pshqw1xhqjqxpvfd2hldfou0/

3w-sas parses two NUL-separated firmware strings from the fixed
err_specific_desc[] field.  The AEN and sense paths locate the second
string with strlen(first) + 1 before guaranteeing that the first
string is terminated inside the array.

Force a terminator in the fixed field before parsing, use strnlen()
for the first and optional second strings, and copy only the bytes
known to reside in err_specific_desc[].

Signed-off-by: Pengpeng Hou <pengpeng@iscas.ac.cn>
---
 drivers/scsi/3w-sas.c | 28 +++++++++++++++++++++++-----
 1 file changed, 23 insertions(+), 5 deletions(-)

--- a/drivers/scsi/3w-sas.c
+++ b/drivers/scsi/3w-sas.c
@@ -227,6 +227,7 @@
 	unsigned short aen;
 	char host[16];
 	char *error_str;
+	size_t desc_len, error_len;
 
 	tw_dev->aen_count++;
 
@@ -250,11 +251,21 @@
 	tw_dev->error_sequence_id++;
 
 	/* Check for embedded error string */
-	error_str = &(header->err_specific_desc[strlen(header->err_specific_desc)+1]);
-
 	header->err_specific_desc[sizeof(header->err_specific_desc) - 1] = '\0';
-	event->parameter_len = strlen(header->err_specific_desc);
-	memcpy(event->parameter_data, header->err_specific_desc, event->parameter_len + 1 + strlen(error_str));
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
 		printk(KERN_WARNING "3w-sas:%s AEN: %s (0x%02X:0x%04X): %s:%s.\n",
 		       host,
@@ -862,12 +873,19 @@
 	TW_Command_Full *full_command_packet;
 	unsigned short error;
 	char *error_str;
+	size_t desc_len;
 
 	header = tw_dev->sense_buffer_virt[i];
 	full_command_packet = tw_dev->command_packet_virt[request_id];
 
 	/* Get embedded firmware error string */
-	error_str = &(header->err_specific_desc[strlen(header->err_specific_desc) + 1]);
+	header->err_specific_desc[sizeof(header->err_specific_desc) - 1] = '\0';
+	desc_len = strnlen(header->err_specific_desc,
+			   sizeof(header->err_specific_desc));
+	if (desc_len + 1 < sizeof(header->err_specific_desc))
+		error_str = &header->err_specific_desc[desc_len + 1];
+	else
+		error_str = "";
 
 	/* Don't print error for Logical unit not supported during rollcall */
 	error = le16_to_cpu(header->status_block.error);

