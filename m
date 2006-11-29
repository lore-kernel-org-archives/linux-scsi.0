From: Douglas Gilbert <dougg@torque.net>
Subject: Re: aic94xx panic on module load
Date: Tue, 28 Nov 2006 20:52:25 -0500
Message-ID: <456CE7D9.9000704@torque.net>
References: <1164734233.21827.8.camel@markh3.pdx.osdl.net>	 <456C83A2.8020507@torque.net>	 <1164750379.21827.26.camel@markh3.pdx.osdl.net> <1164755862.21827.28.camel@markh3.pdx.osdl.net>
Reply-To: dougg@torque.net
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pentafluge.infradead.org ([213.146.154.40]:55452 "EHLO
	pentafluge.infradead.org") by vger.kernel.org with ESMTP
	id S1757551AbWK2Bwj (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 28 Nov 2006 20:52:39 -0500
In-Reply-To: <1164755862.21827.28.camel@markh3.pdx.osdl.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mark Haverkamp <markh@osdl.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, djwong@us.ibm.com

Mark Haverkamp wrote:
> On Tue, 2006-11-28 at 13:46 -0800, Mark Haverkamp wrote:
>> On Tue, 2006-11-28 at 13:44 -0500, Douglas Gilbert wrote:
>>
>> [ ... ]
>>
> 
> I don't know if this helps, but I found the verbose option.  Here is a
> little debug output.
> 
> 
> ./smp_discover -vvvvvvvvv  -p 12 -s 0x500508b300a27a2f /dev/mptctl
>     Discover request: 40 10 00 02 00 00 00 00 00 0c 00 00 00 00 00 00
> send_req_mpt: subvalue=0  SAS address=0x500508b300a27a2f
>     mptctl two scatter gather list interface
> IOCStatus=0x1
> IOCStatus=0x1 IOCLogInfo=0xA27A2F SASStatus=0x0
> smp_send_req failed, res=-1

Mark,
The iocnum may be greater than 0 (especially if you have
other MPT Fusion HBAs (any kind) in that computer).
Have a look in the log around where the mptsas driver
is registered and look for the string "ioc". The number
following "ioc" is what you need. If you find "ioc3" then
try:

 ./smp_discover -p 12 -s 0x500508b300a27a2f /dev/mptctl,3

To verify that expander SAS address, try this:
  find /sys -name "sas_device:expander*"
cd to any directory found and try "cat sas_address".


BTW there is a smp_utils version 0.92 beta at
http://www.torque.net/sg
the error messages are somewhat clearer.


Doug Gilbert

