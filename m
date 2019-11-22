Return-Path: <SRS0=RMqd=ZO=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1860AC432C0
	for <linux-scsi@archiver.kernel.org>; Fri, 22 Nov 2019 02:13:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E0EF1206D7
	for <linux-scsi@archiver.kernel.org>; Fri, 22 Nov 2019 02:13:36 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="R2IINA7y"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726573AbfKVCNg (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 21 Nov 2019 21:13:36 -0500
Received: from userp2130.oracle.com ([156.151.31.86]:46752 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726329AbfKVCNg (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 21 Nov 2019 21:13:36 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xAM29MIY144986;
        Fri, 22 Nov 2019 02:13:17 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : references : date : in-reply-to : message-id : mime-version :
 content-type; s=corp-2019-08-05;
 bh=rbaVrfvNpeSog8dcDylxXVV3ptewurNNj/oaRb7B83Y=;
 b=R2IINA7yBSLivO2IMdgp/49coWk21Epjfp4oasnXp4JR8Xl36Wq1bKjmfDLFRe/hZWS1
 RDLkt318zMmlHs5PpIjfbG5UckhjCAdkr6Ud4Vffj7Gt0h6BPvi1Fet6dfE62+65DWod
 ZlAnicLodJTK82OFh9D2dodBEcQXU6ZYsA0rord8BGLYg167LzVabB93Rw9BmjkOIxy4
 B1ujsT/aE2Kpz3U85HiWIz9KY6oPP0mqBWRuFyFTf8zH2OpUuiGLZO0At4hMwV9I/KJH
 SfjEd6xa+/tDmNj0mn7II5+O8lxm96dItBfEQetr8wKE+yexou7v0hPydQMqbzc1VKlP Pg== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2130.oracle.com with ESMTP id 2wa8hu7xs4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 22 Nov 2019 02:13:17 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xAM28gGV112601;
        Fri, 22 Nov 2019 02:13:16 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3020.oracle.com with ESMTP id 2wdfrwd8jw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 22 Nov 2019 02:13:16 +0000
Received: from abhmp0001.oracle.com (abhmp0001.oracle.com [141.146.116.7])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id xAM2DFHx013213;
        Fri, 22 Nov 2019 02:13:15 GMT
Received: from ca-mkp.ca.oracle.com (/10.159.214.123)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 21 Nov 2019 18:13:14 -0800
To:     John Garry <john.garry@huawei.com>
Cc:     <jejb@linux.vnet.ibm.com>, <martin.petersen@oracle.com>,
        <hch@lst.de>, <linux-scsi@vger.kernel.org>,
        <chenxiang66@hisilicon.com>, <linux-kernel@vger.kernel.org>,
        <yanaijie@huawei.com>
Subject: Re: [PATCH] scsi: scsi_transport_sas: Fix memory leak when removing devices
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
References: <1574242755-94156-1-git-send-email-john.garry@huawei.com>
Date:   Thu, 21 Nov 2019 21:13:12 -0500
In-Reply-To: <1574242755-94156-1-git-send-email-john.garry@huawei.com> (John
        Garry's message of "Wed, 20 Nov 2019 17:39:15 +0800")
Message-ID: <yq136egd5fr.fsf@oracle.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1.92 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9448 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=822
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1911140001 definitions=main-1911220017
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9448 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1011
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=908 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1911140001
 definitions=main-1911220017
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


John,

> Removing a non-host rphy causes a memory leak:

Applied to 5.5/scsi-queue, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
