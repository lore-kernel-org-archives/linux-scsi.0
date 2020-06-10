Return-Path: <SRS0=mOiQ=7X=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A24ECC433E0
	for <linux-scsi@archiver.kernel.org>; Wed, 10 Jun 2020 11:53:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7911D2074B
	for <linux-scsi@archiver.kernel.org>; Wed, 10 Jun 2020 11:53:40 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="x2kiaGPx"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728619AbgFJLxg (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 10 Jun 2020 07:53:36 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:46988 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728583AbgFJLxf (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 10 Jun 2020 07:53:35 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 05ABqQtc139508;
        Wed, 10 Jun 2020 11:53:19 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : mime-version :
 content-type; s=corp-2020-01-29;
 bh=lLuLvWf3spNYNgQdNK2VUalQ9x6mRO55PW3ewD79iEg=;
 b=x2kiaGPxJ+E1anrnxZXxIbVkTnjBICzvi33S0QcvKPUdDLjbrJrbV/ZKaBR6QcFQlU0z
 u6D7kBXw9ER1cXoMqVRTWbseJsbodfOsneudcDLPVOb7L7iEt7a8h0fr4DpPXhsnTAeA
 +Lgp6CFQOxFmlWwXDid3kvqQUVaLIbJcqJtb340AQCgRuiT33w0aVvpUdtA/OBmqTsTs
 8f/TDAVn9owDJ3o9bGOzYRKvMzkP71h9LVlK1W4xBAvLW5IKTm007gw9Ro9+/+78sdkj
 NixQQkTdZvtGV3YfNTltr7lzg8D65yhhXtevVWphC/nGE8RoHkFx/fCyZV157ywLzwCy zA== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2130.oracle.com with ESMTP id 31g2jr9x5x-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Wed, 10 Jun 2020 11:53:19 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 05ABqRE6194928;
        Wed, 10 Jun 2020 11:53:18 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3020.oracle.com with ESMTP id 31gn28tbgp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 10 Jun 2020 11:53:18 +0000
Received: from abhmp0011.oracle.com (abhmp0011.oracle.com [141.146.116.17])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 05ABr80w012721;
        Wed, 10 Jun 2020 11:53:11 GMT
Received: from ca-mkp.ca.oracle.com (/10.159.214.123)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 10 Jun 2020 04:53:08 -0700
To:     Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Cc:     "Martin K. Petersen" <martin.petersen@oracle.com>,
        jejb@linux.ibm.com, linux@armlinux.org.uk,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-scsi@vger.kernel.org
Subject: Re: [PATCH] scsi: powertec: Fix different dev_id between
 'request_irq()' and 'free_irq()'
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq11rmnrvcl.fsf@ca-mkp.ca.oracle.com>
References: <20200530072933.576851-1-christophe.jaillet@wanadoo.fr>
        <159175686974.7062.8526082970785072740.b4-ty@oracle.com>
        <08f63617-03df-71cf-70c4-00f08a9f51d8@wanadoo.fr>
Date:   Wed, 10 Jun 2020 07:53:06 -0400
In-Reply-To: <08f63617-03df-71cf-70c4-00f08a9f51d8@wanadoo.fr> (Christophe
        JAILLET's message of "Wed, 10 Jun 2020 07:35:49 +0200")
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9647 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 suspectscore=0 mlxscore=0
 phishscore=0 adultscore=0 bulkscore=0 malwarescore=0 mlxlogscore=649
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2004280000
 definitions=main-2006100091
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9647 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 impostorscore=0
 cotscore=-2147483648 priorityscore=1501 spamscore=0 suspectscore=0
 lowpriorityscore=0 bulkscore=0 mlxlogscore=701 malwarescore=0 mlxscore=0
 phishscore=0 clxscore=1015 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2004280000 definitions=main-2006100091
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Christophe,

>> [1/1] scsi: powertec: Fix different dev_id between request_irq() and free_irq()
>>        https://git.kernel.org/mkp/scsi/c/af7b415a1ebf
>>
> Please revert,

Dropped (x2).

-- 
Martin K. Petersen	Oracle Linux Engineering
