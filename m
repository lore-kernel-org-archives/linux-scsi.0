Return-Path: <SRS0=+W3W=3D=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 640E0C33CAF
	for <linux-scsi@archiver.kernel.org>; Tue, 14 Jan 2020 03:04:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3B92524658
	for <linux-scsi@archiver.kernel.org>; Tue, 14 Jan 2020 03:04:41 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="KKp4Lez6"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729629AbgANDEh (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 13 Jan 2020 22:04:37 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:53130 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729224AbgANDEh (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 13 Jan 2020 22:04:37 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 00E33f0n181167;
        Tue, 14 Jan 2020 03:04:01 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : references : date : in-reply-to : message-id : mime-version :
 content-type; s=corp-2019-08-05;
 bh=keJibTsJRKKM7cxbY4WBKFccqeBdlACR5qxE4hPJX+4=;
 b=KKp4Lez6+ddRjoyGpUtf4VWNMY+B3LVFG52sUGwtjh/9v2zq9CcRmH5IV/3gDWj5mZtz
 vtHWtkVgOr9rmKfQxdB0jYdPL/to+TFrSl9ZTbeCy3U/1mpQr/MTZhX21WFF906elohQ
 3uYqtdf8jy0Gx3EJK12rwmZQWLhRY4muOJxdMLAGLUdWTQBVg1nRqLQF24zQmFZrfxb5
 YsItUNOOvMmrWiiL8jxwVN/qEQ4u8NVwcagtESmfF0uwtd9oJSYxG3XSVn2wp8ouGWxW
 foe1SEaAWDhbVfQwjVifj0LHDkRKXT0R9o23x5DRMluQRi4sOtEwsYa28K2897yOJBA5 rw== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2120.oracle.com with ESMTP id 2xf73tk4a4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 14 Jan 2020 03:04:00 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 00E33E1L194107;
        Tue, 14 Jan 2020 03:04:00 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userp3020.oracle.com with ESMTP id 2xfrgjss6w-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 14 Jan 2020 03:03:59 +0000
Received: from abhmp0013.oracle.com (abhmp0013.oracle.com [141.146.116.19])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 00E33vjH010007;
        Tue, 14 Jan 2020 03:03:57 GMT
Received: from ca-mkp.ca.oracle.com (/10.159.214.123)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 13 Jan 2020 19:03:57 -0800
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
Date:   Mon, 13 Jan 2020 22:03:54 -0500
In-Reply-To: <38af9fda-9edf-1b54-bd8d-92f712ae4cda@roeck-us.net> (Guenter
        Roeck's message of "Sat, 11 Jan 2020 12:22:57 -0800")
Message-ID: <yq1r202spr9.fsf@oracle.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1.92 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9499 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=643
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1911140001 definitions=main-2001140026
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9499 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=704 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1911140001
 definitions=main-2001140026
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Hi Guenter!

> I tried again, this time with v5.5-rc5. Loading and unloading ahci and
> drivetemp in any order does not cause any problems for me.

I tried your hwmon-next branch and it still happens for me. Both in qemu
and on real hw. I'm really low on bandwidth the next couple of days.
Will try to look later this week unless you beat me to it. I get lots of
these warnings after modprobe drivetemp; modprobe ahci:

[ 1055.611922] WARNING: CPU: 3 PID: 3233 at drivers/base/dd.c:519 really_probe+0x436/0x4f0

A quick test forcing synchronous SCSI scanning made no difference.

-- 
Martin K. Petersen	Oracle Linux Engineering

