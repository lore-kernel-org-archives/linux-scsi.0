From: Kai Makisara <Kai.Makisara@kolumbus.fi>
Subject: Re: st: Fixup -ENOMEDIUM
Date: Thu, 5 Oct 2006 22:59:46 +0300 (EEST)
Message-ID: <Pine.LNX.4.64.0610052216180.7808@kai.makisara.local>
References: <4524CFAA.3010309@suse.de>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from fep32-0.kolumbus.fi ([193.229.0.63]:62296 "EHLO
	fep32-app.kolumbus.fi") by vger.kernel.org with ESMTP
	id S1751017AbWJET7s (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 5 Oct 2006 15:59:48 -0400
In-Reply-To: <4524CFAA.3010309@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: SCSI Mailing List <linux-scsi@vger.kernel.org>

On Thu, 5 Oct 2006, Hannes Reinecke wrote:

> Hi all,
> 
> currently the tape driver doesn't believe in ENOMEDIUM. Even if the sense code
> from TUR indicates that no tape is present the command will be retried; maybe
> the user is fast enough to slip a medium in in the meantime ...
> And even if not, it will return 'EIO' in any case.
> 
The driver implements (up to a point) the Single Unix Specification: if 
O_NONBLOCK is clear, open() shall wait until the device is ready or 
available. It does not wait indefinitely but implements a timeout. This is 
the behaviour I found experimentally in some other Unices.

> This patch fixes the ENOMEDIUM handling: TUR will _not_ be retried if no
> medium is present and the correct error number ENOMEDIUM will be set on exit.
> 
It is true that st_open() does not currently return ENOMEDIUM and your fix 
for this is correct.

> Please apply.
> 
I don't think that the first and second parts should be applied. The third 
part fixes a bug and it should be applied. I include at the end a diff 
containing only that part.

Thanks,
Kai

-----------8<--------------------

Fix st_open() to return -ENOMEDIUM instead of -EIO if no medium is 
found.

Signed-off-by: Kai Makisara <kai.makisara@kolumbus.fi>

--- linux-2.6.18/drivers/scsi/st.c.org	2006-10-05 22:36:15.000000000 +0300
+++ linux-2.6.18/drivers/scsi/st.c	2006-10-05 22:46:12.000000000 +0300
@@ -1177,7 +1177,10 @@ static int st_open(struct inode *inode, 
 		goto err_out;
 	if ((filp->f_flags & O_NONBLOCK) == 0 &&
 	    retval != CHKRES_READY) {
-		retval = (-EIO);
+		if (STp->ready == NO_TAPE)
+			retval = (-ENOMEDIUM);
+		else
+			retval = (-EIO);
 		goto err_out;
 	}
 	return 0;
