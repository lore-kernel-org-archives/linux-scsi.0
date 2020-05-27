Return-Path: <SRS0=8UCH=7J=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F137EC433E0
	for <linux-scsi@archiver.kernel.org>; Wed, 27 May 2020 02:06:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C9AA720787
	for <linux-scsi@archiver.kernel.org>; Wed, 27 May 2020 02:06:19 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="RG6cvhsE"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726351AbgE0CGT (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 26 May 2020 22:06:19 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:37612 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726150AbgE0CGT (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 26 May 2020 22:06:19 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 04R1vj5n035126;
        Wed, 27 May 2020 02:06:11 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : mime-version :
 content-type; s=corp-2020-01-29;
 bh=wu7iKc4W62hdUcV2llDQO6mbwgnhTQAV9ktXcrg9yRc=;
 b=RG6cvhsEdLLdMgAJ/AEjjumYs0ay39f/nLD7UiZ5hQX4xwSKtV/kMFSVN+KBVTo/YpP2
 zcv8X51/r9YnySl9MbMhTl4TNecVpaCu/lfWXJCCaMWjT24QQ6UvI39uSQjYUwsd2QzE
 K+hhchN09RWDlHr2F96Ud773Wy4k+1k8kwSbz5eIO1zVMsxT7DkC+CGh3Hcoh+CXLMY1
 KPP8zlT8lgyuEkhuBVq1hoZ6ISTEwLmGG7TjHTfutDxpjQiqTcJJuthnXQptEsmf3szA
 uQ7d3VkQSACm9tSu4gpiw7GuTIw5/wYZHiy4lHeLk03WTRhJq/jNt8U7zl7t3fcSghlt xw== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2120.oracle.com with ESMTP id 318xbjvy4j-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Wed, 27 May 2020 02:06:11 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 04R1wu6b003262;
        Wed, 27 May 2020 02:06:11 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userp3030.oracle.com with ESMTP id 317dryjn98-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 27 May 2020 02:06:10 +0000
Received: from abhmp0007.oracle.com (abhmp0007.oracle.com [141.146.116.13])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 04R25xIE021041;
        Wed, 27 May 2020 02:06:09 GMT
Received: from ca-mkp.ca.oracle.com (/10.159.214.123)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 26 May 2020 19:05:58 -0700
To:     "Ulrich Windl" <Ulrich.Windl@rz.uni-regensburg.de>
Cc:     <linux-scsi@vger.kernel.org>,
        James Smart <james.smart@broadcom.com>
Subject: Re: On FC host statistics ( /sys/class/fc_host/hostX/statistics)
 and monitoring plugins
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq1h7w2kv96.fsf@ca-mkp.ca.oracle.com>
References: <5EC3CFAE020000A1000390D6@gwsmtp.uni-regensburg.de>
Date:   Tue, 26 May 2020 22:05:57 -0400
In-Reply-To: <5EC3CFAE020000A1000390D6@gwsmtp.uni-regensburg.de> (Ulrich
        Windl's message of "Tue, 19 May 2020 14:23:10 +0200")
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9633 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 phishscore=0 malwarescore=0
 mlxlogscore=999 adultscore=0 suspectscore=5 bulkscore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2004280000
 definitions=main-2005270011
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9633 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 spamscore=0 mlxscore=0
 lowpriorityscore=0 priorityscore=1501 phishscore=0 cotscore=-2147483648
 suspectscore=5 bulkscore=0 clxscore=1011 impostorscore=0 malwarescore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2004280000 definitions=main-2005270011
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Ulrich,

> 1) Some numbers (e.g. fcp_frame_alloc_failures) are not supported by
> some drivers (e.g. QLE2690) and the value read from the file is
> "0xffffffffffffffff". The source seems to set this to -1, but when
> reading it back it looks like unsigned. For a 64-bit counter it's
> quite unlikely to read this value, but it's still possible.

I agree that's messy.

> 2) While statistics counters seems to be 64 bits, I've experienced a
> "wrap around" at fewer bit positions (maybe like 40 bits) for the bfa
> driver. I have no idea whether it's a hardware restriction or a
> firmware/driver bug, however. I did my best to make sure it's not a
> problem of my plugin (assuming those counters are read atomically when
> using one read())

bfa has been dead for about 5 years so don't expect any fixes in that
department.

> My idea was (probably more universal than restricted to FC host
> statistics) to provide another file (maybe named "statistics") that
> lists the names of implemented statistics counters (i.e.: leaving out
> those set to -1) together with the significant bits (like 32 or 64),
> the type of the value (like "counter", "gauge", "boolean", "enum",
> "string", etc.)
> "string" would be free text (I doubt it will make sense for
> statistics, but anyhow), "enum" would be single word tokens
> (e.g. _not_ " NPort (fabric via point-to-point)"), "counter" would
> count bytes or events (maybe a type "event_count[er]" may make sense),
> and "gauge" would be a non-monotonic value like utilization...

I'm not a particularly big fan of -1 reporting. But it seems that the
path of least resistance is to fix the sysfs unsigned issue.

-- 
Martin K. Petersen	Oracle Linux Engineering
