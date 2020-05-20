Return-Path: <SRS0=Yj8A=7C=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 536A4C433E0
	for <linux-scsi@archiver.kernel.org>; Wed, 20 May 2020 02:30:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 223192075F
	for <linux-scsi@archiver.kernel.org>; Wed, 20 May 2020 02:30:31 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="dmBboRb/"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728596AbgETCa1 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 19 May 2020 22:30:27 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:57998 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728415AbgETCa1 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 19 May 2020 22:30:27 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 04K2RBHE084678;
        Wed, 20 May 2020 02:30:21 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=corp-2020-01-29;
 bh=x7lJWCOox4jkdsPlPXMyrL9vU0HyFBMasClnr6W3zDs=;
 b=dmBboRb/1L5IYKmX2ps+rQshKhXLhogBJMvtthSdW+sD8gkKYz32Tyogrde4FkFYNeVN
 4U730/OHth/ziCNHe+5ol0Tmu127NBYVlHn2yzvDFEU0mCfSq334EUfkf3I8NftN6kL9
 OHC1V22F/Tts6xspwG1qsfJ/P7DRexmmGJBG6tS5hPTZJ0qXuzD9p3XyzHBC6jsDt7yt
 VHw0ZU5PKfbeo6oLC3H+3hWO5iKGhNdQ/88iSOgBGnIlMsOmrG8eqwvjWiFbZHh1cksO
 P9GOzHwR+teL3Lk44xN2FlezC4OfeK+CbgLMl5oO0gsI8l+LEueb5BGhT0GRu1hppXCL NQ== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2130.oracle.com with ESMTP id 3127kr8n9q-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Wed, 20 May 2020 02:30:21 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 04K2SPDT001293;
        Wed, 20 May 2020 02:30:21 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3030.oracle.com with ESMTP id 314gm65d7g-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 20 May 2020 02:30:21 +0000
Received: from abhmp0009.oracle.com (abhmp0009.oracle.com [141.146.116.15])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 04K2UKba011815;
        Wed, 20 May 2020 02:30:20 GMT
Received: from ca-mkp.ca.oracle.com (/10.156.108.201)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 19 May 2020 19:30:19 -0700
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     mchristi@redhat.com, Lance Digby <lance.digby@gmail.com>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        target-devel@vger.kernel.org, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v1 target] target: Add initiatorname to NON_EXISTENT_LUN error
Date:   Tue, 19 May 2020 22:30:07 -0400
Message-Id: <158994171818.20861.13529776753176885593.b4-ty@oracle.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <9b13bb2e1f52f1792cd81850ee95bf3781bb5363.1589759816.git.lance.digby@gmail.com>
References: <9b13bb2e1f52f1792cd81850ee95bf3781bb5363.1589759816.git.lance.digby@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9626 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 mlxlogscore=937
 adultscore=0 phishscore=0 mlxscore=0 spamscore=0 suspectscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2004280000 definitions=main-2005200018
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9626 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 phishscore=0 spamscore=0
 bulkscore=0 clxscore=1011 priorityscore=1501 mlxscore=0 impostorscore=0
 suspectscore=0 mlxlogscore=969 malwarescore=0 cotscore=-2147483648
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2004280000 definitions=main-2005200018
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Mon, 18 May 2020 11:02:16 +1000, Lance Digby wrote:

> The NON_EXISTENT_LUN error can be written without an error condition
> on the initiator responsible. Adding the initiatorname to this message
> will reduce the effort required to fix this when many initiators are
> supported by a target.
> 
> This version ensures the initiator name is also printed on the same
> message in transport_lookup_tmr_lun for consistency.

Applied to 5.8/scsi-queue, thanks!

[1/1] scsi: target: core: Add initiatorname to NON_EXISTENT_LUN error
      https://git.kernel.org/mkp/scsi/c/5482d56bfedf

-- 
Martin K. Petersen	Oracle Linux Engineering
