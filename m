Return-Path: <SRS0=xo/b=CM=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BE7E9C433E2
	for <linux-scsi@archiver.kernel.org>; Thu,  3 Sep 2020 01:17:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 94D9720786
	for <linux-scsi@archiver.kernel.org>; Thu,  3 Sep 2020 01:17:52 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="vXbdaMGH"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727859AbgICBRw (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 2 Sep 2020 21:17:52 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:50152 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727851AbgICBRv (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 2 Sep 2020 21:17:51 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0831FLPD085687;
        Thu, 3 Sep 2020 01:17:44 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : mime-version :
 content-type; s=corp-2020-01-29;
 bh=o0NANmwGtLOkklHV6P8tR8srTOIQwnDfq2MeGpFCapo=;
 b=vXbdaMGHox2IgWatJ1+7/7j6HNPZR0f4lHjl04dtK/q36akWMleK5Yh/jQp9jKrqudJN
 nhj8lGBKaOUZ43lSjnyYFE4kCfLezj8MsWkmWIOwFPoGeHPCCXBfzRJYgGtAUQ6k2j+b
 dTk5L9svBv0HgXjbMAiCOl7D03vMBOF+X3H2xxdF0bkiAYfxfC2rHbIV1iLGUGtmFbbn
 ToYBqLa/AgVy/b4iHLINSq7cy2qQSB8nACMonLF/qveSh5KPXIKnEhRNhT4J1ZdEt8c3
 BZTw0wr0OcjhhSg8/9eSfGIGd/KXcaq/l8PwKWiTRDBmoqyGiKewytNn/o0+QFzi79q1 GA== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2130.oracle.com with ESMTP id 337eer5yt1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Thu, 03 Sep 2020 01:17:43 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0831FFgG151165;
        Thu, 3 Sep 2020 01:17:43 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3030.oracle.com with ESMTP id 3380kqxqhr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 03 Sep 2020 01:17:43 +0000
Received: from abhmp0008.oracle.com (abhmp0008.oracle.com [141.146.116.14])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 0831Hg1r027625;
        Thu, 3 Sep 2020 01:17:42 GMT
Received: from ca-mkp.ca.oracle.com (/10.159.214.123)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 02 Sep 2020 18:17:41 -0700
To:     <Viswas.G@microchip.com>
Cc:     <martin.petersen@oracle.com>, <Viswas.G@microchip.com.com>,
        <linux-scsi@vger.kernel.org>,
        <Vasanthalakshmi.Tharmarajan@microchip.com>,
        <Deepak.Ukey@microchip.com>, <yuuzheng@google.com>,
        <auradkar@google.com>, <vishakhavc@google.com>,
        <bjashnani@google.com>, <radha@google.com>, <akshatzen@google.com>
Subject: Re: [PATCH v8 1/2] pm80xx : Support for get phy profile functionality.
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq1a6y7ek7u.fsf@ca-mkp.ca.oracle.com>
References: <20200820185123.27354-1-Viswas.G@microchip.com.com>
        <20200820185123.27354-2-Viswas.G@microchip.com.com>
        <yq1pn75f09i.fsf@ca-mkp.ca.oracle.com>
        <SN6PR11MB348809CB28AA66A7905490949D2F0@SN6PR11MB3488.namprd11.prod.outlook.com>
Date:   Wed, 02 Sep 2020 21:17:39 -0400
In-Reply-To: <SN6PR11MB348809CB28AA66A7905490949D2F0@SN6PR11MB3488.namprd11.prod.outlook.com>
        (Viswas G.'s message of "Wed, 2 Sep 2020 06:35:51 +0000")
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9732 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 spamscore=0 adultscore=0
 mlxscore=0 suspectscore=3 malwarescore=0 mlxlogscore=999 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2009030008
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9732 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 clxscore=1015 priorityscore=1501
 lowpriorityscore=0 malwarescore=0 adultscore=0 spamscore=0 mlxscore=0
 phishscore=0 impostorscore=0 mlxlogscore=999 bulkscore=0 suspectscore=3
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2009030008
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Hi Viswas!

>> Where are these parameters made visible?
>>
>> Also, why not make the phy_errcnt members __le32 instead of using
>> __force?
>
> This was added to avoid sparse compiler warnings reported.

Yes, but those warnings are indicative that your struct definitions are
problematic. I suggest you have one struct with __le32 members which you
use when querying the values from the hardware. And then another struct
that's host-endian. Which goes back to my first question: Where are
these phy parameters actually used and/or exposed to userland?

-- 
Martin K. Petersen	Oracle Linux Engineering
