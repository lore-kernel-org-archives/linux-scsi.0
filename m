Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-14.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 01307C433E0
	for <linux-scsi@archiver.kernel.org>; Fri,  8 Jan 2021 04:20:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C99E82075A
	for <linux-scsi@archiver.kernel.org>; Fri,  8 Jan 2021 04:20:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727329AbhAHEUe (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 7 Jan 2021 23:20:34 -0500
Received: from aserp2130.oracle.com ([141.146.126.79]:48920 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726600AbhAHEUd (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 7 Jan 2021 23:20:33 -0500
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 10848u9T041275;
        Fri, 8 Jan 2021 04:19:50 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=pebeWSAB/h931WmIzvlYW48x41Xx0smnyWFPSOKkVNg=;
 b=XfsCTfHSfQn6tDSg3fO2b3uLO6tFUriACj5c/gVvt3OuS/IBr+OCowUgOGSdcUDm1d3A
 v+XmPOi+gVeYdnv4uZr1r/ahuHtXtq5jd37vKLfUB23rnCr0ulFhVMVuB36dqrvWF7Jz
 d4bIVaANNDxbsxWNP/xaCiRTTgTnKzzQQk3aXgUq9leVsAcWi6BbqDUQiVVD7QK3aypp
 ifSWL5oq81QjLaxPOBrapvV2myECNIWlD0rl5PDmqfpkmi0VQPzW0o/MQ3hdXrjXETqV
 FIeJ/s2fK0s7aOWngCGccZuQcMEfa6KaNksKcaXsb+U/6fGLIdpn/IqyWbnLfM+neBq3 kg== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2130.oracle.com with ESMTP id 35wcuxysa6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Fri, 08 Jan 2021 04:19:50 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 1084AUST040500;
        Fri, 8 Jan 2021 04:19:49 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3020.oracle.com with ESMTP id 35w3qut08y-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 08 Jan 2021 04:19:49 +0000
Received: from abhmp0011.oracle.com (abhmp0011.oracle.com [141.146.116.17])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 1084Jm0h030993;
        Fri, 8 Jan 2021 04:19:49 GMT
Received: from ca-mkp.ca.oracle.com (/10.156.108.201)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 07 Jan 2021 20:19:48 -0800
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     "Ewan D. Milne" <emilne@redhat.com>, linux-scsi@vger.kernel.org
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH] scsi: sd: suppress suprious block errors when WRITE SAME is being disabled
Date:   Thu,  7 Jan 2021 23:19:34 -0500
Message-Id: <161007949339.9892.8564988032616099032.b4-ty@oracle.com>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201207221021.28243-1-emilne@redhat.com>
References: <20201207221021.28243-1-emilne@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9857 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 malwarescore=0 mlxscore=0
 spamscore=0 mlxlogscore=999 phishscore=0 bulkscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2101080021
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9857 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 bulkscore=0
 clxscore=1015 spamscore=0 impostorscore=0 priorityscore=1501 mlxscore=0
 adultscore=0 mlxlogscore=999 lowpriorityscore=0 phishscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2101080021
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Mon, 7 Dec 2020 17:10:21 -0500, Ewan D. Milne wrote:

> The block layer code will split a large zeroout request into multiple bios
> and if WRITE SAME is disabled because the storage device reports that it
> does not support it (or support the length used), we can get an error message
> from the block layer despite the setting of RQF_QUIET on the first request.
> This is because more than one request may have already been submitted.
> 
> Fix this by setting RQF_QUIET when BLK_STS_TARGET is returned to fail the
> request early, we don't need to log a message because we did not actually
> submit the command to the device, and the block layer code will handle the
> error by submitting individual write bios.

Applied to 5.11/scsi-fixes, thanks!

[1/1] scsi: sd: suppress suprious block errors when WRITE SAME is being disabled
      https://git.kernel.org/mkp/scsi/c/e5cc9002caaf

-- 
Martin K. Petersen	Oracle Linux Engineering
