From: "Andrew Vasquez" <andrew.vasquez@qlogic.com>
Subject: RE: Problems with updated firmware for qla2xxx driver.
Date: Tue, 23 Mar 2004 14:44:06 -0800
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <B179AE41C1147041AA1121F44614F0B0DCFFB3@AVEXCH02.qlogic.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pat.qlogic.com ([198.70.193.2]:55392 "EHLO avexch01.qlogic.com")
	by vger.kernel.org with ESMTP id S262892AbUCWWni convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 23 Mar 2004 17:43:38 -0500
content-class: urn:content-classes:message
List-Id: linux-scsi@vger.kernel.org
To: "Caushik, Ramesh" <ramesh.caushik@intel.com>, linux-scsi@vger.kernel.org


On Tuesday, March 23, 2004 11:48 AM, linux-scsi-owner@vger.kernel.org
wrote: 
> 	I am trying to run the latest qla2xxx driver with the
> patches from
> <ftp://ftp.qlogic.com/outgoing/linux/patches/8.x/8.00.00b11k/>
>  on an Intel AdvancedTCA SBC  which has an onboard dual port
> QLogic ISP2312 controller. When I insmod the driver the
> adapter is found and the driver tries to "init" the firmware
> and fails.
>

With the 8.00.00b11k driver, could you enable enable a couple of debug
swtiches in the driver:

In qla_settings.h update the following line:

	#define DEBUG_QLA2100		0	/* For Debug of qla2x00 */

to read as:

	#define DEBUG_QLA2100		1	/* For Debug of qla2x00 */

Then update qla_dbg.h to have the following line:

	/* #define QL_DEBUG_LEVEL_2  */ /* Output error msgs to COM1 */

to read as:

	 #define QL_DEBUG_LEVEL_2   /* Output error msgs to COM1 */

Rebuild the driver, reload, then forward the /var/log/messages file to
me, I'd like to see where the failure is occuring.

> It looks like this is due to the  firmware in driver versions >
> 8.00.00b8. The same driver works fine if  I copy the qla2300_fw.c
> file from an earlier version (8.00.00b8) found in the stock 2.6.2
> kernel. Has anybody else noticed this on other ISP2312 based
> adapters. Appreciate any help resolving this issue.  Ramesh.
> 

We've been testing numerous cards built with the ISP2312 chip, i.e.
QLA2342, QLA2340, and haven't ran into any problems (at least firmware
load problems).

Hmm, 8.00.00b8 used firmware version 3.02.18.  Just so I can try to
narrow down the # of possibilities with the firmware guys, b10 of the
driver used 3.02.21 which you can download from the following URL:

	http://easynews.dl.sourceforge.net/sourceforge/linux-qla2xxx/qla2xxx-src-v8.00.00b10.tar.bz2

Could you also try that firmware and report back your findings along
with the debug test mentioned above.

Regards,
Andrew Vasquez
