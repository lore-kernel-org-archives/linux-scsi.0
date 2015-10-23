From: "Matthew R. Ochs" <mrochs@linux.vnet.ibm.com>
Subject: Re: [PATCH 1/2] scsi: lpfc: Use kzalloc instead of kmalloc
Date: Fri, 23 Oct 2015 18:26:21 -0500
Message-ID: <C55884B0-E8D4-4EE2-AB46-40A871F8A073@linux.vnet.ibm.com>
References: <1445630633-14209-1-git-send-email-punitvara@gmail.com> <1445630633-14209-2-git-send-email-punitvara@gmail.com>
Mime-Version: 1.0 (Mac OS X Mail 8.2 \(2104\))
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e38.co.us.ibm.com ([32.97.110.159]:55809 "EHLO
	e38.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751850AbbJWX00 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 23 Oct 2015 19:26:26 -0400
Received: from localhost
	by e38.co.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-scsi@vger.kernel.org> from <mrochs@linux.vnet.ibm.com>;
	Fri, 23 Oct 2015 17:26:25 -0600
In-Reply-To: <1445630633-14209-2-git-send-email-punitvara@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Punit Vara <punitvara@gmail.com>
Cc: JBottomley@odin.com, don.brace@pmcs.com, storagedev@pmcs.com, iss_storagedev@hp.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org

Hi Punit,

Aren't you missing the removal of the memset() as part of this conversion?


-matt

> On Oct 23, 2015, at 3:03 PM, Punit Vara <punitvara@gmail.com> wrote:
> 
> This patch is to the lpfc_els.c which resolves following warning
> reported by coccicheck:
> 
> WARNING: kzalloc should be used for rdp_context, instead of
> kmalloc/memset
> 
> Signed-off-by: Punit Vara <punitvara@gmail.com>
> ---
> drivers/scsi/lpfc/lpfc_els.c | 2 +-
> 1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/scsi/lpfc/lpfc_els.c b/drivers/scsi/lpfc/lpfc_els.c
> index 36bf58b..422c800 100644
> --- a/drivers/scsi/lpfc/lpfc_els.c
> +++ b/drivers/scsi/lpfc/lpfc_els.c
> @@ -4990,7 +4990,7 @@ lpfc_els_rcv_rdp(struct lpfc_vport *vport, struct lpfc_iocbq *cmdiocb,
> 	if (RDP_NPORT_ID_SIZE !=
> 			be32_to_cpu(rdp_req->nport_id_desc.length))
> 		goto rjt_logerr;
> -	rdp_context = kmalloc(sizeof(struct lpfc_rdp_context), GFP_KERNEL);
> +	rdp_context = kzalloc(sizeof(struct lpfc_rdp_context), GFP_KERNEL);
> 	if (!rdp_context) {
> 		rjt_err = LSRJT_UNABLE_TPC;
> 		goto error;

