From: Hans de Goede <j.w.r.degoede@hhs.nl>
Subject: Re: Linux scsi / usb-mass-storage and HP printer
 cardreader bug + fix
Date: Thu, 10 Jan 2008 11:52:56 +0100
Message-ID: <4785F908.3080307@hhs.nl>
References: <47854051.1060307@hhs.nl> <4785F6CD.6050907@panasas.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-usb-devel-bounces@lists.sourceforge.net>
In-Reply-To: <4785F6CD.6050907@panasas.com>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/linux-usb-devel>,
	<mailto:linux-usb-devel-request@lists.sourceforge.net?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=linux-usb-devel>
List-Post: <mailto:linux-usb-devel@lists.sourceforge.net>
List-Help: <mailto:linux-usb-devel-request@lists.sourceforge.net?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/linux-usb-devel>,
	<mailto:linux-usb-devel-request@lists.sourceforge.net?subject=subscribe>
Sender: linux-usb-devel-bounces@lists.sourceforge.net
Errors-To: linux-usb-devel-bounces@lists.sourceforge.net
To: Boaz Harrosh <bharrosh@panasas.com>
Cc: Guillaume Bedot <littletux@zarb.org>, USB development list <linux-usb-devel@lists.sourceforge.net>, linux-scsi@vger.kernel.org, USB Storage list <usb-storage@lists.one-eyed-alien.net>, linux-usb@vger.kernel.org, David Brown <usb-storage2@davidb.org>, fedora-kernel-list@redhat.com
List-Id: linux-scsi@vger.kernel.org

Boaz Harrosh wrote:
> ----- Original Message -----
> *From:* Hans de Goede <j.w.r.degoede@hhs.nl>
> *To:* USB Storage list <usb-storage@lists.one-eyed-alien.net>
> *CC:* fedora-kernel-list@redhat.com, USB development list
> <linux-usb-devel@lists.sourceforge.net>, David Brown
> <usb-storage2@davidb.org>, Guillaume Bedot <littletux@zarb.org>,
> linux-scsi@vger.kernel.org, linux-usb@vger.kernel.org
> *Sent:* Wed, Jan 09 2008 at 23:44 +0200
> *Subject:* Linux scsi / usb-mass-storage and HP printer cardreader bug + fix
> 
> 
>> Hi All,
>>
>> First of all sorry for the somewhat massive cross-posting, I've spend a 
>> significant amount of time hunting down this bug, and so far the response has 
>> been less the overwhelming.
>>
>> The problem is with the HP PSC 1350 (my printer and confirmed by 2 others) and 
>> atleast also the HP PSC 1610 (confirmed by Guillaume Bedot, in the CC).
>>
>> The cardreader of the multi function printers will "crash" and from that moment 
>> on no longer communicate in any sane way, if you try to read the last sector of 
>> an sdcard* in a read that is more then 1 sector, so trying to read 8 sectors 
>> starting at sector capicity-8 will crash it, as will reading 2 sectors starting 
>> at sector capicity-2, however reading the last sector in a one 1 sector read 
>> will succeed! (* xdcards seem to be fine).
>>
>> I haven't tried if it will crash on larger then 1 sector writes which include 
>> the last sector too, I immediately added code to not do that in both the read 
>> and write paths. I have tested reading and writing the end of the disk with 
>> this kludge in and it works.
>>
>> I currently have a somewhat ugly proof of concept patch for this, which adds 
>> another type of usb-massstorage quirk. When this quirk flag is set, the 
>> usb-massstorage driver modifies READ_10 and WRITE_10 commands of more then 1 
>> sector which includes the last sector to become one sector less. I've been told 
>> by scsi subsystem developers that doing a shorter read / write then requested 
>> is not a problem, the scsi subsystem is designed to handle getting less then it 
>> asked for and will send a seperate request for the last sector.
>>
>> I and 3 others (2 on a PSC 1350 too, one on a PSC1610) have tested this patch 
>> with success. I'm not asking for this patch to be included to the kernel as is, 
>> I'm asking for the now known workaround for this to be added to the kernel in 
>> someway!
>>
>> Perhaps its an idea to add the posibility to have a scsi command filter 
>> function / callback to the scsi or usb-massstorage subsystem, and then add a 
>> mechanism to set this filter depending on usb id's and if added to the scsi 
>> layer, a mechanism to set it based on scsi device and manufacturer 
>> identification strings. Such a mechanism might be usefull in the future to work 
>> around other broken hardware too, and has the added advantage of not having 
>> todo much changes to the normal code path, keep that readable.
>>
>> I'm willing to come up with a patch for such a filter mechanism, provided I get 
>> some pointers where this is best added.
>>
>> Thanks & Regards,
>>
>> Hans
>>
>>
>> p.s.
>>
>> I've also included the fedora-kernel list in the addressee's because I was 
>> hoping that maybe someone can take one of these printers to the kernel hackfest 
>>    in the weekend's fudcon and take a look at this.
>>   
>> +		if ((offset + num) == sdkp->capacity && num > 1) {
>> +			if (srb->cmnd[8] == 0)
>> +				srb->cmnd[7]--;
>> +			srb->cmnd[8]--;
>> +			srb->request_bufflen -= 512;
>> +			srb->underflow -= 512;
>> +		}
>>   
> This will no longer compile on top of latest scsi-misc, and
> LLDs are not suppose to modify request_bufflen anymore.
> 
> I'm not sure what the proper solution should be?
> 

I guess the proper solution would be to add a special case to the scsi layer 
where the read10 / write10 command is issued, and split the request in 2 there 
when it involves the last sector.

There was another reply in this thread stating that problems reading the last 
sector with sd / mmc cards happen quite often, and that this is most likely not 
an isolated case.

Regards,

Hans


-------------------------------------------------------------------------
Check out the new SourceForge.net Marketplace.
It's the best place to buy or sell services for
just about anything Open Source.
http://ad.doubleclick.net/clk;164216239;13503038;w?http://sf.net/marketplace
_______________________________________________
linux-usb-devel@lists.sourceforge.net
To unsubscribe, use the last form field at:
https://lists.sourceforge.net/lists/listinfo/linux-usb-devel
