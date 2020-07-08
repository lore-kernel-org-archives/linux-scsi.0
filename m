Return-Path: <SRS0=1cZD=AT=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 39203C433E0
	for <linux-scsi@archiver.kernel.org>; Wed,  8 Jul 2020 06:07:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 165A52078A
	for <linux-scsi@archiver.kernel.org>; Wed,  8 Jul 2020 06:07:27 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="Gqw1JS5X"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729728AbgGHGHX (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 8 Jul 2020 02:07:23 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:35420 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726151AbgGHGHX (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 8 Jul 2020 02:07:23 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 06866XsW097277;
        Wed, 8 Jul 2020 06:07:06 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=corp-2020-01-29;
 bh=zbUe8+eWeMckW3BnQP2YB70WdC5mxjWWXtoZJ2w9iFA=;
 b=Gqw1JS5XWE2RVrhzmjiFju1+94atpFumZg+9Pc9Kx4anWQ2azONAWHNU6oRat4ArYxfH
 LRNc1IAz0VBX9u/SOaGdYuSDVOvjPXTFf+dzoglOKyjsJuw9Qfr4dRFyVclqwwKLNCMo
 SOBgVBb50gdO40+Se8U8vIkgiu5vGVl1pwmSZ2rC7iymE09mz8SEoAb3G1oMcMoO0qlp
 ChirTQIgMlNWVRGElhFjMYrSDZzxDZw0cDV1wTHcv9zhML1ljwTbiKqbcihBdIcQYugy
 vRQhaN+3gJGw/7QInhirzGkYHcJaE2qMDYaU3P3hcti53T94jh8hdBKi9xi/O2/aRSbM Zw== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2120.oracle.com with ESMTP id 323sxxvqku-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Wed, 08 Jul 2020 06:07:06 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0685x9gJ145207;
        Wed, 8 Jul 2020 06:07:06 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userp3020.oracle.com with ESMTP id 324n4se4mc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 08 Jul 2020 06:07:06 +0000
Received: from abhmp0013.oracle.com (abhmp0013.oracle.com [141.146.116.19])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 0686728V024859;
        Wed, 8 Jul 2020 06:07:02 GMT
Received: from ca-mkp.ca.oracle.com (/10.156.108.201)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 07 Jul 2020 23:07:02 -0700
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     avri.altman@wdc.com, alim.akhtar@samsung.com,
        asutoshd@codeaurora.org, beanhuo@micron.com, jejb@linux.ibm.com,
        tomas.winkler@intel.com, stanley.chu@mediatek.com,
        Bean Huo <huobean@gmail.com>, bvanassche@acm.org,
        cang@codeaurora.org
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
Subject: Re: [PATCH] scsi: ufs: change upiu_flags to be u8
Date:   Wed,  8 Jul 2020 02:06:48 -0400
Message-Id: <159418828149.5152.10735454372874086994.b4-ty@oracle.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200706123936.24799-1-huobean@gmail.com>
References: <20200706123936.24799-1-huobean@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9675 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 phishscore=0
 mlxlogscore=999 spamscore=0 adultscore=0 malwarescore=0 suspectscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2004280000 definitions=main-2007080041
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9675 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 lowpriorityscore=0 mlxlogscore=999
 bulkscore=0 impostorscore=0 adultscore=0 cotscore=-2147483648 phishscore=0
 priorityscore=1501 clxscore=1015 malwarescore=0 suspectscore=0 spamscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2004280000 definitions=main-2007080042
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Mon, 6 Jul 2020 14:39:36 +0200, Bean Huo wrote:

> According to the UFS Spec, the Flags in the UPIU is one-byte length, not
> 4 bytes. change it to be u8.

Applied to 5.9/scsi-queue, thanks!

[1/1] scsi: ufs: Change upiu_flags to be u8
      https://git.kernel.org/mkp/scsi/c/a23064c4123b

-- 
Martin K. Petersen	Oracle Linux Engineering
