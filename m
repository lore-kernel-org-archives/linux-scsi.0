From: Douglas Gilbert <dgilbert@interlog.com>
Subject: Re: SCSI's heuristics for enabling WRITE SAME still need work [was:
 dm mpath: disable WRITE SAME if it fails]
Date: Sat, 21 Sep 2013 11:28:25 -0400
Message-ID: <523DBB19.7090404@interlog.com>
References: <20130919161043.GA27081@redhat.com>	<20130920212142.GA17898@redhat.com> <yq1eh8jf8wq.fsf@sermon.lab.mkp.net>
Reply-To: dgilbert@interlog.com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.infotech.no ([82.134.31.41]:34276 "EHLO smtp.infotech.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751737Ab3IUP2t (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 21 Sep 2013 11:28:49 -0400
In-Reply-To: <yq1eh8jf8wq.fsf@sermon.lab.mkp.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>, Mike Snitzer <snitzer@redhat.com>
Cc: dm-devel@redhat.com, linux-scsi@vger.kernel.org

On 13-09-20 06:03 PM, Martin K. Petersen wrote:
>>>>>> "Mike" == Mike Snitzer <snitzer@redhat.com> writes:
>
> Mike,
>
> Mike> AFAIK the reason for these heuristics is: devices that do support
> Mike> WRITE SAME cannot properly report as much because they don't
> Mike> support REPORT SUPPORTED OPERATION CODES -- this lack of RSOC
> Mike> support is apparently very common?
>
> Only a handful of the very latest and greatest devices support RSOC. The
> number of devices that support WRITE SAME is orders of magnitude larger.
>
> Last I checked I had exactly 1 out of about 100 devices in my lab that
> supported RSOC.
>
>
> Mike> I can appreciate the idea behind the current heuristics but I
> Mike> think the prevelence of the other side of the spectrum (SCSI
> Mike> devices that don't support RSOC or WRITE SAME) was underestimated.
>
> If you by "devices" mean vintage PCI RAID controllers that don't pass
> things through correctly, then yes. I don't think I have a single SCSI
> drive that doesn't support WRITE SAME. And all the controllers I tested
> with here worked fine.
>
>
> Mike> As I say in that comment: "A proper fix could be to make SCSI's
> Mike> default be to disable WRITE SAME for devices that don't properly
> Mike> report they support it.  And possibly have a whitelist to opt-in
> Mike> to enabling WRITE SAME for select targets."
>
> The problem with the opt-in approach is that there are orders of
> magnitude more devices that would need to get it enabled than there are
> broken ones that need it disabled.
>
> There are only a couple of handfuls of RAID controller drivers. We've
> been working through the issues on these on a case by case basis.
>
> Yes, I totally agree it sucks. And I hate that things broke for people
> with Areca and 3ware. But we got those fixed. And it's way easier to
> blacklist "all devices hanging off RAID driver xyz" than it is to
> whitelist every SCSI drive known to man. It sucks in the short term but
> is better long term.
>
> The major headache here of course is that WRITE SAME is inherently
> destructive. We can't just fire off one during discovery and see if it
> works. For WRITE you can issue a command with a transfer length of 0 to
> see if things work. But unfortunately for WRITE SAME a transfer length
> of zero means "wipe the entire device". Yikes!
>
> I guess we could read one sector and try to write it back using WRITE
> SAME and a block count of one. But it's really icky. And I don't like
> the notion of actually writing things during discovery.
>
> As far as being able to trigger a restacking of the queue limits I think
> it's inevitable. We see more and more devices that change properties
> after a firmware upgrade. I think we'll just have to bite the bullet and
> work on that...

Would a closer examination of the available VPD pages
help? For example support for the Logical Block
Provisioning and Block Limits VPD pages. Given either
of those two pages, even if the WRITE SAME specific
fields in those pages are not set, it is unlikely that
sending a WRITE SAME (when actually required rather
than at discovery) would wedge the disk/controller.

If WSNZ is set in the Block Limits VPD pages then it
should be "safe" ** to send a zero length WRITE SAME
command to a LU. And that is another good reason to
check the response of a VPD page request carefully
(e.g. the echo-ed page_code in byte 1 and a sensible
page_length in bytes 2 and 3) since crap devices often
return a standard INQUIRY response to a VPD page request.

Doug Gilbert


** there is departure from the normal "do nothing when
    transfer_length or number_of_LB fields are zero":
    In the case of the WS command with number_of_LBs=0
    and WSNZ=1 in the BLOCK LIMITS VPD page, the response
    should be ILLEGAL_REQUEST with INVALID FIELD IN CDB.
    I guess if it yielded status=GOOD in that case and
    you heard the disk clicking, you might get quite
    worried :-)

