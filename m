From: Dan Carpenter <dan.carpenter@oracle.com>
Subject: re: ufs: Add regulator enable support
Date: Thu, 2 Oct 2014 18:25:38 +0300
Message-ID: <20141002152538.GA6420@mwanda>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:33809 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754425AbaJBPZ5 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 2 Oct 2014 11:25:57 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: sthumma@codeaurora.org
Cc: linux-scsi@vger.kernel.org

Hello Sujit Reddy Thumma,

The patch aa4976130934: "ufs: Add regulator enable support" from Sep
25, 2014, leads to the following static checker warning:

	drivers/scsi/ufs/ufshcd-pltfrm.c:167 ufshcd_populate_vreg()
	warn: missing error code here? 'devm_kzalloc()' failed. 'ret' = '0'

drivers/scsi/ufs/ufshcd-pltfrm.c
   144  static int ufshcd_populate_vreg(struct device *dev, const char *name,
   145                  struct ufs_vreg **out_vreg)
   146  {
   147          int ret = 0;
   148          char prop_name[MAX_PROP_SIZE];
   149          struct ufs_vreg *vreg = NULL;
   150          struct device_node *np = dev->of_node;
   151  
   152          if (!np) {
   153                  dev_err(dev, "%s: non DT initialization\n", __func__);
   154                  goto out;
   155          }
   156  
   157          snprintf(prop_name, MAX_PROP_SIZE, "%s-supply", name);
   158          if (!of_parse_phandle(np, prop_name, 0)) {
   159                  dev_info(dev, "%s: Unable to find %s regulator, assuming enabled\n",
   160                                  __func__, prop_name);
   161                  goto out;
   162          }
   163  
   164          vreg = devm_kzalloc(dev, sizeof(*vreg), GFP_KERNEL);
   165          if (!vreg) {
   166                  dev_err(dev, "No memory for %s regulator\n", name);
   167                  goto out;

Don't print an error message.
Don't use a goto out.
Don't forget to set an error code.

   168          }
   169  

regards,
dan carpenter
