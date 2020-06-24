Return-Path: <SRS0=oFF2=AF=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CFAACC433E0
	for <linux-scsi@archiver.kernel.org>; Wed, 24 Jun 2020 04:30:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AA2722084D
	for <linux-scsi@archiver.kernel.org>; Wed, 24 Jun 2020 04:30:04 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="evm/fhVV"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728853AbgFXEaA (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 24 Jun 2020 00:30:00 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:42974 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728838AbgFXE37 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 24 Jun 2020 00:29:59 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 05O4MU5P049875;
        Wed, 24 Jun 2020 04:29:52 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=corp-2020-01-29;
 bh=lMIBAF9FHK6r2XlKXVLY2GoBF9nHvC+69ZrFRBWtOfY=;
 b=evm/fhVV4QPz0laiJtKBjZ9KfcPvDSnU2bPTbfrFj6UEXALATxFFWgxHXqyrabRtLYL6
 GBFwscyt+Tdaa/29qVWRRSpCAiDbtWbit+FlmnRb207QfgwDsNRYvky2ZCU7lIhewLPy
 leBqG9bZwNFlK7pBe9KGnjBoQ8DhbcCZigSpFqyn8uHMw5xBEgLryvl98zDJe/x0bydN
 ZqHE83evOxhRsEmXfLhu/pl3Nw21DvLBC3QlyoIEC874X/ZnA4oNDBciVsNmovtVujpT
 P6We4r/ULZoAYMwlfnirAe3R8SQwLK0uWxBqrydDjaPtwkUoPccA0IiVjMRuwLIqsZiB 4g== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2120.oracle.com with ESMTP id 31uustgkxd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Wed, 24 Jun 2020 04:29:52 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 05O4NGeV113372;
        Wed, 24 Jun 2020 04:29:52 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3030.oracle.com with ESMTP id 31uurq6un0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 24 Jun 2020 04:29:51 +0000
Received: from abhmp0011.oracle.com (abhmp0011.oracle.com [141.146.116.17])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 05O4Tow5031168;
        Wed, 24 Jun 2020 04:29:50 GMT
Received: from ca-mkp.ca.oracle.com (/10.156.108.201)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 24 Jun 2020 04:29:50 +0000
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     james.smart@broadcom.com, jsmart2021@gmail.com,
        SeongJae Park <sjpark@amazon.com>, dick.kennedy@broadcom.com
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, jejb@linux.ibm.com,
        SeongJae Park <sjpark@amazon.de>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] scsi: lpfc: Avoid another null dereference in lpfc_sli4_hba_unset()
Date:   Wed, 24 Jun 2020 00:29:42 -0400
Message-Id: <159297296072.9797.175884453337292787.b4-ty@oracle.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200623084122.30633-1-sjpark@amazon.com>
References: <20200623084122.30633-1-sjpark@amazon.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9661 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 phishscore=0 mlxscore=0
 spamscore=0 mlxlogscore=979 bulkscore=0 suspectscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2004280000
 definitions=main-2006240031
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9661 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 mlxlogscore=991
 cotscore=-2147483648 adultscore=0 bulkscore=0 spamscore=0 phishscore=0
 suspectscore=0 priorityscore=1501 lowpriorityscore=0 clxscore=1011
 impostorscore=0 malwarescore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2004280000 definitions=main-2006240031
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Tue, 23 Jun 2020 10:41:22 +0200, SeongJae Park wrote:

> Commit cdb42becdd40 ("scsi: lpfc: Replace io_channels for nvme and fcp
> with general hdw_queues per cpu") has introduced static checker warnings
> for potential null dereferences in 'lpfc_sli4_hba_unset()' and
> commit 1ffdd2c0440d ("scsi: lpfc: resolve static checker warning in
> lpfc_sli4_hba_unset") has tried to fix it.  However, yet another
> potential null dereference is remaining.  This commit fixes it.
> 
> [...]

Applied to 5.8/scsi-fixes, thanks!

[1/1] scsi: lpfc: Avoid another null dereference in lpfc_sli4_hba_unset()
      https://git.kernel.org/mkp/scsi/c/46da547e21d6

-- 
Martin K. Petersen	Oracle Linux Engineering
