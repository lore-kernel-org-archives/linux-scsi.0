Return-Path: <SRS0=0wOg=3R=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CE016C3F68F
	for <linux-scsi@archiver.kernel.org>; Tue, 28 Jan 2020 04:23:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A4E512467E
	for <linux-scsi@archiver.kernel.org>; Tue, 28 Jan 2020 04:23:37 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="XqNc0O72"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726267AbgA1EXf (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 27 Jan 2020 23:23:35 -0500
Received: from userp2130.oracle.com ([156.151.31.86]:46848 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726080AbgA1EXf (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 27 Jan 2020 23:23:35 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 00S4NE1V037805;
        Tue, 28 Jan 2020 04:23:22 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : references : date : in-reply-to : message-id : mime-version :
 content-type; s=corp-2019-08-05;
 bh=M37/lXKBiBEp6qH6zPjw/skt+VvxL1DBqovNM+NSYDo=;
 b=XqNc0O72SHdaNHogRvhTEgCWmwfej++xfd4GiWOv1zqeTZjXKE5bS9AWnVQUQrLwXmPR
 JuOEOQgwowClkgfpjxsON1fU+i8ZRo3HGj7UmmqeJU4LxLoAJ7xSnXqGL4dZ3XEVhNwD
 Ui0ySuDxk4v3TJujh4m5dCZmj5yrddhrTSnQNteI8Kakxr0U0v0w4A/tcfyA8daHCyv1
 ognIzI7cf4rDLDbmOA7/FlWbtm49Da74a0CaJO69Uu7vs29Mi+lcJQD+62nEo2wScWrl
 4KAXwkTXdfPgomQlX74hMq7s+Z2zfsabd0k0ugcCC1NxnA777+wqJLt8cQZmj3A0bxkI HQ== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2130.oracle.com with ESMTP id 2xrd3u3h6x-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 28 Jan 2020 04:23:22 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 00S4NKv1182696;
        Tue, 28 Jan 2020 04:23:22 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3020.oracle.com with ESMTP id 2xta8gtfv0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 28 Jan 2020 04:23:22 +0000
Received: from abhmp0012.oracle.com (abhmp0012.oracle.com [141.146.116.18])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 00S4N3JO000985;
        Tue, 28 Jan 2020 04:23:04 GMT
Received: from ca-mkp.ca.oracle.com (/10.159.214.123)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 27 Jan 2020 20:23:03 -0800
To:     Sumanesh Samanta <sumanesh.samanta@broadcom.com>
Cc:     "Martin K. Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org,
        James Bottomley <James.Bottomley@hansenpartnership.com>,
        Jens Axboe <axboe@kernel.dk>,
        Sathya Prakash <sathya.prakash@broadcom.com>,
        Chaitra P B <chaitra.basappa@broadcom.com>,
        Suganath Prabu Subramani 
        <suganath-prabu.subramani@broadcom.com>,
        Kashyap Desai <kashyap.desai@broadcom.com>,
        Shivasharan S <shivasharan.srikanteshwara@broadcom.com>,
        "Ewan D . Milne" <emilne@redhat.com>,
        Christoph Hellwig <hch@lst.de>, Hannes Reinecke <hare@suse.de>,
        Bart Van Assche <bart.vanassche@wdc.com>,
        Ming Lei <ming.lei@redhat.com>, linux-block@vger.kernel.org,
        Sumit Saxena <sumit.saxena@broadcom.com>
Subject: Re: [PATCH 5/6] scsi: core: don't limit per-LUN queue depth for SSD when HBA needs
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
References: <20200119071432.18558-1-ming.lei@redhat.com>
        <20200119071432.18558-6-ming.lei@redhat.com>
        <yq1y2u1if7t.fsf@oracle.com>
        <ab676c4c-03fb-7eb9-6212-129eb83d0ee8@broadcom.com>
        <yq1iml1ehtl.fsf@oracle.com>
        <f4f06cf8459c21749335c6b7a4cfe729@mail.gmail.com>
Date:   Mon, 27 Jan 2020 23:22:59 -0500
In-Reply-To: <f4f06cf8459c21749335c6b7a4cfe729@mail.gmail.com> (Sumanesh
        Samanta's message of "Fri, 24 Jan 2020 12:41:20 -0700")
Message-ID: <yq1blqo9plo.fsf@oracle.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1.92 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9513 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=983
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1911140001 definitions=main-2001280034
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9513 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1911140001
 definitions=main-2001280034
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Sumanesh,

> Instead of relying on QUEUE_FULL and some complex heuristics of when
> to start tracking device_busy, why can't we simply use "
> track_queue_depth" ( along with the other flag that Ming added) to
> decide which devices need queue depth tracking, and track device_busy
> only for them?

Because I am interested in addressing the device_busy contention problem
for all of our non-legacy drivers. I.e. not just for controllers that
happen to queue internally.

> I am not sure how we can suddenly start tracking device_busy on the fly,
> if we do not know how many IO are already pending for that device?

We know that from the tags. It's just not hot path material.

-- 
Martin K. Petersen	Oracle Linux Engineering
