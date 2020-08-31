Return-Path: <SRS0=g0vc=CJ=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 84CBBC433E2
	for <linux-scsi@archiver.kernel.org>; Mon, 31 Aug 2020 17:43:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4D4282071B
	for <linux-scsi@archiver.kernel.org>; Mon, 31 Aug 2020 17:43:35 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="Ake1FkAq"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728090AbgHaRn1 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 31 Aug 2020 13:43:27 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:35624 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726085AbgHaRnZ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 31 Aug 2020 13:43:25 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 07VHU4tL143364;
        Mon, 31 Aug 2020 17:43:20 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=corp-2020-01-29;
 bh=U/KiOg5GPat+PpOb8+jXl7gYYV0mngm0iEqdM9oam2w=;
 b=Ake1FkAquCDuAEFLrk0NDSDKXe7LpJmqUre2cWavvS6XOYgeBt19jPGzY23QwsPlpKZj
 /gRwI2vQhmZYb/iqTdc146ofxeGK3apydQRv6jT259nYFXkzSiKsfCScbD91HKhXPbX3
 QvdkY6wk1niLO4hOey4vYov6Zaj4ypvJhcMWXxW6SOx6e0AM2+rdttHVpQEoZRFiUWYg
 IIET4vnDGRPDZV9U5naMW/uWOiC+yes5SWigZhZUXU4Wdm3boilxupvKQgIu7CvhzN2k
 rbiCloyRobHEYwAQwV24sMeksBHg7yljGqseQt1xNS9P79EhzbaYvq9rvmeH+PBS2FpT ug== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2120.oracle.com with ESMTP id 337eykyjr3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Mon, 31 Aug 2020 17:43:20 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 07VHeYN4165537;
        Mon, 31 Aug 2020 17:41:20 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3020.oracle.com with ESMTP id 3380x0v0px-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 31 Aug 2020 17:41:19 +0000
Received: from abhmp0011.oracle.com (abhmp0011.oracle.com [141.146.116.17])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 07VHfIH3012383;
        Mon, 31 Aug 2020 17:41:18 GMT
Received: from ca-mkp.ca.oracle.com (/10.156.108.201)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 31 Aug 2020 10:41:17 -0700
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     QLogic-Storage-Upstream@qlogic.com, jejb@linux.ibm.com,
        lalit.chandivade@qlogic.com,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        michaelc@cs.wisc.edu, JBottomley@Parallels.com,
        vikas.chaudhary@qlogic.com
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        kernel-janitors@vger.kernel.org, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] scsi: qla4xxx: Fix an error handling path in 'qla4xxx_get_host_stats()'
Date:   Mon, 31 Aug 2020 13:41:04 -0400
Message-Id: <159889566023.22322.13450314707743765419.b4-ty@oracle.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200802101527.676054-1-christophe.jaillet@wanadoo.fr>
References: <20200802101527.676054-1-christophe.jaillet@wanadoo.fr>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9730 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 spamscore=0 phishscore=0
 mlxlogscore=990 adultscore=0 suspectscore=0 bulkscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2008310105
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9730 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 adultscore=0
 priorityscore=1501 phishscore=0 mlxlogscore=988 mlxscore=0
 lowpriorityscore=0 clxscore=1015 spamscore=0 bulkscore=0 impostorscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2008310104
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Sun, 2 Aug 2020 12:15:27 +0200, Christophe JAILLET wrote:

> Update the size used in 'dma_free_coherent()' in order to match the one
> used in the corresponding 'dma_alloc_coherent()'.

Applied to 5.10/scsi-queue, thanks!

[1/1] scsi: qla4xxx: Fix an error handling path in 'qla4xxx_get_host_stats()'
      https://git.kernel.org/mkp/scsi/c/574918e69720

-- 
Martin K. Petersen	Oracle Linux Engineering
