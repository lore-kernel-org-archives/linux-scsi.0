From: Domen Puncer <domen@coderock.org>
Subject: Re: [patch 06/11] drivers/scsi/aacraid/*: convert to pci_register_driver
Date: Tue, 15 Mar 2005 21:17:10 +0100
Message-ID: <20050315201710.GG3955@nd47.coderock.org>
References: <60807403EABEB443939A5A7AA8A7458BE5B10B@otce2k01.adaptec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Received: from coderock.org ([193.77.147.115]:9955 "EHLO trashy.coderock.org")
	by vger.kernel.org with ESMTP id S261477AbVCOUR0 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 15 Mar 2005 15:17:26 -0500
Content-Disposition: inline
In-Reply-To: <60807403EABEB443939A5A7AA8A7458BE5B10B@otce2k01.adaptec.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Salyzyn, Mark" <mark_salyzyn@adaptec.com>
Cc: James.Bottomley@SteelEye.com, linux-scsi@vger.kernel.org, c.lucas@ifrance.com

On 15/03/05 12:59 -0500, Salyzyn, Mark wrote:
> FC3 != kernel.org, and the problem may not exist in latest tree. The
> code for pci_module_init used to do a return (ret < 0) ? ret : 0.
> 
> The problem is then a 'transition' issue, as patches that appear here
> can and will be used for kernel revisions a few back. By changing the
> aacraid driver to check for < 0 rather than != 0 we improve reliability.
> I have discovered that by doing so, the driver in the Adaptec Branch
> taking this patch works fine all the way back early 2.4 trees.
> 

Thanks for clearing that up.
Forgot that scsi is 2.4 compatible. And I have a note to drop
pci_register_driver patches for it. Sorry for all the noise.

So, here's a new patch, if someone wants it; i won't be resending :-)


Use pci_register_driver instead of pci_module_init (old API).

Signed-off-by: Domen Puncer <domen@coderock.org>

--- ./drivers/scsi/aacraid/linit.c.orig	2005-03-15 21:05:53.000000000 +0100
+++ ./drivers/scsi/aacraid/linit.c	2005-03-15 21:06:59.000000000 +0100
@@ -686,12 +686,12 @@ static struct pci_driver aac_pci_driver 
 static int __init aac_init(void)
 {
 	int error;
-	
+
 	printk(KERN_INFO "Red Hat/Adaptec aacraid driver (%s %s)\n",
 			AAC_DRIVER_VERSION, AAC_DRIVER_BUILD_DATE);
 
-	error = pci_module_init(&aac_pci_driver);
-	if (error)
+	error = pci_register_driver(&aac_pci_driver);
+	if (error < 0)
 		return error;
 
 	aac_cfg_major = register_chrdev( 0, "aac", &aac_cfg_fops);
