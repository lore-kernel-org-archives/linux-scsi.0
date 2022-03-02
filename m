Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 49806C433F5
	for <linux-scsi@archiver.kernel.org>; Wed,  2 Mar 2022 05:14:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239594AbiCBFOk (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 2 Mar 2022 00:14:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42006 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239521AbiCBFO0 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 2 Mar 2022 00:14:26 -0500
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 57BC4A9A72;
        Tue,  1 Mar 2022 21:13:43 -0800 (PST)
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 2222cXOt016190;
        Wed, 2 Mar 2022 05:13:40 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2021-07-09;
 bh=FJ/slUmyfVzJZk6jgRLUq//9lqbCFNZrAkRugfbn7XY=;
 b=m2pHnaHw9+VLURCb6pptbRrIZd9ijwuSU9jWcdRUIHuLGQrM0qX47XMbDQOpjldIAg08
 CZH8h7bfFgYwps0/cM7gmhlATA42jVxWnpMnNPgJh1UMgyWlL9JeenwlygReIrjK4RCk
 EjxgUNo47jjv9UIw68V3r2hjaMo+Dp5TAoBuO2e1Qouu0q/O+X/C/UH1s8eBATvfdRtK
 CtPBOcLBX6BKMJCJwx7G4t4tAzqADKjEVRLnMdrxdELjzID7kD6acLj7u5mQRh+xhId7
 X2RZNTqiKOR3cQ7beS/1XUe9URLAH51K3ebia/UpHgyAdGIEJAAPRZBRi8ATE13hnPcQ eg== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by mx0b-00069f02.pphosted.com with ESMTP id 3ehbk9b9vt-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 02 Mar 2022 05:13:39 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 2225C1i8175289;
        Wed, 2 Mar 2022 05:13:38 GMT
Received: from pps.reinject (localhost [127.0.0.1])
        by userp3030.oracle.com with ESMTP id 3ef9ayxgnq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 02 Mar 2022 05:13:38 +0000
Received: from userp3030.oracle.com (userp3030.oracle.com [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 2225DVPS178145;
        Wed, 2 Mar 2022 05:13:38 GMT
Received: from ca-mkp.mkp.ca.oracle.com (ca-mkp.ca.oracle.com [10.156.108.201])
        by userp3030.oracle.com with ESMTP id 3ef9ayxgcv-7;
        Wed, 02 Mar 2022 05:13:38 +0000
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     Christoph Hellwig <hch@lst.de>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, target-devel@vger.kernel.org
Subject: Re: remove struct scsi_request v2
Date:   Wed,  2 Mar 2022 00:13:25 -0500
Message-Id: <164619702114.16127.6666650319483152093.b4-ty@oracle.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20220224175552.988286-1-hch@lst.de>
References: <20220224175552.988286-1-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Proofpoint-GUID: IGWqcdbrgUnMcnR65o40HXNYBTSwpqrd
X-Proofpoint-ORIG-GUID: IGWqcdbrgUnMcnR65o40HXNYBTSwpqrd
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Thu, 24 Feb 2022 18:55:44 +0100, Christoph Hellwig wrote:

> with the recent removal of the REQ_OP_SCSI_{IN,OUT} based passthrough
> from non-scsi drivers, the need for the scsi_request structure went
> away as well.  As all submitters of SCSI passthrough requests are using
> the SCSI midlayer now they can just fill out the scsi_cmnd directly.
> 
> Changes since v1:
>  - fix a few commit message typos
>  - remove an extra clearing of scmd->flags
>  - cleanup sense handling in sg_scsi_ioctl
>  - split the last patch
> 
> [...]

Applied to 5.18/scsi-queue, thanks!

[1/8] target/pscsi: remove struct pscsi_plugin_task
      https://git.kernel.org/mkp/scsi/c/c49ff72cff4c
[2/8] scsi: don't memset the entire scsi_cmnd in scsi_init_command
      https://git.kernel.org/mkp/scsi/c/71bada345b33
[3/8] scsi: remove the cmd field from struct scsi_request
      https://git.kernel.org/mkp/scsi/c/ce70fd9a551a
[4/8] scsi: remove the sense and sense_len fields from struct scsi_request
      https://git.kernel.org/mkp/scsi/c/5b794f98074a
[5/8] scsi: move the resid_len field from struct scsi_request to struct scsi_cmnd
      https://git.kernel.org/mkp/scsi/c/a9a4ea1166d6
[6/8] scsi: move the result field from struct scsi_request to struct scsi_cmnd
      https://git.kernel.org/mkp/scsi/c/dbb4c84d87af
[7/8] scsi: remove struct scsi_request
      https://git.kernel.org/mkp/scsi/c/6aded12b10e0
[8/8] scsi: remove <scsi/scsi_request.h>
      https://git.kernel.org/mkp/scsi/c/264403033105

-- 
Martin K. Petersen	Oracle Linux Engineering
