Return-Path: <SRS0=fPmA=2I=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A2E19C43603
	for <linux-scsi@archiver.kernel.org>; Wed, 18 Dec 2019 03:43:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 777B82146E
	for <linux-scsi@archiver.kernel.org>; Wed, 18 Dec 2019 03:43:10 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="L2n1EUf2"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726622AbfLRDnH (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 17 Dec 2019 22:43:07 -0500
Received: from userp2120.oracle.com ([156.151.31.85]:52036 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726387AbfLRDnG (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 17 Dec 2019 22:43:06 -0500
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xBI3dROh116939;
        Wed, 18 Dec 2019 03:42:43 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : references : date : in-reply-to : message-id : mime-version :
 content-type; s=corp-2019-08-05;
 bh=PjGUM/EnuhLBD6aKzM6coivdq8W0PG7m5U8o0IABAVg=;
 b=L2n1EUf2W36k0n0SLzEzRS5mRleuhAiZLTWF2cVaoef+/bbmgj6sirqHeSZqJQy3h2SQ
 anW2nKv8BTszFhNrI0iuWry8y9aB0Bp93w/FOFQs9aiIOtc91dlG1F7U/iJG2HOLUIbg
 uc5oPT0WygsTi2uBl1Fho7olpa/8NBiedAadKXDO8BpvsLzJ+My8qc89cm3KteNKD2Ya
 MWfp5gcHRmnrmHd7cXmTDkx+F4/oABZ4RTBTKJVbT+bmWpImNxCFtPR8XmlGi9XfNG0H
 xRd4EaKx92vcpj8KSixmbwnFlHS5KccK/vNkF17kW4dEkabnBHbU9n65+flkKUJff+zZ lA== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2120.oracle.com with ESMTP id 2wvrcrat71-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 18 Dec 2019 03:42:43 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xBI3dVGK129935;
        Wed, 18 Dec 2019 03:42:42 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3030.oracle.com with ESMTP id 2wxm4wrpfv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 18 Dec 2019 03:42:42 +0000
Received: from abhmp0011.oracle.com (abhmp0011.oracle.com [141.146.116.17])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id xBI3geCG003973;
        Wed, 18 Dec 2019 03:42:40 GMT
Received: from ca-mkp.ca.oracle.com (/10.159.214.123)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 17 Dec 2019 19:42:39 -0800
To:     Guenter Roeck <linux@roeck-us.net>
Cc:     "Martin K. Petersen" <martin.petersen@oracle.com>,
        linux-hwmon@vger.kernel.org, Jean Delvare <jdelvare@suse.com>,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org
Subject: Re: [PATCH 0/1] Summary: hwmon driver for temperature sensors on SATA drives
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
References: <20191209052119.32072-1-linux@roeck-us.net>
        <yq15zinmrmj.fsf@oracle.com>
        <67b75394-801d-ce91-55f2-f0c0db9cfffc@roeck-us.net>
        <yq1y2vbhe6i.fsf@oracle.com>
        <83d528fc-42b7-aa3f-5dd9-a000268da38e@roeck-us.net>
Date:   Tue, 17 Dec 2019 22:42:37 -0500
In-Reply-To: <83d528fc-42b7-aa3f-5dd9-a000268da38e@roeck-us.net> (Guenter
        Roeck's message of "Mon, 16 Dec 2019 19:57:31 -0800")
Message-ID: <yq1zhfqfgeq.fsf@oracle.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1.92 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9474 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=776
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1911140001 definitions=main-1912180026
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9474 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=834 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1911140001
 definitions=main-1912180026
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Guenter,

>> Also, there are some devices that will lock up the way you access that
>> VPD page. So a tweak is also required there.
>>
> Do you have details ? Do I need to add a call to scsi_device_supports_vpd(),
> maybe ?

Some devices lock up if you ask for too much data. I actually discovered
a VPD handling regression in 5.5 while working on a series of prep
patches for you today. Working on a fix. I'll try to get a patch series
out for review tomorrow.

-- 
Martin K. Petersen	Oracle Linux Engineering
