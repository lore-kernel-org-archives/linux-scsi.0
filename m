From: Christoph Hellwig <hch@lst.de>
Subject: Re: 2.6.6 + Adaptec I2O
Date: Tue, 1 Jun 2004 17:54:14 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040601155414.GA7476@lst.de>
References: <547AF3BD0F3F0B4CBDC379BAC7E4189FAD5115@otce2k03.adaptec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([212.34.189.10]:22217 "EHLO mail.lst.de")
	by vger.kernel.org with ESMTP id S262337AbUFAPyX (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 1 Jun 2004 11:54:23 -0400
Content-Disposition: inline
In-Reply-To: <547AF3BD0F3F0B4CBDC379BAC7E4189FAD5115@otce2k03.adaptec.com>
List-Id: linux-scsi@vger.kernel.org
To: "Salyzyn, Mark" <mark_salyzyn@adaptec.com>
Cc: Christoph Hellwig <hch@lst.de>, Andrew Morton <akpm@osdl.org>, linux-scsi@vger.kernel.org, Leon Toh <tltoh@attglobal.net>

On Tue, Jun 01, 2004 at 11:38:16AM -0400, Salyzyn, Mark wrote:
> *this* DPT_TARGET_BUSY did the bd_claim you indicated would be
> appropriate ... the bus_for_each_dev() call could be dropped though, it
> was simply wishful thinking that we could expand on that idea to get the
> busy check functionality back.

bd_claim/bd_release is paired for a reason.  So you must call bd_claim
before you start your exclusive operation and bd_release afterwards,
your combination just doesn't make sense.

In addition you're calling bd_claim on the inode of the managment
_character_ device.  I honestly can't see how you ever tested this as
it should immediately crash.

