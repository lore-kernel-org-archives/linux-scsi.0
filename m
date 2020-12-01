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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 98D90C64E8A
	for <linux-scsi@archiver.kernel.org>; Tue,  1 Dec 2020 05:07:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2AFDD20725
	for <linux-scsi@archiver.kernel.org>; Tue,  1 Dec 2020 05:07:33 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="hQCUSZS6"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726505AbgLAFHP (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 1 Dec 2020 00:07:15 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:37298 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725849AbgLAFHP (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 1 Dec 2020 00:07:15 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0B14n1PB096955;
        Tue, 1 Dec 2020 05:06:32 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=P4djjKZB/xSDrJYXvSXSplBBdE1NCfQuqHU4zAB6mRM=;
 b=hQCUSZS6Jz9Iyx2eJbPNlacyS8iMb6OrDPp32W3CazdBpIB0jr5NrDVent6Y197iF25o
 sVWZZV5s11RORZud2rvPvvXMgi24okzNxL6myWok9wlqo8UJFzLHME8HjhmgUBHWrrM4
 WGr89h7v3tel9jn7S6FIXXYoAiNVFpHLngWfDdh+F0FXX6gAUH7oaIMIkuIf9LLN7AQa
 nuMmPTjz2nv72xMyQe0qnKR12OSU8BGpCq8yIWZGe60bB7EVPIhWHAO29nmpkKR/yWpA
 JCjk4/bsyzZG1LufLbGZaC8thfsMDSG04CSY5pWSQODbiewv5kXmvUJ+rM3/r0Y42G5n IQ== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by aserp2120.oracle.com with ESMTP id 353egkgjpm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Tue, 01 Dec 2020 05:06:32 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0B14oMEA134978;
        Tue, 1 Dec 2020 05:04:31 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3030.oracle.com with ESMTP id 35404mdvkf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 01 Dec 2020 05:04:31 +0000
Received: from abhmp0020.oracle.com (abhmp0020.oracle.com [141.146.116.26])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 0B154V1s016731;
        Tue, 1 Dec 2020 05:04:31 GMT
Received: from ca-mkp.ca.oracle.com (/10.156.108.201)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 01 Dec 2020 05:04:30 +0000
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     satishkh@cisco.com, Karan Tilak Kumar <kartilak@cisco.com>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        jejb@linux.ibm.com, arulponn@cisco.com, sebaddel@cisco.com,
        linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
Subject: Re: [PATCH] scsi: fnic: Change shost_printk to FNIC_MAIN_DBG
Date:   Tue,  1 Dec 2020 00:04:20 -0500
Message-Id: <160636449895.25598.11033409748628177148.b4-ty@oracle.com>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201121013739.18701-1-kartilak@cisco.com>
References: <20201121013739.18701-1-kartilak@cisco.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9821 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 bulkscore=0
 malwarescore=0 mlxscore=0 mlxlogscore=999 phishscore=0 spamscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2012010033
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9821 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 bulkscore=0 suspectscore=0
 phishscore=0 mlxlogscore=999 lowpriorityscore=0 malwarescore=0
 priorityscore=1501 spamscore=0 impostorscore=0 clxscore=1015 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2012010033
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Fri, 20 Nov 2020 17:37:39 -0800, Karan Tilak Kumar wrote:

> Replacing shost_printk with FNIC_MAIN_DBG so that
> these log messages are controlled by fnic_log_level
> flag in fnic_handle_link.

Applied to 5.11/scsi-queue, thanks!

[1/1] scsi: fnic: Change shost_printk() to FNIC_MAIN_DBG()
      https://git.kernel.org/mkp/scsi/c/875d4eda3bd6

-- 
Martin K. Petersen	Oracle Linux Engineering
