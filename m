From: Sagi Grimberg <sagig@dev.mellanox.co.il>
Subject: Re: [PATCH 02/14] block: Replace bi_integrity with bi_special
Date: Thu, 03 Jul 2014 12:19:24 +0300
Message-ID: <53B5201C.9000601@dev.mellanox.co.il>
References: <1401334128-15499-1-git-send-email-martin.petersen@oracle.com>	<1401334128-15499-3-git-send-email-martin.petersen@oracle.com>	<20140611163257.GB28815@infradead.org> <yq1vbs7q8tw.fsf@sermon.lab.mkp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-wg0-f48.google.com ([74.125.82.48]:49092 "EHLO
	mail-wg0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752960AbaGCJTd (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 3 Jul 2014 05:19:33 -0400
Received: by mail-wg0-f48.google.com with SMTP id n12so12363443wgh.31
        for <linux-scsi@vger.kernel.org>; Thu, 03 Jul 2014 02:19:32 -0700 (PDT)
In-Reply-To: <yq1vbs7q8tw.fsf@sermon.lab.mkp.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>, Christoph Hellwig <hch@infradead.org>
Cc: axboe@fb.com, nab@daterainc.com, linux-scsi@vger.kernel.org

On 6/12/2014 3:18 AM, Martin K. Petersen wrote:
>>>>>> "Christoph" == Christoph Hellwig <hch@infradead.org> writes:
> Christoph> Instead of having a union of pointer just make it a void
> Christoph> pointer. I also think special is a terribly generic name, but
> Christoph> I don't really have a better idea at hand.
>
> I needed something that could encompass additional information to be
> passed for integrity, copy offload and discard requests.
>
> Another option is that we forgo the union name:
>
>          union {
> #if defined(CONFIG_BLK_DEV_INTEGRITY)
>                  struct bio_integrity_payload *bi_integrity;
> #endif
>                  struct bio_copy *bi_copy;
>          };
>
> That's the way Jens has done it in struct request. I think I like that
> better and it doesn't send the same up-for-grabs signal that a void
> pointer might.
>
> Jens: Any preference?
>

A nameless union makes more sense to me here.

Sagi.
