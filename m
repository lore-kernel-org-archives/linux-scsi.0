Return-Path: <SRS0=QEZ7=2J=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 75420C2D0D2
	for <linux-scsi@archiver.kernel.org>; Thu, 19 Dec 2019 00:15:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 48DCB24650
	for <linux-scsi@archiver.kernel.org>; Thu, 19 Dec 2019 00:15:58 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="pNdyvgfE"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726713AbfLSAPy (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 18 Dec 2019 19:15:54 -0500
Received: from userp2130.oracle.com ([156.151.31.86]:50310 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726616AbfLSAPx (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 18 Dec 2019 19:15:53 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xBJ0EEPG158600;
        Thu, 19 Dec 2019 00:15:15 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : references : date : in-reply-to : message-id : mime-version :
 content-type; s=corp-2019-08-05;
 bh=EPBwbki9EZdxxDrWcZ24qhfNq3w08d1404ygElG60JE=;
 b=pNdyvgfEE1eMxZkueum391Od8j2anR8KolD4HRQb4ieKJmdJTgPiHFX/ZmoYagdZM6nH
 enrjf9DRFURQ+5yd5+uKCxMzeOYNS2oZE7xJh/lgF81gh1vYTGhFDN46JMbd3J+sWxlU
 CWdIJruk0SA2eqzfRrEE9r8FMBo8GQE2TkSwGsGB2ZCYrm2jBzk6eZPgaSQfOZ9AUvg2
 p6nEzhxMYSUzt8wUwg5Bx0SzZ9XvIsFmX06DpMlkmlEGfhSSAx4n5TFzcqq0iuSBEE98
 tSRB5p1gZO7fBu9ePhAuFIXEFVcQWBq7pV5wATXvpNUhPakDtHMLaJAWHAZagxmF05u8 EA== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2130.oracle.com with ESMTP id 2wvq5urxt0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 19 Dec 2019 00:15:14 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xBJ09O8K015978;
        Thu, 19 Dec 2019 00:15:14 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3020.oracle.com with ESMTP id 2wyp08gqdb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 19 Dec 2019 00:15:14 +0000
Received: from abhmp0007.oracle.com (abhmp0007.oracle.com [141.146.116.13])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id xBJ0FBv4027621;
        Thu, 19 Dec 2019 00:15:11 GMT
Received: from ca-mkp.ca.oracle.com (/10.159.214.123)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 18 Dec 2019 16:15:10 -0800
To:     Guenter Roeck <linux@roeck-us.net>
Cc:     linux-hwmon@vger.kernel.org, Jean Delvare <jdelvare@suse.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
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
Date:   Wed, 18 Dec 2019 19:15:07 -0500
In-Reply-To: <20191215174509.1847-2-linux@roeck-us.net> (Guenter Roeck's
        message of "Sun, 15 Dec 2019 09:45:09 -0800")
Message-ID: <yq1r211dvck.fsf@oracle.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1.92 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9475 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1911140001 definitions=main-1912190000
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9475 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1911140001
 definitions=main-1912190001
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Guenter,

> This driver solves this problem by adding support for reading the
> temperature of SATA drives from the kernel using the hwmon API and
> by adding a temperature zone for each drive.

My working tree is available here:

  https://git.kernel.org/pub/scm/linux/kernel/git/mkp/linux.git/log/?h=5.6/drivetemp

A few notes:

 - Before applying your patch I did s/satatemp/drivetemp/

 - I get a crash in the driver core during probe if the drivetemp module
   is loaded prior to loading ahci or a SCSI HBA driver. This crash is
   unrelated to my changes. Haven't had time to debug.

 - I tweaked your ATA detection heuristics and now use the cached VPD
   page 0x89 instead of fetching one from the device.

 - I also added support for reading the temperature log page on SCSI
   drives.

 - Tested with a mixed bag of about 40 SCSI and SATA drives attached.

 - I still think sensor naming needs work. How and where are the
   "drivetemp-scsi-8-140" names generated?

I'll tinker some more but thought I'd share what I have for now.

-- 
Martin K. Petersen	Oracle Linux Engineering
