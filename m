Return-Path: <SRS0=h99Q=3K=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F1567C33CB6
	for <linux-scsi@archiver.kernel.org>; Tue, 21 Jan 2020 04:52:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C712C24655
	for <linux-scsi@archiver.kernel.org>; Tue, 21 Jan 2020 04:52:42 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="bRYsuDwG"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728655AbgAUEwl (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 20 Jan 2020 23:52:41 -0500
Received: from userp2130.oracle.com ([156.151.31.86]:39450 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727829AbgAUEwl (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 20 Jan 2020 23:52:41 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 00L4m2VG101771;
        Tue, 21 Jan 2020 04:52:23 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : references : date : in-reply-to : message-id : mime-version :
 content-type; s=corp-2019-08-05;
 bh=zSvC7syoNNlYvDzSXENQ1TCXt+1V3NHHaxvUKbY+RYc=;
 b=bRYsuDwG/O8FwgfamryzNP9oCLbkqaCwhe3JQViZt4HIrxILETuRXNClcuI9eKlSXZhm
 7u3OhPD64VSBG6mNQxAvZEFAao2ifDoXur3s/Bw97gIlR4NcG5MFKAlVJRoxE4BJT47s
 zxSuSanJtv4YIPru6UGC+C2XrVg4BkFXxY2LZWLxV3wByo3H621YP7juUkvSzUtZD5Vh
 fuRrBQWeGwT2/Fbw3NUxvF2C7Zx/5kUAp/2+81DloZH/1AgEpQudS/gbZ0b0owZAedIR
 Tu4l++Nu/wZaOcvpnfoBLw02h6pUgA+XXNutumlz4uJ0YhBq4eObhtfFpit8a+c5lgrA YQ== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2130.oracle.com with ESMTP id 2xkseuam1m-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 21 Jan 2020 04:52:23 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 00L4mEfu138691;
        Tue, 21 Jan 2020 04:52:22 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3020.oracle.com with ESMTP id 2xnpeb91p7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 21 Jan 2020 04:52:22 +0000
Received: from abhmp0018.oracle.com (abhmp0018.oracle.com [141.146.116.24])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 00L4qA2t026702;
        Tue, 21 Jan 2020 04:52:10 GMT
Received: from ca-mkp.ca.oracle.com (/10.159.214.123)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 20 Jan 2020 20:52:09 -0800
To:     Ming Lei <ming.lei@redhat.com>
Cc:     James Bottomley <James.Bottomley@HansenPartnership.com>,
        linux-scsi@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-block@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
        Sathya Prakash <sathya.prakash@broadcom.com>,
        Chaitra P B <chaitra.basappa@broadcom.com>,
        Suganath Prabu Subramani 
        <suganath-prabu.subramani@broadcom.com>,
        Kashyap Desai <kashyap.desai@broadcom.com>,
        Sumit Saxena <sumit.saxena@broadcom.com>,
        Shivasharan S <shivasharan.srikanteshwara@broadcom.com>,
        "Ewan D . Milne" <emilne@redhat.com>,
        Christoph Hellwig <hch@lst.de>, Hannes Reinecke <hare@suse.de>,
        Bart Van Assche <bart.vanassche@wdc.com>
Subject: Re: [PATCH 5/6] scsi: core: don't limit per-LUN queue depth for SSD when HBA needs
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
References: <20200119071432.18558-1-ming.lei@redhat.com>
        <20200119071432.18558-6-ming.lei@redhat.com>
Date:   Mon, 20 Jan 2020 23:52:06 -0500
In-Reply-To: <20200119071432.18558-6-ming.lei@redhat.com> (Ming Lei's message
        of "Sun, 19 Jan 2020 15:14:31 +0800")
Message-ID: <yq1y2u1if7t.fsf@oracle.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1.92 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9506 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=2 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1911140001 definitions=main-2001210041
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9506 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=2 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1911140001
 definitions=main-2001210041
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Ming,

> NVMe doesn't have such per-request-queue(namespace) queue depth, so it
> is reasonable to ignore the limit for SCSI SSD too.

It is really not. A free host tag does not guarantee that the target
device can queue the command.

The assumption that SSDs are somehow special because they are "fast" is
not valid. Given the common hardware queue depth for a SAS device of
~128 it is often trivial to drive a device into a congestion
scenario. We see it all the time for non-rotational devices, SSDs and
arrays alike. The SSD heuristic is simply not going to fly.

Don't get me wrong, I am very sympathetic to obliterating device_busy in
the hot path. I just don't think it is as easy as just ignoring the
counter and hope for the best. Dynamic queue depth management is an
integral part of the SCSI protocol, not something we can just decide to
bypass because a device claims to be of a certain media type or speed.

I would prefer not to touch drivers that rely on cmd_per_lun / untagged
operation and focus exclusively on the ones that use .track_queue_depth.
For those we could consider an adaptive queue depth management scheme.
Something like not maintaining device_busy until we actually get a
QUEUE_FULL condition. And then rely on the existing queue depth ramp up
heuristics to determine when to disable the busy counter again. Maybe
with an additional watermark or time limit to avoid flip-flopping.

If that approach turns out to work, we should convert all remaining
non-legacy drivers to .track_queue_depth so we only have two driver
queuing flavors to worry about.

-- 
Martin K. Petersen	Oracle Linux Engineering
