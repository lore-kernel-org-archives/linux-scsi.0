Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B3C31C4361B
	for <linux-scsi@archiver.kernel.org>; Tue,  8 Dec 2020 04:53:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 87DFD23A5A
	for <linux-scsi@archiver.kernel.org>; Tue,  8 Dec 2020 04:53:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726918AbgLHExA (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 7 Dec 2020 23:53:00 -0500
Received: from aserp2130.oracle.com ([141.146.126.79]:50420 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726828AbgLHEw7 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 7 Dec 2020 23:52:59 -0500
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0B84nhS1099105;
        Tue, 8 Dec 2020 04:52:16 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=E4fuYebIERG0aZIT7o+2O4xvcUKPOiV+ErzyiVg+jiM=;
 b=o1lnbsMGtMgW5ccSznVAK3t8qZNdJ/SfExuib7PMJQa3OYAbvw9UHpQ53Lt1wrsYCeno
 bX96mjXuh1Opn99qeE6AnBfyRQGVD9ZNVzxQVbxo+vUBc4ADSSGDEkr2QORZIcIdqfLO
 SA3ht5n6YAZxa5q/oRYj1WTd/ESXLtnoKX9Rduu+ZO3RalrUZZOrONalQLJNgCAta/zP
 31cYoB1BwHhQgxOwhhNHt7m3H6O8SU8/FXlNz8ccTdG/xXNfiaqVxmXRnflEX19hhtS6
 x9bJoIwZ8kHLWfUz1PFv3J0AFl8oPzmI9n14Cj5Cgh44rUUt1RA9rc7S09HL+2tPMbj9 sw== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2130.oracle.com with ESMTP id 357yqbrwbu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Tue, 08 Dec 2020 04:52:16 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0B84ocSc155424;
        Tue, 8 Dec 2020 04:52:15 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3020.oracle.com with ESMTP id 358kys9m1p-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 08 Dec 2020 04:52:15 +0000
Received: from abhmp0009.oracle.com (abhmp0009.oracle.com [141.146.116.15])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 0B84qEtl028165;
        Tue, 8 Dec 2020 04:52:14 GMT
Received: from ca-mkp.ca.oracle.com (/10.156.108.201)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 07 Dec 2020 20:52:14 -0800
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     James Smart <james.smart@broadcom.com>, linux-scsi@vger.kernel.org
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        Dan Carpenter <dan.carpenter@oracle.com>
Subject: Re: [PATCH] lpfc: Correct null ndlp reference on routine exit
Date:   Mon,  7 Dec 2020 23:52:02 -0500
Message-Id: <160740299786.710.5429624924898215992.b4-ty@oracle.com>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201130181226.16675-1-james.smart@broadcom.com>
References: <20201130181226.16675-1-james.smart@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9828 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 spamscore=0 mlxscore=0
 malwarescore=0 suspectscore=0 mlxlogscore=999 bulkscore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2012080029
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9828 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 mlxlogscore=999
 clxscore=1015 malwarescore=0 bulkscore=0 phishscore=0 adultscore=0
 spamscore=0 priorityscore=1501 mlxscore=0 lowpriorityscore=0
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2012080029
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Mon, 30 Nov 2020 10:12:26 -0800, James Smart wrote:

> smatch correctly called out a logic error with accessing a pointer after
> checking it for null.
>  drivers/scsi/lpfc/lpfc_els.c:2043 lpfc_cmpl_els_plogi()
>  error: we previously assumed 'ndlp' could be null (see line 1942)
> 
> Adjust the exit point to avoid the trace printf ndlp reference. A trace
> entry was already generated when the ndlp was checked for null.

Applied to 5.11/scsi-queue, thanks!

[1/1] lpfc: Correct null ndlp reference on routine exit
      https://git.kernel.org/mkp/scsi/c/9d8de441db26

-- 
Martin K. Petersen	Oracle Linux Engineering
