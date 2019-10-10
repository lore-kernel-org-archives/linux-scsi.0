Return-Path: <SRS0=UT6l=YD=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C7FCCECE596
	for <linux-scsi@archiver.kernel.org>; Thu, 10 Oct 2019 02:29:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9E6EB206C0
	for <linux-scsi@archiver.kernel.org>; Thu, 10 Oct 2019 02:29:41 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="Duug+yMM"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732623AbfJJC3f (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 9 Oct 2019 22:29:35 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:36244 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726675AbfJJC3e (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 9 Oct 2019 22:29:34 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x9A2SdVR046703;
        Thu, 10 Oct 2019 02:29:33 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : references : date : in-reply-to : message-id : mime-version :
 content-type; s=corp-2019-08-05;
 bh=FNfvGZdgq5lIUJoQDdpUhmnVPaLVwiJ2+grwStiga/g=;
 b=Duug+yMMeRHswVU2m+GvfufhTf5ZIknDswr5/NN4d0/C/DYeBc5+40NxmpMjSuTT4gqz
 IjevoryT5aoDlHnj7WiOad6rT8NFtFqPX5bQa7GJtc7ErE5GCOPFy+P8V5vIds6owwaJ
 MoJYV3rwDRbK2xJsUuGzpuz5eU6sx0HOEXII1a7eV0YoHCpmWtcxDT0aQ4dpXrL5MWJ5
 XbeDUK/Bf8I1RV0N/GHEjFmZwMIJy15o0/otCPxPQtyYMUN0pzqFVBIfMGDzsRUr5uVm
 0VArNetwQnffgVsTDHxtHUsDhIIwfT5VE2zwkSYPBRvWc7rFHGGugVoR59rgmAdnMmew EA== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by aserp2120.oracle.com with ESMTP id 2vek4qr6tp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 10 Oct 2019 02:29:32 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x9A2Rttf008585;
        Thu, 10 Oct 2019 02:29:32 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3030.oracle.com with ESMTP id 2vh8k1wquv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 10 Oct 2019 02:29:32 +0000
Received: from abhmp0008.oracle.com (abhmp0008.oracle.com [141.146.116.14])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x9A2TUBr025895;
        Thu, 10 Oct 2019 02:29:31 GMT
Received: from ca-mkp.ca.oracle.com (/10.159.214.123)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 09 Oct 2019 19:29:30 -0700
To:     Allen Pais <allen.pais@oracle.com>
Cc:     martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        jejb@linux.ibm.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] qla2xxx: fix a potential NULL pointer dereference
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
References: <1568824618-4366-1-git-send-email-allen.pais@oracle.com>
Date:   Wed, 09 Oct 2019 22:29:28 -0400
In-Reply-To: <1568824618-4366-1-git-send-email-allen.pais@oracle.com> (Allen
        Pais's message of "Wed, 18 Sep 2019 22:06:58 +0530")
Message-ID: <yq1mue9jptj.fsf@oracle.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1.92 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9405 signatures=668684
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=723
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1908290000 definitions=main-1910100022
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9405 signatures=668684
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=800 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1908290000
 definitions=main-1910100022
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Allen,

> alloc_workqueue is not checked for errors and as a result,
> a potential NULL dereference could occur.

Applied to 5.4/scsi-fixes, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
