Return-Path: <SRS0=2LRe=DO=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.6 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EED18C4363C
	for <linux-scsi@archiver.kernel.org>; Wed,  7 Oct 2020 03:45:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8809C208C7
	for <linux-scsi@archiver.kernel.org>; Wed,  7 Oct 2020 03:45:58 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="UuMoP2At"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726949AbgJGDp6 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 6 Oct 2020 23:45:58 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:37246 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725970AbgJGDp6 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 6 Oct 2020 23:45:58 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0973jd4H167268;
        Wed, 7 Oct 2020 03:45:49 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : mime-version :
 content-type; s=corp-2020-01-29;
 bh=b1GP4lQ8cOxWY9w001mLW2vhSqwNcXeFoDiijm7s64E=;
 b=UuMoP2AtFdZticnNhDeQzTgQYrDnnO0rKliFL7RA63Cvu49FNXkORw0B2ffBW5oKn6LR
 LJzlPwMKevhcMm5nTDba8NDucDgp9+cVFkJWyz4oy21dBB8D6AqItDKeEGKeIqYgIBk7
 V69l5Ji3XfJc0N+7miw5r3VF1jQLoByhlkEMeyUx3PaxOPcpLINe0WcR/Ah6DjquhZg6
 ANdYT/PnrQF9aGWl8joe83QPz+z1XvLVSR8SsRNUgcnqGU2MxMg9j2er7yZ5BDeFvp7z
 DhpB1WZZ+weCFCzQhChKCETM/grv+Z1osj3bx3agERDx8mUf9ElANPhxgI8DTtEL8Vg6 kQ== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2120.oracle.com with ESMTP id 33xhxmyd7u-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Wed, 07 Oct 2020 03:45:49 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0973VAAi016290;
        Wed, 7 Oct 2020 03:43:49 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userp3020.oracle.com with ESMTP id 33yyjgm4hu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 07 Oct 2020 03:43:49 +0000
Received: from abhmp0013.oracle.com (abhmp0013.oracle.com [141.146.116.19])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 0973hlsJ032653;
        Wed, 7 Oct 2020 03:43:47 GMT
Received: from ca-mkp.ca.oracle.com (/10.159.214.123)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 06 Oct 2020 20:43:47 -0700
To:     Douglas Gilbert <dgilbert@interlog.com>
Cc:     "Martin K. Petersen" <martin.petersen@oracle.com>,
        Viswas G <Viswas.G@microchip.com.com>,
        linux-scsi@vger.kernel.org,
        Vasanthalakshmi.Tharmarajan@microchip.com, Viswas.G@microchip.com,
        Ruksar.devadi@microchip.com,
        Jinpu Wang <jinpu.wang@cloud.ionos.com>
Subject: Re: [PATCH V2 0/4] pm80xx updates.
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq14kn6687m.fsf@ca-mkp.ca.oracle.com>
References: <20201005145011.23674-1-Viswas.G@microchip.com.com>
        <yq1r1qa7pw7.fsf@ca-mkp.ca.oracle.com>
        <81c98e02-75cf-5f9d-612f-a67a374811c3@interlog.com>
Date:   Tue, 06 Oct 2020 23:43:44 -0400
In-Reply-To: <81c98e02-75cf-5f9d-612f-a67a374811c3@interlog.com> (Douglas
        Gilbert's message of "Tue, 6 Oct 2020 23:03:27 -0400")
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9766 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=1 adultscore=0 bulkscore=0
 phishscore=0 mlxlogscore=929 mlxscore=0 spamscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2010070022
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9766 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 malwarescore=0 bulkscore=0
 impostorscore=0 lowpriorityscore=0 suspectscore=1 phishscore=0
 mlxlogscore=945 adultscore=0 clxscore=1015 spamscore=0 priorityscore=1501
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2010070023
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Hello Doug,

> As for "imperative mood", I believe there is no such thing in English
> grammar.

"Imperative mood" is how it is described in submitting-patches.rst. I
deliberately use the same term in my feedback emails to make it easy for
the recipient to locate the relevant section in that file.

If you believe that the official process document should be amended,
feel free to reach out to linux-doc.

-- 
Martin K. Petersen	Oracle Linux Engineering
