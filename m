Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9692EC433ED
	for <linux-scsi@archiver.kernel.org>; Mon, 17 May 2021 17:29:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6E90561350
	for <linux-scsi@archiver.kernel.org>; Mon, 17 May 2021 17:29:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239703AbhEQRbA (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 17 May 2021 13:31:00 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:59718 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S236191AbhEQRa5 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 17 May 2021 13:30:57 -0400
Received: from pps.filterd (m0098393.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 14HH3I5j097803;
        Mon, 17 May 2021 13:29:37 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : references : content-type : in-reply-to : sender :
 content-transfer-encoding : mime-version; s=pp1;
 bh=c2qDlA5eVrjzu4P4I89ioLovfblAlNVeFP4UZzd8tGk=;
 b=pgohaN4IU0hltqZLGb447zm1L6Rm+mP3CdXv5kykDoUxM4rlcGJCl9GU1aUdeDzn1GBv
 iL8G22m5eFPT7zUPi8xjqwAFSxSpKeosh1GZBXlalDN05Rl0dpMVMi2tLRg3KgjYb7C/
 BxBpTotjNLj79/Lm53SZsoUshRp36O+e65WsOthcN1MLNI06Hd0oK9196UhDTE2h5mJm
 pl91LMOgutg0WprgFyLUWUGZDzOZkAY+G9kAn/OcSD3Gu9jlegi+g0Zp6uLQak7jBwhU
 xVJghkODNuRiCyLNDaYVs3LhIR5P5tluVSON5pkMlFOmpMuK3mcLQuO9H2NtL5gZMKW6 iQ== 
Received: from ppma04fra.de.ibm.com (6a.4a.5195.ip4.static.sl-reverse.com [149.81.74.106])
        by mx0a-001b2d01.pphosted.com with ESMTP id 38ksdrfgfu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 17 May 2021 13:29:37 -0400
Received: from pps.filterd (ppma04fra.de.ibm.com [127.0.0.1])
        by ppma04fra.de.ibm.com (8.16.0.43/8.16.0.43) with SMTP id 14HHQqmd011873;
        Mon, 17 May 2021 17:29:35 GMT
Received: from b06cxnps4075.portsmouth.uk.ibm.com (d06relay12.portsmouth.uk.ibm.com [9.149.109.197])
        by ppma04fra.de.ibm.com with ESMTP id 38j5x80jff-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 17 May 2021 17:29:35 +0000
Received: from d06av23.portsmouth.uk.ibm.com (d06av23.portsmouth.uk.ibm.com [9.149.105.59])
        by b06cxnps4075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 14HHTVbJ44237284
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 17 May 2021 17:29:31 GMT
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id D09F7A4051;
        Mon, 17 May 2021 17:29:31 +0000 (GMT)
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id BCC2EA404D;
        Mon, 17 May 2021 17:29:31 +0000 (GMT)
Received: from t480-pf1aa2c2.fritz.box (unknown [9.145.159.249])
        by d06av23.portsmouth.uk.ibm.com (Postfix) with ESMTPS;
        Mon, 17 May 2021 17:29:31 +0000 (GMT)
Received: from bblock by t480-pf1aa2c2.fritz.box with local (Exim 4.94.2)
        (envelope-from <bblock@linux.ibm.com>)
        id 1lih3b-000DmG-6a; Mon, 17 May 2021 19:29:31 +0200
Date:   Mon, 17 May 2021 19:29:31 +0200
From:   Benjamin Block <bblock@linux.ibm.com>
To:     Bart Van Assche <bvanassche@acm.org>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, Steffen Maier <maier@linux.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>
Subject: Re: [PATCH 10/50] zfcp: Use blk_req() instead of scsi_cmnd.request
Message-ID: <YKKn+/gzbeYaiV/M@t480-pf1aa2c2.linux.ibm.com>
References: <20210514213356.5264-1-bvanassche@acm.org>
 <20210514213356.5264-62-bvanassche@acm.org>
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <20210514213356.5264-62-bvanassche@acm.org>
Sender: Benjamin Block <bblock@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: zfrcNVxFBB0Er9qR9HVYKWHP99sZbna-
X-Proofpoint-GUID: zfrcNVxFBB0Er9qR9HVYKWHP99sZbna-
Content-Transfer-Encoding: 8bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.761
 definitions=2021-05-17_06:2021-05-17,2021-05-17 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 bulkscore=0 mlxlogscore=999
 suspectscore=0 mlxscore=0 adultscore=0 impostorscore=0 clxscore=1015
 malwarescore=0 phishscore=0 spamscore=0 lowpriorityscore=0
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104190000 definitions=main-2105170117
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Fri, May 14, 2021 at 02:33:16PM -0700, Bart Van Assche wrote:
> Prepare for removal of the request pointer by using blk_req() instead. This
> patch does not change any functionality.
> 
> Signed-off-by: Bart Van Assche <bvanassche@acm.org>
> ---
>  drivers/s390/scsi/zfcp_fsf.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/s390/scsi/zfcp_fsf.c b/drivers/s390/scsi/zfcp_fsf.c
> index 2e4804ef2fb9..ac9223a7677d 100644
> --- a/drivers/s390/scsi/zfcp_fsf.c
> +++ b/drivers/s390/scsi/zfcp_fsf.c
> @@ -2377,7 +2377,7 @@ static void zfcp_fsf_req_trace(struct zfcp_fsf_req *req, struct scsi_cmnd *scsi)
>  		}
>  	}
>  
> -	blk_add_driver_data(scsi->request, &blktrc, sizeof(blktrc));
> +	blk_add_driver_data(blk_req(scsi), &blktrc, sizeof(blktrc));
>  }
>  
>  /**

Looks good.

Acked-by: Benjamin Block <bblock@linux.ibm.com>


If you only rename `blk_req()`, like you suggested in the conversation
with Christoph, and nothing else changes, feel free to carry the
Acked-by over.

-- 
Best Regards, Benjamin Block  / Linux on IBM Z Kernel Development / IBM Systems
IBM Deutschland Research & Development GmbH    /    https://www.ibm.com/privacy
Vorsitz. AufsR.: Gregor Pillen         /        Geschäftsführung: Dirk Wittkopp
Sitz der Gesellschaft: Böblingen / Registergericht: AmtsG Stuttgart, HRB 243294
