From: adam radford <aradford@gmail.com>
Subject: [PATCH] 3ware scsi_dma_unmap fix
Date: Tue, 5 May 2009 11:45:37 -0700
Message-ID: <b1bc6a000905051145s411cea22r7decd68bac687bb8@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary=001e680f10604b1f5b04692eaf95
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from qw-out-2122.google.com ([74.125.92.25]:8499 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752579AbZEESph (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 5 May 2009 14:45:37 -0400
Received: by qw-out-2122.google.com with SMTP id 5so3800239qwd.37
        for <linux-scsi@vger.kernel.org>; Tue, 05 May 2009 11:45:37 -0700 (PDT)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@hansenpartnership.com>, linux-scsi <linux-scsi@vger.kernel.org>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>

--001e680f10604b1f5b04692eaf95
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

This patch for the 3w-9xxx driver is for 2.6.30-rc5.

This patch fixes the following regression the occurred during the
scsi_dma_map()/unmap() changes:

3w-9xxx 0001:45:00.0: DMA-API: device driver tries to free DMA memory
it has not allocated [device address=0x0000000000000000] [size=36
bytes]

James, could you please apply this?

Thanks,

-Adam

Signed-off-by: Adam Radford <aradford@gmail.com>

Note: This patch is included in-line below and also as an attachment
in case Gmail hoses the patch.

diff -Naur linux-2.6.30-rc4/drivers/scsi/3w-9xxx.c
linux-2.6.30-rc4.new/drivers/scsi/3w-9xxx.c
--- linux-2.6.30-rc4/drivers/scsi/3w-9xxx.c	2009-05-04 21:19:49.000000000 -0700
+++ linux-2.6.30-rc4.new/drivers/scsi/3w-9xxx.c	2009-05-04
21:23:59.000000000 -0700
@@ -1978,7 +1978,8 @@
 {
 	struct scsi_cmnd *cmd = tw_dev->srb[request_id];

-	scsi_dma_unmap(cmd);
+	if (cmd->SCp.phase == TW_PHASE_SGLIST)
+		scsi_dma_unmap(cmd);
 } /* End twa_unmap_scsi_data() */

 /* scsi_host_template initializer */

--001e680f10604b1f5b04692eaf95
Content-Type: text/x-patch; charset=US-ASCII; name="3ware_unmap.patch"
Content-Disposition: attachment; filename="3ware_unmap.patch"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_fucy7i920

ZGlmZiAtTmF1ciBsaW51eC0yLjYuMzAtcmM0L2RyaXZlcnMvc2NzaS8zdy05eHh4LmMgbGludXgt
Mi42LjMwLXJjNC5uZXcvZHJpdmVycy9zY3NpLzN3LTl4eHguYwotLS0gbGludXgtMi42LjMwLXJj
NC9kcml2ZXJzL3Njc2kvM3ctOXh4eC5jCTIwMDktMDUtMDQgMjE6MTk6NDkuMDAwMDAwMDAwIC0w
NzAwCisrKyBsaW51eC0yLjYuMzAtcmM0Lm5ldy9kcml2ZXJzL3Njc2kvM3ctOXh4eC5jCTIwMDkt
MDUtMDQgMjE6MjM6NTkuMDAwMDAwMDAwIC0wNzAwCkBAIC0xOTc4LDcgKzE5NzgsOCBAQAogewog
CXN0cnVjdCBzY3NpX2NtbmQgKmNtZCA9IHR3X2Rldi0+c3JiW3JlcXVlc3RfaWRdOwogCi0Jc2Nz
aV9kbWFfdW5tYXAoY21kKTsKKwlpZiAoY21kLT5TQ3AucGhhc2UgPT0gVFdfUEhBU0VfU0dMSVNU
KQorCQlzY3NpX2RtYV91bm1hcChjbWQpOwogfSAvKiBFbmQgdHdhX3VubWFwX3Njc2lfZGF0YSgp
ICovCiAKIC8qIHNjc2lfaG9zdF90ZW1wbGF0ZSBpbml0aWFsaXplciAqLwo=
--001e680f10604b1f5b04692eaf95--
