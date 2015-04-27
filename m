From: Akinobu Mita <akinobu.mita@gmail.com>
Subject: Re: [PATCH v3 4/5] target: Fix sbc_dif_generate() and
 sbc_dif_verify() for WRITE SAME
Date: Mon, 27 Apr 2015 21:58:47 +0900
Message-ID: <CAC5umyjWJ=J1qqbYuM9MsTWsWgtTBf575C4EpiFozBWpeF_2qQ@mail.gmail.com>
References: <1429972410-7146-1-git-send-email-akinobu.mita@gmail.com>
	<1429972410-7146-5-git-send-email-akinobu.mita@gmail.com>
	<553CB591.4040807@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-lb0-f176.google.com ([209.85.217.176]:34622 "EHLO
	mail-lb0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752967AbbD0M6t (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 27 Apr 2015 08:58:49 -0400
In-Reply-To: <553CB591.4040807@dev.mellanox.co.il>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Sagi Grimberg <sagig@dev.mellanox.co.il>
Cc: target-devel@vger.kernel.org, Nicholas Bellinger <nab@linux-iscsi.org>, Sagi Grimberg <sagig@mellanox.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Christoph Hellwig <hch@lst.de>, "James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

2015-04-26 18:53 GMT+09:00 Sagi Grimberg <sagig@dev.mellanox.co.il>:
> On 4/25/2015 5:33 PM, Akinobu Mita wrote:
>>
>> For WRITE SAME, data transfer memory only contains a single block but
>> protection information is required for all blocks that are written by
>> the command.
>>
>> This makes sbc_dif_generate() and sbc_dif_verify() work for WRITE_SAME.
>
>
> This feels a bit like an overshoot...
>
> You only have 1 block, is it really a good idea to calculate
> the CRC over and over for write same? Wouldn't it be better to
> have a really simple sbc_dif_generate_same() that calculates the
> block CRC once and uses it for the entire payload (and watches for
> Type 1 to increment the ref-tag)?

Sounds good.  I'll take the idea.
