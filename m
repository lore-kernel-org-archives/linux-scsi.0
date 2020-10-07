Return-Path: <SRS0=2LRe=DO=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.6 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DCD7EC46466
	for <linux-scsi@archiver.kernel.org>; Wed,  7 Oct 2020 03:48:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 94C7221707
	for <linux-scsi@archiver.kernel.org>; Wed,  7 Oct 2020 03:48:46 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="YJdXl8zJ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727440AbgJGDsp (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 6 Oct 2020 23:48:45 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:36354 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727237AbgJGDs2 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 6 Oct 2020 23:48:28 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0973iHlk044875;
        Wed, 7 Oct 2020 03:48:21 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=omZMH5Or/El0SqWoBZ4UJc8zxDcIRUBPrT8N2B7bIuE=;
 b=YJdXl8zJE9lExgEnbGRl4abJhMrBzQf1ODcSF1DvgO+jURgWOQTFV2OdSAtrWvNz4UDy
 jlZ2ht3ds5Ob7yCjeyZjtBmdGIwxHD6WB/2yR1NGrr0VZuBOa5Pra3elAxeE6rbav6KZ
 zta1CRSARwJqGuOhw7bURfKOWopB5YdNzmfYYhDbkQ4zGnoPY65Ysn21SSsPfcza6co8
 evm6mrAoKzwcAfc2eHkpbKbpkCsn55g14qDqrhAhhIIQ9K2+eIGVkcFd05+UfU4mYljy
 /UXxjCmOqWJSNMudhNapDBAjvocgb4f8LleG9q46cHWIyNfUP963sy2hT09M9uVSWSok HQ== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2120.oracle.com with ESMTP id 33ym34mjy6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Wed, 07 Oct 2020 03:48:21 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0973j94W041285;
        Wed, 7 Oct 2020 03:48:20 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userp3020.oracle.com with ESMTP id 33yyjgm88j-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 07 Oct 2020 03:48:20 +0000
Received: from abhmp0010.oracle.com (abhmp0010.oracle.com [141.146.116.16])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 0973mK0B025078;
        Wed, 7 Oct 2020 03:48:20 GMT
Received: from ca-mkp.ca.oracle.com (/10.156.108.201)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 06 Oct 2020 20:48:19 -0700
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     cleech@redhat.com, lduncan@suse.com,
        Manish Rangankar <mrangankar@marvell.com>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        GR-QLogic-Storage-Upstream@marvell.com, linux-scsi@vger.kernel.org
Subject: Re: [PATCH] qedi: Add schedule_hw_err_handler callback for fan failure
Date:   Tue,  6 Oct 2020 23:47:59 -0400
Message-Id: <160204240577.16940.16015638421960363877.b4-ty@oracle.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200924070338.8270-1-mrangankar@marvell.com>
References: <20200924070338.8270-1-mrangankar@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9766 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 adultscore=0 bulkscore=0
 phishscore=0 mlxlogscore=972 mlxscore=0 spamscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2010070023
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9766 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 impostorscore=0 priorityscore=1501
 mlxscore=0 mlxlogscore=999 clxscore=1015 bulkscore=0 spamscore=0
 malwarescore=0 phishscore=0 suspectscore=0 adultscore=0 lowpriorityscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2010070023
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Thu, 24 Sep 2020 00:03:38 -0700, Manish Rangankar wrote:

> On fan failure event from MFW, bring down active connections,
> and unload the firmware context.

Applied to 5.10/scsi-queue, thanks!

[1/1] scsi: qedi: Add schedule_hw_err_handler callback for fan failure
      https://git.kernel.org/mkp/scsi/c/7dc71ac8eb0b

-- 
Martin K. Petersen	Oracle Linux Engineering
