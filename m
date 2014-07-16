From: "Elliott, Robert (Server Storage)" <Elliott@hp.com>
Subject: RE: [PATCH 4/8] Drivers: scsi: storvsc: Filter WRITE_SAME_16
Date: Wed, 16 Jul 2014 18:43:43 +0000
Message-ID: <94D0CD8314A33A4D9D801C0FE68B402958BA721F@G9W0745.americas.hpqcorp.net>
References: <20140709084300.GD6012@infradead.org>
	 <a31a45eddb544024a7538458b98c3611@BY2PR03MB299.namprd03.prod.outlook.com>
	 <1404935792.2184.5.camel@dabdike.int.hansenpartnership.com>
	 <2f3ae589e6f149acbe4c5dd79f905971@BY2PR03MB299.namprd03.prod.outlook.com>
	 <1404944843.2184.8.camel@dabdike.int.hansenpartnership.com>
	 <20140711063216.GA20660@infradead.org>
	 <328b7a6174ef4dd8a54a7db5ac959834@BY2PR03MB299.namprd03.prod.outlook.com>
	 <yq1a98d2z5x.fsf@sermon.lab.mkp.net> <20140716110111.GA7382@infradead.org>
	 <yq14myhtijx.fsf@sermon.lab.mkp.net> <20140716173827.GB20528@infradead.org>
	 <yq1fvi1rya0.fsf@sermon.lab.mkp.net>
 <1405533734.3165.12.camel@dabdike.int.hansenpartnership.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from g4t3425.houston.hp.com ([15.201.208.53]:30890 "EHLO
	g4t3425.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934841AbaGPSpL convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 16 Jul 2014 14:45:11 -0400
In-Reply-To: <1405533734.3165.12.camel@dabdike.int.hansenpartnership.com>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <jbottomley@parallels.com>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "hch@infradead.org" <hch@infradead.org>, "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>, "apw@canonical.com" <apw@canonical.com>, "kys@microsoft.com" <kys@microsoft.com>, "stable@vger.kernel.org" <stable@vger.kernel.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "ohering@suse.com" <ohering@suse.com>, "jasowang@redhat.com" <jasowang@redhat.com>



> -----Original Message-----
> From: linux-scsi-owner@vger.kernel.org [mailto:linux-scsi-
> owner@vger.kernel.org] On Behalf Of James Bottomley
> Sent: Wednesday, 16 July, 2014 1:02 PM
> To: martin.petersen@oracle.com
> Cc: linux-kernel@vger.kernel.org; hch@infradead.org;
> devel@linuxdriverproject.org; apw@canonical.com; kys@microsoft.com;
> stable@vger.kernel.org; linux-scsi@vger.kernel.org; ohering@suse.com;
> jasowang@redhat.com
> Subject: Re: [PATCH 4/8] Drivers: scsi: storvsc: Filter WRITE_SAME_16
> 
> On Wed, 2014-07-16 at 13:47 -0400, Martin K. Petersen wrote:
> > >>>>> "Christoph" == hch@infradead org <hch@infradead.org> writes:
> >
> > Christoph> Oh, we actually have devices that support WRITE SAME with
> > Christoph> unmap, but not without?  That's defintively a little strange.
> >
> > Yep :(
> >
> > There were several SSDs that did not want to support wearing out flash
> > by writing gobs of zeroes and only support the UNMAP case.
> >
> > Christoph> Yes, and it did this intentionally.  I really wouldn't expect
> > Christoph> devices to support WRITE SAME with UNMAP but blow up on a
> > Christoph> WRITE SAME without it (and not just simple fail it in an
> > Christoph> orderly way).
> >
> > *sigh*
> >
> > Christoph> It definitively seems odd to default to trying WRITE SAME for
> > Christoph> unmap for a device that explicitly tells us that it doesn't
> > Christoph> support WRITE SAME.
> >
> > Maybe it's just a naming thing. I was really trying to convey
> > no_req_write_same support, not no_write_same_10_or_16.
> >
> > Christoph> Note that I'm not against your patch - I suspect forcing us
> > Christoph> to read EVPD pages even for devices that claim to be SPC-2
> > Christoph> will come in useful in various scenarios.
> >
> > I don't have a problem with a BLIST_PREFER_UNMAP flag or something like
> > that. But BLIST_TRY_VPD_PAGES seems more generally useful and it does
> > fix the problem at hand. That's why I went that route.
> 
> Hang on ... unless we apply Christoph or my fix, we'll get the same
> issue with every raid driver (that's about 10 I think) that set
> no_write_same when they hit a >2TB RAID volume, so I think we need both
> fixes.
> 
> James
> 

WRITE SAME with the UNMAP bit set to one (and a few other
conditions) guarantees that the data is zeroed out, while
the UNMAP command is just a hint.  They're not fully
interchangeable.  Which semantics are implied by REQ_DISCARD
and these functions?

One benefit of UNMAP is that UNMAP supports a list of 
discontiguous LBA ranges, whereas WRITE SAME just supports 
one LBA range.  sd_setup_discard_cmnd is not taking
advantage of this feature, though.  Ideally, the block
layer would merge multiple discards into one UNMAP command 
if they're stuck on the request queue for a while, like 
it merges adjacent reads and writes.  That would pave the way
for building up WRITE SCATTERED and READ GATHERED commands.


