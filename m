From: James Smart <James.Smart@Emulex.Com>
Subject: Re: lp8000 and 2.6.18-rc6
Date: Mon, 11 Sep 2006 08:21:35 -0400
Message-ID: <450554CF.4060906@emulex.com>
References: <20060909210856.GC21263@stat.unipd.it> <20060910135631.GD29775@parisc-linux.org> <20060910210444.GC22873@stat.unipd.it> <4504B6AF.3080909@torque.net> <1157941050.3467.21.camel@mulgrave.il.steeleye.com> <20060911095109.GA4953@stat.unipd.it>
Reply-To: James.Smart@Emulex.Com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from emulex.emulex.com ([138.239.112.1]:7579 "EHLO emulex.emulex.com")
	by vger.kernel.org with ESMTP id S1751421AbWIKMVv (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 11 Sep 2006 08:21:51 -0400
In-Reply-To: <20060911095109.GA4953@stat.unipd.it>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: mmzz@stat.unipd.it, linux-scsi@vger.kernel.org

What this tells me is that the reporting as a scsi-4 device is
telling the midlayer to use Report Luns, and that Report Luns is likely
failing on this target. If the manual scans succeed, it says the
luns are there, but were not reported in Report Luns. What you are
encountering is an interaction between the target device and the midlayer
scan behaviors. You should have like behavior on other adapters.
Sounds like this device could use a device list entry.

Please note: it is general practice that /proc stuff for adapters is
being deprecated in lieu of using the /sys/class/scsi_host/host<#>
attributes. This has been true for the lpfc driver as it was a
requirement when we first integrated into kernel.org around 2.6.10.
Expect other adapters to behave the same as lpfc.

-- james

Alberto Cammozzo wrote:
> On Sun, Sep 10, 2006 at 09:17:30PM -0500, James Bottomley wrote:
>> On Sun, 2006-09-10 at 21:06 -0400, Douglas Gilbert wrote:
>>> Type 0 is for disks, strange that sd didn't pick up
>>> those devices on host 7. Could you fetch the sg3_utils
>>> package, build it and try 'sg_inq /dev/sg6'. The output
>>> may be interesting.
>> That would be characteristic of a zoned array returning PQ not connected
>> (or not present) as James Smart suggested ...
>>
>> sg_inq would confirm this theory.
> 
> 	Thank you James, 
> 
> 	Eventually we managed to solve the problem: 
> 
> 	Debian sarge has an old rescan-scsi-bus.sh version based on /proc
> 	instead of /sys. 
> 
> 	newer lpfc module in 2.6.18 kernels doesn't fill /proc/scsi/HOSTADAPTER, 
> 	so older rescan-scsi-bus don't even try to map new devices.
> 
> 	Summarizing: to make partitions visible with lpfc drivers 
> 	for Emulex LP8000 HBA under 2.6.18 kernels, use newer rescan-scsi-bus 
> 	http://www.garloff.de/kurt/linux/rescan-scsi-bus.sh
> 
> 	Thank you everyone for support and the nice work.
> 
> 	Alberto
> 
> 
