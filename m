Return-Path: <SRS0=2nLx=ZH=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E654CC432C3
	for <linux-scsi@archiver.kernel.org>; Fri, 15 Nov 2019 09:06:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C0EFB20723
	for <linux-scsi@archiver.kernel.org>; Fri, 15 Nov 2019 09:06:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727206AbfKOJGc (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 15 Nov 2019 04:06:32 -0500
Received: from verein.lst.de ([213.95.11.211]:43578 "EHLO verein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725829AbfKOJGc (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 15 Nov 2019 04:06:32 -0500
Received: by verein.lst.de (Postfix, from userid 2407)
        id A931368AFE; Fri, 15 Nov 2019 10:06:28 +0100 (CET)
Date:   Fri, 15 Nov 2019 10:06:28 +0100
From:   Christoph Hellwig <hch@lst.de>
To:     Hannes Reinecke <hare@suse.de>
Cc:     "Martin K. Petersen" <martin.petersen@oracle.com>,
        Christoph Hellwig <hch@lst.de>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        Dave Carroll <david.carroll@microsemi.com>,
        Sagar Biradar <sagar.biradar@microchip.com>,
        linux-scsi@vger.kernel.org
Subject: Re: [PATCH 3/4] aacraid: use blk_mq_rq_busy_iter() for traversing
 outstanding commands
Message-ID: <20191115090628.GC24954@lst.de>
References: <20191115080555.146710-1-hare@suse.de> <20191115080555.146710-4-hare@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191115080555.146710-4-hare@suse.de>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Dave and Sagar have been maintaining aacraid for a while, you should
Cc them.

This patch seems to touch fout entirely different areas in aacraid, it
would probably help to split it up into one patch per area explaining how
the replacement for the cmd list for choosen.

> +struct synchronize_busy_data {
> +	struct scsi_device *sdev;
> +	u64 lba;
> +	u32 count;
> +	int active;
> +};
> +
> +static bool synchronize_busy_iter(struct request *req, void *data, bool reserved)

This adds an overly long line. 

> +{
> +	struct scsi_cmnd *cmd = blk_mq_rq_to_pdu(req);
> +	struct synchronize_busy_data *busy_data = data;
> +
> +	if (busy_data->sdev == cmd->device &&

Given that you itere over just a single scsi device using
blk_mq_queue_tag_busy_iter here would seem like the better API.

> +	    cmd->SCp.phase == AAC_OWNER_FIRMWARE) {

And the function would become more readable if it just exists early
for not firmware owned commands, as that saves one level of indentation
for all the heavy lifting.

> +		u64 cmnd_lba;
> +		u32 cmnd_count;
> +
> +		if (cmd->cmnd[0] == WRITE_6) {
> +			cmnd_lba = ((cmd->cmnd[1] & 0x1F) << 16) |
> +				(cmd->cmnd[2] << 8) |
> +				cmd->cmnd[3];
> +			cmnd_count = cmd->cmnd[4];
> +			if (cmnd_count == 0)
> +				cmnd_count = 256;
> +		} else if (cmd->cmnd[0] == WRITE_16) {

Instead of reverse engineering the lba and commands, why not check
the request for REQ_OP_WRITE and then look at bi_iter.bi_sector
(also for the caller to avoid the Linux sector to LBA conversion).

> +		if (((cmnd_lba + cmnd_count) < busy_data->lba) ||
> +		    (busy_data->count && ((busy_data->lba + busy_data->count) < cmnd_lba)))

Lots of braces not required here, and overy longs lines.

> +			return true;
> +		++busy_data->active;

Normally we do a post-fix increment if no one cares about the
return value.

> +	blk_mq_tagset_busy_iter(&sdev->host->tag_set, synchronize_busy_iter, &busy_data);

Another overly long line.

> +static bool wait_for_io_iter(struct request *rq, void *data, bool reserved)
> +{
> +	struct scsi_cmnd *command = blk_mq_rq_to_pdu(rq);
> +	int *active = data;
> +
> +	if (command->SCp.phase == AAC_OWNER_FIRMWARE)
> +		*active = 1;
> +	return true;
> +}

Without bloc ayer quiescing this use is a bit of a hack.  Can you
add a comment toward that?

> +static bool reset_adapter_iter(struct request *rq, void *data, bool reserved)
> +{
> +	struct scsi_cmnd *command = blk_mq_rq_to_pdu(rq);
> +
> +	if (command->SCp.phase == AAC_OWNER_FIRMWARE) {
> +		command->result = DID_OK << 16
> +		  | COMMAND_COMPLETE << 8
> +		  | SAM_STAT_TASK_SET_FULL;

The | goes onto the previous line.

> +static int get_num_of_incomplete_fibs(struct aac_dev *aac)
> +{
>  	struct Scsi_Host *shost = aac->scsi_host_ptr;
>  	struct device *ctrl_dev;
> +	struct fib_count_data fib_count = {
> +		.mlcnt  = 0,
> +		.llcnt  = 0,
> +		.ehcnt  = 0,
> +		.fwcnt  = 0,
> +		.krlcnt = 0,
> +	};

You can do a:

	struct fib_count_data fib_count = { };

to zero all values.


> +	dev_info(ctrl_dev, "outstanding cmd: error handler-%d\n", fib_count.ehcnt);

This adds an overly long line.

> +	return fib_count.mlcnt + fib_count.llcnt + fib_count.ehcnt + fib_count.fwcnt;

Another one.
