From: Christoph Hellwig <hch@infradead.org>
Subject: Re: Patch: s390 root on scsi disc
Date: Sat, 19 Jun 2004 15:27:38 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040619142738.GA6062@infradead.org>
References: <1087661628.26436.30.camel@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from [213.146.154.40] ([213.146.154.40]:27854 "EHLO
	pentafluge.infradead.org") by vger.kernel.org with ESMTP
	id S262388AbUFSO1j (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 19 Jun 2004 10:27:39 -0400
Content-Disposition: inline
In-Reply-To: <1087661628.26436.30.camel@localhost>
List-Id: linux-scsi@vger.kernel.org
To: Stefan =?iso-8859-1?Q?V=F6lkel?= <stefan.voelkel@millenux.com>
Cc: SCSI Mailing List <linux-scsi@vger.kernel.org>, Heiko Carstens <Heiko.Carstens@de.ibm.com>


--- zfcp_aux.c.orig	2004-06-19 16:01:25.000000000 +0000
+++ zfcp_aux.c	2004-06-19 16:00:01.000000000 +0000
@@ -146,6 +146,17 @@
 module_param(flags_dump, uint, 0);
 #endif
 
+#ifndef MODULE
+/* remember kernel boot time parameter */
+static int __init zfcp_device(char *str)
+{
+	device = str;
+	return 1;
+}
+
+__setup("zfcpdevice=", zfcp_device);
+#endif

please use module_param instead.  still wondering why zfcp needs paramters
anyway..

