From: Brian Chadwick <brianchad-ncau/BB9MAPvnOemgxGiVw@public.gmane.org>
Subject: Re: raid 5 creation fails on usb3 connected drives kernel 4.4.x, 4.5
Date: Sun, 17 Apr 2016 14:41:51 +1000
Message-ID: <5713140F.6070304@westnet.com.au>
References: <20160406095308.GA31167@kroah.com>
 <5705EA77.7050408@westnet.com.au> <20160407144413.GD10853@kroah.com>
 <57067E1B.60706@westnet.com.au> <20160407155908.GA8655@kroah.com>
 <57077BC8.7010300@westnet.com.au> <20160408142435.GA4793@kroah.com>
 <5708D6F2.7000608@westnet.com.au> <20160416160840.GC10824@kroah.com>
 <1460823913.2333.3.camel@HansenPartnership.com>
 <20160416164623.GA3104@kroah.com>
Reply-To: brianchad-ncau/BB9MAPvnOemgxGiVw@public.gmane.org
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160416164623.GA3104-U8xfFu+wG4EAvxtiuMwx3w@public.gmane.org>
Sender: linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Greg KH <greg-U8xfFu+wG4EAvxtiuMwx3w@public.gmane.org>, James Bottomley <James.Bottomley-d9PhHud1JfjCXq6kfMZ53/egYHeGw8Jk@public.gmane.org>
Cc: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>, Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>, Hannes Reinecke <hare-l3A5Bk7waGM@public.gmane.org>, James Bottomley <JBottomley-O3H1v1f1dlM@public.gmane.org>, linux-usb-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-scsi@vger.kernel.org

On 17/04/16 02:46, Greg KH wrote:
> On Sat, Apr 16, 2016 at 09:25:13AM -0700, James Bottomley wrote:
>> On Sat, 2016-04-16 at 09:08 -0700, Greg KH wrote:
>>> On Sat, Apr 09, 2016 at 08:18:26PM +1000, Brian Chadwick wrote:
>>>> On 09/04/16 00:24, Greg KH wrote:
>>>>> On Fri, Apr 08, 2016 at 07:37:12PM +1000, Brian Chadwick wrote:
>>>>>> On 08/04/16 01:59, Greg KH wrote:
>>>>>>> On Fri, Apr 08, 2016 at 01:34:51AM +1000, Brian Chadwick
>>>>>>> wrote:
>>>>>>>> On 08/04/16 00:44, Greg KH wrote:
>>>>>>>>> On Thu, Apr 07, 2016 at 03:04:55PM +1000, Brian Chadwick
>>>>>>>>> wrote:
>>>>>>>>>> On 06/04/16 19:53, Greg KH wrote:
>>>>>>>>>>> On Tue, Apr 05, 2016 at 06:42:51PM +1000, Brian
>>>>>>>>>>> Chadwick wrote:
>>>>>>>>>>>> SETUP:
>>>>>>>>>>>>
>>>>>>>>>>>> i7 16GB Computer.
>>>>>>>>>>>>
>>>>>>>>>>>> 1 x PCI-x USB3 adaptor card (i think uses xhci
>>>>>>>>>>>> -hcd)04:00.0 USB controller:
>>>>>>>>>>>> Renesas Technology Corp. uPD720202 USB 3.0 Host
>>>>>>>>>>>> Controller (rev 02)
>>>>>>>>>>>>          Kernel driver in use: xhci_hcd
>>>>>>>>>>>>
>>>>>>>>>>>> 2 x USB3 to dual SATA HDD docks. uses JMicron
>>>>>>>>>>>> JMS56x Series controllers,
>>>>>>>>>>>> uses uas.ko kernel module
>>>>>>>>>>>> Bus 004 Device 002: ID 152d:9561 JMicron Technology
>>>>>>>>>>>> Corp. / JMicron USA
>>>>>>>>>>>> Technology Corp.
>>>>>>>>>>>> Bus 004 Device 003: ID 152d:9561 JMicron Technology
>>>>>>>>>>>> Corp. / JMicron USA
>>>>>>>>>>>> Technology Corp.
>>>>>>>>>>>>
>>>>>>>>>>>> 3 x Western Digital 320GB 3.5" SATA drives
>>>>>>>>>>>>
>>>>>>>>>>>> USE:
>>>>>>>>>>>>
>>>>>>>>>>>> RAID 5
>>>>>>>>>>>>
>>>>>>>>>>>> KERNEL:
>>>>>>>>>>>> 4.3.5
>>>>>>>>>>>>
>>>>>>>>>>>> System works perfectly as expected.
>>>>>>>>>>>>
>>>>>>>>>>>>
>>>>>>>>>>>> Change to kernel 4.4.x or 4.5 and RAID 5 doesnt
>>>>>>>>>>>> work. I am not sure whether
>>>>>>>>>>>> its actually RAID 5 at fault or if its the USB
>>>>>>>>>>>> Attached SCSI driver uas.ko,
>>>>>>>>>>>> or maybe the host driver xhci-hcd.
>>>>>>>>>>> Can you run 'git bisect' to try to track down the
>>>>>>>>>>> offending commit?
>>> <instructions about git-bisect snipped>
>>>
>>>> Hi, well to my surprise git bisect has come up with a commit about
>>>> which I
>>>> had no inkling. I may have to go to another mailing list it doesnt
>>>> look like
>>>> a usb problem.
>>>>
>>>> This is the final output of 'git bisect view' :
>>>>
>>>>
>>>> commit 64d513ac31bd02a3c9b69ef04444f36c196f9a9d
>>>> Author: Christoph Hellwig<hch-jcswGhMUV9g@public.gmane.org>
>>>> Date:   Thu Oct 8 09:28:04 2015 +0100
>>>>
>>>>      scsi: use host wide tags by default
>>>>
>>>>      This patch changes the !blk-mq path to the same defaults as the
>>>> blk-mq
>>>>      I/O path by always enabling block tagging, and always using
>>>> host wide
>>>>      tags.  We've had blk-mq available for a few releases so bugs
>>>> with
>>>>      this mode should have been ironed out, and this ensures we get
>>>> better
>>>>      coverage of over tagging setup over different configs.
>>>>
>>>>      Signed-off-by: Christoph Hellwig<hch-jcswGhMUV9g@public.gmane.org>
>>>>      Acked-by: Jens Axboe<axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>
>>>>      Reviewed-by: Hannes Reinecke<hare-l3A5Bk7waGM@public.gmane.org>
>>>>      Signed-off-by: James Bottomley<JBottomley-O3H1v1f1dlM@public.gmane.org>
>>>>
>>>>
>>>>
>>>> Thank you for your help in narrowing this down, and in educating me
>>>> about
>>>> git bisect (its a neat tool) ... I await your advice as how to
>>>> proceed from
>>>> here.
>>> Sorry for the delay, nice work tracking down the problem.
>>>
>>> Christoph, any ideas?  This patch is breaking this user's system as
>>> described above.  Is there a more recent fix for this, or did
>>> something
>>> forget to get changed in the large patch you did here?
>> If this is UAS connected devices, then this is likely the fix:
>>
>> http://marc.info/?l=linux-scsi&m=146045685829613
> Ah, nice, it's planned to go to Linus later today...
>
> Brian, can you test that patch out to see if it resolves your issue or
> not?
>
> thanks,
>
> greg k-h
>
Hi Greg, that patch has resolved the issue; I tested in 4.4.7 and 4.5.1. 
I am not sure how to test in the git tree so I'll just wait for git pull 
to get the change.

Many thanks to you and any others for your help and education.

Cheers

Brian C.
--
To unsubscribe from this list: send the line "unsubscribe linux-usb" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
