From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] 2.6 aacraid: endian cleanup
Date: Mon, 28 Mar 2005 22:59:31 +0100
Message-ID: <20050328215931.GB14148@infradead.org>
References: <1111430484.9918.9.camel@markh1.pdx.osdl.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pentafluge.infradead.org ([213.146.154.40]:9111 "EHLO
	pentafluge.infradead.org") by vger.kernel.org with ESMTP
	id S262090AbVC1V7d (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 28 Mar 2005 16:59:33 -0500
Content-Disposition: inline
In-Reply-To: <1111430484.9918.9.camel@markh1.pdx.osdl.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mark Haverkamp <markh@osdl.org>
Cc: James Bottomley <James.Bottomley@steeleye.com>, linux-scsi <linux-scsi@vger.kernel.org>, Mark Salyzyn <mark_salyzyn@adaptec.com>

On Mon, Mar 21, 2005 at 10:41:23AM -0800, Mark Haverkamp wrote:
> A patch from Adaptec with byte order changes:
>  - drop byte swapping on all 0's and all 1's content
>  - fix up missing swapping directives
>  - ensure swapping on 16 bit values does not use 32 bit swap
>  - reconcile the readl/writel auto-swapping in only most of the
> configurations.

that last bit is bogus.  readl/writel are defined to swap bytes on
big endian systems.  Whatever broken Mvista/Windriver or whatever port
doesn't do that should be fixed.

Also please remove unrelated changes like the new cardtypes from the patch,
follow normal kernel codingstyle (e.g. ||, && at the end of the line) and
switch to __le* types for harware structures and make sure it's passing
sparse -Wbitwise.

