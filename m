Return-Path: <SRS0=t7w2=AI=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 23236C433E1
	for <linux-scsi@archiver.kernel.org>; Sat, 27 Jun 2020 03:09:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E94262084C
	for <linux-scsi@archiver.kernel.org>; Sat, 27 Jun 2020 03:09:54 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="hqBh3eYY"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725882AbgF0DJu (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 26 Jun 2020 23:09:50 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:37984 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725828AbgF0DJu (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 26 Jun 2020 23:09:50 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 05R38NmS140600;
        Sat, 27 Jun 2020 03:09:34 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=corp-2020-01-29;
 bh=owtYMg382pvIRe6QEkYQxyD7p2+iQVUSI2A9n+iemU4=;
 b=hqBh3eYYhrYYKtOg/vOEfYCJ5JQ0Zn/rlKeVIXT6lkp0hIOwk8MIYjORVyZFZccl4VjI
 2qj/vAUkJKAEgN1XTAqOJrVXp2IHAQAQVtV9mR/nmLpLpT8bOFmusD+2zkSTFOaKNo9M
 4fP6nSF8mmgAyDtCZ/yv3Gi6LM8gutxDUXMoNujG8TbyVI6pWaVaT9YnfkAe6TfSkkL8
 kE5i3CdaFoNDZGzxrPP7Y6SGEToOel2SejpLQCWtYHm5EeoEt1e4Srr94qBeNlIReELG
 ylo143KLTvmK41xYRcRXTwJHDTM5/yQBSXUMDzkrchUQlQdveJMCdGrRX3r89SiZPvdL Sw== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2120.oracle.com with ESMTP id 31wg3bkcdk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Sat, 27 Jun 2020 03:09:34 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 05R37ANL038440;
        Sat, 27 Jun 2020 03:09:33 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3020.oracle.com with ESMTP id 31wwwyr5d4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 27 Jun 2020 03:09:33 +0000
Received: from abhmp0009.oracle.com (abhmp0009.oracle.com [141.146.116.15])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 05R39RFj011711;
        Sat, 27 Jun 2020 03:09:27 GMT
Received: from ca-mkp.ca.oracle.com (/10.156.108.201)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Sat, 27 Jun 2020 03:09:27 +0000
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     jejb@linux.ibm.com,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        linux@armlinux.org.uk
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, kernel-janitors@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH] scsi: cumana_2: Fix different dev_id between 'request_irq()' and 'free_irq()'
Date:   Fri, 26 Jun 2020 23:09:22 -0400
Message-Id: <159322718419.11145.4815572344428827274.b4-ty@oracle.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200625204730.943520-1-christophe.jaillet@wanadoo.fr>
References: <20200530073555.577414-1-christophe.jaillet@wanadoo.fr> <20200625204730.943520-1-christophe.jaillet@wanadoo.fr>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9664 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=894 suspectscore=0
 adultscore=0 mlxscore=0 spamscore=0 bulkscore=0 malwarescore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2004280000 definitions=main-2006270020
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9664 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 suspectscore=0 phishscore=0
 malwarescore=0 cotscore=-2147483648 adultscore=0 lowpriorityscore=0
 impostorscore=0 clxscore=1015 mlxscore=0 mlxlogscore=913 spamscore=0
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2004280000 definitions=main-2006270020
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Thu, 25 Jun 2020 22:47:30 +0200, Christophe JAILLET wrote:

> The dev_id used in 'request_irq()' and 'free_irq()' should match.
> Use 'info' in both cases.

Applied to 5.9/scsi-queue, thanks!

[1/1] scsi: cumana_2: Fix different dev_id between request_irq() and free_irq()
      https://git.kernel.org/mkp/scsi/c/040ab9c4fd00

-- 
Martin K. Petersen	Oracle Linux Engineering
