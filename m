From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: [PATCH 01/12] libiscsi: Convert to host_lock less w/
	interrupts disabled internally
Date: Mon, 20 Dec 2010 01:30:13 -0800
Message-ID: <1292837413.20840.47.camel@haakon2.linux-iscsi.org>
References: <1292793727-31957-1-git-send-email-nab@linux-iscsi.org>
	 <1292793727-31957-2-git-send-email-nab@linux-iscsi.org>
	 <20101219233835.GJ1263@parisc-linux.org>
	 <1292807703.20840.29.camel@haakon2.linux-iscsi.org>
	 <1292808126.20840.33.camel@haakon2.linux-iscsi.org>
	 <20101220020758.GK1263@parisc-linux.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.linux-iscsi.org ([67.23.28.174]:40441 "EHLO
	linux-iscsi.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755021Ab0LTJgK (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 20 Dec 2010 04:36:10 -0500
In-Reply-To: <20101220020758.GK1263@parisc-linux.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Matthew Wilcox <matthew@wil.cx>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>, James Bottomley <James.Bottomley@suse.de>, Jeff Garzik <jeff@garzik.org>, Christoph Hellwig <hch@lst.de>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, Hannes Reinecke <hare@suse.de>, Mike Christie <michaelc@cs.wisc.edu>, Open iSCSI <open-iscsi@googlegroups.com>

On Sun, 2010-12-19 at 19:07 -0700, Matthew Wilcox wrote:
> On Sun, Dec 19, 2010 at 05:22:06PM -0800, Nicholas A. Bellinger wrote:
> > Actually sorry, Mike Christie did already make a clarification on this
> > subject here:
> > 
> > http://marc.info/?l=linux-scsi&m=129010439421506&w=2
> > 
> > I had originally thought the same that session->lock should be using
> > some flavour of spin_lock_irq*() as well, but apparently this is not the
> > case for libiscsi.
> 
> Right, so it seems.  "the session lock is just locked in softirqs/timers"
> means that it does need to be the _bh() version of spin_lock though.
> 
> I'm actually not sure ... is it safe to use the _bh versions in BH
> context?  I think it is because the preempt count is nested, unlike the
> _irq variants of spinlocks.
> 

Hmmm, fair point.  Merging the following incremental patch to convert
session->lock to use spin_lock_bh() in iscsi_queuecommand() into
lock_less-LLDs-for-38-v3:

commit 744f1c119b3fb0c1a6b3c67a7b490e234d1a7e75
Author: Nicholas Bellinger <nab@linux-iscsi.org>
Date:   Mon Dec 20 09:17:19 2010 +0000

    libiscsi: Convert iscsi_queuecommand to use spin_lock_bh
    
    This patch converts iscsi_queuecommand() code to obtain struct iscsi_session->lock
    using spin_lock_bh() to properly handle bottom-half context operation.
    
    Reported-by: Matthew Wilcox <willy@linux.intel.com>
    Signed-off-by: Nicholas A. Bellinger <nab@linux-iscsi.org>

After a quick audit of iscsi_session->lock usage, and I see that
iscsi_complete_pdu(), iscsi_tmf_timedout(), iscsi_eh_cmd_timed_out(),
iscsi_check_transport_timeouts() are using spin_lock(), and
iscsi_session_failure() and iscsi_conn_failure() are using
spin_lock_irqsave().

Mike and Hannes, would you guys mind commenting on this..?  From what I
can determine these should all be converted to use spin_lock_bh(),
yes..?

--nab


