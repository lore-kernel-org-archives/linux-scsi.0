From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: Re: [PATCH 1/2] scsi_transport_fc: FC pass through support via bsg
 interface - revised
Date: Mon, 20 Oct 2008 22:36:42 +0900
Message-ID: <20081020223617E.fujita.tomonori@lab.ntt.co.jp>
References: <D5161DF5-A488-4E02-A4D4-74F5E96CC43A@qlogic.com>
	<20081020204604A.fujita.tomonori@lab.ntt.co.jp>
	<51A5EBA1-15ED-4568-98B1-824B52D6F4F6@qlogic.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mo10.iij4u.or.jp ([210.138.174.78]:37541 "EHLO mo10.iij4u.or.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751587AbYJTNhK (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 20 Oct 2008 09:37:10 -0400
In-Reply-To: <51A5EBA1-15ED-4568-98B1-824B52D6F4F6@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: seokmann.ju@qlogic.com
Cc: fujita.tomonori@lab.ntt.co.jp, James.Smart@Emulex.Com, James.Bottomley@HansenPartnership.com, linux-scsi@vger.kernel.org, andrew.vasquez@qlogic.com, michaelc@cs.wisc.edu, bharrosh@panasas.com, robert.w.love@intel.com

On Mon, 20 Oct 2008 05:46:22 -0700
Seokmann Ju <seokmann.ju@qlogic.com> wrote:

> 
> On Oct 20, 2008, at 4:45 AM, FUJITA Tomonori wrote:
> 
> > On Mon, 20 Oct 2008 03:59:18 -0700
> > Seokmann Ju <seokmann.ju@qlogic.com> wrote:
> >
> >>
> >> On Oct 14, 2008, at 7:13 AM, Seokmann Ju wrote:
> >>
> >>>
> >>> On Oct 14, 2008, at 6:34 AM, FUJITA Tomonori wrote:
> >>>
> >>>> On Tue, 14 Oct 2008 04:44:17 -0700
> >>>> Seokmann Ju <seokmann.ju@qlogic.com> wrote:
> >>>>
> >>>>>>> +static int
> >>>>>>> +fc_service_handler(struct Scsi_Host *shost, struct fc_rport
> >>>>>>> *rport,
> >>>>>>> +			  struct request *req, struct request_queue *q)
> >>>>>>> +{
> >>>>>>> +	int ret;
> >>>>>>> +	struct request *rsp = req->next_rq;
> >>>>>>> +
> >>>>>>> +	if (!rsp) {
> >>>>>>> +		printk(KERN_ERR "ERROR: space for a FC service"
> >>>>>>> +		   " response is missing\n");
> >>>>>>> +		return -EINVAL;
> >>>>>>> +	}
> >>>>>>> +
> >>>>>>> +	if ((req->bio->bi_vcnt > FC_SERVICE_MAX_SG) ||
> >>>>>>> +	    (rsp->bio->bi_vcnt > FC_SERVICE_MAX_SG)) {
> >>>>>>> +		printk(KERN_ERR "ERROR: a FC service"
> >>>>>>> +		    " supports no more than %d SGs\n", FC_SERVICE_MAX_SG);
> >>>>>>> +		return -EINVAL;
> >>>>>>> +	}
> >>>>>>
> >>>>>> This doesn't look correct. bi_vcnt is not related with the number
> >>>>>> of
> >>>>>> sg. You use scatter-gather for large data transfer. You don't
> >>>>>> need to
> >>>>>> worry about bi_vcnt.
> >>>>> I see...
> >>>>> Is there is a way to check, then, how many SG entries the service
> >>>>> needs before the blk_rq_map_sg()?
> >>>>
> >>>> As I wrote in the previous mail, via blk_queue_max_hw_segments()  
> >>>> and
> >>>> blk_queue_max_phys_segments(), you can tell the block layer the
> >>>> number
> >>>> of sg segments you can handle.
> >> One more question here...
> >> With addition of a timer into the FC transport layer for fc_service
> >> handing, the
> >> system seems getting locked up, as below trace shows.
> >> I've been trying to figure out the reasons but not able to do.
> >> It seems like that there is something that I don't know,  
> >> fundamentally
> >> about
> >> the timer usage...
> >> Could you please comments on what might be the things causing the
> >> problem?
> >
> > Hmm, why do you need to invent the own timeout mechanism?
> I was trying to have similar timeout mechanism as in the SCSI I/O,  
> just like 'scsi_add_timer()' in scsi.c:scsi_dispatch_cmd()....
> I assume this is not right approach...?
> 
> > I think that you can use the block layer timeout feature. It doesn't
> > work for fc transport pass through? You can just remove struct
> > timer_list in struct fc_service. Check out how scsi-ml uses
> > blk_queue_rq_timed_out and blk_queue_rq_timeout.
> OK. Thanks, I will try out this.
> What are the exact name of those APIs, again?
> It seems like that none of them are available in the source tree....

You need the latest git kernel. The block layer timeout feature was
introduced post 2.6.27. scsi_add_timer() has gone.
