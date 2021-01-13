Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-14.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 429A7C433E6
	for <linux-scsi@archiver.kernel.org>; Wed, 13 Jan 2021 05:49:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DE8C523125
	for <linux-scsi@archiver.kernel.org>; Wed, 13 Jan 2021 05:49:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726222AbhAMFtk (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 13 Jan 2021 00:49:40 -0500
Received: from userp2130.oracle.com ([156.151.31.86]:46192 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726017AbhAMFtk (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 13 Jan 2021 00:49:40 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 10D5jXat131030;
        Wed, 13 Jan 2021 05:48:58 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=ZdlLA0J3cgMFa3o+rsAGl8bM5Pd5OEiX0zS0eMqJch4=;
 b=zRiWmbGkdXeBOInhyG92nZ0gZM9qlUvn3PpoZe/5lIcFSh4wEdPawqNqyoZUbIRxlPkg
 aHdtOJ7fc7RYATonMTCocIWJBzNZOV30qEchQwdnqWiBiSnXWwzq6ntbOo1fr3ZQ3Hk8
 +YpYUuiduNwcKPXqGNgh8U//D5Mus16owRieMtgAiT3BtQGOBIzL6A74JcdvjZmPl204
 TMIFNkAxe9y878XhZRyIHuBt+zmiDYimGp+xyosJuTQ95/LX1SSCN/n/9/rtx9P1dFcg
 voPQ0c5LxXOYiQIetFUkJbp5hrqwFs6YYgayeurpmZjhVQHNa8alZY/sfWWC1cnl9ARz Eg== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2130.oracle.com with ESMTP id 360kvk1k56-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 13 Jan 2021 05:48:58 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 10D5e5J3133992;
        Wed, 13 Jan 2021 05:48:57 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3030.oracle.com with ESMTP id 360kf00pv0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 13 Jan 2021 05:48:57 +0000
Received: from abhmp0007.oracle.com (abhmp0007.oracle.com [141.146.116.13])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 10D5muCL028809;
        Wed, 13 Jan 2021 05:48:56 GMT
Received: from ca-mkp.ca.oracle.com (/10.156.108.201)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 12 Jan 2021 21:48:56 -0800
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     Javed Hasan <jhasan@marvell.com>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, GR-QLogic-Storage-Upstream@marvell.com
Subject: Re: [PATCH v2] scsi: libfc: Avoid invoking response handler twice if ep is already completed.
Date:   Wed, 13 Jan 2021 00:48:52 -0500
Message-Id: <161051681547.32710.5220182110416028002.b4-ty@oracle.com>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201215194731.2326-1-jhasan@marvell.com>
References: <20201215194731.2326-1-jhasan@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9862 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 bulkscore=0 malwarescore=0
 suspectscore=0 adultscore=0 spamscore=0 mlxlogscore=877 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2101130034
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9862 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=883 phishscore=0
 lowpriorityscore=0 bulkscore=0 priorityscore=1501 malwarescore=0
 clxscore=1015 impostorscore=0 spamscore=0 mlxscore=0 suspectscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2101130034
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Tue, 15 Dec 2020 11:47:31 -0800, Javed Hasan wrote:

>   Issue :- race condition getting hit between the response handler
>   get called because of the exchange_mgr_reset() which clear out all
>   the active XID and the response we get via interrupt as the same time
> 
>   Below are the sequence of events occurring in case of
>   "issue/race condition" :-
>   rport ba0200: Port timeout, state PLOGI
>   rport ba0200: Port entered PLOGI state from PLOGI state
>   xid 1052: Exchange timer armed : 20000 msecs      xid timer armed here
>   rport ba0200: Received LOGO request while in state PLOGI
>   rport ba0200: Delete port
>   rport ba0200: work event 3
>   rport ba0200: lld callback ev 3
>   bnx2fc: rport_event_hdlr: event = 3, port_id = 0xba0200
>   bnx2fc: ba0200 - rport not created Yet!!
>   /* Here we reset any outstanding exchanges before
>    freeing rport using the exch_mgr_reset() */
>   xid 1052: Exchange timer canceled
>   /*Here we got two response for one xid*/
>   xid 1052: invoking resp(), esb 20000000 state 3
>   xid 1052: invoking resp(), esb 20000000 state 3
>   xid 1052: fc_rport_plogi_resp() : ep->resp_active 2
>   xid 1052: fc_rport_plogi_resp() : ep->resp_active 2

Applied to 5.11/scsi-fixes, thanks!

[1/1] scsi: libfc: Avoid invoking response handler twice if ep is already completed.
      https://git.kernel.org/mkp/scsi/c/b2b0f16fa65e

-- 
Martin K. Petersen	Oracle Linux Engineering
