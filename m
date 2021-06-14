Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 58CCAC2B9F4
	for <linux-scsi@archiver.kernel.org>; Mon, 14 Jun 2021 14:33:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 42B9F611C0
	for <linux-scsi@archiver.kernel.org>; Mon, 14 Jun 2021 14:33:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232951AbhFNOfU (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 14 Jun 2021 10:35:20 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:13516 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232958AbhFNOfT (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 14 Jun 2021 10:35:19 -0400
Received: from pps.filterd (m0098399.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 15EE3dsF158771;
        Mon, 14 Jun 2021 10:33:13 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : references : content-type : in-reply-to : sender :
 content-transfer-encoding : mime-version; s=pp1;
 bh=TPmkHzjOwEyk7Tr77ZTCqwCvYX0xEOdFWPSa8Df6pQg=;
 b=QWCKJw+6xdq0FLVCLRorwOTRaVgl2mtu7PEs6U6uxhdUYOGSXjusvVm2a3TUzLtvlvlr
 py7hOjQEAJE48G5SvboA8UAR6ckBy4ii8ueh964EUHmqOu7s3HtG9jjOp12em3CCk4l5
 ePMKVa/L+G6tv3Qb9NsXtSG4HwIWJUAbU1ieChsC5hjipGxpwCpwPtGu0RcQDXW2fFA9
 YwHFYR4scm1/CIaNWI05pDIMbiy+p5MBprJ7MU959Feg0C3i4PMi4bDqVOkWz0JOmuGS
 WA/xmfBzOY+UQwNOOd9+bSqjqvNUwu3hlfBhGAbD1BJkfIpocLwl/iV6TI5qb1/MRJGr Bg== 
Received: from ppma02fra.de.ibm.com (47.49.7a9f.ip4.static.sl-reverse.com [159.122.73.71])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3967fe3ekn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 14 Jun 2021 10:33:13 -0400
Received: from pps.filterd (ppma02fra.de.ibm.com [127.0.0.1])
        by ppma02fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 15EEXAtf031611;
        Mon, 14 Jun 2021 14:33:10 GMT
Received: from b06cxnps4074.portsmouth.uk.ibm.com (d06relay11.portsmouth.uk.ibm.com [9.149.109.196])
        by ppma02fra.de.ibm.com with ESMTP id 3966jpg1ee-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 14 Jun 2021 14:33:10 +0000
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06cxnps4074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 15EEX7Nd33751366
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 14 Jun 2021 14:33:07 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 866384C04E;
        Mon, 14 Jun 2021 14:33:07 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 73BCB4C04A;
        Mon, 14 Jun 2021 14:33:07 +0000 (GMT)
Received: from t480-pf1aa2c2 (unknown [9.145.174.2])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with ESMTPS;
        Mon, 14 Jun 2021 14:33:07 +0000 (GMT)
Received: from bblock by t480-pf1aa2c2 with local (Exim 4.94.2)
        (envelope-from <bblock@linux.ibm.com>)
        id 1lsneE-001Hoy-Tj; Mon, 14 Jun 2021 16:33:06 +0200
Date:   Mon, 14 Jun 2021 16:33:06 +0200
From:   Benjamin Block <bblock@linux.ibm.com>
To:     "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Steffen Maier <maier@linux.ibm.com>,
        Fedor Loshakov <loshakov@linux.ibm.com>
Subject: Re: [PATCH 06/15] scsi: zfcp: Use the proper SCSI midlayer
 interfaces for PI
Message-ID: <YMdoondMcc31A2vJ@t480-pf1aa2c2.linux.ibm.com>
References: <20210609033929.3815-1-martin.petersen@oracle.com>
 <20210609033929.3815-7-martin.petersen@oracle.com>
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <20210609033929.3815-7-martin.petersen@oracle.com>
Sender: Benjamin Block <bblock@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: oYUxrQ2nriHjHxSAp38mgkGRflL9e5EH
X-Proofpoint-ORIG-GUID: oYUxrQ2nriHjHxSAp38mgkGRflL9e5EH
Content-Transfer-Encoding: 8bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.761
 definitions=2021-06-14_09:2021-06-14,2021-06-14 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 lowpriorityscore=0 malwarescore=0 mlxscore=0 suspectscore=0 adultscore=0
 phishscore=0 impostorscore=0 bulkscore=0 clxscore=1015 mlxlogscore=999
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104190000 definitions=main-2106140093
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hey Martin,

please set me and Steffen on CC next time for zfcp.

On Tue, Jun 08, 2021 at 11:39:20PM -0400, Martin K. Petersen wrote:
> Use scsi_prot_ref_tag() and scsi_prot_interval() instead
> scsi_get_lba() and sector_size.
> 
> Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
> ---
>  drivers/s390/scsi/zfcp_fsf.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/s390/scsi/zfcp_fsf.c b/drivers/s390/scsi/zfcp_fsf.c
> index 2e4804ef2fb9..1990216cf289 100644
> --- a/drivers/s390/scsi/zfcp_fsf.c
> +++ b/drivers/s390/scsi/zfcp_fsf.c
> @@ -2599,8 +2599,8 @@ int zfcp_fsf_fcp_cmnd(struct scsi_cmnd *scsi_cmnd)
>  	io->fcp_cmnd_length = FCP_CMND_LEN;
>  
>  	if (scsi_get_prot_op(scsi_cmnd) != SCSI_PROT_NORMAL) {
> -		io->data_block_length = scsi_cmnd->device->sector_size;
> -		io->ref_tag_value = scsi_get_lba(scsi_cmnd) & 0xFFFFFFFF;
> +		io->data_block_length = scsi_prot_interval(scsi_cmnd);
> +		io->ref_tag_value = scsi_prot_ref_tag(scsi_cmnd);

Reviewed-by: Benjamin Block <bblock@linux.ibm.com>


Out of curiosity, do you have any idea whether there is any storage that
offers DIF with a different Logical Block Size than 512 (I haven't see
any, although, that doesn't say much)? Just re-read some parts of our
HBA specs and we probably would be in trouble, if it does, with how we do
things here.

-- 
Best Regards, Benjamin Block  / Linux on IBM Z Kernel Development / IBM Systems
IBM Deutschland Research & Development GmbH    /    https://www.ibm.com/privacy
Vorsitz. AufsR.: Gregor Pillen         /        Geschäftsführung: Dirk Wittkopp
Sitz der Gesellschaft: Böblingen / Registergericht: AmtsG Stuttgart, HRB 243294
