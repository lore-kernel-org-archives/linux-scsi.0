From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH] aacraid: prevent copy_from_user() BUG!
Date: Thu, 05 Jun 2008 10:35:27 -0500
Message-ID: <1212680127.13549.38.camel@localhost.localdomain>
References: <86802c440804181855t615a5616g62d083695ca8ea08@mail.gmail.com>
	 <3AC1542A-0338-4796-9218-502C4AAD64D2@adaptec.com>
	 <86802c440804211742g1fe25aadjeaffce49722e7c46@mail.gmail.com>
	 <BCC76E6D-9A0F-4DC1-822A-50EE44A52890@adaptec.com>
	 <1E278B55-6C77-42FA-8B15-16A0939203FB@adaptec.com>
	 <1FB85EE8-0F95-4CF8-AD36-9E0E6542BB59@adaptec.com>
	 <7D06DAD1-983B-457F-8A9B-76C4FA95D57B@adaptec.com>
	 <D25ECCDE-1A2B-4E11-BEF9-CAC0A9ABA0FE@adaptec.com>
	 <DF06F352-4C27-47D3-983A-FB2414C8D88E@adaptec.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from accolon.hansenpartnership.com ([76.243.235.52]:50933 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751895AbYFEPfc (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 5 Jun 2008 11:35:32 -0400
In-Reply-To: <DF06F352-4C27-47D3-983A-FB2414C8D88E@adaptec.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mark Salyzyn <Mark_Salyzyn@adaptec.com>
Cc: Linux-Scsi <linux-scsi@vger.kernel.org>

On Wed, 2008-05-28 at 15:32 -0400, Mark Salyzyn wrote:
> Seen:
> 
> 	kernel BUG at arch/i386/lib/usercopy.c:872
> 
> under a 2.6.18-8.el5 kernel. Traced it to a garbage-in/garbage-out  
> ioctl condition in the aacraid driver.
> 
> Adaptec's special ioctl scb passthrough needs to check the validity of  
> the individual scatter gather count fields to the maximum the adapter  
> supports. Doing so will have the side effect of preventing  
> copy_from_user() from bugging out while populating the dma buffers.  
> This is a hardening effort, issue was triggered by an errant version  
> of the management tools and thus the BUG should not be seen in the  
> field.
> 
> This attached patch is against current scsi-misc-2.6.

But not actually compiled I see:

  CC [M]  drivers/scsi/aacraid/commctrl.o
drivers/scsi/aacraid/commctrl.c: In function 'aac_send_raw_srb':
drivers/scsi/aacraid/commctrl.c:587: error: dereferencing pointer to incomplete type
drivers/scsi/aacraid/commctrl.c:639: error: dereferencing pointer to incomplete type
drivers/scsi/aacraid/commctrl.c:689: error: dereferencing pointer to incomplete type
drivers/scsi/aacraid/commctrl.c:728: error: dereferencing pointer to incomplete type

I fixed it using the patch below.

James

---

diff --git a/drivers/scsi/aacraid/commctrl.c b/drivers/scsi/aacraid/commctrl.c
index ea96ddb..a735526 100644
--- a/drivers/scsi/aacraid/commctrl.c
+++ b/drivers/scsi/aacraid/commctrl.c
@@ -41,6 +41,7 @@
 #include <linux/kthread.h>
 #include <linux/semaphore.h>
 #include <asm/uaccess.h>
+#include <scsi/scsi_host.h>
 
 #include "aacraid.h"
 


