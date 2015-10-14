From: Himanshu Madhani <himanshu.madhani@qlogic.com>
Subject: Re: [PATCH 2/2] qla2xxx: fix rwlock recursion
Date: Wed, 14 Oct 2015 14:07:08 -0700
Message-ID: <22881A44-6E6A-45D7-828F-B0DE6C91476D@qlogic.com>
References: <1444838261-20990-1-git-send-email-himanshu.madhani@qlogic.com> <1444838261-20990-3-git-send-email-himanshu.madhani@qlogic.com> <561E91D4.8030307@sandisk.com>
Mime-Version: 1.0 (Mac OS X Mail 9.0 \(3094\))
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0b-0016ce01.pphosted.com ([67.231.156.153]:52750 "EHLO
	mx0b-0016ce01.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753671AbbJNVHX convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 14 Oct 2015 17:07:23 -0400
In-Reply-To: <561E91D4.8030307@sandisk.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bart Van Assche <bart.vanassche@sandisk.com>
Cc: jbottomley@parallels.com, hch@lst.de, Giridhar Malavali <giridhar.malavali@qlogic.com>, Andrew Vasquez <andrew.vasquez@qlogic.com>, linux-scsi@vger.kernel.org

Hi Bart, 

> On Oct 14, 2015, at 10:33 AM, Bart Van Assche <bart.vanassche@sandisk.com> wrote:
> 
> On 10/14/2015 08:57 AM, Himanshu Madhani wrote:
>> This patch fixes rwlock recursion introduced for ISP82XX by
>> commit 8dfa4b5a ("qla2xxx: Fix sparse annotations")
> 
> Hello Himanshu,
> 
> Would it be possible to test whether the (untested) patch below also fixes the observed rwlock recursion ?
> 
> Thanks,
> 
> Bart.
> 
> 
> 
> [PATCH] qla2xxx: Fix rwlock recursion
> 
> Fixes: 8dfa4b5a9b44 ("qla2xxx: Fix sparse annotation")
> Signed-off-by: Bart Van Assche <bart.vanassche@sandisk.com>
> Reported-by: Himanshu Madhani <himanshu.madhani@qlogic.com>
> Cc: Giridhar Malavali <giridhar.malavali@qlogic.com>
> ---
> drivers/scsi/qla2xxx/qla_nx.c | 3 ++-
> 1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/scsi/qla2xxx/qla_nx.c b/drivers/scsi/qla2xxx/qla_nx.c
> index eb0cc54..b6b4cfd 100644
> --- a/drivers/scsi/qla2xxx/qla_nx.c
> +++ b/drivers/scsi/qla2xxx/qla_nx.c
> @@ -433,7 +433,7 @@ qla82xx_pci_get_crb_addr_2M(struct qla_hw_data *ha, ulong off_in,
> 	if (off_in < QLA82XX_PCI_CRBSPACE)
> 		return -1;
> 
> -	*off_out = (void __iomem *)(off_in - QLA82XX_PCI_CRBSPACE);
> +	off_in -= QLA82XX_PCI_CRBSPACE;
> 
> 	/* Try direct map */
> 	m = &crb_128M_2M_map[CRB_BLK(off_in)].sub_block[CRB_SUBBLK(off_in)];
> @@ -443,6 +443,7 @@ qla82xx_pci_get_crb_addr_2M(struct qla_hw_data *ha, ulong off_in,
> 		return 0;
> 	}
> 	/* Not in direct map, use crb window */
> +	*off_out = (void __iomem *)off_in;
> 	return 1;
> }
> 

This change  also resolved rwlock recursion on the driver load. Will perform some more basic sanity and report if there are issues seen. 

> -- 
> 2.1.4
> 
> 

