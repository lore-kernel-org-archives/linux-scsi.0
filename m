Return-Path: <SRS0=a792=EB=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.9 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3D7E1C2D0A3
	for <linux-scsi@archiver.kernel.org>; Mon, 26 Oct 2020 20:10:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DC80821BE5
	for <linux-scsi@archiver.kernel.org>; Mon, 26 Oct 2020 20:10:23 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="W6XshSze"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726175AbgJZUKX (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 26 Oct 2020 16:10:23 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:47910 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726174AbgJZUKX (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 26 Oct 2020 16:10:23 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 09QK0SBO011817;
        Mon, 26 Oct 2020 20:10:12 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : mime-version :
 content-type; s=corp-2020-01-29;
 bh=sWCsMg3RgE0t4FRG1DvzyELR8z9gLmBdVNbhEBIM8mQ=;
 b=W6XshSzeJ2X6Rh9LHRTDLwFYdNmvFEe6bPlA6hMR/lJ1YdELrypQXquCY5MBK0sR4woD
 zexXiqkZ6i0VWUPbNnBBl5usON21xX5stIotb67wLYK5CNPGlRtMHg+nWnVSZTDIZWCU
 ZF5pkTv5bez7e3i41hbm5V9YEr9LdzZM9Wzx9ruDq3YeL+gqN8HHMxl/D5QiI8RmJ5P+
 PSI1ld7H8iRGjlXrB/wBf3TJNJcC/q5dM0g50rseuNBlUakSP89UVXYm8SzWeDndc/jB
 eI6Kc7BZuSWLmbEpvlh09brneFZbLETLMHPEQUejKNg1V9UAEn4xKjViPoc6Eh7w4o+8 rw== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2120.oracle.com with ESMTP id 34dgm3v6aw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Mon, 26 Oct 2020 20:10:11 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 09QJxxQ6185658;
        Mon, 26 Oct 2020 20:08:11 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3020.oracle.com with ESMTP id 34cx5wb1eg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 26 Oct 2020 20:08:11 +0000
Received: from abhmp0008.oracle.com (abhmp0008.oracle.com [141.146.116.14])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 09QK88mO003655;
        Mon, 26 Oct 2020 20:08:08 GMT
Received: from ca-mkp.ca.oracle.com (/10.159.214.123)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 26 Oct 2020 13:08:08 -0700
To:     Ming Lei <ming.lei@redhat.com>
Cc:     linux-scsi@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Christoph Hellwig <hch@lst.de>,
        "Ewan D . Milne" <emilne@redhat.com>,
        Hannes Reinecke <hare@suse.de>,
        Bart Van Assche <bvanassche@acm.org>
Subject: Re: [PATCH] scsi: core: don't start concurrent async scan on same host
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq1eelkah01.fsf@ca-mkp.ca.oracle.com>
References: <20201010032539.426615-1-ming.lei@redhat.com>
Date:   Mon, 26 Oct 2020 16:08:04 -0400
In-Reply-To: <20201010032539.426615-1-ming.lei@redhat.com> (Ming Lei's message
        of "Sat, 10 Oct 2020 11:25:39 +0800")
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9786 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 mlxscore=0 mlxlogscore=999
 suspectscore=1 bulkscore=0 malwarescore=0 spamscore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2010260132
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9786 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 lowpriorityscore=0 impostorscore=0
 adultscore=0 bulkscore=0 spamscore=0 phishscore=0 mlxlogscore=999
 suspectscore=1 clxscore=1015 mlxscore=0 malwarescore=0 priorityscore=1501
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2010260132
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Ming,

> Current scsi host scan mechanism supposes to fallback into sync host
> scan if async scan is in-progress. However, this rule isn't strictly
> respected, because scsi_prep_async_scan() doesn't hold scan_mutex when
> checking shost->async_scan. When scsi_scan_host() is called
> concurrently, two async scan on same host may be started, and hang in
> do_scan_async() is observed.
>
> Fixes this issue by checking & setting shost->async_scan atomically
> with shost->scan_mutex.

Applied to 5.10/scsi-fixes, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
