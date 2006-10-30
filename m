From: malahal@us.ibm.com
Subject: Re: [PATCH] cleanup after a discovery error
Date: Mon, 30 Oct 2006 12:23:02 -0800
Message-ID: <20061030202302.GA22870@us.ibm.com>
References: <20061019031910.GA16855@us.ibm.com> <1161284938.11219.22.camel@mulgrave.il.steeleye.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e32.co.us.ibm.com ([32.97.110.150]:36517 "EHLO
	e32.co.us.ibm.com") by vger.kernel.org with ESMTP id S1751539AbWJ3UXI
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 30 Oct 2006 15:23:08 -0500
Received: from westrelay02.boulder.ibm.com (westrelay02.boulder.ibm.com [9.17.195.11])
	by e32.co.us.ibm.com (8.13.8/8.12.11) with ESMTP id k9UKN57i011145
	for <linux-scsi@vger.kernel.org>; Mon, 30 Oct 2006 15:23:05 -0500
Received: from d03av02.boulder.ibm.com (d03av02.boulder.ibm.com [9.17.195.168])
	by westrelay02.boulder.ibm.com (8.13.6/8.13.6/NCO v8.1.1) with ESMTP id k9UKN46O516560
	for <linux-scsi@vger.kernel.org>; Mon, 30 Oct 2006 13:23:04 -0700
Received: from d03av02.boulder.ibm.com (loopback [127.0.0.1])
	by d03av02.boulder.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id k9UKN46Q023279
	for <linux-scsi@vger.kernel.org>; Mon, 30 Oct 2006 13:23:04 -0700
Content-Disposition: inline
In-Reply-To: <1161284938.11219.22.camel@mulgrave.il.steeleye.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: linux-scsi@vger.kernel.org

James Bottomley [James.Bottomley@SteelEye.com] wrote:
> 
> This is a bit of a layering violation
> 
> if the various discover functions are going to return an error, I think
> it's their job to clean up whatever they did before returning.
> 
> James

Hope this works better.
Signed-off-by: Malahal Naineni <malahal@us.ibm.com>

diff -r 80de69a94159 drivers/scsi/libsas/sas_discover.c
--- a/drivers/scsi/libsas/sas_discover.c	Wed Oct 25 13:28:31 2006 -0700
+++ b/drivers/scsi/libsas/sas_discover.c	Mon Oct 30 11:55:21 2006 -0800
@@ -684,6 +684,11 @@ static void sas_discover_domain(void *da
 	}
 
 	if (error) {
+		sas_rphy_delete(port->port_dev->rphy);
+		port->port_dev->rphy = NULL;
+		spin_lock(&port->dev_list_lock);
+		list_del_init(&port->port_dev->dev_list_node);
+		spin_unlock(&port->dev_list_lock);
 		kfree(port->port_dev); /* not kobject_register-ed yet */
 		port->port_dev = NULL;
 	}
