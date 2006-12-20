From: "Brett G. Durrett" <brett@imvu.com>
Subject: Re: megaraid_sas waiting for command and then offline
Date: Tue, 19 Dec 2006 17:03:11 -0800
Message-ID: <45888BCF.6040901@imvu.com>
References: <457E1C59.80208@metacarta.com> <457E3D0D.7070707@imvu.com> <457E43BE.9040806@metacarta.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from 66-117-159-244.lmi.net ([66.117.159.244]:51584 "EHLO slick.org"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S932894AbWLTB10 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 19 Dec 2006 20:27:26 -0500
In-Reply-To: <457E43BE.9040806@metacarta.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Joseph Malicki <jmalicki@metacarta.com>
Cc: "linux-scsi "@vger.kernel.org, "David N. Welton" <d.welton@webster.it>, linux-poweredge@dell.com, Sumant Patro <Sumant.Patro@lsil.com>, "Marc A. Meadows" <mam+megaraid@metacarta.com>, "Keith R. Baker" <krbaker+megaraid@metacarta.com>


Just replied to another poster but wanted to respond to this thread as 
well...

Joe,

Huge thanks for the pointer to the new firmware... I had a page 
bookmarked for the 2950 firmware but the bookmark went to an old page. 

We are running 16G machines, dual core, dual CPU, RAID 5 on Perc5i.  The 
kernel is 2.6.18 and I think all of Sumant's changes are in 2.6.19.  The 
patrol reads did not seem to correlate to the failures.

Some possibly good news: It is probably too early to say for sure, but I 
upgraded the firmware and have not had a failure on any of the machines 
with the new firmware.  I will not feel this is "fixed" until I go 
another two weeks with no failures.

The notes in the firmware update are supposed to fix a problem that is 
consistent with our failures:

4.0 Fixes

Addresses potential issue with PERC 5 controllers that may become 
unresponsive on systems with 8GB of memory or more.  This fix corrects 
an issue on systems with 8+ GB of memory PERC 5 controllers may become 
unresponsive. If the affected controller is the boot device this would 
cause an OS crash, hang, or bluescreen. If not the boot controller the 
system would experience timeouts (event 129 and 9 in windows, IO aborts 
in Linux). Once the controller is in this state it will not return to 
operation until the system has rebooted, any storage connected to the 
controller will not be accessible until the reboot.
This has now been corrected.

B-

Joseph Malicki wrote:
> Hi Brett!
>
> Thanks for the response, hopefully we can gather enough data points to 
> help solve the problem.
>
> The new PERC 5/i integrated firmware dated 11/21/2006 is at:
> http://support.dell.com/support/downloads/format.aspx?c=us&l=en&s=gen&SystemID=PWE_2950&os=LIN4&osl=en&deviceid=9182&typecnt=2&libid=46&releaseid=R139225&vercnt=3 
>
> PERC 5/E adapter: 
> http://support.dell.com/support/downloads/format.aspx?c=us&l=en&s=gen&SystemID=PWE_2950&os=LIN4&osl=en&deviceid=9181&typecnt=2&libid=46&releaseid=R139227&vercnt=2 
>
>
> The release notes describe very similar symptoms, but I am not ready 
> to believe it yet as I can't reliably reproduce the problem well 
> enough to be confident of a fix, though it sounds like you might be 
> able to.    Unfortunately we're using Debian at the moment, but if I 
> can reproduce I can run on RHEL in a heartbeat to duplicate it for 
> support (for now I'm trying to minimize variables).
>
> Also, which driver version are you running?  I noticed you were using 
> some patches from Sumant Patro@LSI - is your driver identical to the 
> one in 2.6.19?  If not, what does it look like?
>
> Have you noticed any correlations with patrol reads at the times of 
> the failures? You can tell by running MegaCli -FwTermLog -Dsply -aALL
>
> What hardware are you running (CPUs, RAM, disk configuration)?
>
> Have you noticed any correlation with heavy network I/O (as well as 
> disk I/O)?  Some of our systems may have experienced this when running 
> more network load than typical.
>
>
> Thanks!
> Joe
>
> Brett G. Durrett wrote:
>>
>> I am still seeing this and we have between 2 and 5 failures per week 
>> (across almost 20 machines).  I am seeing it on ext3 (we migrated all 
>> of the machines from XFS) and with ReadAhead disabled.
>>
>> You mention a firmware update but I don't see any new PERC 5 firmware 
>> packages on Dell's site... can you give me a pointer to the firmware 
>> update?
>>
>> Also, has anybody had this problem on RHE?  Dell does not support 
>> Linux unless it is RHE... I would be surprised is somehow RHE did not 
>> have this problem.
>>
>> B-
>>
>>
>>
>> Joe Malicki wrote:
>>>>  I have the same or a similar issue running 2.6.17 SMP x86_64 - the
>>>> megaraid_sas driver hangs waiting for commands and then the filesystem
>>>> unmounts, leaving the machine in an unusable state until there is a 
>>>> hard
>>>> reboot (the machine is responsive but any access, shell or 
>>>> otherwise, is
>>>> impossible without the filesystem). While I do not have much debugging
>>>> information available, this happens to me about once every 6-7 days in
>>>> my pool of seven machines, so I can probably get debugging info. Since
>>>> the disk is offline and I can't get remote console, I don't have any
>>>> details except something similar to Dave Lloyd's post, below.
>>>>     
>>>
>>
>
