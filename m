Return-Path: <SRS0=Tsb4=6F=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6F54BC54FCC
	for <linux-scsi@archiver.kernel.org>; Tue, 21 Apr 2020 21:18:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4A1352072D
	for <linux-scsi@archiver.kernel.org>; Tue, 21 Apr 2020 21:18:54 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="v5VenSxZ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726323AbgDUVSy (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 21 Apr 2020 17:18:54 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:58338 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725987AbgDUVSx (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 21 Apr 2020 17:18:53 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 03LLIeBH143205;
        Tue, 21 Apr 2020 21:18:41 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=tJBvFRE2/R/Rwq6HgvgWpmlqNch16MwaFKj33UGs4Iw=;
 b=v5VenSxZqD57jGwWYlMBmU8kxpbG9bOB4SUHKVO25TQWWOqQh/8JLg7g2BWi1/YresGi
 0SE0vNYQNYOwMXddN9ggNewnelByjzLWWu8/zxRJnBelp8SnP6m6nLwn9KhhpoK67UiD
 lkCTp/yiPY2DFFfDdE/pTGCdkoDa7frnLKecI6RzXk1IvUKjIlrWnzbuGxxBMMe1RNE7
 vcw/ccsei3D0bZGiUDwJZQaokLWcWVI1hP+omL8b/PHwUQp/80EwVUMEuWPw1x56500G
 yWSZ1pDEQzNs3/Mku3FXx36oDYprNHIhTiQ3iGRLjZRTDy77ZtxZDmWcqXnYy1R7f+Qr 4A== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2130.oracle.com with ESMTP id 30grpgku4g-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 21 Apr 2020 21:18:41 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 03LLHpjb172381;
        Tue, 21 Apr 2020 21:18:30 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3030.oracle.com with ESMTP id 30gb3su7p8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 21 Apr 2020 21:18:30 +0000
Received: from abhmp0006.oracle.com (abhmp0006.oracle.com [141.146.116.12])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 03LLITaO032730;
        Tue, 21 Apr 2020 21:18:29 GMT
Received: from [10.154.114.8] (/10.154.114.8)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 21 Apr 2020 14:18:28 -0700
Subject: Re: [PATCH v4 1/2] scsi: qla2xxx: set UNLOADING before waiting for
 session deletion
To:     mwilck@suse.com, "Martin K. Petersen" <martin.petersen@oracle.com>,
        Arun Easi <aeasi@marvell.com>, Quinn Tran <qutran@marvell.com>
Cc:     Roman Bolshakov <r.bolshakov@yadro.com>,
        Daniel Wagner <dwagner@suse.de>,
        Bart Van Assche <Bart.VanAssche@sandisk.com>,
        James Bottomley <jejb@linux.vnet.ibm.com>,
        linux-scsi@vger.kernel.org
References: <20200421204621.19228-1-mwilck@suse.com>
 <20200421204621.19228-2-mwilck@suse.com>
From:   himanshu.madhani@oracle.com
Organization: Oracle Corporation
Message-ID: <b2a549fd-1e88-d150-4dc6-83a0ff89689e@oracle.com>
Date:   Tue, 21 Apr 2020 16:18:27 -0500
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <20200421204621.19228-2-mwilck@suse.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9598 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 spamscore=0 adultscore=0
 mlxlogscore=999 phishscore=0 suspectscore=2 bulkscore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2003020000
 definitions=main-2004210154
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9598 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 mlxscore=0
 lowpriorityscore=0 adultscore=0 suspectscore=2 bulkscore=0 clxscore=1011
 malwarescore=0 phishscore=0 spamscore=0 priorityscore=1501 impostorscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2003020000
 definitions=main-2004210154
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org



On 4/21/20 3:46 PM, mwilck@suse.com wrote:
> From: Martin Wilck <mwilck@suse.com>
> 
> The purpose of the UNLOADING flag is to avoid port login procedures
> to continue when a controller is in the process of shutting down.
> It makes sense to set this flag before starting session teardown.
> 
> Furthermore, use atomic test_and_set_bit() to avoid the shutdown
> being run multiple times in parallel. In qla2x00_disable_board_on_pci_error(),
> the test for UNLOADING is postponed until after the check for an already
> disabled PCI board.
> 
> Fixes: 45235022da99 ("scsi: qla2xxx: Fix driver unload by shutting down chip")
> Reviewed-by: Arun Easi <aeasi@marvell.com>
> Reviewed-by: Daniel Wagner <dwagner@suse.de>
> Reviewed-by: Roman Bolshakov <r.bolshakov@yadro.com>
> Signed-off-by: Martin Wilck <mwilck@suse.com>
> ---
>   drivers/scsi/qla2xxx/qla_os.c | 32 ++++++++++++++------------------
>   1 file changed, 14 insertions(+), 18 deletions(-)
> 
> diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
> index d9072ea..ce0dabb 100644
> --- a/drivers/scsi/qla2xxx/qla_os.c
> +++ b/drivers/scsi/qla2xxx/qla_os.c
> @@ -3732,6 +3732,13 @@ qla2x00_remove_one(struct pci_dev *pdev)
>   	}
>   	qla2x00_wait_for_hba_ready(base_vha);
>   
> +	/*
> +	 * if UNLOADING flag is already set, then continue unload,
> +	 * where it was set first.
> +	 */
> +	if (test_and_set_bit(UNLOADING, &base_vha->dpc_flags))
> +		return;
> +
>   	if (IS_QLA25XX(ha) || IS_QLA2031(ha) || IS_QLA27XX(ha) ||
>   	    IS_QLA28XX(ha)) {
>   		if (ha->flags.fw_started)
> @@ -3750,15 +3757,6 @@ qla2x00_remove_one(struct pci_dev *pdev)
>   
>   	qla2x00_wait_for_sess_deletion(base_vha);
>   
> -	/*
> -	 * if UNLOAD flag is already set, then continue unload,
> -	 * where it was set first.
> -	 */
> -	if (test_bit(UNLOADING, &base_vha->dpc_flags))
> -		return;
> -
> -	set_bit(UNLOADING, &base_vha->dpc_flags);
> -
>   	qla_nvme_delete(base_vha);
>   
>   	dma_free_coherent(&ha->pdev->dev,
> @@ -6628,13 +6626,6 @@ qla2x00_disable_board_on_pci_error(struct work_struct *work)
>   	struct pci_dev *pdev = ha->pdev;
>   	scsi_qla_host_t *base_vha = pci_get_drvdata(ha->pdev);
>   
> -	/*
> -	 * if UNLOAD flag is already set, then continue unload,
> -	 * where it was set first.
> -	 */
> -	if (test_bit(UNLOADING, &base_vha->dpc_flags))
> -		return;
> -
>   	ql_log(ql_log_warn, base_vha, 0x015b,
>   	    "Disabling adapter.\n");
>   
> @@ -6645,9 +6636,14 @@ qla2x00_disable_board_on_pci_error(struct work_struct *work)
>   		return;
>   	}
>   
> -	qla2x00_wait_for_sess_deletion(base_vha);
> +	/*
> +	 * if UNLOADING flag is already set, then continue unload,
> +	 * where it was set first.
> +	 */
> +	if (test_and_set_bit(UNLOADING, &base_vha->dpc_flags))
> +		return;
>   
> -	set_bit(UNLOADING, &base_vha->dpc_flags);
> +	qla2x00_wait_for_sess_deletion(base_vha);
>   
>   	qla2x00_delete_all_vps(ha, base_vha);
>   
> 

Reviewed-by: Himanshu Madhani <himanshu.madhani@oracle.com>

-- 
Himanshu Madhani
Oracle Linux Engineering
