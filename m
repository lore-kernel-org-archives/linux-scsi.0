Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.2 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A5686C83017
	for <linux-scsi@archiver.kernel.org>; Tue,  1 Dec 2020 05:05:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4921C20725
	for <linux-scsi@archiver.kernel.org>; Tue,  1 Dec 2020 05:05:33 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="Qs5b5OAu"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726245AbgLAFFZ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 1 Dec 2020 00:05:25 -0500
Received: from userp2130.oracle.com ([156.151.31.86]:32930 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726157AbgLAFFZ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 1 Dec 2020 00:05:25 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0B14nSb6128511;
        Tue, 1 Dec 2020 05:04:37 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=lGUp/B1uRQZoC4m4D+Ga5RSkHZ0LgZyALlWto3zNUUQ=;
 b=Qs5b5OAu4VmDnD/J5RP81w/48e0f68T9MaaTm8uAs7OoKhus3rQgOz3gn57sNfRnGB3a
 ZsYmM1/Q+Sl5TbNTnB+wjccS5pRQuTJlYQJ4zlk0sBDyOrLzyhTcaZfhyZze5iB9g91V
 evllv/OfXfBThwqnUf6P8RjLOaWD0ct+wG9sggpzFbY9Kkzku0qo9dU8XFs1a8sGg6pc
 0nLAtSjOfrLmBFFboAeTYOnlyW3FX7IWhz7ur/om2dupVgwezuV6RPH5NB7hRxVPf8sf
 TckTJGtXxIhGfVCPfKQBYHUG6GaDGTfoBRJ7dWzAb4vHVLCMB3xBe7qwBlOqLrAnlnda sQ== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2130.oracle.com with ESMTP id 353dyqgkxu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Tue, 01 Dec 2020 05:04:37 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0B14oG6B157302;
        Tue, 1 Dec 2020 05:04:36 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userp3020.oracle.com with ESMTP id 3540armyey-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 01 Dec 2020 05:04:36 +0000
Received: from abhmp0012.oracle.com (abhmp0012.oracle.com [141.146.116.18])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 0B154ZjZ018697;
        Tue, 1 Dec 2020 05:04:35 GMT
Received: from ca-mkp.ca.oracle.com (/10.156.108.201)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 30 Nov 2020 21:04:34 -0800
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     linux-scsi@vger.kernel.org, jejb@linux.ibm.com,
        jinpu.wang@cloud.ionos.com, Xu Wang <vulab@iscas.ac.cn>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] scsi: pm8001: remove casting kcalloc
Date:   Tue,  1 Dec 2020 00:04:24 -0500
Message-Id: <160636449894.25598.8648752568103050488.b4-ty@oracle.com>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201120083648.9319-1-vulab@iscas.ac.cn>
References: <20201120083648.9319-1-vulab@iscas.ac.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9821 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=876 bulkscore=0
 phishscore=0 mlxscore=0 adultscore=0 malwarescore=0 suspectscore=1
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2012010033
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9821 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 bulkscore=0
 clxscore=1015 mlxscore=0 spamscore=0 priorityscore=1501 mlxlogscore=906
 suspectscore=1 lowpriorityscore=0 phishscore=0 adultscore=0
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2012010033
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Fri, 20 Nov 2020 08:36:48 +0000, Xu Wang wrote:

> Remove casting the values returned by kcalloc.

Applied to 5.11/scsi-queue, thanks!

[1/1] scsi: pm8001: Remove typecast for pointer returned by kcalloc()
      https://git.kernel.org/mkp/scsi/c/27a34943bd89

-- 
Martin K. Petersen	Oracle Linux Engineering
