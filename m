Return-Path: <SRS0=oFF2=AF=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 63F38C433DF
	for <linux-scsi@archiver.kernel.org>; Wed, 24 Jun 2020 04:29:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3C5842084D
	for <linux-scsi@archiver.kernel.org>; Wed, 24 Jun 2020 04:29:59 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="gNCwIE2N"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728831AbgFXE36 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 24 Jun 2020 00:29:58 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:53260 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727862AbgFXE36 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 24 Jun 2020 00:29:58 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 05O4MXIf053112;
        Wed, 24 Jun 2020 04:29:52 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=corp-2020-01-29;
 bh=BIxYwIDUiItD6ldeEnKYO++ESY7yEYfh4CFfC0MfsZE=;
 b=gNCwIE2NEtTv5EDrTdkFUThnxgcW3YHSMtn+yGsgNkGVlkg6iJBS6sWbaNvHlysxmjYE
 kXeCHVF82athsUdgb3j0pYBLMgbPGjA8+qv0e3e7punXSgvaZABTite6ewcG/LPImx6A
 oMpt9KgBXkMvVcjBPJZAT/5brhKVJlUW9Y7yVsd7kdr5y6WlUeSRzS1wBinIQ3rREByL
 aU+wItPVhmbOb6ClThvxTTVS6HCBosz/fOZHY2mXIVBltCVcZYK5jCvyNqV3SjnhwKRD
 eviZy11Ijrc8Cfvytp90oHfm8LI5PaOhIjov6vSD1WWh0QbdDIWLvd11QjP/wQ5J0nSs kQ== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2130.oracle.com with ESMTP id 31uut5gkpt-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Wed, 24 Jun 2020 04:29:52 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 05O4NFZT113232;
        Wed, 24 Jun 2020 04:29:52 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3030.oracle.com with ESMTP id 31uurq6un2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 24 Jun 2020 04:29:52 +0000
Received: from abhmp0004.oracle.com (abhmp0004.oracle.com [141.146.116.10])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 05O4TpOb031170;
        Wed, 24 Jun 2020 04:29:51 GMT
Received: from ca-mkp.ca.oracle.com (/10.156.108.201)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 24 Jun 2020 04:29:51 +0000
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     linux-scsi@vger.kernel.org, Tomas Henzl <thenzl@redhat.com>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        sreekanth.reddy@broadcom.com, ssaner@redhat.com
Subject: Re: [PATCH] mptscsih: fix read sense data size
Date:   Wed, 24 Jun 2020 00:29:43 -0400
Message-Id: <159297296072.9797.2628708627698948907.b4-ty@oracle.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200616150446.4840-1-thenzl@redhat.com>
References: <20200616150446.4840-1-thenzl@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9661 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 phishscore=0 mlxscore=0
 spamscore=0 mlxlogscore=999 bulkscore=0 suspectscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2004280000
 definitions=main-2006240031
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9661 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 clxscore=1011
 lowpriorityscore=0 bulkscore=0 adultscore=0 spamscore=0 suspectscore=0
 phishscore=0 impostorscore=0 cotscore=-2147483648 priorityscore=1501
 mlxscore=0 mlxlogscore=999 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2004280000 definitions=main-2006240031
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Tue, 16 Jun 2020 17:04:46 +0200, Tomas Henzl wrote:

> The sense data buffer in sense_buf_pool is allocated with
> size of MPT_SENSE_BUFFER_ALLOC(64) (multiplied by req_depth)
> while SNS_LEN(sc)(96) is used when reading the data.
> That may lead to a read from unallocated area,
> sometimes from another (unallocated) page.
> To fix this limit the read size to MPT_SENSE_BUFFER_ALLOC.

Applied to 5.8/scsi-fixes, thanks!

[1/1] scsi: mptscsih: Fix read sense data size
      https://git.kernel.org/mkp/scsi/c/afe89f115e84

-- 
Martin K. Petersen	Oracle Linux Engineering
