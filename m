From: KY Srinivasan <kys@microsoft.com>
Subject: RE: [PATCH 3/6] hv:scsi:Untangle the storage protocol negotiation
 from the vmbus protocol negotiation.
Date: Mon, 1 Jun 2015 19:17:58 +0000
Message-ID: <BY2PR0301MB165421CF61BAF41BD420BFC1A0B60@BY2PR0301MB1654.namprd03.prod.outlook.com>
References: <1432931336-14434-1-git-send-email-kys@microsoft.com>
 <1432931359-14473-1-git-send-email-kys@microsoft.com>
 <1432931359-14473-3-git-send-email-kys@microsoft.com>
 <20150601104237.GU28762@mwanda>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20150601104237.GU28762@mwanda>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>, "ohering@suse.com" <ohering@suse.com>, "jbottomley@parallels.com" <jbottomley@parallels.com>, "hch@infradead.org" <hch@infradead.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "apw@canonical.com" <apw@canonical.com>, "vkuznets@redhat.com" <vkuznets@redhat.com>, "jasowang@redhat.com" <jasowang@redhat.com>, Keith Mange <Keith.Mange@microsoft.com>
List-Id: linux-scsi@vger.kernel.org



> -----Original Message-----
> From: Dan Carpenter [mailto:dan.carpenter@oracle.com]
> Sent: Monday, June 1, 2015 3:43 AM
> To: KY Srinivasan
> Cc: gregkh@linuxfoundation.org; linux-kernel@vger.kernel.org;
> devel@linuxdriverproject.org; ohering@suse.com;
> jbottomley@parallels.com; hch@infradead.org; linux-scsi@vger.kernel.org;
> apw@canonical.com; vkuznets@redhat.com; jasowang@redhat.com; Keith
> Mange
> Subject: Re: [PATCH 3/6] hv:scsi:Untangle the storage protocol negotiation
> from the vmbus protocol negotiation.
> 
> On Fri, May 29, 2015 at 01:29:16PM -0700, K. Y. Srinivasan wrote:
> > -	if (vstor_packet->operation != VSTOR_OPERATION_COMPLETE_IO
> ||
> > -	    vstor_packet->status != 0)
> > +	if (vstor_packet->status != 0) {
> > +		ret = -EINVAL;
> >  		goto cleanup;
> > +	}
> 
> There is not actually any cleanup, goto cleanup is just a do-nothing
> goto.
> 
> In the original code, we returned success here.  That always looked like
> a "forgot to set the error code" bug to me, but do-nothing labels always
> introduce ambiguous looking "forgot to set the error code" bugs so I can
> never be positive.
> 
> Could you take a look at the other "goto cleanup;" places in this
> function and maybe add a comment, change it to something more clear like
> "return 0;" or fix the error code?

Thanks Dan; will do.

K. Y
> 
> regards,
> dan carpenter
