Return-Path: <SRS0=ePHC=6P=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AD93CC47253
	for <linux-scsi@archiver.kernel.org>; Fri,  1 May 2020 09:55:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8562E2166E
	for <linux-scsi@archiver.kernel.org>; Fri,  1 May 2020 09:55:24 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="FPQ3pbDA"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728458AbgEAJzX (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 1 May 2020 05:55:23 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:59032 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728325AbgEAJzX (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 1 May 2020 05:55:23 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0419t3w3054517;
        Fri, 1 May 2020 09:55:21 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=oA2EYlqtMj8SXF8ij2FPfBlczX1un0eUx9jcQLXMKZ8=;
 b=FPQ3pbDAHIrgnSsllcb4F9byaqKAhRM2SfCjejF/eAi7s0t+D2ZaomYgxz9W6gtbiZm3
 D8in/c3S8QEJykZOsY/P9Ofc5a5Meit7istGwy6BqqUmF38R9RDDYmbi6di6blSGvr6E
 /dzwfusbZysi2R4BMS/mYC10VVYGTDCVu3fm+NAiBKClmd7834JqWR1uSvuLI4TdrA0N
 6NXG91E0v/PIAWFulCW7tEb2/YCWG+pTcY5D+RVjn9iITtTvIg1lfUqWx8okWOuC7ldo
 McHEC48fqGdL7SBKreWmIjUQbtaelRYP9zL0VIm1wVmBfVmytrdZ0KJZMIbVMlnHY+PT Xg== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2120.oracle.com with ESMTP id 30r7f5sma0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 01 May 2020 09:55:21 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0419qxS1037530;
        Fri, 1 May 2020 09:53:20 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3020.oracle.com with ESMTP id 30r7fa0hby-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 01 May 2020 09:53:20 +0000
Received: from abhmp0015.oracle.com (abhmp0015.oracle.com [141.146.116.21])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 0419rJP3030907;
        Fri, 1 May 2020 09:53:19 GMT
Received: from kadam (/41.57.98.10)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 01 May 2020 02:53:17 -0700
Date:   Fri, 1 May 2020 12:53:11 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     suganath-prabu.subramani@broadcom.com
Cc:     MPT-FusionLinux.pdl@broadcom.com, linux-scsi@vger.kernel.org
Subject: Re: [bug report] scsi: mpt3sas: Handle RDPQ DMA allocation in same
 4G region
Message-ID: <20200501095311.GD1992@kadam>
References: <20200429142149.GA823478@mwanda>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200429142149.GA823478@mwanda>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9607 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 suspectscore=3
 phishscore=0 malwarescore=0 mlxscore=0 spamscore=0 mlxlogscore=473
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2005010076
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9607 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 spamscore=0 mlxscore=0
 lowpriorityscore=0 priorityscore=1501 adultscore=0 mlxlogscore=540
 clxscore=1015 phishscore=0 impostorscore=0 suspectscore=3 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2003020000
 definitions=main-2005010076
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

This also causes a bug in the callers.

    drivers/scsi/mpt3sas/mpt3sas_base.c:7428 mpt3sas_base_attach()
    warn: 'ioc->hpr_lookup' double freed

We free the pointers, then return an error and the caller frees the
pointers as well.

Smatch is very limited in the types of double frees it looks for.
It really requires someone to manually go through the free paths and
check it by hand because I'm sure there are other bugs there as well.

Please CC me on the Fix because I'm not subscribed to the linux-scsi
mailing list.

regards,
dan carpenter

