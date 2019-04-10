From: Dan Carpenter <dan.carpenter@oracle.com>
Subject: Re: [PATCH] scsi: cxgbi: remove redundant __kfree_skb call on skb
Date: Wed, 10 Apr 2019 09:46:15 +0300
Message-ID: <20190410064615.GD6095@kadam>
References: <20190409133819.21127-1-colin.king@canonical.com>
 <5CACAD57.1030703@bfs.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <5CACAD57.1030703@bfs.de>
Sender: linux-kernel-owner@vger.kernel.org
To: walter harms <wharms@bfs.de>
Cc: Colin King <colin.king@canonical.com>, Karen Xie <kxie@chelsio.com>, "James E . J . Bottomley" <jejb@linux.ibm.com>, "Martin K . Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org, kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Tue, Apr 09, 2019 at 04:33:59PM +0200, walter harms wrote:
> 
> 
> Am 09.04.2019 15:38, schrieb Colin King:
> > From: Colin Ian King <colin.king@canonical.com>
> > 
> > The error return path via label rel_resource checks for a non-null
> > skb before free'ing it.  However, skb is always null at this exit
> > path, so the null check and the free are redundant and can be removed.
> > Removing this allows the original goto's to rel_resource to be cleaned
> > up; the first can be replaced by a return of -EINVAL, the second can
> > be replaced by a more appropriate -ENOMEM return since allow_wr has
> > failed go allocate some memory.
> > 
> > Addresses-Coverity: ("Logically Dead Code")
> > Signed-off-by: Colin Ian King <colin.king@canonical.com>
> > ---
> >  drivers/scsi/cxgbi/cxgb3i/cxgb3i.c | 9 ++-------
> >  1 file changed, 2 insertions(+), 7 deletions(-)
> > 
> > diff --git a/drivers/scsi/cxgbi/cxgb3i/cxgb3i.c b/drivers/scsi/cxgbi/cxgb3i/cxgb3i.c
> > index 75e1273a44b3..5a4387f437d5 100644
> > --- a/drivers/scsi/cxgbi/cxgb3i/cxgb3i.c
> > +++ b/drivers/scsi/cxgbi/cxgb3i/cxgb3i.c
> > @@ -979,14 +979,14 @@ static int init_act_open(struct cxgbi_sock *csk)
> >  	csk->atid = cxgb3_alloc_atid(t3dev, &t3_client, csk);
> >  	if (csk->atid < 0) {
> >  		pr_err("NO atid available.\n");
> > -		goto rel_resource;
> > +		return -EINVAL;
> >  	}
> >  	cxgbi_sock_set_flag(csk, CTPF_HAS_ATID);
> >  	cxgbi_sock_get(csk);
> >  
> >  	skb = alloc_wr(sizeof(struct cpl_act_open_req), 0, GFP_KERNEL);
> >  	if (!skb)
> > -		goto rel_resource;
> > +		return -ENOMEM;
> 
> I would expect a cxgb3_free_atid(csk->atid) here. Did i miss something ?
> 

Yeah.  I don't see that cxgb3_free_atid() drops the cxgbi_sock_get()
reference so we would want to do a put for that as well I think.

regards,
dan carpenter
