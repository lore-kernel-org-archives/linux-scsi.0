Return-Path: <SRS0=78fV=5C=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5E2D5C1975A
	for <linux-scsi@archiver.kernel.org>; Tue, 17 Mar 2020 17:37:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2A76620735
	for <linux-scsi@archiver.kernel.org>; Tue, 17 Mar 2020 17:37:11 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="SCFOcK04"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726541AbgCQRhK (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 17 Mar 2020 13:37:10 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:37546 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726121AbgCQRhK (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 17 Mar 2020 13:37:10 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 02HHHid4056176;
        Tue, 17 Mar 2020 17:37:05 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : references : date : in-reply-to : message-id : mime-version :
 content-type; s=corp-2020-01-29;
 bh=MvSwwo92DsrXQy0Agc5N+8enO8qO2ig/YDPbQhy2Oe8=;
 b=SCFOcK04iZ6HFDfUiv68sv6BE0H+zlz5uf9AQwen+Ukw8zaAPm0hH8erefMaT+XPfjXf
 OLNg3ZhHi+mLYntJlu2vvUhu6ZuBu1azH+PhMtdBARxU98PpXz+3xIQsUS6RfDSzaFc3
 PbDV6roNqS5Z6gRkKzUPogIO9h0vEEoeD//zHIs47xgV8DwiS+KgahE75keaTcLyz+Ks
 tXn9qf3lFWIZ4jMVQ34VO7qPsdssa5HPIvEp4y0AAdRejfP1PIxMWVF3exqymFmO/4uY
 KP6t75t4efubZzEb6uFT/xYsZkMIJiq/UdbWyoLp8mVQxYUND4KYeo3qo/7M+A9o3EDV zw== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2120.oracle.com with ESMTP id 2yrqwn66vs-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 17 Mar 2020 17:37:05 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 02HHKYc2001465;
        Tue, 17 Mar 2020 17:37:05 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userp3020.oracle.com with ESMTP id 2ys8yymr3q-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 17 Mar 2020 17:37:05 +0000
Received: from abhmp0012.oracle.com (abhmp0012.oracle.com [141.146.116.18])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 02HHb4hm028355;
        Tue, 17 Mar 2020 17:37:04 GMT
Received: from ca-mkp.ca.oracle.com (/10.159.214.123)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 17 Mar 2020 10:37:03 -0700
To:     Takashi Iwai <tiwai@suse.de>
Cc:     linux-scsi@vger.kernel.org
Subject: Re: [PATCH v2 0/8] scsi: Use scnprintf() for avoiding potential buffer overflow
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
References: <20200315094241.9086-1-tiwai@suse.de>
Date:   Tue, 17 Mar 2020 13:37:02 -0400
In-Reply-To: <20200315094241.9086-1-tiwai@suse.de> (Takashi Iwai's message of
        "Sun, 15 Mar 2020 10:42:33 +0100")
Message-ID: <yq1blouopc1.fsf@oracle.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1.92 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9563 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 mlxlogscore=920 mlxscore=0
 adultscore=0 bulkscore=0 malwarescore=0 spamscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2003020000
 definitions=main-2003170069
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9563 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 lowpriorityscore=0 mlxlogscore=984
 mlxscore=0 bulkscore=0 phishscore=0 spamscore=0 suspectscore=0
 malwarescore=0 priorityscore=1501 clxscore=1011 adultscore=0
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2003170069
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Takashi,

> here is a respin of trivial patch series just to convert suspicious
> snprintf() usages with the more safer one, scnprintf().

Applied to 5.7/scsi-queue, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
