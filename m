Return-Path: <SRS0=I90e=23=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_SANE_1 autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ADA8BC33C8C
	for <linux-scsi@archiver.kernel.org>; Mon,  6 Jan 2020 14:45:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 84D8120731
	for <linux-scsi@archiver.kernel.org>; Mon,  6 Jan 2020 14:45:43 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="KZAS/9jg"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726478AbgAFOpj (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 6 Jan 2020 09:45:39 -0500
Received: from userp2130.oracle.com ([156.151.31.86]:58656 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726303AbgAFOpj (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 6 Jan 2020 09:45:39 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 006Egre7060448;
        Mon, 6 Jan 2020 14:45:32 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2019-08-05;
 bh=y6Yf0Tj3nApnNA9jMdUffxaonp7W12V1dGrGOMpEJEs=;
 b=KZAS/9jgYbJYUWelkrCfBVA1iF8Tduijy60JmFC/xnanGW+4BeeONdNUxaIMVgED8aCM
 NUKzOXUkv/ECMSb4WnnarCme0Rdnyf8Pn/NgBy3zSBuvrAchPlJoGarYHK8EDod2TAwU
 /m7SsNOgVO3rq2D5irEcsgPOoWhRmA2We5YdmI/r24SLbIxtmr3sk9RuaNVNR6gH/n/v
 PNuUL3R346pgeGuXJky4+E5iPfuVxKan5Ka3dNXM+KMe5JoHj8ylw46upFEw3YY1IkN6
 tTBweIYqtJA/L8Os7RCUWdvobxfgEz2JoiDLoofsEsbqgacLSEqCGAKptvMl9oDn5U75 tQ== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2130.oracle.com with ESMTP id 2xaj4tqqk7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 06 Jan 2020 14:45:32 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 006EipJi181815;
        Mon, 6 Jan 2020 14:45:31 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3030.oracle.com with ESMTP id 2xb4v12q70-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 06 Jan 2020 14:45:31 +0000
Received: from abhmp0002.oracle.com (abhmp0002.oracle.com [141.146.116.8])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 006EjUAT027182;
        Mon, 6 Jan 2020 14:45:30 GMT
Received: from kadam (/129.205.23.165)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 06 Jan 2020 06:45:29 -0800
Date:   Mon, 6 Jan 2020 17:45:22 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     Colin King <colin.king@canonical.com>
Cc:     Himanshu Madhani <hmadhani@marvell.com>,
        "James E . J . Bottomley" <jejb@linux.ibm.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Quinn Tran <qutran@marvell.com>, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: Re: [PATCH][next] scsi: qla2xxx: fix null pointer dereference on
 null_fcport
Message-ID: <20200106144522.GL3911@kadam>
References: <20200106141144.52888-1-colin.king@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200106141144.52888-1-colin.king@canonical.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9491 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=2 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1911140001 definitions=main-2001060134
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9491 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=2 phishscore=0 bulkscore=0 spamscore=0 clxscore=1011
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1911140001
 definitions=main-2001060134
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Mon, Jan 06, 2020 at 02:11:44PM +0000, Colin King wrote:
> From: Colin Ian King <colin.king@canonical.com>
> 
> Currently several error exit return paths end up passing a null
> new_fcport pointer to function qla2x00_free_fcport and this causes
> a null pointer dereference.  Fix this by moving and renaming the
> exit path label to be after the call to qla2x00_free_fcport to avoid
> the errorneous and unnecessary call to qla2x00_free_fcport.
> 
> Addresses-Coverity: ("Dereference after null check")
> Fixes: 3dae220595ba ("scsi: qla2xxx: Use common routine to free fcport struct")
> Signed-off-by: Colin Ian King <colin.king@canonical.com>
> ---
>  drivers/scsi/qla2xxx/qla_init.c | 9 ++++-----
>  1 file changed, 4 insertions(+), 5 deletions(-)
> 
> diff --git a/drivers/scsi/qla2xxx/qla_init.c b/drivers/scsi/qla2xxx/qla_init.c
> index a5076f43edea..ed056626d7a3 100644
> --- a/drivers/scsi/qla2xxx/qla_init.c
> +++ b/drivers/scsi/qla2xxx/qla_init.c
> @@ -5108,7 +5108,7 @@ qla2x00_configure_local_loop(scsi_qla_host_t *vha)
>  	rval = qla2x00_get_id_list(vha, ha->gid_list, ha->gid_list_dma,
>  	    &entries);
>  	if (rval != QLA_SUCCESS)
> -		goto cleanup_allocation;
> +		goto exit;
>  
>  	ql_dbg(ql_dbg_disc, vha, 0x2011,
>  	    "Entries in ID list (%d).\n", entries);
> @@ -5138,7 +5138,7 @@ qla2x00_configure_local_loop(scsi_qla_host_t *vha)
>  		ql_log(ql_log_warn, vha, 0x2012,
>  		    "Memory allocation failed for fcport.\n");
>  		rval = QLA_MEMORY_ALLOC_FAILED;
> -		goto cleanup_allocation;
> +		goto exit;
>  	}
>  	new_fcport->flags &= ~FCF_FABRIC_DEVICE;
>  
> @@ -5228,7 +5228,7 @@ qla2x00_configure_local_loop(scsi_qla_host_t *vha)
>  				ql_log(ql_log_warn, vha, 0xd031,
>  				    "Failed to allocate memory for fcport.\n");
>  				rval = QLA_MEMORY_ALLOC_FAILED;
> -				goto cleanup_allocation;
> +				goto exit;

This leaks now.

>  			}
>  			spin_lock_irqsave(&vha->hw->tgt.sess_lock, flags);
>  			new_fcport->flags &= ~FCF_FABRIC_DEVICE;
> @@ -5239,7 +5239,6 @@ qla2x00_configure_local_loop(scsi_qla_host_t *vha)
>  		/* Base iIDMA settings on HBA port speed. */
>  		fcport->fp_speed = ha->link_data_rate;
>  
> -		found_devs++;

Delete "found_devs" completely.  Also remove the "new_fcport = NULL;"
line because that's not required any more.

regards,
dan carpenter

