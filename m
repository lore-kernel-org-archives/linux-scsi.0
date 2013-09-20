From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: SCSI's heuristics for enabling WRITE SAME still need work [was: dm mpath: disable WRITE SAME if it fails]
Date: Fri, 20 Sep 2013 18:03:17 -0400
Message-ID: <yq1eh8jf8wq.fsf@sermon.lab.mkp.net>
References: <20130919161043.GA27081@redhat.com>
	<20130920212142.GA17898@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:21782 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752824Ab3ITWDW (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 20 Sep 2013 18:03:22 -0400
In-Reply-To: <20130920212142.GA17898@redhat.com> (Mike Snitzer's message of
	"Fri, 20 Sep 2013 17:21:42 -0400")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mike Snitzer <snitzer@redhat.com>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, dm-devel@redhat.com, linux-scsi@vger.kernel.org

>>>>> "Mike" == Mike Snitzer <snitzer@redhat.com> writes:

Mike,

Mike> AFAIK the reason for these heuristics is: devices that do support
Mike> WRITE SAME cannot properly report as much because they don't
Mike> support REPORT SUPPORTED OPERATION CODES -- this lack of RSOC
Mike> support is apparently very common?

Only a handful of the very latest and greatest devices support RSOC. The
number of devices that support WRITE SAME is orders of magnitude larger.

Last I checked I had exactly 1 out of about 100 devices in my lab that
supported RSOC.


Mike> I can appreciate the idea behind the current heuristics but I
Mike> think the prevelence of the other side of the spectrum (SCSI
Mike> devices that don't support RSOC or WRITE SAME) was underestimated.

If you by "devices" mean vintage PCI RAID controllers that don't pass
things through correctly, then yes. I don't think I have a single SCSI
drive that doesn't support WRITE SAME. And all the controllers I tested
with here worked fine.


Mike> As I say in that comment: "A proper fix could be to make SCSI's
Mike> default be to disable WRITE SAME for devices that don't properly
Mike> report they support it.  And possibly have a whitelist to opt-in
Mike> to enabling WRITE SAME for select targets."

The problem with the opt-in approach is that there are orders of
magnitude more devices that would need to get it enabled than there are
broken ones that need it disabled.

There are only a couple of handfuls of RAID controller drivers. We've
been working through the issues on these on a case by case basis.

Yes, I totally agree it sucks. And I hate that things broke for people
with Areca and 3ware. But we got those fixed. And it's way easier to
blacklist "all devices hanging off RAID driver xyz" than it is to
whitelist every SCSI drive known to man. It sucks in the short term but
is better long term.

The major headache here of course is that WRITE SAME is inherently
destructive. We can't just fire off one during discovery and see if it
works. For WRITE you can issue a command with a transfer length of 0 to
see if things work. But unfortunately for WRITE SAME a transfer length
of zero means "wipe the entire device". Yikes!

I guess we could read one sector and try to write it back using WRITE
SAME and a block count of one. But it's really icky. And I don't like
the notion of actually writing things during discovery.

As far as being able to trigger a restacking of the queue limits I think
it's inevitable. We see more and more devices that change properties
after a firmware upgrade. I think we'll just have to bite the bullet and
work on that...

-- 
Martin K. Petersen	Oracle Linux Engineering
