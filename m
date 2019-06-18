From: Ming Lei <ming.lei@redhat.com>
Subject: Re: [PATCH V4 11/16] scsi: aha152x: use sg helper to operate
 scatterlist
Date: Tue, 18 Jun 2019 08:15:37 +0800
Message-ID: <20190618001536.GA5774@ming.t460p>
References: <20190617030349.26415-1-ming.lei@redhat.com>
 <20190617030349.26415-12-ming.lei@redhat.com>
 <alpine.LNX.2.21.1906171334330.168@nippy.intranet>
 <alpine.LNX.2.21.1906180901160.284@nippy.intranet>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <driverdev-devel-bounces@linuxdriverproject.org>
Content-Disposition: inline
In-Reply-To: <alpine.LNX.2.21.1906180901160.284@nippy.intranet>
List-Unsubscribe: <http://driverdev.linuxdriverproject.org/mailman/options/driverdev-devel>,
 <mailto:driverdev-devel-request@linuxdriverproject.org?subject=unsubscribe>
List-Archive: <http://driverdev.linuxdriverproject.org/pipermail/driverdev-devel/>
List-Post: <mailto:driverdev-devel@linuxdriverproject.org>
List-Help: <mailto:driverdev-devel-request@linuxdriverproject.org?subject=help>
List-Subscribe: <http://driverdev.linuxdriverproject.org/mailman/listinfo/driverdev-devel>,
 <mailto:driverdev-devel-request@linuxdriverproject.org?subject=subscribe>
Errors-To: driverdev-devel-bounces@linuxdriverproject.org
Sender: "devel" <driverdev-devel-bounces@linuxdriverproject.org>
To: Finn Thain <fthain@telegraphics.com.au>
Cc: Michael Schmitz <schmitzmic@gmail.com>, devel@driverdev.osuosl.org, Hannes Reinecke <hare@suse.com>, Benjamin Block <bblock@linux.ibm.com>, linux-scsi@vger.kernel.org, "Martin K . Petersen" <martin.petersen@oracle.com>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, linux-usb@vger.kernel.org, James Smart <james.smart@broadcom.com>, "Ewan D . Milne" <emilne@redhat.com>, Jim Gill <jgill@vmware.com>, James Bottomley <James.Bottomley@hansenpartnership.com>, Brian King <brking@us.ibm.com>, "Juergen E . Fischer" <fischer@norbit.de>, Christoph Hellwig <hch@lst.de>, Dan Carpenter <dan.carpenter@oracle.com>, Bart Van Assche <bvanassche@acm.org>
List-Id: linux-scsi@vger.kernel.org

On Tue, Jun 18, 2019 at 09:35:48AM +1000, Finn Thain wrote:
> On Mon, 17 Jun 2019, Finn Thain wrote:
> 
> > On Mon, 17 Jun 2019, Ming Lei wrote:
> > 
> > > Use the scatterlist iterators and remove direct indexing of the
> > > scatterlist array.
> > > 
> > > This way allows us to pre-allocate one small scatterlist, which can be
> > > chained with one runtime allocated scatterlist if the pre-allocated one
> > > isn't enough for the whole request.
> > > 
> > > Finn added the change to replace SCp.buffers_residual with sg_is_last()
> > > for fixing updating it, and the similar change has been applied on
> > > NCR5380.c
> > > 
> > > Cc: Finn Thain <fthain@telegraphics.com.au>
> > > Signed-off-by: Ming Lei <ming.lei@redhat.com>
> > 
> > Reviewed-by: Finn Thain <fthain@telegraphics.com.au>
> > 
> 
> I have to retract that. I think this patch is still wrong.
> 
> GETSTCNT() appears to be the number of bytes sent since datao_init() and 
> not the number of bytes sent since the start of the command. (Note the 
> CLRSTCNT in datao_init() which appears to clear the transfer counter.) I 
> don't see how the existing datao_end() could work otherwise. (Juergen?)
> 
> So here's another attempt. Ming, I'd be happy to take the blame/credit (in 
> the form of a From tag etc.) in case you don't want to spend more time on 
> this.

Sure, will do that in V5.

Thanks,
Ming
