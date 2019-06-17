From: Ming Lei <ming.lei@redhat.com>
Subject: Re: [PATCH V4 05/16] scsi: ipr: use sg helper to operate scatterlist
Date: Mon, 17 Jun 2019 16:50:32 +0800
Message-ID: <20190617085027.GA31002@ming.t460p>
References: <20190617030349.26415-1-ming.lei@redhat.com>
 <20190617030349.26415-6-ming.lei@redhat.com>
 <20190617082423.GE7455@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <driverdev-devel-bounces@linuxdriverproject.org>
Content-Disposition: inline
In-Reply-To: <20190617082423.GE7455@lst.de>
List-Unsubscribe: <http://driverdev.linuxdriverproject.org/mailman/options/driverdev-devel>,
 <mailto:driverdev-devel-request@linuxdriverproject.org?subject=unsubscribe>
List-Archive: <http://driverdev.linuxdriverproject.org/pipermail/driverdev-devel/>
List-Post: <mailto:driverdev-devel@linuxdriverproject.org>
List-Help: <mailto:driverdev-devel-request@linuxdriverproject.org?subject=help>
List-Subscribe: <http://driverdev.linuxdriverproject.org/mailman/listinfo/driverdev-devel>,
 <mailto:driverdev-devel-request@linuxdriverproject.org?subject=subscribe>
Errors-To: driverdev-devel-bounces@linuxdriverproject.org
Sender: "devel" <driverdev-devel-bounces@linuxdriverproject.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Michael Schmitz <schmitzmic@gmail.com>, devel@driverdev.osuosl.org, Hannes Reinecke <hare@suse.com>, Benjamin Block <bblock@linux.ibm.com>, linux-scsi@vger.kernel.org, "Martin K . Petersen" <martin.petersen@oracle.com>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, linux-usb@vger.kernel.org, James Smart <james.smart@broadcom.com>, "Ewan D . Milne" <emilne@redhat.com>, Jim Gill <jgill@vmware.com>, James Bottomley <James.Bottomley@hansenpartnership.com>, Brian King <brking@us.ibm.com>, Finn Thain <fthain@telegraphics.com.au>, "Juergen E . Fischer" <fischer@norbit.de>, Dan Carpenter <dan.carpenter@oracle.com>, Bart Van Assche <bvanassche@acm.org>
List-Id: linux-scsi@vger.kernel.org

On Mon, Jun 17, 2019 at 10:24:23AM +0200, Christoph Hellwig wrote:
> > -	for (i = 0; i < (len / bsize_elem); i++, buffer += bsize_elem) {
> > -		struct page *page = sg_page(&scatterlist[i]);
> > +	for (i = 0; i < (len / bsize_elem); i++, sg = sg_next(sg), buffer += bsize_elem) {
> 
> Please split the overly long line.

Fine.

> 
> > +		struct page *page = sg_page(sg);
> >  
> >  		kaddr = kmap(page);
> >  		memcpy(kaddr, buffer, bsize_elem);
> >  		kunmap(page);
> 
> Not new in this patch, but this is buggy as scatterlists could have
> offsets.  This should probably use the scatterlist.c copy helper
> eventually.

This sglist is allocated by driver, see ipr_copy_ucode_buffer(), so
offset for any element is zero.

Thanks,
Ming
