Return-Path: <SRS0=Cu6i=6O=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6D4CFC83004
	for <linux-scsi@archiver.kernel.org>; Thu, 30 Apr 2020 02:18:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4AC38208E0
	for <linux-scsi@archiver.kernel.org>; Thu, 30 Apr 2020 02:18:20 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="TNXZp5bl"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726489AbgD3CSQ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 29 Apr 2020 22:18:16 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:43730 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726180AbgD3CSQ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 29 Apr 2020 22:18:16 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 03U2HnNR095384;
        Thu, 30 Apr 2020 02:18:09 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=corp-2020-01-29;
 bh=1EpdnCTaGeK6kaN+YXuEy0NQfId+N/eZu0x/n1++L24=;
 b=TNXZp5blPFYqKb9u05Adt4NZDOoDfLcy+c2AYfdwzoTuZU2EAbYoywE22AFXEPrW8zVz
 LIx79oeY+Yjq+SLv2QIaxRCBeQtL7hjC5WreRBeB7pyOinuVVqZHEEVdoSPu0wTxzOV/
 /h7pBQEsG+BH3bG9YTmguNJa10BMOWyaEI1gQVaYObnMPQLQi1bWAZG9nkFcsjpMwLDT
 3I+96bZXMS1F/9JScURLkzQnQi46mnKZ/38znzJINYYD4SNjMm0ja9VHNpdWVrI3Zgm6
 by5EX9mafkWxFeb+We75pKKThUaKoYyJGDABIZh0bfRrLu+PUiYWPqH2MQga6gFoFpJs +g== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2130.oracle.com with ESMTP id 30p01nyf2d-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 30 Apr 2020 02:18:09 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 03U2I8vL114392;
        Thu, 30 Apr 2020 02:18:09 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3030.oracle.com with ESMTP id 30mxrwcya0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 30 Apr 2020 02:18:08 +0000
Received: from abhmp0010.oracle.com (abhmp0010.oracle.com [141.146.116.16])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 03U2I5be008456;
        Thu, 30 Apr 2020 02:18:05 GMT
Received: from ca-mkp.ca.oracle.com (/10.156.108.201)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 29 Apr 2020 19:18:05 -0700
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     Arun Easi <aeasi@marvell.com>, Nilesh Javali <njavali@marvell.com>,
        linux-scsi@vger.kernel.org,
        "James E . J . Bottomley" <jejb@linux.ibm.com>,
        GR-QLogic-Storage-Upstream@marvell.com,
        Colin King <colin.king@canonical.com>,
        Himanshu Madhani <himanshu.madhani@oracle.com>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: Re: [PATCH][next] scsi: qla2xxx: make 1 bit bit-fields unsigned int
Date:   Wed, 29 Apr 2020 22:18:01 -0400
Message-Id: <158821297686.28621.17012076745454768383.b4-ty@oracle.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200428102013.1040598-1-colin.king@canonical.com>
References: <20200428102013.1040598-1-colin.king@canonical.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9606 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 phishscore=0 suspectscore=0
 mlxlogscore=858 malwarescore=0 bulkscore=0 spamscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2003020000
 definitions=main-2004300015
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9606 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 spamscore=0 clxscore=1015
 phishscore=0 mlxlogscore=913 adultscore=0 priorityscore=1501 mlxscore=0
 suspectscore=0 malwarescore=0 lowpriorityscore=0 impostorscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2003020000
 definitions=main-2004300014
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Tue, 28 Apr 2020 11:20:13 +0100, Colin King wrote:

> The bitfields mpi_fw_dump_reading and mpi_fw_dumped are currently signed
> which is not recommended as the representation is an implementation defined
> behaviour.  Fix this by making the bit-fields unsigned ints.

Applied to 5.8/scsi-queue, thanks!

[1/1] scsi: qla2xxx: make 1-bit bit-fields unsigned int
      https://git.kernel.org/mkp/scsi/c/78b874b7cbf0

-- 
Martin K. Petersen	Oracle Linux Engineering
