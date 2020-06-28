Return-Path: <SRS0=bO3J=AJ=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_2 autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8CA73C433DF
	for <linux-scsi@archiver.kernel.org>; Sun, 28 Jun 2020 18:29:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 76B1E206BE
	for <linux-scsi@archiver.kernel.org>; Sun, 28 Jun 2020 18:29:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726613AbgF1S3J (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 28 Jun 2020 14:29:09 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:36572 "EHLO
        mx0b-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726060AbgF1S3I (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Sun, 28 Jun 2020 14:29:08 -0400
Received: from pps.filterd (m0127361.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 05SI2mPP184668;
        Sun, 28 Jun 2020 14:29:04 -0400
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 31xkqhx29u-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Sun, 28 Jun 2020 14:29:04 -0400
Received: from m0127361.ppops.net (m0127361.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 05SIIBo9026240;
        Sun, 28 Jun 2020 14:29:04 -0400
Received: from ppma03dal.us.ibm.com (b.bd.3ea9.ip4.static.sl-reverse.com [169.62.189.11])
        by mx0a-001b2d01.pphosted.com with ESMTP id 31xkqhx29p-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Sun, 28 Jun 2020 14:29:04 -0400
Received: from pps.filterd (ppma03dal.us.ibm.com [127.0.0.1])
        by ppma03dal.us.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 05SIKLg0031295;
        Sun, 28 Jun 2020 18:29:03 GMT
Received: from b03cxnp07028.gho.boulder.ibm.com (b03cxnp07028.gho.boulder.ibm.com [9.17.130.15])
        by ppma03dal.us.ibm.com with ESMTP id 31wwr84gf4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Sun, 28 Jun 2020 18:29:03 +0000
Received: from b03ledav004.gho.boulder.ibm.com (b03ledav004.gho.boulder.ibm.com [9.17.130.235])
        by b03cxnp07028.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 05SIT2e851773762
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sun, 28 Jun 2020 18:29:02 GMT
Received: from b03ledav004.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 1F5D378060;
        Sun, 28 Jun 2020 18:29:02 +0000 (GMT)
Received: from b03ledav004.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 34A3E7805C;
        Sun, 28 Jun 2020 18:29:01 +0000 (GMT)
Received: from [153.66.254.194] (unknown [9.85.161.191])
        by b03ledav004.gho.boulder.ibm.com (Postfix) with ESMTP;
        Sun, 28 Jun 2020 18:29:00 +0000 (GMT)
Message-ID: <1593368939.4487.13.camel@linux.ibm.com>
Subject: Re: [PATCH] scsi: scsi_transport_spi: fix function pointer check.
From:   James Bottomley <jejb@linux.ibm.com>
Reply-To: jejb@linux.ibm.com
To:     trix@redhat.com, martin.petersen@oracle.com
Cc:     linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Date:   Sun, 28 Jun 2020 11:28:59 -0700
In-Reply-To: <20200627133242.21618-1-trix@redhat.com>
References: <20200627133242.21618-1-trix@redhat.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.26.6 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.216,18.0.687
 definitions=2020-06-28_11:2020-06-26,2020-06-28 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxlogscore=999 bulkscore=0
 mlxscore=0 adultscore=0 clxscore=1015 phishscore=0 priorityscore=1501
 malwarescore=0 lowpriorityscore=0 suspectscore=0 cotscore=-2147483648
 spamscore=0 impostorscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2004280000 definitions=main-2006280136
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Sat, 2020-06-27 at 06:32 -0700, trix@redhat.com wrote:
> From: Tom Rix <trix@redhat.com>
> 
> clang static analysis flags several null function pointer problems.
> 
> drivers/scsi/scsi_transport_spi.c:374:1: warning: Called function
> pointer is null (null dereference) [core.CallAndMessage]
> spi_transport_max_attr(offset, "%d\n");
> ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
> 
> Reviewing the store_spi_store_max macro
> 
> 	if (i->f->set_##field)
> 		return -EINVAL;
> 
> should be
> 
> 	if (!i->f->set_##field)
> 		return -EINVAL;
> 
> Signed-off-by: Tom Rix <trix@redhat.com>

Fixes: 9b161a4d3e83 "[SCSI] scsi_transport_spi: convert to attribute groups")

Gosh that's an old bug ... clearly no-one is manually setting width or
offset.

Reviewed-by: James Bottomley <jejb@linux.ibm.com>

James


> ---
>  drivers/scsi/scsi_transport_spi.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/scsi/scsi_transport_spi.c
> b/drivers/scsi/scsi_transport_spi.c
> index f8661062ef95..f3d5b1bbd5aa 100644
> --- a/drivers/scsi/scsi_transport_spi.c
> +++ b/drivers/scsi/scsi_transport_spi.c
> @@ -339,7 +339,7 @@ store_spi_transport_##field(struct device *dev, 	
> 		\
>  	struct spi_transport_attrs *tp				
> 	\
>  		= (struct spi_transport_attrs *)&starget-
> >starget_data;	\
>  									
> \
> -	if (i->f->set_##field)					
> 	\
> +	if (!i->f->set_##field)					
> 	\
>  		return -EINVAL;					
> 	\
>  	val = simple_strtoul(buf, NULL, 0);				
> \
>  	if (val > tp->max_##field)					
> \

