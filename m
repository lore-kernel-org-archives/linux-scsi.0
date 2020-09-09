Return-Path: <SRS0=U9Ib=CS=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_2 autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B17B3C10DAA
	for <linux-scsi@archiver.kernel.org>; Wed,  9 Sep 2020 05:05:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6471620936
	for <linux-scsi@archiver.kernel.org>; Wed,  9 Sep 2020 05:05:37 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="D8DWbtaC"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725840AbgIIFFb (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 9 Sep 2020 01:05:31 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:12472 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725772AbgIIFFb (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 9 Sep 2020 01:05:31 -0400
Received: from pps.filterd (m0098416.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 089519og052859;
        Wed, 9 Sep 2020 01:05:14 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : subject :
 from : reply-to : to : cc : date : in-reply-to : references : content-type
 : mime-version : content-transfer-encoding; s=pp1;
 bh=upUKW1wfH6tUScMMqZ4LJBIsyfo7taO8e7cu/MaUiSc=;
 b=D8DWbtaCustHMVeKhhusyL120QJsAUw5+N9Cw6xtl7Nm6Qry25bSaEc2dqIT6qiLTanK
 vDMYDgaNPoHIxUUuosxlIrRam9nAWqlSKgWsoo8CIq1wp9DXVHbVjUkI99SfAknYcPUN
 Ng6TyGn1Z5xAw3BbiqudkzbkJnsx1KnHvaxaanoPELn4lf1VBtIkY1v1nQVkHrzUoLAf
 u05NvpIKwhFXoh7UI5594ZYBkDTwyyC0jTulCkvmXnBaIbVlyOAmlKzef0VBk47hs75r
 V0J3hsPJPGW3FaICcrDv14CdxlFDvX/QgDAajEjJLK4kSwctCCv9baEPCHKBBPRHZVsf oQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 33eqgwsmt4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 09 Sep 2020 01:05:14 -0400
Received: from m0098416.ppops.net (m0098416.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 089541dA062667;
        Wed, 9 Sep 2020 01:05:13 -0400
Received: from ppma01wdc.us.ibm.com (fd.55.37a9.ip4.static.sl-reverse.com [169.55.85.253])
        by mx0b-001b2d01.pphosted.com with ESMTP id 33eqgwsmsq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 09 Sep 2020 01:05:13 -0400
Received: from pps.filterd (ppma01wdc.us.ibm.com [127.0.0.1])
        by ppma01wdc.us.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 08951c8N002829;
        Wed, 9 Sep 2020 05:05:12 GMT
Received: from b03cxnp07028.gho.boulder.ibm.com (b03cxnp07028.gho.boulder.ibm.com [9.17.130.15])
        by ppma01wdc.us.ibm.com with ESMTP id 33c2a8vqkc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 09 Sep 2020 05:05:12 +0000
Received: from b03ledav004.gho.boulder.ibm.com (b03ledav004.gho.boulder.ibm.com [9.17.130.235])
        by b03cxnp07028.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 08955BS552363556
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 9 Sep 2020 05:05:11 GMT
Received: from b03ledav004.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 6C0037805E;
        Wed,  9 Sep 2020 05:05:11 +0000 (GMT)
Received: from b03ledav004.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 1F28F78064;
        Wed,  9 Sep 2020 05:05:08 +0000 (GMT)
Received: from [153.66.254.174] (unknown [9.85.154.61])
        by b03ledav004.gho.boulder.ibm.com (Postfix) with ESMTP;
        Wed,  9 Sep 2020 05:05:07 +0000 (GMT)
Message-ID: <1599627906.10803.65.camel@linux.ibm.com>
Subject: Re: [PATCH v2 1/2] scsi: ufs: Abort tasks before clear them from
 doorbell
From:   James Bottomley <jejb@linux.ibm.com>
Reply-To: jejb@linux.ibm.com
To:     Can Guo <cang@codeaurora.org>, asutoshd@codeaurora.org,
        nguyenb@codeaurora.org, hongwus@codeaurora.org,
        ziqichen@codeaurora.org, rnayak@codeaurora.org,
        linux-scsi@vger.kernel.org, kernel-team@android.com,
        saravanak@google.com, salyzyn@google.com
Cc:     Alim Akhtar <alim.akhtar@samsung.com>,
        Avri Altman <avri.altman@wdc.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Bean Huo <beanhuo@micron.com>,
        Bart Van Assche <bvanassche@acm.org>,
        open list <linux-kernel@vger.kernel.org>,
        "moderated list:ARM/Mediatek SoC support" 
        <linux-arm-kernel@lists.infradead.org>,
        "moderated list:ARM/Mediatek SoC support" 
        <linux-mediatek@lists.infradead.org>
Date:   Tue, 08 Sep 2020 22:05:06 -0700
In-Reply-To: <1599099873-32579-2-git-send-email-cang@codeaurora.org>
References: <1599099873-32579-1-git-send-email-cang@codeaurora.org>
         <1599099873-32579-2-git-send-email-cang@codeaurora.org>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.26.6 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-09-09_02:2020-09-08,2020-09-09 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 spamscore=0 clxscore=1011
 lowpriorityscore=0 adultscore=0 priorityscore=1501 mlxlogscore=999
 impostorscore=0 mlxscore=0 bulkscore=0 phishscore=0 malwarescore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2009090040
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

I can't reconcile this hunk:

On Wed, 2020-09-02 at 19:24 -0700, Can Guo wrote:
> @@ -6504,6 +6505,80 @@ static void ufshcd_set_req_abort_skip(struct
> ufs_hba *hba, unsigned long bitmap)
>   * issued. To avoid that, first issue UFS_QUERY_TASK to check if the
> command is
>   * really issued and then try to abort it.
>   *
> + * Returns zero on success, non-zero on failure
> + */
> +static int ufshcd_try_to_abort_task(struct ufs_hba *hba, int tag)
> +{
> +	struct ufshcd_lrb *lrbp = &hba->lrb[tag];
> +	int err = 0;
> +	int poll_cnt;
> +	u8 resp = 0xF;
> +	u32 reg;
> +
> +	for (poll_cnt = 100; poll_cnt; poll_cnt--) {
> +		err = ufshcd_issue_tm_cmd(hba, lrbp->lun, lrbp-
> >task_tag,
> +				UFS_QUERY_TASK, &resp);
> +		if (!err && resp ==
> UPIU_TASK_MANAGEMENT_FUNC_SUCCEEDED) {
> +			/* cmd pending in the device */
> +			dev_err(hba->dev, "%s: cmd pending in the
> device. tag = %d\n",
> +				__func__, tag);
> +			break;
> +		} else if (!err && resp ==
> UPIU_TASK_MANAGEMENT_FUNC_COMPL) {
> +			/*
> +			 * cmd not pending in the device, check if
> it is
> +			 * in transition.
> +			 */
> +			dev_err(hba->dev, "%s: cmd at tag %d not
> pending in the device.\n",
> +				__func__, tag);
> +			reg = ufshcd_readl(hba,
> REG_UTP_TRANSFER_REQ_DOOR_BELL);
> +			if (reg & (1 << tag)) {
> +				/* sleep for max. 200us to stabilize
> */
> +				usleep_range(100, 200);
> +				continue;
> +			}
> +			/* command completed already */
> +			dev_err(hba->dev, "%s: cmd at tag %d
> successfully cleared from DB.\n",
> +				__func__, tag);
> +			goto out;
> +		} else {
> +			dev_err(hba->dev,
> +				"%s: no response from device. tag =
> %d, err %d\n",
> +				__func__, tag, err);
> +			if (!err)
> +				err = resp; /* service response
> error */
> +			goto out;
> +		}
> +	}
> +
> +	if (!poll_cnt) {
> +		err = -EBUSY;
> +		goto out;
> +	}
> +
> +	err = ufshcd_issue_tm_cmd(hba, lrbp->lun, lrbp->task_tag,
> +			UFS_ABORT_TASK, &resp);
> +	if (err || resp != UPIU_TASK_MANAGEMENT_FUNC_COMPL) {
> +		if (!err) {
> +			err = resp; /* service response error */
> +			dev_err(hba->dev, "%s: issued. tag = %d, err
> %d\n",
> +				__func__, tag, err);
> +		}
> +		goto out;
> +	}
> +
> +	err = ufshcd_clear_cmd(hba, tag);
> +	if (err)
> +		dev_err(hba->dev, "%s: Failed clearing cmd at tag
> %d, err %d\n",
> +			__func__, tag, err);
> +
> +out:
> +	return err;
> +}
> +
> +/**
> + * ufshcd_abort - scsi host template eh_abort_handler callback
> + * @cmd: SCSI command pointer
> + *
>   * Returns SUCCESS/FAILED
>   */
>  static int ufshcd_abort(struct scsi_cmnd *cmd)
> @@ -6513,8 +6588,6 @@ static int ufshcd_abort(struct scsi_cmnd *cmd)
>  	unsigned long flags;
>  	unsigned int tag;
>  	int err = 0;
> -	int poll_cnt;
> -	u8 resp = 0xF;
>  	struct ufshcd_lrb *lrbp;
>  	u32 reg;
>  
> @@ -6583,63 +6656,9 @@ static int ufshcd_abort(struct scsi_cmnd *cmd)
>  		goto out;
>  	}
>  
> -	for (poll_cnt = 100; poll_cnt; poll_cnt--) {
> -		err = ufshcd_issue_tm_cmd(hba, lrbp->lun, lrbp-
> >task_tag,
> -				UFS_QUERY_TASK, &resp);
> -		if (!err && resp ==
> UPIU_TASK_MANAGEMENT_FUNC_SUCCEEDED) {
> -			/* cmd pending in the device */
> -			dev_err(hba->dev, "%s: cmd pending in the
> device. tag = %d\n",
> -				__func__, tag);
> -			break;
> -		} else if (!err && resp ==
> UPIU_TASK_MANAGEMENT_FUNC_COMPL) {
> -			/*
> -			 * cmd not pending in the device, check if
> it is
> -			 * in transition.
> -			 */
> -			dev_err(hba->dev, "%s: cmd at tag %d not
> pending in the device.\n",
> -				__func__, tag);
> -			reg = ufshcd_readl(hba,
> REG_UTP_TRANSFER_REQ_DOOR_BELL);
> -			if (reg & (1 << tag)) {
> -				/* sleep for max. 200us to stabilize
> */
> -				usleep_range(100, 200);
> -				continue;
> -			}
> -			/* command completed already */
> -			dev_err(hba->dev, "%s: cmd at tag %d
> successfully cleared from DB.\n",
> -				__func__, tag);
> -			goto out;
> -		} else {
> -			dev_err(hba->dev,
> -				"%s: no response from device. tag =
> %d, err %d\n",
> -				__func__, tag, err);
> -			if (!err)
> -				err = resp; /* service response
> error */
> -			goto out;
> -		}
> -	}
> -
> -	if (!poll_cnt) {
> -		err = -EBUSY;
> -		goto out;
> -	}
> -
> -	err = ufshcd_issue_tm_cmd(hba, lrbp->lun, lrbp->task_tag,
> -			UFS_ABORT_TASK, &resp);
> -	if (err || resp != UPIU_TASK_MANAGEMENT_FUNC_COMPL) {
> -		if (!err) {
> -			err = resp; /* service response error */
> -			dev_err(hba->dev, "%s: issued. tag = %d, err
> %d\n",
> -				__func__, tag, err);
> -		}
> -		goto out;
> -	}
> -
> -	err = ufshcd_clear_cmd(hba, tag);
> -	if (err) {
> -		dev_err(hba->dev, "%s: Failed clearing cmd at tag
> %d, err %d\n",
> -			__func__, tag, err);
> +	err = ufshcd_try_to_abort_task(hba, tag);
> +	if (err)
>  		goto out;
> -	}
>  
>  	spin_lock_irqsave(host->host_lock, flags);
>  	__ufshcd_transfer_req_compl(hba, (1UL << tag));


With the change in this fix:

commit b10178ee7fa88b68a9e8adc06534d2605cb0ec23
Author: Stanley Chu <stanley.chu@mediatek.com>
Date:   Tue Aug 11 16:18:58 2020 +0200

    scsi: ufs: Clean up completed request without interrupt
notification


It looks like there have to be two separate error returns from your new
ufshcd_try_to_abort_function() so it knows to continue with
usfhcd_transfer_req_complete(), or the whole function needs to be
refactored, but if this goes upstream as is it looks like it will
eliminate the bug fix.

James

