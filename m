From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: Re: [PATCH 03/11] block: add rq->resid_len
Date: Wed, 13 May 2009 00:16:39 +0900
Message-ID: <20090513001756P.fujita.tomonori@lab.ntt.co.jp>
References: <20090511235852Z.fujita.tomonori@lab.ntt.co.jp>
	<4A093A34.3020101@panasas.com>
	<20090513000150H.fujita.tomonori@lab.ntt.co.jp>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <20090513000150H.fujita.tomonori@lab.ntt.co.jp>
Sender: linux-ide-owner@vger.kernel.org
To: bharrosh@panasas.com
Cc: tj@kernel.org, axboe@kernel.dk, linux-kernel@vger.kernel.org, jeff@garzik.org, linux-ide@vger.kernel.org, James.Bottomley@HansenPartnership.com, linux-scsi@vger.kernel.org, bzolnier@gmail.com, petkovbb@googlemail.com, sshtylyov@ru.mvista.com, mike.miller@hp.com, Eric.Moore@lsi.com, stern@rowland.harvard.edu, zaitcev@redhat.com, Geert.Uytterhoeven@sonycom.com, sfr@canb.auug.org.au, grant.likely@secretlab.ca, paul.clements@steeleye.com, tim@cyberelk.net, jeremy@xensource.com, adrian@mcmen.demon.co.uk, oakad@yahoo.com, dwmw2@infradead.org, schwidefsky@de.ibm.com, ballabio_dario@emc.com, davem@davemloft.net, rusty@rustcorp.com.au, Markus.Lidel@shadowconnect.com, dgilbert@interlog.com, djwong@us.ibm.com
List-Id: linux-scsi@vger.kernel.org

On Wed, 13 May 2009 00:00:47 +0900
FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp> wrote:

> On Tue, 12 May 2009 11:58:28 +0300
> Boaz Harrosh <bharrosh@panasas.com> wrote:
> 
> > On 05/11/2009 05:59 PM, FUJITA Tomonori wrote:
> > > On Mon, 11 May 2009 14:31:41 +0300
> > > Boaz Harrosh <bharrosh@panasas.com> wrote:
> > > 
> > >>>>> diff --git a/drivers/scsi/libsas/sas_expander.c b/drivers/scsi/libsas/sas_expander.c
> > >>>>> index 3da02e4..6605ec9 100644
> > >>>>> --- a/drivers/scsi/libsas/sas_expander.c
> > >>>>> +++ b/drivers/scsi/libsas/sas_expander.c
> > >>>>> @@ -1936,12 +1936,8 @@ int sas_smp_handler(struct Scsi_Host *shost, struct sas_rphy *rphy,
> > >>>>>  			       bio_data(rsp->bio), rsp->data_len);
> > >>>>>  	if (ret > 0) {
> > >>>>>  		/* positive number is the untransferred residual */
> > >>>>> -		rsp->data_len = ret;
> > >>>>> -		req->data_len = 0;
> > >>>>> +		rsp->resid_len = ret;
> > >>>>>  		ret = 0;
> > >>>>> -	} else if (ret == 0) {
> > >>>>> -		rsp->data_len = 0;
> > >>>>> -		req->data_len = 0;
> > >>>>>  	}
> > >>>>>  
> > >>>>>  	return ret;
> > >>>> This is actually a bug fix, as well as a strait conversion
> > >>> Can you elaborate a bit about the bug fix part?
> > >>>
> > >> Nothing big really, just that before (according to the comment), the theoretical
> > >> negative case would be full-residual. and now it is zero (untouched).
> > >>
> > >> I know that in iscsi a negative residual is possible which means over-flow. That is:
> > >> the target had more data to give then the buffer had space for. (which is not an error at all)
> > > 
> > > Hmm, iSCSI? This code is for SAS management Protocol.
> > > 
> > 
> > I gave that as an example of what the scsi standard says about negative
> > residual count return from the target. If SAS as sepecific and different
> > meaning to negative residual, it should be noted and handled.
> 
> Please read the code first.
> 
> If sas_smp_handler() returns a negative value, a lld doesn't transfer

Oops, smp_execute_task()


> anything. The original code used full-residual. The original code is
> fine. Your 'this is a bug fix' claim is wrong. We need to revert the
> original behavior though.

Note that you could claim that we should handle residual here when you
find SAS_DATA_OVERRUN in smp_execute_task(). I guess that it means
INVALID_REQUEST_FRAME_LENGTH; the driver sent the data and doesn't get
anything. So we could do better about residual for the error but I
didn't know about the lld spec and I kept the code that the vendor
submitted.
