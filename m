Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D5B2BC64E7B
	for <linux-scsi@archiver.kernel.org>; Tue, 24 Nov 2020 03:58:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7BE5B2085B
	for <linux-scsi@archiver.kernel.org>; Tue, 24 Nov 2020 03:58:43 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="YKZDVTrk"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728067AbgKXD6g (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 23 Nov 2020 22:58:36 -0500
Received: from userp2130.oracle.com ([156.151.31.86]:36342 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728468AbgKXD6f (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 23 Nov 2020 22:58:35 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0AO3uT0w079281;
        Tue, 24 Nov 2020 03:58:23 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=bA7CzgRK1lXS7YiO5uGQArtgq38/15OaAjPlpfNXVa4=;
 b=YKZDVTrkPQ+QL6MsFQFXGg8gpsa52kXodr/P7BXImhEyc6s1pb3Nv7CBx2psctAESLAU
 B8Nq5DV8OVoBhOA5zrSXnFqxQ15vYZ7q5+HL4B1CoosrLs/KYP/ZdLFQL2YYzFErpc4E
 PrblC9K58c5IieniXQ9zKgO+I13U4ukUxSjMGC4zhEMA2cvVVLZqYK0LVkrUe2U3kgrK
 fEPWveN2iX5SKlpc5fnUG1tgpMUCH1UkifKmieMcxtCu5nub9ncG74VCa6CCtwh/s+ku
 ai46SI6qrJR2+Bfr8lHtGSpR4SQcg+GZ+NB1cetpKJxCTPx3OGcMrND0T9b9pH8sVbAD fA== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2130.oracle.com with ESMTP id 34xtaqkykx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Tue, 24 Nov 2020 03:58:23 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0AO3ssEH115654;
        Tue, 24 Nov 2020 03:58:23 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userp3030.oracle.com with ESMTP id 34yctvu0wk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 24 Nov 2020 03:58:23 +0000
Received: from abhmp0008.oracle.com (abhmp0008.oracle.com [141.146.116.14])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 0AO3wLV0006685;
        Tue, 24 Nov 2020 03:58:21 GMT
Received: from ca-mkp.ca.oracle.com (/10.156.108.201)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 23 Nov 2020 19:58:20 -0800
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     james.bottomley@hansenpartnership.com,
        Tyrel Datwyler <tyreld@linux.ibm.com>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        brking@linux.ibm.com, linux-kernel@vger.kernel.org,
        linux-scsi@vger.kernel.org, linuxppc-dev@lists.ozlabs.org
Subject: Re: [PATCH v3 0/6] ibmvfc: Protocol definition updates and new targetWWPN Support
Date:   Mon, 23 Nov 2020 22:58:09 -0500
Message-Id: <160618683552.24173.5839850324071459334.b4-ty@oracle.com>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201118011104.296999-1-tyreld@linux.ibm.com>
References: <20201118011104.296999-1-tyreld@linux.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9814 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 suspectscore=0
 malwarescore=0 spamscore=0 phishscore=0 mlxlogscore=999 adultscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2011240021
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9814 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 spamscore=0 phishscore=0
 mlxlogscore=999 clxscore=1015 suspectscore=0 lowpriorityscore=0
 priorityscore=1501 bulkscore=0 impostorscore=0 adultscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2011240021
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Tue, 17 Nov 2020 19:10:58 -0600, Tyrel Datwyler wrote:

> Several Management Datagrams (MADs) have been reversioned to add a targetWWPN
> field that is intended to better identify a target over in place of the scsi_id.
> This patchset adds the new protocol definitions and implements support for using
> the new targetWWPN field and exposing the capability to the VIOS. This
> targetWWPN support is a prerequisuite for upcoming channelization/MQ support.
> 
> changes in v3:
> * addressed field naming consistency in Patches 2 & 5 in response to [brking]
> * fixed commit log typos
> * fixed bad rebase of Patch 4 such that it now compiles
> 
> [...]

Applied to 5.11/scsi-queue, thanks!

[1/6] scsi: ibmvfc: Deduplicate common ibmvfc_cmd init code
      https://git.kernel.org/mkp/scsi/c/fad74a1be2db
[2/6] scsi: ibmvfc: Add new fields for version 2 of several MADs
      https://git.kernel.org/mkp/scsi/c/c16b8a6d8af1
[3/6] scsi: ibmvfc: Add helper for testing capability flags
      https://git.kernel.org/mkp/scsi/c/a318c2b71cce
[4/6] scsi: ibmvfc: Add FC payload retrieval routines for versioned vfcFrames
      https://git.kernel.org/mkp/scsi/c/5a9d16f71c26
[5/6] scsi: ibmvfc: Add support for target_wwpn field in v2 MADs and vfcFrame
      https://git.kernel.org/mkp/scsi/c/ebc7c74bd2dc
[6/6] scsi: ibmvfc: Advertise client support for targetWWPN using v2 commands
      https://git.kernel.org/mkp/scsi/c/e4af87b7079e

-- 
Martin K. Petersen	Oracle Linux Engineering
