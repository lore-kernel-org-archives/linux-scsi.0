From: "Kallickal, Jayamohan" <Jayamohan.Kallickal@Emulex.Com>
Subject: RE: Possible reentrancy issue in be_iopoll
Date: Tue, 19 Mar 2013 19:42:20 +0000
Message-ID: <37724B2049F71D4C9B086F99DDB2DE111BA82542@CMEXMB1.ad.emulex.com>
References: <51472EB7.2020903@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cmexedge1.ext.emulex.com ([138.239.224.99]:46855 "EHLO
	CMEXEDGE1.ext.emulex.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754455Ab3CSTmV convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 19 Mar 2013 15:42:21 -0400
In-Reply-To: <51472EB7.2020903@mellanox.com>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Shlomo Pongratz <shlomop@mellanox.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
Cc: "michaelc@cs.wisc.edu" <michaelc@cs.wisc.edu>

Shlomo,

 Thanks for the review and spotting this issue.

Will fix this and include in the next submission, unless you want to do it yourself.

Thanks
Jay

-----Original Message-----
From: Shlomo Pongratz [mailto:shlomop@mellanox.com] 
Sent: Monday, March 18, 2013 8:12 AM
To: linux-scsi@vger.kernel.org
Cc: Kallickal, Jayamohan; michaelc@cs.wisc.edu
Subject: Possible reentrancy issue in be_iopoll

Hi Jayamohan.

I think that there is a reentrancy issue in "drivers/scsi/be2iscsi/be_main.c::be_iopoll".
The driver creates "NAPI" context per core which is fine, however the above routine declares the ret variable as static!
Thus there is only one instance of this variable, so if this routine is called from more than one thread of execution the result is unpredictable.

         static unsigned int ret;
         .....

         ret = beiscsi_process_cq(pbe_eq); <----------------------------------------------------------------------------------Another
thread can enter here and change "ret".
         if (ret < budget) {
                ....
         }
<----------------------------------------------------------------------------------Another
thread can enter here and change "ret".
         return ret;

I can't submit a patch without checking it first, which is impossible since I don't have the HW, but the fix seems trivial, just take out the static.

Best regards,

S.P.

