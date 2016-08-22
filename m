From: James Smart <james.smart@broadcom.com>
Subject: Re: [PATCH 5/5] nvme-fabrics: Add FC LLDD loopback driver to test FC
 host and target transport
Date: Mon, 22 Aug 2016 10:14:25 -0700
Message-ID: <15eab2d7-b42f-27f1-f934-369db6911c47@broadcom.com>
References: <5792b91f.Lb5BdNQrSWnmgOYG%james.smart@broadcom.com>
 <1470183344.3928.54.camel@linux.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pa0-f51.google.com ([209.85.220.51]:34366 "EHLO
        mail-pa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751774AbcHVRO1 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 22 Aug 2016 13:14:27 -0400
Received: by mail-pa0-f51.google.com with SMTP id fi15so39450913pac.1
        for <linux-scsi@vger.kernel.org>; Mon, 22 Aug 2016 10:14:27 -0700 (PDT)
In-Reply-To: <1470183344.3928.54.camel@linux.intel.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: J Freyensee <james_p_freyensee@linux.intel.com>, linux-nvme@lists.infradead.org, linux-scsi@vger.kernel.org



On 8/2/2016 5:15 PM, J Freyensee wrote:
>
>>   +int
>> +fcloop_fcp_op(struct nvmet_fc_target_port *tgtport,
>> +			struct nvmefc_tgt_fcp_req *tgt_fcpreq)
>> +{
>> +	...
>> +
>> +	return 0;
> if this function returns an 'int', why would it always return 0 and not
> the fcp_err values (if there is an error)?

I'll look at it. The reason it's carried in the tgt_fcpreq is that a 
real LLDD would likely return from the fcp_op, and report an error later 
on. I'll see if things should be reorg'd.


>
>> +struct nvme_fc_port_template fctemplate = {
>> +	.create_queue	= fcloop_create_queue,
>> +	.delete_queue	= fcloop_delete_queue,
>> +	.ls_req		= fcloop_ls_req,
>> +	.fcp_io		= fcloop_fcp_req,
>> +	.ls_abort	= fcloop_ls_abort,
>> +	.fcp_abort	= fcloop_fcp_abort,
>> +
>> +	.max_hw_queues	= 1,
>> +	.max_sgl_segments = 256,
>> +	.max_dif_sgl_segments = 256,
>> +	.dma_boundary = 0xFFFFFFFF,
> Between here and "struct nvmet_fc_target_template tgttemplate" they are
> assigning the same magic values to the same variable names, so why not
> have these values as #defines for a tad easier maintainability?

sure.


>
>> +static ssize_t
>> +fcloop_create_local_port(struct device *dev, struct device_attribute
>> *attr,
>> +		const char *buf, size_t count)
>> +{
>> +	struct nvme_fc_port_info pinfo;
>> +	struct fcloop_ctrl_options *opts;
>> +	struct nvme_fc_local_port *localport;
>> +	struct fcloop_lport *lport;
>> +	int ret;
>> +
>> +	opts = kzalloc(sizeof(*opts), GFP_KERNEL);
>> +	if (!opts)
>> +		return -ENOMEM;
>> +
>> +	ret = fcloop_parse_options(opts, buf);
>> +	if (ret)
>> +		goto out_free_opts;
>> +
>> +	/* everything there ? */
>> +	if ((opts->mask & LPORT_OPTS) != LPORT_OPTS) {
>> +		ret = -EINVAL;
>> +		goto out_free_opts;
>> +	}
>> +
>> +	pinfo.fabric_name = opts->fabric;
>> +	pinfo.node_name = opts->wwnn;
>> +	pinfo.port_name = opts->wwpn;
>> +	pinfo.port_role = opts->roles;
>> +	pinfo.port_id = opts->fcaddr;
>> +
>> +	ret = nvme_fc_register_localport(&pinfo, &fctemplate, NULL,
>> &localport);
>> +	if (!ret) {
>> +		/* success */
>> +		lport = localport->private;
>> +		lport->localport = localport;
>> +		INIT_LIST_HEAD(&lport->list);
>> +		INIT_LIST_HEAD(&lport->rport_list);
>> +		list_add_tail(&lport->list, &fcloop_lports);
>> +
>> +		/* mark all of the input buffer consumed */
>> +		ret = count;
>> +	}
>> +
>> +out_free_opts:
>> +	kfree(opts);
>> +	return ret;
>> +}
>> +
>> +static int __delete_local_port(struct fcloop_lport *lport)
>> +{
>> +	int ret;
>> +
>> +	if (!list_empty(&lport->rport_list))
>> +		return -EBUSY;
>> +
>> +	list_del(&lport->list);
>> +
> Is a mutex or locking mechanism not needed here for this list?

Yeah - could probably use. As it was mainly a test tool with a 
controlled sequence, I think I ignored it.

-- james


