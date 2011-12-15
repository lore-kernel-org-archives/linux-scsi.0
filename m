From: David Dillow <dillowda-1Heg1YXhbW8@public.gmane.org>
Subject: Re: [PATCH 09/14] srp_transport: Fix attribute registration
Date: Thu, 15 Dec 2011 15:09:39 -0500
Message-ID: <1323979779.16703.72.camel@lap75545.ornl.gov>
References: <201112011954.25811.bvanassche@acm.org>
	 <201112012006.50445.bvanassche@acm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <201112012006.50445.bvanassche-HInyCGIudOg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Roland Dreier <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>, stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Fujita Tomonori <fujita.tomonori-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>, Brian King <brking-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
List-Id: linux-scsi@vger.kernel.org

On Thu, 2011-12-01 at 20:06 +0100, Bart Van Assche wrote:
> Register transport attributes after the attribute array has been
> set up instead of before.

Why?

I don't disagree with the change, but there should be at least a little
discussion of why you're doing it. Your last message about this to James
Bottomley had quite a bit of content, perhaps too much, but then his
comment that 'it's best practice to initialize a structure before
registering it' seems appropriate.

> Signed-off-by: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
> Cc: FUJITA Tomonori <fujita.tomonori-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
> Cc: Brian King <brking-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
> Cc: David Dillow <dillowda-1Heg1YXhbW8@public.gmane.org>
> Cc: Roland Dreier <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>
> Cc: stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> ---
>  drivers/scsi/scsi_transport_srp.c |    3 ++-
>  1 files changed, 2 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/scsi/scsi_transport_srp.c b/drivers/scsi/scsi_transport_srp.c
> index 21a045e..07c4394 100644
> --- a/drivers/scsi/scsi_transport_srp.c
> +++ b/drivers/scsi/scsi_transport_srp.c
> @@ -324,13 +324,14 @@ srp_attach_transport(struct srp_function_template *ft)
>  	i->rport_attr_cont.ac.attrs = &i->rport_attrs[0];
>  	i->rport_attr_cont.ac.class = &srp_rport_class.class;
>  	i->rport_attr_cont.ac.match = srp_rport_match;
> -	transport_container_register(&i->rport_attr_cont);
>  
>  	count = 0;
>  	SETUP_RPORT_ATTRIBUTE_RD(port_id);
>  	SETUP_RPORT_ATTRIBUTE_RD(roles);
>  	i->rport_attrs[count] = NULL;
>  
> +	transport_container_register(&i->rport_attr_cont);
> +
>  	i->f = ft;
>  
>  	return &i->t;

-- 
Dave Dillow
National Center for Computational Science
Oak Ridge National Laboratory
(865) 241-6602 office

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
