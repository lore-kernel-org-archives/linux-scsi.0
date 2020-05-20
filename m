Return-Path: <SRS0=Yj8A=7C=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9CF39C433E0
	for <linux-scsi@archiver.kernel.org>; Wed, 20 May 2020 17:03:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7D40E206B6
	for <linux-scsi@archiver.kernel.org>; Wed, 20 May 2020 17:03:06 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="j3P7r5XP"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727006AbgETRDG (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 20 May 2020 13:03:06 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:54978 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726436AbgETRDF (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 20 May 2020 13:03:05 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 04KH1UBJ075002;
        Wed, 20 May 2020 17:02:53 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=omD5w1gjsNoPoJ7ISZ82/4eV7Ij43yN9848MWmSKydg=;
 b=j3P7r5XPSjWRviOXA5RtdxKBjoErqgLJb8DrWpoKhWD5kEOh7Zm91IEdfL1pqq+WItB+
 XkXUsHURQhL3d/C/FHu5LyDkvPI6qWPr0vimZh2gioRf2/hBrZw0RQH3mAxX3AJRNNcH
 6O9p0VVrp5FWllYaCFNQAhxDgRaZnB9NYasr4veuDIfyHybKsFb/E2U68mmId3LpXjFq
 EaxQt9FTJrlUefbHGIu4Tbpa8gAxikOyxEbwIvf50j4PHgpht3aYFhat/RSepUTzg3xS
 RBOG8URiJ9FZk5ixKtv1I2NtK9Y9s6ol00OSTu/6MVoixRr1ODLrZtsj8QBCryqVCIK8 4g== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2120.oracle.com with ESMTP id 31501rau1g-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Wed, 20 May 2020 17:02:50 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 04KGrPIR062956;
        Wed, 20 May 2020 17:00:50 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3020.oracle.com with ESMTP id 312t385mhk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 20 May 2020 17:00:48 +0000
Received: from abhmp0005.oracle.com (abhmp0005.oracle.com [141.146.116.11])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 04KH0iIG005911;
        Wed, 20 May 2020 17:00:45 GMT
Received: from [10.154.123.42] (/10.154.123.42)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 20 May 2020 10:00:44 -0700
Subject: Re: [PATCH] qla2xxx: Remove an unused function
To:     Bart Van Assche <bvanassche@acm.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>
Cc:     linux-scsi@vger.kernel.org, Arun Easi <aeasi@marvell.com>,
        Nilesh Javali <njavali@marvell.com>,
        Hannes Reinecke <hare@suse.de>,
        Daniel Wagner <dwagner@suse.de>,
        Martin Wilck <mwilck@suse.com>,
        Roman Bolshakov <r.bolshakov@yadro.com>
References: <20200520040738.1017-1-bvanassche@acm.org>
From:   Himanshu Madhani <himanshu.madhani@oracle.com>
Organization: Oracle Corporation
Message-ID: <77aab9a3-f944-bc84-876d-68cb170cdd42@oracle.com>
Date:   Wed, 20 May 2020 12:00:43 -0500
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <20200520040738.1017-1-bvanassche@acm.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9627 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 spamscore=0 mlxlogscore=999
 phishscore=0 mlxscore=0 malwarescore=0 suspectscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2004280000
 definitions=main-2005200136
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9627 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 lowpriorityscore=0 spamscore=0
 mlxlogscore=999 clxscore=1015 priorityscore=1501 cotscore=-2147483648
 impostorscore=0 bulkscore=0 adultscore=0 malwarescore=0 phishscore=0
 mlxscore=0 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2004280000 definitions=main-2005200137
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org



On 5/19/20 11:07 PM, Bart Van Assche wrote:
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
>   drivers/scsi/qla2xxx/qla_nx.c | 41 -----------------------------------
>   1 file changed, 41 deletions(-)
> 
> diff --git a/drivers/scsi/qla2xxx/qla_nx.c b/drivers/scsi/qla2xxx/qla_nx.c
> index 21f968e4a584..0baf55b7e88f 100644
> --- a/drivers/scsi/qla2xxx/qla_nx.c
> +++ b/drivers/scsi/qla2xxx/qla_nx.c
> @@ -380,47 +380,6 @@ qla82xx_pci_set_crbwindow_2M(struct qla_hw_data *ha, ulong off_in,
>   	*off_out = (off_in & MASK(16)) + CRB_INDIRECT_2M + ha->nx_pcibase;
>   }
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
>   static int
>   qla82xx_pci_get_crb_addr_2M(struct qla_hw_data *ha, ulong off_in,
>   			    void __iomem **off_out)
> 

Reviewed-by: Himanshu Madhani <himanshu.madhani@oracle.com>

-- 
Himanshu Madhani                     Oracle Linux Engineering
