From: Andrew Vasquez <praka@san.rr.com>
Subject: Re: Qlogic driver hang
Date: Fri, 3 Oct 2003 11:15:20 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20031003181520.GA2077@praka.local.home>
References: <B179AE41C1147041AA1121F44614F0B060ED34@AVEXCH02.qlogic.org> <1065109530.24236.6127.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from orngca-mls02.socal.rr.com ([66.75.160.17]:6273 "EHLO
	orngca-mls02.socal.rr.com") by vger.kernel.org with ESMTP
	id S263842AbTJCSgn (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 3 Oct 2003 14:36:43 -0400
Received: from praka.san.rr.com (66-75-133-254.san.rr.com [66.75.133.254])
	by orngca-mls02.socal.rr.com (8.11.4/8.11.3) with ESMTP id h93IW4k23715
	for <linux-scsi@vger.kernel.org>; Fri, 3 Oct 2003 11:32:05 -0700 (PDT)
Received: from san.rr.com (localhost [127.0.0.1])
	by san.rr.com (8.12.3/8.12.3/SuSE Linux 0.6) with ESMTP id h93IFMZB002100
	for <linux-scsi@vger.kernel.org>; Fri, 3 Oct 2003 11:15:22 -0700
Received: (from praka@localhost)
	by san.rr.com (8.12.3/8.12.3/Submit) id h93IFK6M002099
	for linux-scsi@vger.kernel.org; Fri, 3 Oct 2003 11:15:20 -0700
Content-Disposition: inline
In-Reply-To: <1065109530.24236.6127.camel@localhost.localdomain>
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

On Thu, 02 Oct 2003, Chris Worley wrote:

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

So much for forward progress :O

Would it be possible to get the logs mentioned below?  I'm rather
curious where exactly (or as close as possible) the hang is occuring.
How 'hard' is the hang?  Is the cap-locks key available (light
flashes)?  Is the HBA connected to anything at the time of module
load?


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

Regards,
Andrew Vasquez
