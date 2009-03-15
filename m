From: Boaz Harrosh <bharrosh@panasas.com>
Subject: Re: [RFC] FC pass thru - Rev V
Date: Sun, 15 Mar 2009 11:30:12 +0200
Message-ID: <49BCCAA4.5060104@panasas.com>
References: <1227043498.4949.21.camel@ogier> <1234365225.24194.3.camel@ogier> <3F3E8B49-EB9A-4A6D-ABB0-3F4FC2EF7D1C@qlogic.com> <BAD9A31D-BCDA-46F9-AE12-E310B684498F@qlogic.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from gw-ca.panasas.com ([209.116.51.66]:7372 "EHLO
	laguna.int.panasas.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752767AbZCOJcM (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 15 Mar 2009 05:32:12 -0400
In-Reply-To: <BAD9A31D-BCDA-46F9-AE12-E310B684498F@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Seokmann Ju <seokmann.ju@qlogic.com>
Cc: James Smart <James.Smart@Emulex.Com>, linux-scsi@vger.kernel.org, Andrew Vasquez <andrew.vasquez@qlogic.com>, "sven@linux.vnet.ibm.com Schuetz" <sven@linux.vnet.ibm.com>, futjita.tomonori@lab.ntt.co.jp, Giridhar Malavali <giridhar.malavali@qlogic.com>

Seokmann Ju wrote:
> On Feb 11, 2009, at 7:43 AM, Seokmann Ju wrote:
> 
>> On Feb 11, 2009, at 7:13 AM, James Smart wrote:
>>
>>> Trying to kick-start this again...
>>> I've updated the prior RFC with the comments from Seokmann,
>>> SvenFujita, and Boaz. I would still like review on the
>>> blk_xxx completion calls in the std and error paths.
>> I'm looking the driver changes to match it with latest updates in  
>> the transport layer.
>> The driver with the changes should be available within a couple of  
>> weeks.
> Here is a change that I've made for transport layer while I'm testing  
> the feature.
> ---
> diff --git a/drivers/scsi/scsi_transport_fc.c b/drivers/scsi/ 
> scsi_transport_fc.c
> index 63ab7bc..4bca164 100644
> --- a/drivers/scsi/scsi_transport_fc.c
> +++ b/drivers/scsi/scsi_transport_fc.c
> @@ -3435,10 +3435,11 @@ fc_bsg_jobdone(struct fc_bsg_job *job)
>                  BUG_ON(job->reply->reply_payload_rcv_len > rsp_len);
>                  /* set reply (bidi) residual */
>                  rsp->data_len = (rsp_len - job->reply- 
>  >reply_payload_rcv_len);

This part looks a bit white-space broken.

> -       }
> +               blk_end_bidi_request(req, err, blk_rq_bytes(req),
> +                   job->reply->reply_payload_rcv_len);
> 
> -       /* we assume all request payload was transferred */
> -       blk_end_request(req, err, blk_rq_bytes(req));
> +       } else
> +               blk_end_request(req, err, blk_rq_bytes(req));

I still do not like this version for more then one reason. There is
a more proper simpler way.

Where is the code-base this is patching? I'll make a proper patch for you.

> 
>          fc_destroy_bsgjob(job);
>   }
> ---
> 
> With this change, I'm able to issue several ELS/CT services to the  
> qla2xxx module for those registered to the transport layer and have  
> rport associated with them.
> 
<snip>

Boaz
