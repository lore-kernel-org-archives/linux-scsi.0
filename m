From: Chris Worley <cworley@lnxi.com>
Subject: Qlogic driver hang
Date: 02 Oct 2003 09:45:31 -0600
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1065109530.24236.6127.camel@localhost.localdomain>
References: <B179AE41C1147041AA1121F44614F0B060ED34@AVEXCH02.qlogic.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from [208.177.141.226] ([208.177.141.226]:63117 "EHLO
	localhost.lnxi.com") by vger.kernel.org with ESMTP id S263392AbTJBPsz
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 2 Oct 2003 11:48:55 -0400
Received: from localhost (localhost.localdomain [127.0.0.1])
	by localhost.lnxi.com (8.11.6/8.11.6) with ESMTP id h92FjWM30882
	for <linux-scsi@vger.kernel.org>; Thu, 2 Oct 2003 09:45:32 -0600
In-Reply-To: <B179AE41C1147041AA1121F44614F0B060ED34@AVEXCH02.qlogic.org>
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

In using the 6.06.00 version of the qlogic driver, the module load gets
to:

	Verifying chip...      

And hangs the system.  The older driver would print out:

	Firmware version:  3.01.13, Driver version 6.01.00

at this point.  Any ideas what I'm doing wrong?

Thanks,

Chris
On Tue, 2003-09-30 at 16:25, Andrew Vasquez wrote:
> Chris
> 
> > The tarball from Qlogic was labeled:
> > 
> >   qla2x00-v6.01.00-dist.tgz 
> > 
> > It's the full-height, PCI-X, 133MHz, single port, 2340 (I think). 
> >
> >
> 
> Ouch, that's a really old driver (with some known [error handling]
> problems).  Would it be possible to start with something a bit more
> recent, 6.06.00 has been posted to QLogic's website:
> 
> 	http://www.qlogic.com/support/product_resources.asp?id=253
> 	http://download.qlogic.com/drivers/13591/qla2x00-v6.06.00-dist.tgz
> 
> I'd suggest we start from there.  If you are still experiencing
> problems, forward the /var/log/messages file after you enable
> 'Extended Error Logging' from the BIOS utility.  If you feel
> comfortable changing some lines in the driver source, more descript
> (helpful) logs can be obtained with the following three changes:
> 
> 	o In the qla_settings.h file change the following line from:
> 
> 		#define DEBUG_QLA2100		0  /* For Debug of qla2x00 */
> 	 to
> 		#define DEBUG_QLA2100		1  /* For Debug of qla2x00 */
> 
> 	o In the qla2x00.h file change the following line from:
> 
> 		/* #define QL_DEBUG_LEVEL_2  */ /* Output error msgs to COM1 */
> 	  to
> 		#define QL_DEBUG_LEVEL_2   /* Output error msgs to COM1 */
> 
> 	o In the qla2x00.c file change the following line from:
> 
> 		static int extended_error_logging = 0;	/* 0 = off, 1 = log errors */
> 	  to
> 		static int extended_error_logging = 1;	/* 0 = off, 1 = log errors */
> 
> Recompile & load the driver.
> 
> Regards,
> Andrew Vasquez

