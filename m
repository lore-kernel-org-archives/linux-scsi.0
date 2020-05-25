Return-Path: <SRS0=b1yV=7H=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7656FC433DF
	for <linux-scsi@archiver.kernel.org>; Mon, 25 May 2020 18:04:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 38132207D8
	for <linux-scsi@archiver.kernel.org>; Mon, 25 May 2020 18:04:52 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=yadro.com header.i=@yadro.com header.b="T0ZWSfWP"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389771AbgEYSEw (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 25 May 2020 14:04:52 -0400
Received: from mta-02.yadro.com ([89.207.88.252]:53652 "EHLO mta-01.yadro.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2388621AbgEYSEv (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 25 May 2020 14:04:51 -0400
Received: from localhost (unknown [127.0.0.1])
        by mta-01.yadro.com (Postfix) with ESMTP id 8982B4C83B;
        Mon, 25 May 2020 18:04:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=yadro.com; h=
        in-reply-to:content-disposition:content-type:content-type
        :mime-version:references:message-id:subject:subject:from:from
        :date:date:received:received:received; s=mta-01; t=1590429886;
         x=1592244287; bh=0MPK7U6EchTSXx7IGC4GJwjCPcvLvNQV3oRmGK9pT1Q=; b=
        T0ZWSfWP7jl28PaFOT0b+vohxh0D4JWAg/leGEeawdvEPboi4G+UvbItfs8n8o9N
        biJU3YkBo3WvQoGiLTa+0H4dzkoIMOvo/fbVwaVrQKRqKoLMRawDy1EkxihDEpJJ
        Jq0i4LOmFnFzmDuceqqyDLeSTVRVZA5hHLn1ClA6jyY=
X-Virus-Scanned: amavisd-new at yadro.com
Received: from mta-01.yadro.com ([127.0.0.1])
        by localhost (mta-01.yadro.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id 3WKaihlw6kla; Mon, 25 May 2020 21:04:46 +0300 (MSK)
Received: from T-EXCH-02.corp.yadro.com (t-exch-02.corp.yadro.com [172.17.10.102])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mta-01.yadro.com (Postfix) with ESMTPS id 41A54404CF;
        Mon, 25 May 2020 21:04:45 +0300 (MSK)
Received: from localhost (172.17.204.212) by T-EXCH-02.corp.yadro.com
 (172.17.10.102) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384_P384) id 15.1.669.32; Mon, 25
 May 2020 21:04:46 +0300
Date:   Mon, 25 May 2020 21:04:46 +0300
From:   Roman Bolshakov <r.bolshakov@yadro.com>
To:     Bart Van Assche <bvanassche@acm.org>
CC:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>,
        <linux-scsi@vger.kernel.org>, Arun Easi <aeasi@marvell.com>,
        Nilesh Javali <njavali@marvell.com>,
        Himanshu Madhani <himanshu.madhani@oracle.com>,
        Hannes Reinecke <hare@suse.de>,
        Daniel Wagner <dwagner@suse.de>, Martin Wilck <mwilck@suse.com>
Subject: Re: [PATCH] qla2xxx: Remove an unused function
Message-ID: <20200525180446.GA64430@SPB-NB-133.local>
References: <20200520040738.1017-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20200520040738.1017-1-bvanassche@acm.org>
X-Originating-IP: [172.17.204.212]
X-ClientProxiedBy: T-EXCH-01.corp.yadro.com (172.17.10.101) To
 T-EXCH-02.corp.yadro.com (172.17.10.102)
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Tue, May 19, 2020 at 09:07:38PM -0700, Bart Van Assche wrote:
> This was detected by building the qla2xxx driver with clang. See also
> commit a9083016a531 ("[SCSI] qla2xxx: Add ISP82XX support").
> 
> Cc: Arun Easi <aeasi@marvell.com>
> Cc: Nilesh Javali <njavali@marvell.com>
> Cc: Himanshu Madhani <himanshu.madhani@oracle.com>
> Cc: Hannes Reinecke <hare@suse.de>
> Cc: Daniel Wagner <dwagner@suse.de>
> Cc: Martin Wilck <mwilck@suse.com>
> Cc: Roman Bolshakov <r.bolshakov@yadro.com>
> Signed-off-by: Bart Van Assche <bvanassche@acm.org>
> ---
>  drivers/scsi/qla2xxx/qla_nx.c | 41 -----------------------------------
>  1 file changed, 41 deletions(-)
> 
> diff --git a/drivers/scsi/qla2xxx/qla_nx.c b/drivers/scsi/qla2xxx/qla_nx.c
> index 21f968e4a584..0baf55b7e88f 100644
> --- a/drivers/scsi/qla2xxx/qla_nx.c
> +++ b/drivers/scsi/qla2xxx/qla_nx.c
> @@ -380,47 +380,6 @@ qla82xx_pci_set_crbwindow_2M(struct qla_hw_data *ha, ulong off_in,
>  	*off_out = (off_in & MASK(16)) + CRB_INDIRECT_2M + ha->nx_pcibase;
>  }
>  
> -static inline unsigned long
> -qla82xx_pci_set_crbwindow(struct qla_hw_data *ha, u64 off)
> -{
> -	scsi_qla_host_t *vha = pci_get_drvdata(ha->pdev);
> -	/* See if we are currently pointing to the region we want to use next */
> -	if ((off >= QLA82XX_CRB_PCIX_HOST) && (off < QLA82XX_CRB_DDR_NET)) {
> -		/* No need to change window. PCIX and PCIEregs are in both
> -		 * regs are in both windows.
> -		 */
> -		return off;
> -	}
> -
> -	if ((off >= QLA82XX_CRB_PCIX_HOST) && (off < QLA82XX_CRB_PCIX_HOST2)) {
> -		/* We are in first CRB window */
> -		if (ha->curr_window != 0)
> -			WARN_ON(1);
> -		return off;
> -	}
> -
> -	if ((off > QLA82XX_CRB_PCIX_HOST2) && (off < QLA82XX_CRB_MAX)) {
> -		/* We are in second CRB window */
> -		off = off - QLA82XX_CRB_PCIX_HOST2 + QLA82XX_CRB_PCIX_HOST;
> -
> -		if (ha->curr_window != 1)
> -			return off;
> -
> -		/* We are in the QM or direct access
> -		 * register region - do nothing
> -		 */
> -		if ((off >= QLA82XX_PCI_DIRECT_CRB) &&
> -			(off < QLA82XX_PCI_CAMQM_MAX))
> -			return off;
> -	}
> -	/* strange address given */
> -	ql_dbg(ql_dbg_p3p, vha, 0xb001,
> -	    "%s: Warning: unm_nic_pci_set_crbwindow "
> -	    "called with an unknown address(%llx).\n",
> -	    QLA2XXX_DRIVER_NAME, off);
> -	return off;
> -}
> -
>  static int
>  qla82xx_pci_get_crb_addr_2M(struct qla_hw_data *ha, ulong off_in,
>  			    void __iomem **off_out)

Hi Bart,

Reviewed-by: Roman Bolshakov <r.bolshakov@yadro.com>

Thanks,
Roman
