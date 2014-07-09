From: James Bottomley <jbottomley@parallels.com>
Subject: Re: [PATCH 4/8] Drivers: scsi: storvsc: Filter WRITE_SAME_16
Date: Wed, 9 Jul 2014 19:56:32 +0000
Message-ID: <1404935792.2184.5.camel@dabdike.int.hansenpartnership.com>
References: <1404866789-26910-1-git-send-email-kys@microsoft.com>
 <1404866812-26950-1-git-send-email-kys@microsoft.com>
 <1404866812-26950-4-git-send-email-kys@microsoft.com>
 <20140709084300.GD6012@infradead.org>
 <a31a45eddb544024a7538458b98c3611@BY2PR03MB299.namprd03.prod.outlook.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <driverdev-devel-bounces@linuxdriverproject.org>
In-Reply-To: <a31a45eddb544024a7538458b98c3611@BY2PR03MB299.namprd03.prod.outlook.com>
Content-Language: en-US
Content-ID: <E15C1C7964A7744C836D181D5870ACF9@sw.swsoft.com>
List-Unsubscribe: <http://driverdev.linuxdriverproject.org/mailman/options/driverdev-devel>,
 <mailto:driverdev-devel-request@linuxdriverproject.org?subject=unsubscribe>
List-Archive: <http://driverdev.linuxdriverproject.org/pipermail/driverdev-devel>
List-Post: <mailto:driverdev-devel@linuxdriverproject.org>
List-Help: <mailto:driverdev-devel-request@linuxdriverproject.org?subject=help>
List-Subscribe: <http://driverdev.linuxdriverproject.org/mailman/listinfo/driverdev-devel>,
 <mailto:driverdev-devel-request@linuxdriverproject.org?subject=subscribe>
Errors-To: driverdev-devel-bounces@linuxdriverproject.org
Sender: driverdev-devel-bounces@linuxdriverproject.org
To: "kys@microsoft.com" <kys@microsoft.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "jasowang@redhat.com" <jasowang@redhat.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "stable@vger.kernel.org" <stable@vger.kernel.org>, "ohering@suse.com" <ohering@suse.com>, "hch@infradead.org" <hch@infradead.org>, "apw@canonical.com" <apw@canonical.com>, "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>
List-Id: linux-scsi@vger.kernel.org

On Wed, 2014-07-09 at 19:52 +0000, KY Srinivasan wrote:
> 
> > -----Original Message-----
> > From: Christoph Hellwig [mailto:hch@infradead.org]
> > Sent: Wednesday, July 9, 2014 1:43 AM
> > To: KY Srinivasan
> > Cc: linux-kernel@vger.kernel.org; devel@linuxdriverproject.org;
> > ohering@suse.com; jbottomley@parallels.com; jasowang@redhat.com;
> > apw@canonical.com; linux-scsi@vger.kernel.org; stable@vger.kernel.org
> > Subject: Re: [PATCH 4/8] Drivers: scsi: storvsc: Filter WRITE_SAME_16
> > 
> > On Tue, Jul 08, 2014 at 05:46:48PM -0700, K. Y. Srinivasan wrote:
> > > Host does not handle WRITE_SAME_16; filter this command out. This
> > > patch is required to handle large devices (greater than 2 TB disks).
> > 
> > Storvsc already sets the no_write_same flag, where is the command coming
> > from?
> 
> In spite of this flag,  I see WRITE_SAME_16 being issued when I format a device bigger than 2 TB;
> I tried both xfs and ext4. Windows hosts currently do not handle unsupported commands correctly -
> The information returned is not sufficient to effect recovery in the Linux guest. While this may be addressed in
> future hosts, this patch fixes the problem.

What Christoph means is that this looks like a bug somewhere in SCSI
itself.  That means we need to find it and kill it, not add workarounds
to every driver that sets no_write_same ...

James
