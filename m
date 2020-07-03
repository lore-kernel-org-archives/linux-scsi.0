Return-Path: <SRS0=NMWN=AO=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 72C1BC433E0
	for <linux-scsi@archiver.kernel.org>; Fri,  3 Jul 2020 04:06:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5138920724
	for <linux-scsi@archiver.kernel.org>; Fri,  3 Jul 2020 04:06:16 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="WEljvCeF"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725937AbgGCEGM (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 3 Jul 2020 00:06:12 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:34924 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725294AbgGCEGM (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 3 Jul 2020 00:06:12 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0633xR8s097771;
        Fri, 3 Jul 2020 04:06:03 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=corp-2020-01-29;
 bh=LeWbrm8TYj4y9U2ldIQcfga2SR1ikeuUSI76X1adpzo=;
 b=WEljvCeFyInkhSxz1wsbIOxncCttsCl6Nj0/8JJErhXpvVop1NCwWfTzPAmxQ15zCKxJ
 sKMW7PTdpAxa4gBwbPZeylJ1mVxUnJ30AINBySi5GGZ4gjIGZ1xJwECTk97L8xS75Dsh
 4v2Oy9cXQylSRubve2h9StDnWs7VAkvo6VzezRA0rEpLotNyiBLbKCYh8CTkQeZZXL2k
 JRkz7N6nSmxEXyTLh6ipgvT+4Av0TJeNtYV8QLjuTmMZP271Sa/q8EprECG5Y+nlllly
 0getILNJeo5Fh7q6OhtitNHmpWlZHkeLuPyqH34RgogP9k/5P/v18SWn8FLSFtt14l+8 wQ== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2120.oracle.com with ESMTP id 31wxrnkp7v-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Fri, 03 Jul 2020 04:06:03 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0633wiGU162058;
        Fri, 3 Jul 2020 04:04:02 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userp3020.oracle.com with ESMTP id 31xfvwnc8n-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 03 Jul 2020 04:04:02 +0000
Received: from abhmp0009.oracle.com (abhmp0009.oracle.com [141.146.116.15])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 063440op002587;
        Fri, 3 Jul 2020 04:04:00 GMT
Received: from ca-mkp.ca.oracle.com (/10.156.108.201)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 03 Jul 2020 04:04:00 +0000
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     linux@armlinux.org.uk,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        jejb@linux.ibm.com
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: Re: [PATCH V2] scsi: powertec: Fix different dev_id between 'request_irq()' and 'free_irq()'
Date:   Fri,  3 Jul 2020 00:03:53 -0400
Message-Id: <159374899165.14731.13358873635382558544.b4-ty@oracle.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200626035948.944148-1-christophe.jaillet@wanadoo.fr>
References: <08f63617-03df-71cf-70c4-00f08a9f51d8@wanadoo.fr> <20200626035948.944148-1-christophe.jaillet@wanadoo.fr>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9670 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 adultscore=0 spamscore=0
 phishscore=0 malwarescore=0 mlxlogscore=907 bulkscore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2004280000
 definitions=main-2007030027
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9670 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 mlxlogscore=916
 priorityscore=1501 impostorscore=0 bulkscore=0 clxscore=1015
 malwarescore=0 phishscore=0 adultscore=0 cotscore=-2147483648
 lowpriorityscore=0 suspectscore=0 spamscore=0 classifier=spam adjust=0
 reason=mlx scancount=1 engine=8.12.0-2004280000
 definitions=main-2007030027
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Fri, 26 Jun 2020 05:59:48 +0200, Christophe JAILLET wrote:

> The dev_id used in 'request_irq()' and 'free_irq()' should match.
> So use 'info' in both cases.

Applied to 5.9/scsi-queue, thanks!

[1/1] scsi: powertec: Fix different dev_id between request_irq() and free_irq()
      https://git.kernel.org/mkp/scsi/c/d179f7c76324

-- 
Martin K. Petersen	Oracle Linux Engineering
