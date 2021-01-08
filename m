Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-14.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B6D5CC43603
	for <linux-scsi@archiver.kernel.org>; Fri,  8 Jan 2021 04:21:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8FFE02075A
	for <linux-scsi@archiver.kernel.org>; Fri,  8 Jan 2021 04:21:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727634AbhAHEUm (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 7 Jan 2021 23:20:42 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:52474 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727330AbhAHEUl (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 7 Jan 2021 23:20:41 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 10849FLY096297;
        Fri, 8 Jan 2021 04:19:48 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=7ps+9gWcGiHnwfLHUSJZrujUQR+FHByCmsN1jIEAUuc=;
 b=kVY38nuz0puFhQbf7TKXLM3M4QEOPHMEbJvRRvtm3l/NGlco0+8SZDjkK3IGklPpejtu
 6gDAJ/NlLIr2d3Mjiy0lx9XIwcP8RInei2ZvtvmD3CAwFhProah3ptDXiiP3YYB0kACw
 rRJ0/xHhNiyp88X3gO4VnfAqoPuRSlCTudphkrXjE5uPuu5RwOqbzBANT+NgOwlg8AOV
 bFp2bVbKL+nd57f+/PNY3sXBx53wqlc6O6z13HgL4GdDxtXsIlO6McXYc1Y912zX9mFf
 /OtORHSt34j4IYnYpKyBgBROaNYjTnUWYGr2KoOaqODBXvVH8cS1jydsJA/ZsVRafsUs 3Q== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2120.oracle.com with ESMTP id 35wepmfd93-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Fri, 08 Jan 2021 04:19:48 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 1084AUVH040494;
        Fri, 8 Jan 2021 04:19:47 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3020.oracle.com with ESMTP id 35w3qut08q-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 08 Jan 2021 04:19:47 +0000
Received: from abhmp0015.oracle.com (abhmp0015.oracle.com [141.146.116.21])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 1084Jkm3030987;
        Fri, 8 Jan 2021 04:19:46 GMT
Received: from ca-mkp.ca.oracle.com (/10.156.108.201)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 08 Jan 2021 04:19:45 +0000
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     kernel-team@android.com, linux-scsi@vger.kernel.org,
        ziqichen@codeaurora.org, saravanak@google.com,
        rnayak@codeaurora.org, Can Guo <cang@codeaurora.org>,
        hongwus@codeaurora.org, nguyenb@codeaurora.org,
        asutoshd@codeaurora.org, salyzyn@google.com
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        Bean Huo <beanhuo@micron.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Bart Van Assche <bvanassche@acm.org>,
        Avri Altman <avri.altman@wdc.com>,
        open list <linux-kernel@vger.kernel.org>,
        Alim Akhtar <alim.akhtar@samsung.com>
Subject: Re: [PATCH] scsi: ufs: Correct the lun used in eh_device_reset_handler() callback
Date:   Thu,  7 Jan 2021 23:19:31 -0500
Message-Id: <161007949338.9892.8133334421380740608.b4-ty@oracle.com>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <1609157080-26283-1-git-send-email-cang@codeaurora.org>
References: <1609157080-26283-1-git-send-email-cang@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9857 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 malwarescore=0 mlxscore=0
 spamscore=0 mlxlogscore=999 phishscore=0 bulkscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2101080021
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9857 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 bulkscore=0 spamscore=0
 impostorscore=0 phishscore=0 lowpriorityscore=0 suspectscore=0
 priorityscore=1501 mlxscore=0 malwarescore=0 clxscore=1015 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2101080021
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Mon, 28 Dec 2020 04:04:36 -0800, Can Guo wrote:

> Users can initiate resets to specific SCSI device/target/host through
> IOCTL. When this happens, the SCSI cmd passed to eh_device/target/host
> _reset_handler() callbacks is initialized with a request whose tag is -1.
> So, in this case, it is not right for eh_device_reset_handler() callback
> to count on the lun get from hba->lrb[-1]. Fix it by getting lun from the
> SCSI device associated with the SCSI cmd.

Applied to 5.11/scsi-fixes, thanks!

[1/1] scsi: ufs: Correct the lun used in eh_device_reset_handler() callback
      https://git.kernel.org/mkp/scsi/c/35fc4cd34426

-- 
Martin K. Petersen	Oracle Linux Engineering
