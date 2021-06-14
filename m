Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DC566C2B9F4
	for <linux-scsi@archiver.kernel.org>; Mon, 14 Jun 2021 14:50:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BB4A961283
	for <linux-scsi@archiver.kernel.org>; Mon, 14 Jun 2021 14:50:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232919AbhFNOwX (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 14 Jun 2021 10:52:23 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:37672 "EHLO
        mx0b-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232858AbhFNOwW (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 14 Jun 2021 10:52:22 -0400
Received: from pps.filterd (m0098417.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 15EEZZvs176498;
        Mon, 14 Jun 2021 10:50:17 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : references : content-type : in-reply-to : sender :
 content-transfer-encoding : mime-version; s=pp1;
 bh=QLMrU22zMD2US22b2rVVCf/GB9PrsCpJ3yw0B0C2cZQ=;
 b=Qrg9v62+4fcvxi+pAzjaPD9wZ/yVquG8ejqiC5fwcyRkoyX4PxcUZYs9QJevNugSNg41
 xvI2iA3M0UgS/+Opr2026mS4DXQJ0WkwcwAwnqFxl7/33E1KJTqUuGDjBiz99SAkfJV9
 vb/KGpXksxlitd7GSYABH5bcCYYC/JOrpgON5BnRKGoSM5Xgy7zzbURW7OMxfAO/cnH/
 fPL0A6thkddbP9h1ZLU1h/oiSEchjNtb3xfO4mbkGTnVzbfN9Qo9Ksta0gtlDDyBXUe0
 skxXK64QM9CD3V9i3F9eS9zQW19KmLp8p4+sXYOLxC5CzVubw4Z11rhxu6jwRdMbfT2Z FQ== 
Received: from ppma06fra.de.ibm.com (48.49.7a9f.ip4.static.sl-reverse.com [159.122.73.72])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3966xs50uw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 14 Jun 2021 10:50:17 -0400
Received: from pps.filterd (ppma06fra.de.ibm.com [127.0.0.1])
        by ppma06fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 15EEnFcm021303;
        Mon, 14 Jun 2021 14:50:16 GMT
Received: from b06cxnps4075.portsmouth.uk.ibm.com (d06relay12.portsmouth.uk.ibm.com [9.149.109.197])
        by ppma06fra.de.ibm.com with ESMTP id 394m6h8j4s-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 14 Jun 2021 14:50:15 +0000
Received: from d06av23.portsmouth.uk.ibm.com (d06av23.portsmouth.uk.ibm.com [9.149.105.59])
        by b06cxnps4075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 15EEoCFc33030500
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 14 Jun 2021 14:50:12 GMT
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id B796FA405F;
        Mon, 14 Jun 2021 14:50:12 +0000 (GMT)
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id A57D8A4040;
        Mon, 14 Jun 2021 14:50:12 +0000 (GMT)
Received: from t480-pf1aa2c2 (unknown [9.145.174.2])
        by d06av23.portsmouth.uk.ibm.com (Postfix) with ESMTPS;
        Mon, 14 Jun 2021 14:50:12 +0000 (GMT)
Received: from bblock by t480-pf1aa2c2 with local (Exim 4.94.2)
        (envelope-from <bblock@linux.ibm.com>)
        id 1lsnum-001IEe-5H; Mon, 14 Jun 2021 16:50:12 +0200
Date:   Mon, 14 Jun 2021 16:50:12 +0200
From:   Benjamin Block <bblock@linux.ibm.com>
To:     "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org
Subject: Re: [PATCH 12/15] scsi: core: Make scsi_get_lba() return the LBA
Message-ID: <YMdspAy63qF1h8aI@t480-pf1aa2c2.linux.ibm.com>
References: <20210609033929.3815-1-martin.petersen@oracle.com>
 <20210609033929.3815-13-martin.petersen@oracle.com>
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <20210609033929.3815-13-martin.petersen@oracle.com>
Sender: Benjamin Block <bblock@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: -r7Tr7JCi0sBzpp4BKKXkUVcMf-FNIBK
X-Proofpoint-ORIG-GUID: -r7Tr7JCi0sBzpp4BKKXkUVcMf-FNIBK
Content-Transfer-Encoding: 8bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.761
 definitions=2021-06-14_09:2021-06-14,2021-06-14 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0 mlxscore=0
 adultscore=0 clxscore=1015 priorityscore=1501 phishscore=0 mlxlogscore=999
 malwarescore=0 lowpriorityscore=0 spamscore=0 bulkscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104190000
 definitions=main-2106140095
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Tue, Jun 08, 2021 at 11:39:26PM -0400, Martin K. Petersen wrote:
> scsi_get_lba() confusingly returned the block layer sector number
> expressed in units of 512 bytes. Now that we have a more aptly named
> scsi_get_sector() function, make scsi_get_lba() return the actual LBA.
> 
> Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
> ---
>  include/scsi/scsi_cmnd.h | 12 +++++++-----
>  1 file changed, 7 insertions(+), 5 deletions(-)
> 
> diff --git a/include/scsi/scsi_cmnd.h b/include/scsi/scsi_cmnd.h
> index cba63377d46a..90da9617d28a 100644
> --- a/include/scsi/scsi_cmnd.h
> +++ b/include/scsi/scsi_cmnd.h
> @@ -225,6 +225,13 @@ static inline sector_t scsi_get_sector(struct scsi_cmnd *scmd)
>  	return blk_rq_pos(scmd->request);
>  }
>  
> +static inline sector_t scsi_get_lba(struct scsi_cmnd *scmd)
> +{
> +	unsigned int shift = ilog2(scmd->device->sector_size) - SECTOR_SHIFT;
> +
> +	return blk_rq_pos(scmd->request) >> shift;

Hmm again, should it use `blk_mq_rq_from_pdu()`?

-- 
Best Regards, Benjamin Block  / Linux on IBM Z Kernel Development / IBM Systems
IBM Deutschland Research & Development GmbH    /    https://www.ibm.com/privacy
Vorsitz. AufsR.: Gregor Pillen         /        Geschäftsführung: Dirk Wittkopp
Sitz der Gesellschaft: Böblingen / Registergericht: AmtsG Stuttgart, HRB 243294
