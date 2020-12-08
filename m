Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 323CEC4361B
	for <linux-scsi@archiver.kernel.org>; Tue,  8 Dec 2020 01:31:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id ECDCC221FD
	for <linux-scsi@archiver.kernel.org>; Tue,  8 Dec 2020 01:31:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726459AbgLHBb0 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 7 Dec 2020 20:31:26 -0500
Received: from aserp2130.oracle.com ([141.146.126.79]:56208 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726369AbgLHBb0 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 7 Dec 2020 20:31:26 -0500
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0B81TGqD103681;
        Tue, 8 Dec 2020 01:30:25 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : mime-version :
 content-type; s=corp-2020-01-29;
 bh=sYcP+zt4qLnmC4XoPneH40sjSPVxmZGxQb7RF5dynPI=;
 b=wEuk4/W9/KHjkBAuQd4MQJz39HGqb3qumTThlwxmnMux4UqbXKUuiNRORZc8wjvxvDTb
 IGXA5NHe+VmpgbuWS2nWlmM1fXjtgaR5CWOJKk3IoEe+XyDZ6D0hFAPg8lOQKDe8b+8o
 jvMFRPQhwCIWIfi20ZcPemMW+ykCecsqplO43wsbEBJKQ5mFNn3dhK5rh++nr5/uriA7
 Xjx55QgmycYnGJrdVugRL8wz3AQKJtfX5dMJ0oLGcqF1iqf1+oK5cYtjVw2szYEwfu4J
 DzefTqJrzvRx/tOnaf7BwaYf9TrqviCQka+9cy/rGwaOEj8gJDijNmdBy2v5/cUf9SRJ mA== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by aserp2130.oracle.com with ESMTP id 357yqbrhcp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Tue, 08 Dec 2020 01:30:25 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0B81TfcN117394;
        Tue, 8 Dec 2020 01:30:25 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userp3030.oracle.com with ESMTP id 358m4x2kw8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 08 Dec 2020 01:30:24 +0000
Received: from abhmp0012.oracle.com (abhmp0012.oracle.com [141.146.116.18])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 0B81UI2C004546;
        Tue, 8 Dec 2020 01:30:18 GMT
Received: from ca-mkp.ca.oracle.com (/10.159.214.123)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 07 Dec 2020 17:30:17 -0800
To:     Arnd Bergmann <arnd@kernel.org>
Cc:     "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Nathan Chancellor <natechancellor@gmail.com>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Jaegeuk Kim <jaegeuk@kernel.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Alim Akhtar <alim.akhtar@samsung.com>,
        Avri Altman <avri.altman@wdc.com>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Can Guo <cang@codeaurora.org>,
        Asutosh Das <asutoshd@codeaurora.org>,
        Bean Huo <beanhuo@micron.com>,
        Bart Van Assche <bvanassche@acm.org>,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        clang-built-linux@googlegroups.com
Subject: Re: [PATCH] ufshcd: fix Wsometimes-uninitialized warning
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq15z5d13vl.fsf@ca-mkp.ca.oracle.com>
References: <20201203223137.1205933-1-arnd@kernel.org>
Date:   Mon, 07 Dec 2020 20:30:14 -0500
In-Reply-To: <20201203223137.1205933-1-arnd@kernel.org> (Arnd Bergmann's
        message of "Thu, 3 Dec 2020 23:31:26 +0100")
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9828 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 spamscore=0 suspectscore=1
 bulkscore=0 malwarescore=0 phishscore=0 adultscore=0 mlxlogscore=975
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2012080006
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9828 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=1 mlxlogscore=987
 clxscore=1011 malwarescore=0 bulkscore=0 phishscore=0 adultscore=0
 spamscore=0 priorityscore=1501 mlxscore=0 lowpriorityscore=0
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2012080006
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Arnd,

> clang complains about a possible code path in which a variable is
> used without an initialization:
>
> drivers/scsi/ufs/ufshcd.c:7690:3: error: variable 'sdp' is used uninitialized whenever 'if' condition is false [-Werror,-Wsometimes-uninitialized]
>                 BUG_ON(1);
>                 ^~~~~~~~~

Applied to 5.11/scsi-staging, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
