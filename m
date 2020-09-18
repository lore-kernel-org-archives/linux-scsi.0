Return-Path: <SRS0=xkU+=C3=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_SANE_1
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E413AC43465
	for <linux-scsi@archiver.kernel.org>; Fri, 18 Sep 2020 18:01:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 84E5721741
	for <linux-scsi@archiver.kernel.org>; Fri, 18 Sep 2020 18:01:28 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="Ghs8eMA7"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726312AbgIRSBZ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 18 Sep 2020 14:01:25 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:43026 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726118AbgIRSBY (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 18 Sep 2020 14:01:24 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 08IHxlJD120269;
        Fri, 18 Sep 2020 18:00:51 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=8t9bvmNa7HAbT/T846NG8EsOFIharYS9N7nOuLhuASw=;
 b=Ghs8eMA73OKyFYU2sieQPHJz7IQr2Z0/Kg+q7d8eI5ZxZnxCQ/xud0UxSMOUTH3T5wvC
 9azCJpe81SMpW5Sp1Vmi7eAFcPewOC2/vDXOle6dOsSK9M9Yo0GMvHQ4x5QO2ROlkaAL
 xrENiDW7hnnyoDw7ycTtWxE9iG3V3SPZEa6GytTZ61CAN96ui+MX4QCUdT3t0F0Y9Jg3
 53JO0ye4C7zXvcsnXCI3bpAV9utvVlV5OC4743z0NprMIrFvtBFKSCMNWWllRO9+ozQH
 9ULw6hcAxXd1Ms+NGzeosKXMqan3PQIwuJc4TFlEXPmr6/a2l5ZLKCGWTB736J+S4Mp3 9A== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2130.oracle.com with ESMTP id 33gnrrgpb5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Fri, 18 Sep 2020 18:00:51 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 08II0APH140452;
        Fri, 18 Sep 2020 18:00:50 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3030.oracle.com with ESMTP id 33khpq2kxy-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 18 Sep 2020 18:00:50 +0000
Received: from abhmp0015.oracle.com (abhmp0015.oracle.com [141.146.116.21])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 08II0jFm028734;
        Fri, 18 Sep 2020 18:00:46 GMT
Received: from kadam (/41.57.98.10)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 18 Sep 2020 18:00:45 +0000
Date:   Fri, 18 Sep 2020 21:00:37 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     Joe Perches <joe@perches.com>
Cc:     "Gustavo A. R. Silva" <gustavoars@kernel.org>,
        Jing Xiangfeng <jingxiangfeng@huawei.com>, jejb@linux.ibm.com,
        martin.petersen@oracle.com, lee.jones@linaro.org,
        colin.king@canonical.com, axboe@kernel.dk,
        mchehab+huawei@kernel.org, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        kernel-janitors <kernel-janitors@vger.kernel.org>
Subject: Re: [PATCH] scsi: arcmsr: Remove the superfluous break
Message-ID: <20200918180037.GY4282@kadam>
References: <20200918093230.49050-1-jingxiangfeng@huawei.com>
 <20200918145619.GA25599@embeddedor>
 <e9320543ab6e7c8bd5ceae8cfa9d0912a0e962e0.camel@perches.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e9320543ab6e7c8bd5ceae8cfa9d0912a0e962e0.camel@perches.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9748 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 suspectscore=0
 mlxlogscore=999 phishscore=0 mlxscore=0 adultscore=0 spamscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2009180147
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9748 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 spamscore=0
 lowpriorityscore=0 malwarescore=0 mlxscore=0 bulkscore=0 suspectscore=0
 clxscore=1011 mlxlogscore=999 adultscore=0 priorityscore=1501
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2009180147
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Smatch just ignores these because they're often done deliberately.

regards,
dan carpenter

