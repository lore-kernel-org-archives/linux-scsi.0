From: Boaz Harrosh <bharrosh@panasas.com>
Subject: Re: [RFC] FC pass thru - Rev V
Date: Wed, 11 Feb 2009 18:15:07 +0200
Message-ID: <4992F98B.1060401@panasas.com>
References: <1227043498.4949.21.camel@ogier> <1234365225.24194.3.camel@ogier>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from gw-ca.panasas.com ([66.104.249.162]:8385 "EHLO
	laguna.int.panasas.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753559AbZBKQPR (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 11 Feb 2009 11:15:17 -0500
In-Reply-To: <1234365225.24194.3.camel@ogier>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Smart@Emulex.Com
Cc: linux-scsi@vger.kernel.org, seokmann.ju@qlogic.com, andrew.vasquez@qlogic.com, sven@linux.vnet.ibm.com, futjita.tomonori@lab.ntt.co.jp

James Smart wrote:
> Trying to kick-start this again...  
> I've updated the prior RFC with the comments from Seokmann,
> SvenFujita, and Boaz. I would still like review on the
> blk_xxx completion calls in the std and error paths.
> 
> It currently expects that blk_end_request() has been updated
> by Fujita's patch to incorporate blk_end_bidi_request()
> functionality :
> http://marc.info/?l-linux-scsi&m=122785157116659&w=2
> 

I did not accept this patch and it did not go in right?
I still don't like it, it's a performance regression.

> -- james s
> 
> ======
> 
> All,
> 
> I've reworked Seokmann's patch for the following items:
> - Add an fchost interface for bsg requests
> 
> - Formalized the request/response structures that I expect
>   to have us stuff into the bsg cmd/sense data areas. These
>   are now genericized so we can essentially pass any kind of
>   transaction. It can be a request that has no transmit or
>   receive payload, and simply returns a response.
> 
> - A new file was created, scsi_bsg_fc.h, which contains the
>   request/response data structures that should be shared
>   between the application and the kernel entities. 
> 
> - I stripped out some things that were in the request
>   structure that were actually LLD fields. Instead, I added
>   a dd_bsgsize structure to the template, so the transport
>   will allocate LLD work space along with the job structure.
>   I expect the missing fields to move to this area.
> 
> - I've made a strong attempt at ensuring that the request
>   has all the information necessary for the LLD, so that
>   there is no need to have the LLD remap the transmit payload
>   to figure things out. Granted, this comes at the cost of
>   replicating some data items.
> 
>   Sven, I've added the CT information you needed as part of this.
> 
> - I've renamed things quite a bit, hoping to make it clarity
>   better. The "service" struct is now a job. I still have
>   headaches with "request" (is it the blk request, or the job
>   request, or what..)
> 
> - The CT/ELS response is a bit funky. I've noted that the
>   way Emulex returns a response, vs Qlogic is a bit different,
>   thus the 2 ways to indicate "reject".
> 
> - fixed a couple of bugs in Seokmann's code, in the teardown,
>   error flows, request que dma settings, etc.
> 
> - I added a "vendor_id" field to the scsi_host_template to
>   use when verifying that the recipient knows how to decode
>   vendor-specific message. I didn't do this with the netlink
>   things as I was prepping it to not break kabi in existing
>   and older kernels. But, I believe this is a good time to
>   add it.
> 
> - I've started the Documentation/scsi/scsi_transport_fc.txt
>   documentation, but punted finishing it in lieu of sending
>   this RFC. I'm starting from Seokman's original emails and
>   will be updating for this reformat.
> 
> I'm only starting to debug this, so user beware.
> 
> I could really use some code review from Fujita or Boaz, to
> make sure I'm calling the right blk_xx completion functions
> relative to the setup flow, and to ensure that the "goose"
> when I jump out while the rport is blocked is correct.
> 
> Comments welcome
> 
> -- james s
> 
> 
> 
> 
> 
>  Signed-off-by: James Smart <james.smart@emulex.com>
> 
>  ---
> 
>  Documentation/scsi/scsi_fc_transport.txt |   11 
>  Documentation/scsi/scsi_mid_low_api.txt  |    5 
>  drivers/scsi/scsi_transport_fc.c         |  614 ++++++++++++++++++++++++++++++-
>  include/scsi/scsi_bsg_fc.h               |  322 ++++++++++++++++
>  include/scsi/scsi_host.h                 |    9 
>  include/scsi/scsi_transport_fc.h         |   52 ++
>  6 files changed, 1009 insertions(+), 4 deletions(-)
> 
> 
> diff -upNr a/Documentation/scsi/scsi_fc_transport.txt b/Documentation/scsi/scsi_fc_transport.txt
> --- a/Documentation/scsi/scsi_fc_transport.txt	2009-01-27 09:44:22.000000000 -0500
> +++ b/Documentation/scsi/scsi_fc_transport.txt	2009-02-10 10:34:42.000000000 -0500
> @@ -1,10 +1,11 @@
>                               SCSI FC Tansport
>                   =============================================
>  
> -Date:  4/12/2007
> +Date:  11/18/2008
>  Kernel Revisions for features:
>    rports : <<TBS>>
>    vports : 2.6.22 (? TBD)
> +  bsg support : 2.6.29 (?TBD)
>  
>  
>  Introduction
> @@ -15,6 +16,7 @@ The FC transport can be found at:
>    drivers/scsi/scsi_transport_fc.c
>    include/scsi/scsi_transport_fc.h
>    include/scsi/scsi_netlink_fc.h
> +  include/scsi/scsi_bsg_fc.h
>  
>  This file is found at Documentation/scsi/scsi_fc_transport.txt
>  
> @@ -472,6 +474,13 @@ int
>  fc_vport_terminate(struct fc_vport *vport)
>  
>  
> +FC BSG support (CT & ELS passthru, and more)
> +========================================================================
> +<< To Be Supplied >>
> +
> +
> +
> +
>  Credits
>  =======
>  The following people have contributed to this document:
> diff -upNr a/Documentation/scsi/scsi_mid_low_api.txt b/Documentation/scsi/scsi_mid_low_api.txt
> --- a/Documentation/scsi/scsi_mid_low_api.txt	2008-09-23 15:11:57.000000000 -0400
> +++ b/Documentation/scsi/scsi_mid_low_api.txt	2009-02-10 10:34:42.000000000 -0500
> @@ -1271,6 +1271,11 @@ of interest:
>      hostdata[0]  - area reserved for LLD at end of struct Scsi_Host. Size
>                     is set by the second argument (named 'xtr_bytes') to
>                     scsi_host_alloc() or scsi_register().
> +    vendor_id    - a unique value that identifies the vendor supplying
> +                   the LLD for the Scsi_Host.  Used most often in validating
> +                   vendor-specific message requests.  Value consists of an
> +                   identifier type and a vendor-specific value.
> +                   See scsi_netlink.h for a description of valid formats.
>  
>  The scsi_host structure is defined in include/scsi/scsi_host.h
>  
> diff -upNr a/drivers/scsi/scsi_transport_fc.c b/drivers/scsi/scsi_transport_fc.c
> --- a/drivers/scsi/scsi_transport_fc.c	2009-01-27 09:44:31.000000000 -0500
> +++ b/drivers/scsi/scsi_transport_fc.c	2009-02-10 14:58:39.000000000 -0500
> @@ -35,6 +35,7 @@
>  #include <linux/netlink.h>
>  #include <net/netlink.h>
>  #include <scsi/scsi_netlink_fc.h>
> +#include <scsi/scsi_bsg_fc.h>
>  #include "scsi_priv.h"
>  #include "scsi_transport_fc_internal.h"
>  
> @@ -43,6 +44,10 @@ static void fc_vport_sched_delete(struct
>  static int fc_vport_setup(struct Scsi_Host *shost, int channel,
>  	struct device *pdev, struct fc_vport_identifiers  *ids,
>  	struct fc_vport **vport);
> +static int fc_bsg_hostadd(struct Scsi_Host *, struct fc_host_attrs *);
> +static int fc_bsg_rportadd(struct Scsi_Host *, struct fc_rport *);
> +static void fc_bsg_remove(struct request_queue *);
> +static void fc_bsg_goose_queue(struct fc_rport *);
>  
>  /*
>   * Redefine so that we can have same named attributes in the
> @@ -411,13 +416,26 @@ static int fc_host_setup(struct transpor
>  		return -ENOMEM;
>  	}
>  
> +	fc_bsg_hostadd(shost, fc_host);
> +	/* ignore any bsg add error - we just can't do sgio */
> +
> +	return 0;
> +}
> +
> +static int fc_host_remove(struct transport_container *tc, struct device *dev,
> +			 struct device *cdev)
> +{
> +	struct Scsi_Host *shost = dev_to_shost(dev);
> +	struct fc_host_attrs *fc_host = shost_to_fc_host(shost);
> +
> +	fc_bsg_remove(fc_host->rqst_q);
>  	return 0;
>  }
>  
>  static DECLARE_TRANSPORT_CLASS(fc_host_class,
>  			       "fc_host",
>  			       fc_host_setup,
> -			       NULL,
> +			       fc_host_remove,
>  			       NULL);
>  
>  /*
> @@ -2383,6 +2401,7 @@ fc_rport_final_delete(struct work_struct
>  		scsi_flush_work(shost);
>  
>  	fc_terminate_rport_io(rport);
> +
>  	/*
>  	 * Cancel any outstanding timers. These should really exist
>  	 * only when rmmod'ing the LLDD and we're asking for
> @@ -2415,6 +2434,8 @@ fc_rport_final_delete(struct work_struct
>  	    (i->f->dev_loss_tmo_callbk))
>  		i->f->dev_loss_tmo_callbk(rport);
>  
> +	fc_bsg_remove(rport->rqst_q);
> +
>  	transport_remove_device(dev);
>  	device_del(dev);
>  	transport_destroy_device(dev);
> @@ -2502,6 +2523,9 @@ fc_rport_create(struct Scsi_Host *shost,
>  	transport_add_device(dev);
>  	transport_configure_device(dev);
>  
> +	fc_bsg_rportadd(shost, rport);
> +	/* ignore any bsg add error - we just can't do sgio */
> +
>  	if (rport->roles & FC_PORT_ROLE_FCP_TARGET) {
>  		/* initiate a scan of the target */
>  		rport->flags |= FC_RPORT_SCAN_PENDING;
> @@ -2666,6 +2690,8 @@ fc_remote_port_add(struct Scsi_Host *sho
>  					spin_unlock_irqrestore(shost->host_lock,
>  							flags);
>  
> +				fc_bsg_goose_queue(rport);
> +
>  				return rport;
>  			}
>  		}
> @@ -3351,6 +3377,592 @@ fc_vport_sched_delete(struct work_struct
>  }
>  
>  
> +/*
> + * BSG support
> + */
> +
> +
> +/**
> + * fc_destroy_bsgjob - routine to teardown/delete a fc bsg job
> + * @job:	fc_bsg_job that is to be torn down
> + */
> +static void
> +fc_destroy_bsgjob(struct fc_bsg_job *job)
> +{
> +	unsigned long flags;
> +
> +	spin_lock_irqsave(&job->job_lock, flags);
> +	if (job->ref_cnt) {
> +		spin_unlock_irqrestore(&job->job_lock, flags);
> +		return;
> +	}
> +	spin_unlock_irqrestore(&job->job_lock, flags);
> +
> +	put_device(job->dev);	/* release reference for the request */
> +
> +	kfree(job->request_payload.sg_list);
> +	kfree(job->reply_payload.sg_list);
> +	kfree(job);
> +}
> +
> +
> +/**
> + * fc_bsg_jobdone - completion routine for bsg requests that the LLD has
> + *                  completed
> + * @job:	fc_bsg_job that is complete
> + */
> +static void
> +fc_bsg_jobdone(struct fc_bsg_job *job)
> +{
> +	struct request *req = job->req;
> +	struct request *rsp = req->next_rq;
> +	unsigned long flags;
> +	unsigned rsp_len;
-	unsigned rsp_len;
+	unsigned rsp_len = 0;
+	unsigned req_len = 0;

See below

> +	int err;
> +
> +	spin_lock_irqsave(&job->job_lock, flags);
> +	job->state_flags |= FC_RQST_STATE_DONE;
> +	job->ref_cnt--;
> +	spin_unlock_irqrestore(&job->job_lock, flags);
> +
> +	err = job->req->errors = job->reply->result;
> +	if (err < 0)
> +		/* we're only returning the result field in the reply */
> +		job->req->sense_len = sizeof(uint32_t);
> +	else
> +		job->req->sense_len = job->reply_len;
> +

Why use of  job->req when you have req = job->req above, it's confusing.

> +	if (rsp) {
> +		rsp_len = blk_rq_bytes(rsp);
> +		BUG_ON(job->reply->reply_payload_rcv_len > rsp_len);
> +		/* set reply (bidi) residual */
> +		rsp->data_len = (rsp_len - job->reply->reply_payload_rcv_len);
> +	}
> +
> +	/* we assume all request payload was transferred */
> +	blk_end_request(req, err, blk_rq_bytes(req));

Don't you need residual count in bsg caller?

This code will always return full request->data_len as residual count
of out/uni_in to caller of bsg SG_IO caller.

and it will only work with the un-accepted patch above just do:

+	if (rsp) {
+		rsp_len = blk_rq_bytes(rsp);
+		BUG_ON(job->reply->reply_payload_rcv_len > rsp_len);
+		/* set reply (bidi) residual */
+		rsp->data_len = (rsp_len - job->reply->reply_payload_rcv_len);
+	}
+
+	req_len = blk_rq_bytes(req);
+	/* we assume all request payload was transferred */
+	req->data_len = 0;
+	blk_end_bidi_request(req, err, req_len, rsp_len);

This will handle all cases today without need of above patch.

> +
> +	fc_destroy_bsgjob(job);
> +}
> +
> +
<snip>

Thanks
Boaz
