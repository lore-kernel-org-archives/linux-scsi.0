Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2FDD1C2B9F4
	for <linux-scsi@archiver.kernel.org>; Mon, 14 Jun 2021 14:34:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 128E7611C0
	for <linux-scsi@archiver.kernel.org>; Mon, 14 Jun 2021 14:34:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233059AbhFNOgW (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 14 Jun 2021 10:36:22 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:34508 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S232815AbhFNOgV (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 14 Jun 2021 10:36:21 -0400
Received: from pps.filterd (m0098416.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 15EEXF7D178313;
        Mon, 14 Jun 2021 10:33:49 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : references : content-type : in-reply-to : sender :
 content-transfer-encoding : mime-version; s=pp1;
 bh=YhuyEdL+q/N9B3vKawATEiXFl/0+UXwh1QYjC+r9M5I=;
 b=tPk2pB+IAG5XXq0sXdUY9kPBafF28DJ36Uh/6/nBv8goO6e8pHFdcTwc9VJg2dt68pOy
 iMOWt+ByBwFy/8izfRCHBjeVltTmjXKE8TiTkh5+vVLGghu2DmF7zln9IfgeW26TPYQS
 8NApzofY0+UMn9xs93Re+kcblU6wZziNPmC+g616jkq9mRkFpRk1HTGNuG73xCsrL4rO
 G0VcNemd/58XuAtfITs3OZZH8363k4PmB034FsrmejMgaJISSbdJ1rnbYMOGSAn3v3lu
 LZArBYG/6o4pgQBCISS7UAv+SLCqQMHhjg1yCnTrSIK490M77EE0JDhbZEZWz1zM7Eaf Sw== 
Received: from ppma05fra.de.ibm.com (6c.4a.5195.ip4.static.sl-reverse.com [149.81.74.108])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3967c93p4t-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 14 Jun 2021 10:33:49 -0400
Received: from pps.filterd (ppma05fra.de.ibm.com [127.0.0.1])
        by ppma05fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 15EEXVlu027817;
        Mon, 14 Jun 2021 14:33:47 GMT
Received: from b06cxnps3075.portsmouth.uk.ibm.com (d06relay10.portsmouth.uk.ibm.com [9.149.109.195])
        by ppma05fra.de.ibm.com with ESMTP id 394mj8ghyw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 14 Jun 2021 14:33:47 +0000
Received: from d06av24.portsmouth.uk.ibm.com (d06av24.portsmouth.uk.ibm.com [9.149.105.60])
        by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 15EEXiAV13631796
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 14 Jun 2021 14:33:44 GMT
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 481EF4204F;
        Mon, 14 Jun 2021 14:33:44 +0000 (GMT)
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 34EA24203F;
        Mon, 14 Jun 2021 14:33:44 +0000 (GMT)
Received: from t480-pf1aa2c2 (unknown [9.145.174.2])
        by d06av24.portsmouth.uk.ibm.com (Postfix) with ESMTPS;
        Mon, 14 Jun 2021 14:33:44 +0000 (GMT)
Received: from bblock by t480-pf1aa2c2 with local (Exim 4.94.2)
        (envelope-from <bblock@linux.ibm.com>)
        id 1lsnep-001Hpy-N1; Mon, 14 Jun 2021 16:33:43 +0200
Date:   Mon, 14 Jun 2021 16:33:43 +0200
From:   Benjamin Block <bblock@linux.ibm.com>
To:     "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org
Subject: Re: [PATCH 01/15] scsi: core: Add scsi_prot_ref_tag() helper
Message-ID: <YMdoxzn0jxLG25/n@t480-pf1aa2c2.linux.ibm.com>
References: <20210609033929.3815-1-martin.petersen@oracle.com>
 <20210609033929.3815-2-martin.petersen@oracle.com>
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <20210609033929.3815-2-martin.petersen@oracle.com>
Sender: Benjamin Block <bblock@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: bfgpdrHnR8uzOA-M_-57E7IrnleiW6Hz
X-Proofpoint-ORIG-GUID: bfgpdrHnR8uzOA-M_-57E7IrnleiW6Hz
Content-Transfer-Encoding: 8bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.761
 definitions=2021-06-14_09:2021-06-14,2021-06-14 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0
 lowpriorityscore=0 bulkscore=0 adultscore=0 mlxlogscore=999
 priorityscore=1501 malwarescore=0 spamscore=0 clxscore=1015 phishscore=0
 mlxscore=0 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104190000 definitions=main-2106140095
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Tue, Jun 08, 2021 at 11:39:15PM -0400, Martin K. Petersen wrote:
> We are about to remove the request pointer from struct scsi_cmnd and
> that will complicate getting to the ref_tag via t10_pi_ref_tag() in
> the various drivers. Introduce a helper function to retrieve the
> reference tag so drivers will not have to worry about the details.
> 
> Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
> ---
>  include/scsi/scsi_cmnd.h | 7 +++++++
>  1 file changed, 7 insertions(+)
> 
> diff --git a/include/scsi/scsi_cmnd.h b/include/scsi/scsi_cmnd.h
> index 779a59fe8676..301b9cd4ddd0 100644
> --- a/include/scsi/scsi_cmnd.h
> +++ b/include/scsi/scsi_cmnd.h
> @@ -287,6 +287,13 @@ static inline sector_t scsi_get_lba(struct scsi_cmnd *scmd)
>  	return blk_rq_pos(scmd->request);
>  }
>  
> +static inline u32 scsi_prot_ref_tag(struct scsi_cmnd *scmd)
> +{
> +	struct request *rq = blk_mq_rq_from_pdu(scmd);
> +
> +	return t10_pi_ref_tag(rq);
> +}
> +
>  static inline unsigned int scsi_prot_interval(struct scsi_cmnd *scmd)
>  {
>  	return scmd->device->sector_size;

Reviewed-by: Benjamin Block <bblock@linux.ibm.com>

-- 
Best Regards, Benjamin Block  / Linux on IBM Z Kernel Development / IBM Systems
IBM Deutschland Research & Development GmbH    /    https://www.ibm.com/privacy
Vorsitz. AufsR.: Gregor Pillen         /        Geschäftsführung: Dirk Wittkopp
Sitz der Gesellschaft: Böblingen / Registergericht: AmtsG Stuttgart, HRB 243294
