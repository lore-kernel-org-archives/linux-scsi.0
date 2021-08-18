Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7DEF7C4338F
	for <linux-scsi@archiver.kernel.org>; Wed, 18 Aug 2021 14:28:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6041E60EFF
	for <linux-scsi@archiver.kernel.org>; Wed, 18 Aug 2021 14:28:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238652AbhHRO2e (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 18 Aug 2021 10:28:34 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:24292 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233320AbhHRO2e (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 18 Aug 2021 10:28:34 -0400
Received: from pps.filterd (m0098394.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 17IE2baf040681;
        Wed, 18 Aug 2021 10:27:07 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : subject :
 from : reply-to : to : cc : date : in-reply-to : references : content-type
 : mime-version : content-transfer-encoding; s=pp1;
 bh=N2l28f+ljzrAMnDjhtcOJfqTQipoZl0SCKF7Bazm2ac=;
 b=dbG/3YG+LaiJMcGpUOSatk3xjpneWwYLQTIgQf/4uq2h9bu00voinLqBsRlX1BOSe7rL
 yyMVqhghqbRUbmKgZIRpA0OO1iaWc+o7Xiip20+cYVPx6smCdK4FCyVBr4tteHIjLnCk
 QdM8R5gdEaIZgo+MbBZP9r/ZARW/aFMxn8LfA84CqjkMvDXVXduhNG6gz35Zw3CdPioL
 CghaqJtEBzzH5GvF6AfMhoHR+KoF3BY0T8U75tbClIpImyB8rcEv75pnoE/h4+O1VnCA
 G7J6w3L3/2mEP6piJLOc0vx8beim/LyvVllZJ1V2w4gcuA67e/JW+D1x9NIRAHOIT8+U Rg== 
Received: from ppma04wdc.us.ibm.com (1a.90.2fa9.ip4.static.sl-reverse.com [169.47.144.26])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3agkvmsgut-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 18 Aug 2021 10:27:07 -0400
Received: from pps.filterd (ppma04wdc.us.ibm.com [127.0.0.1])
        by ppma04wdc.us.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 17IEDEq0007436;
        Wed, 18 Aug 2021 14:27:06 GMT
Received: from b03cxnp08028.gho.boulder.ibm.com (b03cxnp08028.gho.boulder.ibm.com [9.17.130.20])
        by ppma04wdc.us.ibm.com with ESMTP id 3ae5fdgpst-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 18 Aug 2021 14:27:06 +0000
Received: from b03ledav004.gho.boulder.ibm.com (b03ledav004.gho.boulder.ibm.com [9.17.130.235])
        by b03cxnp08028.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 17IER5OM39059770
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 18 Aug 2021 14:27:05 GMT
Received: from b03ledav004.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 39CD978069;
        Wed, 18 Aug 2021 14:27:05 +0000 (GMT)
Received: from b03ledav004.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 9848178072;
        Wed, 18 Aug 2021 14:27:03 +0000 (GMT)
Received: from jarvis.lan (unknown [9.160.128.138])
        by b03ledav004.gho.boulder.ibm.com (Postfix) with ESMTP;
        Wed, 18 Aug 2021 14:27:03 +0000 (GMT)
Message-ID: <996f1de7010aa3ebfd334fb09562944550f894c3.camel@linux.ibm.com>
Subject: Re: [PATCH 2/2] scsi: qla1280: Fix DEBUG_QLA1280 compilation issues
From:   James Bottomley <jejb@linux.ibm.com>
Reply-To: jejb@linux.ibm.com
To:     John Garry <john.garry@huawei.com>, mdr@sgi.com,
        martin.petersen@oracle.com
Cc:     linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        bvanassche@acm.org
Date:   Wed, 18 Aug 2021 10:27:01 -0400
In-Reply-To: <1629294801-32102-3-git-send-email-john.garry@huawei.com>
References: <1629294801-32102-1-git-send-email-john.garry@huawei.com>
         <1629294801-32102-3-git-send-email-john.garry@huawei.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.34.4 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: x7yJxCsDC_9vq3pnR3W_bIvlEHTzkc-P
X-Proofpoint-GUID: x7yJxCsDC_9vq3pnR3W_bIvlEHTzkc-P
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.790
 definitions=2021-08-18_04:2021-08-17,2021-08-18 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxlogscore=999 clxscore=1011
 priorityscore=1501 malwarescore=0 impostorscore=0 mlxscore=0 phishscore=0
 spamscore=0 bulkscore=0 lowpriorityscore=0 suspectscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2107140000
 definitions=main-2108180089
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Wed, 2021-08-18 at 21:53 +0800, John Garry wrote:
> The driver does not compile under DEBUG_QLA1280 flag, so fix up with
> as
> little fuss as possible some debug statements.
> 
> Also delete ql1280_dump_device(), which looks to have never been
> referenced.
> 
> Signed-off-by: John Garry <john.garry@huawei.com>
> ---
>  drivers/scsi/qla1280.c | 39 ++++++++-------------------------------
>  1 file changed, 8 insertions(+), 31 deletions(-)
> 
> diff --git a/drivers/scsi/qla1280.c b/drivers/scsi/qla1280.c
> index b4f7d8d7a01c..27b16ec399cd 100644
> --- a/drivers/scsi/qla1280.c
> +++ b/drivers/scsi/qla1280.c
> @@ -2807,7 +2807,7 @@ qla1280_64bit_start_scsi(struct scsi_qla_host
> *ha, struct srb * sp)
>  
>  	dprintk(2, "start: cmd=%p sp=%p CDB=%xm, handle %lx\n", cmd,
> sp,
>  		cmd->cmnd[0], (long)CMD_HANDLE(sp->cmd));
> -	dprintk(2, "             bus %i, target %i, lun %i\n",
> +	dprintk(2, "             bus %i, target %i, lun %lld\n",
>  		SCSI_BUS_32(cmd), SCSI_TCN_32(cmd), SCSI_LUN_32(cmd));
>  	qla1280_dump_buffer(2, cmd->cmnd, MAX_COMMAND_SIZE);
>  
> @@ -2879,7 +2879,7 @@ qla1280_64bit_start_scsi(struct scsi_qla_host
> *ha, struct srb * sp)
>  			remseg--;
>  		}
>  		dprintk(5, "qla1280_64bit_start_scsi: Scatter/gather "
> -			"command packet data - b %i, t %i, l %i \n",
> +			"command packet data - b %i, t %i, l %lld \n",
>  			SCSI_BUS_32(cmd), SCSI_TCN_32(cmd),
>  			SCSI_LUN_32(cmd));

These are the wrong fixes, I think.  The qla1280 can only cope with 32
bits, which is why all the macros have an _32.  Over the years we've
expanded the values in the SCSI command to be 64 bit but by and large,
the truncation in this driver is silent.  However, the correct fix
should be to make the truncation explicit in the macro, so

#define SCSI_LUN_32(Cmnd)	((int)Cmnd->device->lun)

And the same for all the other _32 macros.  This avoids the unexpected
outcome that the _32 macros are actually returning 64 bits and cause me
to do a WTF at your %lld change.

James


