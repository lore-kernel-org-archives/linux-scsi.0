From: David Dillow <dillowda-1Heg1YXhbW8@public.gmane.org>
Subject: Re: [PATCH 13/18] ib_srp: Allow SRP disconnect through sysfs
Date: Sun, 26 Feb 2012 01:33:39 -0500
Message-ID: <1330238021.1026.88.camel@obelisk.thedillows.org>
References: <3109536.qySrY1Ts3e@asus> <2116892.gZCKSBP7SJ@asus>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <2116892.gZCKSBP7SJ@asus>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org, fujita.tomonori-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org, brking-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org
List-Id: linux-scsi@vger.kernel.org

On Sat, 2012-01-14 at 12:52 +0000, Bart Van Assche wrote:
> Make it possible to disconnect the IB RC connection used by the
> SRP protocol to communicate with a target.
> 
> Let the SRP transport layer create a sysfs "delete" attribute for
> initiator drivers that support this functionality.

>  
> +	rport->ft = &ib_srp_transport_functions;

The initiator should not be mucking around with internal functions of
the transport. Even if this is going to live in srp_rport rather than
srp_internal like other transports, this assignment should be done in
srp_rport_add().


> diff --git a/drivers/infiniband/ulp/srp/ib_srp.h b/drivers/infiniband/ulp/srp/ib_srp.h
> index 3882adf..22e0c5d 100644
> --- a/drivers/infiniband/ulp/srp/ib_srp.h
> +++ b/drivers/infiniband/ulp/srp/ib_srp.h
> @@ -154,6 +154,7 @@ struct srp_target_port {
>  	u16			io_class;
>  	struct srp_host	       *srp_host;
>  	struct Scsi_Host       *scsi_host;
> +	struct srp_rport       *rport;

Why do we need to save this in our target? You don't use it anywhere in
this patch.


> --- a/drivers/scsi/scsi_transport_srp.c
> +++ b/drivers/scsi/scsi_transport_srp.c

> @@ -116,6 +116,22 @@ show_srp_rport_roles(struct device *dev, struct device_attribute *attr,
>  
>  static DEVICE_ATTR(roles, S_IRUGO, show_srp_rport_roles, NULL);
>  
> +static ssize_t store_srp_rport_delete(struct device *dev,
> +				      struct device_attribute *attr,
> +				      const char *buf, size_t count)
> +{
> +	struct srp_rport *rport = transport_class_to_srp_rport(dev);

This should translate to the srp_internal and then use the function
template there instead of adding them to srp_rport.

	struct Scsi_Host *shost = rport_to_shost(rport);
	struct srp_internal *i = to_srp_internal(shost->transportt);

	if (!i->f->rport_delete)
		return -ENOSYS;

	i->f->rport_delete(rport);
	return count;


> diff --git a/include/scsi/scsi_transport_srp.h b/include/scsi/scsi_transport_srp.h
> index 9c60ca1..1a109ff 100644
> --- a/include/scsi/scsi_transport_srp.h
> +++ b/include/scsi/scsi_transport_srp.h
> @@ -14,13 +14,23 @@ struct srp_rport_identifiers {
>  };
>  
>  struct srp_rport {
> +	/* for initiator and target drivers */
> +
> +	struct srp_function_template *ft;

This isn't needed; while perhaps more efficient, it breaks from the
practice used by other SCSI transports.

>  	struct device dev;
>  
>  	u8 port_id[16];
>  	u8 roles;
> +
> +	/* for initiator drivers */
> +
> +	void			*lld_data;	/* LLD private data */

Other transports add a private data size to the transport's function
templates, and allocate space at the end of the rport. See
fc_function_template:dd_fcrport_size and fc_rport:dd_data.

Using this model will let use store our pointer there for now, and may
let us merge the rport allocation of the initiator with the transport's
allocation in the future.

Or it may just be complexity for no real gain; I can certainly see that
argument against it.

-- 
Dave Dillow
National Center for Computational Science
Oak Ridge National Laboratory
(865) 241-6602 office

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
