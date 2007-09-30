From: Muli Ben-Yehuda <muli@il.ibm.com>
Subject: Re: [PATCH] aic94xx: fix SMP request DMA direction
Date: Sun, 30 Sep 2007 09:26:52 +0200
Message-ID: <20070930072652.GG4239@rhun.haifa.ibm.com>
References: <20070928023341.GA10750@havoc.gtf.org> <20070928235534.GC22855@tree.beaverton.ibm.com> <20070929062215.GD4239@rhun.haifa.ibm.com> <46FDEFDD.8070401@garzik.org> <20070930071355.GC21125@tree.beaverton.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mtagate1.de.ibm.com ([195.212.29.150]:16392 "EHLO
	mtagate1.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752408AbXI3H04 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 30 Sep 2007 03:26:56 -0400
Received: from d12nrmr1607.megacenter.de.ibm.com (d12nrmr1607.megacenter.de.ibm.com [9.149.167.49])
	by mtagate1.de.ibm.com (8.13.8/8.13.8) with ESMTP id l8U7QsYJ693248
	for <linux-scsi@vger.kernel.org>; Sun, 30 Sep 2007 07:26:54 GMT
Received: from d12av03.megacenter.de.ibm.com (d12av03.megacenter.de.ibm.com [9.149.165.213])
	by d12nrmr1607.megacenter.de.ibm.com (8.13.8/8.13.8/NCO v8.5) with ESMTP id l8U7Qs042347150
	for <linux-scsi@vger.kernel.org>; Sun, 30 Sep 2007 09:26:54 +0200
Received: from d12av03.megacenter.de.ibm.com (loopback [127.0.0.1])
	by d12av03.megacenter.de.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id l8U7QsRA012759
	for <linux-scsi@vger.kernel.org>; Sun, 30 Sep 2007 09:26:54 +0200
Content-Disposition: inline
In-Reply-To: <20070930071355.GC21125@tree.beaverton.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Darrick J. Wong" <djwong@us.ibm.com>
Cc: Jeff Garzik <jeff@garzik.org>, linux-scsi@vger.kernel.org

On Sun, Sep 30, 2007 at 12:13:55AM -0700, Darrick J. Wong wrote:

> Actually, SMP commands are used during device discovery to find
> things attached to expanders, so it seems likely that "it blows up
> almost immediately after loading the module" symptoms are a result
> of this bug.
> 
> That said, the bug that Jeff fixed resulted in extra permissions
> (+w) being set for the SMP request buffer, so that's probably why
> I've never seen any problems manifesting on x260/x3800 systems.
> 
> (Unless the CalIOC2 has a write only mode?)

It does (you can turn on each of the R and W bits in the TCE entry
seperately) but we don't make use of it - we set it to either none, RO
or RW.

Cheers,
Muli
