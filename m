From: Kai Makisara <Kai.Makisara@kolumbus.fi>
Subject: Re: [PATCH 5/10] convert st to use scsi_execute_async
Date: Sat, 12 Nov 2005 19:03:51 +0200 (EET)
Message-ID: <Pine.LNX.4.63.0511121859070.10335@kai.makisara.local>
References: <1131444404.23111.66.camel@max>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from fep30-0.kolumbus.fi ([193.229.0.32]:12368 "EHLO
	fep30-app.kolumbus.fi") by vger.kernel.org with ESMTP
	id S932415AbVKLRDv (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 12 Nov 2005 12:03:51 -0500
In-Reply-To: <1131444404.23111.66.camel@max>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mike Christie <michaelc@cs.wisc.edu>
Cc: Jens Axboe <axboe@suse.de>, linux-scsi@vger.kernel.org

On Tue, 8 Nov 2005, Mike Christie wrote:

> convert st to always send scatterlists and kill scsi_request
> usage.
> 
> This is the same as last time as it was posted, but with Kai's patches
> merged and we now pass the bytes value to scsi_execute_async.
> 
This does not work "out of the box". The changes in st are almost the same 
ones than before but the world around st has changed ;-) This has revealed 
at least one bug in st that is fixed by the patch at the end of this 
message. After this patch some simple tests succeed but there seem to be 
still problems with larger requests. I don't have time to continue 
debugging just now but I should be able to post more results during this 
weekend.

Kai

--- linux-2.6.14-blk1/drivers/scsi/st.c.org	2005-11-09 22:36:56.000000000 +0200
+++ linux-2.6.14-blk1/drivers/scsi/st.c	2005-11-12 17:59:22.000000000 +0200
@@ -3666,6 +3666,7 @@
 	}
 	STbuffer->frp_segs = STbuffer->orig_frp_segs;
 	STbuffer->frp_sg_current = 0;
+	STbuffer->sg_segs = 0;
 }
 
 
