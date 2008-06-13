From: Matthew Wilcox <matthew@wil.cx>
Subject: Re: [PATCH/RFC] allow userspace to modify scsi command filter on per device basis
Date: Fri, 13 Jun 2008 13:54:48 -0600
Message-ID: <20080613195448.GA30405@parisc-linux.org>
References: <6cf6b73e0806131233i53942756j24a00ba18abebb47@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from palinux.external.hp.com ([192.25.206.14]:53174 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752106AbYFMTzF (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 13 Jun 2008 15:55:05 -0400
Content-Disposition: inline
In-Reply-To: <6cf6b73e0806131233i53942756j24a00ba18abebb47@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Adel Gadllah <adel.gadllah@gmail.com>
Cc: linux-scsi@vger.kernel.org, pjones@redhat.com, Jens Axboe <jens.axboe@oracle.com>

On Fri, Jun 13, 2008 at 09:33:27PM +0200, Adel Gadllah wrote:
> -		if (blk_verify_command(rq->cmd, has_write_perm))
> +		if (blk_cmd_filter_verify_command(bd->cmd_filter, rq->cmd, bd->f_mode))

Could you wrap to 80 columns?

> +static ssize_t rcf_cmds_store(struct blk_scsi_cmd_filter *filter,
> +			      const char *page, size_t count, int rw)
> +{
> +	ssize_t ret = 0;
> +	unsigned long okbits[BLK_SCSI_CMD_PER_LONG], *target_okbits;
> +	int cmd, status, len;
> +	substring_t ss;
> +
> +	memset(&okbits, 0, sizeof (okbits));
> +
> +	for (len = strlen(page); len > 0; len -= 3) {
> +		if (len < 2)
> +			break;
> +		ss.from = (char *) page + ret;
> +		ss.to = (char *) page + ret + 2;
> +		ret+=3;
> +		status = match_hex(&ss, &cmd);
> +		/* either of these cases means invalid input, so do nothing. */
> +		if (status || cmd >= BLK_SCSI_MAX_CMDS)
> +			return -EINVAL;
> +
> +		set_bit(cmd, okbits);

set_bit is atomic.  locked ops can be quite painful on some processors.
Since okbits is local, the atomicity isn't necessary and you can simply
use __set_bit.

> +static void rcf_set_defaults(struct blk_scsi_cmd_filter *filter)
> +{
> +	/* Basic read-only commands */
> +	set_bit(TEST_UNIT_READY, filter->read_ok);

The set_bit vs __set_bit comment also applies here.

> +int blk_register_filter(struct gendisk *disk)
> +{
> +	int ret;
> +	struct blk_scsi_cmd_filter *filter = &disk->cmd_filter;
> +	struct kobject *parent = kobject_get(disk->holder_dir);
> +	
> +	if(!parent) {
> +		return -EBUSY;
> +	}

Normal style would be to write

	if (!parent)
		return -EBUSY;

(though I don't understand why no parent means we're busy)

> +
> +	ret = kobject_init_and_add(&filter->kobj, &rcf_ktype, parent, "%s", "filter");
> +
> +	if (ret < 0)
> +		return ret;
> +
> +	rcf_set_defaults(filter);

Surely we should set the bits before we make the object visible?

> @@ -189,6 +189,7 @@ void add_disk(struct gendisk *disk)
>  			    disk->minors, NULL, exact_match, exact_lock, disk);
>  	register_disk(disk);
>  	blk_register_queue(disk);
> +	blk_register_filter(disk);

We don't need to handle errors here?  Why not?

-- 
Intel are signing my paycheques ... these opinions are still mine
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
