From: Ewan Milne <emilne@redhat.com>
Subject: Re: SCSI's heuristics for enabling WRITE SAME still need work
 [was: dm mpath: disable WRITE SAME if it fails]
Date: Mon, 23 Sep 2013 14:18:45 -0400
Message-ID: <1379960325.4010.32.camel@localhost.localdomain>
References: <20130919161043.GA27081@redhat.com>
	 <20130920212142.GA17898@redhat.com>  <yq1eh8jf8wq.fsf@sermon.lab.mkp.net>
Reply-To: emilne@redhat.com
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:30848 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753962Ab3IWSSu (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 23 Sep 2013 14:18:50 -0400
In-Reply-To: <yq1eh8jf8wq.fsf@sermon.lab.mkp.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>, dgilbert@interlog.com
Cc: Mike Snitzer <snitzer@redhat.com>, dm-devel@redhat.com, linux-scsi@vger.kernel.org

On Fri, 2013-09-20 at 18:03 -0400, Martin K. Petersen wrote:
...
> Only a handful of the very latest and greatest devices support RSOC. The
> number of devices that support WRITE SAME is orders of magnitude larger.
> 
> Last I checked I had exactly 1 out of about 100 devices in my lab that
> supported RSOC.
...
> The major headache here of course is that WRITE SAME is inherently
> destructive. We can't just fire off one during discovery and see if it
> works. For WRITE you can issue a command with a transfer length of 0 to
> see if things work. But unfortunately for WRITE SAME a transfer length
> of zero means "wipe the entire device". Yikes!
> 
> I guess we could read one sector and try to write it back using WRITE
> SAME and a block count of one. But it's really icky. And I don't like
> the notion of actually writing things during discovery.
...

Just out of curiosity, what do the devices that support WRITE SAME
report for the MAXIMUM WRITE SAME LENGTH field in VPD page B0?  The
spec says that this can be zero if there is no restriction, but is
there any chance that most/all of them report some nonzero value?

Expanding on Doug's thinking, perhaps there is some combination of
VPD page availability / field values that could be used to explicitly
enable WRITE SAME?  Or, have you been through that already?

-Ewan


