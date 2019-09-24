Return-Path: <SRS0=Cwhq=XT=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0D8BDC432C2
	for <linux-scsi@archiver.kernel.org>; Tue, 24 Sep 2019 03:14:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D2698214AF
	for <linux-scsi@archiver.kernel.org>; Tue, 24 Sep 2019 03:13:59 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="BK+A8kAP"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2403902AbfIXDN7 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 23 Sep 2019 23:13:59 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:34222 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2394624AbfIXDN7 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 23 Sep 2019 23:13:59 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x8O39QA3146236;
        Tue, 24 Sep 2019 03:13:54 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : references : date : in-reply-to : message-id : mime-version :
 content-type; s=corp-2019-08-05;
 bh=ta5AeQudnvN1zrSND9uIdE9gyJJkB4Vl7of9pqDoRfQ=;
 b=BK+A8kAPuGliyX6IRh/JbcArRVgH51FKyHI5P1okVWimL0V4LRJfTCOcd3EGNKpLgCr/
 Q00lhEs5bShwuI7AWIsN6pfEG6AHj+T63G0IYDYm23i6sJVUhpoGhOnK4TQy3tSyo77d
 KrB3DJUBFslvE0exH394/FN7L2/zdXqFJbwWdukzHEmW4cFcTFdOyvLLMl6YAAeW/0Mn
 IsNw8lNJ2lryQayUEEMuCMkqSINS8O1GsLdS8Wdr1vHz+WEXhhnzCKnI7lcl0yfiYmMX
 RQAZGTXwHoopcBDSmae5Zel9yvyvAXianECLewI2V2jw7xLwQAPjMypBU6GaFrxSAW7m 6w== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2130.oracle.com with ESMTP id 2v5b9tk1vf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 24 Sep 2019 03:13:54 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x8O39LMj099328;
        Tue, 24 Sep 2019 03:13:54 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3020.oracle.com with ESMTP id 2v6yvmgsqa-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 24 Sep 2019 03:13:54 +0000
Received: from abhmp0009.oracle.com (abhmp0009.oracle.com [141.146.116.15])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x8O3DqkS006389;
        Tue, 24 Sep 2019 03:13:53 GMT
Received: from ca-mkp.ca.oracle.com (/10.159.214.123)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 23 Sep 2019 20:13:52 -0700
To:     Himanshu Madhani <hmadhani@marvell.com>
Cc:     <James.Bottomley@HansenPartnership.com>,
        <martin.petersen@oracle.com>, <linux-scsi@vger.kernel.org>
Subject: Re: [PATCH v2 00/14] qla2xxx: Bug fixes for the driver
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
References: <20190912180918.6436-1-hmadhani@marvell.com>
Date:   Mon, 23 Sep 2019 23:13:50 -0400
In-Reply-To: <20190912180918.6436-1-hmadhani@marvell.com> (Himanshu Madhani's
        message of "Thu, 12 Sep 2019 11:09:04 -0700")
Message-ID: <yq17e5y4c9d.fsf@oracle.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1.92 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9389 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1908290000 definitions=main-1909240031
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9389 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1908290000
 definitions=main-1909240031
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Himanshu,

> This series has fixes for N2N handling and unload path for driver when
> NPIV is configured. Also included are patches for capturing firmware
> dump when firmware posts MPI heartbeat stop event.  We have also
> enhanced handling of FCP/FC-NVMe when target advertises both
> capabilites under same WWNN.
>
> Please apply this series for 5.4/scsi-queue at your earliest
> convenience.

This came in too late for 5.4. I applied patches #1-7 to fixes. Patch #8
and beyond are more like features and will have to wait for 5.5.

Thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
