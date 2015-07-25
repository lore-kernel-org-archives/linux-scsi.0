From: "Matthew R. Ochs" <mrochs@linux.vnet.ibm.com>
Subject: Re: [PATCH v2 3/3] cxlflash: Virtual LUN support
Date: Sat, 25 Jul 2015 15:31:40 -0500
Message-ID: <5B9D6DCF-AFE4-419F-B7A8-7BFA4819C8FA@linux.vnet.ibm.com>
References: <1437089217-52200-1-git-send-email-mrochs@linux.vnet.ibm.com> <55B29CE1.4030708@linux.vnet.ibm.com>
Mime-Version: 1.0 (Apple Message framework v1085)
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e18.ny.us.ibm.com ([129.33.205.208]:34338 "EHLO
	e18.ny.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964824AbbGYUbr convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 25 Jul 2015 16:31:47 -0400
Received: from /spool/local
	by e18.ny.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-scsi@vger.kernel.org> from <mrochs@linux.vnet.ibm.com>;
	Sat, 25 Jul 2015 16:31:47 -0400
Received: from b01cxnp23032.gho.pok.ibm.com (b01cxnp23032.gho.pok.ibm.com [9.57.198.27])
	by d01dlp03.pok.ibm.com (Postfix) with ESMTP id A4DB3C90045
	for <linux-scsi@vger.kernel.org>; Sat, 25 Jul 2015 16:22:49 -0400 (EDT)
Received: from d01av04.pok.ibm.com (d01av04.pok.ibm.com [9.56.224.64])
	by b01cxnp23032.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id t6PKVhpa57212988
	for <linux-scsi@vger.kernel.org>; Sat, 25 Jul 2015 20:31:43 GMT
Received: from d01av04.pok.ibm.com (localhost [127.0.0.1])
	by d01av04.pok.ibm.com (8.14.4/8.14.4/NCO v10.0 AVout) with ESMTP id t6PKVft6006035
	for <linux-scsi@vger.kernel.org>; Sat, 25 Jul 2015 16:31:43 -0400
In-Reply-To: <55B29CE1.4030708@linux.vnet.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Brian King <brking@linux.vnet.ibm.com>
Cc: linux-scsi@vger.kernel.org, James.Bottomley@HansenPartnership.com, nab@linux-iscsi.org, hch@infradead.org, mikey@neuling.org, imunsie@au1.ibm.com, dja@ozlabs.au.ibm.com, "Manoj N. Kumar" <manoj@linux.vnet.ibm.com>

Hi Brian,

Thanks for reviewing. Comments inline below.


-matt

On Jul 24, 2015, at 3:15 PM, Brian King wrote:

> On 07/16/2015 06:26 PM, Matthew R. Ochs wrote:
>> +
>> +/**
>> + * ba_clone() - frees a block from the block allocator
>> + * @ba_lun:	Block allocator from which to allocate a block.
>> + * @to_free:	Block to free.
>> + *
>> + * Return: 0 on success, -1 on failure
>> + */
>> +static int ba_clone(struct ba_lun *ba_lun, u64 to_clone)
>> +{
>> +	struct ba_lun_info *lun_info =
>> +	    (struct ba_lun_info *)ba_lun->ba_lun_handle;
>> +
>> +	if (validate_alloc(lun_info, to_clone)) {
>> +		pr_err("%s: AUN %llX is not allocated on lun_id %llX\n",
>> +		       __func__, to_clone, ba_lun->lun_id);
> 
> Suggest using dev_err here instead to scope the error to the adapter.

Sure, we plan on transitioning to dev_* prints where it make sense. This routine
in particular will likely not be transitioned, but we can add a dev print in the
outer caller to track the device.

> 
>> +		return -1;
> 
> Might be nice to return a better error to the user in both of the error cases
> in this code.

We can look at doing this although in this particular case I'm not sure it would
help things much from a user perspective. These failures are more indicative
of an internal driver bug and not one a user would be all that interested in.

>> +
>> +	rc = ba_init(&blka->ba_lun);
>> +	if (rc) {
>> +		pr_err("%s: cannot init block_alloc, rc=%d\n", __func__, rc);
>> +		goto init_ba_exit;
> 
> The goto here is unnecessary

We'll remove it.

>> +
>> +		result = scsi_execute(sdev, scsi_cmd, DMA_TO_DEVICE, cmd_buf,
>> +				      CMD_BUFSIZE, sense_buf,
>> +				      (MC_DISCOVERY_TIMEOUT*HZ), 5, 0, NULL);
> 
> 5 seconds seems a little on the short side for this command. Perhaps using
> sdev->request_queue->rq_timeout would be better?

Sure, we'll look into using the rq_timeout value.

> 
>> +
>> +		if (result) {
>> +			pr_err("%s: command failed for offset %lld"
>> +			      " result=0x%x\n", __func__, offset, result);
>> +			rc = -EIO;
>> +			goto out;
>> +		}
>> +	}
>> +
>> +out:
> 
> You need to free cmd_buf and sense_buf here.

Good catch. We just fixed this yesterday.

>> +	nsectors = (resize->req_size * CXLFLASH_BLOCK_SIZE) / gli->blk_len;
>> +	new_size = (nsectors + MC_CHUNK_SIZE - 1) / MC_CHUNK_SIZE;
> 
> Use DIV_ROUND_UP instead.

Will do.

>> +		lli->lun_index = cfg->promote_lun_index;
>> +		writeq_be(lli->lun_id[0],
>> +			  &afu->afu_map->global.fc_port[0]
>> +			  [cfg->promote_lun_index]);
> 
> Would improve readability IMHO if you either put the second parm all on one
> line or used a local variable to make it better fit on one line, rather than
> line breaking where you did.

I agree. We've been doing this to other places in the driver as well for
the same reason. Will look at fixing this one too as part of v3.

> 
>> +		writeq_be(lli->lun_id[1],
>> +			  &afu->afu_map->global.fc_port[1]
>> +			  [cfg->promote_lun_index]);
>> +		cfg->promote_lun_index++;
>> +		pr_debug("%s: Virtual LUN on slot %d  id0=%llx, id1=%llx\n",
>> +			 __func__, lli->lun_index, lli->lun_id[0],
>> +			 lli->lun_id[1]);
> 
> Suggest changing the pr_debug calls to dev_dbg calls where possible to scope
> the messages to an adapter.

Same response as earlier. We'll look at refactoring all of the pr_*'s to dev_*'s where
possible and makes sense.

