Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D9DD0C63777
	for <linux-scsi@archiver.kernel.org>; Tue, 17 Nov 2020 06:06:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 74B212468D
	for <linux-scsi@archiver.kernel.org>; Tue, 17 Nov 2020 06:06:48 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="qj08sUi/"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726741AbgKQGGr (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 17 Nov 2020 01:06:47 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:37046 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726628AbgKQGGr (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 17 Nov 2020 01:06:47 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0AH648Gb172904;
        Tue, 17 Nov 2020 06:06:42 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=5x60dfneffxPJgWPh4rhQWm76JVXcCXrIsW/mFCREs4=;
 b=qj08sUi/cbVICROdFkeXrwiywrE2ZaaYOjK4deAOjsXZrt5420vlxRE2KBlfkmXwWSGK
 yHtFmE4ldSnGvNQORtPr7659z72H8h7itAOha1oTYvyvdD6cEl4LDzwrJo2cghDoC1X+
 mogez+ng9uopElbr4WRhLdYjqjPjX/nGx539Feqsg+pU4TFCU7VlGdyZKl6q5VZVtN1f
 ipeuI9mUjgozecUzzVigvQUk7DKWU4XbJgudLWEHc1JeXgCrXBaGPPw7/L3OCG0EmvzA
 99xT2Yx4IYno8qaErkVmSI/fM1kQ/ZQxVjALH4qB9yNyVGuJwMvSSZfBAwN1MzVnvbk9 Sg== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2120.oracle.com with ESMTP id 34t76krq7v-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Tue, 17 Nov 2020 06:06:42 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0AH65ExO161464;
        Tue, 17 Nov 2020 06:06:42 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3020.oracle.com with ESMTP id 34umcxr8cw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 17 Nov 2020 06:06:42 +0000
Received: from abhmp0007.oracle.com (abhmp0007.oracle.com [141.146.116.13])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 0AH66eef019678;
        Tue, 17 Nov 2020 06:06:40 GMT
Received: from ca-mkp.ca.oracle.com (/10.156.108.201)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 16 Nov 2020 22:06:39 -0800
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     linux-scsi@vger.kernel.org, target-devel@vger.kernel.org,
        Mike Christie <michael.christie@oracle.com>,
        mlombard@redhat.com
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH] iscsi target: fix cmd abort fabric stop race
Date:   Tue, 17 Nov 2020 01:06:38 -0500
Message-Id: <160559316817.969.3374643719447006512.b4-ty@oracle.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <1605318378-9269-1-git-send-email-michael.christie@oracle.com>
References: <1605318378-9269-1-git-send-email-michael.christie@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9807 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 mlxscore=0 phishscore=0
 spamscore=0 bulkscore=0 mlxlogscore=782 malwarescore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2011170044
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9807 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 phishscore=0
 adultscore=0 priorityscore=1501 bulkscore=0 clxscore=1015 mlxlogscore=796
 malwarescore=0 mlxscore=0 spamscore=0 lowpriorityscore=0 impostorscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2011170044
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Fri, 13 Nov 2020 19:46:18 -0600, Mike Christie wrote:

> Maurizio Lombardi <mlombard@redhat.com> found a race where the abort
> and cmd stop paths can race as follows:
> 
> 1. thread1 runs iscsit_release_commands_from_conn and sets
> CMD_T_FABRIC_STOP.
> 2. thread2 runs iscsit_aborted_task and then does __iscsit_free_cmd. It
> then returns from the aborted_task callout and we finish
> target_handle_abort and do:
> 
> [...]

Applied to 5.10/scsi-fixes, thanks!

[1/1] scsi: target: iscsi: Fix cmd abort fabric stop race
      https://git.kernel.org/mkp/scsi/c/f36199355c64

-- 
Martin K. Petersen	Oracle Linux Engineering
