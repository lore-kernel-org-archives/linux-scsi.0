Return-Path: <SRS0=1R64=74=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.2 required=3.0
	tests=HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_2
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0FCA3C433E0
	for <linux-scsi@archiver.kernel.org>; Mon, 15 Jun 2020 23:28:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EC56C20739
	for <linux-scsi@archiver.kernel.org>; Mon, 15 Jun 2020 23:28:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726808AbgFOX2T (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 15 Jun 2020 19:28:19 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:45262 "EHLO
        mx0b-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725960AbgFOX2S (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 15 Jun 2020 19:28:18 -0400
Received: from pps.filterd (m0127361.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 05FN4ATi146937;
        Mon, 15 Jun 2020 19:28:00 -0400
Received: from ppma01dal.us.ibm.com (83.d6.3fa9.ip4.static.sl-reverse.com [169.63.214.131])
        by mx0a-001b2d01.pphosted.com with ESMTP id 31p5euy0p2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 15 Jun 2020 19:27:59 -0400
Received: from pps.filterd (ppma01dal.us.ibm.com [127.0.0.1])
        by ppma01dal.us.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 05FNOWap032321;
        Mon, 15 Jun 2020 23:27:58 GMT
Received: from b03cxnp08026.gho.boulder.ibm.com (b03cxnp08026.gho.boulder.ibm.com [9.17.130.18])
        by ppma01dal.us.ibm.com with ESMTP id 31pckfm5ws-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 15 Jun 2020 23:27:58 +0000
Received: from b03ledav004.gho.boulder.ibm.com (b03ledav004.gho.boulder.ibm.com [9.17.130.235])
        by b03cxnp08026.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 05FNRtJQ25821592
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 15 Jun 2020 23:27:55 GMT
Received: from b03ledav004.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 929D578063;
        Mon, 15 Jun 2020 23:27:57 +0000 (GMT)
Received: from b03ledav004.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id BA57C7805C;
        Mon, 15 Jun 2020 23:27:55 +0000 (GMT)
Received: from jarvis (unknown [9.80.212.50])
        by b03ledav004.gho.boulder.ibm.com (Postfix) with ESMTP;
        Mon, 15 Jun 2020 23:27:55 +0000 (GMT)
Message-ID: <1592263673.7698.5.camel@linux.ibm.com>
Subject: Re: [PATCH] scsi: megaraid_sas: Use array_size() helper
From:   James Bottomley <jejb@linux.ibm.com>
Reply-To: jejb@linux.ibm.com
To:     "Gustavo A. R. Silva" <gustavoars@kernel.org>,
        Kashyap Desai <kashyap.desai@broadcom.com>,
        Sumit Saxena <sumit.saxena@broadcom.com>,
        Shivasharan S <shivasharan.srikanteshwara@broadcom.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     megaraidlinux.pdl@broadcom.com, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        "Gustavo A. R. Silva" <gustavo@embeddedor.com>
Date:   Mon, 15 Jun 2020 16:27:53 -0700
In-Reply-To: <20200615214718.GA6970@embeddedor>
References: <20200615214718.GA6970@embeddedor>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.26.6 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.216,18.0.687
 definitions=2020-06-15_11:2020-06-15,2020-06-15 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 cotscore=-2147483648
 adultscore=0 mlxlogscore=999 mlxscore=0 priorityscore=1501 phishscore=0
 lowpriorityscore=0 impostorscore=0 clxscore=1011 malwarescore=0
 suspectscore=0 bulkscore=0 spamscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2004280000 definitions=main-2006150160
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Mon, 2020-06-15 at 16:47 -0500, Gustavo A. R. Silva wrote:
> The get_order() function has no 2-factor argument form, so
> multiplication
> factors need to be wrapped in array_size().
> 
> This issue was found with the help of Coccinelle and, audited and
> fixed
> manually.
> 
> Addresses-KSPP-ID: https://github.com/KSPP/linux/issues/83
> Signed-off-by: Gustavo A. R. Silva <gustavoars@kernel.org>
> ---
>  drivers/scsi/megaraid/megaraid_sas_fusion.c | 8 ++++----
>  1 file changed, 4 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/scsi/megaraid/megaraid_sas_fusion.c
> b/drivers/scsi/megaraid/megaraid_sas_fusion.c
> index 319f241da4b6..6de44ed4cde7 100644
> --- a/drivers/scsi/megaraid/megaraid_sas_fusion.c
> +++ b/drivers/scsi/megaraid/megaraid_sas_fusion.c
> @@ -5180,8 +5180,8 @@ megasas_alloc_fusion_context(struct
> megasas_instance *instance)
>  
>  	fusion = instance->ctrl_context;
>  
> -	fusion->log_to_span_pages = get_order(MAX_LOGICAL_DRIVES_EXT
> *
> -					      sizeof(LD_SPAN_INFO));
> +	fusion->log_to_span_pages =
> get_order(array_size(MAX_LOGICAL_DRIVES_EXT,
> +					      sizeof(LD_SPAN_INFO)))
> ;

What's the point of this?  You're replacing a constant multiplication
the compiler can compute with one it can't on the theory there might be
an overflow, which is pretty far fetched given MAX_LOGICAL_DRIVES_EXT
is 256 and sizeof(LD_SPAN_INFO) is around 82.

I thought the whole point of overflow detection was to use it for
instances where we could be tricked into triggering one by userspace
which may result in a buffer under or overflow ... this is two
constants, how could this ever be a source of an exploit?

James

