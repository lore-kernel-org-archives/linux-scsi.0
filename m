From: "Salyzyn, Mark" <mark_salyzyn@adaptec.com>
Subject: RE: 2.6.13.2 aacraid regression
Date: Wed, 5 Oct 2005 12:58:38 -0400
Message-ID: <547AF3BD0F3F0B4CBDC379BAC7E4189F01B02355@otce2k03.adaptec.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1030251AbVJEQ6l@vger.kernel.org>
content-class: urn:content-classes:message
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: linux-scsi@vger.kernel.org, Juan D Ch <jchimienti@most.com.ar>, Mark Haverkamp <markh@osdl.org>, Martin Drab <drab@kepler.fjfi.cvut.cz>
List-Id: linux-scsi@vger.kernel.org

Juan was kind enough to linger on site, and work on a production
machine, to try the parameter to make the system stable. He discovered
that reducing the maximum transfer size issued to the adapter to 128KB
stabilized his system. This is related to an earlier change for the
2.6.13 tree resulting from Martin Drab's testing where the transfer size
was reduced from 4G to 256KB; we needed to go still further in scaling
back the request size.

Here is the patch that tames this regression.

Applies to the 2.6.13.2 tree.

Signed-off-by: Mark Salyzyn <aacraid@adaptec.com>

Index: linux-2.6.13.2/drivers/scsi/aacraid/aacraid.h
===================================================================
--- linux-2.6.13.2/drivers/scsi/aacraid/aacraid.h       2005-10-05
12:45:16 -0400
+++ linux-2.6.13.2-aacraid-fix/drivers/scsi/aacraid/aacraid.h
2005-09-16 21:02:12 -0400
@@ -15,7 +15,7 @@
 #define AAC_MAX_LUN            (8)

 #define AAC_MAX_HOSTPHYSMEMPAGES (0xfffff)
-#define AAC_MAX_32BIT_SGBCOUNT ((unsigned short)512)
+#define AAC_MAX_32BIT_SGBCOUNT ((unsigned short)256)

 /*
  * These macros convert from physical channels to virtual channels

Sincerely -- Mark Salyzyn
