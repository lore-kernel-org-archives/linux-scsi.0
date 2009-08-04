From: Christof Schmitt <christof.schmitt@de.ibm.com>
Subject: Re: FCP target reset
Date: Tue, 4 Aug 2009 10:46:38 +0200
Message-ID: <20090804084637.GA3835@schmichrtp.de.ibm.com>
References: <20090803162302.GA9872@schmichrtp.de.ibm.com> <4A774AC8.8080805@emulex.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mtagate1.uk.ibm.com ([194.196.100.161]:33428 "EHLO
	mtagate1.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754994AbZHDIqi (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 4 Aug 2009 04:46:38 -0400
Received: from d06nrmr1806.portsmouth.uk.ibm.com (d06nrmr1806.portsmouth.uk.ibm.com [9.149.39.193])
	by mtagate1.uk.ibm.com (8.13.1/8.13.1) with ESMTP id n748kcPq006153
	for <linux-scsi@vger.kernel.org>; Tue, 4 Aug 2009 08:46:38 GMT
Received: from d06av03.portsmouth.uk.ibm.com (d06av03.portsmouth.uk.ibm.com [9.149.37.213])
	by d06nrmr1806.portsmouth.uk.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id n748kcnZ1839252
	for <linux-scsi@vger.kernel.org>; Tue, 4 Aug 2009 09:46:38 +0100
Received: from d06av03.portsmouth.uk.ibm.com (loopback [127.0.0.1])
	by d06av03.portsmouth.uk.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id n748kcdk032119
	for <linux-scsi@vger.kernel.org>; Tue, 4 Aug 2009 09:46:38 +0100
Content-Disposition: inline
In-Reply-To: <4A774AC8.8080805@emulex.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Smart <James.Smart@Emulex.Com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

On Mon, Aug 03, 2009 at 04:38:32PM -0400, James Smart wrote:
> Just because a newer rev of the spec doesn't do something does not mean 
> that all the targets/environments stopped using it...  Target Reset was a 
> mandatory item for FCP-2 compliance, which is what most of the stuff in 
> the field is at.   So, I recommend that the header be updated with the 
> older definition - It can be flagged any way you desire (/* Deprecated as 
> of FCP-3 */).
>
> As for use in LLD's - there's nothing else (TMF-wise) that works at the 
> I_T nexus level to map to the shost eh_target_reset_handler.  Thus, I'd 
> continue to use it for the entrypoint. You can always choose to not 
> implement the entry point, but my recommendation is to support it if 
> possible. It's much better than having to resort to a "bus" or "adapter" 
> reset after a lun reset fails.

I agree that it makes sense to keep this. My question resulted partly
from the confusion about the removal of this function in recent specs.
Here is a patch to add the target reset flag to the FCP header file to
use it in zfcp (and other SCSI FC drivers).

Christof
---
SCSI: Add target reset flag to FCP header file

From: Christof Schmitt <christof.schmitt@de.ibm.com>

While the target reset task management function has been deprecated in
newer specs, it is still in use by SCSI FC drivers and there is no real
replacement. Add the target reset flag to the FCP header file to allow
use of this definition in SCSI FC drivers.

Signed-off-by: Christof Schmitt <christof.schmitt@de.ibm.com>
---
 include/scsi/fc/fc_fcp.h |    2 ++
 1 file changed, 2 insertions(+)

--- a/include/scsi/fc/fc_fcp.h	2009-03-24 13:50:59.000000000 +0100
+++ b/include/scsi/fc/fc_fcp.h	2009-08-04 10:28:50.000000000 +0200
@@ -84,6 +84,8 @@ struct fcp_cmnd32 {
  */
 #define	FCP_TMF_CLR_ACA		0x40	/* clear ACA condition */
 #define	FCP_TMF_LUN_RESET	0x10	/* logical unit reset task management */
+#define	FCP_TMF_TGT_RESET	0x20	/* target reset task management,
+					   deprecated as of FCP-3 */
 #define	FCP_TMF_CLR_TASK_SET	0x04	/* clear task set */
 #define	FCP_TMF_ABT_TASK_SET	0x02	/* abort task set */
 
