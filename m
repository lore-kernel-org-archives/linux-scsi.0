From: Christoph Hellwig <hch@lst.de>
Subject: Re: Bugs in multipath scsi in 4.3-rc2
Date: Fri, 2 Oct 2015 14:52:24 +0200
Message-ID: <20151002125224.GA14899@lst.de>
References: <20150925121636.GC12540@fergus.ozlabs.ibm.com> <20150925151802.GB20282@lst.de> <1443202278.2188.13.camel@HansenPartnership.com> <20150930151449.GC26299@lst.de> <20151001043453.GA2893@iris.ozlabs.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.211]:43917 "EHLO newverein.lst.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751919AbbJBMw0 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 2 Oct 2015 08:52:26 -0400
Content-Disposition: inline
In-Reply-To: <20151001043453.GA2893@iris.ozlabs.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Paul Mackerras <paulus@ozlabs.org>
Cc: Christoph Hellwig <hch@lst.de>, James Bottomley <James.Bottomley@HansenPartnership.com>, linux-scsi@vger.kernel.org, Tejun Heo <tj@kernel.org>

On Thu, Oct 01, 2015 at 02:34:54PM +1000, Paul Mackerras wrote:
> I still get the warning:

Ok, I sent you the wrong patch.  scsi_dh_add_device is the function that
needs to switch to use __scsi_dh_lookup.  New version below:

diff --git a/drivers/scsi/scsi_dh.c b/drivers/scsi/scsi_dh.c
index edb044a..cc9ea81 100644
--- a/drivers/scsi/scsi_dh.c
+++ b/drivers/scsi/scsi_dh.c
@@ -226,7 +226,7 @@ int scsi_dh_add_device(struct scsi_device *sdev)
 
 	drv = scsi_dh_find_driver(sdev);
 	if (drv)
-		devinfo = scsi_dh_lookup(drv);
+		devinfo = __scsi_dh_lookup(drv);
 	if (devinfo)
 		err = scsi_dh_handler_attach(sdev, devinfo);
 	return err;
