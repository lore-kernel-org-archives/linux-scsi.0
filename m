Return-Path: <SRS0=Yj8A=7C=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4724CC433E0
	for <linux-scsi@archiver.kernel.org>; Wed, 20 May 2020 02:30:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2661F2075F
	for <linux-scsi@archiver.kernel.org>; Wed, 20 May 2020 02:30:22 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="qUPohkQR"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728585AbgETCaU (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 19 May 2020 22:30:20 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:33520 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726938AbgETCaS (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 19 May 2020 22:30:18 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 04K2Rpuv030611;
        Wed, 20 May 2020 02:30:14 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=corp-2020-01-29;
 bh=Jv+flDIWRrmF/SONlySx4xgud1oSWFI3sl4meZRPiM4=;
 b=qUPohkQRH4AVpNch2pwv9hc2W2lZmNBC/FgEp2NBDgVk+Wv/4rXnW+YVweSNKMAAKyeC
 6XfmHUDre9Czezczfq5evSlQkNKkc7kwMpBvRPWKT6XJAaqOtdKVonzoXesN0UEB5VuY
 ebwcgDd1715GdJQh8TsF5UW3na1RWB5GcDt5Sa7c4OIxTKAOGMpIvVycT3hua8wCjrQM
 lu1X97vQHyB36VlTYv6t4rj38lLfjxiHPKD3ODi+4r8aejp+e2gPYPM+7BoCBv5suugD
 9Ue4PC9rDOFAj87RZEPuYbVxzhEta+hLYdLnDLvd7X9beuAUmyqsxp/cYUCZgStnohIC WA== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by aserp2120.oracle.com with ESMTP id 31284m0m8u-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Wed, 20 May 2020 02:30:14 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 04K2SPIT001202;
        Wed, 20 May 2020 02:30:13 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userp3030.oracle.com with ESMTP id 314gm65d0q-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 20 May 2020 02:30:13 +0000
Received: from abhmp0001.oracle.com (abhmp0001.oracle.com [141.146.116.7])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 04K2UBPa027910;
        Wed, 20 May 2020 02:30:11 GMT
Received: from ca-mkp.ca.oracle.com (/10.156.108.201)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 19 May 2020 19:30:11 -0700
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     mchristi@redhat.com, target-devel@vger.kernel.org,
        linux-scsi@vger.kernel.org,
        Bodo Stroesser <bstroesser@ts.fujitsu.com>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH v2] scsi: target: tcmu: userspace must not complete queued commands
Date:   Tue, 19 May 2020 22:30:01 -0400
Message-Id: <158994171818.20861.2092677585621625446.b4-ty@oracle.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200518164833.12775-1-bstroesser@ts.fujitsu.com>
References: <20200518164833.12775-1-bstroesser@ts.fujitsu.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9626 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 mlxlogscore=952
 adultscore=0 phishscore=0 mlxscore=0 spamscore=0 suspectscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2004280000 definitions=main-2005200018
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9626 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 mlxscore=0
 cotscore=-2147483648 impostorscore=0 malwarescore=0 mlxlogscore=978
 lowpriorityscore=0 phishscore=0 spamscore=0 bulkscore=0 adultscore=0
 priorityscore=1501 clxscore=1015 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2004280000 definitions=main-2005200018
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Mon, 18 May 2020 18:48:33 +0200, Bodo Stroesser wrote:

> When tcmu queues a new command - no matter whether in command
> ring or in qfull_queue - a cmd_id from IDR udev->commands is
> assigned to the command.
> 
> If userspaces sends a wrong command completion containing the
> cmd_id of a command on the qfull_queue, tcmu_handle_completions()
> finds the command in the IDR and calls tcmu_handle_completion()
> for it. This might do some nasty things, because commands in
> qfull_queue do not have a valid dbi list.
> 
> [...]

Applied to 5.8/scsi-queue, thanks!

[1/1] scsi: target: tcmu: Userspace must not complete queued commands
      https://git.kernel.org/mkp/scsi/c/61fb24822166

PS. Please run checkpatch. Had to fix a bunch of whitespace errors.

-- 
Martin K. Petersen	Oracle Linux Engineering
