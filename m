From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: SCSI's heuristics for enabling WRITE SAME still need work [was:
 dm mpath: disable WRITE SAME if it fails]
Date: Tue, 24 Sep 2013 08:34:50 -0400
Message-ID: <20130924123449.GA16083@redhat.com>
References: <20130919161043.GA27081@redhat.com>
 <20130920212142.GA17898@redhat.com>
 <yq1eh8jf8wq.fsf@sermon.lab.mkp.net>
 <1379960325.4010.32.camel@localhost.localdomain>
 <52412581.2010909@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:45424 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753270Ab3IXMe4 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 24 Sep 2013 08:34:56 -0400
Content-Disposition: inline
In-Reply-To: <52412581.2010909@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: emilne@redhat.com, device-mapper development <dm-devel@redhat.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, dgilbert@interlog.com, linux-scsi@vger.kernel.org

On Tue, Sep 24 2013 at  1:39am -0400,
Hannes Reinecke <hare@suse.de> wrote:

> On 09/23/2013 08:18 PM, Ewan Milne wrote:
> > On Fri, 2013-09-20 at 18:03 -0400, Martin K. Petersen wrote:
> > ...
> >> Only a handful of the very latest and greatest devices support RSOC. The
> >> number of devices that support WRITE SAME is orders of magnitude larger.
> >>
> >> Last I checked I had exactly 1 out of about 100 devices in my lab that
> >> supported RSOC.
> > ...
> >> The major headache here of course is that WRITE SAME is inherently
> >> destructive. We can't just fire off one during discovery and see if it
> >> works. For WRITE you can issue a command with a transfer length of 0 to
> >> see if things work. But unfortunately for WRITE SAME a transfer length
> >> of zero means "wipe the entire device". Yikes!
> >>
> >> I guess we could read one sector and try to write it back using WRITE
> >> SAME and a block count of one. But it's really icky. And I don't like
> >> the notion of actually writing things during discovery.
> > ...
> > 
> > Just out of curiosity, what do the devices that support WRITE SAME
> > report for the MAXIMUM WRITE SAME LENGTH field in VPD page B0?  The
> > spec says that this can be zero if there is no restriction, but is
> > there any chance that most/all of them report some nonzero value?
> > 
> > Expanding on Doug's thinking, perhaps there is some combination of
> > VPD page availability / field values that could be used to explicitly
> > enable WRITE SAME?  Or, have you been through that already?
> > 
> Hehe. Won't do any good.
> 
> My drives support 'report opcodes', and report that write same is
> supported:
> ...
>  93                 16    Write same(16)
> ...
> 
> but no support for page 'b0'. And yes, these are real SAS drives.

Your drive would be fine then since it does support RSOC and specifies
WRITE SAME is supported.  Pretty sure Ewan was only suggesting to resort
to looking at the VPD page if RSOC isn't supported.

So are there drives like this?:
1) don't support RSOC
2) do support WRITE SAME
3) do populate VPD page with either WRITE SAME w/ discard bit set or
UNMAP?
