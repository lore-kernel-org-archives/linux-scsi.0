Return-Path: <SRS0=W9vy=DJ=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.9 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3A14AC35257
	for <linux-scsi@archiver.kernel.org>; Fri,  2 Oct 2020 22:54:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0592820796
	for <linux-scsi@archiver.kernel.org>; Fri,  2 Oct 2020 22:54:19 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="LkLD5QTS"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725797AbgJBWyT (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 2 Oct 2020 18:54:19 -0400
Received: from aserp2130.oracle.com ([141.146.126.79]:42860 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725283AbgJBWyP (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 2 Oct 2020 18:54:15 -0400
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 092MrwsH102293;
        Fri, 2 Oct 2020 22:53:58 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : mime-version :
 content-type; s=corp-2020-01-29;
 bh=YEutNmhk/CIE24xbhcuPSWMQxQ3nn3ZcbaPYLZ35Zow=;
 b=LkLD5QTSw/60NCYTaFBfw0AFIardUFi7hKV2vbLlwHoLEoP0Gwqloq4vQnNUu8MOuxyI
 6JMmzoNKPH5moTvnnFw+PgkNQNgVXLOIuStc9A5avqZN31dmiwIOe3+BA3dGPk3zO3Xr
 xlyusSq36R4/DxrcEIAymsCW6GfIr9AaebfPZJQfzUqgdkIT86eN5XIgHUnUht1i95FH
 yO+D9UQAhXWxEpQpfiDEHpH1BTUOwhhDeOyd1B7/B/6G6aXS+EIl/ePxR0wjcT4UqYjG
 adR3kKI1NS/dYq/VnSd9z0Qod6GBxEV351MniDaOQcctoegqKXPdLvBzqr/y/QlIsCdW /w== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2130.oracle.com with ESMTP id 33wupg4689-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Fri, 02 Oct 2020 22:53:57 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 092MotE6034325;
        Fri, 2 Oct 2020 22:53:55 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userp3020.oracle.com with ESMTP id 33tfdy982m-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 02 Oct 2020 22:53:55 +0000
Received: from abhmp0012.oracle.com (abhmp0012.oracle.com [141.146.116.18])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 092MrsaA007295;
        Fri, 2 Oct 2020 22:53:55 GMT
Received: from ca-mkp.ca.oracle.com (/10.159.214.123)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 02 Oct 2020 15:53:54 -0700
To:     Mike Christie <michael.christie@oracle.com>
Cc:     martin.petersen@oracle.com, bvanassche@acm.org,
        linux-scsi@vger.kernel.org, james.bottomley@hansenpartnership.com
Subject: Re: [PATCH V3 0/2] scsi/sd: make disk cmd retries configurable
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq1v9fsdytk.fsf@ca-mkp.ca.oracle.com>
References: <1601566554-26752-1-git-send-email-michael.christie@oracle.com>
Date:   Fri, 02 Oct 2020 18:53:52 -0400
In-Reply-To: <1601566554-26752-1-git-send-email-michael.christie@oracle.com>
        (Mike Christie's message of "Thu, 1 Oct 2020 10:35:52 -0500")
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9762 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=897 phishscore=0
 adultscore=0 malwarescore=0 spamscore=0 mlxscore=0 bulkscore=0
 suspectscore=1 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2010020174
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9762 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 malwarescore=0
 lowpriorityscore=0 impostorscore=0 priorityscore=1501 clxscore=1015
 phishscore=0 mlxscore=0 bulkscore=0 spamscore=0 mlxlogscore=925
 suspectscore=1 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2010020175
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Mike,

> The following patches made over Martin's staging branch allow the user
> to config sd cmd retries. I didn't allow the user to set any old value
> and kept the max at 5. However, you can now turn it off and rely on
> the transport error handler to decide when to stop retrying. You can
> also decrease retries for cases for disks where there is no use in
> retrying 5 times.

Applied to 5.10/scsi-staging, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
