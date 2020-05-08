Return-Path: <SRS0=EpTV=6W=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 74F30C35280
	for <linux-scsi@archiver.kernel.org>; Fri,  8 May 2020 02:55:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 54E7F20731
	for <linux-scsi@archiver.kernel.org>; Fri,  8 May 2020 02:55:16 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="VAJnvqbT"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727111AbgEHCy5 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 7 May 2020 22:54:57 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:33670 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726756AbgEHCyx (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 7 May 2020 22:54:53 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0482rnIM085497;
        Fri, 8 May 2020 02:54:44 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=corp-2020-01-29;
 bh=Sq+mU1qvjVw5dKRhuurPqz36df4d8wnd3ANBxDpyJRc=;
 b=VAJnvqbTKxGnQ/NAjhCEVryhwkbvDVAgxnerkWsJKIFBWQY5hLd3WK4xVXv568mCcIhm
 GF8IKP2EM9MoDA1ivVB9lXz4l7BdvYcW5jmp6MSFzpinBQsTai5nBNcWb0H2kMH/xziv
 dfHDhAFxRM34DPib2O5u/x6zAi0W/1uy65TKHqqviKpGFt5LuYIx211vZYsh4SiyDP7A
 BEq+IXVXmWuKl9xZzCj1vVMEWNImDE6WW2ioktbffi8SCD22psExA24ertJPANOLO9DQ
 aTCm7TPvSFP/Vh2fLDXQE2wuReKYy4CQSgKolII1664/HItkFiqAZKzjB5ALZU91xDcN nA== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2120.oracle.com with ESMTP id 30vtexrrku-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 08 May 2020 02:54:44 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0482qutg138303;
        Fri, 8 May 2020 02:54:43 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3030.oracle.com with ESMTP id 30vtdmp58a-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 08 May 2020 02:54:43 +0000
Received: from abhmp0013.oracle.com (abhmp0013.oracle.com [141.146.116.19])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 0482sf0T028792;
        Fri, 8 May 2020 02:54:42 GMT
Received: from ca-mkp.ca.oracle.com (/10.156.108.201)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 07 May 2020 19:54:41 -0700
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     jejb@linux.ibm.com, Jason Yan <yanaijie@huawei.com>,
        kartilak@cisco.com, sebaddel@cisco.com, satishkh@cisco.com,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH] scsi: fnic: use true,false for fnic->internal_reset_inprogress
Date:   Thu,  7 May 2020 22:54:28 -0400
Message-Id: <158890633245.6466.4414588807706254361.b4-ty@oracle.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200430121718.14970-1-yanaijie@huawei.com>
References: <20200430121718.14970-1-yanaijie@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9614 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 malwarescore=0 spamscore=0
 mlxscore=0 mlxlogscore=999 bulkscore=0 phishscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2003020000
 definitions=main-2005080022
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9614 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 lowpriorityscore=0 adultscore=0
 spamscore=0 suspectscore=0 bulkscore=0 priorityscore=1501 malwarescore=0
 phishscore=0 impostorscore=0 mlxscore=0 mlxlogscore=999 clxscore=1015
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2003020000
 definitions=main-2005080022
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Thu, 30 Apr 2020 20:17:18 +0800, Jason Yan wrote:

> Fix the following coccicheck warning:
> 
> drivers/scsi/fnic/fnic_scsi.c:2627:5-36: WARNING: Comparison of 0/1 to
> bool variable

Applied to 5.8/scsi-queue, thanks!

[1/1] scsi: fnic: Use true, false for fnic->internal_reset_inprogress
      https://git.kernel.org/mkp/scsi/c/b91857a5ca13

-- 
Martin K. Petersen	Oracle Linux Engineering
