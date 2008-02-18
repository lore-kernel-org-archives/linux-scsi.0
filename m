From: FUJITA Tomonori <tomof@acm.org>
Subject: Re: ips.c broken since 2.6.23 on x86_64?
Date: Mon, 18 Feb 2008 22:32:46 +0900
Message-ID: <20080218223246I.tomof@acm.org>
References: <20080217211539.GA29813@tpepper-t42p.dolavim.us>
	<20080218073134A.tomof@acm.org>
	<20080217233701.GA30994@tpepper-t42p.dolavim.us>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mo11.iij4u.or.jp ([210.138.174.79]:45702 "EHLO mo11.iij4u.or.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751650AbYBRNdH (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 18 Feb 2008 08:33:07 -0500
In-Reply-To: <20080217233701.GA30994@tpepper-t42p.dolavim.us>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: lnxninja@linux.vnet.ibm.com
Cc: tomof@acm.org, fujita.tomonori@lab.ntt.co.jp, linux-scsi@vger.kernel.org, Mark_Salyzyn@adaptec.comfujita.tomonori@lab.ntt.co.jp

On Sun, 17 Feb 2008 15:37:02 -0800
Tim Pepper <lnxninja@linux.vnet.ibm.com> wrote:

> On Mon 19 Feb at 07:31:56 +0900 tomof@acm.org said:
> > 
> > Can you apply the 0001 and 0002 against 2.6.24 and see how it works?
> > If it works well, then please apply the 0001, 0002 and 0003.
> 
> Fujita-san,
> 
> I've started through the patches in order, cumulatively and after applying
> 0005 things break.  I wont be able to test anything else until tomorrow
> when I can phycisally reset the machine...

Great, thanks a lot!

Can you apply this patch after the 0005 patch and see how it works? If
it works, then please continue to test 0006, 0007 ...


diff --git a/drivers/scsi/ips.c b/drivers/scsi/ips.c
index 05bb6ea..39cdd68 100644
--- a/drivers/scsi/ips.c
+++ b/drivers/scsi/ips.c
@@ -6906,7 +6906,7 @@ ips_register_scsi(int index)
 	sh->max_channel = ha->nbus - 1;
 	sh->can_queue = ha->max_cmds - 1;
 
-	scsi_add_host(sh, NULL);
+	scsi_add_host(sh, &ha->pcidev->dev);
 	scsi_scan_host(sh);
 
 	return 0;
-- 
1.5.3.7

