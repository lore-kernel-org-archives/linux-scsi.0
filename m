From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 1/2] target: Add transport_handle_cdb_direct
	optimization
Date: Sat, 4 Jun 2011 16:03:08 +0200
Message-ID: <20110604140308.GB13359@lst.de>
References: <1307167290-24832-1-git-send-email-nab@linux-iscsi.org> <1307167290-24832-2-git-send-email-nab@linux-iscsi.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.211]:39247 "EHLO newverein.lst.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756236Ab1FDODJ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 4 Jun 2011 10:03:09 -0400
Content-Disposition: inline
In-Reply-To: <1307167290-24832-2-git-send-email-nab@linux-iscsi.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Cc: Andy Grover <agrover@redhat.com>, Christoph Hellwig <hch@lst.de>, target-devel <target-devel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>

> + */
> +int transport_handle_cdb_direct(
> +	struct se_cmd *cmd)
> +{
> +	if (!cmd->se_lun) {
> +		dump_stack();
> +		printk(KERN_ERR "cmd->se_lun is NULL\n");
> +		return -EINVAL;
> +	}
> +	if (in_interrupt()) {
> +		dump_stack();
> +		printk(KERN_ERR "transport_generic_handle_cdb cannot be called"
> +				" from interrupt context\n");
> +		return -EINVAL;
> +	}
> +
> +	return transport_generic_new_cmd(cmd);

I can't really see any reason to add this helper.  It just adds rather
pointless debug checks for cases that already will blow up "properly" with
the current code.  Let's keep the callchain lean and just leave it out.

