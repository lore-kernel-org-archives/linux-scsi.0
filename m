Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C7845C433EF
	for <linux-scsi@archiver.kernel.org>; Fri, 10 Jun 2022 17:45:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347127AbiFJRpE (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 10 Jun 2022 13:45:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51080 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347119AbiFJRpD (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 10 Jun 2022 13:45:03 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 467C855239
        for <linux-scsi@vger.kernel.org>; Fri, 10 Jun 2022 10:45:02 -0700 (PDT)
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 25AEOqd2013524;
        Fri, 10 Jun 2022 17:45:00 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2021-07-09;
 bh=+iLVC11HEXajcgAt0fr4Yi9ZbcMGnrotpL1O2yni1xU=;
 b=excTlatuaSHx6YwpQ7nxuEnBS5C4HAncixHnBbjGp7pDi0cXbyvB6eadj7MC9HIzFdYV
 aUmcq3ID3a3mSnuntn6kGa2CYNdizY73EKTc3asdOAfGkt7vx3YWY/98fJqIwm/gtWhI
 gzjTICN0zSqrQhLhuc74PbcJ72sLL6MtRQdKwCjGnrZ+qtdFj8ZobHNJkMOkNVbGCerR
 psuguTUy4DIPgHrX/pQczEu7r54PJjmns3xbNCGqsCZ/rynVUvN09GdpZdrhHCKuFlO7
 j4vonEyx7JFP1BzLYhAZQOIln3NWEMsBI5bLHjm+wA5I409T8x+N/X+goWaAnvD8xefx Wg== 
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3gfydqx6tq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 10 Jun 2022 17:45:00 +0000
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.16.1.2/8.16.1.2) with SMTP id 25AHGaOj032834;
        Fri, 10 Jun 2022 17:45:00 GMT
Received: from pps.reinject (localhost [127.0.0.1])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com with ESMTP id 3gfwu676ak-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 10 Jun 2022 17:45:00 +0000
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 25AHixqW017402;
        Fri, 10 Jun 2022 17:44:59 GMT
Received: from ca-mkp.mkp.ca.oracle.com (ca-mkp.ca.oracle.com [10.156.108.201])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com with ESMTP id 3gfwu6769u-1;
        Fri, 10 Jun 2022 17:44:59 +0000
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     Damien Le Moal <damien.lemoal@opensource.wdc.com>,
        linux-scsi@vger.kernel.org
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        Niklas Cassel <niklas.cassel@wdc.com>,
        Douglas Gilbert <dgilbert@interlog.com>
Subject: Re: [PATCH v2] scsi: scsi_debug: fix zone transition to full condition
Date:   Fri, 10 Jun 2022 13:44:57 -0400
Message-Id: <165488293505.18353.11483854001214506739.b4-ty@oracle.com>
X-Mailer: git-send-email 2.35.2
In-Reply-To: <20220608011302.92061-1-damien.lemoal@opensource.wdc.com>
References: <20220608011302.92061-1-damien.lemoal@opensource.wdc.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Proofpoint-GUID: Qx1u-xxpci7fUXBFxQ64zZ-92lRsr15A
X-Proofpoint-ORIG-GUID: Qx1u-xxpci7fUXBFxQ64zZ-92lRsr15A
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Wed, 8 Jun 2022 10:13:02 +0900, Damien Le Moal wrote:

> When a write command to a sequential write required or sequential write
> preferred zone result in the zone write pointer reaching the end of the
> zone, the zone condition must be set to full AND the number of
> implicitly or explicitly open zones updated to have a correct accounting
> for zone resources. However, the function zbc_inc_wp() only sets the
> zone condition to full without updating the open zone counters,
> resulting in a zone state machine breakage.
> 
> [...]

Applied to 5.19/scsi-fixes, thanks!

[1/1] scsi: scsi_debug: fix zone transition to full condition
      https://git.kernel.org/mkp/scsi/c/566d3c57eb52

-- 
Martin K. Petersen	Oracle Linux Engineering
