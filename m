From: Seokmann Ju <seokmann.ju@qlogic.com>
Subject: Re: [PATCH 1/2] scsi_transport_fc: FC pass through support via bsg interface - revised
Date: Tue, 14 Oct 2008 07:13:04 -0700
Message-ID: <B6F25B51-7CF2-470E-8358-25E3E436593B@qlogic.com>
References: <45109B57-BBED-47A8-8183-4F4464D1DBEC@qlogic.com> <20081014112148W.fujita.tomonori@lab.ntt.co.jp> <1FF7A5F2-7B3B-4862-8435-15E3C666D166@qlogic.com> <20081014215239E.fujita.tomonori@lab.ntt.co.jp>
Mime-Version: 1.0 (Apple Message framework v929.2)
Content-Type: text/plain; charset=US-ASCII; format=flowed; delsp=yes
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from avexch2.qlogic.com ([198.70.193.116]:39474 "EHLO
	avexch2.qlogic.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752565AbYJNONH (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 14 Oct 2008 10:13:07 -0400
In-Reply-To: <20081014215239E.fujita.tomonori@lab.ntt.co.jp>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: James.Smart@Emulex.Com, James.Bottomley@HansenPartnership.com, linux-scsi@vger.kernel.org, andrew.vasquez@qlogic.com, michaelc@cs.wisc.edu, bharrosh@panasas.com, robert.w.love@intel.com


On Oct 14, 2008, at 6:34 AM, FUJITA Tomonori wrote:

> On Tue, 14 Oct 2008 04:44:17 -0700
> Seokmann Ju <seokmann.ju@qlogic.com> wrote:
>
>>>> +static int
>>>> +fc_service_handler(struct Scsi_Host *shost, struct fc_rport  
>>>> *rport,
>>>> +			  struct request *req, struct request_queue *q)
>>>> +{
>>>> +	int ret;
>>>> +	struct request *rsp = req->next_rq;
>>>> +
>>>> +	if (!rsp) {
>>>> +		printk(KERN_ERR "ERROR: space for a FC service"
>>>> +		   " response is missing\n");
>>>> +		return -EINVAL;
>>>> +	}
>>>> +
>>>> +	if ((req->bio->bi_vcnt > FC_SERVICE_MAX_SG) ||
>>>> +	    (rsp->bio->bi_vcnt > FC_SERVICE_MAX_SG)) {
>>>> +		printk(KERN_ERR "ERROR: a FC service"
>>>> +		    " supports no more than %d SGs\n", FC_SERVICE_MAX_SG);
>>>> +		return -EINVAL;
>>>> +	}
>>>
>>> This doesn't look correct. bi_vcnt is not related with the number of
>>> sg. You use scatter-gather for large data transfer. You don't need  
>>> to
>>> worry about bi_vcnt.
>> I see...
>> Is there is a way to check, then, how many SG entries the service
>> needs before the blk_rq_map_sg()?
>
> As I wrote in the previous mail, via blk_queue_max_hw_segments() and
> blk_queue_max_phys_segments(), you can tell the block layer the number
> of sg segments you can handle.
OK. I've got it. Thanks.

Seokmann

