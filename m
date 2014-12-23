From: Christoph Hellwig <hch@lst.de>
Subject: Re: block: remove artifical max_hw_sectors cap
Date: Tue, 23 Dec 2014 09:28:05 +0100
Message-ID: <20141223082805.GA2303@lst.de>
References: <5497F319.20802@profihost.ag>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.211]:36988 "EHLO newverein.lst.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755328AbaLWI2J (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 23 Dec 2014 03:28:09 -0500
Content-Disposition: inline
In-Reply-To: <5497F319.20802@profihost.ag>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Stefan Priebe - Profihost AG <s.priebe@profihost.ag>, Nicholas Bellinger <nab@linux-iscsi.org>
Cc: linux-scsi@vger.kernel.org, target-devel@vger.kernel.org

On Mon, Dec 22, 2014 at 11:31:53AM +0100, Stefan Priebe - Profihost AG wrote:
> Hi,
> 
> since the below patch i've some problems with iscsi.
> 
> The LIO based iscsi Server is full of messages like this:
> SCSI OP 2ah with too big sectors 8344 exceeds fabric_max_sectors: 8192
> 
> And the client says:
> Buffer I/O error on device sdd, logical block 38861907
> lost page write due to I/O error on sdd
> 
> May be some code fixes for iscsi client is missing?

No, the problem seems that the the target is enforcing a size limit
without communicating it through the block limits EVPD page.

Nic, can you fix LIO to expose the proper max xfer size?
