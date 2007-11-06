From: Matthew Wilcox <matthew@wil.cx>
Subject: Re: [PATCH] SCSI: Use is_power_of_2() macro for simplicity.
Date: Tue, 6 Nov 2007 08:30:13 -0700
Message-ID: <20071106153012.GG4113@parisc-linux.org>
References: <Pine.LNX.4.64.0711061019450.9041@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from palinux.external.hp.com ([192.25.206.14]:35723 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752433AbXKFPaO (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 6 Nov 2007 10:30:14 -0500
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0711061019450.9041@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Robert P. J. Day" <rpjday@crashcourse.ca>
Cc: linux-scsi@vger.kernel.org

On Tue, Nov 06, 2007 at 10:20:46AM -0500, Robert P. J. Day wrote:
> @@ -1656,7 +1657,7 @@ static inline int reconnect_target(struct NCR_ESP *esp, struct ESP_regs *eregs)
>  	if(!(it & me))
>  		return -1;
>  	it &= ~me;
> -	if(it & (it - 1))
> +	if(!is_power_of_2(it))
>  		return -1;

Non-equivalent transform.  Probably a bug.

>  		bits &= ~esp->scsi_id_mask;
> -		if (!bits || (bits & (bits - 1)))
> +		if (!is_power_of_2(bits))
>  			goto do_reset;

Non-equivalent transform.  Definitely a bug.

>  		iscsi_set_param(cls_conn, param, buf, buflen);
> -		if (session->max_r2t & (session->max_r2t - 1))
> +		if (!is_power_of_2(session->max_r2t))
>  			session->max_r2t = roundup_pow_of_two(session->max_r2t);

Non-equivalent transform.  Not sure if it's a bug or not.

> 
> -	if (cmds_max < 2 || (cmds_max & (cmds_max - 1)) ||
> +	if (cmds_max < 2 || !is_power_of_2(cmds_max) ||
>  	    cmds_max >= ISCSI_MGMT_ITT_OFFSET) {

This one's OK.

-- 
Intel are signing my paycheques ... these opinions are still mine
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
