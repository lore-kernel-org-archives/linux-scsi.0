From: Adrian Bunk <bunk@fs.tum.de>
Subject: [patch] 2.5.70-mm2: aha1740.c doesn't compile. (fwd)
Date: Wed, 18 Jun 2003 00:40:35 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030617224035.GG29247@fs.tum.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from hermes.fachschaften.tu-muenchen.de ([129.187.202.12]:62163 "HELO
	hermes.fachschaften.tu-muenchen.de") by vger.kernel.org with SMTP
	id S264975AbTFQW0s (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 17 Jun 2003 18:26:48 -0400
Content-Disposition: inline
List-Id: linux-scsi@vger.kernel.org
To: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
Cc: trivial@rustcorp.com.au

The problem described below still exists in 2.5.72. A patch to fix it 
is:

--- linux-2.5.72/drivers/scsi/aha1740.c.old	2003-06-18 00:36:51.000000000 +0200
+++ linux-2.5.72/drivers/scsi/aha1740.c	2003-06-18 00:36:55.000000000 +0200
@@ -102,6 +102,7 @@
     if (len > length)
 	len = length;
     return len;
+}
 
 
 static int aha1740_makecode(unchar *sense, unchar *status)


I've tested the compilation with 2.5.72.

Please apply
Adrian



----- Forwarded message from Adrian Bunk <bunk@fs.tum.de> -----

Date:	Thu, 29 May 2003 21:40:03 +0200
From: Adrian Bunk <bunk@fs.tum.de>
To: Andrew Morton <akpm@digeo.com>,
    Christoph Hellwig <hch@infradead.org>
Cc: linux-kernel@vger.kernel.org,
    llinux-scsi@vger.kernel.org
Subject: [patch] 2.5.70-mm2: aha1740.c doesn't compile.

It seems the following compile error comes from Linus' tree:

<--  snip  -->

...
  CC      drivers/scsi/aha1740.o
...
drivers/scsi/aha1740.c:613: syntax error at end of input
...
make[2]: *** [drivers/scsi/aha1740.o] Error 1

<--  snip  -->


The culprit is the following bogus part of a patch (please _revert_ it):


linux-2.5.70/drivers/scsi/aha1740.c	2003-05-26 19:16:33.000000000 -0700
25/drivers/scsi/aha1740.c	2003-05-28 23:52:00.000000000 -0700
@@ -108,7 +102,6 @@ static int aha1740_proc_info(char *buffe
     if (len > length)
 	len = length;
     return len;
-}
 
 
 static int aha1740_makecode(unchar *sense, unchar *status)



cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

-
To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
Please read the FAQ at  http://www.tux.org/lkml/

----- End forwarded message -----

