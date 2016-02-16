From: jiangyiwen <jiangyiwen@huawei.com>
Subject: Re: [PATCH] block/sd: Return -EREMOTEIO when WRITE SAME and DISCARD
 are disabled
Date: Tue, 16 Feb 2016 20:14:13 +0800
Message-ID: <56C31295.2020309@huawei.com>
References: <20160204042528.GA15599@redhat.com>
 <1454568483-11298-1-git-send-email-martin.petersen@oracle.com>
 <56B316EA.9090803@huawei.com> <yq14mdnhmry.fsf@sermon.lab.mkp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from szxga01-in.huawei.com ([58.251.152.64]:50957 "EHLO
	szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755174AbcBPMO3 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 16 Feb 2016 07:14:29 -0500
In-Reply-To: <yq14mdnhmry.fsf@sermon.lab.mkp.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org, linux-block@vger.kernel.org, snitzer@redhat.com, James Bottomley <james.bottomley@hansenpartnership.com>

On 2016/2/5 11:13, Martin K. Petersen wrote:
>>>>>> "Yiwen" == jiangyiwen  <jiangyiwen@huawei.com> writes:
> 
> Yiwen,
> 
> Yiwen> First, I don't understand why blk_peek_request() return
> Yiwen> EREMOTEIO, as I know, in this situation we only prepare scsi
> Yiwen> command without sending to device, and I think EREMOTEIO should
> Yiwen> be returned only when IO has already sent to device, maybe I
> Yiwen> don't understand definition of EREMOTEIO.  So, Why don't return
> Yiwen> the errno with EOPNOTSUPP?
> 
> DM currently has special handling for EREMOTEIO failures (because that's
> what we'd return when a device responds with ILLEGAL REQUEST).
> 
> I am not opposed to returning EOPNOTSUPP but it would require more
> changes and since this is a bugfix for stable I want to keep it as small
> as possible.
> 
> Yiwen> In addition, I still worried with whether there has other
> Yiwen> situations which will return EIO or other error. In this way,
> Yiwen> MD/DM still can happen this type of problem, so I think may be in
> Yiwen> multipath we still needs a protection to avoid it.
> 
> There are various error scenarios where we can end up bailing with a
> BLKPREP_KILL. But the general rule of thumb is that these conditions all
> demand a retry. The optional commands like WRITE SAME and UNMAP are
> special in that they are irrecoverable.
> 
> Yiwen> At last, I have a additional problem, I remember that you
> Yiwen> previously send a series of patches about XCOPY, why don't have
> Yiwen> any news latter later? I very much expect that I can see these
> Yiwen> patches which are merged into kernel.
> 
> I am working on a refresh of the series that includes token-based copy
> offload support in addition to EXTENDED COPY. The patches depend on Mike
> Christie's request flag patch series which has yet to be merged.
> 
Hi Martin,
I tested this code, but found a problem.

When called scsi_prep_fn return BLKPREP_INVALID, we should
use the same code with BLKPREP_KILL in scsi_prep_return. This
patch should add a line of code as follows:

---
 drivers/scsi/scsi_lib.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index dd8ad2a..d8d2198 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -1343,6 +1343,7 @@ scsi_prep_return(struct request_queue *q, struct request *req, int ret)

 	switch (ret) {
 	case BLKPREP_KILL:
+	case BLKPREP_INVALID:
 		req->errors = DID_NO_CONNECT << 16;
 		/* release the command and kill it */
 		if (req->special) {
-- 
1.8.4.3

Thanks,
Yiwen Jiang.

