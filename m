From: Brian King <brking@linux.vnet.ibm.com>
Subject: [PATCH] ipr: Fix sync scsi scan
Date: Mon, 8 Aug 2016 17:53:12 -0500
Message-ID: <11d0860f-b8dd-61a4-ac32-3ce6da208d74@linux.vnet.ibm.com>
References: <1470439261.2337.63.camel@HansenPartnership.com>
 <87popjshn6.fsf@concordia.ellerman.id.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <87popjshn6.fsf@concordia.ellerman.id.au>
Sender: linux-kernel-owner@vger.kernel.org
To: Michael Ellerman <mpe@ellerman.id.au>, James Bottomley <James.Bottomley@HansenPartnership.com>, Andrew Morton <akpm@linux-foundation.org>, Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>, "Martin K. Petersen" <martin.petersen@oracle.com>, "aneesh.kumar@linux.vnet.ibm.com" <aneesh.kumar@linux.vnet.ibm.com>
List-Id: linux-scsi@vger.kernel.org

On 08/08/2016 05:02 AM, Michael Ellerman wrote:
> James Bottomley <James.Bottomley@HansenPartnership.com> writes:
> 
>> This is seven basic fixes (plus one MAINTAINERS update) which came in
>> close to the merge window.
>>
>> The patch is available here:
>>
>> git://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi.git scsi-misc
>>
>> The short changelog is:
>>
>> Brian King (1):
>>       ipr: Wait to do async scan until scsi host is initialized
> 
> This commit seems to be causing a ~10 minute pause during boot on my
> powerpc boxes which have an IPR, eg:

Sorry about that. I fixed up async scan and managed to break sync scan...

This patch fixes it on my box. Does it fix the issue for you as well?

Thanks,

Brian

-- 
Brian King
Power Linux I/O
IBM Linux Technology Center

8<

Commit b195d5e2bffd3de3f07e8683e6abddf099ea0822 fixed async scan
for ipr, but broke sync scan for ipr. This fixes sync scan back up.

Signed-off-by: Brian King <brking@linux.vnet.ibm.com>
---

 drivers/scsi/ipr.c |   11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

diff -puN drivers/scsi/ipr.c~ipr_async_scan_fixup_again drivers/scsi/ipr.c
--- linux-2.6.git/drivers/scsi/ipr.c~ipr_async_scan_fixup_again	2016-08-08 17:48:51.637984104 -0500
+++ linux-2.6.git-bjking1/drivers/scsi/ipr.c	2016-08-08 17:48:51.643984056 -0500
@@ -10410,8 +10410,11 @@ static int ipr_probe(struct pci_dev *pde
 		__ipr_remove(pdev);
 		return rc;
 	}
+	spin_lock_irqsave(ioa_cfg->host->host_lock, flags);
+	ioa_cfg->scan_enabled = 1;
+	schedule_work(&ioa_cfg->work_q);
+	spin_unlock_irqrestore(ioa_cfg->host->host_lock, flags);
 
-	scsi_scan_host(ioa_cfg->host);
 	ioa_cfg->iopoll_weight = ioa_cfg->chip_cfg->iopoll_weight;
 
 	if (ioa_cfg->iopoll_weight && ioa_cfg->sis64 && ioa_cfg->nvectors > 1) {
@@ -10421,10 +10424,8 @@ static int ipr_probe(struct pci_dev *pde
 		}
 	}
 
-	spin_lock_irqsave(ioa_cfg->host->host_lock, flags);
-	ioa_cfg->scan_enabled = 1;
-	schedule_work(&ioa_cfg->work_q);
-	spin_unlock_irqrestore(ioa_cfg->host->host_lock, flags);
+	scsi_scan_host(ioa_cfg->host);
+
 	return 0;
 }
 
_
