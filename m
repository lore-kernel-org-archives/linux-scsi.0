Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 11E89C433EF
	for <linux-scsi@archiver.kernel.org>; Wed,  2 Mar 2022 05:13:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237736AbiCBFOX (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 2 Mar 2022 00:14:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41752 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238681AbiCBFOV (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 2 Mar 2022 00:14:21 -0500
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0B94419286
        for <linux-scsi@vger.kernel.org>; Tue,  1 Mar 2022 21:13:38 -0800 (PST)
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 2222xuo5014684;
        Wed, 2 Mar 2022 05:13:33 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2021-07-09;
 bh=aCN9NflAAMvdFGaYbnVP+UXNoWWs88uwgRUsQ9PCDnc=;
 b=QunudFvpePuljK8tdaZOI1zfzDdopTX9/LqIQy3ZVH70Fn6lPJpRgONHEx9w57+LhZxG
 Ism4r/SrEdQEbCjzyXfN5+/B5xYZKmYV5af869EBBrphlC+8D4Qg91AfsovOXPv7XVBx
 8c39ofXv43j0fC1qJAs8X49iAoudKg4PPXr1GHQsyG1hdyvBjXXOAQH7oxFvJA1+Ytcd
 q/uIPP1xCp8xsWr5ZUwyFXMrob9Dnz7gmGXgYTvlGo20OiEcfQuSkfaBgoKW9V/mz3Be
 RHM6AZPxoGWh5zpZpzBDYyxiYSlt9b/uunbnWsjt3NmSzdQcrSRy4tVioj+xFiaQU1hp ig== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by mx0b-00069f02.pphosted.com with ESMTP id 3eh15amp2k-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 02 Mar 2022 05:13:33 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 2225C1xP175274;
        Wed, 2 Mar 2022 05:13:31 GMT
Received: from pps.reinject (localhost [127.0.0.1])
        by userp3030.oracle.com with ESMTP id 3ef9ayxgea-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 02 Mar 2022 05:13:31 +0000
Received: from userp3030.oracle.com (userp3030.oracle.com [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 2225DVPG178145;
        Wed, 2 Mar 2022 05:13:31 GMT
Received: from ca-mkp.mkp.ca.oracle.com (ca-mkp.ca.oracle.com [10.156.108.201])
        by userp3030.oracle.com with ESMTP id 3ef9ayxgcv-1;
        Wed, 02 Mar 2022 05:13:31 +0000
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     linux-scsi@vger.kernel.org, Ajish Koshy <Ajish.Koshy@microchip.com>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        Jinpu Wang <jinpu.wang@cloud.ionos.com>,
        Damien Le Moal <damien.lemoal@opensource.wdc.com>,
        Viswas.G@microchip.com, Vasanthalakshmi.Tharmarajan@microchip.com
Subject: Re: [PATCH v2] scsi: pm80xx: handle non-fatal errors
Date:   Wed,  2 Mar 2022 00:13:19 -0500
Message-Id: <164619702112.16127.1049773029089570035.b4-ty@oracle.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20220222092618.108198-1-Ajish.Koshy@microchip.com>
References: <20220222092618.108198-1-Ajish.Koshy@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Proofpoint-ORIG-GUID: DbOhKrBVqvEWYtS7ed8tQuZwEZDEa1UW
X-Proofpoint-GUID: DbOhKrBVqvEWYtS7ed8tQuZwEZDEa1UW
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Tue, 22 Feb 2022 14:56:18 +0530, Ajish Koshy wrote:

> Firmware expects host driver to clear scratchpad rsvd 0 register after
> non-fatal error is found.
> 
> This is done when firmware raises fatal error interrupt and indicates
> non-fatal error. At this point firmware updates scratchpad rsvd 0
> register with non-fatal error value. Here host has to clear the register
> after reading it during non-fatal errors.
> 
> [...]

Applied to 5.18/scsi-queue, thanks!

[1/1] scsi: pm80xx: handle non-fatal errors
      https://git.kernel.org/mkp/scsi/c/80cac47b0895

-- 
Martin K. Petersen	Oracle Linux Engineering
