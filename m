Return-Path: <SRS0=FF5A=DH=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.5 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,NICE_REPLY_A,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0C357C4727E
	for <linux-scsi@archiver.kernel.org>; Wed, 30 Sep 2020 09:33:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C02F120739
	for <linux-scsi@archiver.kernel.org>; Wed, 30 Sep 2020 09:33:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728149AbgI3JdT (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 30 Sep 2020 05:33:19 -0400
Received: from mx2.suse.de ([195.135.220.15]:35790 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725776AbgI3JdT (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 30 Sep 2020 05:33:19 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 92508B018;
        Wed, 30 Sep 2020 09:33:16 +0000 (UTC)
Subject: Re: [PATCH v2 7/8] scsi_transport_fc: Added a new sysfs attribute
 port_state
To:     Muneendra <muneendra.kumar@broadcom.com>,
        linux-scsi@vger.kernel.org
Cc:     jsmart2021@gmail.com, emilne@redhat.com, mkumar@redhat.com
References: <1601268657-940-1-git-send-email-muneendra.kumar@broadcom.com>
 <1601268657-940-8-git-send-email-muneendra.kumar@broadcom.com>
From:   Hannes Reinecke <hare@suse.de>
Message-ID: <89648ad7-d4d2-c684-16d5-6bd39398f046@suse.de>
Date:   Wed, 30 Sep 2020 11:33:15 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.12.0
MIME-Version: 1.0
In-Reply-To: <1601268657-940-8-git-send-email-muneendra.kumar@broadcom.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 9/28/20 6:50 AM, Muneendra wrote:
> Added a new sysfs attribute port_state under fc_transport/target*/
> 
> With this new interface the user can move the port_state from
> Marginal -> Online and Online->Marginal.
> 
> On Marginal :This interface will set SCMD_NORETRIES_ABORT bit in
> scmd->state for all the pending io's on the scsi device associated
> with target port.
> 
> On Online :This interface will clear SCMD_NORETRIES_ABORT bit in
> scmd->state for all the pending io's on the scsi device associated
> with target port.
> 
> Below is the interface provided to set the port state to Marginal
> and Online.
> 
> echo "Marginal" >> /sys/class/fc_transport/targetX\:Y\:Z/port_state
> echo "Online" >> /sys/class/fc_transport/targetX\:Y\:Z/port_state
> 
> Also made changes in fc_remote_port_delete,fc_user_scan_tgt,
> fc_timeout_deleted_rport functions  to handle the new rport state
> FC_PORTSTATE_MARGINAL.
> 
> Signed-off-by: Muneendra <muneendra.kumar@broadcom.com>
> 
> ---
> v2:
> Changed from a noretries_abort attribute under fc_transport/target*/ to
> port_state for changing the port_state to a marginal state
> ---
>   drivers/scsi/scsi_transport_fc.c | 140 +++++++++++++++++++++++++++----
>   1 file changed, 122 insertions(+), 18 deletions(-)
> 
> diff --git a/drivers/scsi/scsi_transport_fc.c b/drivers/scsi/scsi_transport_fc.c
> index 2ff7f06203da..6fe2463c5a68 100644
> --- a/drivers/scsi/scsi_transport_fc.c
> +++ b/drivers/scsi/scsi_transport_fc.c
> @@ -142,20 +142,23 @@ fc_enum_name_search(host_event_code, fc_host_event_code,
>   static struct {
>   	enum fc_port_state	value;
>   	char			*name;
> +	int			matchlen;
>   } fc_port_state_names[] = {
> -	{ FC_PORTSTATE_UNKNOWN,		"Unknown" },
> -	{ FC_PORTSTATE_NOTPRESENT,	"Not Present" },
> -	{ FC_PORTSTATE_ONLINE,		"Online" },
> -	{ FC_PORTSTATE_OFFLINE,		"Offline" },
> -	{ FC_PORTSTATE_BLOCKED,		"Blocked" },
> -	{ FC_PORTSTATE_BYPASSED,	"Bypassed" },
> -	{ FC_PORTSTATE_DIAGNOSTICS,	"Diagnostics" },
> -	{ FC_PORTSTATE_LINKDOWN,	"Linkdown" },
> -	{ FC_PORTSTATE_ERROR,		"Error" },
> -	{ FC_PORTSTATE_LOOPBACK,	"Loopback" },
> -	{ FC_PORTSTATE_DELETED,		"Deleted" },
> +	{ FC_PORTSTATE_UNKNOWN,		"Unknown", 7},
> +	{ FC_PORTSTATE_NOTPRESENT,	"Not Present", 11 },
> +	{ FC_PORTSTATE_ONLINE,		"Online", 6 },
> +	{ FC_PORTSTATE_OFFLINE,		"Offline", 7 },
> +	{ FC_PORTSTATE_BLOCKED,		"Blocked", 7 },
> +	{ FC_PORTSTATE_BYPASSED,	"Bypassed", 8 },
> +	{ FC_PORTSTATE_DIAGNOSTICS,	"Diagnostics", 11 },
> +	{ FC_PORTSTATE_LINKDOWN,	"Linkdown", 8 },
> +	{ FC_PORTSTATE_ERROR,		"Error", 5 },
> +	{ FC_PORTSTATE_LOOPBACK,	"Loopback", 8 },
> +	{ FC_PORTSTATE_DELETED,		"Deleted", 7 },
> +	{ FC_PORTSTATE_MARGINAL,	"Marginal", 8 },
>   };
>   fc_enum_name_search(port_state, fc_port_state, fc_port_state_names)
> +fc_enum_name_match(port_state, fc_port_state, fc_port_state_names)
>   #define FC_PORTSTATE_MAX_NAMELEN	20
>   
>   
> @@ -306,7 +309,7 @@ static void fc_scsi_scan_rport(struct work_struct *work);
>    * Attribute counts pre object type...
>    * Increase these values if you add attributes
>    */
> -#define FC_STARGET_NUM_ATTRS 	3
> +#define FC_STARGET_NUM_ATTRS	4
>   #define FC_RPORT_NUM_ATTRS	10
>   #define FC_VPORT_NUM_ATTRS	9
>   #define FC_HOST_NUM_ATTRS	29
> @@ -358,10 +361,12 @@ static int fc_target_setup(struct transport_container *tc, struct device *dev,
>   		fc_starget_node_name(starget) = rport->node_name;
>   		fc_starget_port_name(starget) = rport->port_name;
>   		fc_starget_port_id(starget) = rport->port_id;
> +		fc_starget_port_state(starget) = rport->port_state;
>   	} else {
>   		fc_starget_node_name(starget) = -1;
>   		fc_starget_port_name(starget) = -1;
>   		fc_starget_port_id(starget) = -1;
> +		fc_starget_port_state(starget) = FC_PORTSTATE_UNKNOWN;
>   	}
>   
>   	return 0;
> @@ -995,6 +1000,93 @@ static FC_DEVICE_ATTR(rport, fast_io_fail_tmo, S_IRUGO | S_IWUSR,
>   /*
>    * FC SCSI Target Attribute Management
>    */
> +static void scsi_target_chg_noretries_abort(struct scsi_target *starget, int set)
> +{
> +	struct scsi_device *sdev, *tmp;
> +	struct Scsi_Host *shost = dev_to_shost(starget->dev.parent);
> +	unsigned long flags;
> +
> +	spin_lock_irqsave(shost->host_lock, flags);
> +	list_for_each_entry_safe(sdev, tmp, &starget->devices, same_target_siblings) {
> +		if (sdev->sdev_state == SDEV_DEL)
> +			continue;
> +
> +		spin_unlock_irqrestore(shost->host_lock, flags);
> +		if (scsi_device_get(sdev))
> +			continue;
> +
> +		spin_unlock_irqrestore(shost->host_lock, flags);
> +		scsi_chg_noretries_abort_io_device(sdev, set);
> +		spin_lock_irqsave(shost->host_lock, flags);
> +		scsi_device_put(sdev);
> +	}
> +	spin_unlock_irqrestore(shost->host_lock, flags);
> +}
> +
> +/*
> + * Sets port_state to Marginal/Online.
> + * On Marginal it Sets  no retries on abort in scmd->state for all
> + * outstanding io of all the scsi_devs
> + * This only allows ONLINE->MARGINAL and MARGINAL->ONLINE
> + */
> +static ssize_t fc_target_set_marginal_state(struct device *dev,
> +						struct device_attribute *attr,
> +						const char *buf, size_t count)
> +{
> +	struct scsi_target *starget = transport_class_to_starget(dev);
> +	struct fc_rport *rport = starget_to_rport(starget);
> +	enum fc_port_state port_state;
> +	int ret = 0;
> +
> +	ret = get_fc_port_state_match(buf, &port_state);
> +
> +	if (port_state == FC_PORTSTATE_MARGINAL) {
> +
> +		/*
> +		 * Change the state to marginal only if the
> +		 * current rport state is Online
> +		 * Allow only Online->marginal
> +		 */
> +		if (rport->port_state == FC_PORTSTATE_ONLINE) {
> +			rport->port_state = port_state;
> +			scsi_target_chg_noretries_abort(starget, 1);
> +		}
> +
> +	} else if (port_state == FC_PORTSTATE_ONLINE) {
> +		/*
> +		 * Change the state to Online only if the
> +		 * current rport state is Marginal
> +		 * Allow only  MArginal->Online
> +		 */
> +
> +		if (rport->port_state == FC_PORTSTATE_MARGINAL) {
> +			rport->port_state = port_state;
> +			scsi_target_chg_noretries_abort(starget, 0);
> +		}
> +
> +
> +	} else
> +		return -EINVAL;
> +	return count;
> +}
> +
> +static ssize_t
> +fc_target_show_port_state(struct device *dev,
> +				struct device_attribute *attr, char *buf)
> +{
> +	const char *name;
> +	struct scsi_target *starget = transport_class_to_starget(dev);
> +	struct fc_rport *rport = starget_to_rport(starget);
> +
> +	name = get_fc_port_state_name(rport->port_state);
> +	if (!name)
> +		return -EINVAL;
> +
> +	return snprintf(buf, 20, "%s\n", name);
> +}
> +
> +static FC_DEVICE_ATTR(starget, port_state, 0444 | 0200,
> +		fc_target_show_port_state, fc_target_set_marginal_state);
>   
>   /*
>    * Note: in the target show function we recognize when the remote
> @@ -1037,6 +1129,13 @@ static FC_DEVICE_ATTR(starget, field, S_IRUGO,			\
>   	if (i->f->show_starget_##field)					\
>   		count++
>   
> +#define SETUP_PRIVATE_STARGET_ATTRIBUTE_RW(field)			\
> +do {									\
> +	i->private_starget_attrs[count] = device_attr_starget_##field; \
> +	i->starget_attrs[count] = &i->private_starget_attrs[count];	\
> +	count++;							\
> +} while (0)
> +
>   #define SETUP_STARGET_ATTRIBUTE_RW(field)				\
>   	i->private_starget_attrs[count] = device_attr_starget_##field; \
>   	if (!i->f->set_starget_##field) {				\
> @@ -2095,7 +2194,8 @@ fc_user_scan_tgt(struct Scsi_Host *shost, uint channel, uint id, u64 lun)
>   		if (rport->scsi_target_id == -1)
>   			continue;
>   
> -		if (rport->port_state != FC_PORTSTATE_ONLINE)
> +		if ((rport->port_state != FC_PORTSTATE_ONLINE) &&
> +			(rport->port_state != FC_PORTSTATE_MARGINAL))
>   			continue;
>   
>   		if ((channel == rport->channel) &&

This really should be moved to the previous patch.

> @@ -2198,7 +2298,7 @@ fc_attach_transport(struct fc_function_template *ft)
>   	SETUP_STARGET_ATTRIBUTE_RD(node_name);
>   	SETUP_STARGET_ATTRIBUTE_RD(port_name);
>   	SETUP_STARGET_ATTRIBUTE_RD(port_id);
> -
> +	SETUP_PRIVATE_STARGET_ATTRIBUTE_RW(port_state);
>   	BUG_ON(count > FC_STARGET_NUM_ATTRS);
>   
>   	i->starget_attrs[count] = NULL;

Why did you move it to be a 'starget' attribute?
I would have thought it should be an 'rport' attribute, seeing that it's 
intrinsic to the fc transport class.

> @@ -2958,7 +3058,8 @@ fc_remote_port_delete(struct fc_rport  *rport)
>   
>   	spin_lock_irqsave(shost->host_lock, flags);
>   
> -	if (rport->port_state != FC_PORTSTATE_ONLINE) {
> +	if ((rport->port_state != FC_PORTSTATE_ONLINE) &&
> +		(rport->port_state != FC_PORTSTATE_MARGINAL)) {
>   		spin_unlock_irqrestore(shost->host_lock, flags);
>   		return;
>   	}
> @@ -3100,7 +3201,8 @@ fc_timeout_deleted_rport(struct work_struct *work)
>   	 * target, validate it still is. If not, tear down the
>   	 * scsi_target on it.
>   	 */
> -	if ((rport->port_state == FC_PORTSTATE_ONLINE) &&
> +	if (((rport->port_state == FC_PORTSTATE_ONLINE) ||
> +		(rport->port_state == FC_PORTSTATE_MARGINAL)) &&
>   	    (rport->scsi_target_id != -1) &&
>   	    !(rport->roles & FC_PORT_ROLE_FCP_TARGET)) {
>   		dev_printk(KERN_ERR, &rport->dev,
> @@ -3243,7 +3345,8 @@ fc_scsi_scan_rport(struct work_struct *work)
>   	struct fc_internal *i = to_fc_internal(shost->transportt);
>   	unsigned long flags;
>   
> -	if ((rport->port_state == FC_PORTSTATE_ONLINE) &&
> +	if (((rport->port_state == FC_PORTSTATE_ONLINE) ||
> +		(rport->port_state == FC_PORTSTATE_ONLINE)) &&
>   	    (rport->roles & FC_PORT_ROLE_FCP_TARGET) &&
>   	    !(i->f->disable_target_scan)) {
>   		scsi_scan_target(&rport->dev, rport->channel,
> @@ -3747,7 +3850,8 @@ static blk_status_t fc_bsg_rport_prep(struct fc_rport *rport)
>   	    !(rport->flags & FC_RPORT_FAST_FAIL_TIMEDOUT))
>   		return BLK_STS_RESOURCE;
>   
> -	if (rport->port_state != FC_PORTSTATE_ONLINE)
> +	if ((rport->port_state != FC_PORTSTATE_ONLINE) &&
> +		(rport->port_state != FC_PORTSTATE_MARGINAL))
>   		return BLK_STS_IOERR;
>   
>   	return BLK_STS_OK;
> 
All of this should be moved to the previous patch; this should be just 
for the sysfs attribute.

Cheers,

Hannes
-- 
Dr. Hannes Reinecke		           Kernel Storage Architect
hare@suse.de			                  +49 911 74053 688
SUSE Software Solutions Germany GmbH, Maxfeldstr. 5, 90409 Nürnberg
HRB 36809 (AG Nürnberg), GF: Felix Imendörffer
