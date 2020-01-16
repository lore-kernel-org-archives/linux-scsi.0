Return-Path: <SRS0=K2E6=3F=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 006AFC3F68F
	for <linux-scsi@archiver.kernel.org>; Thu, 16 Jan 2020 04:13:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id CC4A92077B
	for <linux-scsi@archiver.kernel.org>; Thu, 16 Jan 2020 04:12:59 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="QzqWvTzS"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730782AbgAPEMz (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 15 Jan 2020 23:12:55 -0500
Received: from userp2120.oracle.com ([156.151.31.85]:34250 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729048AbgAPEMz (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 15 Jan 2020 23:12:55 -0500
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 00G49CGc130923;
        Thu, 16 Jan 2020 04:12:30 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : references : date : in-reply-to : message-id : mime-version :
 content-type; s=corp-2019-08-05;
 bh=6Ya2kPRS3moX5+eA9DeZTfFSagefGsXpkir8zlrPo+o=;
 b=QzqWvTzSKl7xy+i7quBOO8Y9CJsmqUhke8acr75lo/S8SMNOHs5ERdSp9qgxtK9bV0cw
 +wGUgQEz3QwVoCvQK404zIeBoaI6qBZkz8ybrqSaBC1JfoXrOqWC8p4EVT8XAVs+YR2+
 5WrjJID/6wre+qvCc4T0sN3EbZhGV4BEqRwe985MztiPc2xcUZlqPNDorGgU4ZFgyAkB
 hgI0xdEI5NlrDpIytxNX/p2rHey1OaD0NXSn0FOD4iCn+xqlp9fDu3Tcrf4OjDUpeskp
 tuJeVA35Tqw9zFebkWHP1WMFgyoDC20LYao51GHCtPqMbToAYuCEW0zuPGtHwx9HAlIy tQ== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2120.oracle.com with ESMTP id 2xf73yr2nb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 16 Jan 2020 04:12:30 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 00G49CUX186215;
        Thu, 16 Jan 2020 04:12:29 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userp3030.oracle.com with ESMTP id 2xhy22jj8e-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 16 Jan 2020 04:12:29 +0000
Received: from abhmp0004.oracle.com (abhmp0004.oracle.com [141.146.116.10])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 00G4CQa3028217;
        Thu, 16 Jan 2020 04:12:27 GMT
Received: from ca-mkp.ca.oracle.com (/10.159.214.123)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 15 Jan 2020 20:12:26 -0800
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
        <yq1r211dvck.fsf@oracle.com>
        <b22a519c-8f26-e731-345f-9deca1b2150e@roeck-us.net>
        <yq1sgkq21ll.fsf@oracle.com> <20200108153341.GB28530@roeck-us.net>
        <38af9fda-9edf-1b54-bd8d-92f712ae4cda@roeck-us.net>
        <yq1r202spr9.fsf@oracle.com>
        <403cfbf8-79da-94f1-509f-e90d1a165722@roeck-us.net>
Date:   Wed, 15 Jan 2020 23:12:23 -0500
In-Reply-To: <403cfbf8-79da-94f1-509f-e90d1a165722@roeck-us.net> (Guenter
        Roeck's message of "Mon, 13 Jan 2020 21:20:51 -0800")
Message-ID: <yq14kwwnioo.fsf@oracle.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1.92 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9501 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1911140001 definitions=main-2001160032
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9501 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1911140001
 definitions=main-2001160032
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Guenter,

> The hwmon-next branch is based on v5.5-rc1. It might be better to
> either merge hwmon-next into mainline, or to apply the drivetemp patch
> to mainline, and test the result. I have seen some (unrelated) weird
> tracebacks in the driver core with v5.5-rc1, so that may not be the
> best baseline for a test.

I'm afraid the warnings still happen with hwmon-next on top of
linus/master.

-- 
Martin K. Petersen	Oracle Linux Engineering
