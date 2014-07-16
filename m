From: "hch@infradead.org" <hch@infradead.org>
Subject: Re: [PATCH 4/8] Drivers: scsi: storvsc: Filter WRITE_SAME_16
Date: Wed, 16 Jul 2014 10:38:27 -0700
Message-ID: <20140716173827.GB20528@infradead.org>
References: <20140709084300.GD6012@infradead.org>
 <a31a45eddb544024a7538458b98c3611@BY2PR03MB299.namprd03.prod.outlook.com>
 <1404935792.2184.5.camel@dabdike.int.hansenpartnership.com>
 <2f3ae589e6f149acbe4c5dd79f905971@BY2PR03MB299.namprd03.prod.outlook.com>
 <1404944843.2184.8.camel@dabdike.int.hansenpartnership.com>
 <20140711063216.GA20660@infradead.org>
 <328b7a6174ef4dd8a54a7db5ac959834@BY2PR03MB299.namprd03.prod.outlook.com>
 <yq1a98d2z5x.fsf@sermon.lab.mkp.net>
 <20140716110111.GA7382@infradead.org>
 <yq14myhtijx.fsf@sermon.lab.mkp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <driverdev-devel-bounces@linuxdriverproject.org>
Content-Disposition: inline
In-Reply-To: <yq14myhtijx.fsf@sermon.lab.mkp.net>
List-Unsubscribe: <http://driverdev.linuxdriverproject.org/mailman/options/driverdev-devel>,
 <mailto:driverdev-devel-request@linuxdriverproject.org?subject=unsubscribe>
List-Archive: <http://driverdev.linuxdriverproject.org/pipermail/driverdev-devel>
List-Post: <mailto:driverdev-devel@linuxdriverproject.org>
List-Help: <mailto:driverdev-devel-request@linuxdriverproject.org?subject=help>
List-Subscribe: <http://driverdev.linuxdriverproject.org/mailman/listinfo/driverdev-devel>,
 <mailto:driverdev-devel-request@linuxdriverproject.org?subject=subscribe>
Errors-To: driverdev-devel-bounces@linuxdriverproject.org
Sender: driverdev-devel-bounces@linuxdriverproject.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "jasowang@redhat.com" <jasowang@redhat.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, James Bottomley <jbottomley@parallels.com>, "ohering@suse.com" <ohering@suse.com>, "hch@infradead.org" <hch@infradead.org>, "stable@vger.kernel.org" <stable@vger.kernel.org>, "apw@canonical.com" <apw@canonical.com>, "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>
List-Id: linux-scsi@vger.kernel.org

On Wed, Jul 16, 2014 at 11:44:18AM -0400, Martin K. Petersen wrote:
> There are lots of devices out there that support WRITE SAME(10) or (16)
> without the UNMAP bit. And there are devices that support WRITE SAME w/
> UNMAP functionality but not "regular" WRITE SAME.

Oh, we actually have devices that support WRITE SAME with unmap, but not
without?  That's defintively a little strange.

> no_write_same is there to prevent the REQ_WRITE_SAME use case (for which
> we have really weak heuristics). Your patch overloads no_write_same so
> it also governs a REQ_DISCARD use case.

Yes, and it did this intentionally.  I really wouldn't expect devices
to support WRITE SAME with UNMAP but blow up on a WRITE SAME without
it (and not just simple fail it in an orderly way).

> My proposed black list patch fixes the hyperv discard issue. So I don't
> see why we'd need to overload no_write_same which was meant for an
> entirely different purpose.

It definitively seems odd to default to trying WRITE SAME for unmap
for a device that explicitly tells us that it doesn't support WRITE
SAME.

Note that I'm not against your patch - I suspect forcing us to read
EVPD pages even for devices that claim to be SPC-2 will come in useful
in various scenarios.
