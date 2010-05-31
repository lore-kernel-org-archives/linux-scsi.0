From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: Re: [PATCH 1/2] [tgt]: Add proper CDB passthrough for SG_IO
 backstores
Date: Mon, 31 May 2010 12:32:56 +0900
Message-ID: <20100531123241H.fujita.tomonori@lab.ntt.co.jp>
References: <1274159582-6074-1-git-send-email-nab@linux-iscsi.org>
	<4C023192.9080503@panasas.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sh.osrg.net ([192.16.179.4]:32970 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755715Ab0EaDdZ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 30 May 2010 23:33:25 -0400
In-Reply-To: <4C023192.9080503@panasas.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: bharrosh@panasas.com
Cc: nab@linux-iscsi.org, stgt@vger.kernel.org, linux-scsi@vger.kernel.org, fujita.tomonori@lab.ntt.co.jp, michaelc@cs.wisc.edu, James.Bottomley@suse.de, dgilbert@interlog.com

On Sun, 30 May 2010 12:36:18 +0300
Boaz Harrosh <bharrosh@panasas.com> wrote:

> > @@ -125,7 +141,7 @@ static int bs_sg_cmd_submit(struct scsi_cmd *cmd)
> >  		set_cmd_async(cmd);
> >  	else {
> >  		eprintf("failed to start cmd 0x%p\n", cmd);
> > -		set_cmd_failed(cmd);
> > +		return set_cmd_failed(cmd);
> >  	}
> >  	return 0;
> >  }
> > @@ -238,6 +254,7 @@ static int bs_sg_cmd_done(struct scsi_cmd *cmd)
> >  static struct backingstore_template sg_bst = {
> >  	.bs_name		= "sg",
> >  	.bs_datasize		= 0,
> > +	.bs_passthrough		= 1,
> >  	.bs_open		= bs_sg_open,
> >  	.bs_close		= bs_sg_close,
> >  	.bs_cmd_submit		= bs_sg_cmd_submit,
> 
> And again the Second patch should just fold into this one. And the final disposition will
> just set the .bs_cmd_submit to the proper one.

Hmm, that means this patchset adds new I/O code with sg (or
bsg). That's not passthrough..

I think that passthrough needs to overwrite some of struct
device_type_template and modify target_cmd_queue().
