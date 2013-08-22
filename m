From: Joe Perches <joe@perches.com>
Subject: Re: [PATCH] scsi: fix the build warning
Date: Wed, 21 Aug 2013 18:55:59 -0700
Message-ID: <1377136559.12003.18.camel@joe-AO722>
References: <1377132262-15744-1-git-send-email-zwu.kernel@gmail.com>
	 <1377133329.12003.9.camel@joe-AO722>
	 <CAEH94Lhh11+zFHsRNDXoyxQfndxDRMcVvLnZDXQLw5cyaavUJw@mail.gmail.com>
	 <1377134271.12003.15.camel@joe-AO722> <yq1ppt68qk9.fsf@sermon.lab.mkp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from perches-mx.perches.com ([206.117.179.246]:34326 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752120Ab3HVB4B (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 21 Aug 2013 21:56:01 -0400
In-Reply-To: <yq1ppt68qk9.fsf@sermon.lab.mkp.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Zhi Yong Wu <zwu.kernel@gmail.com>, linux-scsi@vger.kernel.org, James Bottomley <jbottomley@parallels.com>, linux-kernel mlist <linux-kernel@vger.kernel.org>, Zhi Yong Wu <wuzhy@linux.vnet.ibm.com>, akinobu.mita@gmail.com

On Wed, 2013-08-21 at 21:25 -0400, Martin K. Petersen wrote:
> >>>>> "Joe" == Joe Perches <joe@perches.com> writes:
> 
> Joe> I don't get this build warning in the first place and I think the
> Joe> scsi_debug file is quite old and probably doesn't need to be
> Joe> changed at all.
> 
> guard isn't a boolean, it selects the checksum algorithm used.

OK, maybe this then...
---
 drivers/scsi/scsi_debug.c | 2 +-
 1 file changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/scsi/scsi_debug.c b/drivers/scsi/scsi_debug.c
index cb4fefa..6fc2831 100644
--- a/drivers/scsi/scsi_debug.c
+++ b/drivers/scsi/scsi_debug.c
@@ -3312,7 +3312,7 @@ static int __init scsi_debug_init(void)
 		return -EINVAL;
 	}
 
-	if (scsi_debug_guard > 1) {
+	if (scsi_debug_guard < 0 || scsi_debug_guard > 1) {
 		printk(KERN_ERR "scsi_debug_init: guard must be 0 or 1\n");
 		return -EINVAL;
 	}


