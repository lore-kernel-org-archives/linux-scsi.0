Return-Path: <SRS0=EpTV=6W=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4512FC35280
	for <linux-scsi@archiver.kernel.org>; Fri,  8 May 2020 02:56:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1F33020731
	for <linux-scsi@archiver.kernel.org>; Fri,  8 May 2020 02:56:44 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="u+trX3XY"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726701AbgEHC4n (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 7 May 2020 22:56:43 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:44856 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726616AbgEHC4n (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 7 May 2020 22:56:43 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0482ruCs004439;
        Fri, 8 May 2020 02:56:41 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=Uny+uC7/ZQW7FY9CTTMIxZUPVExHx3H9GSMw7FttPp8=;
 b=u+trX3XY2VbraC47nwayenMuEbLiNt4/qTm7D5TKTKgI9hens9GlTNYhCGeLunJGNm5y
 U+f7MRSW+kFLic8r3Fd+5HLuD9IlQesU52wY+TzionRWfXUSYHjQq3JV3P8zdK+Nz1Qi
 MnbLuElm2GjF2uT760bgRwYf6JsUjvYnoG/7dfnDcz1vmGYIAQ/fmzrPTuQyWCWodZx+
 1JZEA34R2F7GyNYZsg8Jqvt5p8H8CWs7dR1mILEmbntv8Ir7ix3qBecVSbMIDISS9b7J
 /NQFXKHsr8pO2Bc5O+V2jqA/pkegb+xlXbCDOhvWSBYHKZHOE1pwUm9nRezrCRt8hL0C cg== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2130.oracle.com with ESMTP id 30vtewrrum-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 08 May 2020 02:56:41 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0482ppb5138435;
        Fri, 8 May 2020 02:54:41 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userp3030.oracle.com with ESMTP id 30vtebgpau-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 08 May 2020 02:54:41 +0000
Received: from abhmp0017.oracle.com (abhmp0017.oracle.com [141.146.116.23])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 0482seLO003637;
        Fri, 8 May 2020 02:54:40 GMT
Received: from ca-mkp.ca.oracle.com (/10.156.108.201)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 07 May 2020 19:54:39 -0700
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     linux-scsi@vger.kernel.org,
        Suganath Prabu <suganath-prabu.subramani@broadcom.com>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        sreekanth.reddy@broadcom.com, Sathya.Prakash@broadcom.com
Subject: Re: [PATCH] mpt3sas: Capture IOC data for analyzing the issue.
Date:   Thu,  7 May 2020 22:54:26 -0400
Message-Id: <158890633246.6466.5024818162350396741.b4-ty@oracle.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <1588056322-29227-1-git-send-email-suganath-prabu.subramani@broadcom.com>
References: <1588056322-29227-1-git-send-email-suganath-prabu.subramani@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9614 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 malwarescore=0
 mlxlogscore=698 phishscore=0 mlxscore=0 adultscore=0 suspectscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2005080022
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9614 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 mlxscore=0 mlxlogscore=753
 malwarescore=0 spamscore=0 priorityscore=1501 lowpriorityscore=0
 impostorscore=0 suspectscore=0 adultscore=0 clxscore=1015 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2003020000
 definitions=main-2005080022
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Tue, 28 Apr 2020 02:45:22 -0400, Suganath Prabu wrote:

> If some issue happens OR if firmware fault occurs then to get the basic
> information developer may ask the customer to reproduce the issue with
> logging level enabled. But most of the basic information needed to
> analyze the issue will be available in ioc’s MPT3SAS_ADAPTER structure
> such as IOCFacts, ioc flags (related to sge, msix, error recovery etc.),
> performance mode type, TMs and internal commands reply status etc. So if
> this MPT3SAS_ADAPTER data is captured into a file whenever some issue
> occurs then developer can get some basic of the information that he needed
> to analyze the issue from this captured data.
> pros
>        - Reduces the number of reproductions count,
>        - No need to add the printk statements which affects the performance
>                 when they are added in IO path.
> 
> [...]

Applied to 5.8/scsi-queue, thanks!

[1/1] scsi: mpt3sas: Capture IOC data for debugging purposes
      https://git.kernel.org/mkp/scsi/c/2b01b293f359

-- 
Martin K. Petersen	Oracle Linux Engineering
