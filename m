From: "Salyzyn, Mark" <mark_salyzyn@adaptec.com>
Subject: RE: [PATCH] aacraid: use kthread_ API
Date: Tue, 14 Feb 2006 12:53:06 -0500
Message-ID: <547AF3BD0F3F0B4CBDC379BAC7E4189F0222C7CC@otce2k03.adaptec.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-gw3.adaptec.com ([216.52.22.36]:59323 "EHLO
	mail-gw3.adaptec.com") by vger.kernel.org with ESMTP
	id S1422725AbWBNRxI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 14 Feb 2006 12:53:08 -0500
content-class: urn:content-classes:message
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>, jejb@steeleye.com
Cc: linux-scsi@vger.kernel.org

Looks good by me, save that it would be nicer to use either
AAC_DRIVERNAME or aac->name instead of yet another hard coded string.

Eg:

 > -	aac->thread_pid = kernel_thread((int (*)(void
*))aac_command_thread,
 > -	  aac, 0);
 > -	if (aac->thread_pid < 0) {
-> +	aac->thread = kthread_run(aac_command_thread, aac, "aacraid");
+> +	aac->thread = kthread_run(aac_command_thread, aac,
AAC_DRIVERNAME);
 > +	if (IS_ERR(aac->thread)) {
 >  		printk(KERN_ERR "aacraid: Unable to create command
thread.\n");

Sincerely -- Mark Salyzyn
