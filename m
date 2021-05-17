Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CB26AC433B4
	for <linux-scsi@archiver.kernel.org>; Mon, 17 May 2021 17:23:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id ACD3360FDB
	for <linux-scsi@archiver.kernel.org>; Mon, 17 May 2021 17:23:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236778AbhEQRYm (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 17 May 2021 13:24:42 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:4832 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S230248AbhEQRYi (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 17 May 2021 13:24:38 -0400
Received: from pps.filterd (m0098413.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 14HH2u9c173133;
        Mon, 17 May 2021 13:23:17 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : references : content-type : in-reply-to : sender :
 content-transfer-encoding : mime-version; s=pp1;
 bh=0ZOA774XlyociALIfksmcYoxaQ0wWiUekrHXa1liAZo=;
 b=ErP6dmbNR2MepGGdtlfAyjLMyWnsr+A1ngQvp9jhPVcg1T10lnUAwcXHWvo1ds+fjJFT
 hvDFn3mZkrkUpummIkfY5AV809TrfQPoE8AWNmPA5btO3tZeB+1Rpwa2705ULYc8YQGp
 Z7now1k0VZNiPY4f9w3rqhwpG4ZOhE3IcO82ynPAWytL4lHsno7qSZCbRN2nOnf69tu9
 aDmaP3oBVt1LI7GQ6NdjWc5GqnhCbKxC0NOkr1z4SOqdkzTepCwv1TG7LB1YjXxrI/CR
 9ILWy6GHOE30V9nSNzMaUgjO4B9DF9QI1PQu0PfYBqglkK6qKpXFEVlnCB1LtddC+YYC Rw== 
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0b-001b2d01.pphosted.com with ESMTP id 38kvf2rrjh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 17 May 2021 13:23:17 -0400
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.16.0.43/8.16.0.43) with SMTP id 14HHFqG1027535;
        Mon, 17 May 2021 17:23:16 GMT
Received: from b06avi18878370.portsmouth.uk.ibm.com (b06avi18878370.portsmouth.uk.ibm.com [9.149.26.194])
        by ppma03ams.nl.ibm.com with ESMTP id 38j5x7s0v7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 17 May 2021 17:23:15 +0000
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (b06wcsmtp001.portsmouth.uk.ibm.com [9.149.105.160])
        by b06avi18878370.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 14HHMkFE20709820
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 17 May 2021 17:22:46 GMT
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 9DC75A405C;
        Mon, 17 May 2021 17:23:13 +0000 (GMT)
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 8A3AAA405B;
        Mon, 17 May 2021 17:23:13 +0000 (GMT)
Received: from t480-pf1aa2c2.fritz.box (unknown [9.145.159.249])
        by b06wcsmtp001.portsmouth.uk.ibm.com (Postfix) with ESMTPS;
        Mon, 17 May 2021 17:23:13 +0000 (GMT)
Received: from bblock by t480-pf1aa2c2.fritz.box with local (Exim 4.94.2)
        (envelope-from <bblock@linux.ibm.com>)
        id 1ligxV-000Dhb-0l; Mon, 17 May 2021 19:23:13 +0200
Date:   Mon, 17 May 2021 19:23:12 +0200
From:   Benjamin Block <bblock@linux.ibm.com>
To:     Bart Van Assche <bvanassche@acm.org>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>,
        Jaegeuk Kim <jaegeuk@kernel.org>, linux-scsi@vger.kernel.org
Subject: Re: [PATCH v3 3/8] zfcp: Use scsi_get_sector() instead of
 scsi_get_lba()
Message-ID: <YKKmgJ/O5zGTHZeh@t480-pf1aa2c2.linux.ibm.com>
References: <20210513223757.3938-1-bvanassche@acm.org>
 <20210513223757.3938-4-bvanassche@acm.org>
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <20210513223757.3938-4-bvanassche@acm.org>
Sender: Benjamin Block <bblock@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: 0p1AdZHATGaUqQyb-3j7MvmVuZfCfvON
X-Proofpoint-GUID: 0p1AdZHATGaUqQyb-3j7MvmVuZfCfvON
Content-Transfer-Encoding: 8bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.761
 definitions=2021-05-17_06:2021-05-17,2021-05-17 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 adultscore=0 mlxlogscore=999
 bulkscore=0 suspectscore=0 spamscore=0 clxscore=1011 priorityscore=1501
 impostorscore=0 phishscore=0 lowpriorityscore=0 mlxscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104190000
 definitions=main-2105170117
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Thu, May 13, 2021 at 03:37:52PM -0700, Bart Van Assche wrote:
> Use scsi_get_sector() instead of scsi_get_lba() since the name of the
> latter is confusing. Additionally, use lower_32_bits() instead of
> open-coding it. This patch does not change any functionality.
> 
> Cc: Benjamin Block <bblock@linux.ibm.com>
> Signed-off-by: Bart Van Assche <bvanassche@acm.org>
> ---
>  drivers/s390/scsi/zfcp_fsf.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/s390/scsi/zfcp_fsf.c b/drivers/s390/scsi/zfcp_fsf.c
> index 2e4804ef2fb9..3d9a3dc4975b 100644
> --- a/drivers/s390/scsi/zfcp_fsf.c
> +++ b/drivers/s390/scsi/zfcp_fsf.c
> @@ -2600,7 +2600,7 @@ int zfcp_fsf_fcp_cmnd(struct scsi_cmnd *scsi_cmnd)
>  
>  	if (scsi_get_prot_op(scsi_cmnd) != SCSI_PROT_NORMAL) {
>  		io->data_block_length = scsi_cmnd->device->sector_size;
> -		io->ref_tag_value = scsi_get_lba(scsi_cmnd) & 0xFFFFFFFF;
> +		io->ref_tag_value = lower_32_bits(scsi_get_sector(scsi_cmnd));
>  	}
>  
>  	if (zfcp_fsf_set_data_dir(scsi_cmnd, &io->data_direction))

Looks good.

Acked-by: Benjamin Block <bblock@linux.ibm.com>

-- 
Best Regards, Benjamin Block  / Linux on IBM Z Kernel Development / IBM Systems
IBM Deutschland Research & Development GmbH    /    https://www.ibm.com/privacy
Vorsitz. AufsR.: Gregor Pillen         /        Geschäftsführung: Dirk Wittkopp
Sitz der Gesellschaft: Böblingen / Registergericht: AmtsG Stuttgart, HRB 243294
