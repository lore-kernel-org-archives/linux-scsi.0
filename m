From: Finn Thain <fthain@telegraphics.com.au>
Subject: Re: [PATCH V5 10/16] s390: zfcp_fc: use sg helper to operate
 scatterlist
Date: Tue, 25 Jun 2019 13:42:40 +1000 (AEST)
Message-ID: <alpine.LNX.2.21.1906251342280.8@nippy.intranet>
References: <20190618013757.22401-1-ming.lei@redhat.com>
 <20190618013757.22401-11-ming.lei@redhat.com>
 <95bfa1fb-d0eb-fc61-ecc0-001ae52a326f@linux.ibm.com>
 <20190625011902.GA23777@ming.t460p>
 <alpine.LNX.2.21.1906251157160.8@nippy.intranet>
 <20190625023027.GF23777@ming.t460p>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <driverdev-devel-bounces@linuxdriverproject.org>
In-Reply-To: <20190625023027.GF23777@ming.t460p>
List-Unsubscribe: <http://driverdev.linuxdriverproject.org/mailman/options/driverdev-devel>,
 <mailto:driverdev-devel-request@linuxdriverproject.org?subject=unsubscribe>
List-Archive: <http://driverdev.linuxdriverproject.org/pipermail/driverdev-devel/>
List-Post: <mailto:driverdev-devel@linuxdriverproject.org>
List-Help: <mailto:driverdev-devel-request@linuxdriverproject.org?subject=help>
List-Subscribe: <http://driverdev.linuxdriverproject.org/mailman/listinfo/driverdev-devel>,
 <mailto:driverdev-devel-request@linuxdriverproject.org?subject=subscribe>
Errors-To: driverdev-devel-bounces@linuxdriverproject.org
Sender: "devel" <driverdev-devel-bounces@linuxdriverproject.org>
To: Ming Lei <ming.lei@redhat.com>
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>, Jim Gill <jgill@vmware.com>, James Bottomley <James.Bottomley@hansenpartnership.com>, Christoph Hellwig <hch@lst.de>, devel@driverdev.osuosl.org, linux-s390@vger.kernel.org, Hannes Reinecke <hare@suse.com>, Bart Van Assche <bvanassche@acm.org>, linux-scsi@vger.kernel.org, James Smart <james.smart@broadcom.com>, "Ewan D . Milne" <emilne@redhat.com>, "Juergen E . Fischer" <fischer@norbit.de>, Dan Carpenter <dan.carpenter@oracle.com>, Benjamin Block <bblock@linux.ibm.com>, Brian King <brking@us.ibm.com>, Michael Schmitz <schmitzmic@gmail.com>, "Martin K . Petersen" <martin.petersen@oracle.com>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, linux-usb@vger.kernel.org, Martin Schwidefsky <schwidefsky@de.ibm.com>, Steffen Maier <maier@linux.ibm.com>
List-Id: linux-scsi@vger.kernel.org

On Tue, 25 Jun 2019, Ming Lei wrote:

> On Tue, Jun 25, 2019 at 12:01:24PM +1000, Finn Thain wrote:
> > > diff --git a/drivers/s390/scsi/zfcp_dbf.c b/drivers/s390/scsi/zfcp_dbf.c
> > > index dccdb41bed8c..c7129f5234f0 100644
> > > --- a/drivers/s390/scsi/zfcp_dbf.c
> > > +++ b/drivers/s390/scsi/zfcp_dbf.c
> > > @@ -552,7 +552,7 @@ static u16 zfcp_dbf_san_res_cap_len_if_gpn_ft(char *tag,
> > >  		if (x % (ZFCP_FC_GPN_FT_ENT_PAGE + 1))
> > >  			acc++;
> > >  		else
> > > -			acc = sg_virt(++resp_entry);
> > > +			acc = sg_virt(resp_entry = sg_next(resp_entry));
> > 
> > Shouldn't that be,
> > 
> > 			acc = sg_virt(sg_next(resp_entry));
> 
> resp_entry needs to be updated.
> 

Right, sorry for the noise.

-- 

> > 
> > >  
> > >  		last = acc->fp_flags & FC_NS_FID_LAST;
> > >  	}
> > > diff --git a/drivers/s390/scsi/zfcp_fc.c b/drivers/s390/scsi/zfcp_fc.c
> > > index b018b61bd168..5048812ce660 100644
> > > --- a/drivers/s390/scsi/zfcp_fc.c
> > > +++ b/drivers/s390/scsi/zfcp_fc.c
> > > @@ -742,7 +742,7 @@ static int zfcp_fc_eval_gpn_ft(struct zfcp_fc_req *fc_req,
> > >  		if (x % (ZFCP_FC_GPN_FT_ENT_PAGE + 1))
> > >  			acc++;
> > >  		else
> > > -			acc = sg_virt(++sg);
> > > +			acc = sg_virt(sg = sg_next(sg));
> > 
> > and
> > 
> > 			acc = sg_virt(sg_next(sg));
> > 
> > ?
> 
> Same with above.
> 
> Thanks,
> Ming
> 
