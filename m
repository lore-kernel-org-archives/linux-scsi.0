From: Mark Lord <lkml@rtr.ca>
Subject: Re: [PATCH] drivers/scsi/sd.c: fix uninitialized variable in handling
 medium errors
Date: Wed, 26 Apr 2006 16:52:15 -0400
Message-ID: <444FDD7F.4040407@rtr.ca>
References: <200604261627.29419.lkml@rtr.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from rtr.ca ([64.26.128.89]:40595 "EHLO mail.rtr.ca")
	by vger.kernel.org with ESMTP id S932391AbWDZUwe (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 26 Apr 2006 16:52:34 -0400
In-Reply-To: <200604261627.29419.lkml@rtr.ca>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andrew Morton <akpm@osdl.org>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org

Mark Lord wrote:
>
>When scsi_get_sense_info_fld() fails (returns 0), it does NOT update the
>value of first_err_block.  But sd_rw_intr() merrily continues to use that
>variable regardless, possibly making incorrect decisions about retries and the like.
>
>This patch removes the randomness there, by using the first sector of the
>request (SCpnt->request->sector) in such cases, instead of first_err_block.

Note that this bug has been around for a while, and is also present in 2.6.16.xx.
This same patch applies there too.

Cheers
