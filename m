From: Pat LaVarre <p.lavarre@ieee.org>
Subject: Re: sg utils sg_io -i 0x24 -y "12 00:00:00 24 00"
Date: 26 Nov 2003 09:15:12 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1069863312.4325.45.camel@patrh9>
References: <1068165515.28505.29.camel@patrh9>
	 <20031107095145.A3785@beaverton.ibm.com>  <1068228695.3417.34.camel@patrh9>
	 <1068229639.3417.46.camel@patrh9>  <1068229873.3417.51.camel@patrh9>
	 <1068594777.6448.7.camel@patrh9>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from email-out1.iomega.com ([147.178.1.82]:54445 "EHLO
	email.iomega.com") by vger.kernel.org with ESMTP id S264240AbTKZQPy convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 26 Nov 2003 11:15:54 -0500
In-Reply-To: <1068594777.6448.7.camel@patrh9>
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

> again there we see CDB for length, data for expected
> length returning actual length, sense for expected length returning
> actual length.

ftp://members.aol.com/plscsi/linux/plscsi.tar.gz
says g++ rather than gcc in that Makefile for the sake of that minority
of folk who have gcc/g++ configured so that gcc fails to link after
compiling .cpp.

http://members.aol.com/plscsi/linux/plscsi.tar.gz
fetches the same, but via http rather than via ftp.

Neither, whoops, yet give us the following popular patch that often
makes such commands work as:

plscsi /dev/hdc
plscsi /dev/hdd
plscsi /dev/scd0

Pat LaVarre

diff -Nur plscsi.2002-09-21/sgio.cpp plscsi/sgio.cpp
--- plscsi.2002-09-21/sgio.cpp	2002-09-21 13:25:18.000000000 -0600
+++ plscsi/sgio.cpp	2003-11-26 09:10:59.109906736 -0700
@@ -116,6 +116,7 @@
     sgio->theErrFile = stderr;
 
     sgio->theOpenMode = O_RDWR; /* O_RDONLY often works */
+    sgio->theOpenMode = O_RDONLY|O_NONBLOCK;
     sgio->theFileDescriptor = -1;
     sgio->theSgVersionNum = 0; /* 0 = unknown */
 


