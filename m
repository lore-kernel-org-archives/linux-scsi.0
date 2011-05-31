From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 39/42] target: Call transport_new_cmd instead of adding
	to cmd queue
Date: Tue, 31 May 2011 11:48:00 +0200
Message-ID: <20110531094800.GA31240@lst.de>
References: <1306523240-15543-1-git-send-email-agrover@redhat.com> <1306523240-15543-40-git-send-email-agrover@redhat.com> <1306834367.8193.169.camel@haakon2.linux-iscsi.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.211]:38613 "EHLO newverein.lst.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751810Ab1EaJsA (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 31 May 2011 05:48:00 -0400
Content-Disposition: inline
In-Reply-To: <1306834367.8193.169.camel@haakon2.linux-iscsi.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Cc: linux-iscsi-target-dev@googlegroups.com, target-devel <target-devel@vger.kernel.org>, Christoph Hellwig <hch@lst.de>, linux-scsi <linux-scsi@vger.kernel.org>

On Tue, May 31, 2011 at 02:32:47AM -0700, Nicholas A. Bellinger wrote:
> -static void transport_add_cmd_to_queue(
> +static int transport_add_cmd_to_queue(
>         struct se_cmd *cmd,
>         int t_state)
>  {
> @@ -775,6 +776,8 @@ static void transport_add_cmd_to_queue(
> 
>         atomic_inc(&qobj->queue_cnt);
>         wake_up_interruptible(&qobj->thread_wq);
> +
> +       return 0;
>  }
> 
>  static struct se_cmd *
> @@ -1847,9 +1850,14 @@ int transport_generic_handle_cdb(
>                 printk(KERN_ERR "cmd->se_lun is NULL\n");
>                 return -EINVAL;
>         }
> -
> -       transport_add_cmd_to_queue(cmd, TRANSPORT_NEW_CMD);
> -       return 0;
> +       /*
> +        * Assume that target fabrics not presenting an cmd->se_tfo->new_cmd_map
> +        * function pointer (like iscsi-target) want direct execution of
> +        * transport_generic_new_cmd()
> +        */
> +       return (cmd->se_tfo->new_cmd_map) ?
> +               transport_add_cmd_to_queue(cmd, TRANSPORT_NEW_CMD) :
> +               transport_generic_new_cmd(cmd);
>  }

This it too ugly to live, please revert it.

The proper way to do it is to simply mark transport_generic_new_cmd
non-static and call it directly from the iscsi code.

