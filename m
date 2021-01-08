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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 72D02C433E9
	for <linux-scsi@archiver.kernel.org>; Fri,  8 Jan 2021 04:21:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4FAA9207B8
	for <linux-scsi@archiver.kernel.org>; Fri,  8 Jan 2021 04:21:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727394AbhAHEUi (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 7 Jan 2021 23:20:38 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:52402 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727330AbhAHEUh (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 7 Jan 2021 23:20:37 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 108491t6096231;
        Fri, 8 Jan 2021 04:19:53 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=DDuxeQBXo/1pfS790U9+UPR1ss0xHnQAZ3q/ZRc7iBA=;
 b=c2rrBPZqw5UNcoVFM8lq7UzInlZZF5ccQ9j0NWS608MYq0eJgKHMPGI564D2D1t2OJ+H
 HwgahoWSVqoEBSAR9Y4O8FyGaEqfDV+Y8VsxCa4Vrx1Gywm4+Oqi+VkkrBO6hJqN6RSR
 WSIsPZP3VcVX1GawEB3vkd/9kqpG6zHYm3pnHHJ8orDUw7XCyP8ELhqHZNO1zJYOH06k
 wemKtb6pLA0EjEQW/4dVHQKx9kBsILZN0117ncAaELxTzs4/rpsRuX5epVJ/QvjpAONl
 +hfWMU1M3QkT5q+iHzUdl2osBAWdxB7Z8waMskg/zlI/1JgrQ7WiaMDDGRf/TtAPpXIL 9Q== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2120.oracle.com with ESMTP id 35wepmfd96-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Fri, 08 Jan 2021 04:19:53 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 1084Atka079230;
        Fri, 8 Jan 2021 04:19:53 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3020.oracle.com with ESMTP id 35v1fc2x8a-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 08 Jan 2021 04:19:53 +0000
Received: from abhmp0015.oracle.com (abhmp0015.oracle.com [141.146.116.21])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 1084JmVB028921;
        Fri, 8 Jan 2021 04:19:49 GMT
Received: from ca-mkp.ca.oracle.com (/10.156.108.201)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 08 Jan 2021 04:19:47 +0000
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     Dinghao Liu <dinghao.liu@zju.edu.cn>, kjlu@umn.edu
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
Subject: Re: [PATCH] [v2] scsi: scsi_debug: Fix memleak in scsi_debug_init
Date:   Thu,  7 Jan 2021 23:19:33 -0500
Message-Id: <161007949338.9892.4671065272962496715.b4-ty@oracle.com>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201226061503.20050-1-dinghao.liu@zju.edu.cn>
References: <20201226061503.20050-1-dinghao.liu@zju.edu.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9857 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=953 phishscore=0
 suspectscore=0 spamscore=0 bulkscore=0 adultscore=0 mlxscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2101080021
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9857 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 bulkscore=0 spamscore=0
 impostorscore=0 phishscore=0 lowpriorityscore=0 suspectscore=0
 priorityscore=1501 mlxscore=0 malwarescore=0 clxscore=1011 mlxlogscore=978
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2101080021
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Sat, 26 Dec 2020 14:15:03 +0800, Dinghao Liu wrote:

> When sdeb_zbc_model does not match BLK_ZONED_NONE,
> BLK_ZONED_HA or BLK_ZONED_HM, we should free sdebug_q_arr
> to prevent memleak. Also there is no need to execute
> sdebug_erase_store() on failure of sdeb_zbc_model_str().

Applied to 5.11/scsi-fixes, thanks!

[1/1] scsi: scsi_debug: Fix memleak in scsi_debug_init
      https://git.kernel.org/mkp/scsi/c/3b01d7ea4dae

-- 
Martin K. Petersen	Oracle Linux Engineering
