Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 12721C433FE
	for <linux-scsi@archiver.kernel.org>; Wed,  9 Mar 2022 04:14:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229621AbiCIEPV (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 8 Mar 2022 23:15:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39350 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229611AbiCIEPT (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 8 Mar 2022 23:15:19 -0500
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 930733B3F3
        for <linux-scsi@vger.kernel.org>; Tue,  8 Mar 2022 20:14:16 -0800 (PST)
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 22948BBJ003031;
        Wed, 9 Mar 2022 04:14:11 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2021-07-09;
 bh=B1kQr4eEgVGLzriLJbWEiVLuNbj8Fu66tl6zL2uVu9I=;
 b=ZVeAQtK1JI2VlLlgk/PU1Li+gUDNmtShbMWGPaXrtkf2wEX5NvA3VZfPGyBD+Ie1TIAT
 2PnV2Jup/TqwltIUkChhY3vq/acyRd/0QQ6Zcs4fJ1Oj3xB3T1Zc4YM2KD25UQe8T+uR
 /CQv39rDALSL8Iw/jUCybp9S4J56FFrpHVif7V3Xp+btkskF077K9jloBOYgTyuYMUcp
 nIFd9+bSs9wxJJvtNie8naBVELgXfjNn0XB05WsnZx8v4HWeCUGptSTXe60NV7BXmoe/
 Vmkvqt8fMhlw0AgCewftijsAOPlwQK7/E3GkERgs2kRDTn3lDXHYw4c4MsXurVxrv9eV GA== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by mx0b-00069f02.pphosted.com with ESMTP id 3em0du0xmg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 09 Mar 2022 04:14:11 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 22947k10167717;
        Wed, 9 Mar 2022 04:14:10 GMT
Received: from pps.reinject (localhost [127.0.0.1])
        by aserp3020.oracle.com with ESMTP id 3ekyp2qddp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 09 Mar 2022 04:14:10 +0000
Received: from aserp3020.oracle.com (aserp3020.oracle.com [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 2294EAeF174884;
        Wed, 9 Mar 2022 04:14:10 GMT
Received: from ca-mkp.mkp.ca.oracle.com (ca-mkp.ca.oracle.com [10.156.108.201])
        by aserp3020.oracle.com with ESMTP id 3ekyp2qddd-1;
        Wed, 09 Mar 2022 04:14:10 +0000
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     John Garry <john.garry@huawei.com>, linux-scsi@vger.kernel.org,
        Damien Le Moal <damien.lemoal@opensource.wdc.com>,
        Jason Yan <yanaijie@huawei.com>,
        Dan Carpenter <dan.carpenter@oracle.com>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH v2] scsi: libsas: cleanup sas_form_port()
Date:   Tue,  8 Mar 2022 23:14:05 -0500
Message-Id: <164679903742.29335.4694775601726558276.b4-ty@oracle.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20220228094857.557329-1-damien.lemoal@opensource.wdc.com>
References: <20220228094857.557329-1-damien.lemoal@opensource.wdc.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Proofpoint-ORIG-GUID: mUPW8SX7IFdOXdxtEz_pddZwNgcNS3qY
X-Proofpoint-GUID: mUPW8SX7IFdOXdxtEz_pddZwNgcNS3qY
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Mon, 28 Feb 2022 18:48:57 +0900, Damien Le Moal wrote:

> Sparse throws a warning about context imbalance ("different lock
> contexts for basic block") in sas_form_port() as it gets confused with
> the fact that a port is locked within one of the 2 search loop and
> unlocked afterward outside of the search loops once the phy is added to
> the port. Since this code is not easy to follow, improve it by factoring
> out the code adding the phy to the port once the port is locked into the
> helper function sas_form_port_add_phy(). This helper can then be called
> directly within the port search loops, avoiding confusion and clearing
> the sparse warning.
> 
> [...]

Applied to 5.18/scsi-queue, thanks!

[1/1] scsi: libsas: cleanup sas_form_port()
      https://git.kernel.org/mkp/scsi/c/32698c955295

-- 
Martin K. Petersen	Oracle Linux Engineering
