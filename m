From: Tom Yan <tom.ty89@gmail.com>
Subject: Re: [RFC] sd: dynamically adjust SD_MAX_WS16_BLOCKS as per the actual
 logical block size
Date: Fri, 12 Aug 2016 12:52:57 +0800
Message-ID: <CAGnHSEk1UG1CaX+2zv20ONxnM7XavGvW9kX2KSPy7R7ZoKL_pA@mail.gmail.com>
References: <b7f44789e0e68fa57d2e3cd059ac3a5bc6d53495.1470954520.git.tom.ty89@gmail.com>
 <yq1bn0yptqq.fsf@sermon.lab.mkp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-qt0-f169.google.com ([209.85.216.169]:36091 "EHLO
	mail-qt0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750989AbcHLEw7 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 12 Aug 2016 00:52:59 -0400
In-Reply-To: <yq1bn0yptqq.fsf@sermon.lab.mkp.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Shaun Tancheff <shaun@tancheff.com>, linux-scsi@vger.kernel.org, linux-block@vger.kernel.org, Shaun Tancheff <shaun.tancheff@seagate.com>

On 12 August 2016 at 11:10, Martin K. Petersen
<martin.petersen@oracle.com> wrote:
>
> However, the CDB transfer length limit is really not the main issue
> here, it's bi_size that we need to enforce.
>
> After contemplating a bit I think it would be cleanest to add
> BLK_MAX_BIO_SECTORS and clamp on that in blk_queue_max_foobar() like we
> do with some of the other queue limits. Move the enforcement to block
> where the actual limit originates rather than code around it in sd.

I don't really follow. What would this BLK_MAX_BIO_SECTORS be? It
doesn't appear to me that a static value is going to address the
problem I am addressing in this patch.

>
> Also, please use ilog2() instead of division for things like this.
>
> --
> Martin K. Petersen      Oracle Linux Engineering
