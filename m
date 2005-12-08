From: Patrick Mansfield <patmans@us.ibm.com>
Subject: Re: linux kernel panic when ejecting ieee1394 ipod
Date: Thu, 8 Dec 2005 09:34:29 -0800
Message-ID: <20051208173429.GA2666@us.ibm.com>
References: <200512072358.15398.adq_dvb@lidskialf.net> <200512080119.48740.adq@lidskialf.net> <200512080159.10913.adq_dvb@lidskialf.net> <200512080209.17757.adq_dvb@lidskialf.net> <43979E1A.30801@s5r6.in-berlin.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e3.ny.us.ibm.com ([32.97.182.143]:52657 "EHLO e3.ny.us.ibm.com")
	by vger.kernel.org with ESMTP id S1750718AbVLHRe5 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 8 Dec 2005 12:34:57 -0500
Received: from d01relay02.pok.ibm.com (d01relay02.pok.ibm.com [9.56.227.234])
	by e3.ny.us.ibm.com (8.12.11/8.12.11) with ESMTP id jB8HYlGC006031
	for <linux-scsi@vger.kernel.org>; Thu, 8 Dec 2005 12:34:47 -0500
Received: from d01av02.pok.ibm.com (d01av02.pok.ibm.com [9.56.224.216])
	by d01relay02.pok.ibm.com (8.12.10/NCO/VERS6.8) with ESMTP id jB8HYl5W122922
	for <linux-scsi@vger.kernel.org>; Thu, 8 Dec 2005 12:34:47 -0500
Received: from d01av02.pok.ibm.com (loopback [127.0.0.1])
	by d01av02.pok.ibm.com (8.12.11/8.13.3) with ESMTP id jB8HYkOI000638
	for <linux-scsi@vger.kernel.org>; Thu, 8 Dec 2005 12:34:47 -0500
Content-Disposition: inline
In-Reply-To: <43979E1A.30801@s5r6.in-berlin.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
Cc: Andrew de Quincey <adq_dvb@lidskialf.net>, linux1394-devel@lists.sourceforge.net, linux-scsi@vger.kernel.org

On Thu, Dec 08, 2005 at 03:44:42AM +0100, Stefan Richter wrote:

> What if you replace WRITE by READ in 
> drivers/scsi/scsi_ioctl.c::scsi_cmd_ioctl()::case CDROMEJECT ?

You must mean block/scsi_ioctl.c? i.e.:

diff -uprN -X /home/patman/dontdiff linux-2.6.15-rc5-git1/block/scsi_ioctl.c mod- linux-2.6.15-rc5-git1/block/scsi_ioctl.c
--- /home/linux/views/linux-2.6.15-rc5-git1/block/scsi_ioctl.c	2005-12-03 22:51:54.000000000 -0800
+++ linux-2.6.15-rc5-git1/block/scsi_ioctl.c	2005-12-08 09:31:52.000000000 -0800
@@ -566,7 +566,7 @@ int scsi_cmd_ioctl(struct file *file, st
 		case CDROMCLOSETRAY:
 			close = 1;
 		case CDROMEJECT:
-			rq = blk_get_request(q, WRITE, __GFP_WAIT);
+			rq = blk_get_request(q, READ, __GFP_WAIT);
 			rq->flags |= REQ_BLOCK_PC;
 			rq->data = NULL;
 			rq->data_len = 0;

> And BTW, can/should this latter case block be converted to use 
> scsi_execute() or scsi_execute_req()?

And then scsi_cmd_ioctl() already uses blk layer REQ_BLOCK_PC.

-- Patrick Mansfield
