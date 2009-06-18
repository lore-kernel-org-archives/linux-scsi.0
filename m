From: David Strand <dpstrand@gmail.com>
Subject: [PATCH] mpt fusion: mptfc crash fixed
Date: Thu, 18 Jun 2009 16:39:03 -0700
Message-ID: <448b15030906181639u2c65f35bg611b5d5b45af0826@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-yx0-f192.google.com ([209.85.210.192]:54902 "EHLO
	mail-yx0-f192.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752534AbZFRXqj (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 18 Jun 2009 19:46:39 -0400
Received: by yxe30 with SMTP id 30so1991903yxe.4
        for <linux-scsi@vger.kernel.org>; Thu, 18 Jun 2009 16:46:29 -0700 (PDT)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: scsi <linux-scsi@vger.kernel.org>

I found that if I interrupt a fibre channel link to cause a link state
change, the mptfc driver crashes. Patch follows:

diff -Nuar linux-2.6.30.vanilla/drivers/message/fusion/mptfc.c
linux-2.6.30.new/drivers/message/fusion/mptfc.c
--- linux-2.6.30.vanilla/drivers/message/fusion/mptfc.c	2009-06-09
20:05:27.000000000 -0700
+++ linux-2.6.30.new/drivers/message/fusion/mptfc.c	2009-06-10
18:23:08.000000000 -0700
@@ -1071,7 +1071,7 @@
 mptfc_link_status_change(struct work_struct *work)
 {
 	MPT_ADAPTER             *ioc =
-		container_of(work, MPT_ADAPTER, fc_rescan_work);
+		container_of(work, MPT_ADAPTER, fc_lsc_work);
 	int ii;

 	for (ii=0; ii < ioc->facts.NumberOfPorts; ii++)
