Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1498AC433F5
	for <linux-scsi@archiver.kernel.org>; Tue, 19 Oct 2021 03:44:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id F2F436128E
	for <linux-scsi@archiver.kernel.org>; Tue, 19 Oct 2021 03:44:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232666AbhJSDqZ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 18 Oct 2021 23:46:25 -0400
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:46788 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232025AbhJSDqY (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 18 Oct 2021 23:46:24 -0400
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 19J3Cljk015258;
        Tue, 19 Oct 2021 03:44:09 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2021-07-09;
 bh=81Sg+SeAIVdtJ9U0wn1PFrp0ffb8KlsCsS7d+YFALrE=;
 b=y+Z571UnRK3L/+ZTG4l8ejgQLQnl1B2svoDsx2GIqI/xnkRwHPfd1K+0nOMSAjDyIaV9
 72j7dxErBNpMo8qhmiZ3tZdZ9XQHufSCtyOp/rlhZNJ+PU861iKfhZ+5trqFbnWwg3rP
 X1fXMRGxsOmeFwIkKC5aJQ+fTpzcv6/pFLQ8Ha5t+8yj0ziLJ/8inYcqGoNEc7EN7Jhz
 FB+oWhvFLCDiAzDgpswzbo6UqYoApRrR6/iuqbqddZMu09o8n8WhorJxCZ0XOL4LSLuk
 jmgykgtt4Nw5h8voFDCOeeKwrsKDEkqljbieV1zxQjZSr9zyO6WDRMMd7aSier2rBfSn Gw== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by mx0b-00069f02.pphosted.com with ESMTP id 3brnfhqskd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 19 Oct 2021 03:43:45 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 19J3ZUXF077121;
        Tue, 19 Oct 2021 03:43:44 GMT
Received: from pps.reinject (localhost [127.0.0.1])
        by userp3020.oracle.com with ESMTP id 3br8grmms6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 19 Oct 2021 03:43:44 +0000
Received: from userp3020.oracle.com (userp3020.oracle.com [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 19J3hhHZ101685;
        Tue, 19 Oct 2021 03:43:43 GMT
Received: from ca-mkp.mkp.ca.oracle.com (ca-mkp.ca.oracle.com [10.156.108.201])
        by userp3020.oracle.com with ESMTP id 3br8grmmrp-1;
        Tue, 19 Oct 2021 03:43:43 +0000
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     Adrian Hunter <adrian.hunter@intel.com>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        "James E . J . Bottomley" <jejb@linux.ibm.com>,
        Avri Altman <avri.altman@wdc.com>,
        Bean Huo <huobean@gmail.com>, linux-scsi@vger.kernel.org
Subject: Re: [PATCH V2 0/1] scsi: ufs-pci: Force a full restore after suspend-to-disk
Date:   Mon, 18 Oct 2021 23:43:37 -0400
Message-Id: <163461411521.13664.3282868630672659801.b4-ty@oracle.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20211018151004.284200-1-adrian.hunter@intel.com>
References: <20211018151004.284200-1-adrian.hunter@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Proofpoint-ORIG-GUID: sx0rEAMwOn5sYsfyJv3wgfGNkRU8nWqP
X-Proofpoint-GUID: sx0rEAMwOn5sYsfyJv3wgfGNkRU8nWqP
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Mon, 18 Oct 2021 18:10:03 +0300, Adrian Hunter wrote:

> This patch ensures suspend-to-disk works with Host Performance Booster.
> Since the Host Perfomance Booster feature was added in v5.15, please
> consider this for v5.15 fixes.
> 
> 
> Changes in V2:
> 
> [...]

Applied to 5.15/scsi-fixes, thanks!

[1/1] scsi: ufs-pci: Force a full restore after suspend-to-disk
      https://git.kernel.org/mkp/scsi/c/4e5483b8440d

-- 
Martin K. Petersen	Oracle Linux Engineering
