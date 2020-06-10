Return-Path: <SRS0=mOiQ=7X=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1721EC433DF
	for <linux-scsi@archiver.kernel.org>; Wed, 10 Jun 2020 02:04:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E3DE42074B
	for <linux-scsi@archiver.kernel.org>; Wed, 10 Jun 2020 02:04:58 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="c7691Btk"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726030AbgFJCE6 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 9 Jun 2020 22:04:58 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:52222 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725798AbgFJCE6 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 9 Jun 2020 22:04:58 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 05A23S1x029034;
        Wed, 10 Jun 2020 02:04:57 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=corp-2020-01-29;
 bh=fdcpaRNTJQZb91R4Ee4nR/703dNwazwd2stO4gdgO1Y=;
 b=c7691BtkQ/hcVN7RNwGNuuNavM7FuO0Qe02zzNr4RtPR2WyDCWrLKU2TL4C7xQ5DVkaR
 SW0tlO5ESM4xyd2iQVHwMIHZlZOgqxRfKoqCzHViZL06MTpZXpQJy8Eyes/0zyoxH1TG
 LRlFvk94KN1qcCNSPQC1zLqqgoo640DwhDJMp/W94Y42ToyUmjho6u7TfPE6mK34A8Kx
 tvY31J+6ttp+F/NkBAcYRHlMu+S9ZDSyiAMiEm72k25Wizoy2cPHVqOqVnsZDQ4AjudA
 7rbKvwvaCTcZMGJhD5jHQ4J9c/mGbTi0vM3LVkomCAiQ0hsMo8k8RJrsUXPDjabXw/xu Uw== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by aserp2120.oracle.com with ESMTP id 31jepnsqeb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Wed, 10 Jun 2020 02:04:56 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 05A1vvcp042870;
        Wed, 10 Jun 2020 02:02:56 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3030.oracle.com with ESMTP id 31gmqpffap-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 10 Jun 2020 02:02:56 +0000
Received: from abhmp0011.oracle.com (abhmp0011.oracle.com [141.146.116.17])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 05A22uBA004567;
        Wed, 10 Jun 2020 02:02:56 GMT
Received: from ca-mkp.ca.oracle.com (/10.156.108.201)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 09 Jun 2020 19:02:55 -0700
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     target-devel@vger.kernel.org, michael.christie@oracle.com,
        Sudhakar Panneerselvam <sudhakar.panneerselvam@oracle.com>,
        linux-scsi@vger.kernel.org
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        shirley.ma@oracle.com
Subject: Re: [PATCH v4 0/4] target: fix NULL pointer dereference
Date:   Tue,  9 Jun 2020 22:02:48 -0400
Message-Id: <159175452258.16072.16589931095798965569.b4-ty@oracle.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <1591559913-8388-1-git-send-email-sudhakar.panneerselvam@oracle.com>
References: <1591559913-8388-1-git-send-email-sudhakar.panneerselvam@oracle.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9647 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 bulkscore=0 mlxscore=0
 mlxlogscore=999 adultscore=0 spamscore=0 suspectscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2004280000
 definitions=main-2006100013
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9647 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 lowpriorityscore=0 suspectscore=0
 priorityscore=1501 bulkscore=0 clxscore=1015 phishscore=0 impostorscore=0
 malwarescore=0 mlxscore=0 cotscore=-2147483648 adultscore=0 spamscore=0
 mlxlogscore=999 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2004280000 definitions=main-2006100013
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Sun, 7 Jun 2020 19:58:29 +0000, Sudhakar Panneerselvam wrote:

> The following set of commits address a NULL pointer dereference and some
> refactoring around this issue.
> 
> v4:
>  - initialize the LUN in transport_init_se_cmd()
> 
> v3:
>  - fix NULL pointer dereference when cdb initialization fails
> 
> [...]

Applied to 5.8/scsi-queue, thanks!

[1/4] scsi: target: Factor out a new helper, target_cmd_init_cdb()
      https://git.kernel.org/mkp/scsi/c/f98c2ddf8ba3
[2/4] scsi: target: Initialize LUN in transport_init_se_cmd()
      https://git.kernel.org/mkp/scsi/c/a36840d80027
[3/4] scsi: target: Fix NULL pointer dereference
      https://git.kernel.org/mkp/scsi/c/9e95fb805dc0
[4/4] scsi: target: Rename target_setup_cmd_from_cdb() to target_cmd_parse_cdb()
      https://git.kernel.org/mkp/scsi/c/987db58737e2

-- 
Martin K. Petersen	Oracle Linux Engineering
