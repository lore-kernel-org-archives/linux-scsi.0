From: "hch@infradead.org" <hch@infradead.org>
Subject: Re: [PATCH 4/8] Drivers: scsi: storvsc: Filter WRITE_SAME_16
Date: Thu, 17 Jul 2014 00:42:34 -0700
Message-ID: <20140717074234.GA7604@infradead.org>
References: <20140711063216.GA20660@infradead.org>
 <328b7a6174ef4dd8a54a7db5ac959834@BY2PR03MB299.namprd03.prod.outlook.com>
 <yq1a98d2z5x.fsf@sermon.lab.mkp.net>
 <20140716110111.GA7382@infradead.org>
 <yq14myhtijx.fsf@sermon.lab.mkp.net>
 <20140716173827.GB20528@infradead.org>
 <yq1fvi1rya0.fsf@sermon.lab.mkp.net>
 <1405533734.3165.12.camel@dabdike.int.hansenpartnership.com>
 <94D0CD8314A33A4D9D801C0FE68B402958BA721F@G9W0745.americas.hpqcorp.net>
 <yq138e1rtzz.fsf@sermon.lab.mkp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <stable-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <yq138e1rtzz.fsf@sermon.lab.mkp.net>
Sender: stable-owner@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: "Elliott, Robert (Server Storage)" <Elliott@hp.com>, James Bottomley <jbottomley@parallels.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "hch@infradead.org" <hch@infradead.org>, "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>, "apw@canonical.com" <apw@canonical.com>, "kys@microsoft.com" <kys@microsoft.com>, "stable@vger.kernel.org" <stable@vger.kernel.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "ohering@suse.com" <ohering@suse.com>, "jasowang@redhat.com" <jasowang@redhat.com>
List-Id: linux-scsi@vger.kernel.org

On Wed, Jul 16, 2014 at 03:20:00PM -0400, Martin K. Petersen wrote:
> The block layer can only describe one contiguous block range in a
> request. My copy offload patches introduces the bi_special field that
> allows us to attach additional information to an I/O. I have
> experimented with doing that for discards to overcome the suck of DSM
> TRIM. Splitting and merging requests in MD/DM gets much more cumbersome,
> though.

I had a bunch of prototypes for this years ago that didn't really work
out.  I always made ranged didscards something that driver had to opt
in for.  In my case md and dm never opted in, although for mirroring or
multipath it should of course handle it fairly easily.

> It also wasn't evident that it was worth the hassle. While UNMAP allows
> us to express large regions, DSM TRIM on the SATA side is limited to 32
> MB per range. So in many cases we end up maxing out the payload capacity
> even with a single contiguous range.

That's mostly because we don't support larger than 512 byte TRIM payloads
yet..
