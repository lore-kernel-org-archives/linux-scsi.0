From: Mike Christie <michaelc@cs.wisc.edu>
Subject: Re: [PATCH 10/11] qla4xxx: Added ping support
Date: Mon, 05 Mar 2012 20:49:37 -0600
Message-ID: <4F557B41.5010703@cs.wisc.edu>
References: <1329138050-1042-1-git-send-email-vikas.chaudhary@qlogic.com> <1329138050-1042-11-git-send-email-vikas.chaudhary@qlogic.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:43846 "EHLO sabe.cs.wisc.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030241Ab2CFCtr (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 5 Mar 2012 21:49:47 -0500
In-Reply-To: <1329138050-1042-11-git-send-email-vikas.chaudhary@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: vikas.chaudhary@qlogic.com
Cc: jbottomley@parallels.com, linux-scsi@vger.kernel.org, ravi.anand@qlogic.com, lalit.chandivade@qlogic.com

On 02/13/2012 07:00 AM, vikas.chaudhary@qlogic.com wrote:
> +
> +		if (mbox_sts_entry->out_mbox[0] == MBOX_STS_COMMAND_COMPLETE)
> +			status = QLA_SUCCESS;
> +		else
> +			status = QLA_ERROR;
> +
> +		data_size = sizeof(mbox_sts_entry->out_mbox);
> +
> +		qla4xxx_post_ping_evt_work(ha, status, mrb->pid, data_size,
> +					(uint8_t *) mbox_sts_entry->out_mbox);
> +		break;
> +

Not sure what I was thinking. This is not going to work.

We are not going to pass back vendor specific values, and then have
multiple decoders in userspace.

What are you trying to pass back up to userspace? Can you add a enum or
defines for some common error values? We can also pass back vendor
specific info, but we have to also have some common error cls info or it
is completely useless to other apps.

And, can we get more info that if it failed or not?
