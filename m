Return-Path: <SRS0=8UCH=7J=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2D915C433DF
	for <linux-scsi@archiver.kernel.org>; Wed, 27 May 2020 02:15:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0CD2B2075F
	for <linux-scsi@archiver.kernel.org>; Wed, 27 May 2020 02:15:41 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="C1LQYV9L"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726064AbgE0CPi (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 26 May 2020 22:15:38 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:42738 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725271AbgE0CPi (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 26 May 2020 22:15:38 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 04R2BjUd057186;
        Wed, 27 May 2020 02:15:21 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=corp-2020-01-29;
 bh=mghp+WpbdLMN0nDPLyfzed/1h7X13BvnjtY+Osza9A4=;
 b=C1LQYV9LfP5bvnSkNrP4Sgtk2MWKdoD5Zc2Vt4kmW/TIb4YMrf+/AkZc8MaDqD3XxYZB
 bQZnEsFKh9MTVH3wiu6sFFBZYcAdvNhrv39TwUAuqT2b1VvHD8NrRsepvwrNu4ATPVSt
 GFXqPAZvUf9Axc88vtFWdPNP8XIQdWbKlhxEVa6uLiUmuzzakZW1586MLMqsBn2IdoaH
 SMDpLp5W2//GZZtQTJFqkUQofEjLEzLi4Xahp81Vwmqg4h1RudfNOuBNTUgbbF1XLcL8
 62QGBa6I5weuZnFjXza6u3GGkkLrH1/dioQSw99Pdaym82rbR3nUVZWTyB5R6SCe7XSA 2w== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2120.oracle.com with ESMTP id 318xbjvyr2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Wed, 27 May 2020 02:15:21 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 04R27XpX133148;
        Wed, 27 May 2020 02:13:20 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3020.oracle.com with ESMTP id 317j5q90dv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 27 May 2020 02:13:20 +0000
Received: from abhmp0013.oracle.com (abhmp0013.oracle.com [141.146.116.19])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 04R2DIAw024162;
        Wed, 27 May 2020 02:13:20 GMT
Received: from ca-mkp.ca.oracle.com (/10.156.108.201)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 26 May 2020 19:13:18 -0700
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     Dick Kennedy <dick.kennedy@broadcom.com>,
        linux-scsi@vger.kernel.org, Xiyu Yang <xiyuyang19@fudan.edu.cn>,
        James Smart <james.smart@broadcom.com>,
        linux-kernel@vger.kernel.org,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        Xin Tan <tanxin.ctf@gmail.com>, yuanxzhang@fudan.edu.cn,
        kjlu@umn.edu
Subject: Re: [PATCH] scsi: lpfc: Fix lpfc_nodelist leak when processing unsolicited event
Date:   Tue, 26 May 2020 22:13:03 -0400
Message-Id: <159054550934.12032.465431351148000035.b4-ty@oracle.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <1590416184-52592-1-git-send-email-xiyuyang19@fudan.edu.cn>
References: <1590416184-52592-1-git-send-email-xiyuyang19@fudan.edu.cn>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9633 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 spamscore=0 suspectscore=1
 mlxlogscore=999 mlxscore=0 adultscore=0 phishscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2004280000
 definitions=main-2005270012
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9633 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 spamscore=0 mlxscore=0
 lowpriorityscore=0 priorityscore=1501 phishscore=0 cotscore=-2147483648
 suspectscore=1 bulkscore=0 clxscore=1011 impostorscore=0 malwarescore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2004280000 definitions=main-2005270013
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Mon, 25 May 2020 22:16:24 +0800, Xiyu Yang wrote:

> In order to create or activate a new node, lpfc_els_unsol_buffer()
> invokes lpfc_nlp_init() or lpfc_enable_node() or lpfc_nlp_get(), all of
> them will return a reference of the specified lpfc_nodelist object to
> "ndlp" with increased refcnt.
> 
> When lpfc_els_unsol_buffer() returns, local variable "ndlp" becomes
> invalid, so the refcount should be decreased to keep refcount balanced.
> 
> [...]

Applied to 5.8/scsi-queue, thanks!

[1/1] scsi: lpfc: Fix lpfc_nodelist leak when processing unsolicited event
      https://git.kernel.org/mkp/scsi/c/7217e6e694da

-- 
Martin K. Petersen	Oracle Linux Engineering
