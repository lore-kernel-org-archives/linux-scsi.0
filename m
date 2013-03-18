From: Shlomo Pongratz <shlomop@mellanox.com>
Subject: Possible reentrancy issue in be_iopoll
Date: Mon, 18 Mar 2013 17:11:51 +0200
Message-ID: <51472EB7.2020903@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from eu1sys200aog104.obsmtp.com ([207.126.144.117]:47577 "EHLO
	eu1sys200aog104.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751889Ab3CRPMM (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 18 Mar 2013 11:12:12 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: jayamohank@serverengines.com, michaelc@cs.wisc.edu

Hi Jayamohan.

I think that there is a reentrancy issue in 
"drivers/scsi/be2iscsi/be_main.c::be_iopoll".
The driver creates "NAPI" context per core which is fine, however the 
above routine declares the ret variable as static!
Thus there is only one instance of this variable, so if this routine is 
called from more than one thread of execution the result is unpredictable.

         static unsigned int ret;
         .....

         ret = beiscsi_process_cq(pbe_eq);
<----------------------------------------------------------------------------------Another 
thread can enter here and change "ret".
         if (ret < budget) {
                ....
         }
<----------------------------------------------------------------------------------Another 
thread can enter here and change "ret".
         return ret;

I can't submit a patch without checking it first, which is impossible 
since I don't have the HW, but the fix seems trivial, just take out the 
static.

Best regards,

S.P.

