From: Randy Dunlap <randy.dunlap@oracle.com>
Subject: Re: OnStream DI30: undescriptive message: CoD != 0 in
 idescsi_pc_intr
Date: Sun, 21 Jan 2007 16:37:19 -0800
Message-ID: <20070121163719.6c4defd8.randy.dunlap@oracle.com>
References: <45B2CC89.1020305@xs4all.nl>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from agminet01.oracle.com ([141.146.126.228]:17490 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751813AbXAVAlb (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 21 Jan 2007 19:41:31 -0500
In-Reply-To: <45B2CC89.1020305@xs4all.nl>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: bjdouma@xs4all.nl
Cc: linux-kernel@vger.kernel.org, osst@riede.org, osst-users@lists.sourceforge.net, scsi <linux-scsi@vger.kernel.org>

On Sun, 21 Jan 2007 03:14:33 +0100 Bauke Jan Douma wrote:

> OnStream Di30 (using ide-scsi and osst drivers), when reading
> or writing I regularly get these kernel messages:
> 
> <3>ide-scsi: CoD != 0 in idescsi_pc_intr
> 
> Let's assume flaky hardware; nothing we can hold the kernel to
> blame for (which is 2.6.19.1) -- it's a good thing it's calling
> our attention.  There's no data corruption, btw.
> 
> However, said message is quite useless because undescriptive
> and too terse.

Not sure that this helps much.

---
From: Randy Dunlap <randy.dunlap@oracle.com>

Expand on a terse ide-scsi message.
Something is confused.

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
---
 drivers/scsi/ide-scsi.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- linux-2619-work.orig/drivers/scsi/ide-scsi.c
+++ linux-2619-work/drivers/scsi/ide-scsi.c
@@ -528,7 +528,7 @@ static ide_startstop_t idescsi_pc_intr (
 	ireason.all	= HWIF(drive)->INB(IDE_IREASON_REG);
 
 	if (ireason.b.cod) {
-		printk(KERN_ERR "ide-scsi: CoD != 0 in idescsi_pc_intr\n");
+		printk(KERN_ERR "ide-scsi: CoD(Command/Data flag) != 0(Data) in idescsi_pc_intr\n");
 		return ide_do_reset (drive);
 	}
 	if (ireason.b.io) {

