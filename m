Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AECF8C433E0
	for <linux-scsi@archiver.kernel.org>; Mon, 21 Dec 2020 02:40:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6976222EBD
	for <linux-scsi@archiver.kernel.org>; Mon, 21 Dec 2020 02:40:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726550AbgLUCk1 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 20 Dec 2020 21:40:27 -0500
Received: from aserp2130.oracle.com ([141.146.126.79]:40188 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725497AbgLUCk1 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 20 Dec 2020 21:40:27 -0500
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0BL2VWF3103110;
        Mon, 21 Dec 2020 02:39:30 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id; s=corp-2020-01-29;
 bh=bRmq7XthfWgC083/KnoUv7GqWN5bWFCyrCXPYI2IWd8=;
 b=TBoVmwIdOa8cnEAhwOX2iL8UsGiSpav6tDF0Yo1jKmzbmAHkKZ1xK6e99+Q7P7kQRZom
 KuEHbFN+ICD+W3ZGhP/d8+uCq7JOmOqUwkiSp6oev3BNvDelpPxcUlr7rDs9TNk6U3Bq
 RmnIEMQ/q9NjkRHQWsPI3RGkjCIupnwTKdkpmh4NPIlAkT2eMwMEDEXoKX7lpUp3xfXJ
 DGoOj6m05G6QqNUssSkyrqG2r5KZtfWaw6zDB7nz36n0449S9652ablxwPJDfae2n0+C
 nMsxXdRnR2lRpMcxTGF/291pUI9+dPKsSmS3tz4QCtLKlNNJMIDhmpbAE+ipBookNpH9 YQ== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2130.oracle.com with ESMTP id 35h71augtn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Mon, 21 Dec 2020 02:39:30 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0BL2ZjmO179041;
        Mon, 21 Dec 2020 02:37:30 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3020.oracle.com with ESMTP id 35hudw31pf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 21 Dec 2020 02:37:30 +0000
Received: from abhmp0019.oracle.com (abhmp0019.oracle.com [141.146.116.25])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 0BL2bMPY009307;
        Mon, 21 Dec 2020 02:37:26 GMT
Received: from ol2.localdomain (/73.88.28.6)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Sun, 20 Dec 2020 18:37:22 -0800
From:   Mike Christie <michael.christie@oracle.com>
To:     lduncan@suse.com, cleech@redhat.com, martin.petersen@oracle.com,
        linux-scsi@vger.kernel.org, james.bottomley@hansenpartnership.com
Cc:     lutianxiong@huawei.com, linfeilong@huawei.com,
        liuzhiqiang26@huawei.com, haowenchao@huawei.com
Subject: [PATCH 0/6 V3] iscsi fixes
Date:   Sun, 20 Dec 2020 20:37:00 -0600
Message-Id: <1608518226-30376-1-git-send-email-michael.christie@oracle.com>
X-Mailer: git-send-email 1.8.3.1
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9841 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 adultscore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxlogscore=999 malwarescore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2012210018
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9841 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 bulkscore=0
 clxscore=1015 suspectscore=0 spamscore=0 phishscore=0 malwarescore=0
 mlxscore=0 impostorscore=0 priorityscore=1501 adultscore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2012210017
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

The following patches were made over Linus's tree. Martin's staging
branches were missing fe0a8a95e7134d0b44cd407bc0085b9ba8d8fe31.

The patches are mostly fixes. There is one cleanup to the locking
and non standard task cleanup that is used by a later patch that
fixes the refcounting during timeouts/TMFs.

V3:
- Add some patches for issues found while testing.
	- session queue depth was stuck at 128
	- cmd window could not be detected when session was relogged in.
- Patch "libiscsi: drop taskqueuelock" had a bug where we did not
disable bhs and during xmit thread suspension leaked the current task.
V2:
- Take back_lock when looping over running cmds in iscsi_eh_cmd_timed_out
in case those complete while we are accessing them.


