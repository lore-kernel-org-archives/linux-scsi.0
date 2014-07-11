From: KY Srinivasan <kys@microsoft.com>
Subject: RE: [PATCH 7/8] drivers: scsi: storvsc: Set srb_flags in all cases
Date: Fri, 11 Jul 2014 21:03:52 +0000
Message-ID: <f7789b309ce84187b64760e3885f7cfa@BY2PR03MB299.namprd03.prod.outlook.com>
References: <1404866789-26910-1-git-send-email-kys@microsoft.com>
 <1404866812-26950-1-git-send-email-kys@microsoft.com>
 <1404866812-26950-7-git-send-email-kys@microsoft.com>
 <20140710101849.GD1151@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20140710101849.GD1151@infradead.org>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>, "ohering@suse.com" <ohering@suse.com>, "jbottomley@parallels.com" <jbottomley@parallels.com>, "jasowang@redhat.com" <jasowang@redhat.com>, "apw@canonical.com" <apw@canonical.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "stable@vger.kernel.org" <stable@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org



> -----Original Message-----
> From: Christoph Hellwig [mailto:hch@infradead.org]
> Sent: Thursday, July 10, 2014 3:19 AM
> To: KY Srinivasan
> Cc: linux-kernel@vger.kernel.org; devel@linuxdriverproject.org;
> ohering@suse.com; jbottomley@parallels.com; jasowang@redhat.com;
> apw@canonical.com; linux-scsi@vger.kernel.org; stable@vger.kernel.org
> Subject: Re: [PATCH 7/8] drivers: scsi: storvsc: Set srb_flags in all cases
> 
> >  	default:
> >  		vm_srb->data_in = UNKNOWN_TYPE;
> > -		vm_srb->win8_extension.srb_flags = 0;
> > +		vm_srb->win8_extension.srb_flags |=
> (SRB_FLAGS_DATA_IN |
> > +						     SRB_FLAGS_DATA_OUT);
> 
> This would usually be a command that doesn't transfer data (e.g.
> TEST_UNIT_READY or SYNCHRONIZE_CACHE), do you really want to set the in
> and out flags here?

On the host, before they forward the command to the native driver stack, I am told they validate that the flags be correctly set because of some bugs in the Emulex driver.

K. Y
