Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-14.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5BB1FC43217
	for <linux-scsi@archiver.kernel.org>; Fri,  8 Jan 2021 04:21:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 40A5121D40
	for <linux-scsi@archiver.kernel.org>; Fri,  8 Jan 2021 04:21:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727769AbhAHEUy (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 7 Jan 2021 23:20:54 -0500
Received: from userp2130.oracle.com ([156.151.31.86]:49588 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727761AbhAHEUx (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 7 Jan 2021 23:20:53 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 1084A72P106543;
        Fri, 8 Jan 2021 04:20:02 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=D8QYOeQGXSvAjNKY8pJROHJxHIla8RMRGjNlXk1LD30=;
 b=mUALdhUikHSxGR4nrlgP8mr/ZuYXmE12KLJG1OC+eT0h6RuhDjh5O89REmI9cu/1zeI0
 x2LOeAUBwK8FostLfmv+Achp66ewhKwpoH12RNE9nDZbnSIqHRIVH8FJscOOoNVi8naX
 yKDtP7BpyUAXt993WRIQXT5smtNNaVdUlyoNwo3f7VH02s+EG9p5/N6iS+DH2Gn+H69h
 QCN97WkX2V9wQ+WOG+3isMQhHlIUSZH0pj0buptXDfTJmQyLZ48CkMrxDy2v9I+diY1M
 /RnqL6mxeUkZqeUcCgRHXHwkcoesxR2pO4O23Q2hiHZr1JJsIKpwWAEcKcsCRrMhRO8+ GQ== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2130.oracle.com with ESMTP id 35wftxeyte-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Fri, 08 Jan 2021 04:20:02 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 10849SPe170611;
        Fri, 8 Jan 2021 04:20:01 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3030.oracle.com with ESMTP id 35w3g3r4rg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 08 Jan 2021 04:20:01 +0000
Received: from abhmp0009.oracle.com (abhmp0009.oracle.com [141.146.116.15])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 1084Jv6I031018;
        Fri, 8 Jan 2021 04:20:00 GMT
Received: from ca-mkp.ca.oracle.com (/10.156.108.201)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 07 Jan 2021 20:19:56 -0800
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     Tyrel Datwyler <tyreld@linux.ibm.com>,
        james.bottomley@hansenpartnership.com
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        kernel test robot <lkp@intel.com>,
        linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org, brking@linux.ibm.com
Subject: Re: [PATCH] ibmvfc: fix missing cast of ibmvfc_event pointer to u64 handle
Date:   Thu,  7 Jan 2021 23:19:41 -0500
Message-Id: <161007949340.9892.9443484467279726588.b4-ty@oracle.com>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210106203721.1054693-1-tyreld@linux.ibm.com>
References: <20210106203721.1054693-1-tyreld@linux.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9857 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 malwarescore=0 adultscore=0
 phishscore=0 spamscore=0 mlxlogscore=999 suspectscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2101080021
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9857 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 suspectscore=0 mlxscore=0
 bulkscore=0 priorityscore=1501 impostorscore=0 clxscore=1015
 lowpriorityscore=0 mlxlogscore=999 malwarescore=0 spamscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2101080021
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Wed, 6 Jan 2021 14:37:21 -0600, Tyrel Datwyler wrote:

> Commit 2aa0102c6688 ("scsi: ibmvfc: Use correlation token to tag
> commands") sets the vfcFrame correlation token to the pointer handle of
> the associated ibmvfc_event. However, that commit failed to cast the
> pointer to an appropriate type which in this case is a u64. As such
> sparse warnings are generated for both correlation token assignments.
> 
>  ibmvfc.c:2375:36: sparse: incorrect type in argument 1 (different base types)
>  ibmvfc.c:2375:36: sparse: expected unsigned long long [usertype] val
>  ibmvfc.c:2375:36: sparse: got struct ibmvfc_event *[assigned] evt
> 
> [...]

Applied to 5.11/scsi-fixes, thanks!

[1/1] ibmvfc: fix missing cast of ibmvfc_event pointer to u64 handle
      https://git.kernel.org/mkp/scsi/c/901d01c8e50c

-- 
Martin K. Petersen	Oracle Linux Engineering
