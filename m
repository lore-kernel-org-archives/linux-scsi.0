Return-Path: <SRS0=m8O6=CU=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.9 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 12B06C43461
	for <linux-scsi@archiver.kernel.org>; Fri, 11 Sep 2020 16:32:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CDAB8208FE
	for <linux-scsi@archiver.kernel.org>; Fri, 11 Sep 2020 16:32:14 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="Ukl4e3wp"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726616AbgIKQcL (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 11 Sep 2020 12:32:11 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:39232 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726523AbgIKQbz (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 11 Sep 2020 12:31:55 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 08BESpG5164100;
        Fri, 11 Sep 2020 14:30:46 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : mime-version :
 content-type; s=corp-2020-01-29;
 bh=HmeGucpRUi0Eo916me/DU96md3K7p33K6XQmtvXjH+s=;
 b=Ukl4e3wpUDJLhAeU3vKOUT78/8IR6o2lCf6YSVCFRcG+BUHWhql2nqUcdbi3Pw85aix6
 cDpvv4QRkpnc7ggUEoYiCOhzPFpCeXJMug6YIH421gtPQfhe0X8/6zV5EX7dJBnXNKjW
 85GLEBsKXi9J0shYRYZfMb8ZEqcweCDAwbfbUW0ZxnSiJiHsUA76cAzn/Tij2tfApSBv
 GyKqGnsQcUI4dqv5/B4u83ZShce1128Auz+0g4z4n7DTBGSDpCJk7s30Tdc4mWSsZQyG
 YR/7U2cHcnUr4d5wkf5SIzZO+MuuMKCUrE5RkQqjqoSAJ779ugzh7LGXQb7Gpt2Yu+3E uw== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by aserp2120.oracle.com with ESMTP id 33c2mmegqv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Fri, 11 Sep 2020 14:30:46 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 08BEOZeE103473;
        Fri, 11 Sep 2020 14:28:45 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3030.oracle.com with ESMTP id 33cmm3fku3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 11 Sep 2020 14:28:45 +0000
Received: from abhmp0018.oracle.com (abhmp0018.oracle.com [141.146.116.24])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 08BESfHb018511;
        Fri, 11 Sep 2020 14:28:41 GMT
Received: from ca-mkp.ca.oracle.com (/10.159.214.123)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 11 Sep 2020 07:28:41 -0700
To:     Adrian Hunter <adrian.hunter@intel.com>
Cc:     "Martin K. Petersen" <martin.petersen@oracle.com>,
        "James E . J . Bottomley" <jejb@linux.ibm.com>,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        Alim Akhtar <alim.akhtar@samsung.com>,
        Avri Altman <avri.altman@wdc.com>,
        Can Guo <cang@codeaurora.org>,
        Stanley Chu <stanley.chu@mediatek.com>
Subject: Re: [PATCH V2] scsi: ufs-pci: Add LTR support for Intel controllers
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq1v9gkz8ux.fsf@ca-mkp.ca.oracle.com>
References: <20200827072030.24655-1-adrian.hunter@intel.com>
        <yq14kohexka.fsf@ca-mkp.ca.oracle.com>
        <dc615e02-18a3-334d-dbc4-8aba94e4be6b@intel.com>
        <a27fa387-356c-82e1-a49f-62602336589e@intel.com>
        <841d40b4-1181-2bd3-2c7f-4c00e76cbe60@intel.com>
Date:   Fri, 11 Sep 2020 10:28:38 -0400
In-Reply-To: <841d40b4-1181-2bd3-2c7f-4c00e76cbe60@intel.com> (Adrian Hunter's
        message of "Fri, 11 Sep 2020 17:01:08 +0300")
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9740 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 phishscore=0 suspectscore=1
 spamscore=0 mlxlogscore=999 adultscore=0 malwarescore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2009110118
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9740 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 priorityscore=1501
 phishscore=0 adultscore=0 bulkscore=0 clxscore=1015 mlxlogscore=999
 malwarescore=0 suspectscore=1 lowpriorityscore=0 spamscore=0
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2009110119
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Adrian,

>> Now there seem to be conflicts between 5.10/scsi-queue and v5.9-rc4.
>> I am not sure what I can do?
>
> Now I see it does apply to James' for-next branch.  Can it be applied there?
>

I'll set up a dedicated branch.

-- 
Martin K. Petersen	Oracle Linux Engineering
