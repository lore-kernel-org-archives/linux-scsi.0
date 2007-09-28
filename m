From: "Moore, Eric" <Eric.Moore@lsi.com>
Subject: RE: Some plans for scsi_cmnd
Date: Fri, 28 Sep 2007 16:15:56 -0600
Message-ID: <664A4EBB07F29743873A87CF62C26D70A0A205@NAMAIL4.ad.lsil.com>
References: <20070925133733.GT10625@parisc-linux.org>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail0.lsil.com ([147.145.40.20]:58547 "EHLO mail0.lsil.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753654AbXI1WQg convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 28 Sep 2007 18:16:36 -0400
Content-class: urn:content-classes:message
In-Reply-To: <20070925133733.GT10625@parisc-linux.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Matthew Wilcox <matthew@wil.cx>, linux-scsi@vger.kernel.org, hch@infradead.org

On Tuesday, September 25, 2007 7:38 AM, Matthew Wilcox wrote: 

> As I said, it's ambitious.  But it'll let us get rid of scsi_pointer
> and host_scribble entirely.
> 


Are you serious about removing the host_scribble?     In fusion we
currently are hanging our per request message frame pointer there.
Its used for two reasons:

(1)  Old fibre channel firmware bug.  The bug is the same message frame
completed twice.  1st completion is okay and the scsi_cmd is reallocated
to some other IO.  Meanwhile the driver receives a double completion of
the same message frame, and the driver attempts to complete the
reallocated scsi_cmd to some other IO.  The sanity check on
host_scribble avoids this.

(2)  error recovery threads decides to complete a scsi_cmd before its
been returned back by the scsi lld, and the scsi_cmd is reused for some
other IO.  Meanwhile fusion firmware finally  decides it wants to
command the command, then the driver is completing the  reallocated
scsi_cmd that is mapped to some other IO.  Again, host_scribble sanity
check makes sure we finish off the scsi_cmd that its intended for.


Thus said, someone upgrades to newer FC firmware, they will not have
issue #1.    

Regarding issue #2, if eh threads allow scsi lld to cleanup ts own scsi
cmds, then we shouldn't need this.


Eric
