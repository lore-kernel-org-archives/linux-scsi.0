Return-Path: <SRS0=Rfh9=BB=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EC844C433E4
	for <linux-scsi@archiver.kernel.org>; Wed, 22 Jul 2020 04:20:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C7F4420714
	for <linux-scsi@archiver.kernel.org>; Wed, 22 Jul 2020 04:20:56 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="neJ/Zb/f"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726667AbgGVEUy (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 22 Jul 2020 00:20:54 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:35300 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725843AbgGVEUx (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 22 Jul 2020 00:20:53 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 06M4BesR026344;
        Wed, 22 Jul 2020 04:20:39 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : mime-version :
 content-type; s=corp-2020-01-29;
 bh=GmVFjAR9iCA9TcUZ4V6DR89rguuicaNzloj+md2B74s=;
 b=neJ/Zb/fLn7FByziUxxCH1Ok5g3J26h0se84yq/aD5kyIuZ2WDgOxuTE6WX0TeyO2KNr
 HSif3/5/pGmChmIJ/Tt97lfzTXGk6dq2U761inndIReehcqm2z+LKanCY3wyP3Tx8I6S
 Y5dFFaK3NiPo5rsao4+dCbn7bPYb9qFhINTtFGT9+W82/e8o5JyjTyRNah1JRLuTsM7m
 Fhw66K4bEH8W8bBa0VmpjWwPSbwAfcI46xncSCaX+JhpmM2Mfu2kFeQioE5i1VbWx4e2
 DI7tuGNJVvINQr2TLewJnE+hZArNAuvz9yJn45AmuUypDkAM3tC6iXEwnbULNxkyDTln tA== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2120.oracle.com with ESMTP id 32d6ksn1fu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Wed, 22 Jul 2020 04:20:39 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 06M4JPhI100637;
        Wed, 22 Jul 2020 04:20:38 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3030.oracle.com with ESMTP id 32e9usga4g-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 22 Jul 2020 04:20:38 +0000
Received: from abhmp0015.oracle.com (abhmp0015.oracle.com [141.146.116.21])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 06M4KaLQ023626;
        Wed, 22 Jul 2020 04:20:36 GMT
Received: from ca-mkp.ca.oracle.com (/10.159.214.123)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 22 Jul 2020 04:20:36 +0000
To:     Avri Altman <Avri.Altman@wdc.com>
Cc:     Alim Akhtar <alim.akhtar@samsung.com>,
        "daejun7.park@samsung.com" <daejun7.park@samsung.com>,
        "jejb@linux.ibm.com" <jejb@linux.ibm.com>,
        "martin.petersen@oracle.com" <martin.petersen@oracle.com>,
        "asutoshd@codeaurora.org" <asutoshd@codeaurora.org>,
        "beanhuo@micron.com" <beanhuo@micron.com>,
        "stanley.chu@mediatek.com" <stanley.chu@mediatek.com>,
        "cang@codeaurora.org" <cang@codeaurora.org>,
        "bvanassche@acm.org" <bvanassche@acm.org>,
        "tomas.winkler@intel.com" <tomas.winkler@intel.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "'Sang-yoon Oh'" <sangyoon.oh@samsung.com>,
        "'Sung-Jun Park'" <sungjun07.park@samsung.com>,
        "'yongmyung lee'" <ymhungry.lee@samsung.com>,
        "'Jinyoung CHOI'" <j-young.choi@samsung.com>,
        "'Adel Choi'" <adel.choi@samsung.com>,
        "'BoRam Shin'" <boram.shin@samsung.com>
Subject: Re: [PATCH v6 0/5] scsi: ufs: Add Host Performance Booster Support
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq1tuy0fag7.fsf@ca-mkp.ca.oracle.com>
References: <CGME20200713103423epcms2p8442ee7cc22395e4a4cedf224f95c45e8@epcms2p8>
        <963815509.21594636682161.JavaMail.epsvc@epcpadp2>
        <077301d65b0d$24d79920$6e86cb60$@samsung.com>
        <SN6PR04MB4640A5A8C71A51DB45968DAFFC7C0@SN6PR04MB4640.namprd04.prod.outlook.com>
        <SN6PR04MB4640A85E665E20D709885E16FC7A0@SN6PR04MB4640.namprd04.prod.outlook.com>
Date:   Wed, 22 Jul 2020 00:20:32 -0400
In-Reply-To: <SN6PR04MB4640A85E665E20D709885E16FC7A0@SN6PR04MB4640.namprd04.prod.outlook.com>
        (Avri Altman's message of "Sun, 19 Jul 2020 06:35:23 +0000")
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9689 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 mlxscore=0 phishscore=0
 bulkscore=0 malwarescore=0 suspectscore=1 mlxlogscore=999 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2007220028
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9689 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 suspectscore=1
 bulkscore=0 mlxscore=0 mlxlogscore=999 impostorscore=0 priorityscore=1501
 lowpriorityscore=0 phishscore=0 spamscore=0 adultscore=0 clxscore=1011
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2007220028
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Avri,

> Martin - Can we move forward with this one?

  CHECK   drivers/scsi/ufs/ufshcd-pltfrm.c
drivers/scsi/ufs/ufsfeature.c:90:20: warning: symbol 'ufshpb_dev_type' was not declared. Should it be static?
drivers/scsi/ufs/ufsfeature.c:104:17: warning: symbol 'ufsf_bus_type' was not declared. Should it be static?
  CC [M]  drivers/scsi/ufs/ufsfeature.o
  CC [M]  drivers/scsi/ufs/ufs_bsg.o
  CC [M]  drivers/scsi/ufs/ufs-sysfs.o
drivers/scsi/ufs/ufshpb.c:18:14: warning: symbol 'ufshpb_host_map_kbytes' was not declared. Should it be static?
drivers/scsi/ufs/ufshpb.c:793:28: warning: mixing different enum types:
drivers/scsi/ufs/ufshpb.c:793:28:    unsigned int enum HPB_RGN_STATE
drivers/scsi/ufs/ufshpb.c:793:28:    unsigned int enum HPB_SRGN_STATE
  CC [M]  drivers/scsi/ufs/ufshcd.o
drivers/scsi/ufs/ufshpb.c:1026:31: warning: context imbalance in 'ufshpb_run_active_subregion_list' - different lock contexts for basic block

-- 
Martin K. Petersen	Oracle Linux Engineering
