From: "Tony Battersby" <tonyb@cybernetics.com>
Subject: [PATCH 2.4] sym53c8xx_2 sniff inquiry fix
Date: Mon, 1 Nov 2004 16:26:02 -0500
Message-ID: <04Nov1.162539est.333210@cyborg.cybernetics.com>
Reply-To: <tonyb@cybernetics.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cyborg.cybernetics.com ([206.246.200.18]:25101 "EHLO
	cybernetics.com") by vger.kernel.org with ESMTP id S319844AbUKAVZk
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 1 Nov 2004 16:25:40 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: 'Marcelo Tosatti' <marcelo.tosatti@cyclades.com>
Cc: linux-scsi@vger.kernel.org

This is a resend of http://marc.theaimsgroup.com/?l=linux-scsi&m=108117878914404&w=2

The sym53c8xx_2 driver in lk 2.4.x is unmaintained.  This is a backported fix
from lk 2.6.x for a problem with sniffing inquiry data incorrectly resulting
in Ultra 160 negotiation being disabled for some devices.  Please apply.

--- linux-2.4.26-vanilla/drivers/scsi/sym53c8xx_2/sym_misc.c	Fri Nov  9 18:22:54 2001
+++ linux-2.4.26-asp/drivers/scsi/sym53c8xx_2/sym_misc.c	Wed Apr 28 14:02:41 2004
@@ -315,7 +315,7 @@
 	 */
 	inq_byte56 = tp->inq_byte56;
 	if (inq_version >= 4 && inq_len > 56)
-		tp->inq_byte56 = inq_data[56];
+		inq_byte56 = inq_data[56];
 #if 0
 printf("XXXXXX [%d] inq_version=%x inq_byte7=%x inq_byte56=%x XXXXX\n",
 	inq_len, inq_version, inq_byte7, inq_byte56);


Anthony J. Battersby
Cybernetics

