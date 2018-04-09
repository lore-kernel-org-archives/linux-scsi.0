From: Johannes Thumshirn <jthumshirn@suse.de>
Subject: Re: [PATCH] qla2xxx: correctly shift host byte
Date: Mon, 9 Apr 2018 14:17:51 +0200
Message-ID: <20180409121751.vwrph2ojoh6eye4r@linux-x5ow.site>
References: <20180406075222.7358-1-jthumshirn@suse.de>
 <222067aa244e369343101a4df9efab1ebd1b918c.camel@wdc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <222067aa244e369343101a4df9efab1ebd1b918c.camel@wdc.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Bart Van Assche <Bart.VanAssche@wdc.com>
Cc: "martin.petersen@oracle.com" <martin.petersen@oracle.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "himanshu.madhani@cavium.com" <himanshu.madhani@cavium.com>
List-Id: linux-scsi@vger.kernel.org

On Fri, Apr 06, 2018 at 03:33:30PM +0000, Bart Van Assche wrote:
> On Fri, 2018-04-06 at 09:52 +0200, Johannes Thumshirn wrote:
> > The host byte has to be shifted by 16 not 6.
> > 
> > Signed-off-by: Johannes Thumshirn <jthumshirn@suse.de>
> > ---
> >  drivers/scsi/qla2xxx/qla_isr.c | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> > 
> > diff --git a/drivers/scsi/qla2xxx/qla_isr.c b/drivers/scsi/qla2xxx/qla_isr.c
> > index 89f93ebd819d..49d67e1d571f 100644
> > --- a/drivers/scsi/qla2xxx/qla_isr.c
> > +++ b/drivers/scsi/qla2xxx/qla_isr.c
> > @@ -2368,7 +2368,7 @@ qla25xx_process_bidir_status_iocb(scsi_qla_host_t *vha, void *pkt,
> >  	bsg_job->reply_len = sizeof(struct fc_bsg_reply);
> >  	/* Always return DID_OK, bsg will send the vendor specific response
> >  	 * in this case only */
> > -	sp->done(sp, DID_OK << 6);
> > +	sp->done(sp, DID_OK << 16);
> >  
> >  }
> 
> Hello Johannes,
> 
> Had you noticed the following statements? I think the "<< 1" should be removed
> from these statements.
> 
> $ git grep 'SAM_STAT.*<< 1'
> drivers/scsi/qla2xxx/qla_isr.c:         cmd->result |= SAM_STAT_CHECK_CONDITION << 1;
> drivers/scsi/qla2xxx/qla_isr.c:         cmd->result |= SAM_STAT_CHECK_CONDITION << 1;
> drivers/scsi/qla2xxx/qla_isr.c:         cmd->result |= SAM_STAT_CHECK_CONDITION << 1;

Thanks for the heads up, but this will be a separate patch.

Byte,
       Johannes
-- 
Johannes Thumshirn                                          Storage
jthumshirn@suse.de                                +49 911 74053 689
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: Felix Imendörffer, Jane Smithard, Graham Norton
HRB 21284 (AG Nürnberg)
Key fingerprint = EC38 9CAB C2C4 F25D 8600 D0D0 0393 969D 2D76 0850
