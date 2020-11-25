Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5C6E9C56202
	for <linux-scsi@archiver.kernel.org>; Wed, 25 Nov 2020 17:07:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 126EB21D7F
	for <linux-scsi@archiver.kernel.org>; Wed, 25 Nov 2020 17:07:36 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="JiqWRQ60"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732633AbgKYRHT (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 25 Nov 2020 12:07:19 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:33246 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1730293AbgKYRHT (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 25 Nov 2020 12:07:19 -0500
Received: from pps.filterd (m0098393.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0APH2VtP006630;
        Wed, 25 Nov 2020 12:07:04 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : references : mime-version : content-type :
 content-transfer-encoding : in-reply-to : sender; s=pp1;
 bh=Ncy3un7Mk9a3HgaKgU8ECzla06RPArkUvrBxSyMW5XY=;
 b=JiqWRQ60w9cLeWy2x6vGrY7NghfRzqVmMbhO7bX0PiXjJeKgzlbC8I5zZlY2y8Nj/boH
 8YBKACvOPWNprD8LySyw1e7387fWZa2l5QTbEptoamAfmBgKL3Oc43oWxh+OTr46cFUG
 2KFORErbyAGPqzW2+5JbMf7kSIqydZaZKaUaEUhdEQaKewdcM/32iGWtX3fAAhxEQ0Kf
 n9aYkyINkrhNbz8JfI1LhX2XxfyZfFItUoXXObLu56SPGld+UpMAzFKqCThXQDZdSbkG
 YavD23vpflCN0EQandNmrZ+Lzt4tcZgN/DLqjVX2WHcgAzVSTwmPkj8Qexdbck207sFz /Q== 
Received: from ppma06ams.nl.ibm.com (66.31.33a9.ip4.static.sl-reverse.com [169.51.49.102])
        by mx0a-001b2d01.pphosted.com with ESMTP id 351u5q8dsm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 25 Nov 2020 12:07:04 -0500
Received: from pps.filterd (ppma06ams.nl.ibm.com [127.0.0.1])
        by ppma06ams.nl.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 0APH2qlK010586;
        Wed, 25 Nov 2020 17:07:02 GMT
Received: from b06cxnps4074.portsmouth.uk.ibm.com (d06relay11.portsmouth.uk.ibm.com [9.149.109.196])
        by ppma06ams.nl.ibm.com with ESMTP id 34xt5hcw10-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 25 Nov 2020 17:07:02 +0000
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06cxnps4074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 0APH6x7M18874716
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 25 Nov 2020 17:06:59 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 966704C04E;
        Wed, 25 Nov 2020 17:06:59 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 843324C040;
        Wed, 25 Nov 2020 17:06:59 +0000 (GMT)
Received: from t480-pf1aa2c2 (unknown [9.145.2.194])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with ESMTPS;
        Wed, 25 Nov 2020 17:06:59 +0000 (GMT)
Received: from bblock by t480-pf1aa2c2 with local (Exim 4.94)
        (envelope-from <bblock@linux.ibm.com>)
        id 1khyFu-002ZXe-FD; Wed, 25 Nov 2020 18:06:58 +0100
Date:   Wed, 25 Nov 2020 18:06:58 +0100
From:   Benjamin Block <bblock@linux.ibm.com>
To:     Qinglang Miao <miaoqinglang@huawei.com>
Cc:     Steffen Maier <maier@linux.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-scsi@vger.kernel.org
Subject: Re: [PATCH] scsi: zfcp: fix use-after-free in zfcp_unit_remove
Message-ID: <20201125170658.GB8578@t480-pf1aa2c2>
References: <20201120074854.31754-1-miaoqinglang@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20201120074854.31754-1-miaoqinglang@huawei.com>
Sender: Benjamin Block <bblock@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.312,18.0.737
 definitions=2020-11-25_10:2020-11-25,2020-11-25 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 phishscore=0 mlxlogscore=946
 suspectscore=0 malwarescore=0 clxscore=1015 impostorscore=0
 priorityscore=1501 bulkscore=0 adultscore=0 mlxscore=0 lowpriorityscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2011250104
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Fri, Nov 20, 2020 at 03:48:54PM +0800, Qinglang Miao wrote:
> kfree(port) is called in put_device(&port->dev) so that following
> use would cause use-after-free bug.
> 
> The former put_device is redundant for device_unregister contains
> put_device already. So just remove it to fix this.
> 
> Fixes: 86bdf218a717 ("[SCSI] zfcp: cleanup unit sysfs attribute usage")
> Reported-by: Hulk Robot <hulkci@huawei.com>
> Signed-off-by: Qinglang Miao <miaoqinglang@huawei.com>
> ---
>  drivers/s390/scsi/zfcp_unit.c | 2 --
>  1 file changed, 2 deletions(-)
> 
> diff --git a/drivers/s390/scsi/zfcp_unit.c b/drivers/s390/scsi/zfcp_unit.c
> index e67bf7388..664b77853 100644
> --- a/drivers/s390/scsi/zfcp_unit.c
> +++ b/drivers/s390/scsi/zfcp_unit.c
> @@ -255,8 +255,6 @@ int zfcp_unit_remove(struct zfcp_port *port, u64 fcp_lun)
>  		scsi_device_put(sdev);
>  	}
>  
> -	put_device(&unit->dev);
> -
>  	device_unregister(&unit->dev);
>  
>  	return 0;

Same as in the other mail for `zfcp_sysfs_port_remove_store()`. We
explicitly get a new ref in `_zfcp_unit_find()`, so we also need to put
that away again.

-- 
Best Regards, Benjamin Block  / Linux on IBM Z Kernel Development / IBM Systems
IBM Deutschland Research & Development GmbH    /    https://www.ibm.com/privacy
Vorsitz. AufsR.: Gregor Pillen         /        Geschäftsführung: Dirk Wittkopp
Sitz der Gesellschaft: Böblingen / Registergericht: AmtsG Stuttgart, HRB 243294
