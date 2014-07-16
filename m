From: James Bottomley <jbottomley@parallels.com>
Subject: Re: [PATCH 4/8] Drivers: scsi: storvsc: Filter WRITE_SAME_16
Date: Wed, 16 Jul 2014 18:02:14 +0000
Message-ID: <1405533734.3165.12.camel@dabdike.int.hansenpartnership.com>
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
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <stable-owner@vger.kernel.org>
In-Reply-To: <yq1fvi1rya0.fsf@sermon.lab.mkp.net>
Content-Language: en-US
Content-ID: <CF87AB6BF3B33C439C18C9A9D3B76DDB@sw.swsoft.com>
Sender: stable-owner@vger.kernel.org
To: "martin.petersen@oracle.com" <martin.petersen@oracle.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "hch@infradead.org" <hch@infradead.org>, "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>, "apw@canonical.com" <apw@canonical.com>, "kys@microsoft.com" <kys@microsoft.com>, "stable@vger.kernel.org" <stable@vger.kernel.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "ohering@suse.com" <ohering@suse.com>, "jasowang@redhat.com" <jasowang@redhat.com>
List-Id: linux-scsi@vger.kernel.org

On Wed, 2014-07-16 at 13:47 -0400, Martin K. Petersen wrote:
> >>>>> "Christoph" == hch@infradead org <hch@infradead.org> writes:
> 
> Christoph> Oh, we actually have devices that support WRITE SAME with
> Christoph> unmap, but not without?  That's defintively a little strange.
> 
> Yep :(
> 
> There were several SSDs that did not want to support wearing out flash
> by writing gobs of zeroes and only support the UNMAP case.
> 
> Christoph> Yes, and it did this intentionally.  I really wouldn't expect
> Christoph> devices to support WRITE SAME with UNMAP but blow up on a
> Christoph> WRITE SAME without it (and not just simple fail it in an
> Christoph> orderly way).
> 
> *sigh*
> 
> Christoph> It definitively seems odd to default to trying WRITE SAME for
> Christoph> unmap for a device that explicitly tells us that it doesn't
> Christoph> support WRITE SAME.
> 
> Maybe it's just a naming thing. I was really trying to convey
> no_req_write_same support, not no_write_same_10_or_16.
> 
> Christoph> Note that I'm not against your patch - I suspect forcing us
> Christoph> to read EVPD pages even for devices that claim to be SPC-2
> Christoph> will come in useful in various scenarios.
> 
> I don't have a problem with a BLIST_PREFER_UNMAP flag or something like
> that. But BLIST_TRY_VPD_PAGES seems more generally useful and it does
> fix the problem at hand. That's why I went that route.

Hang on ... unless we apply Christoph or my fix, we'll get the same
issue with every raid driver (that's about 10 I think) that set
no_write_same when they hit a >2TB RAID volume, so I think we need both
fixes.

James
