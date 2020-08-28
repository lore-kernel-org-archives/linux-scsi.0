Return-Path: <SRS0=lsqi=CG=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D6806C433E2
	for <linux-scsi@archiver.kernel.org>; Fri, 28 Aug 2020 08:13:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A46C520665
	for <linux-scsi@archiver.kernel.org>; Fri, 28 Aug 2020 08:13:03 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b="cauCaQU6"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728218AbgH1IND (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 28 Aug 2020 04:13:03 -0400
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:64286 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728444AbgH1IM7 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 28 Aug 2020 04:12:59 -0400
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 07S86Xi4017909;
        Fri, 28 Aug 2020 01:12:48 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=date : from : to :
 cc : subject : in-reply-to : message-id : references : mime-version :
 content-type; s=pfpt0220; bh=Id98umVObg4vwPprlH0XhjdBkBqEfjFMJPp+TCOC5mQ=;
 b=cauCaQU684FQOeX7h0PRmqiXsQvpLZZh1AX7dMefTGp+2G8qDcJCrvE7aB7Bccr+Mz9s
 mGymgmLJr08ODbE/aBnDFSb4C4wcBHGcGfb/NawqaUFecmBHM8+AygAe9NMd5k0KQCjt
 QzFzS7p7eqsNLOfPkwaGMoIbmEY1uBXb/wdhxhdieK7KKNtGiHyIldqbu+QWs1i8DEpg
 2m+fO9g50YyZLqGrgFzxjgzW6R9r0CIg1HUe2d/GK6bPfJRGGBP5zcMeVtYB7UWoNObI
 06WTZXXY5fdfQ2tZE7fclPQ7zYXvpQYjfoMQ1N8zQs5FPYCo97h3AfVzC76ONV29Scx1 jA== 
Received: from sc-exch03.marvell.com ([199.233.58.183])
        by mx0b-0016f401.pphosted.com with ESMTP id 3332vnayxt-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Fri, 28 Aug 2020 01:12:48 -0700
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by SC-EXCH03.marvell.com
 (10.93.176.83) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Fri, 28 Aug
 2020 01:12:47 -0700
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Fri, 28 Aug
 2020 01:12:46 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Fri, 28 Aug 2020 01:12:46 -0700
Received: from irv1user01.caveonetworks.com (unknown [10.104.116.179])
        by maili.marvell.com (Postfix) with ESMTP id 618493F703F;
        Fri, 28 Aug 2020 01:12:46 -0700 (PDT)
Received: from localhost (aeasi@localhost)
        by irv1user01.caveonetworks.com (8.14.4/8.14.4/Submit) with ESMTP id 07S8Cix7028428;
        Fri, 28 Aug 2020 01:12:44 -0700
X-Authentication-Warning: irv1user01.caveonetworks.com: aeasi owned process doing -bs
Date:   Fri, 28 Aug 2020 01:12:44 -0700
From:   Arun Easi <aeasi@marvell.com>
X-X-Sender: aeasi@irv1user01.caveonetworks.com
To:     Rene Rebe <rene@exactcode.com>
CC:     <linux-scsi@vger.kernel.org>,
        Himanshu Madhani <himanshu.madhani@oracle.com>,
        Bart Van Assche <bvanassche@acm.org>
Subject: Re: [PATCH v3] fix qla2xxx regression on sparc64
In-Reply-To: <20200827.222729.1875148247374704975.rene@exactcode.com>
Message-ID: <alpine.LRH.2.21.9999.2008280106500.31539@irv1user01.caveonetworks.com>
References: <20200827.222729.1875148247374704975.rene@exactcode.com>
User-Agent: Alpine 2.21.9999 (LRH 334 2019-03-29)
MIME-Version: 1.0
Content-Type: multipart/mixed;
        boundary="1745531764-457366854-1598602366=:31539"
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-08-28_05:2020-08-28,2020-08-28 signatures=0
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

--1745531764-457366854-1598602366=:31539
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT

On Thu, 27 Aug 2020, 1:27pm, Rene Rebe wrote:

> 
> Commit 98aee70d19a7e3203649fa2078464e4f402a0ad8 in 2014 broke qla2xxx
> on sparc64, e.g. as in the Sun Blade 1000 / 2000. Unbreak by partial
> revert to fix endianess in nvram firmware default initialization. Also
> mark the second frame_payload_size in nvram_t __le16 to avoid new
> sparse warnings.
> 
> Fixes: 98aee70d19a7e ("qla2xxx: Add endianizer to max_payload_size modifier.")
> Signed-off-by: René Rebe <rene@exactcode.de>
> 

Looks good. Other *nvram_config changes are already taken care by one of 
the recent fixes, this was the only one missing.

I was surprised that this really exception path (bad HBA nvram) was 
causing a regression; apparently this is not an exception path in this old 
machine.

Thanks Rene.

Regards,
-Arun
--1745531764-457366854-1598602366=:31539--
