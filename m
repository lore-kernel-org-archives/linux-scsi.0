From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: [RFC-v2 11/12] iscsi-target: Add misc utility and debug logic
Date: Tue, 15 Mar 2011 15:59:56 -0700
Message-ID: <1300229996.28255.322.camel@haakon2.linux-iscsi.org>
References: <1300103829-10337-1-git-send-email-nab@linux-iscsi.org>
	 <1300103829-10337-12-git-send-email-nab@linux-iscsi.org>
	 <20110315102720.GC24496@lst.de>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.linux-iscsi.org ([67.23.28.174]:39387 "EHLO
	linux-iscsi.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751366Ab1COXHA (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 15 Mar 2011 19:07:00 -0400
In-Reply-To: <20110315102720.GC24496@lst.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>, James Bottomley <James.Bottomley@HansenPartnership.com>, Mike Christie <michaelc@cs.wisc.edu>, Hannes Reinecke <hare@suse.de>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, Boaz Harrosh <bharrosh@panasas.com>, Stephen Rothwell <sfr@canb.auug.org.au>, Douglas Gilbert <dgilbert@interlog.com>

On Tue, 2011-03-15 at 11:27 +0100, Christoph Hellwig wrote:
> On Mon, Mar 14, 2011 at 04:57:08AM -0700, Nicholas A. Bellinger wrote:
> > +++ b/drivers/target/iscsi/iscsi_debug.h
> > @@ -0,0 +1,113 @@
> > +#ifndef ISCSI_DEBUG_H
> > +#define ISCSI_DEBUG_H
> > +
> > +/*
> > + * Debugging Support
> > + */
> > +
> > +#define TRACE_DEBUG	0x00000001	/* Verbose debugging */
> > +#define TRACE_SCSI	0x00000002	/* Stuff related to SCSI Mid-layer */
> 
> Please use trace events for this kind of debugging.
> 

<nod>, will have a closer look at Documentation/trace/events.txt

> > +	spin_lock_bh(&conn->cmd_lock);
> > +	list_add_tail(&cmd->i_list, &conn->conn_cmd_list);
> > +	spin_unlock_bh(&conn->cmd_lock);
> > +
> > +	atomic_inc(&conn->active_cmds);
> 
> Seems like this counter is always maintained together with the list,
> so it should be a non-atomic type under cmd_lock.
> 

This counter (was) purely information and unused beyond the atomic_inc()
+ atomic_dec().  Removing now..

--nab

