From: Martin Wilck <mwilck@suse.com>
Subject: Re: [PATCH 09/12] hpsa: separate monitor events from heartbeat
 worker
Date: Fri, 28 Apr 2017 09:06:39 +0200
Message-ID: <1493363199.24450.1.camel@suse.com>
References: <149159483812.15658.615814291766210537.stgit@brunhilda>
         <149159560000.15658.13539404380272805930.stgit@brunhilda>
         <1491913120.4742.13.camel@suse.com>
         <4993A297653ECB4581FA5C3C31323D1951D38015@avsrvexchmbx2.microsemi.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from victor.provo.novell.com ([137.65.250.26]:54556 "EHLO
        prv3-mh.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1030872AbdD1HGx (ORCPT
        <rfc822;groupwise-linux-scsi@vger.kernel.org:0:0>);
        Fri, 28 Apr 2017 03:06:53 -0400
In-Reply-To: <4993A297653ECB4581FA5C3C31323D1951D38015@avsrvexchmbx2.microsemi.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Don Brace <don.brace@microsemi.com>, "joseph.szczypek@hpe.com" <joseph.szczypek@hpe.com>, Gerry Morong <gerry.morong@microsemi.com>, John Hall <John.Hall@microsemi.com>, "jejb@linux.vnet.ibm.com" <jejb@linux.vnet.ibm.com>, Kevin Barnett <kevin.barnett@microsemi.com>, Mahesh Rajashekhara <mahesh.rajashekhara@microsemi.com>, Bader Ali - Saleh <bader.alisaleh@microsemi.com>, "hch@infradead.org" <hch@infradead.org>, Scott Teel <scott.teel@microsemi.com>, Viswas G <viswas.g@microsemi.com>, Justin Lindley <justin.lindley@microsemi.com>, Scott Benesh <scott.benesh@microsemi.com>, "POSWALD@suse.com" <POSWALD@suse.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

On Thu, 2017-04-27 at 21:10 +0000, Don Brace wrote:
> > -
> > The new worker thread duplicates code from hpsa_rescan_ctlr_worker.
> > I
> > find this a bit irritating. Could you maybe use just a single
> > worker,
> > and just check using time stamps whether the "big" heartbeat needs
> > to
> > be performed?
> > 
> > Regards
> > Martin
> > 
> > --
> > Dr. Martin Wilck <mwilck@suse.com>, Tel. +49 (0)911 74053 2107
> > SUSE Linux GmbH, GF: Felix Imendörffer, Jane Smithard, Graham
> > Norton
> > HRB 21284 (AG Nürnberg)
> 
> We thought about that, but we want to separate controller events
> from the rescan worker.
> 
> Both can cause a rescan to occur however for multipath we have
> found that we need to respond faster than the normal scheduled rescan
> interval for path fail-overs.
> 
> Getting controller events only involves reading a register, but
> the rescan worker can obtain an updated LUN list when there
> is a PTRAID device present.
> 
> However, I did refactor the patch to move common code to
> a separate function.
> 
> Would this be more acceptable?

Sounds good, yes. I'd also appreciate if you'd add these additional
comments to the commit message.

Regards
Martin

-- 
Dr. Martin Wilck <mwilck@suse.com>, Tel. +49 (0)911 74053 2107
SUSE Linux GmbH, GF: Felix Imendörffer, Jane Smithard, Graham Norton
HRB 21284 (AG Nürnberg)
