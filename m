From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: [PATCH 3/4] scsi_dh_rdac: Adding the match function for	rdac
 device handler
Date: Thu, 3 Nov 2011 11:17:48 -0400
Message-ID: <20111103151748.GA10627@redhat.com>
References: <47D23AD8469A2B448F33C24BD7A39BD9105DB4D8@RTPMVEXC1-PRD.hq.netapp.com>
 <4EB0EF3F.1010300@suse.de>
 <47D23AD8469A2B448F33C24BD7A39BD9105DB8EE@RTPMVEXC1-PRD.hq.netapp.com>
 <20111102154612.GA30632@redhat.com>
 <47D23AD8469A2B448F33C24BD7A39BD9105DBDC7@RTPMVEXC1-PRD.hq.netapp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:35503 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755396Ab1KCPR4 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 3 Nov 2011 11:17:56 -0400
Content-Disposition: inline
In-Reply-To: <47D23AD8469A2B448F33C24BD7A39BD9105DBDC7@RTPMVEXC1-PRD.hq.netapp.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Babu.Moger@netapp.com, device-mapper development <dm-devel@redhat.com>
Cc: Linux SCSI Mailing list <linux-scsi@vger.kernel.org>, hare@suse.de

On Thu, Nov 03 2011 at 10:47am -0400,
Moger, Babu <Babu.Moger@netapp.com> wrote:

> > -----Original Message-----
> > From: Mike Snitzer [mailto:snitzer@redhat.com]
> > Sent: Wednesday, November 02, 2011 10:46 AM
> > To: device-mapper development
> > Cc: Linux SCSI Mailing list
> > Subject: Re: [dm-devel] [PATCH 3/4] scsi_dh_rdac: Adding the match
> > function for rdac device handler
> > 
> > On Wed, Nov 02 2011 at 11:23am -0400,
> > Moger, Babu <Babu.Moger@netapp.com> wrote:
> > >
> > > OK. I will add the check for TPGS. I will send the patches tomorrow.
> > > For sending the VPD pages(0xC2, 0xC4 and 0xC8), I think we need be
> > little careful here.
> > > This includes sending these commands to every possible device in the
> > system. That is what we want to avoid.
> > > I will investigate more on that. That will be my next set of patches
> > independent of this.
> > 
> > Much appreciated.  I agree with Hannes, ideally we wouldn't need the
> > rdac dev_list.
> 
> Yes, We would like to remove the dependency on Vendor/product strings.
> I will work on that. These current patches will address the current the
> Attach issue which I mentioned in the description(PATCH 0/4).
> I will resubmit the patches now..

Great.

> > What about the issue where the appropriate scsi_dh isn't attached
> > during
> > scan (resulting in boot failures, trespasses, etc)?
> > 
> > Hannes, I know you had plans for how to address the early scsi_dh
> > attachment (and this match() work is a great step forward).  I just
> > wanted to touch base with you on what your current vision is on how to
> > achieve proper early scsi_dh attachment (and what the remaining TODO
> > is).
> 
> I am not aware of any other issue at this point. Hannes may know about it.

Yeap Hannes is aware.

I was referring to IO being issued to passive paths (ghost LUNs) because
scsi_dh isn't yet loaded.  Whereby causing the storage backend to
trespass unnecessarily.  This bouncing (and corresponding IO errors) are
avoided if the appropriate scsi_dh module is always loaded before the
storage driver (e.g. lpfc or qla2xxx).
