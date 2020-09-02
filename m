Return-Path: <SRS0=1vUj=CL=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9E77BC433E6
	for <linux-scsi@archiver.kernel.org>; Wed,  2 Sep 2020 01:20:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5E0E120707
	for <linux-scsi@archiver.kernel.org>; Wed,  2 Sep 2020 01:20:46 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="XwWeBzx0"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726140AbgIBBUp (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 1 Sep 2020 21:20:45 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:37320 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726107AbgIBBUp (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 1 Sep 2020 21:20:45 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0821K9ZG147903;
        Wed, 2 Sep 2020 01:20:40 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : mime-version :
 content-type; s=corp-2020-01-29;
 bh=6Ix/wFPP3jGYKh2npUpM7gRAU5rDqRb638VaJZQP+Lc=;
 b=XwWeBzx0nPtmsWrDZiALcCEOCupiGaZVGq4lwIBL7RGCaMUnlDQ96p72iKxiPNvrpOeN
 Fes2BAQRSbgFl60BKAV4KOw5VgSd3Z1P3q0KdfB0LDLKm+YwlsgyOZPxU7CCIawDv59K
 81Ff9gO5wl5UDc2MlD5epKqq/jdkBpJkXfHKRcJYadHxrICxxzum7HOKhXY81QuF6a/y
 WEI0kzH1FZVi7ILoxcVbHSnVttPEAKlrxeDfaZnKXGOSRWbrD/zAdVrQKtVdanFsMbIS
 H9UWrGovEcgwJ5K3PBu9cXEG2wnR3rtmQOZ0lYSWbApp2kZnofAZ303HgYlLzAXM72jU Ww== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by aserp2120.oracle.com with ESMTP id 337eym7jja-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Wed, 02 Sep 2020 01:20:40 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0821Jhq6126284;
        Wed, 2 Sep 2020 01:20:39 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userp3030.oracle.com with ESMTP id 3380xxkr73-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 02 Sep 2020 01:20:39 +0000
Received: from abhmp0010.oracle.com (abhmp0010.oracle.com [141.146.116.16])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 0821KcQn029208;
        Wed, 2 Sep 2020 01:20:38 GMT
Received: from ca-mkp.ca.oracle.com (/10.159.214.123)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 01 Sep 2020 18:20:37 -0700
To:     Viswas G <Viswas.G@microchip.com.com>
Cc:     <linux-scsi@vger.kernel.org>,
        <Vasanthalakshmi.Tharmarajan@microchip.com>,
        <Viswas.G@microchip.com>, <deepak.ukey@microchip.com>,
        <martin.petersen@oracle.com>, <yuuzheng@google.com>,
        <auradkar@google.com>, <vishakhavc@google.com>,
        <bjashnani@google.com>, <radha@google.com>, <akshatzen@google.com>
Subject: Re: [PATCH v8 2/2] pm80xx : Staggered spin up support.
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq1k0xdf006.fsf@ca-mkp.ca.oracle.com>
References: <20200820185123.27354-1-Viswas.G@microchip.com.com>
        <20200820185123.27354-3-Viswas.G@microchip.com.com>
Date:   Tue, 01 Sep 2020 21:20:34 -0400
In-Reply-To: <20200820185123.27354-3-Viswas.G@microchip.com.com> (Viswas G.'s
        message of "Fri, 21 Aug 2020 00:21:23 +0530")
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9731 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 adultscore=0 phishscore=0
 malwarescore=0 bulkscore=0 mlxscore=0 mlxlogscore=999 suspectscore=1
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2009020009
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9731 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=1 adultscore=0
 priorityscore=1501 phishscore=0 mlxlogscore=999 mlxscore=0
 lowpriorityscore=0 clxscore=1011 spamscore=0 bulkscore=0 impostorscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2009020009
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Viswas,

> As a part of drive discovery, driver will initaite the drive spin up.
> If all drives do spin up together, it will result in large power
> consumption. To reduce the power consumption, driver provide an option
> to make a small group of drives (say 3 or 4 drives together) to do the
> spin up. The delay between two spin up group and no of drives to spin
> up (group) can be programmed by the customer in seeprom and driver
> will use it to control the spinup.

Please implement this in libsas as several people have suggested.
Thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
