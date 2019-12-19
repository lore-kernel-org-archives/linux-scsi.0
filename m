Return-Path: <SRS0=QEZ7=2J=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 80EDDC43603
	for <linux-scsi@archiver.kernel.org>; Thu, 19 Dec 2019 08:09:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4F71C2465E
	for <linux-scsi@archiver.kernel.org>; Thu, 19 Dec 2019 08:09:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726463AbfLSIJB (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 19 Dec 2019 03:09:01 -0500
Received: from mx2.suse.de ([195.135.220.15]:49994 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726303AbfLSIJB (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 19 Dec 2019 03:09:01 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id A4BD5AC67;
        Thu, 19 Dec 2019 08:08:59 +0000 (UTC)
Date:   Thu, 19 Dec 2019 09:09:42 +0100
From:   Daniel Wagner <dwagner@suse.de>
To:     Bart Van Assche <bvanassche@acm.org>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>,
        linux-scsi@vger.kernel.org, Christoph Hellwig <hch@lst.de>,
        Himanshu Madhani <hmadhani@marvell.com>,
        Quinn Tran <qutran@marvell.com>,
        Martin Wilck <mwilck@suse.com>,
        Roman Bolshakov <r.bolshakov@yadro.com>
Subject: Re: [PATCH] qla2xxx: Fix sparse warnings triggered by the PCI state
 checking code
Message-ID: <20191219080942.goxjgzvexim4nihv@boron>
References: <20191219004412.37639-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191219004412.37639-1-bvanassche@acm.org>
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Wed, Dec 18, 2019 at 04:44:12PM -0800, Bart Van Assche wrote:
> This patch fixes the following sparse warnings:
> 
> drivers/scsi/qla2xxx/qla_mbx.c:120:21: warning: restricted pci_channel_state_t degrades to integer
> drivers/scsi/qla2xxx/qla_mbx.c:120:37: warning: restricted pci_channel_state_t degrades to integer
> 
> This patch does not change any functionality. From include/linux/pci.h:
> 
> enum pci_channel_state {
> 	/* I/O channel is in normal state */
> 	pci_channel_io_normal = (__force pci_channel_state_t) 1,
> 
> 	/* I/O to channel is blocked */
> 	pci_channel_io_frozen = (__force pci_channel_state_t) 2,
> 
> 	/* PCI card is dead */
> 	pci_channel_io_perm_failure = (__force pci_channel_state_t) 3,
> };
> 
> Cc: Himanshu Madhani <hmadhani@marvell.com>
> Cc: Quinn Tran <qutran@marvell.com>
> Cc: Martin Wilck <mwilck@suse.com>
> Cc: Daniel Wagner <dwagner@suse.de>
> Cc: Roman Bolshakov <r.bolshakov@yadro.com>
> Signed-off-by: Bart Van Assche <bvanassche@acm.org>

Reviewed-by: Daniel Wagner <dwagner@suse.de>

> ---
>  drivers/scsi/qla2xxx/qla_mbx.c | 5 ++---
>  drivers/scsi/qla2xxx/qla_mr.c  | 5 ++---
>  2 files changed, 4 insertions(+), 6 deletions(-)
> 
> diff --git a/drivers/scsi/qla2xxx/qla_mbx.c b/drivers/scsi/qla2xxx/qla_mbx.c
> index b7c1108c48e2..935af77e519f 100644
> --- a/drivers/scsi/qla2xxx/qla_mbx.c
> +++ b/drivers/scsi/qla2xxx/qla_mbx.c
> @@ -117,10 +117,9 @@ qla2x00_mailbox_command(scsi_qla_host_t *vha, mbx_cmd_t *mcp)
>  
>  	ql_dbg(ql_dbg_mbx, vha, 0x1000, "Entered %s.\n", __func__);
>  
> -	if (ha->pdev->error_state > pci_channel_io_frozen) {
> +	if (ha->pdev->error_state == pci_channel_io_perm_failure) {
>  		ql_log(ql_log_warn, vha, 0x1001,
> -		    "error_state is greater than pci_channel_io_frozen, "
> -		    "exiting.\n");
> +		    "PCI channel failed permanently, exiting.\n");
>  		return QLA_FUNCTION_TIMEOUT;
>  	}
>  
> diff --git a/drivers/scsi/qla2xxx/qla_mr.c b/drivers/scsi/qla2xxx/qla_mr.c
> index 605b59c76c90..5f7efdb0cce7 100644
> --- a/drivers/scsi/qla2xxx/qla_mr.c
> +++ b/drivers/scsi/qla2xxx/qla_mr.c
> @@ -53,10 +53,9 @@ qlafx00_mailbox_command(scsi_qla_host_t *vha, struct mbx_cmd_32 *mcp)
>  	struct qla_hw_data *ha = vha->hw;
>  	scsi_qla_host_t *base_vha = pci_get_drvdata(ha->pdev);
>  
> -	if (ha->pdev->error_state > pci_channel_io_frozen) {
> +	if (ha->pdev->error_state == pci_channel_io_perm_failure) {
>  		ql_log(ql_log_warn, vha, 0x115c,
> -		    "error_state is greater than pci_channel_io_frozen, "
> -		    "exiting.\n");
> +		    "PCI channel failed permanently, exiting.\n");
>  		return QLA_FUNCTION_TIMEOUT;
>  	}
>  
