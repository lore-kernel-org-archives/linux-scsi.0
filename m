From: Steven Dake <sdake@mvista.com>
Subject: Re: Qlogic driver hang
Date: Thu, 02 Oct 2003 11:16:30 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1065118590.4779.158.camel@persist.az.mvista.com>
References: <B179AE41C1147041AA1121F44614F0B060ED34@AVEXCH02.qlogic.org>
	 <1065109530.24236.6127.camel@localhost.localdomain>
Reply-To: sdake@mvista.com
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from rav-az.mvista.com ([65.200.49.157]:41993 "EHLO
	zipcode.az.mvista.com") by vger.kernel.org with ESMTP
	id S263424AbTJBSQh (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 2 Oct 2003 14:16:37 -0400
In-Reply-To: <1065109530.24236.6127.camel@localhost.localdomain>
List-Id: linux-scsi@vger.kernel.org
To: Chris Worley <cworley@lnxi.com>, mbellon@mvista.com
Cc: linux-scsi@vger.kernel.org

At one point some code was added to enable parity on the chip.  This may
be the cause of the hang.  Try disabling parity checking in the driver.

On Thu, 2003-10-02 at 08:45, Chris Worley wrote:
> In using the 6.06.00 version of the qlogic driver, the module load gets
> to:
> 
> 	Verifying chip...      
> 
> And hangs the system.  The older driver would print out:
> 
> 	Firmware version:  3.01.13, Driver version 6.01.00
> 
> at this point.  Any ideas what I'm doing wrong?
> 
> Thanks,
> 
> Chris
> On Tue, 2003-09-30 at 16:25, Andrew Vasquez wrote:
> > Chris
> > 
> > > The tarball from Qlogic was labeled:
> > > 
> > >   qla2x00-v6.01.00-dist.tgz 
> > > 
> > > It's the full-height, PCI-X, 133MHz, single port, 2340 (I think). 
> > >
> > >
> > 
> > Ouch, that's a really old driver (with some known [error handling]
> > problems).  Would it be possible to start with something a bit more
> > recent, 6.06.00 has been posted to QLogic's website:
> > 
> > 	http://www.qlogic.com/support/product_resources.asp?id=253
> > 	http://download.qlogic.com/drivers/13591/qla2x00-v6.06.00-dist.tgz
> > 
> > I'd suggest we start from there.  If you are still experiencing
> > problems, forward the /var/log/messages file after you enable
> > 'Extended Error Logging' from the BIOS utility.  If you feel
> > comfortable changing some lines in the driver source, more descript
> > (helpful) logs can be obtained with the following three changes:
> > 
> > 	o In the qla_settings.h file change the following line from:
> > 
> > 		#define DEBUG_QLA2100		0  /* For Debug of qla2x00 */
> > 	 to
> > 		#define DEBUG_QLA2100		1  /* For Debug of qla2x00 */
> > 
> > 	o In the qla2x00.h file change the following line from:
> > 
> > 		/* #define QL_DEBUG_LEVEL_2  */ /* Output error msgs to COM1 */
> > 	  to
> > 		#define QL_DEBUG_LEVEL_2   /* Output error msgs to COM1 */
> > 
> > 	o In the qla2x00.c file change the following line from:
> > 
> > 		static int extended_error_logging = 0;	/* 0 = off, 1 = log errors */
> > 	  to
> > 		static int extended_error_logging = 1;	/* 0 = off, 1 = log errors */
> > 
> > Recompile & load the driver.
> > 
> > Regards,
> > Andrew Vasquez
> 
> -
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
> 

