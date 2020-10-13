Return-Path: <SRS0=AAGU=DU=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 69289C433DF
	for <linux-scsi@archiver.kernel.org>; Tue, 13 Oct 2020 22:43:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2DA0121D40
	for <linux-scsi@archiver.kernel.org>; Tue, 13 Oct 2020 22:43:52 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="hMomfsmv"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729059AbgJMWng (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 13 Oct 2020 18:43:36 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:41910 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728940AbgJMWne (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 13 Oct 2020 18:43:34 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 09DMZthw072107;
        Tue, 13 Oct 2020 22:43:27 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=6eDOfmsg3M6HjzVzF4Q6BXlsZWdT31E8WfJpclrv5RE=;
 b=hMomfsmvOvHY24WbXxEj2lszuL6v53eeMWAVS0sb4OzFHmShgBz2k/qFDbiXnvqMHJ/Y
 ow2q0Bo4I7ek823NkV4dJS8lttebQ/mf8jG3NOFk5OYZnmY8LKonZ0wQninjHJ46GDmN
 1f/gpSK59S0xKMXYzmset2DZbl8sIMC9hnYE+ml4vgs5A9xTIeOPLMtvOkh3zdeW8o6e
 Ta0pUCN8NOMqNbwerO3PEGdQ0pjxKzlr4MyggCcWHH6Mk5L8rjEpEt4do/SvdfcobuWd
 qHo6HLR0aNryXWuWfzdlqnRLcO1rixSlRS+r8qp+F9KPp/7llG6Xa/NahmlD/9h+afze WA== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2120.oracle.com with ESMTP id 343vaeb2d9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Tue, 13 Oct 2020 22:43:27 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 09DMZE9x155704;
        Tue, 13 Oct 2020 22:43:27 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3020.oracle.com with ESMTP id 343puyjx4p-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 13 Oct 2020 22:43:26 +0000
Received: from abhmp0011.oracle.com (abhmp0011.oracle.com [141.146.116.17])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 09DMhPxu014601;
        Tue, 13 Oct 2020 22:43:26 GMT
Received: from ca-mkp.ca.oracle.com (/10.156.108.201)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 13 Oct 2020 15:43:25 -0700
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     Viswas G <Viswas.G@microchip.com.com>, linux-scsi@vger.kernel.org
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        Vasanthalakshmi.Tharmarajan@microchip.com,
        Jinpu Wang <jinpu.wang@cloud.ionos.com>,
        Viswas.G@microchip.com, Ruksar.devadi@microchip.com
Subject: Re: [PATCH V2 0/4] pm80xx updates.
Date:   Tue, 13 Oct 2020 18:43:01 -0400
Message-Id: <160262862430.3018.11202634138022750566.b4-ty@oracle.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201005145011.23674-1-Viswas.G@microchip.com.com>
References: <20201005145011.23674-1-Viswas.G@microchip.com.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9773 signatures=668681
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=890 mlxscore=0 spamscore=0
 adultscore=0 suspectscore=0 phishscore=0 bulkscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2010130158
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9773 signatures=668681
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=909 clxscore=1015
 impostorscore=0 phishscore=0 malwarescore=0 bulkscore=0 priorityscore=1501
 mlxscore=0 suspectscore=0 spamscore=0 adultscore=0 lowpriorityscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2010130158
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Mon, 5 Oct 2020 20:20:07 +0530, Viswas G wrote:

> Changes from v1:
> 	- Improved commit messages.
> 	- Fixed compiler warning for
> 		 "Increase the number of outstanding IO supported" patch
> 
> Viswas G (4):
>   pm80xx: Increase number of supported queues.
>   pm80xx: Remove DMA memory allocation for ccb and device structures.
>   pm80xx: Increase the number of outstanding IO supported to 1024.
>   pm80xx: Driver version update
> 
> [...]

Applied to 5.10/scsi-queue, thanks!

[1/4] scsi: pm80xx: Increase number of supported queues
      https://git.kernel.org/mkp/scsi/c/05c6c029a44d
[2/4] scsi: pm80xx: Remove DMA memory allocation for ccb and device structures
      https://git.kernel.org/mkp/scsi/c/27bc43bd7c42
[3/4] scsi: pm80xx: Increase the number of outstanding I/O supported to 1024
      https://git.kernel.org/mkp/scsi/c/5a141315ed7c
[4/4] scsi: pm80xx: Driver version update
      https://git.kernel.org/mkp/scsi/c/39a45d538dba

-- 
Martin K. Petersen	Oracle Linux Engineering
