From: KY Srinivasan <kys@microsoft.com>
Subject: RE: [PATCH 2/4] scsi: storvsc: Properly support Fibre Channel devices
Date: Sat, 12 Dec 2015 03:07:59 +0000
Message-ID: <SN1PR0301MB16628D34640307F7EBFB97D7A0EB0@SN1PR0301MB1662.namprd03.prod.outlook.com>
References: <1449792829-15406-1-git-send-email-kys@microsoft.com>
 <1449792860-15447-1-git-send-email-kys@microsoft.com>
 <1449792860-15447-2-git-send-email-kys@microsoft.com>
 <20151211102519.GF5284@mwanda>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20151211102519.GF5284@mwanda>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>, "ohering@suse.com" <ohering@suse.com>, "jbottomley@parallels.com" <jbottomley@parallels.com>, "hch@infradead.org" <hch@infradead.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "apw@canonical.com" <apw@canonical.com>, "vkuznets@redhat.com" <vkuznets@redhat.com>, "jasowang@redhat.com" <jasowang@redhat.com>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>
List-Id: linux-scsi@vger.kernel.org



> -----Original Message-----
> From: Dan Carpenter [mailto:dan.carpenter@oracle.com]
> Sent: Friday, December 11, 2015 2:25 AM
> To: KY Srinivasan <kys@microsoft.com>
> Cc: gregkh@linuxfoundation.org; linux-kernel@vger.kernel.org;
> devel@linuxdriverproject.org; ohering@suse.com;
> jbottomley@parallels.com; hch@infradead.org; linux-scsi@vger.kernel.org;
> apw@canonical.com; vkuznets@redhat.com; jasowang@redhat.com;
> martin.petersen@oracle.com
> Subject: Re: [PATCH 2/4] scsi: storvsc: Properly support Fibre Channel devices
> 
> On Thu, Dec 10, 2015 at 04:14:18PM -0800, K. Y. Srinivasan wrote:
> > +	ret = vmbus_sendpacket(device->channel, vstor_packet,
> > +			       (sizeof(struct vstor_packet) -
> > +			       vmscsi_size_delta),
> > +			       (unsigned long)request,
> > +			       VM_PKT_DATA_INBAND,
> > +
> VMBUS_DATA_PACKET_FLAG_COMPLETION_REQUESTED);
> > +
> > +	if (ret != 0)
> > +		goto cleanup;
> > +
> > +	t = wait_for_completion_timeout(&request->wait_event, 5*HZ);
> > +	if (t == 0) {
> > +		ret = -ETIMEDOUT;
> > +		goto cleanup;
> > +	}
> > +
> > +	if (vstor_packet->operation != VSTOR_OPERATION_COMPLETE_IO
> ||
> > +	    vstor_packet->status != 0)
> > +		goto cleanup;
> 
> "cleanup" is a misleading name because it doesn't clean up anything.
> Do nothing gotos are a pain in the butt and they always introduce bugs.
> For example, you appear to have forgotten to set the error code.  But
> because it's a do-nothing goto it's ambiguous so perhaps returning
> success was intended.
> 
> Empirically this style of coding causes bugs.  It does not prevent them.
> It is a bad style if you believe in measuring, evidence and science.

Thanks Dan. I will fix this and resend.

K. Y
