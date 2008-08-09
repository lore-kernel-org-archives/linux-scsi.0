From: Matthew Wilcox <matthew@wil.cx>
Subject: Re: [PATCH v4] cmdfilter: clean up sysfs interface
Date: Fri, 8 Aug 2008 21:39:36 -0600
Message-ID: <20080809033935.GI8618@parisc-linux.org>
References: <6cf6b73e0808081456g7d50f66dvc98f5b42a6bab65b@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from palinux.external.hp.com ([192.25.206.14]:49131 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753663AbYHIDjx (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 8 Aug 2008 23:39:53 -0400
Content-Disposition: inline
In-Reply-To: <6cf6b73e0808081456g7d50f66dvc98f5b42a6bab65b@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Adel Gadllah <adel.gadllah@gmail.com>
Cc: linux-scsi@vger.kernel.org, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, Jens Axboe <jens.axboe@oracle.com>, viro@zeniv.linux.org.uk, Peter Jones <pjones@redhat.com>, dougg@torque.net, dan.j.williams@intel.com, James.Bottomley@hansenpartnership.com

On Fri, Aug 08, 2008 at 11:56:35PM +0200, Adel Gadllah wrote:
> @@ -84,8 +83,8 @@ static ssize_t rcf_cmds_show(struct
> blk_scsi_cmd_filter *filter, char *page,
> 
>  	for (i = 0; i < BLK_SCSI_MAX_CMDS; i++) {
>  		if (test_bit(i, okbits)) {
> -			sprintf(npage, "%02x", i);
> -			npage += 2;
> +			sprintf(npage, "0x%02x", i);
> +			npage += 4;
>  			if (i < BLK_SCSI_MAX_CMDS - 1)
>  				sprintf(npage++, " ");
>  		}

Why not:

			npage += sprintf(npage, "0x%02x", i);
?  (and before anyone suggests snprintf, we can at most have 256
entries, each consuming 5 bytes.  5 * 256 <3k and no arch has less than
a 4k page size.  so we can't overflow the buffer.)

> @@ -111,32 +110,41 @@ static ssize_t rcf_writecmds_show(struct
> blk_scsi_cmd_filter *filter,
>  static ssize_t rcf_cmds_store(struct blk_scsi_cmd_filter *filter,
>  			      const char *page, size_t count, int rw)
>  {
> -	ssize_t ret = 0;
>  	unsigned long okbits[BLK_SCSI_CMD_PER_LONG], *target_okbits;
> -	int cmd, status, len;
> -	substring_t ss;
> -
> -	memset(&okbits, 0, sizeof(okbits));
> -
> -	for (len = strlen(page); len > 0; len -= 3) {
> -		if (len < 2)
> -			break;
> -		ss.from = (char *) page + ret;
> -		ss.to = (char *) page + ret + 2;
> -		ret += 3;
> -		status = match_hex(&ss, &cmd);
> +	int cmd, set;
> +	char *p, *status;
> +
> +	if (rw == READ) {
> +		memcpy(&okbits, filter->read_ok, sizeof(okbits));
> +		target_okbits = filter->read_ok;
> +	} else {
> +		memcpy(&okbits, filter->write_ok, sizeof(okbits));
> +		target_okbits = filter->write_ok;
> +	}
> +
> +	while ((p = strsep((char **)&page, " ")) != NULL) {
> +		set = 1;
> +
> +		if (p[0] == '-') {
> +			set = 0;
> +			p++;
> +		}
> +
> +		if (p[0] == '+')
> +			p++;
> +
> +		cmd = simple_strtol(p, &status, 16);
> +
>  		/* either of these cases means invalid input, so do nothing. */
> -		if (status || cmd >= BLK_SCSI_MAX_CMDS)
> +		if ((status == p) || cmd >= BLK_SCSI_MAX_CMDS)
>  			return -EINVAL;

Doesn't this accept -+0x20 for example?  Why not:

		set = 1;
		if (p[0] == '+') {
			p++;
		} else if (p[0] == '-') {
			set = 0;
			p++;
		}
		cmd = simple_strtol(p, &status, 16);

> -		__set_bit(cmd, okbits);
> +		if (set)
> +			__set_bit(cmd, okbits);
> +		else
> +			__clear_bit(cmd, okbits);
>  	}
> 
> -	if (rw == READ)
> -		target_okbits = filter->read_ok;
> -	else
> -		target_okbits = filter->write_ok;
> -
>  	memmove(target_okbits, okbits, sizeof(okbits));

target_okbits can't overlap with okbits, so you can use memcpy instead
of memmove here.

>  	return count;
>  }

-- 
Intel are signing my paycheques ... these opinions are still mine
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
