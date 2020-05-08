Return-Path: <SRS0=EpTV=6W=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 967F3C4724C
	for <linux-scsi@archiver.kernel.org>; Fri,  8 May 2020 02:54:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7037C20731
	for <linux-scsi@archiver.kernel.org>; Fri,  8 May 2020 02:54:45 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="aiD1/7L4"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727067AbgEHCyp (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 7 May 2020 22:54:45 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:43708 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726756AbgEHCyn (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 7 May 2020 22:54:43 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0482ruM6004670;
        Fri, 8 May 2020 02:54:40 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=LVDE8JDF8mZLsCd2GgcvjTcmBzUorw9bXgcprIWPc5Q=;
 b=aiD1/7L4G74Ih01L/xL4VGM/+/zIexd1SnluW6S1tbfzCcXDd8/Gukyrf0P0DcQuLtba
 6Bg1ugNeaoqbsVQs0fumZYW474JfkjQ1X8Kv5tQl7LeWRcJUPrDPx79Wm5sOFi05UmbF
 6KpQbaxkG4yQqwsaZ8SJTtXEqoYgZKGR6s1oaTtP2FjgZEsddQ1TDMnPgdOaZBm/xhM9
 XRhrnNpDGwdnPxBJVugoU1mCGTBf3ugh9aZVKfvnNn2BSklaKwSXaAmvDbBDAod6A2SV
 4fgOQg4Tms/HyDKH1HFTfuHZsmgIVg/jjwiUKDqH0eJQeQx+FIoY5KgYdnnrGuDMME9O Vw== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2130.oracle.com with ESMTP id 30vtewrrqv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 08 May 2020 02:54:40 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0482qutf138303;
        Fri, 8 May 2020 02:54:39 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3030.oracle.com with ESMTP id 30vtdmp55x-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 08 May 2020 02:54:39 +0000
Received: from abhmp0015.oracle.com (abhmp0015.oracle.com [141.146.116.21])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 0482sdaK028267;
        Fri, 8 May 2020 02:54:39 GMT
Received: from ca-mkp.ca.oracle.com (/10.156.108.201)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 07 May 2020 19:54:38 -0700
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     Sreekanth Reddy <sreekanth.reddy@broadcom.com>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        suganath-prabu.subramani@broadcom.com, linux-scsi@vger.kernel.org,
        sathya.prakash@broadcom.com
Subject: Re: [PATCH] mpt3sas: Disable DIF when prot_mask set to zero
Date:   Thu,  7 May 2020 22:54:25 -0400
Message-Id: <158890633246.6466.6192035999786026188.b4-ty@oracle.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <1588065902-2726-1-git-send-email-sreekanth.reddy@broadcom.com>
References: <1588065902-2726-1-git-send-email-sreekanth.reddy@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9614 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 malwarescore=0 spamscore=0
 mlxscore=0 mlxlogscore=876 bulkscore=0 phishscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2003020000
 definitions=main-2005080022
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9614 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 mlxscore=0 mlxlogscore=923
 malwarescore=0 spamscore=0 priorityscore=1501 lowpriorityscore=0
 impostorscore=0 suspectscore=0 adultscore=0 clxscore=1015 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2003020000
 definitions=main-2005080022
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Tue, 28 Apr 2020 05:25:02 -0400, Sreekanth Reddy wrote:

> By default DIF Type1, DIF Type2 & DIF Type3 will be enabled.
> Also users can enable either DIF Type 1 or DIF Type2 or DIF Type3
> or in any combination using the prot_mask module parameter.
> 
> But when the user provides the prot_mask module parameter
> value as zero then the driver is not disabling the DIF,
> instead it enables all three typesof DIF's.
> 
> [...]

Applied to 5.8/scsi-queue, thanks!

[1/1] scsi: mpt3sas: Disable DIF when prot_mask set to zero
      https://git.kernel.org/mkp/scsi/c/e869f8ea6a64

-- 
Martin K. Petersen	Oracle Linux Engineering
