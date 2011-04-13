From: Mike Christie <michaelc@cs.wisc.edu>
Subject: Re: [RFC-V2 PATCH 2/5] qla4xxx: add support for set_net_config
Date: Tue, 12 Apr 2011 22:55:54 -0500
Message-ID: <4DA51ECA.1020507@cs.wisc.edu>
References: <1301769261-29896-1-git-send-email-vikas.chaudhary@qlogic.com> <1301769261-29896-3-git-send-email-vikas.chaudhary@qlogic.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:50782 "EHLO sabe.cs.wisc.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756932Ab1DMD4G (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 12 Apr 2011 23:56:06 -0400
In-Reply-To: <1301769261-29896-3-git-send-email-vikas.chaudhary@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: vikas.chaudhary@qlogic.com
Cc: James.Bottomley@suse.de, linux-scsi@vger.kernel.org, open-iscsi@googlegroups.com, lalit.chandivade@qlogic.com, ravi.anand@qlogic.com, Harish Zunjarrao <harish.zunjarrao@qlogic.com>

On 04/02/2011 01:34 PM, vikas.chaudhary@qlogic.com wrote:
>
> +/* Only for primary ACB, secondary ACB not supported
> + * iface_num = 0: valid ->  linklocal, routable, router, autocfg options
> + * iface_num = 1: valid ->  routable
> + */
> +static inline void qla4xxx_set_ipv6(struct iscsi_net_param *net_param,
> +		struct addr_ctrl_blk *init_fw_cb)
> +{
> +	switch (net_param->param_type) {
> +	case ISCSI_NET_PARAM_IPV6_ADDR:
> +		if (net_param->iface_num&  0x1) {

Is this my mailer?

I think you want to check for iface_num == 1. Above in the function 
comments and in other places you set the iface_num as a int, but in this 
function you check it more like a bitmask.


> +	case ISCSI_NET_PARAM_IPV6_LINKLOCAL:
> +		if (net_param->iface_num&  0x1)

> +	case ISCSI_NET_PARAM_IPV6_ROUTER:
> +		if (net_param->iface_num&  0x1)


> +	case ISCSI_NET_PARAM_IPV6_ADDR_AUTOCFG:
> +		/* Autocfg applies to even interface */
> +		if (net_param->iface_num&  0x1)

However, in other places you have that comment about even applying to 
autocfg interfaces.

Why does it say even but you only support 2 ipv6 ifaces in the  patches? 
Can you support more? Are you coding it in preparation for more?


.....



> +
> +static int
> +qla4xxx_set_net_config(struct Scsi_Host *shost, char *data, int count)
> +{
> +	struct scsi_qla_host *ha = to_qla_host(shost);
> +	int rval = 0;
> +	struct iscsi_net_param *net_param = NULL;
> +	struct addr_ctrl_blk *init_fw_cb = NULL;
> +	dma_addr_t init_fw_cb_dma;
> +
> +	struct addr_ctrl_blk *acb = NULL;
> +	dma_addr_t acb_dma;
> +	uint32_t ddb_state;
> +	struct ddb_entry *ddb_entry, *ddbtemp;
> +	unsigned long wait_time;
> +
> +	uint32_t mbox_cmd[MBOX_REG_COUNT];
> +	uint32_t mbox_sts[MBOX_REG_COUNT];
> +	uint32_t total_param_count;
> +	uint32_t length;
> +
> +	init_fw_cb = dma_alloc_coherent(&ha->pdev->dev,
> +	    sizeof(struct addr_ctrl_blk),&init_fw_cb_dma, GFP_KERNEL);
> +	if (!init_fw_cb) {
> +		printk(KERN_ERR
> +		    "scsi(%ld): %s: Unable to alloc init_cb\n",
> +		    ha->host_no, __func__);

ql4_printk instead of printk. Check in other parts of patches too.

And remember to remove debugging printks or make what looking debug 
printks more informative and use ql4_printk.


When we set the net settings we reset the port, right? What is the max 
length of time that could take? Like if you set DHCP, do we wait for 
that to timeout and what is longest we wait?

It was orignally designed to be singled threaded non blocking, so you 
are stopping everything here.
