From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH] storvsc: use small sg_tablesize on x86
Date: Thu, 01 Oct 2015 13:51:58 -0700
Message-ID: <1443732718.6886.23.camel@HansenPartnership.com>
References: <1441706801-15300-1-git-send-email-olaf@aepfle.de>
	 <BY2PR0301MB16540206D42C1E00EC353D0EA04C0@BY2PR0301MB1654.namprd03.prod.outlook.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <BY2PR0301MB16540206D42C1E00EC353D0EA04C0@BY2PR0301MB1654.namprd03.prod.outlook.com>
Sender: linux-kernel-owner@vger.kernel.org
To: KY Srinivasan <kys@microsoft.com>
Cc: Olaf Hering <olaf@aepfle.de>, Haiyang Zhang <haiyangz@microsoft.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On Thu, 2015-10-01 at 20:30 +0000, KY Srinivasan wrote:
> 
> > -----Original Message-----
> > From: Olaf Hering [mailto:olaf@aepfle.de]
> > Sent: Tuesday, September 8, 2015 3:07 AM
> > To: KY Srinivasan <kys@microsoft.com>; Haiyang Zhang
> > <haiyangz@microsoft.com>; JBottomley@odin.com
> > Cc: linux-kernel@vger.kernel.org; linux-scsi@vger.kernel.org; Olaf Hering
> > <olaf@aepfle.de>
> > Subject: [PATCH] storvsc: use small sg_tablesize on x86
> > 
> > Reducing the sg_tablesize allows booting of 32bit kernels in VMs, after
> > commit be0cf6ca301c61458dc4aa1a37acf4f58d2ed3d6 ("scsi: storvsc: Set the
> > tablesize based on the information given by the host")
> > 
> > [    5.567138] hv_storvsc vmbus_1: adjusting sg_tablesize 0x800 -> 0x20
> > 
> > Signed-off-by: Olaf Hering <olaf@aepfle.de>
> Reviewed-by: K. Y. Srinivasan <kys@microsoft.com>
> > ---
> >  drivers/scsi/storvsc_drv.c | 5 +++++
> >  1 file changed, 5 insertions(+)
> > 
> > diff --git a/drivers/scsi/storvsc_drv.c b/drivers/scsi/storvsc_drv.c
> > index 40c43ae..36bf183 100644
> > --- a/drivers/scsi/storvsc_drv.c
> > +++ b/drivers/scsi/storvsc_drv.c
> > @@ -1907,6 +1907,11 @@ static int storvsc_probe(struct hv_device *device,
> >  	 * from the host.
> >  	 */
> >  	host->sg_tablesize = (stor_device->max_transfer_bytes >>
> > PAGE_SHIFT);
> > +#if defined(CONFIG_X86_32)
> > +	dev_warn(&device->device, "adjusting sg_tablesize 0x%x -> 0x%x",
> > +			host->sg_tablesize,
> > MAX_MULTIPAGE_BUFFER_COUNT);
> > +	host->sg_tablesize = MAX_MULTIPAGE_BUFFER_COUNT;
> > +#endif

Um, this is a bit architecture specific (I know Azure is x86, but
still).  Can you make the define check CONFIG_32BIT rather than
CONFIG_X86_32?

James
