Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-14.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ED242C4332D
	for <linux-scsi@archiver.kernel.org>; Wed, 13 Jan 2021 05:50:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C0FAD23125
	for <linux-scsi@archiver.kernel.org>; Wed, 13 Jan 2021 05:50:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726483AbhAMFtu (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 13 Jan 2021 00:49:50 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:37008 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726435AbhAMFtu (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 13 Jan 2021 00:49:50 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 10D5j3UM096893;
        Wed, 13 Jan 2021 05:49:02 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=9rfJgOG+i/Amk8QXkMX5HJn31P4XWUWh1O+4Lz2JGmw=;
 b=Dbx17U5gHvdiF+HQjpT6xEKCXkRVYVV5fYCkW9fyQ94Gt1BqHtoLhkvql4uYwig/Siu+
 iuTBfISHL6AvxAuRUzR1+Xn0Rejw7sxMc/75tWTFNAoLwSsMnDZNORu/gscG3HY5JkNq
 TnriOZpHqXMhzM//NWFxWuPBkUPaE3nWabvRY9Pqrx43dsIPB2Mxy1Nm6S2PzD/ma57D
 6kItRtK0QajH/DNqt+apdU2K35eetwLgK9ozLTSiYgKXBkDdBT4OGBfWn1TJPq7Us35f
 wxODm0FroZQCOPTrmCDK4WHN90GJhgvcaJe/CqnGnPVjyrfGdTGAYvdxHjBlbtbxooKq zA== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2120.oracle.com with ESMTP id 360kcysp2n-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 13 Jan 2021 05:49:02 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 10D5eWDP058838;
        Wed, 13 Jan 2021 05:49:01 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userp3020.oracle.com with ESMTP id 360kf6w0nf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 13 Jan 2021 05:49:01 +0000
Received: from abhmp0012.oracle.com (abhmp0012.oracle.com [141.146.116.18])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 10D5mw5X028818;
        Wed, 13 Jan 2021 05:48:59 GMT
Received: from ca-mkp.ca.oracle.com (/10.156.108.201)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 12 Jan 2021 21:48:58 -0800
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     mwilck@suse.com, Hannes Reinecke <hare@suse.de>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org,
        Bart Van Assche <Bart.VanAssche@sandisk.com>,
        James Bottomley <jejb@linux.vnet.ibm.com>
Subject: Re: [PATCH] scsi: scsi_transport_srp: don't block target in failfast state
Date:   Wed, 13 Jan 2021 00:48:54 -0500
Message-Id: <161051681547.32710.6972443319580164027.b4-ty@oracle.com>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210111142541.21534-1-mwilck@suse.com>
References: <20210111142541.21534-1-mwilck@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9862 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 mlxlogscore=999 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2101130034
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9862 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 phishscore=0
 impostorscore=0 bulkscore=0 adultscore=0 suspectscore=0 malwarescore=0
 lowpriorityscore=0 clxscore=1011 mlxlogscore=999 mlxscore=0
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2101130034
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Mon, 11 Jan 2021 15:25:41 +0100, mwilck@suse.com wrote:

> If the port is in SRP_RPORT_FAIL_FAST state when srp_reconnect_rport()
> is entered, a transition to SDEV_BLOCK would be illegal, and a kernel
> WARNING would be triggered. Skip scsi_target_block() in this case.

Applied to 5.11/scsi-fixes, thanks!

[1/1] scsi: scsi_transport_srp: don't block target in failfast state
      https://git.kernel.org/mkp/scsi/c/72eeb7c71513

-- 
Martin K. Petersen	Oracle Linux Engineering
