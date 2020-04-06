Return-Path: <SRS0=wQ7u=5W=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.5 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3B176C2BA19
	for <linux-scsi@archiver.kernel.org>; Mon,  6 Apr 2020 14:41:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 04BAB2465E
	for <linux-scsi@archiver.kernel.org>; Mon,  6 Apr 2020 14:41:00 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="I8HX3mSK"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728702AbgDFOk7 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 6 Apr 2020 10:40:59 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:59990 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728699AbgDFOk7 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 6 Apr 2020 10:40:59 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 036EdpXM187560;
        Mon, 6 Apr 2020 14:39:51 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=fvjfAcxSmjfvmMnmTgeQhsmcQElp1Ta9apy7mifMz8o=;
 b=I8HX3mSK4d2k2gG93C7MTbYrLeXBvXtlWpNXkuZ8xH/uBPRsA8YCJKSmz59D1g/NmGoK
 c+C0whbnNCq3CQuJnCssNU3nIT0tAOqn+oWYBPMkH+nt/TxTcyu5sL6WD7q4zM5DmHNl
 9f8ISxhroLj+qDj8g7k+dGhC+FVPIYk6UNfcsNssrIRqmam2AMmOL/UOhYiPovnpAoL8
 vaEa1YRmCaqxcLL/Tvwpx7REslrwnX67rrpPbSi9JWrmXKcdgbbxY3ZY3Uu231mUjrWk
 8opNwD2jez4gu6iUDsRHzQeliUcjVjzVtYsKEBbVQEwH5V3jyakvIZKPJjakYKpbC4zt 7w== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2130.oracle.com with ESMTP id 306hnqy97w-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 06 Apr 2020 14:39:51 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 036Ecjdi054425;
        Mon, 6 Apr 2020 14:39:48 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3030.oracle.com with ESMTP id 3073sq23ta-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 06 Apr 2020 14:39:48 +0000
Received: from abhmp0002.oracle.com (abhmp0002.oracle.com [141.146.116.8])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 036Edk0q025386;
        Mon, 6 Apr 2020 14:39:46 GMT
Received: from [192.168.1.24] (/70.114.128.235)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 06 Apr 2020 07:39:46 -0700
Subject: Re: [PATCH] qla2xxx: Split qla2x00_configure_local_loop()
To:     Bart Van Assche <bvanassche@acm.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>
Cc:     linux-scsi@vger.kernel.org, Nilesh Javali <njavali@marvell.com>,
        Himanshu Madhani <hmadhani@marvell.com>,
        Quinn Tran <qutran@marvell.com>,
        Martin Wilck <mwilck@suse.com>,
        Daniel Wagner <dwagner@suse.de>,
        Roman Bolshakov <r.bolshakov@yadro.com>
References: <20200405225905.17171-1-bvanassche@acm.org>
From:   Himanshu Madhani <himanshu.madhani@oracle.com>
Organization: Oracle Corporation
Message-ID: <05b77d71-970a-7049-029f-52d9e78e2c9a@oracle.com>
Date:   Mon, 6 Apr 2020 09:39:43 -0500
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <20200405225905.17171-1-bvanassche@acm.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9582 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 phishscore=0 spamscore=0
 malwarescore=0 suspectscore=0 adultscore=0 bulkscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2003020000
 definitions=main-2004060121
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9582 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 phishscore=0 adultscore=0
 priorityscore=1501 mlxscore=0 malwarescore=0 mlxlogscore=999
 lowpriorityscore=0 spamscore=0 impostorscore=0 suspectscore=0
 clxscore=1011 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2004060121
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 4/5/20 5:59 PM, Bart Van Assche wrote:
> The size of the function qla2x00_configure_local_loop() hurts its
> readability. Hence split that function. This patch does not change
> any functionality.
> 
> Cc: Nilesh Javali <njavali@marvell.com>
> Cc: Himanshu Madhani <hmadhani@marvell.com>
> Cc: Quinn Tran <qutran@marvell.com>
> Cc: Martin Wilck <mwilck@suse.com>
> Cc: Daniel Wagner <dwagner@suse.de>
> Cc: Roman Bolshakov <r.bolshakov@yadro.com>
> Signed-off-by: Bart Van Assche <bvanassche@acm.org>
> ---
>   drivers/scsi/qla2xxx/qla_init.c | 92 ++++++++++++++++++---------------
>   1 file changed, 50 insertions(+), 42 deletions(-)
> 
> diff --git a/drivers/scsi/qla2xxx/qla_init.c b/drivers/scsi/qla2xxx/qla_init.c
> index 5b2deaa730bf..80390d3f3236 100644
> --- a/drivers/scsi/qla2xxx/qla_init.c
> +++ b/drivers/scsi/qla2xxx/qla_init.c
> @@ -5081,6 +5081,54 @@ qla2x00_configure_loop(scsi_qla_host_t *vha)
>   	return (rval);
>   }
>   
> +static int qla2x00_configure_n2n_loop(scsi_qla_host_t *vha)
> +{
> +	struct qla_hw_data *ha = vha->hw;
> +	unsigned long flags;
> +	fc_port_t *fcport;
> +	int rval;
> +
> +	if (test_and_clear_bit(N2N_LOGIN_NEEDED, &vha->dpc_flags)) {
> +		/* borrowing */
> +		u32 *bp, sz;
> +
> +		memset(ha->init_cb, 0, ha->init_cb_size);
> +		sz = min_t(int, sizeof(struct els_plogi_payload),
> +			   ha->init_cb_size);
> +		rval = qla24xx_get_port_login_templ(vha, ha->init_cb_dma,
> +						    ha->init_cb, sz);
> +		if (rval == QLA_SUCCESS) {
> +			__be32 *q = &ha->plogi_els_payld.data[0];
> +
> +			bp = (uint32_t *)ha->init_cb;
> +			cpu_to_be32_array(q, bp, sz / 4);
> +			memcpy(bp, q, sizeof(ha->plogi_els_payld.data));
> +		} else {
> +			ql_dbg(ql_dbg_init, vha, 0x00d1,
> +			       "PLOGI ELS param read fail.\n");
> +			goto skip_login;
> +		}
> +	}
> +
> +	list_for_each_entry(fcport, &vha->vp_fcports, list) {
> +		if (fcport->n2n_flag) {
> +			qla24xx_fcport_handle_login(vha, fcport);
> +			return QLA_SUCCESS;
> +		}
> +	}
> +
> +skip_login:
> +	spin_lock_irqsave(&vha->work_lock, flags);
> +	vha->scan.scan_retry++;
> +	spin_unlock_irqrestore(&vha->work_lock, flags);
> +
> +	if (vha->scan.scan_retry < MAX_SCAN_RETRIES) {
> +		set_bit(LOCAL_LOOP_UPDATE, &vha->dpc_flags);
> +		set_bit(LOOP_RESYNC_NEEDED, &vha->dpc_flags);
> +	}
> +	return QLA_FUNCTION_FAILED;
> +}
> +
>   /*
>    * qla2x00_configure_local_loop
>    *	Updates Fibre Channel Device Database with local loop devices.
> @@ -5098,7 +5146,6 @@ qla2x00_configure_local_loop(scsi_qla_host_t *vha)
>   	int		found_devs;
>   	int		found;
>   	fc_port_t	*fcport, *new_fcport;
> -
>   	uint16_t	index;
>   	uint16_t	entries;
>   	struct gid_list_info *gid;
> @@ -5108,47 +5155,8 @@ qla2x00_configure_local_loop(scsi_qla_host_t *vha)
>   	unsigned long flags;
>   
>   	/* Inititae N2N login. */
> -	if (N2N_TOPO(ha)) {
> -		if (test_and_clear_bit(N2N_LOGIN_NEEDED, &vha->dpc_flags)) {
> -			/* borrowing */
> -			u32 *bp, sz;
> -
> -			memset(ha->init_cb, 0, ha->init_cb_size);
> -			sz = min_t(int, sizeof(struct els_plogi_payload),
> -			    ha->init_cb_size);
> -			rval = qla24xx_get_port_login_templ(vha,
> -			    ha->init_cb_dma, (void *)ha->init_cb, sz);
> -			if (rval == QLA_SUCCESS) {
> -				__be32 *q = &ha->plogi_els_payld.data[0];
> -
> -				bp = (uint32_t *)ha->init_cb;
> -				cpu_to_be32_array(q, bp, sz / 4);
> -
> -				memcpy(bp, q, sizeof(ha->plogi_els_payld.data));
> -			} else {
> -				ql_dbg(ql_dbg_init, vha, 0x00d1,
> -				    "PLOGI ELS param read fail.\n");
> -				goto skip_login;
> -			}
> -		}
> -
> -		list_for_each_entry(fcport, &vha->vp_fcports, list) {
> -			if (fcport->n2n_flag) {
> -				qla24xx_fcport_handle_login(vha, fcport);
> -				return QLA_SUCCESS;
> -			}
> -		}
> -skip_login:
> -		spin_lock_irqsave(&vha->work_lock, flags);
> -		vha->scan.scan_retry++;
> -		spin_unlock_irqrestore(&vha->work_lock, flags);
> -
> -		if (vha->scan.scan_retry < MAX_SCAN_RETRIES) {
> -			set_bit(LOCAL_LOOP_UPDATE, &vha->dpc_flags);
> -			set_bit(LOOP_RESYNC_NEEDED, &vha->dpc_flags);
> -		}
> -		return QLA_FUNCTION_FAILED;
> -	}
> +	if (N2N_TOPO(ha))
> +		return qla2x00_configure_n2n_loop(vha);
>   
>   	found_devs = 0;
>   	new_fcport = NULL;
> 

Reviewed-by: Himanshu Madhani <himanshu.madhani@oracle.com>

-- Himanshu
