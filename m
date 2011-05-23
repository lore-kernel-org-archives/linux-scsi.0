From: akpm@linux-foundation.org
Subject: [patch 6/6] drivers/scsi/ultrastor.c: fix asm snippet
Date: Mon, 23 May 2011 15:29:15 -0700
Message-ID: <201105232229.p4NMTFGS016161@imap1.linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33163 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757826Ab1EWW3e (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 23 May 2011 18:29:34 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com
Cc: linux-scsi@vger.kernel.org, akpm@linux-foundation.org, samuel.thibault@ens-lyon.org, deweerdt@free.fr

From: Samuel Thibault <samuel.thibault@ens-lyon.org>

Commit 1292500b ("ultrastor: clean up inline asm warnings") replaced

"=m" (*field) : "1" (*field)

with

"=m" (*field) :

with comment "The following patch fixes it by using the '+' operator on
the (*field) operand, marking it as read-write to gcc."
'+' was actually forgotten.  This really puts it.

Signed-off-by: Samuel Thibault <samuel.thibault@ens-lyon.org>
Cc: Frederik Deweerdt <deweerdt@free.fr>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/scsi/ultrastor.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/scsi/ultrastor.c~drivers-scsi-ultrastorc-fix-asm-snippet drivers/scsi/ultrastor.c
--- a/drivers/scsi/ultrastor.c~drivers-scsi-ultrastorc-fix-asm-snippet
+++ a/drivers/scsi/ultrastor.c
@@ -307,7 +307,7 @@ static inline int find_and_clear_bit_16(
 	"0: bsfw %1,%w0\n\t"
 	"btr %0,%1\n\t"
 	"jnc 0b"
-	: "=&r" (rv), "=m" (*field) :);
+	: "=&r" (rv), "+m" (*field) :);
 
   return rv;
 }
_
