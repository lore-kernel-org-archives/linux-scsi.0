Return-Path: <SRS0=h99Q=3K=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 08A20C32771
	for <linux-scsi@archiver.kernel.org>; Tue, 21 Jan 2020 00:24:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id CC69F24125
	for <linux-scsi@archiver.kernel.org>; Tue, 21 Jan 2020 00:24:54 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="CKocOPnO"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728712AbgAUAYx (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 20 Jan 2020 19:24:53 -0500
Received: from userp2130.oracle.com ([156.151.31.86]:40830 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728512AbgAUAYx (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 20 Jan 2020 19:24:53 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 00L08LbU122625;
        Tue, 21 Jan 2020 00:24:46 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : references : date : in-reply-to : message-id : mime-version :
 content-type; s=corp-2019-08-05;
 bh=Og8bOqXdsBnnJInf2k2P9tYck2sngbknTnv6FDoyEoQ=;
 b=CKocOPnO9FYDMKoDRYgQvo96vAYxt2rLOFo83pnQG3PcBc3DeyTZalPDhmmx3iOu+RF+
 +9BNBV9PJp7LxJ7ItNwSgQ4PBHfcF3q5UYOTYeye9Qu3pyI7KT4hleKQ0WcqEEKwCX30
 YcyJc4gZZkmIzmpDn59o3prb26Laa7ubL8sTaTKZajSZ81Wb0nRmmo7uESxH/RVdhMPT
 tfBr1re/XePskvZQbi4j5AExE8lsNJgbMgQjGdywfzpVPDvNzSk98LP0OMj/rLXOEwXJ
 HI886y3dZCz8mPY5nDUCEM8/zK2zYp5dCwuGlf61F5tRLOkO3hfBZaolhbBItH+LTd5Z 3w== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2130.oracle.com with ESMTP id 2xkseua0qu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 21 Jan 2020 00:24:46 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 00L09MJg161723;
        Tue, 21 Jan 2020 00:24:45 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3020.oracle.com with ESMTP id 2xmc5mf0uu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 21 Jan 2020 00:24:45 +0000
Received: from abhmp0018.oracle.com (abhmp0018.oracle.com [141.146.116.24])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 00L0Oa68005888;
        Tue, 21 Jan 2020 00:24:36 GMT
Received: from ca-mkp.ca.oracle.com (/10.159.214.123)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 20 Jan 2020 16:24:36 -0800
To:     Jinpu Wang <jinpu.wang@cloud.ionos.com>
Cc:     Deepak Ukey <deepak.ukey@microchip.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Linux SCSI Mailinglist <linux-scsi@vger.kernel.org>,
        Vasanthalakshmi.Tharmarajan@microchip.com,
        Viswas G <Viswas.G@microchip.com>,
        Jack Wang <jinpu.wang@profitbricks.com>, yuuzheng@google.com,
        Vikram Auradkar <auradkar@google.com>, vishakhavc@google.com,
        bjashnani@google.com, Radha Ramachandran <radha@google.com>,
        akshatzen@google.com
Subject: Re: [PATCH V2 05/13] pm80xx : Support for char device.
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
References: <20200117071923.7445-1-deepak.ukey@microchip.com>
        <20200117071923.7445-6-deepak.ukey@microchip.com>
        <CAMGffEnc1sWgOB7PENtbBQUzJ6iRORHrJe4Y5FV1+WkgrhAwOg@mail.gmail.com>
Date:   Mon, 20 Jan 2020 19:24:33 -0500
In-Reply-To: <CAMGffEnc1sWgOB7PENtbBQUzJ6iRORHrJe4Y5FV1+WkgrhAwOg@mail.gmail.com>
        (Jinpu Wang's message of "Fri, 17 Jan 2020 15:15:12 +0100")
Message-ID: <yq17e1lk666.fsf@oracle.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1.92 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9506 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1911140001 definitions=main-2001210000
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9506 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1011
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1911140001
 definitions=main-2001210000
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Jinpu,

> Thanks for the commit message, looks much better. In the past, people
> are against IOCTL, suggesting netlink, have you considered that?

Not so keen on adding more ioctls. It's 2020 and all...

Given the nature of the exported information, what's wrong with putting
it in sysfs?

-- 
Martin K. Petersen	Oracle Linux Engineering
