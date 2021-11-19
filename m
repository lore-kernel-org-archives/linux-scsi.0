Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AA5FAC433FE
	for <linux-scsi@archiver.kernel.org>; Fri, 19 Nov 2021 04:16:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 968CF61AED
	for <linux-scsi@archiver.kernel.org>; Fri, 19 Nov 2021 04:16:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233839AbhKSET4 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 18 Nov 2021 23:19:56 -0500
Received: from mx0a-00069f02.pphosted.com ([205.220.165.32]:47810 "EHLO
        mx0a-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233817AbhKSET4 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 18 Nov 2021 23:19:56 -0500
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1AJ1oRLe009988;
        Fri, 19 Nov 2021 04:16:49 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2021-07-09;
 bh=MDo0Z3sdzzkfiMz5YNrn1MZU+PYI3QRyrzQQxv0AKq4=;
 b=HeI5duHvUvhcvKTwN3zxVlFn014seyAJG75JZAktSuC8LtWSxynXNNKjITBa3LjIeQNy
 r02eP26INuzUPkAi5AB7DGen/63S36R1B+CJaga3LjF1Y7GqtF+Yt0PZX/59q17jKohk
 JZ4D6eS4IiqWBUGYrt47Z8f8v6+EM3XQI/zjSuhj1RzR8z2mXdCiETHyFGX6LNnJtMU/
 x+11+i1jeA25jcd+DaLj6qHXDEPk81ZD6Zzr8W7w3TP9/lQyybJsA3hnop/YR3pwL0Mh
 yNGZuRDHxjHU/t1XIPkzK4KTxeGJOzebhyzmFRSr6oCDycZHmQyumeWS9WCdNoCXw4FQ Ww== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by mx0b-00069f02.pphosted.com with ESMTP id 3cd382mwtf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 19 Nov 2021 04:16:48 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 1AJ4FBps020381;
        Fri, 19 Nov 2021 04:16:44 GMT
Received: from pps.reinject (localhost [127.0.0.1])
        by userp3020.oracle.com with ESMTP id 3caq4x7bxn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 19 Nov 2021 04:16:44 +0000
Received: from userp3020.oracle.com (userp3020.oracle.com [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 1AJ4GiwG024731;
        Fri, 19 Nov 2021 04:16:44 GMT
Received: from ca-mkp.mkp.ca.oracle.com (ca-mkp.ca.oracle.com [10.156.108.201])
        by userp3020.oracle.com with ESMTP id 3caq4x7bx2-1;
        Fri, 19 Nov 2021 04:16:44 +0000
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     Adrian Hunter <adrian.hunter@intel.com>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        Avri Altman <avri.altman@wdc.com>,
        Can Guo <cang@codeaurora.org>, Bean Huo <huobean@gmail.com>,
        Alim Akhtar <alim.akhtar@samsung.com>,
        linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Asutosh Das <asutoshd@codeaurora.org>,
        "James E . J . Bottomley" <jejb@linux.ibm.com>
Subject: Re: [PATCH V2 0/2] scsi: ufs: core: Fix task management completion timeout race
Date:   Thu, 18 Nov 2021 23:16:30 -0500
Message-Id: <163729506336.21244.18367469797969306759.b4-ty@oracle.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20211108064815.569494-1-adrian.hunter@intel.com>
References: <20211108064815.569494-1-adrian.hunter@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Proofpoint-ORIG-GUID: QoTqqn9Xn3PnXR5GT1B5iYygXuXP0liB
X-Proofpoint-GUID: QoTqqn9Xn3PnXR5GT1B5iYygXuXP0liB
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Mon, 8 Nov 2021 08:48:13 +0200, Adrian Hunter wrote:

> I though I sent this back on 15 October, but apparently I didn't, so
> here it is now.
> 
> Please consider this for fixes.
> 
> 
> Changes in V2:
> 
> [...]

Applied to 5.16/scsi-fixes, thanks!

[1/2] scsi: ufs: core: Fix task management completion timeout race
      https://git.kernel.org/mkp/scsi/c/886fe2915cce
[2/2] scsi: ufs: core: Fix another task management completion race
      https://git.kernel.org/mkp/scsi/c/5cb37a26355d

-- 
Martin K. Petersen	Oracle Linux Engineering
