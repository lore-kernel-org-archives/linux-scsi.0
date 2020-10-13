Return-Path: <SRS0=AAGU=DU=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 65518C433DF
	for <linux-scsi@archiver.kernel.org>; Tue, 13 Oct 2020 22:44:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2696621D7A
	for <linux-scsi@archiver.kernel.org>; Tue, 13 Oct 2020 22:44:18 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="DsrEByOD"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728959AbgJMWnd (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 13 Oct 2020 18:43:33 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:34438 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728939AbgJMWnc (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 13 Oct 2020 18:43:32 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 09DMYHR2023303;
        Tue, 13 Oct 2020 22:43:25 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=PWeN2iDB4NQPy2eaaVDuaFTKf8x+9FkhEM3VEvFipCM=;
 b=DsrEByODAge1UI47n10G/kgxXeSguYz4IgQDaIKFcXGBYlqQsv0pFvozgc6dhuasCOT/
 vToL4BMWINJBt/Em0yN95RLm89VAd/8y1xQHlZyVpSYCtcJuRl+8pnx/SyKFOson39JS
 18XBsPKzDexlTVWvKBbINv1so8ov0cn5AMq3x5tmw4A4re/ZAqwivJk/Z+giO5vrsk9C
 p/83pcYGnI4o89K5ZXKoCmz57EZ200nd2AXzs9vWN+DPXb2qVSacWGVOC0ugKE+qCUor
 zHEOP1qi+NvbYDmXcxd6ADSDGBjrPyHcQc+9bUOyyXCnrfw6IMLVaHQw3p+gtkVzVAPt qg== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by aserp2120.oracle.com with ESMTP id 3434wkmr87-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Tue, 13 Oct 2020 22:43:25 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 09DMabj6049262;
        Tue, 13 Oct 2020 22:43:25 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userp3030.oracle.com with ESMTP id 343pvx1ssn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 13 Oct 2020 22:43:24 +0000
Received: from abhmp0019.oracle.com (abhmp0019.oracle.com [141.146.116.25])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 09DMhNIs014595;
        Tue, 13 Oct 2020 22:43:23 GMT
Received: from ca-mkp.ca.oracle.com (/10.156.108.201)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 13 Oct 2020 15:43:23 -0700
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     linux-kernel@vger.kernel.org, njavali@marvell.com,
        Pavel Machek <pavel@denx.de>, jejb@linux.ibm.com,
        linux-scsi@vger.kernel.org, GR-QLogic-Storage-Upstream@marvell.com
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH] qla2xxx: Use constant when it is known.
Date:   Tue, 13 Oct 2020 18:42:59 -0400
Message-Id: <160262862432.3018.8247533524614555067.b4-ty@oracle.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200921112340.GA19336@duo.ucw.cz>
References: <20200921112340.GA19336@duo.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9773 signatures=668681
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 mlxscore=0 adultscore=0
 bulkscore=0 mlxlogscore=958 suspectscore=0 malwarescore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2010130158
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9773 signatures=668681
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 lowpriorityscore=0 mlxscore=0
 malwarescore=0 phishscore=0 suspectscore=0 impostorscore=0 clxscore=1015
 spamscore=0 priorityscore=1501 bulkscore=0 adultscore=0 mlxlogscore=992
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2010130158
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Mon, 21 Sep 2020 13:23:40 +0200, Pavel Machek wrote:

> Directly return constant when it is known, to make code easier to
> understand.

Applied to 5.10/scsi-queue, thanks!

[1/1] scsi: qla2xxx: Use constant when it is known
      https://git.kernel.org/mkp/scsi/c/b994718760fa

-- 
Martin K. Petersen	Oracle Linux Engineering
