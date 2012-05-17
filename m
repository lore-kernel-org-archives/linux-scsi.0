From: "Jun'ichi Nomura" <j-nomura@ce.jp.nec.com>
Subject: Re: multipath_busy() stalls IO due to scsi_host_is_busy()
Date: Thu, 17 May 2012 18:09:57 +0900
Message-ID: <4FB4C065.7070804@ce.jp.nec.com>
References: <4FB39D78.9020300@itwm.fraunhofer.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from TYO202.gate.nec.co.jp ([202.32.8.206]:34612 "EHLO
	tyo202.gate.nec.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761385Ab2EQJLR (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 17 May 2012 05:11:17 -0400
In-Reply-To: <4FB39D78.9020300@itwm.fraunhofer.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bernd Schubert <bernd.schubert@itwm.fraunhofer.de>
Cc: dm-devel@redhat.com, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

Hi,

On 05/16/12 21:28, Bernd Schubert wrote:
> Looking through the call chain, I see the underlying problem seems to be in scsi_host_is_busy().
> 
>> static inline int scsi_host_is_busy(struct Scsi_Host *shost)
>> {
>>     if ((shost->can_queue > 0 && shost->host_busy >= shost->can_queue) ||
>>         shost->host_blocked || shost->host_self_blocked)
>>         return 1;
>>
>>     return 0;
>> }

multipath_busy() was introduced because, without that,
a request would be prematurely sent down to SCSI,
lose the chance of additional merges and result in
bad performance.

However, when it is target/host that is busy, I think dm should
send the request down and let SCSI, which has better knowledge
about the shared resource, do appropriate starvation control.

Could you try the attached patch?

---
Jun'ichi Nomura, NEC Corporation

If sdev is not busy but starget and/or host is busy,
it is better to accept a request from stacking driver.
Otherwise, the stacking device could be starved by other device
sharing the same target/host.

diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index 5dfd749..0eb4602 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -1378,16 +1378,13 @@ static int scsi_lld_busy(struct request_queue *q)
 {
 	struct scsi_device *sdev = q->queuedata;
 	struct Scsi_Host *shost;
-	struct scsi_target *starget;
 
 	if (!sdev)
 		return 0;
 
 	shost = sdev->host;
-	starget = scsi_target(sdev);
 
-	if (scsi_host_in_recovery(shost) || scsi_host_is_busy(shost) ||
-	    scsi_target_is_busy(starget) || scsi_device_is_busy(sdev))
+	if (scsi_host_in_recovery(shost) || scsi_device_is_busy(sdev)) 
 		return 1;
 
 	return 0;
