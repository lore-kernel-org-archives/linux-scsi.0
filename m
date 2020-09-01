Return-Path: <SRS0=73BN=CK=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 101A6C433E2
	for <linux-scsi@archiver.kernel.org>; Tue,  1 Sep 2020 02:39:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E23E22071B
	for <linux-scsi@archiver.kernel.org>; Tue,  1 Sep 2020 02:39:04 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="fek4UG/q"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726085AbgIACjD (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 31 Aug 2020 22:39:03 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:40896 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725993AbgIACjD (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 31 Aug 2020 22:39:03 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0812Ywxt136261;
        Tue, 1 Sep 2020 02:38:38 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : mime-version :
 content-type; s=corp-2020-01-29;
 bh=ODzJwzUs/zeuCjHJvx0jE7ULwiCStSifLSIDrM6dZ4Q=;
 b=fek4UG/qyocwHBzdIQfXrasX5T8PoWhB7w5BJNk7wq3Cb3X9rnP+/TAJZJOWP76H/4Ni
 P55h3VwfqV6590gA9xc1AQHi48HMto/5GwsDIWNQp00paDWhwYEt7ST6DQjGiMqAD6Lf
 eLPlO6Q40cUAAR3q7WZBto81niEGZBe9eXLljmL4Cee9r5/HOsZXQcXq8c1zZgt7ckQk
 ZVbJuR6ufSOZTOcFDnI+5gVnCts8/q9tl2kktz7ICi4+JGthxAPdEGcEYHRSVrZnsRIA
 8e4nHabvhkHSU1+SNlVYQg9zbgcuBXwTmZVkN/Yo/Ss0WP+nC7noDOn79GZmJXs/Gwxa pA== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2130.oracle.com with ESMTP id 337eeqsj9k-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Tue, 01 Sep 2020 02:38:38 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0812Z8fl179592;
        Tue, 1 Sep 2020 02:38:37 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3030.oracle.com with ESMTP id 3380kmg654-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 01 Sep 2020 02:38:37 +0000
Received: from abhmp0016.oracle.com (abhmp0016.oracle.com [141.146.116.22])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 0812cOUr003233;
        Tue, 1 Sep 2020 02:38:29 GMT
Received: from ca-mkp.ca.oracle.com (/10.159.214.123)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 31 Aug 2020 19:38:24 -0700
To:     Long Li <longli@microsoft.com>
Cc:     John Garry <john.garry@huawei.com>, Ming Lei <ming.lei@redhat.com>,
        James Bottomley <James.Bottomley@HansenPartnership.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        "Ewan D . Milne" <emilne@redhat.com>,
        Kashyap Desai <kashyap.desai@broadcom.com>,
        Hannes Reinecke <hare@suse.de>,
        Bart Van Assche <bvanassche@acm.org>,
        "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>
Subject: Re: [PATCH V4] scsi: core: only re-run queue in scsi_end_request()
 if device queue is busy
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq17dtegrmy.fsf@ca-mkp.ca.oracle.com>
References: <20200817100840.2496976-1-ming.lei@redhat.com>
        <5805af73-c3ec-8393-0dc2-18fe797d781b@huawei.com>
        <BN8PR21MB1155A14705AA35680B25F9F4CE2E0@BN8PR21MB1155.namprd21.prod.outlook.com>
Date:   Mon, 31 Aug 2020 22:38:21 -0400
In-Reply-To: <BN8PR21MB1155A14705AA35680B25F9F4CE2E0@BN8PR21MB1155.namprd21.prod.outlook.com>
        (Long Li's message of "Tue, 1 Sep 2020 01:18:50 +0000")
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9730 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 spamscore=0 adultscore=0
 mlxscore=0 suspectscore=1 malwarescore=0 mlxlogscore=999 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2009010022
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9730 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 clxscore=1011 priorityscore=1501
 lowpriorityscore=0 malwarescore=0 adultscore=0 spamscore=0 mlxscore=0
 phishscore=0 impostorscore=0 mlxlogscore=999 bulkscore=0 suspectscore=1
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2009010022
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


> On Azure Standard D64s v3 (64 vcpus, 256 GiB memory), it sees better
> CPU utilization with the patch.
>
> Tested-by: Long Li <longli@microsoft.com>

Since this is a core change I'd like to see another review tag.

Thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
