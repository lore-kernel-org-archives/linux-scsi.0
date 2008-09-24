From: Boaz Harrosh <bharrosh@panasas.com>
Subject: Re: qlogicpti driver hangs the machine
Date: Wed, 24 Sep 2008 12:00:22 +0300
Message-ID: <48DA01A6.1010807@panasas.com>
References: <20080923.212513.184633012.davem@davemloft.net>	<20080924044211.GL27204@parisc-linux.org>	<20080923.215302.152506074.davem@davemloft.net> <20080924.014553.221132445.davem@davemloft.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from gw-ca.panasas.com ([66.104.249.162]:31075 "EHLO
	laguna.int.panasas.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751532AbYIXJA2 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 24 Sep 2008 05:00:28 -0400
In-Reply-To: <20080924.014553.221132445.davem@davemloft.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: David Miller <davem@davemloft.net>
Cc: matthew@wil.cx, mroos@linux.ee, linux-scsi@vger.kernel.org, sparclinux@vger.kernel.org, Jens Axboe <jens.axboe@oracle.com>

David Miller wrote:
> From: David Miller <davem@davemloft.net>
> Date: Tue, 23 Sep 2008 21:53:02 -0700 (PDT)
> 
>> I'm about to stick a qlogicpti card into my ultra2 and try to reproduce
>> this.
> 
> Unfortunately, the driver works just fine for me, in fact it's
> checking the root filesystem right now :-)
> 
> Meelis, if Matthew isn't able to give you some debugging patches or
> other stuff to try, I'll try to get this fixed when I get back from
> the netfilter workshop in Paris in 2 weeks.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

Subject: [PATCH] fix fall out of sg-chaining patch

I've reviewed all patches since Matthew's, and I find one small
problem.

In the load_cmd() there is a compound loop where the first 4 sg's are
set then the rest are set into a memory structure in group of 7 sg's.

Well the second 7-group and on is a bug because sg pointer does not advance.
This is a fall out from Jens's patch.

I'm not sure if this is it but it should be fixed
---
git diff --stat -p
 drivers/scsi/qlogicpti.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/scsi/qlogicpti.c b/drivers/scsi/qlogicpti.c
index 4a1cf63..9053508 100644
--- a/drivers/scsi/qlogicpti.c
+++ b/drivers/scsi/qlogicpti.c
@@ -914,6 +914,7 @@ static inline int load_cmd(struct scsi_cmnd *Cmnd, struct Command_Entry *cmd,
 				ds[i].d_count = sg_dma_len(s);
 			}
 			sg_count -= n;
+			sg = s;
 		}
 	} else {
 		cmd->dataseg[0].d_base = 0;
