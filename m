Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3C29AC433F5
	for <linux-scsi@archiver.kernel.org>; Sat, 11 Sep 2021 00:44:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0A06B61209
	for <linux-scsi@archiver.kernel.org>; Sat, 11 Sep 2021 00:44:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234978AbhIKApa (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 10 Sep 2021 20:45:30 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:13060 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S234957AbhIKAp3 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 10 Sep 2021 20:45:29 -0400
Received: from pps.filterd (m0098420.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 18B0YXR4070675;
        Fri, 10 Sep 2021 20:44:15 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : subject :
 from : reply-to : to : cc : date : in-reply-to : references : content-type
 : mime-version : content-transfer-encoding; s=pp1;
 bh=Js1G9fMr3SLMbQiFtn4J8goD659dYmd+lck4/iDCLfo=;
 b=WQZMGP8DLI+VLlHAUFGY/Oav+PVl0V+iTheYQ73tl6cEkidlidKCo7lBuMwLGDwSi4GP
 mkmXjY8Qg+EtnoaX4++gp91mIZG9xdblMJ7zqmSCX0HHLVfm5E4lKRH97nZF0LA9LtW4
 eOt4TIFlxxoqbXepIazqEh/N7rp5XCBwxJhcTBuV+fZVK3izGVVEcfVoBkcsqvzgEKZp
 mzgwbIwCFY2DI+uv/O0SQJg2g3UDY3XyMis1IPYsb+SQ1DDBOgSrbV8JSX8ilFXfxDE/
 Ik4ridaCxup2UK++XR5TEkiqNeRkW7sXx2aFmh2D7Dttv1pS1wyg7gNOMKCPaWYbigtj VQ== 
Received: from ppma02dal.us.ibm.com (a.bd.3ea9.ip4.static.sl-reverse.com [169.62.189.10])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3b0577fkyr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 10 Sep 2021 20:44:14 -0400
Received: from pps.filterd (ppma02dal.us.ibm.com [127.0.0.1])
        by ppma02dal.us.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 18B0cMfE022968;
        Sat, 11 Sep 2021 00:44:14 GMT
Received: from b03cxnp07029.gho.boulder.ibm.com (b03cxnp07029.gho.boulder.ibm.com [9.17.130.16])
        by ppma02dal.us.ibm.com with ESMTP id 3aytnewe97-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Sat, 11 Sep 2021 00:44:14 +0000
Received: from b03ledav004.gho.boulder.ibm.com (b03ledav004.gho.boulder.ibm.com [9.17.130.235])
        by b03cxnp07029.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 18B0iCC948628158
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 11 Sep 2021 00:44:12 GMT
Received: from b03ledav004.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 7F9B078060;
        Sat, 11 Sep 2021 00:44:12 +0000 (GMT)
Received: from b03ledav004.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id D039C7805F;
        Sat, 11 Sep 2021 00:44:11 +0000 (GMT)
Received: from jarvis.int.hansenpartnership.com (unknown [9.211.143.40])
        by b03ledav004.gho.boulder.ibm.com (Postfix) with ESMTP;
        Sat, 11 Sep 2021 00:44:11 +0000 (GMT)
Message-ID: <b73451e25a3f7881fb507500cb6bc0eae63f605b.camel@linux.ibm.com>
Subject: Re: [PATCH V2 1/1] scsi/ses: Saw "Failed to get diagnostic page 0x1"
From:   James Bottomley <jejb@linux.ibm.com>
Reply-To: jejb@linux.ibm.com
To:     wenxiong@linux.vnet.ibm.com
Cc:     linux-scsi@vger.kernel.org, brking1@linux.vnet.ibm.com,
        martin.petersen@oracle.com, wenxiong@us.ibm.com,
        Wen Xiong <root@ltczz405-lp2.aus.stglabs.ibm.com>
Date:   Fri, 10 Sep 2021 17:44:10 -0700
In-Reply-To: <1631300645-27662-1-git-send-email-wenxiong@linux.vnet.ibm.com>
References: <1631300645-27662-1-git-send-email-wenxiong@linux.vnet.ibm.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.34.4 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: 8RP4usOzIKsIqEwkqkKe43V_bO6fZlti
X-Proofpoint-ORIG-GUID: 8RP4usOzIKsIqEwkqkKe43V_bO6fZlti
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.790
 definitions=2021-09-10_09:2021-09-09,2021-09-10 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015
 priorityscore=1501 mlxlogscore=999 bulkscore=0 adultscore=0 malwarescore=0
 spamscore=0 suspectscore=0 mlxscore=0 phishscore=0 impostorscore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2109030001 definitions=main-2109110000
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Fri, 2021-09-10 at 14:04 -0500, wenxiong@linux.vnet.ibm.com wrote:
> From: Wen Xiong <root@ltczz405-lp2.aus.stglabs.ibm.com>
> 
> We saw two errors with Slider drawer:
> - Failed to get diagnostic page 0x1 during booting up
> - /sys/class/enclosure is empty with ipr adapter + Slider drawer
> 
> From scsi logging level with error=3, looks ses_recv_diag not try on
> a UA. The patch addes retrying on a UA in ses_recv_diag();

Do we know why the device is returning a UA?  Presumably it's a check
condition UA meaning the device is trying to tell us something and
wants us to request sense?

> Signed-Off-by: Wen Xiong<wenxiong@linux.vnet.ibm.com>
> Reviewed-by: Brian King <brking@linux.vnet.ibm.com>
> ---
>  drivers/scsi/ses.c | 11 +++++++++--
>  1 file changed, 9 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/scsi/ses.c b/drivers/scsi/ses.c
> index c2afba2a5414..93f6a8ce1bea 100644
> --- a/drivers/scsi/ses.c
> +++ b/drivers/scsi/ses.c
> @@ -87,9 +87,16 @@ static int ses_recv_diag(struct scsi_device *sdev,
> int page_code,
>  		0
>  	};
>  	unsigned char recv_page_code;
> +	struct scsi_sense_hdr sshdr;
> +	int retries = SES_RETRIES;
> +
> +	do {
> +		ret =  scsi_execute_req(sdev, cmd, DMA_FROM_DEVICE,
> buf,
> +			bufflen, &sshdr, NULL, SES_TIMEOUT, 

This grew an additional argument: you want to replace the NULL with the
sshdr, I think ... and compile test it next time.

> SES_RETRIES, NULL);

I think you want a 1 here instead of SES_RETRIES because you're
retrying for SES_RETRIES in an outer loop now, so if you maxed out both
sets of retries, you'd retry for SES_RETRIES^2.

If this is a CC/UA, you can simplify all this by setting

cmd->expecting_cc_ua = 1

and avoiding the loop.

James


