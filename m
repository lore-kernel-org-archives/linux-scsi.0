From: KY Srinivasan <kys@microsoft.com>
Subject: RE: [PATCH 6/7] scsi: storvsc: Don't assume that the scatterlist is
 not chained
Date: Tue, 24 Mar 2015 16:29:42 +0000
Message-ID: <BN1PR0301MB0707EDA27C3C7D79463F34F7A00A0@BN1PR0301MB0707.namprd03.prod.outlook.com>
References: <1427144760-11875-1-git-send-email-kys@microsoft.com>
 <1427144801-11920-1-git-send-email-kys@microsoft.com>
 <1427144801-11920-6-git-send-email-kys@microsoft.com>
 <20150324085607.GA1849@aepfle.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <driverdev-devel-bounces@linuxdriverproject.org>
In-Reply-To: <20150324085607.GA1849@aepfle.de>
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
To: Olaf Hering <olaf@aepfle.de>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>, "jasowang@redhat.com" <jasowang@redhat.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "jbottomley@parallels.com" <jbottomley@parallels.com>, "hch@infradead.org" <hch@infradead.org>, "apw@canonical.com" <apw@canonical.com>, "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>
List-Id: linux-scsi@vger.kernel.org



> -----Original Message-----
> From: Olaf Hering [mailto:olaf@aepfle.de]
> Sent: Tuesday, March 24, 2015 1:56 AM
> To: KY Srinivasan
> Cc: gregkh@linuxfoundation.org; linux-kernel@vger.kernel.org;
> devel@linuxdriverproject.org; jbottomley@parallels.com;
> hch@infradead.org; linux-scsi@vger.kernel.org; apw@canonical.com;
> vkuznets@redhat.com; jasowang@redhat.com
> Subject: Re: [PATCH 6/7] scsi: storvsc: Don't assume that the scatterlist is not
> chained
> 
> On Mon, Mar 23, K. Y. Srinivasan wrote:
> 
> > @@ -653,32 +640,39 @@ static unsigned int
> copy_from_bounce_buffer(struct scatterlist *orig_sgl,
> >  	unsigned long bounce_addr = 0;
> >  	unsigned long dest_addr = 0;
> >  	unsigned long flags;
> > +	struct scatterlist *cur_dest_sgl;
> > +	struct scatterlist *cur_src_sgl;
> >
> >  	local_irq_save(flags);
> > -
> > +	cur_dest_sgl = orig_sgl;
> > +	cur_src_sgl = bounce_sgl;
> >  	for (i = 0; i < orig_sgl_count; i++) {
> > -		dest_addr = sg_kmap_atomic(orig_sgl,i) + orig_sgl[i].offset;
> > +		dest_addr = (unsigned long)
> > +				kmap_atomic(sg_page(cur_dest_sgl)) +
> > +				cur_dest_sgl->offset;
> >  		dest = dest_addr;
> >  		destlen = orig_sgl[i].length;
> > +		destlen = cur_dest_sgl->length;
> 
> Double assignment.

Thanks Olaf; I will fix this and resubmit.

K. Y

> 
> Olaf
