Return-Path: <SRS0=0wOg=3R=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 59CC9C35249
	for <linux-scsi@archiver.kernel.org>; Tue, 28 Jan 2020 04:07:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 319A42467F
	for <linux-scsi@archiver.kernel.org>; Tue, 28 Jan 2020 04:07:02 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="WJ+zi0wf"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726294AbgA1EHB (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 27 Jan 2020 23:07:01 -0500
Received: from userp2120.oracle.com ([156.151.31.85]:39464 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726191AbgA1EHB (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 27 Jan 2020 23:07:01 -0500
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 00S444rD002746;
        Tue, 28 Jan 2020 04:06:48 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : references : date : in-reply-to : message-id : mime-version :
 content-type; s=corp-2019-08-05;
 bh=kSe+FMI4DWUbakNU7CA9Z8wJ2J1bWGYKRMfixOlJauc=;
 b=WJ+zi0wfyRH70+od4Qk5d79Iez2RalBqBqDi+TX+QC2QOnFd8EDgwDa6vA4TpQxQBPHZ
 /I+wnzTUmSI8HKI/RJnowrlILMH6GKr85UdwMedjHkqzACEQqWfBE97GvrRMeiwqoJdS
 wdXP0VDuC7xi78ybzRe+0nshk0PwCe4f5WmUA6d1/7orxJrdmCkvLBfYu81OnBWgWTvS
 mI63KY4pfi+MvFcOUKg7Hk0xJzFdlfg5ng8fnEp1HUk+6r8YhJZIoi07E//nZ+8T1vkL
 1IlPqZLdKJbrMwjmEplV8Ci0d5SgbQEmLQzkZWXRvLGv4XP3weTAo82DESHP3Ac5gqP6 PQ== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2120.oracle.com with ESMTP id 2xrear3brj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 28 Jan 2020 04:06:48 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 00S44jhk101251;
        Tue, 28 Jan 2020 04:04:47 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3020.oracle.com with ESMTP id 2xry6xc7xf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 28 Jan 2020 04:04:47 +0000
Received: from abhmp0004.oracle.com (abhmp0004.oracle.com [141.146.116.10])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 00S44LmP018493;
        Tue, 28 Jan 2020 04:04:21 GMT
Received: from ca-mkp.ca.oracle.com (/10.159.214.123)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 27 Jan 2020 20:04:21 -0800
To:     Sumit Saxena <sumit.saxena@broadcom.com>
Cc:     Ming Lei <ming.lei@redhat.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        James Bottomley <James.Bottomley@hansenpartnership.com>,
        Linux SCSI List <linux-scsi@vger.kernel.org>,
        linux-block@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
        Sathya Prakash <sathya.prakash@broadcom.com>,
        Chaitra P B <chaitra.basappa@broadcom.com>,
        Suganath Prabu Subramani 
        <suganath-prabu.subramani@broadcom.com>,
        Kashyap Desai <kashyap.desai@broadcom.com>,
        Shivasharan S <shivasharan.srikanteshwara@broadcom.com>,
        "Ewan D . Milne" <emilne@redhat.com>,
        Christoph Hellwig <hch@lst.de>, Hannes Reinecke <hare@suse.de>,
        Bart Van Assche <bart.vanassche@wdc.com>
Subject: Re: [PATCH 5/6] scsi: core: don't limit per-LUN queue depth for SSD when HBA needs
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
References: <20200119071432.18558-1-ming.lei@redhat.com>
        <20200119071432.18558-6-ming.lei@redhat.com>
        <yq1y2u1if7t.fsf@oracle.com> <20200123025429.GA5191@ming.t460p>
        <yq1sgk5ejix.fsf@oracle.com> <20200124015957.GA17387@ming.t460p>
        <CAL2rwxrLVeAZmFPGvOOqDrea8Nh3p1Cb5BSd4r4noC_8AzRtHg@mail.gmail.com>
Date:   Mon, 27 Jan 2020 23:04:18 -0500
In-Reply-To: <CAL2rwxrLVeAZmFPGvOOqDrea8Nh3p1Cb5BSd4r4noC_8AzRtHg@mail.gmail.com>
        (Sumit Saxena's message of "Fri, 24 Jan 2020 18:13:40 +0530")
Message-ID: <yq1ftg09qgt.fsf@oracle.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1.92 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9513 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1911140001 definitions=main-2001280031
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9513 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1911140001
 definitions=main-2001280031
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Sumit,

> "mpt3sas" adapters support QUEUE FULL based on IOCCapabilities of
> Firmware.  Default configuration is Firmware will manage QUEUE FULL.

Regrettably...

-- 
Martin K. Petersen	Oracle Linux Engineering
