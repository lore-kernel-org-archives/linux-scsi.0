Return-Path: <SRS0=qxeY=C2=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9F5C0C433E2
	for <linux-scsi@archiver.kernel.org>; Thu, 17 Sep 2020 04:39:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 57397208E4
	for <linux-scsi@archiver.kernel.org>; Thu, 17 Sep 2020 04:39:10 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="uZc1SkBA"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726126AbgIQEjF (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 17 Sep 2020 00:39:05 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:43034 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725267AbgIQEjE (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 17 Sep 2020 00:39:04 -0400
X-Greylist: delayed 12460 seconds by postgrey-1.27 at vger.kernel.org; Thu, 17 Sep 2020 00:39:03 EDT
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 08H18u4d003589;
        Thu, 17 Sep 2020 01:10:52 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : mime-version :
 content-type; s=corp-2020-01-29;
 bh=tjZQK6ULcGr0MkqRNUv7sTRb+fPh/vA/4XgPl7/esnU=;
 b=uZc1SkBAODgzfsLj2OPNti3MoEtuZff14d/u5deKYcez5I5bUXV6l1GRgD8v9aAqoWWF
 aoWxyHjJpY3uRmg2w05ePcz2Bl+yp/sx5usZMeb2KS/iBxVU/yBolS5VKGk6iOOHfhRl
 V0/2w7NV7nzDthXnmf53BurvV7ue7WfT7Ul2Y1lTy8HRkddi1ktgOXDxYbmAAAowBOox
 YDF8fP99qn2smWUtFSLrwTF466/GZvfxvMVlbVuULHEQ4atFpXMi+3ngjd6hNM2/Gz2p
 HDFMw6mI06RFIt4bptHT1hcmomM64fnFztwTacD/edpx7NvjwbAw91UJIca/3DhdJCca Xw== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2120.oracle.com with ESMTP id 33gp9me6ej-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Thu, 17 Sep 2020 01:10:52 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 08H19te4010994;
        Thu, 17 Sep 2020 01:10:51 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3020.oracle.com with ESMTP id 33hm33v1s6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 17 Sep 2020 01:10:51 +0000
Received: from abhmp0020.oracle.com (abhmp0020.oracle.com [141.146.116.26])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 08H1AedG009064;
        Thu, 17 Sep 2020 01:10:40 GMT
Received: from ca-mkp.ca.oracle.com (/10.159.214.123)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 17 Sep 2020 01:10:39 +0000
To:     John Garry <john.garry@huawei.com>
Cc:     "Martin K. Petersen" <martin.petersen@oracle.com>,
        Jens Axboe <axboe@kernel.dk>, <jejb@linux.ibm.com>,
        <don.brace@microsemi.com>, <kashyap.desai@broadcom.com>,
        <ming.lei@redhat.com>, <bvanassche@acm.org>,
        <dgilbert@interlog.com>, <paolo.valente@linaro.org>,
        <hare@suse.de>, <hch@lst.de>, <sumit.saxena@broadcom.com>,
        <linux-block@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-scsi@vger.kernel.org>, <esc.storagedev@microsemi.com>,
        <megaraidlinux.pdl@broadcom.com>, <chenxiang66@hisilicon.com>,
        <luojiaxing@huawei.com>
Subject: Re: [PATCH v8 00/18] blk-mq/scsi: Provide hostwide shared tags for
 SCSI HBAs
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq1imcdw6ni.fsf@ca-mkp.ca.oracle.com>
References: <1597850436-116171-1-git-send-email-john.garry@huawei.com>
        <df6a3bd3-a89e-5f2f-ece1-a12ada02b521@kernel.dk>
        <379ef8a4-5042-926a-b8a0-2d0a684a0e01@huawei.com>
        <yq1363xbtk7.fsf@ca-mkp.ca.oracle.com>
        <32def143-911f-e497-662e-a2a41572fe4f@huawei.com>
Date:   Wed, 16 Sep 2020 21:10:36 -0400
In-Reply-To: <32def143-911f-e497-662e-a2a41572fe4f@huawei.com> (John Garry's
        message of "Wed, 16 Sep 2020 08:21:25 +0100")
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9746 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 bulkscore=0 mlxlogscore=999
 malwarescore=0 mlxscore=0 phishscore=0 adultscore=0 suspectscore=1
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2009170005
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9746 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 mlxlogscore=999
 adultscore=0 malwarescore=0 clxscore=1015 lowpriorityscore=0 phishscore=0
 spamscore=0 priorityscore=1501 suspectscore=1 impostorscore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2009170005
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


John,

> Have you had a chance to check these outstanding SCSI patches?
>
> scsi: megaraid_sas: Added support for shared host tagset for cpuhotplug
> scsi: scsi_debug: Support host tagset
> scsi: hisi_sas: Switch v3 hw to MQ
> scsi: core: Show nr_hw_queues in sysfs
> scsi: Add host and host template flag 'host_tagset'

These look good to me.

Jens, feel free to merge.

Acked-by: Martin K. Petersen <martin.petersen@oracle.com>

-- 
Martin K. Petersen	Oracle Linux Engineering
