From: KY Srinivasan <kys@microsoft.com>
Subject: RE: [PATCH v2 0/2] scsi: storvsc: Add support for FC lightweight host.
Date: Sun, 29 Jan 2017 00:35:32 +0000
Message-ID: <DM5PR03MB24902D4813941D2722030DA1A0480@DM5PR03MB2490.namprd03.prod.outlook.com>
References: <1485437940-18706-1-git-send-email-cavery@redhat.com>
 <20170126145159.GA29683@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <driverdev-devel-bounces@linuxdriverproject.org>
In-Reply-To: <20170126145159.GA29683@infradead.org>
Content-Language: en-US
List-Unsubscribe: <http://driverdev.linuxdriverproject.org/mailman/options/driverdev-devel>,
 <mailto:driverdev-devel-request@linuxdriverproject.org?subject=unsubscribe>
List-Archive: <http://driverdev.linuxdriverproject.org/pipermail/driverdev-devel/>
List-Post: <mailto:driverdev-devel@linuxdriverproject.org>
List-Help: <mailto:driverdev-devel-request@linuxdriverproject.org?subject=help>
List-Subscribe: <http://driverdev.linuxdriverproject.org/mailman/listinfo/driverdev-devel>,
 <mailto:driverdev-devel-request@linuxdriverproject.org?subject=subscribe>
Errors-To: driverdev-devel-bounces@linuxdriverproject.org
Sender: "devel" <driverdev-devel-bounces@linuxdriverproject.org>
To: Christoph Hellwig <hch@infradead.org>, Cathy Avery <cavery@redhat.com>
Cc: "jejb@linux.vnet.ibm.com" <jejb@linux.vnet.ibm.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>, Haiyang Zhang <haiyangz@microsoft.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "famz@redhat.com" <famz@redhat.com>, "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>, "dan.carpenter@oracle.com" <dan.carpenter@oracle.com>
List-Id: linux-scsi@vger.kernel.org



> -----Original Message-----
> From: Christoph Hellwig [mailto:hch@infradead.org]
> Sent: Thursday, January 26, 2017 6:52 AM
> To: Cathy Avery <cavery@redhat.com>
> Cc: KY Srinivasan <kys@microsoft.com>; hch@infradead.org; Haiyang Zhang
> <haiyangz@microsoft.com>; jejb@linux.vnet.ibm.com;
> martin.petersen@oracle.com; dan.carpenter@oracle.com;
> devel@linuxdriverproject.org; linux-kernel@vger.kernel.org; linux-
> scsi@vger.kernel.org; famz@redhat.com
> Subject: Re: [PATCH v2 0/2] scsi: storvsc: Add support for FC lightweight host.
> 
> On Thu, Jan 26, 2017 at 08:38:58AM -0500, Cathy Avery wrote:
> > Included in the current storvsc driver for Hyper-V is the ability
> > to access luns on an FC fabric via a virtualized fiber channel
> > adapter exposed by the Hyper-V host. This was done to provide an
> > interface for existing customer tools that was more consistent with
> > a conventional FC device. The driver attaches to the FC transport
> > to allow host and port names to be published under
> > /sys/class/fc_host/hostX.
> >
> > A problem arose when attaching to the FC transport. The scsi_scan code
> > attempts to call fc_user_scan which has basically become a no-op
> > due to the virtualized nature of the FC host
> > ( missing rports, vports, etc ). At this point you cannot refresh
> > the scsi bus after mapping or unmapping luns on the SAN without
> > a reboot.
> 
> I don't think a device without rports or vports is a FC device, plain and
> simple.  So as far as I'm concerned we should remove the code from storvsc
> that pretends to be FC, and not add it to virtio to start with.
> 
> And again I think leightweight is a very confusing name -
> what exactly is leight or heavy?   It's really fake or dummy
> in the current version.

Windows has chosen this model for virtualizing FC devices to the guest -
without rports (or vports). As I noted in my earlier email, James came up with
this notion of a lightweight template almost a year ago. We can certainly pick a 
more appropriate name and include better documentation. 
> 
> >
> > 2) Removes an original workaround dealing with replacing
> > the eh_timed_out function. Patch 1 will not set the
> > scsi_transport_template.eh_timed_out function directly during
> > lightweight fc_attach_transport(). It instead relies on
> > whatever was indicated as the scsi_host_template timeout handler
> > during scsi_times_out() scsi_error.c. So the workaround is
> > no longer necessary.
> 
> Can you send a patch that gets rid of the transport class timeout handler
> entirely?  I think it's simply the wrong layering we have here - the
> driver needs to be in control of timeouts, and if it wants it can
> optionally call into library code in the transport class.

We will address this concern.
> 
> 
> FYI, all the long-term relevant explanation need to go into the patches
> themselves (patch description or code comments), not in the cover
> letter.

We will address this.

Regards,

K. Y
