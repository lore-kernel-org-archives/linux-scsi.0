From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] [SCSI] sg.c: fixes to sg_build_indirect()
Date: Sat, 4 Nov 2006 20:12:14 +0000
Message-ID: <20061104201214.GA32205@infradead.org>
References: <254019.55389.qm@web31801.mail.mud.yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pentafluge.infradead.org ([213.146.154.40]:19097 "EHLO
	pentafluge.infradead.org") by vger.kernel.org with ESMTP
	id S965614AbWKDUMS (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 4 Nov 2006 15:12:18 -0500
Content-Disposition: inline
In-Reply-To: <254019.55389.qm@web31801.mail.mud.yahoo.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Luben Tuikov <ltuikov@yahoo.com>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, Douglas Gilbert <dougg@torque.net>

On Sat, Nov 04, 2006 at 11:48:42AM -0800, Luben Tuikov wrote:
> The sg driver corrupts memory when the data buffer
> size is 5493376 (0x53d280) bytes.  The reason for this
> is the computation of the left over size given the
> size of scatter-gather array and the size of the
> scatter-gather element.  This patch fixes this.
> 
> Other fixes:
> 1. Eliminate scatter_elem_sz_prev, and use memory
>    barriers to get its current value.  Reset it to PAGE_SIZE
>    if the user has set it to something smaller.

I just stumbled over the scatter_elem_sz / scatter_elem_sz_prev
usage aswell when reasearching something unrelated in sg.
It seems very wrong to me to have unprotectred globals for buffer
size estimations.  If these estimates make sense we should do 
them per open file descriptor to avoid the races and to make sure
they still work properly in cases where multiple I/Os are going on
through sg.

Anyway, your patch looks very good and is an improvement in that area.

