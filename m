From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: PROBLEM: linux-2.6.25.3, aha152x'->init suspiciously returned
	1, it should follow 0/-E convention
Date: Sat, 10 May 2008 08:33:58 -0500
Message-ID: <1210426438.4002.1.camel@localhost.localdomain>
References: <20080510103040.C7E891D652BF@mx.drokz.nl>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from accolon.hansenpartnership.com ([76.243.235.52]:52557 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755504AbYEJNeD (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sat, 10 May 2008 09:34:03 -0400
In-Reply-To: <20080510103040.C7E891D652BF@mx.drokz.nl>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Frank de Jong <frapex@xs4all.nl>
Cc: linux-scsi@vger.kernel.org, Juergen Fischer <fischer@norbit.de>

On Sat, 2008-05-10 at 12:30 +0200, Frank de Jong wrote:
> Hello,
> 
> Bug report follows.
> 
> [1.] One line summary of the problem:
> linux-2.6.25.3, aha152x'->init suspiciously returned 1, it should 
> follow 0/-E convention. The module / driver works okay. Unloading the 
> module is impossible.

The driver is apparently returning 0 on failure and 1 on success.
That's a bit unfortunate.  This should fix it.

James

---

diff --git a/drivers/scsi/aha152x.c b/drivers/scsi/aha152x.c
index f5215fd..f0c4ffc 100644
--- a/drivers/scsi/aha152x.c
+++ b/drivers/scsi/aha152x.c
@@ -3830,7 +3830,7 @@ static int __init aha152x_init(void)
 			iounmap(p);
 		}
 		if (!ok && setup_count == 0)
-			return 0;
+			return -ENODEV;
 
 		printk(KERN_INFO "aha152x: BIOS test: passed, ");
 #else
@@ -3909,7 +3909,7 @@ static int __init aha152x_init(void)
 #endif
 	}
 
-	return 1;
+	return 0;
 }
 
 static void __exit aha152x_exit(void)


