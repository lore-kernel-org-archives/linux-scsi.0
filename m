From: Christoph Hellwig <hch@infradead.org>
Subject: Re: iscsi_trx going into D state
Date: Tue, 4 Oct 2016 04:46:42 -0700
Message-ID: <20161004114642.GA2377@infradead.org>
References: <CAANLjFoj9-qscJOSf2jtKYt2+4cQxMHNJ9q2QTey4wyG5OTSAA@mail.gmail.com>
 <20161004075545.j52mg3a2jckrchlp@linux-x5ow.site>
 <5cfc7eb8-c59d-4b7a-3dee-99e17d72f251@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:59599 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752604AbcJDLqo (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 4 Oct 2016 07:46:44 -0400
Content-Disposition: inline
In-Reply-To: <5cfc7eb8-c59d-4b7a-3dee-99e17d72f251@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: Johannes Thumshirn <jthumshirn@suse.de>, Robert LeBlanc <robert@leblancnet.us>, linux-rdma@vger.kernel.org, linux-scsi@vger.kernel.org

On Tue, Oct 04, 2016 at 11:11:18AM +0200, Hannes Reinecke wrote:
> Hmm. Looking at the code it looks as we might miss some calls to
> 'complete'. Can you try with the attached patch?

That only looks slightly better than the original.  What this really
needs is a waitqueue and and waitevent on sess->ncon.  Although
that will need a bit more refactoring around that code.  There also
are a few more ovbious issues around it, e.g. iscsit_close_connection
needs to use atomic_dec_and_test on sess->nconn instead of having
separate atomic_dec and atomic_read calls, and a lot of the 0 or 1
atomic_ts in this code should be replaced with atomic bitops.

Btw, there also was a fix from Lee in this area that added a missing
wakeup, make sure your tree already has that.
