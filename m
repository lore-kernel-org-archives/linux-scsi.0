From: pcaldes <pcaldes@attglobal.net>
Subject: Re: aacraid not detecting drives if compiled into kernel
Date: Mon, 26 Feb 2007 12:51:53 -0600
Message-ID: <45E32C49.7030108@attglobal.net>
References: <AE4F746F2AECFC4DA4AADD66A1DFEF015BC88A@otce2k301.adaptec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from alnrmhc16.comcast.net ([204.127.225.96]:53810 "EHLO
	alnrmhc16.comcast.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932416AbXBZTA3 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 26 Feb 2007 14:00:29 -0500
In-Reply-To: <AE4F746F2AECFC4DA4AADD66A1DFEF015BC88A@otce2k301.adaptec.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Salyzyn, Mark" <mark_salyzyn@adaptec.com>
Cc: linux-scsi@vger.kernel.org

Thanx for your quick reply on Friday.
I was able to get the aacraid driver statically linked into the kernel 
to recognize the drive.

I found the 1.1-5-2420 drivers from the Adaptec site 
(aacraid_drv_1.1.5-2420.rpm)
Since there were no patches specifically for my kernel RHEL3  
(kernel-2.4.21-47.E),
I used the driver source located in aacraid_source.tgz which I used to 
replace everything in the drivers/scsi/aacraid directory
and recompiled the kernel.

How stable is the 1.1.5-2420 driver under 2.4?
Also, is 2420 the latest stable build?


Salyzyn, Mark wrote:
> The driver in RHEL3 is old (1.1.5-2412ish, so not that old), use the
> Adaptec supplied sources and we will investigate. You can find them in
> our download section, just pick a 'modern' aac based card and browse for
> the latest. I believe I fixed the last set of problems associate with
> compiling the driver static in the kernel in 1.1.5-2415. The testing was
> done under a 2.6 kernel though so we may have a new set of issues to
> work through ...
>
> Sincerely -- Mark Salyzyn
>
>   
>> -----Original Message-----
>> From: linux-scsi-owner@vger.kernel.org 
>> [mailto:linux-scsi-owner@vger.kernel.org] On Behalf Of pcaldes
>> Sent: Thursday, February 22, 2007 8:35 PM
>> To: linux-scsi@vger.kernel.org
>> Subject: aacraid not detecting drives if compiled into kernel
>>
>>
>> I'm using the Redhat kernel-2.4.21-47.EL on an IBM x3550 server which 
>> has a IBM ServeRAID 8k-l controller.
>> I recompiled kernel to include the aacraid driver in the 
>> kernel (not as 
>> a module) for use with a bootcd.
>> CONFIG_SCSI=y
>> CONFIG_BLK_DEV_SD=y
>> CONFIG_SCSI_AACRAID=y
>>
>> When the kernel loads, the aacraid driver initializes but it does not 
>> find the drive.
>> If I force the SCSI subsystem to rescan the host adapters, 
>> the aacraid 
>> driver finds the drive.
>>     # echo "scsi scan-new-devices" > /dev/scsi/scsi
>>
>> However, if I compile the aacraid driver as a module, when I do a 
>> 'modprobe aacraid' the driver loads and finds the drive.
>>
>> Any ideas on what is wrong and how to get around this?
>> I really need to have the aacraid driver compiled into the kernel for 
>> various reasons to avoid using an initrd.
>>     

