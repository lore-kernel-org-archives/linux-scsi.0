Return-Path: <SRS0=a792=EB=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.9 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5A2F5C4363A
	for <linux-scsi@archiver.kernel.org>; Mon, 26 Oct 2020 22:17:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 05F7A2087C
	for <linux-scsi@archiver.kernel.org>; Mon, 26 Oct 2020 22:17:33 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="WHXNSCRy"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392725AbgJZWRc (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 26 Oct 2020 18:17:32 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:59378 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2392676AbgJZWRc (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 26 Oct 2020 18:17:32 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 09QMFQD1056786;
        Mon, 26 Oct 2020 22:17:14 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : mime-version :
 content-type; s=corp-2020-01-29;
 bh=CfXVg4Pjz2MlVU0kNsI5cVbStug/lhdkDKpneKXv37s=;
 b=WHXNSCRymgYXRohefUfD4VzvOP688oIJ6+Ki5CQhy7WGldyEDpc37A4PQNeKatCfUr7R
 yIAxzailW/a4f3laqZkffbkfOD3kWHQptT3gUTDZMAy0BUjR8TCUr40LV4iPOY28pnfB
 UgFgj+0Vb3mbJ5/wo2IkWHMyUZegBPMoxEuMkD6JdtCpgW6xTo+F2ni3B9i0HaIx66aZ
 mYfrdCfGyZAfoFSPin5GSFLERW57xcGE6X270ftq4gjYKgH73r3BxqAj8V7KSWrFfV7F
 S7s0IrSpqVbhS7Zz34+A0gFQgFyUfoO5DBE7lX2ZvC7NYGY6jhFZJEBejONj0K9UXees yQ== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2120.oracle.com with ESMTP id 34dgm3vn7q-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Mon, 26 Oct 2020 22:17:14 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 09QM6FLK031232;
        Mon, 26 Oct 2020 22:15:13 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userp3020.oracle.com with ESMTP id 34cx1q0p74-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 26 Oct 2020 22:15:13 +0000
Received: from abhmp0014.oracle.com (abhmp0014.oracle.com [141.146.116.20])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 09QMF9xD031024;
        Mon, 26 Oct 2020 22:15:09 GMT
Received: from ca-mkp.ca.oracle.com (/10.159.214.123)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 26 Oct 2020 15:15:08 -0700
To:     "David C. Partridge" <david.partridge@perdrix.co.uk>
Cc:     <linux-scsi@vger.kernel.org>
Subject: Re: Adaptec ASR-51245 and aacraid driver timeouts
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq11rhk8wre.fsf@ca-mkp.ca.oracle.com>
References: <007e01d6a7a1$fed7d820$fc878860$@perdrix.co.uk>
Date:   Mon, 26 Oct 2020 18:15:06 -0400
In-Reply-To: <007e01d6a7a1$fed7d820$fc878860$@perdrix.co.uk> (David
        C. Partridge's message of "Wed, 21 Oct 2020 13:02:04 +0100")
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9786 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 phishscore=0 bulkscore=0
 suspectscore=1 malwarescore=0 mlxlogscore=784 mlxscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2010260143
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9786 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 lowpriorityscore=0 impostorscore=0
 adultscore=0 bulkscore=0 spamscore=0 phishscore=0 mlxlogscore=817
 suspectscore=1 clxscore=1011 mlxscore=0 malwarescore=0 priorityscore=1501
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2010260144
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


David,

> I'm running LUbuntu x64 20.04.1 kernel 5.4.0-52-generic with an
> Adapted ASR-51245 hosting a RAID-5 array.
>
> If I configure the card to power down the drives in the raid array
> after a period of idleness, the next time my server attempts to access
> the logical device I get:

If card firmware decides to power down the drives, why doesn't it spin
them back up on access?

-- 
Martin K. Petersen	Oracle Linux Engineering
