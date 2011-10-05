From: Vikas Chaudhary <vikas.chaudhary@qlogic.com>
Subject: Re: [PATCH v2 resend] qla4xxx: use pci_dev->revision
Date: Wed, 5 Oct 2011 11:13:44 -0700
Message-ID: <CAB1EBA3.9A3F%vikas.chaudhary@qlogic.com>
References: <201110051901.54549.sshtylyov@ru.mvista.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from va3ehsobe006.messaging.microsoft.com ([216.32.180.16]:19971
	"EHLO VA3EHSOBE007.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S932812Ab1JESN5 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 5 Oct 2011 14:13:57 -0400
In-Reply-To: <201110051901.54549.sshtylyov@ru.mvista.com>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Sergei Shtylyov <sshtylyov@ru.mvista.com>, scsi <linux-scsi@vger.kernel.org>
Cc: "James.Bottomley@suse.de" <James.Bottomley@suse.de>, Ravi Anand <ravi.anand@qlogic.com>, Dept_iscsi_driver <iscsi-driver@qlogic.com>, "akpm@linux-foundation.org" <akpm@linux-foundation.org>



On 05/10/11 8:01 AM, "Sergei Shtylyov" <sshtylyov@ru.mvista.com> wrote:

>Commit f4f5df23bf72208d0c2f1d8be629839924c2f4c2 ([SCSI] qla4xxx: Added
>support
>for ISP82XX) added code to read the PCI revision ID from the PCI
>configuration
>register while it's already stored by PCI subsystem in the 'revision'
>field of
>'struct pci_dev'...
>
>Signed-off-by: Sergei Shtylyov <sshtylyov@ru.mvista.com>
>
>---
>The patch is against the recent Linus' tree.
>It wasn't merged in either 2.6.39, 3.0 or 3.1 time, hopefully it can be
>merged
>to 3.2...
>
>Andrew, the SCSI maintainer seems to ignore this patch, maybe you can
>queue it?
>
> drivers/scsi/qla4xxx/ql4_os.c |    6 ++----
> 1 file changed, 2 insertions(+), 4 deletions(-)
>
>Index: linux-2.6/drivers/scsi/qla4xxx/ql4_os.c
>===================================================================
>--- linux-2.6.orig/drivers/scsi/qla4xxx/ql4_os.c
>+++ linux-2.6/drivers/scsi/qla4xxx/ql4_os.c
>@@ -1430,7 +1430,6 @@ static void qla4xxx_free_adapter(struct
> int qla4_8xxx_iospace_config(struct scsi_qla_host *ha)
> {
>       int status = 0;
>-      uint8_t revision_id;
>       unsigned long mem_base, mem_len, db_base, db_len;
>       struct pci_dev *pdev = ha->pdev;
>
>@@ -1442,10 +1441,9 @@ int qla4_8xxx_iospace_config(struct scsi
>               goto iospace_error_exit;
>       }
>
>-      pci_read_config_byte(pdev, PCI_REVISION_ID, &revision_id);
>       DEBUG2(printk(KERN_INFO "%s: revision-id=%d\n",
>-          __func__, revision_id));
>-      ha->revision_id = revision_id;
>+          __func__, pdev->revision));
>+      ha->revision_id = pdev->revision;
>
>       /* remap phys address */
>       mem_base = pci_resource_start(pdev, 0); /* 0 is for BAR 0 */
>

Acked-by: Vikas Chaudhary <vikas.chaudhary@qlogic.com>


This message and any attached documents contain information from QLogic Corporation or its wholly-owned subsidiaries that may be confidential. If you are not the intended recipient, you may not read, copy, distribute, or use this information. If you have received this transmission in error, please notify the sender immediately by reply e-mail and then delete this message.

