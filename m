From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH] fusion: streamline ->slave_alloc/->slave_destroy
Date: Tue, 26 Oct 2004 14:55:28 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20041026125528.GA25050@lst.de>
References: <0E3FA95632D6D047BA649F95DAB60E5705262988@exa-atlanta>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.210]:3042 "EHLO mail.lst.de")
	by vger.kernel.org with ESMTP id S262249AbUJZMzf (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 26 Oct 2004 08:55:35 -0400
Content-Disposition: inline
In-Reply-To: <0E3FA95632D6D047BA649F95DAB60E5705262988@exa-atlanta>
List-Id: linux-scsi@vger.kernel.org
To: "Moore, Eric Dean" <Emoore@lsil.com>
Cc: Christoph Hellwig <hch@lst.de>, linux-scsi@vger.kernel.org

> The problem is mptscsih_slave_destroy is being called twice. The first
> time we free hd->Targets, the second time we hit the oops.  I'm still
> investigating. Here is back trace using source level debugger.   Also
> beyond the back trace is snip of source, having the embedded printks.

That was not just with my patch but with your new monster update, right?

It contains this totally bogus line:

+                       
+                       /* remove the device from our internal data structures */
+                       if(hd->Targets[pScsiReq->TargetID] != NULL) {
+                               mptscsih_slave_destroy(sc->device);
+                       }
+                   

in mptscsih_io_done

