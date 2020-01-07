Return-Path: <SRS0=hsTv=24=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1CAA6C33C9B
	for <linux-scsi@archiver.kernel.org>; Tue,  7 Jan 2020 04:10:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E6EFC207E0
	for <linux-scsi@archiver.kernel.org>; Tue,  7 Jan 2020 04:10:47 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="jElTaqMs"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727550AbgAGEKr (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 6 Jan 2020 23:10:47 -0500
Received: from userp2130.oracle.com ([156.151.31.86]:34864 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727432AbgAGEKr (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 6 Jan 2020 23:10:47 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 00749WVO088091;
        Tue, 7 Jan 2020 04:10:20 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : references : date : in-reply-to : message-id : mime-version :
 content-type; s=corp-2019-08-05;
 bh=A79SI0wBAntvD1EW3YYmYwTYNFp8rHgmaSMpBMWpWzg=;
 b=jElTaqMsUI4VO3lilql8LaupxfRfny1Cx14T7tZ7kSy3MybWZErQWr8MKtvmQZNrKh0w
 HfljcSxhYfc5ayutX8VvnsfhfntNnYq4Min6JJlD/O0xHK1YPlABTJ9zXzuCVhFTyAnN
 71kyAQtk8nMFv0AL6WhHnJqiLOUFTI3dZ2ewHHzmxDqdiB2SFibRyOOwzpl1Hk8+q8Lt
 zZ28uptJu1LKY9S4npPQYBksoRP6rvj5tiL0oWWzJ/6WW8+RONAzLiAdyVCsulF2UWvf
 h7tsY0pkZGS5ZcCv7iJSLOZfhTU6r/zTZ5S6Dz4VPwO1et0O8C7WsjsYVmtY+bkcqES4 HQ== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2130.oracle.com with ESMTP id 2xaj4tu22h-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 07 Jan 2020 04:10:20 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 00749T0u154649;
        Tue, 7 Jan 2020 04:10:19 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3020.oracle.com with ESMTP id 2xb47hq6uc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 07 Jan 2020 04:10:19 +0000
Received: from abhmp0009.oracle.com (abhmp0009.oracle.com [141.146.116.15])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 0074AI17007946;
        Tue, 7 Jan 2020 04:10:18 GMT
Received: from ca-mkp.ca.oracle.com (/10.159.214.123)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 06 Jan 2020 20:10:18 -0800
To:     Guenter Roeck <linux@roeck-us.net>
Cc:     "Martin K. Petersen" <martin.petersen@oracle.com>,
        linux-hwmon@vger.kernel.org, Jean Delvare <jdelvare@suse.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Bart Van Assche <bvanassche@acm.org>,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org,
        Chris Healy <cphealy@gmail.com>
Subject: Re: [PATCH v2] hwmon: Driver for temperature sensors on SATA drives
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
References: <20191215174509.1847-1-linux@roeck-us.net>
        <20191215174509.1847-2-linux@roeck-us.net>
        <yq1r211dvck.fsf@oracle.com> <20191219003256.GA28144@roeck-us.net>
Date:   Mon, 06 Jan 2020 23:10:15 -0500
In-Reply-To: <20191219003256.GA28144@roeck-us.net> (Guenter Roeck's message of
        "Wed, 18 Dec 2019 16:32:57 -0800")
Message-ID: <yq17e233o0o.fsf@oracle.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1.92 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9492 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=866
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1911140001 definitions=main-2001070032
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9492 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=927 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1911140001
 definitions=main-2001070032
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Hi Guenter!

>>  - I still think sensor naming needs work. How and where are the
>>    "drivetemp-scsi-8-140" names generated?
>> 
> Quick one: In libsensors, outside the kernel. The naming is generic,
> along the line of <driver name>-<bus name>-<bus index>-<slot>.

I understand that there are sensors that may not have an obvious
associated topology and therefore necessitate coming up with a suitable
naming or enumeration scheme. But in this case we already have a
well-defined SCSI device name. Any particular reason you don't shift the
chip.addr back and print the H:C:T:L format that you used as input?

However arcane H:C:T:L may seem, I think that predictable naming would
make things a lot easier for users that need to identify which device
matches which sensor...

-- 
Martin K. Petersen	Oracle Linux Engineering
