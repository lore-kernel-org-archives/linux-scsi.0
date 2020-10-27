Return-Path: <SRS0=LZqT=EC=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.9 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0B7A7C55178
	for <linux-scsi@archiver.kernel.org>; Tue, 27 Oct 2020 00:21:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CBA8620723
	for <linux-scsi@archiver.kernel.org>; Tue, 27 Oct 2020 00:21:48 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="Nkt9v38U"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2441229AbgJ0AVr (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 26 Oct 2020 20:21:47 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:55040 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2441222AbgJ0AVq (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 26 Oct 2020 20:21:46 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 09R0F2MN058979;
        Tue, 27 Oct 2020 00:21:40 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : mime-version :
 content-type; s=corp-2020-01-29;
 bh=yKf+TLM8FaUS8yvyOhERA6d6h1+T384M5rD4+vg1YPw=;
 b=Nkt9v38UOEu/EiDVq2/8jnrElgCtFvj1WP0KvNg1iUfqQ7QdnsDqrM0Ddb3jdGrNsAaH
 tEWAMYLOwP1EW5+VruIq1X8IyYQfoJf/xb2jEDZz5Ok3VCHj7oUxaQnjgSMIW0mEgy54
 vXxfBuI0A347gQiogac3L3Dd91l17L/wPWfkF8gkphpHmY6xneqPHtiLhptq16hoUIoy
 vlWRZ4QFpJPdC+WHbDR1GG7KhKJbdidTP1JknXPdjVMqQqsc12oTZWUEUUH05bdBOagF
 UVZ4RrDrz+hNvT7uuHgSgIwKzSPnhd+hRV/Tx10frwk5cjY4RLdlGsiHoxrdJyJrk0Vy Vg== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2120.oracle.com with ESMTP id 34dgm3vx7u-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Tue, 27 Oct 2020 00:21:39 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 09R0Fxeb025400;
        Tue, 27 Oct 2020 00:21:39 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3020.oracle.com with ESMTP id 34cx5wgnee-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 27 Oct 2020 00:21:39 +0000
Received: from abhmp0006.oracle.com (abhmp0006.oracle.com [141.146.116.12])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 09R0Lb01015918;
        Tue, 27 Oct 2020 00:21:37 GMT
Received: from ca-mkp.ca.oracle.com (/10.159.214.123)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 26 Oct 2020 17:21:37 -0700
To:     Hannes Reinecke <hare@suse.de>
Cc:     "Martin K. Petersen" <martin.petersen@oracle.com>,
        Christoph Hellwig <hch@lst.de>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        linux-scsi@vger.kernel.org
Subject: Re: [PATCH 0/4] scsi: remove devices in ALUA transitioning status
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq136207c42.fsf@ca-mkp.ca.oracle.com>
References: <20200930080256.90964-1-hare@suse.de>
Date:   Mon, 26 Oct 2020 20:21:35 -0400
In-Reply-To: <20200930080256.90964-1-hare@suse.de> (Hannes Reinecke's message
        of "Wed, 30 Sep 2020 10:02:52 +0200")
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9786 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 mlxscore=0 mlxlogscore=999
 suspectscore=1 bulkscore=0 malwarescore=0 spamscore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2010270000
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9786 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 lowpriorityscore=0 impostorscore=0
 adultscore=0 bulkscore=0 spamscore=0 phishscore=0 mlxlogscore=999
 suspectscore=1 clxscore=1015 mlxscore=0 malwarescore=0 priorityscore=1501
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2010270000
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Hannes,

> during testing we found that there is an issue with dev_loss_tmo and
> devices in ALUA transitioning state.  What happens is that I/O gets
> requeued via BLK_STS_RESOURCE for these devices, so when dev_loss_tmo
> triggers the SCSI core cannot flush the request list as I/O is simply
> requeued.
>
> So when the driver is trying to re-establish the device it'll wait for
> that last reference to drop in order to re-attach the device, but as
> I/O is still outstanding on the (old) device it'll wait for ever.
>
> Fix this by returning 'BLK_STS_AGAIN' from scsi_dh_alua when the
> device is in ALUA transitioning, and also set the 'transitioning'
> state when scsi_dh_alua is receiving a sense code, and not only after
> scsi_dh_alua successfully received the response to a REPORT TARGET
> PORT GROUPS command.

It would be good to get this revived/reviewed.

Thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
