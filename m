Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 31FE7C433FE
	for <linux-scsi@archiver.kernel.org>; Fri,  3 Dec 2021 03:04:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1378362AbhLCDHu (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 2 Dec 2021 22:07:50 -0500
Received: from mx0a-00069f02.pphosted.com ([205.220.165.32]:12774 "EHLO
        mx0a-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1350673AbhLCDHu (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 2 Dec 2021 22:07:50 -0500
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1B31bvbn032215;
        Fri, 3 Dec 2021 03:04:12 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2021-07-09;
 bh=BKnObZ7geocC49waErrE9GRryKp77DeqzWXTV2OBkVU=;
 b=OdjCEGz/aH/cFvgUapWO7Kmlj5J9Ay7WYoc+yhzOr77Fix6xIoUnAqdhlvvqAoTAn44S
 cNUH7jqnhgfkgRHRnFq78pilGqZ/qbz/+Qh+szyzBNrH0gE4R6r5tCSPH7yqDC9noraP
 qs6EZOBswp6PKuVKZ+qtPQ4EEQHiV5kuVwRxqqJ3CX3+imQVtDFZUIrYM6oC/QifKVz4
 irqNUZ/hP5tamdQsqnZdhlQ5FPE15SDjMR82hAMS6It382Jg1rJFWwu9H4zWmNj0UNDu
 agCdXoGEVxVoUqlpq8PginK1rTswQ1NbUqL7o/3Z+VG0wm+hJiylzs/7EGvQf4+duu47 fw== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by mx0b-00069f02.pphosted.com with ESMTP id 3cpb70d4ae-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 03 Dec 2021 03:04:11 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 1B331p2S188333;
        Fri, 3 Dec 2021 03:04:01 GMT
Received: from pps.reinject (localhost [127.0.0.1])
        by aserp3020.oracle.com with ESMTP id 3cnhvht9gc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 03 Dec 2021 03:04:01 +0000
Received: from aserp3020.oracle.com (aserp3020.oracle.com [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 1B3340iW003616;
        Fri, 3 Dec 2021 03:04:00 GMT
Received: from ca-mkp.mkp.ca.oracle.com (ca-mkp.ca.oracle.com [10.156.108.201])
        by aserp3020.oracle.com with ESMTP id 3cnhvht9f3-1;
        Fri, 03 Dec 2021 03:04:00 +0000
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     Adrian Hunter <adrian.hunter@intel.com>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        Alim Akhtar <alim.akhtar@samsung.com>,
        Wei Li <liwei213@huawei.com>,
        Avri Altman <avri.altman@wdc.com>,
        Can Guo <cang@codeaurora.org>, linux-scsi@vger.kernel.org,
        Bean Huo <huobean@gmail.com>,
        Asutosh Das <asutoshd@codeaurora.org>,
        Kiwoong Kim <kwmad.kim@samsung.com>,
        Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>,
        Bart Van Assche <bvanassche@acm.org>,
        "James E . J . Bottomley" <jejb@linux.ibm.com>
Subject: Re: [PATCH V8 0/1] scsi: ufs: Let devices remain runtime suspended during system suspend
Date:   Thu,  2 Dec 2021 22:03:57 -0500
Message-Id: <163850060429.30297.10398480290681805623.b4-ty@oracle.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20211027130614.406985-1-adrian.hunter@intel.com>
References: <20211027130614.406985-1-adrian.hunter@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Proofpoint-ORIG-GUID: fVJ4rdjEsiVAd63L2vXX9WdXiyyh2ucV
X-Proofpoint-GUID: fVJ4rdjEsiVAd63L2vXX9WdXiyyh2ucV
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Wed, 27 Oct 2021 16:06:13 +0300, Adrian Hunter wrote:

> UFS devices can remain runtime suspended at system suspend time,
> if the conditions are right.  Add support for that, first fixing
> the impediments.
> 
> 
> Changes in V8:
> 
> [...]

Applied to 5.17/scsi-queue, thanks!

[1/1] scsi: ufs: Let devices remain runtime suspended during system suspend
      https://git.kernel.org/mkp/scsi/c/ddba1cf7a506

-- 
Martin K. Petersen	Oracle Linux Engineering
