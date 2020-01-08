Return-Path: <SRS0=fkLW=25=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8DA75C33C9B
	for <linux-scsi@archiver.kernel.org>; Wed,  8 Jan 2020 01:12:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 64BB52080A
	for <linux-scsi@archiver.kernel.org>; Wed,  8 Jan 2020 01:12:41 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="Y7pVuVho"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726530AbgAHBMk (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 7 Jan 2020 20:12:40 -0500
Received: from userp2130.oracle.com ([156.151.31.86]:44054 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725601AbgAHBMj (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 7 Jan 2020 20:12:39 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 00819CZL120969;
        Wed, 8 Jan 2020 01:12:11 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : references : date : in-reply-to : message-id : mime-version :
 content-type; s=corp-2019-08-05;
 bh=3ydrE+T/CSID+gARHjnF6wd1bt90Yw9xO2VGOIXAOBQ=;
 b=Y7pVuVhowbYc0FayjzkOX8nnmUIQLHS0mEO1OMmW+zr81/HQMzywLj2upnP+DBa18nAZ
 NPIK41ZHR0JMgYbycFkryGBv3GapPJfdiYs66lr1PMWSoj/srJzyKnifU1W3g02aB40X
 42YnLMl72IxH5/tk5vlwI9WRVJsuNF4f8BGsrCIu2gvkqDlJoA3LDCpKwxF1l0WhZCgz
 m3wl2ITtxNihtCAKExT1qq7ud8Oaen3TnNNdyzzyiixqvst5pIfxZQ2b8vSC6OnzNPhp
 l/BQ4fMTbuChkjMDgeTLmJQ6LbN2Qxlg2sCCCoOoSplsllh/JXYEeLAQB2vPTVZn0ViI jA== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2130.oracle.com with ESMTP id 2xaj4u12w2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 08 Jan 2020 01:12:11 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 008199Z9128871;
        Wed, 8 Jan 2020 01:12:11 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userp3020.oracle.com with ESMTP id 2xcpcrg2p0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 08 Jan 2020 01:12:10 +0000
Received: from abhmp0010.oracle.com (abhmp0010.oracle.com [141.146.116.16])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 0081C9j3002068;
        Wed, 8 Jan 2020 01:12:09 GMT
Received: from ca-mkp.ca.oracle.com (/10.159.214.123)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 07 Jan 2020 17:12:09 -0800
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
Date:   Tue, 07 Jan 2020 20:12:06 -0500
In-Reply-To: <b22a519c-8f26-e731-345f-9deca1b2150e@roeck-us.net> (Guenter
        Roeck's message of "Wed, 1 Jan 2020 09:46:23 -0800")
Message-ID: <yq1sgkq21ll.fsf@oracle.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1.92 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9493 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=894
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1911140001 definitions=main-2001080009
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9493 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=955 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1911140001
 definitions=main-2001080009
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Guenter,

> Any idea how I might be able to reproduce this ? So far I have been
> unsuccessful.
>
> Building drivetemp into the kernel, with ahci and everything SCSI
> built as module, doesn't trigger the crash for me. This is with the
> drivetemp patch (v3) as well as commit d188b0675b ("scsi: core: Add
> sysfs attributes for VPD pages 0h and 89h") applied on top of v5.4.7.

This is with 5.5-rc1. I'll try another kernel.

My repro is:

# modprobe drivetemp
# modprobe <any SCSI driver, including ahci>

-- 
Martin K. Petersen	Oracle Linux Engineering
