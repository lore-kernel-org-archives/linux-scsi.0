Return-Path: <SRS0=8UCH=7J=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DDB84C433E0
	for <linux-scsi@archiver.kernel.org>; Wed, 27 May 2020 02:15:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B38662075F
	for <linux-scsi@archiver.kernel.org>; Wed, 27 May 2020 02:15:15 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="PlfVhglU"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725836AbgE0CPP (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 26 May 2020 22:15:15 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:46910 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725271AbgE0CPP (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 26 May 2020 22:15:15 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 04R2COWM164804;
        Wed, 27 May 2020 02:15:07 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=corp-2020-01-29;
 bh=B8ApPcY/tIazHhsS+vzu6lbpX4bzI1fdFm/o1K4XfkA=;
 b=PlfVhglU4HJ0rJYWFvuQferNl/r3k2eQ1VwE6VFVedgzxItXppbxCGbmXwvSNLOs5qfD
 ETu2h+9S2TvOQo+9R8m4VkrI0+2j3DMAT2ifp8QafBMn/+afTlIpnhYfyi9phE1r6Wkk
 +Up4YJznsXmgBAJ+LGvKhNYwNFefUE4h4rgtJrqjckSAscsGr9pRRsjoLDvLzfeIJQ1x
 WqzxiuVhw0fR2J1nA6tF5vbD+nqpo5CqV4/cqDQWexPry+fJ37R+JsSor9WDoCZO3Kxh
 SBHMxaMpx0wJJ+h/HioPwZDDjpS6xa9cj9oVJE7jigStfFw2cuneurepVI/FY/U2eeeM pA== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by aserp2120.oracle.com with ESMTP id 318xe1cy0p-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Wed, 27 May 2020 02:15:07 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 04R2Cof4060311;
        Wed, 27 May 2020 02:13:07 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userp3030.oracle.com with ESMTP id 317dryjttb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 27 May 2020 02:13:07 +0000
Received: from abhmp0014.oracle.com (abhmp0014.oracle.com [141.146.116.20])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 04R2D5Mi017217;
        Wed, 27 May 2020 02:13:05 GMT
Received: from ca-mkp.ca.oracle.com (/10.156.108.201)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 26 May 2020 19:13:04 -0700
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     open-iscsi@googlegroups.com, Bob Liu <bob.liu@oracle.com>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, jejb@linux.ibm.com, lduncan@suse.com,
        cleech@redhat.com
Subject: Re: [RFC RESEND PATCH v2] scsi: iscsi: register sysfs for iscsi workqueue
Date:   Tue, 26 May 2020 22:12:51 -0400
Message-Id: <159054550933.12032.6330104964795657980.b4-ty@oracle.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200505011908.15538-1-bob.liu@oracle.com>
References: <20200505011908.15538-1-bob.liu@oracle.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9633 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 phishscore=0 malwarescore=0
 mlxlogscore=999 adultscore=0 suspectscore=0 bulkscore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2004280000
 definitions=main-2005270013
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9633 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 mlxlogscore=999
 adultscore=0 cotscore=-2147483648 mlxscore=0 bulkscore=0
 priorityscore=1501 phishscore=0 lowpriorityscore=0 malwarescore=0
 clxscore=1015 impostorscore=0 suspectscore=0 classifier=spam adjust=0
 reason=mlx scancount=1 engine=8.12.0-2004280000
 definitions=main-2005270013
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Tue, 5 May 2020 09:19:08 +0800, Bob Liu wrote:

> Motivation:
> This patch enable setting cpu affinity through "cpumask" for iscsi workqueues
> (iscsi_q_xx and iscsi_eh), so as to get performance isolation.
> 
> The max number of active worker was changed form 1 to 2, because "cpumask" of
> ordered workqueue isn't allowed to change.
> 
> [...]

Applied to 5.8/scsi-queue, thanks!

[1/1] scsi: iscsi: Register sysfs for iscsi workqueue
      https://git.kernel.org/mkp/scsi/c/3ce419662dd4

-- 
Martin K. Petersen	Oracle Linux Engineering
