From: Kai Makisara <Kai.Makisara@kolumbus.fi>
Subject: Re: [st] "mt-st tell" fails in 2.6.10-rc1
Date: Tue, 2 Nov 2004 21:44:47 +0200 (EET)
Message-ID: <Pine.LNX.4.61.0411022135020.4871@kai.makisara.local>
References: <Pine.LNX.4.60.0411020927280.2947@wrench.lan>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from fep19-0.kolumbus.fi ([193.229.0.45]:61400 "EHLO
	fep19-app.kolumbus.fi") by vger.kernel.org with ESMTP
	id S261344AbUKBTos (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 2 Nov 2004 14:44:48 -0500
In-Reply-To: <Pine.LNX.4.60.0411020927280.2947@wrench.lan>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Marc Thomas <marc@dragonfly.plus.com>
Cc: linux-scsi@vger.kernel.org

On Tue, 2 Nov 2004, Marc Thomas wrote:

> 
> Hi All,
> 
> I've noticed that in 2.6.10-rc1 the "mt tell" command (from mt-st) fails to
> report SCSI tape position, returning "No such device". Other tape (read)
> operations appear to be ok. It worked fine in 2.6.9-rc4.
> 
The patch at the end of this message should fix this (passes basic tests). 
Someone added the ioctl to reset the SCSI device but the error handling 
is not quite correct. The code in 2.6.10-rc1 allows st_ioctl to continue 
unless reset succeeded. The fix allows continuation only if 
scsi_nonblockable_ioctl() does not handle the ioctl (returns -ENODEV). 
retval is cleared because the following code assumes it is zero unless set 
to something else.

Thanks for reporting the bug.

Signed-off-by: Kai Makisara <kai.makisara@kolumbus.fi>

--- linux-2.6.10-rc1/drivers/scsi/st.c~	2004-10-23 12:42:04.000000000 +0300
+++ linux-2.6.10-rc1/drivers/scsi/st.c	2004-11-02 21:30:53.000000000 +0200
@@ -3129,8 +3129,9 @@
 	 * access to the device is prohibited.
 	 */
 	retval = scsi_nonblockable_ioctl(STp->device, cmd_in, p, file);
-	if (!scsi_block_when_processing_errors(STp->device) || !retval)
+	if (!scsi_block_when_processing_errors(STp->device) || retval != -ENODEV)
 		goto out;
+	retval = 0;
 
 	cmd_type = _IOC_TYPE(cmd_in);
 	cmd_nr = _IOC_NR(cmd_in);
