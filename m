Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D32C5C48BE6
	for <linux-scsi@archiver.kernel.org>; Mon, 14 Jun 2021 14:48:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BC79561350
	for <linux-scsi@archiver.kernel.org>; Mon, 14 Jun 2021 14:48:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233104AbhFNOvA (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 14 Jun 2021 10:51:00 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:5260 "EHLO
        mx0b-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232875AbhFNOvA (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 14 Jun 2021 10:51:00 -0400
Received: from pps.filterd (m0098417.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 15EEZw4A178385;
        Mon, 14 Jun 2021 10:48:49 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : references : content-type : in-reply-to : sender :
 content-transfer-encoding : mime-version; s=pp1;
 bh=/d/wdRwjj9btLmpjVH77lJhRJTTe/30I2iLFAs+CFjY=;
 b=fHTMvBfZnPTW1uExQSQo8C8TbUx5fwSeFbZWBXScgfJcrkFE7JiORZwP0AhWQwstIgLW
 n6FuCMe0QSNsdtbueJNpuQUdU7womSSltXcHyW+IIu4kANP83QIG2bihte0HYs5XaUI6
 S7nJ1ra2Olle3u5kniKjy3lXrVx6VFj4efB+/A1kYHk6jI1YoRZNdUseNYa0MUeI5eDd
 tJ8wwgw7PEZSPaKLtejH8m3/HU7yVcE+9u1c1wk+OKd4l2tLeMcZk800Ln/eFniCcC5Y
 1LL6BxNCwixb5D1U9CL4mssVh+B+rUxej0taAZR+4BI8DySMYY5X1TjpiuBbkaV8w5Mx +g== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3966xs4x7h-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 14 Jun 2021 10:48:49 -0400
Received: from m0098417.ppops.net (m0098417.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 15EEZdZ9176707;
        Mon, 14 Jun 2021 10:48:49 -0400
Received: from ppma06ams.nl.ibm.com (66.31.33a9.ip4.static.sl-reverse.com [169.51.49.102])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3966xs4x6k-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 14 Jun 2021 10:48:48 -0400
Received: from pps.filterd (ppma06ams.nl.ibm.com [127.0.0.1])
        by ppma06ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 15EEmRmo020962;
        Mon, 14 Jun 2021 14:48:47 GMT
Received: from b06cxnps4075.portsmouth.uk.ibm.com (d06relay12.portsmouth.uk.ibm.com [9.149.109.197])
        by ppma06ams.nl.ibm.com with ESMTP id 394m6hs0ue-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 14 Jun 2021 14:48:47 +0000
Received: from d06av21.portsmouth.uk.ibm.com (d06av21.portsmouth.uk.ibm.com [9.149.105.232])
        by b06cxnps4075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 15EEmikg33948098
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 14 Jun 2021 14:48:44 GMT
Received: from d06av21.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id A9D2B52051;
        Mon, 14 Jun 2021 14:48:44 +0000 (GMT)
Received: from t480-pf1aa2c2 (unknown [9.145.174.2])
        by d06av21.portsmouth.uk.ibm.com (Postfix) with ESMTPS id 9684C52050;
        Mon, 14 Jun 2021 14:48:44 +0000 (GMT)
Received: from bblock by t480-pf1aa2c2 with local (Exim 4.94.2)
        (envelope-from <bblock@linux.ibm.com>)
        id 1lsntM-001ICF-3d; Mon, 14 Jun 2021 16:48:44 +0200
Date:   Mon, 14 Jun 2021 16:48:44 +0200
From:   Benjamin Block <bblock@linux.ibm.com>
To:     "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Christoph Hellwig <hch@lst.de>, Ming Lei <ming.lei@redhat.com>,
        Hannes Reinecke <hare@suse.de>,
        Damien Le Moal <damien.lemoal@wdc.com>
Subject: Re: [PATCH 10/15] scsi: core: Introduce scsi_get_sector()
Message-ID: <YMdsTOpT3a4TA3E5@t480-pf1aa2c2.linux.ibm.com>
References: <20210609033929.3815-1-martin.petersen@oracle.com>
 <20210609033929.3815-11-martin.petersen@oracle.com>
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <20210609033929.3815-11-martin.petersen@oracle.com>
Sender: Benjamin Block <bblock@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: rC4n6nquubaaX3TZz0ytjfr_vWxhm3Zj
X-Proofpoint-ORIG-GUID: 9QXaqti-SOpyK6j4q6jS0P2WVhNchwX9
Content-Transfer-Encoding: 8bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.761
 definitions=2021-06-14_09:2021-06-14,2021-06-14 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0 mlxscore=0
 adultscore=0 clxscore=1011 priorityscore=1501 phishscore=0 mlxlogscore=999
 malwarescore=0 lowpriorityscore=0 spamscore=0 bulkscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104190000
 definitions=main-2106140095
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Tue, Jun 08, 2021 at 11:39:24PM -0400, Martin K. Petersen wrote:
> From: Bart Van Assche <bvanassche@acm.org>
> 
> Since scsi_get_lba() returns a sector_t value instead of the LBA, the name
> of that function is confusing. Introduce an identical function
> scsi_get_sector().
> 
> Link: https://lore.kernel.org/r/20210513223757.3938-2-bvanassche@acm.org
> Cc: Christoph Hellwig <hch@lst.de>
> Cc: Ming Lei <ming.lei@redhat.com>
> Cc: Hannes Reinecke <hare@suse.de>
> Reviewed-by: Damien Le Moal <damien.lemoal@wdc.com>
> Signed-off-by: Bart Van Assche <bvanassche@acm.org>
> Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
> ---
>  include/scsi/scsi_cmnd.h | 5 +++++
>  1 file changed, 5 insertions(+)
> 
> diff --git a/include/scsi/scsi_cmnd.h b/include/scsi/scsi_cmnd.h
> index 301b9cd4ddd0..cba63377d46a 100644
> --- a/include/scsi/scsi_cmnd.h
> +++ b/include/scsi/scsi_cmnd.h
> @@ -220,6 +220,11 @@ static inline int scsi_sg_copy_to_buffer(struct scsi_cmnd *cmd,
>  				 buf, buflen);
>  }
>  
> +static inline sector_t scsi_get_sector(struct scsi_cmnd *scmd)
> +{
> +	return blk_rq_pos(scmd->request);

Wondering a bit why this still uses the request pointer, after you say
in patch 01 that it goes away. So it should probably use
`blk_mq_rq_from_pdu()`?


-- 
Best Regards, Benjamin Block  / Linux on IBM Z Kernel Development / IBM Systems
IBM Deutschland Research & Development GmbH    /    https://www.ibm.com/privacy
Vorsitz. AufsR.: Gregor Pillen         /        Geschäftsführung: Dirk Wittkopp
Sitz der Gesellschaft: Böblingen / Registergericht: AmtsG Stuttgart, HRB 243294
