From: KY Srinivasan <kys@microsoft.com>
Subject: RE: [PATCH 1/8] Drivers: scsi: storvsc: Change the limits to reflect
 the values on the host
Date: Wed, 9 Jul 2014 23:39:42 +0000
Message-ID: <70a32eae84164a60b6318246fcedfa55@BY2PR03MB299.namprd03.prod.outlook.com>
References: <1404866789-26910-1-git-send-email-kys@microsoft.com>
 <1404866812-26950-1-git-send-email-kys@microsoft.com>
 <20140709083954.GA6012@infradead.org>
 <e5e366a15a9f4a6fa1817b0f3b25a482@BY2PR03MB299.namprd03.prod.outlook.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <driverdev-devel-bounces@linuxdriverproject.org>
In-Reply-To: <e5e366a15a9f4a6fa1817b0f3b25a482@BY2PR03MB299.namprd03.prod.outlook.com>
Content-Language: en-US
List-Unsubscribe: <http://driverdev.linuxdriverproject.org/mailman/options/driverdev-devel>,
 <mailto:driverdev-devel-request@linuxdriverproject.org?subject=unsubscribe>
List-Archive: <http://driverdev.linuxdriverproject.org/pipermail/driverdev-devel>
List-Post: <mailto:driverdev-devel@linuxdriverproject.org>
List-Help: <mailto:driverdev-devel-request@linuxdriverproject.org?subject=help>
List-Subscribe: <http://driverdev.linuxdriverproject.org/mailman/listinfo/driverdev-devel>,
 <mailto:driverdev-devel-request@linuxdriverproject.org?subject=subscribe>
Errors-To: driverdev-devel-bounces@linuxdriverproject.org
Sender: driverdev-devel-bounces@linuxdriverproject.org
To: KY Srinivasan <kys@microsoft.com>, Christoph Hellwig <hch@infradead.org>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "jasowang@redhat.com" <jasowang@redhat.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "stable@vger.kernel.org" <stable@vger.kernel.org>, "ohering@suse.com" <ohering@suse.com>, "jbottomley@parallels.com" <jbottomley@parallels.com>, "apw@canonical.com" <apw@canonical.com>, "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>
List-Id: linux-scsi@vger.kernel.org



> -----Original Message-----
> From: driverdev-devel-bounces@linuxdriverproject.org [mailto:driverdev-
> devel-bounces@linuxdriverproject.org] On Behalf Of KY Srinivasan
> Sent: Wednesday, July 9, 2014 1:07 PM
> To: Christoph Hellwig
> Cc: linux-scsi@vger.kernel.org; jasowang@redhat.com; linux-
> kernel@vger.kernel.org; jbottomley@parallels.com; ohering@suse.com;
> stable@vger.kernel.org; apw@canonical.com; devel@linuxdriverproject.org
> Subject: RE: [PATCH 1/8] Drivers: scsi: storvsc: Change the limits to reflect the
> values on the host
> 
> 
> 
> > -----Original Message-----
> > From: Christoph Hellwig [mailto:hch@infradead.org]
> > Sent: Wednesday, July 9, 2014 1:40 AM
> > To: KY Srinivasan
> > Cc: linux-kernel@vger.kernel.org; devel@linuxdriverproject.org;
> > ohering@suse.com; jbottomley@parallels.com; jasowang@redhat.com;
> > apw@canonical.com; linux-scsi@vger.kernel.org; stable@vger.kernel.org
> > Subject: Re: [PATCH 1/8] Drivers: scsi: storvsc: Change the limits to
> > reflect the values on the host
> >
> > On Tue, Jul 08, 2014 at 05:46:45PM -0700, K. Y. Srinivasan wrote:
> > > + * In Hyper-V, each port/path/target maps to 1 scsi host adapter.
> >
> > Does it still?  The STORVSC_FC_MAX_TARGETS define suggests otherwise.
> 
> I will fix the comments and get rid of unnecessary comments.
> 
> >
> > > -	.cmd_per_lun =		1,
> > > +	.cmd_per_lun =		255,
> >
> > This looks like an unrelated change.
> 
> I will have a separate patch for this.
> >
> > > +		/* max # of devices per target */
> > > +		host->max_lun = STORVSC_FC_MAX_LUNS_PER_TARGET;
> > > +		/* max # of targets per channel */
> > > +		host->max_id = STORVSC_FC_MAX_TARGETS;
> > > +		/* max # of channels */
> > > +		host->max_channel = STORVSC_FC_MAX_CHANNELS - 1;
> >
> > I don't think these comments add any value..
> 
> I will get rid of the comments.
> 
> >
> > Also any reason you use off by one defines for max_channel, but not
> > the others?
> 
> No particular reason; I will clean this up.

On further examination max_channel is the maximum number of channels including channel 0. Thus the value set for
max_channel is correct. max_id appears to indicate the limit. In scsi_scan_channel the loop control  is (id < max_id) and
hence the value I have here is correct. max_lun is also used like max_id to indicate the limit. In scsi_sequential_lun_scan()
the loop control is (lun < max_dev_lun) and hence I think the value I have here is fine.

Regards,

K. Y 
