From: Tom Yan <tom.ty89@gmail.com>
Subject: Re: [RFC 3/3] libata-scsi: add optimal transfer length to block
 limits VPD
Date: Fri, 15 Jul 2016 02:13:56 +0800
Message-ID: <CAGnHSEm40pLyvy=kU4yVEmQ_t7dQtv2+vXg5VDvrkP_ExFfgaw@mail.gmail.com>
References: <1c10437e3cd9be8556e77462b40ad53be542dfba.1468384890.git.tom.ty89@gmail.com>
 <5659242e8546753768944757fc86988f1986585c.1468384890.git.tom.ty89@gmail.com> <20160713170426.GG4065@mtj.duckdns.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-qk0-f182.google.com ([209.85.220.182]:36441 "EHLO
	mail-qk0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751098AbcGNSN6 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 14 Jul 2016 14:13:58 -0400
In-Reply-To: <20160713170426.GG4065@mtj.duckdns.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Tejun Heo <tj@kernel.org>
Cc: martin.petersen@oracle.com, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org, linux-block@vger.kernel.org

Well it's mainly to "pre-de-couple" BLK_DEF_MAX_SECTORS from ATA
drives. If we left the field unset, the scsi disk driver will fall
back to BLK_DEF_MAX_SECTORS when setting the block limit "max_sectors"
(while its cap "max_hw_sectors" is set by libata depending on whether
the drive supports LBA48 or so). So by filling in this field, we can
set an optimal value for the ATA drives specifically, while the block
layer devs will have less to concern when they determine the value of
the macro (which should be hardware-neutural, sort of).

A "side-effect" of this is, the scsi disk driver will also use this
field to set the block limit "io_opt", which we had left it unset all
the time. I am not sure about if there are any pros and cons in
setting the limit, that's why I sent this as an RFC and to the
linux-block mailing list as well. By looking at what the scsi disk
driver do, it appears that it's a sensible thing to set the limit to a
value that matches with the other limit "max_sectors", though.

On 14 July 2016 at 01:04, Tejun Heo <tj@kernel.org> wrote:
> On Wed, Jul 13, 2016 at 12:47:08PM +0800, tom.ty89@gmail.com wrote:
>> From: Tom Yan <tom.ty89@gmail.com>
>>
>> As of commit 6b7e9cde4969 ("sd: Fix rw_max for devices that report
>> an optimal xfer size"), the scsi disk driver (correctly) derive both
>> of the queue limits "io_opt" and "max_sectors" from the optimal
>> transfer length field.
>>
>> In case we would like the two limits to be derived from a value
>> other than BLK_DEF_MAX_SECTORS for ATA disks in the future, this
>> patch has made it easy.
>
> What's the actual impact of this patch at this point?
>
> Thanks.
>
> --
> tejun
