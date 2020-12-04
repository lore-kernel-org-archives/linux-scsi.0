Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 81D67C4361A
	for <linux-scsi@archiver.kernel.org>; Fri,  4 Dec 2020 13:11:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2EE9D22AAC
	for <linux-scsi@archiver.kernel.org>; Fri,  4 Dec 2020 13:11:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727004AbgLDNLU (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 4 Dec 2020 08:11:20 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:22552 "EHLO
        mx0b-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728066AbgLDNLU (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 4 Dec 2020 08:11:20 -0500
Received: from pps.filterd (m0098421.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0B4D4n5B195101;
        Fri, 4 Dec 2020 08:10:31 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : references : mime-version : content-type :
 content-transfer-encoding : in-reply-to : sender; s=pp1;
 bh=2re6ZhL9EGLPSFOa590Lhw2IyMBxMx3ZD3FeOmRe8MY=;
 b=Qij7k718Wvfq/xB/TWTEa/rksnoPV1vp3bs7kBbrVEW337GF5WHxt4ilx4lzpXW6b9SY
 rexw8GV1JXQh7S+kLRbcGHlk+DFeO3OcxzDCW2t1Zk4qHe5zD6ItR1CwhFdi15Ftj65i
 lfDAuZSVDqWzvsxKI2cqhwZmH9O67S+/baiJKhnerWfKST/Ro+r/Kcx5LfcfszBnLK/t
 IwKDJSF/6hcGAi4li7a8b36jctYRGBm0fYhThkBSeOg29SaAmOtyH8hcb1FMi3wolG/y
 /YNX/JWZs9NNrQ7bj7MTaNZWguOMqTqGRUb1sqdprh/gwXniHv1YNUqzS/n5XuuoXUry vQ== 
Received: from ppma06ams.nl.ibm.com (66.31.33a9.ip4.static.sl-reverse.com [169.51.49.102])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3578ammqjp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 04 Dec 2020 08:10:31 -0500
Received: from pps.filterd (ppma06ams.nl.ibm.com [127.0.0.1])
        by ppma06ams.nl.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 0B4Cmt1l000372;
        Fri, 4 Dec 2020 13:10:29 GMT
Received: from b06cxnps4076.portsmouth.uk.ibm.com (d06relay13.portsmouth.uk.ibm.com [9.149.109.198])
        by ppma06ams.nl.ibm.com with ESMTP id 354fpdd1rs-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 04 Dec 2020 13:10:29 +0000
Received: from d06av26.portsmouth.uk.ibm.com (d06av26.portsmouth.uk.ibm.com [9.149.105.62])
        by b06cxnps4076.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 0B4DARlk7930530
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 4 Dec 2020 13:10:27 GMT
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 01C81AE057;
        Fri,  4 Dec 2020 13:10:27 +0000 (GMT)
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id CF14FAE056;
        Fri,  4 Dec 2020 13:10:25 +0000 (GMT)
Received: from t480-pf1aa2c2 (unknown [9.145.180.48])
        by d06av26.portsmouth.uk.ibm.com (Postfix) with ESMTPS;
        Fri,  4 Dec 2020 13:10:25 +0000 (GMT)
Received: from bblock by t480-pf1aa2c2 with local (Exim 4.94)
        (envelope-from <bblock@linux.ibm.com>)
        id 1klAqJ-000F08-NN; Fri, 04 Dec 2020 14:09:47 +0100
Date:   Fri, 4 Dec 2020 14:09:36 +0100
From:   Benjamin Block <bblock@linux.ibm.com>
To:     Hannes Reinecke <hare@suse.de>
Cc:     "Martin K. Petersen" <martin.petersen@oracle.com>,
        Christoph Hellwig <hch@lst.de>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        linux-scsi@vger.kernel.org
Subject: Re: [PATCH 14/37] zfcp: do not set COMMAND_COMPLETE
Message-ID: <20201204130936.GA7858@t480-pf1aa2c2>
References: <20201204100140.140863-1-hare@suse.de>
 <20201204100140.140863-15-hare@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20201204100140.140863-15-hare@suse.de>
Sender: Benjamin Block <bblock@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.312,18.0.737
 definitions=2020-12-04_04:2020-12-04,2020-12-04 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 suspectscore=0 phishscore=0
 adultscore=0 mlxlogscore=999 spamscore=0 impostorscore=0
 priorityscore=1501 lowpriorityscore=0 malwarescore=0 mlxscore=0
 clxscore=1011 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2012040075
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Fri, Dec 04, 2020 at 11:01:17AM +0100, Hannes Reinecke wrote:
> COMMAND_COMPLETE is defined as '0', and it is a SCSI parallel message
> to boot. So drop the call to set_msg_byte().
> 
> Signed-off-by: Hannes Reinecke <hare@suse.de>
> ---
>  drivers/s390/scsi/zfcp_fc.h | 1 -
>  1 file changed, 1 deletion(-)
> 
> diff --git a/drivers/s390/scsi/zfcp_fc.h b/drivers/s390/scsi/zfcp_fc.h
> index 6902ae1f8e4f..8aaf409ce9cb 100644
> --- a/drivers/s390/scsi/zfcp_fc.h
> +++ b/drivers/s390/scsi/zfcp_fc.h
> @@ -275,7 +275,6 @@ void zfcp_fc_eval_fcp_rsp(struct fcp_resp_with_ext *fcp_rsp,
>  	u32 sense_len, resid;
>  	u8 rsp_flags;
>  
> -	set_msg_byte(scsi, COMMAND_COMPLETE);
>  	scsi->result |= fcp_rsp->resp.fr_status;
>  
>  	rsp_flags = fcp_rsp->resp.fr_flags;
> -- 
> 2.16.4
> 

Thanks, Hannes.

Acked-by: Benjamin Block <bblock@linux.ibm.com>

-- 
Best Regards, Benjamin Block  / Linux on IBM Z Kernel Development / IBM Systems
IBM Deutschland Research & Development GmbH    /    https://www.ibm.com/privacy
Vorsitz. AufsR.: Gregor Pillen         /        Geschäftsführung: Dirk Wittkopp
Sitz der Gesellschaft: Böblingen / Registergericht: AmtsG Stuttgart, HRB 243294
