From: Christoph Hellwig <hch@lst.de>
Subject: Re: [RFC-v2 11/12] iscsi-target: Add misc utility and debug logic
Date: Tue, 15 Mar 2011 11:27:20 +0100
Message-ID: <20110315102720.GC24496@lst.de>
References: <1300103829-10337-1-git-send-email-nab@linux-iscsi.org> <1300103829-10337-12-git-send-email-nab@linux-iscsi.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1300103829-10337-12-git-send-email-nab@linux-iscsi.org>
Sender: linux-kernel-owner@vger.kernel.org
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>, James Bottomley <James.Bottomley@HansenPartnership.com>, Christoph Hellwig <hch@lst.de>, Mike Christie <michaelc@cs.wisc.edu>, Hannes Reinecke <hare@suse.de>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, Boaz Harrosh <bharrosh@panasas.com>, Stephen Rothwell <sfr@canb.auug.org.au>, Douglas Gilbert <dgilbert@interlog.com>
List-Id: linux-scsi@vger.kernel.org

On Mon, Mar 14, 2011 at 04:57:08AM -0700, Nicholas A. Bellinger wrote:
> +++ b/drivers/target/iscsi/iscsi_debug.h
> @@ -0,0 +1,113 @@
> +#ifndef ISCSI_DEBUG_H
> +#define ISCSI_DEBUG_H
> +
> +/*
> + * Debugging Support
> + */
> +
> +#define TRACE_DEBUG	0x00000001	/* Verbose debugging */
> +#define TRACE_SCSI	0x00000002	/* Stuff related to SCSI Mid-layer */

Please use trace events for this kind of debugging.

> +	spin_lock_bh(&conn->cmd_lock);
> +	list_add_tail(&cmd->i_list, &conn->conn_cmd_list);
> +	spin_unlock_bh(&conn->cmd_lock);
> +
> +	atomic_inc(&conn->active_cmds);

Seems like this counter is always maintained together with the list,
so it should be a non-atomic type under cmd_lock.
