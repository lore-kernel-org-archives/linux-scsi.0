Return-Path: <SRS0=zYer=YZ=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4428ACA9ECB
	for <linux-scsi@archiver.kernel.org>; Fri,  1 Nov 2019 02:14:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1D550208E3
	for <linux-scsi@archiver.kernel.org>; Fri,  1 Nov 2019 02:14:58 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="PHt4oBZX"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727570AbfKACOy (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 31 Oct 2019 22:14:54 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:35632 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727492AbfKACOy (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 31 Oct 2019 22:14:54 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xA12E46p155908;
        Fri, 1 Nov 2019 02:14:34 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : references : date : in-reply-to : message-id : mime-version :
 content-type; s=corp-2019-08-05;
 bh=8ZteHVtFSBKHelPZ2up4MemamaBu1QtExLweCtfz82E=;
 b=PHt4oBZXCCy3QZMYC65htF/TOs7rDCRpIQ38UXoBqs/+Ra6ZWAlVkrZsNCeDW4frVnEA
 j3UKIWMOgsyuXyUyarW++aeNqLvTpxcS5UqRK3lc+libLdwMCv7Sag1Z2qFQ0oczDQTv
 orKDp9+A6zQnRvSruT4GlJrjirylrR2qres/ZQ8Zu6EqUjE5RDdnaovEQ6rjRxS7BxBt
 8lyCKM6V0yOZResaQA/nYMMmnE9EDPId/zaA8pFFtwIMhZYtwkDCO1485UHGc4JRXYTJ
 fP+KLIJ9bdaPjw2SqbLQ8wucp0NkNhEFSD//TqzyMDB1H80jOtvG+tXjeiU1CLVDwaob wA== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2120.oracle.com with ESMTP id 2vxwhfq096-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 01 Nov 2019 02:14:34 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xA12EJNr076521;
        Fri, 1 Nov 2019 02:14:34 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3020.oracle.com with ESMTP id 2vysbvyavb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 01 Nov 2019 02:14:33 +0000
Received: from abhmp0016.oracle.com (abhmp0016.oracle.com [141.146.116.22])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id xA12EHa2023451;
        Fri, 1 Nov 2019 02:14:17 GMT
Received: from ca-mkp.ca.oracle.com (/10.159.214.123)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 31 Oct 2019 19:14:16 -0700
To:     "Bean Huo \(beanhuo\)" <beanhuo@micron.com>
Cc:     "'Alim Akhtar'" <alim.akhtar@samsung.com>,
        "'Avri Altman'" <avri.altman@wdc.com>,
        "'Pedro Sousa'" <pedrom.sousa@synopsys.com>,
        "'Martin K. Petersen'" <martin.petersen@oracle.com>,
        "'James E.J. Bottomley'" <jejb@linux.ibm.com>,
        "'Evan Green'" <evgreen@chromium.org>,
        "'Stanley Chu'" <stanley.chu@mediatek.com>,
        "'linux-kernel\@vger.kernel.org'" <linux-kernel@vger.kernel.org>,
        "'linux-scsi\@vger.kernel.org'" <linux-scsi@vger.kernel.org>,
        Can Guo <cang@codeaurora.org>
Subject: Re: [PATCH v1] scsi: ufs: delete redundant function ufshcd_def_desc_sizes()
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
References: <BN7PR08MB5684A3ACE214C3D4792CE729DB610@BN7PR08MB5684.namprd08.prod.outlook.com>
Date:   Thu, 31 Oct 2019 22:14:13 -0400
In-Reply-To: <BN7PR08MB5684A3ACE214C3D4792CE729DB610@BN7PR08MB5684.namprd08.prod.outlook.com>
        (Bean Huo's message of "Tue, 29 Oct 2019 14:22:45 +0000")
Message-ID: <yq1imo45one.fsf@oracle.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1.92 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9427 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=948
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1908290000 definitions=main-1911010020
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9427 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1011
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1908290000
 definitions=main-1911010020
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Bean,

> There is no need to call ufshcd_def_desc_sizes() in ufshcd_init(),
> since descriptor lengths will be checked and initialized later in
> ufshcd_init_desc_sizes().

Applied to 5.5/scsi-queue, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
