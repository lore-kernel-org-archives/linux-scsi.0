From: "Bhanu Prakash Gollapudi" <bprakash@broadcom.com>
Subject: Re: [RFC PATCH v2 5/5] bnx2fc: Use the fcoe_sysfs control
 interface
Date: Sun, 30 Sep 2012 23:49:52 -0700
Message-ID: <50693D10.7010204@broadcom.com>
References: <20120927020142.20592.56661.stgit@fritz>
 <20120927020209.20592.36040.stgit@fritz>
Mime-Version: 1.0
Content-Type: text/plain;
 charset=utf-8;
 format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mms2.broadcom.com ([216.31.210.18]:4058 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751416Ab2JAGuj (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 1 Oct 2012 02:50:39 -0400
In-Reply-To: <20120927020209.20592.36040.stgit@fritz>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Robert Love <robert.w.love@intel.com>
Cc: cleech@redhat.com, bvanassche@acm.org, devel@open-fcoe.org, linux-scsi@vger.kernel.org

On 09/26/2012 07:02 PM, Robert Love wrote:
> This patch adds support for the new fcoe_sysfs
> control interface to bnx2fc.ko. It keeps the deprecated
> interface in tact and therefore either the legacy
> or the new control interfaces can be used. A mixed mode
> is not supported. A user must either use the new
> interfaces or the old ones, but not both.
>
> The fcoe_ctlr's link state is now driven by both the
> netdev link state as well as the fcoe_ctlr_device's
> enabled attribute. The link must be up and the
> fcoe_ctlr_device must be enabled before the FCoE
> Controller starts discovery or login.
>
> Signed-off-by: Robert Love <robert.w.love@intel.com>

Changes look good to me. I did some testing and did not observe any 
issues, except that a small modification is required in _bnx2fc_create() 
(see below). In fact, I like the new design, as we do not have any user 
space compatibility issues.

I also see that even the non-netdev based FCoE driver can also take 
advantage of this provided they use libfcoe for FIP, which is good.

Thanks.

> +/**
> + * _bnx2fc_create() - Create bnx2fc FCoE interface
> + * @netdev  :   The net_device object the Ethernet interface to create on
> + * @fip_mode:   The FIP mode for this creation
> + * @link_state: The ctlr link state on creation
>    *
> - * Called from sysfs.
> + * Called from either the libfcoe 'create' module parameter
> + * via fcoe_create or from fcoe_syfs's ctlr_create file.
> + *
> + * libfcoe's 'create' module parameter is deprecated so some
> + * consolidation of code can be done when that interface is
> + * removed.
>    *
>    * Returns: 0 for success
>    */
> -static int bnx2fc_create(struct net_device *netdev, enum fip_state fip_mode)
> +static int _bnx2fc_create(struct net_device *netdev,
> +			  enum fip_state fip_mode,
> +			  enum bnx2fc_create_link_state link_state)
>   {
> +	struct fcoe_ctlr_device *cdev;
>   	struct fcoe_ctlr *ctlr;
>   	struct bnx2fc_interface *interface;
>   	struct bnx2fc_hba *hba;
> @@ -2111,7 +2177,15 @@ static int bnx2fc_create(struct net_device *netdev, enum fip_state fip_mode)
>   	/* Make this master N_port */
>   	ctlr->lp = lport;
>   
> -	if (!bnx2fc_link_ok(lport)) {
> +	cdev = fcoe_ctlr_to_ctlr_dev(ctlr);
> +
> +	if (link_state == BNX2FC_CREATE_LINK_UP)
> +		cdev->enabled = FCOE_CTLR_ENABLED;
> +	else
> +		cdev->enabled = FCOE_CTLR_DISABLED;
> +
> +	if (link_state == BNX2FC_CREATE_LINK_UP &&
> +	    !bnx2fc_link_ok(lport)) {
>   		fcoe_ctlr_link_up(ctlr);
>   		fc_host_port_type(lport->host) = FC_PORTTYPE_NPORT;
>   		set_bit(ADAPTER_STATE_READY, &interface->hba->adapter_state);
bnx2fc needs the following check in _bnx2fc_create. Otherwise, during 
ifup, bnx2fc_ulp_start() may start the interface even if enabled is not set.

diff --git a/drivers/scsi/bnx2fc/bnx2fc_fcoe.c 
b/drivers/scsi/bnx2fc/bnx2fc_fcoe.c
index 60baf88..e96bf54 100644
--- a/drivers/scsi/bnx2fc/bnx2fc_fcoe.c
+++ b/drivers/scsi/bnx2fc/bnx2fc_fcoe.c
@@ -2193,7 +2193,8 @@ static int _bnx2fc_create(struct net_device *netdev,

         BNX2FC_HBA_DBG(lport, "create: START DISC\n");
         bnx2fc_start_disc(interface);
-       interface->enabled = true;
+       if (link_state == BNX2FC_CREATE_LINK_UP)
+               interface->enabled = true;
         /*
          * Release from kref_init in bnx2fc_interface_setup, on success
          * lport should be holding a reference taken in bnx2fc_if_create


> @@ -2145,6 +2219,37 @@ mod_err:
>   }
>   
>   /**
> + * bnx2fc_create() - Create a bnx2fc interface
> + * @netdev  : The net_device object the Ethernet interface to create on
> + * @fip_mode: The FIP mode for this creation
> + *
> + * Called from fcoe transport
> + *
> + * Returns: 0 for success
> + */
> +static int bnx2fc_create(struct net_device *netdev, enum fip_state fip_mode)
> +{
> +	return _bnx2fc_create(netdev, fip_mode, BNX2FC_CREATE_LINK_UP);
> +}
> +
> +/**
> + * bnx2fc_ctlr_alloc() - Allocate a bnx2fc interface from fcoe_sysfs
> + * @netdev: The net_device to be used by the allocated FCoE Controller
> + *
> + * This routine is called from fcoe_sysfs. It will start the fcoe_ctlr
> + * in a link_down state. The allows the user an opportunity to configure
> + * the FCoE Controller from sysfs before enabling the FCoE Controller.
> + *
> + * Creating in with this routine starts the FCoE Controller in Fabric
> + * mode. The user can change to VN2VN or another mode before enabling.
> + */
> +static int bnx2fc_ctlr_alloc(struct net_device *netdev)
> +{
> +	return _bnx2fc_create(netdev, FIP_MODE_FABRIC,
> +			      BNX2FC_CREATE_LINK_DOWN);
> +}
> +
> +/**
>    * bnx2fc_find_hba_for_cnic - maps cnic instance to bnx2fc hba instance
>    *
>    * @cnic:	Pointer to cnic device instance
> @@ -2270,6 +2375,7 @@ static struct fcoe_transport bnx2fc_transport = {
>   	.name = {"bnx2fc"},
>   	.attached = false,
>   	.list = LIST_HEAD_INIT(bnx2fc_transport.list),
> +	.alloc = bnx2fc_ctlr_alloc,
>   	.match = bnx2fc_match,
>   	.create = bnx2fc_create,
>   	.destroy = bnx2fc_destroy,
> @@ -2514,6 +2620,7 @@ module_init(bnx2fc_mod_init);
>   module_exit(bnx2fc_mod_exit);
>   
>   static struct fcoe_sysfs_function_template bnx2fc_fcoe_sysfs_templ = {
> +	.set_fcoe_ctlr_enabled = bnx2fc_ctlr_enabled,
>   	.get_fcoe_ctlr_link_fail = bnx2fc_ctlr_get_lesb,
>   	.get_fcoe_ctlr_vlink_fail = bnx2fc_ctlr_get_lesb,
>   	.get_fcoe_ctlr_miss_fka = bnx2fc_ctlr_get_lesb,
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>



