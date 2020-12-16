Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 65B63C4361B
	for <linux-scsi@archiver.kernel.org>; Wed, 16 Dec 2020 18:57:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id F39AD23441
	for <linux-scsi@archiver.kernel.org>; Wed, 16 Dec 2020 18:57:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732554AbgLPS4s (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 16 Dec 2020 13:56:48 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:36608 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732464AbgLPS4s (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 16 Dec 2020 13:56:48 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0BGIdvEd151825;
        Wed, 16 Dec 2020 18:55:54 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id; s=corp-2020-01-29;
 bh=WFvdsNvLNT3B+7AF/PDLXCbdHB9el8RA8UrIEqhmtZU=;
 b=oEDknyMieFRRmrLOfECCh8SmQfJXPVmeqNY9qqGh0JeT5hE4jc2OKa8cyDnT9Dh6Vqy9
 hq7GqbC7BBCwtpDmMR7Sje+9hbQSNHYeefEqvMnpAIFEH5dFT+LBGKXdIJN6/gevfHmG
 /9nm3pXGZd2WnXJmA54y9UY6BDOJq1MMqmuqA+dK64sdQfUtL8Wu6Kl2p8dGyo3Zhpkf
 6uRULOwTYKEFbs75Pd43Vx3k71/48hfkT1xDzDw0aMK/1tSPQJ2J8AuBadtoEIszYOTw
 5EcmFkA0kdavAUjsvfLnUNI4nHAnBjqZurSPS6+92YSAialdkiylFANwgrDj+CUvyii/ /g== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2120.oracle.com with ESMTP id 35cntm9wjd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Wed, 16 Dec 2020 18:55:54 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0BGIfNwd057242;
        Wed, 16 Dec 2020 18:55:53 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3020.oracle.com with ESMTP id 35e6es9wk3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 16 Dec 2020 18:55:53 +0000
Received: from abhmp0019.oracle.com (abhmp0019.oracle.com [141.146.116.25])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 0BGItoxn001738;
        Wed, 16 Dec 2020 18:55:52 GMT
Received: from ol2.localdomain (/73.88.28.6)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 16 Dec 2020 10:55:50 -0800
From:   Mike Christie <michael.christie@oracle.com>
To:     lduncan@suse.com, cleech@redhat.com, martin.petersen@oracle.com,
        linux-scsi@vger.kernel.org, james.bottomley@hansenpartnership.com
Cc:     lutianxiong@huawei.com, linfeilong@huawei.com,
        liuzhiqiang26@huawei.com, haowenchao@huawei.com
Subject: [PATCH 0/3 V2] iscsi cmd lifetime fixups/cleanups
Date:   Wed, 16 Dec 2020 12:55:40 -0600
Message-Id: <1608144943-4748-1-git-send-email-michael.christie@oracle.com>
X-Mailer: git-send-email 1.8.3.1
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9837 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 mlxscore=0 phishscore=0
 bulkscore=0 suspectscore=0 malwarescore=0 mlxlogscore=600 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2012160117
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9837 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 phishscore=0 mlxscore=0
 lowpriorityscore=0 spamscore=0 adultscore=0 malwarescore=0 suspectscore=0
 mlxlogscore=614 impostorscore=0 priorityscore=1501 clxscore=1015
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2012160117
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

The following patches were made over Linus's tree. Martin's staging
branches were missing fe0a8a95e7134d0b44cd407bc0085b9ba8d8fe31.

The patches are mix of cleanups and fixups. The first patch is
just a fix that was in the same code path as the second patch.

The second patch was originally mode to drop the taskqueuelock use, but
it also moved the running cmd cleanup code to the failure functions,
and that is needed by the 3rd patch.

The 3rd patch then takes a ref to the cmd in the EH and timer paths
or takes the back_lock, and utilizes the running cmd cleanup from the
2nd patch to handle an issue in bnx2i where it wants to sleep in the
cleanup_task callout and needs to know what locks are held.

V2:
- Take back_lock when looping over running cmds in iscsi_eh_cmd_timed_out
in case those complete while we are accessing them.


