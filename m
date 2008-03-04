From: Mike Galbraith <efault@gmx.de>
Subject: Re: [PATCH] block: fix residual byte count handling
Date: Tue, 04 Mar 2008 19:49:15 +0100
Message-ID: <1204656555.6598.4.camel@homer.simson.net>
References: <20080304182228Z.fujita.tomonori@lab.ntt.co.jp>
	 <20080304093536.GH6704@kernel.dk>
	 <1204634238.5997.5.camel@homer.simson.net>
	 <20080304123939.GM6704@kernel.dk>
	 <1204634619.17258.0.camel@homer.simson.net>
	 <1204635515.17258.12.camel@homer.simson.net>
	 <20080304130307.GN6704@kernel.dk>
	 <1204640722.5783.10.camel@homer.simson.net>
	 <20080304181736.GP6704@kernel.dk>
	 <1204655711.19496.10.camel@homer.simson.net>
	 <20080304184534.GR6704@kernel.dk>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:60493 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1765343AbYCDStW (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 4 Mar 2008 13:49:22 -0500
In-Reply-To: <20080304184534.GR6704@kernel.dk>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jens Axboe <jens.axboe@oracle.com>
Cc: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, htejun@gmail.com, tomof@acm.org, James.Bottomley@HansenPartnership.com, akpm@linux-foundation.org, linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org, jgarzik@pobox.com, bzolnier@gmail.com


On Tue, 2008-03-04 at 19:45 +0100, Jens Axboe wrote:

> > It says cc66b4512cae8df4ed1635483210aabf7690ec27... kewpie doll?
> 
> That looks right, then perhaps there's still an issue there :/
> Logs?

Tejuns patchlet (below) fixed it here.

Date:	Wed, 05 Mar 2008 01:42:45 +0900
From:	Tejun Heo <htejun@gmail.com>
To:	FUJITA Tomonori <tomof@acm.org>
CC:	efault@gmx.de, jens.axboe@oracle.com, fujita.tomonori@lab.ntt.co.jp, James.Bottomley@HansenPartnership.com, akpm@linux-foundation.org, linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org, jgarzik@pobox.com, bzolnier@gmail.com
Subject: Re: [PATCH] block: fix residual byte count handling

Tejun Heo wrote:
> Tejun Heo wrote:
>> FUJITA Tomonori wrote:
>>>> Aiee... device going down after timing out on READ_DISC_INFO.  That's
>>>> gruesome.  Can you please try the other patches?
>>> Tejun, I thought that libata needs a fix for sum(sg) != rq->data_len. No?
>> The extra_len you added to qc->nbytes should be it.  The only other
>> place to pay attention is the ATAPI transfer chunk size and your patch
>> seems to get it right.
>>
>>> Now Jens' git tree should work with all the non libata stuff, ide,
>>> firewire, bsg, etc. But I'm not sure about libata.
>> With the second patch, all others should be fine no matter what.  I'll
>> go check libata part again.
> 
> I can reproduce the problem here and it's very weird.  I'll report back
> when I know more.

Okay, I got it.  Heh, it turns out SCSI and/or block layer is not
ready for rq->data_len != sum(sg).  When adjusted command completes,
SCSI midlayer completes the command with rq->data_len for PC commands
which eventually ends up in __end_that_request_first().  As there are
extra sg area left after completing rq->data_len, blk layer says so to
SCSI layer and SCSI layer retries the command only with the appended
area.

The following patch gets the writing going.  I really think it's a
serious mistake to break rq->data_len == sum(sg).  If we break
rq->data_len == requested size, the worst bugs are giving wrong size
when issuing commands to application layer of devices which is
relatively easy to spot and not all that command anyway.  Breaking
rq->data_len == sum(sg), bugs will be in internal mechanics, DMA
engine programming and transport layer.  Oh well...

diff --git a/drivers/scsi/scsi.c b/drivers/scsi/scsi.c
index fecba05..32439ac 100644
--- a/drivers/scsi/scsi.c
+++ b/drivers/scsi/scsi.c
@@ -757,7 +757,7 @@ void scsi_finish_command(struct scsi_cmnd *cmd)
 				"Notifying upper driver of completion "
 				"(result %x)\n", cmd->result));
 
-	good_bytes = scsi_bufflen(cmd);
+	good_bytes = scsi_bufflen(cmd) + cmd->request->data_len;
         if (cmd->request->cmd_type != REQ_TYPE_BLOCK_PC) {
 		drv = scsi_cmd_to_driver(cmd);
 		if (drv->done)




