Return-Path: <SRS0=XwCY=DP=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	UNWANTED_LANGUAGE_BODY autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7F173C433E7
	for <linux-scsi@archiver.kernel.org>; Thu,  8 Oct 2020 02:56:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 241182168B
	for <linux-scsi@archiver.kernel.org>; Thu,  8 Oct 2020 02:56:19 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="kgQW9ylG"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728008AbgJHC4S (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 7 Oct 2020 22:56:18 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:46628 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726181AbgJHC4R (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 7 Oct 2020 22:56:17 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0982spJ6124447;
        Thu, 8 Oct 2020 02:56:05 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : mime-version :
 content-type; s=corp-2020-01-29;
 bh=qPWEwYH8MZQoaH85J/TUo2qvS1GOm+LqlXsK1d9O+U0=;
 b=kgQW9ylGE3h7JI3XIT99WeLDlCmWX/kApMMs3tWyEagruPggOEU4i6bn5YLPvqY0KXT1
 vmUFrNq0yAMmQLIUAx3cWwH2iNwL6qgeTyEZEqjwPRopXugzwUDvDodfu5YjKKMwSX7m
 ts3LRl3bdOPQYPq/kMBdZaG3yUADHAQS5suehEvQSGcIv599IybyPZNqV1sQCniDHz2c
 aBtGDIIeKqcQavLm5oY4Z3kZMngwZuA8GTFO3z/CpNeH00o4MdCRBfKTD1qTsLZp+E7B
 2j22OjQdRLOpjO/R1EtS+Od/aNq2fUsF9DjArgY7j48GczPxjKHro257TAf2VaV8GG/T aA== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2120.oracle.com with ESMTP id 33ym34tacs-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Thu, 08 Oct 2020 02:56:05 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0982suUt032183;
        Thu, 8 Oct 2020 02:56:05 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3020.oracle.com with ESMTP id 3410k0dtbv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 08 Oct 2020 02:56:05 +0000
Received: from abhmp0020.oracle.com (abhmp0020.oracle.com [141.146.116.26])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 0982u2GM026895;
        Thu, 8 Oct 2020 02:56:02 GMT
Received: from ca-mkp.ca.oracle.com (/10.159.214.123)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 07 Oct 2020 19:56:02 -0700
To:     Ye Bin <yebin10@huawei.com>
Cc:     <linuxdrivers@attotech.com>, <linux-scsi@vger.kernel.org>,
        Hulk Robot <hulkci@huawei.com>
Subject: Re: [PATCH] scsi: esas2r: Fix inconsistent of format with argument
 type
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq1362pxwah.fsf@ca-mkp.ca.oracle.com>
References: <20200930021527.2831077-1-yebin10@huawei.com>
Date:   Wed, 07 Oct 2020 22:56:00 -0400
In-Reply-To: <20200930021527.2831077-1-yebin10@huawei.com> (Ye Bin's message
        of "Wed, 30 Sep 2020 10:15:27 +0800")
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9767 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 mlxlogscore=999 spamscore=0
 adultscore=0 bulkscore=0 malwarescore=0 suspectscore=1 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2010080025
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9767 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 impostorscore=0 priorityscore=1501
 mlxscore=0 mlxlogscore=999 clxscore=1015 bulkscore=0 spamscore=0
 malwarescore=0 phishscore=0 suspectscore=1 adultscore=0 lowpriorityscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2010080025
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Hello Ye,

> @@ -310,7 +310,7 @@ static void esas2r_complete_vda_ioctl(struct esas2r_adapter *a,
>  				le32_to_cpu(rsp->vda_version);
>  			cfg->data.init.fw_build = rsp->fw_build;
>  
> -			snprintf(buf, sizeof(buf), "%1.1u.%2.2u",
> +			snprintf(buf, sizeof(buf), "%1.1d.%2.2d",
>  				 (int)LOBYTE(le16_to_cpu(rsp->fw_release)),
>  				 (int)HIBYTE(le16_to_cpu(rsp->fw_release)));

I doubt the firmware release is a negative number.

-- 
Martin K. Petersen	Oracle Linux Engineering
