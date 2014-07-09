From: KY Srinivasan <kys@microsoft.com>
Subject: RE: [PATCH 4/8] Drivers: scsi: storvsc: Filter WRITE_SAME_16
Date: Wed, 9 Jul 2014 21:14:00 +0000
Message-ID: <2f3ae589e6f149acbe4c5dd79f905971@BY2PR03MB299.namprd03.prod.outlook.com>
References: <1404866789-26910-1-git-send-email-kys@microsoft.com>
 <1404866812-26950-1-git-send-email-kys@microsoft.com>
 <1404866812-26950-4-git-send-email-kys@microsoft.com>
 <20140709084300.GD6012@infradead.org>
 <a31a45eddb544024a7538458b98c3611@BY2PR03MB299.namprd03.prod.outlook.com>
 <1404935792.2184.5.camel@dabdike.int.hansenpartnership.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <driverdev-devel-bounces@linuxdriverproject.org>
In-Reply-To: <1404935792.2184.5.camel@dabdike.int.hansenpartnership.com>
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
To: James Bottomley <jbottomley@parallels.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "jasowang@redhat.com" <jasowang@redhat.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "stable@vger.kernel.org" <stable@vger.kernel.org>, "ohering@suse.com" <ohering@suse.com>, "hch@infradead.org" <hch@infradead.org>, "apw@canonical.com" <apw@canonical.com>, "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>
List-Id: linux-scsi@vger.kernel.org



> -----Original Message-----
> From: James Bottomley [mailto:jbottomley@parallels.com]
> Sent: Wednesday, July 9, 2014 12:57 PM
> To: KY Srinivasan
> Cc: linux-kernel@vger.kernel.org; hch@infradead.org;
> devel@linuxdriverproject.org; apw@canonical.com; stable@vger.kernel.org;
> linux-scsi@vger.kernel.org; ohering@suse.com; jasowang@redhat.com
> Subject: Re: [PATCH 4/8] Drivers: scsi: storvsc: Filter WRITE_SAME_16
> 
> On Wed, 2014-07-09 at 19:52 +0000, KY Srinivasan wrote:
> >
> > > -----Original Message-----
> > > From: Christoph Hellwig [mailto:hch@infradead.org]
> > > Sent: Wednesday, July 9, 2014 1:43 AM
> > > To: KY Srinivasan
> > > Cc: linux-kernel@vger.kernel.org; devel@linuxdriverproject.org;
> > > ohering@suse.com; jbottomley@parallels.com; jasowang@redhat.com;
> > > apw@canonical.com; linux-scsi@vger.kernel.org;
> > > stable@vger.kernel.org
> > > Subject: Re: [PATCH 4/8] Drivers: scsi: storvsc: Filter
> > > WRITE_SAME_16
> > >
> > > On Tue, Jul 08, 2014 at 05:46:48PM -0700, K. Y. Srinivasan wrote:
> > > > Host does not handle WRITE_SAME_16; filter this command out. This
> > > > patch is required to handle large devices (greater than 2 TB disks).
> > >
> > > Storvsc already sets the no_write_same flag, where is the command
> > > coming from?
> >
> > In spite of this flag,  I see WRITE_SAME_16 being issued when I format
> > a device bigger than 2 TB; I tried both xfs and ext4. Windows hosts
> > currently do not handle unsupported commands correctly - The
> > information returned is not sufficient to effect recovery in the Linux guest.
> While this may be addressed in future hosts, this patch fixes the problem.
> 
> What Christoph means is that this looks like a bug somewhere in SCSI itself.
> That means we need to find it and kill it, not add workarounds to every driver
> that sets no_write_same ...

James,

I will try to isolate this issue in the SCSI stack. If it is ok with you guys, I would still want to filter WRITE_SAME_16
(as we currently do WRITE_SAME) in our driver since this would address the problem for a large number of
customers on our platform.

Regards,

K. Y
