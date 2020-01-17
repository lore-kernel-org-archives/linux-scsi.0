Return-Path: <SRS0=Mkh6=3G=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7DD64C33CAF
	for <linux-scsi@archiver.kernel.org>; Fri, 17 Jan 2020 01:29:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5516120728
	for <linux-scsi@archiver.kernel.org>; Fri, 17 Jan 2020 01:29:46 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="CeQQpeFl"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388092AbgAQB3m (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 16 Jan 2020 20:29:42 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:45718 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730070AbgAQB3m (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 16 Jan 2020 20:29:42 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 00H1O3hb155714;
        Fri, 17 Jan 2020 01:29:36 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : references : date : in-reply-to : message-id : mime-version :
 content-type; s=corp-2019-08-05;
 bh=XYEZpW6I+SWVCI8l8yTQxH4M0FMw+uzWBFImgbXRtMo=;
 b=CeQQpeFl2xAtM5g/e+1p/8BGWws+OXyEl5Y/mSO3cZ2R4avd5GrKI6z/heg1KSFbWJvZ
 /86EJbF03qhPz+CgAgPGgbzTg6ZcMC/Y3L1+1XXPT/gmeD45t0IYjj8ToEljTheWyx+f
 8FtIhfp16RX9rAlbhwwE0iAfQyiw6hk6hjpoG+W8mb//AzJOf9SwZxBVtBr8yX4Fu29f
 kn1gNaMYuBePGJ76hlJtfPTPqKs/Tfrq5DeSgVoEa289FJoQSvoT1DIwmSHIEdV8xFn1
 edQyBVFzxVhyrTYTf94EvbvAVbthdA7mWKOo6w/wNQFxMzwKAZyFQkrB1J2Qhyz1u4VD ZQ== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2120.oracle.com with ESMTP id 2xf73u5whh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 17 Jan 2020 01:29:36 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 00H1O8KX086551;
        Fri, 17 Jan 2020 01:29:35 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3020.oracle.com with ESMTP id 2xk22xvxj3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 17 Jan 2020 01:29:35 +0000
Received: from abhmp0002.oracle.com (abhmp0002.oracle.com [141.146.116.8])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 00H1TYev010198;
        Fri, 17 Jan 2020 01:29:34 GMT
Received: from ca-mkp.ca.oracle.com (/10.159.214.123)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 16 Jan 2020 17:29:33 -0800
To:     Thomas Bogendoerfer <tbogendoerfer@suse.de>
Cc:     "Martin K. Petersen" <martin.petersen@oracle.com>,
        Michael Reed <mdr@sgi.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] scsi: qla1280: Fix dma firmware download, if dma address is 64bit
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
References: <20200114160936.1517-1-tbogendoerfer@suse.de>
        <yq18sm8nitd.fsf@oracle.com>
        <20200116124335.43a679198f514cbdf7a929c4@suse.de>
Date:   Thu, 16 Jan 2020 20:29:31 -0500
In-Reply-To: <20200116124335.43a679198f514cbdf7a929c4@suse.de> (Thomas
        Bogendoerfer's message of "Thu, 16 Jan 2020 12:43:35 +0100")
Message-ID: <yq1d0bina4k.fsf@oracle.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1.92 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9502 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=836
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1911140001 definitions=main-2001170008
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9502 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=912 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1911140001
 definitions=main-2001170008
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Thomas,

> kbuild robot found an issue in the patch. Do you want a new version of
> the patch or an incremental patch ?

Incremental, please.

-- 
Martin K. Petersen	Oracle Linux Engineering
