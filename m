From: KY Srinivasan <kys@microsoft.com>
Subject: RE: [PATCH 8/8] drivers: scsi: storvsc: Correctly handle
 TEST_UNIT_READY failure
Date: Wed, 9 Jul 2014 18:35:47 +0000
Message-ID: <67b90e6c79674f27979f42277dbb62e5@BY2PR03MB299.namprd03.prod.outlook.com>
References: <1404866789-26910-1-git-send-email-kys@microsoft.com>
 <1404866812-26950-1-git-send-email-kys@microsoft.com>
 <1404866812-26950-8-git-send-email-kys@microsoft.com>
 <20140709084644.GH6012@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <driverdev-devel-bounces@linuxdriverproject.org>
In-Reply-To: <20140709084644.GH6012@infradead.org>
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
To: Christoph Hellwig <hch@infradead.org>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "jasowang@redhat.com" <jasowang@redhat.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "jbottomley@parallels.com" <jbottomley@parallels.com>, "ohering@suse.com" <ohering@suse.com>, "stable@vger.kernel.org" <stable@vger.kernel.org>, "apw@canonical.com" <apw@canonical.com>, "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>
List-Id: linux-scsi@vger.kernel.org



> -----Original Message-----
> From: Christoph Hellwig [mailto:hch@infradead.org]
> Sent: Wednesday, July 9, 2014 1:47 AM
> To: KY Srinivasan
> Cc: linux-kernel@vger.kernel.org; devel@linuxdriverproject.org;
> ohering@suse.com; jbottomley@parallels.com; jasowang@redhat.com;
> apw@canonical.com; linux-scsi@vger.kernel.org; stable@vger.kernel.org
> Subject: Re: [PATCH 8/8] drivers: scsi: storvsc: Correctly handle
> TEST_UNIT_READY failure
> 
> On Tue, Jul 08, 2014 at 05:46:52PM -0700, K. Y. Srinivasan wrote:
> > --- a/drivers/scsi/storvsc_drv.c
> > +++ b/drivers/scsi/storvsc_drv.c
> > @@ -1023,6 +1023,13 @@ static void storvsc_handle_error(struct
> vmscsi_request *vm_srb,
> >  		case ATA_12:
> >  			set_host_byte(scmnd, DID_PASSTHROUGH);
> >  			break;
> > +		/*
> > +		 * On Some Windows hosts TEST_UNIT_READY command can
> return
> > +		 * SRB_STATUS_ERROR, let the upper level code deal with it
> > +		 * based on the sense information.
> > +		 */
> > +		case TEST_UNIT_READY:
> > +			break;
> 
> Don't we need to set an error in the command for the error handler to take
> action?  Or is this propagated elsewhere?

The host sets the appropriate scsi response and sense information that allows the upper-level scsi stack to appropriately recover. We are just making sure that we won't mark the target as failed which is what would happen in the absence of this patch since the host has set a very generic SRB error code that indicates failure.

Regards,

K. Y
