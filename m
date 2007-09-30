From: "Darrick J. Wong" <djwong@us.ibm.com>
Subject: Re: [PATCH] aic94xx: fix SMP request DMA direction
Date: Sun, 30 Sep 2007 00:13:55 -0700
Message-ID: <20070930071355.GC21125@tree.beaverton.ibm.com>
References: <20070928023341.GA10750@havoc.gtf.org> <20070928235534.GC22855@tree.beaverton.ibm.com> <20070929062215.GD4239@rhun.haifa.ibm.com> <46FDEFDD.8070401@garzik.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e34.co.us.ibm.com ([32.97.110.152]:55359 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753144AbXI3HNZ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 30 Sep 2007 03:13:25 -0400
Received: from d03relay02.boulder.ibm.com (d03relay02.boulder.ibm.com [9.17.195.227])
	by e34.co.us.ibm.com (8.13.8/8.13.8) with ESMTP id l8U7DPBB027052
	for <linux-scsi@vger.kernel.org>; Sun, 30 Sep 2007 03:13:25 -0400
Received: from d03av04.boulder.ibm.com (d03av04.boulder.ibm.com [9.17.195.170])
	by d03relay02.boulder.ibm.com (8.13.8/8.13.8/NCO v8.5) with ESMTP id l8U7DOE0405138
	for <linux-scsi@vger.kernel.org>; Sun, 30 Sep 2007 01:13:25 -0600
Received: from d03av04.boulder.ibm.com (loopback [127.0.0.1])
	by d03av04.boulder.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id l8U7DOoP013850
	for <linux-scsi@vger.kernel.org>; Sun, 30 Sep 2007 01:13:24 -0600
Content-Disposition: inline
In-Reply-To: <46FDEFDD.8070401@garzik.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jeff Garzik <jeff@garzik.org>
Cc: Muli Ben-Yehuda <muli@il.ibm.com>, linux-scsi@vger.kernel.org

On Sat, Sep 29, 2007 at 02:25:33AM -0400, Jeff Garzik wrote:
> Muli Ben-Yehuda wrote:
>> On Fri, Sep 28, 2007 at 04:55:34PM -0700, Darrick J. Wong wrote:
>>> On Thu, Sep 27, 2007 at 10:33:41PM -0400, Jeff Garzik wrote:
>>>> Unless I'm missing something, the SMP request goes /to/ the PCI device 
>>>> :)
>>>>
>>>> Signed-off-by: Jeff Garzik <jeff@garzik.org>
>>> ACK; builds ok and SMP commands seem to work ok (not that they
>>> didn't before).
>> Could this explain some weirdness we were seeing with aic94xx and
>> Calgary/CalIOC2 enabled, or are SMP commands not likely to be used in
>> normal operation? We map the IOMMU entries differently for FROMDEVICE
>> (RW) and TODEVICE(RO).
>
> SMP == scsi management == not used during normal data transfer.
>
> It could certainly explain flakiness if you have expanders, though

Actually, SMP commands are used during device discovery to find things
attached to expanders, so it seems likely that "it blows up almost
immediately after loading the module" symptoms are a result of this bug.

That said, the bug that Jeff fixed resulted in extra permissions (+w)
being set for the SMP request buffer, so that's probably why I've never
seen any problems manifesting on x260/x3800 systems.

(Unless the CalIOC2 has a write only mode?)

--D
