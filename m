Return-Path: <SRS0=fhi0=3M=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.4 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5AE37C33CAA
	for <linux-scsi@archiver.kernel.org>; Thu, 23 Jan 2020 22:51:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 19D7E207FF
	for <linux-scsi@archiver.kernel.org>; Thu, 23 Jan 2020 22:51:08 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b="Z0rf6ib5"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729462AbgAWWvH (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 23 Jan 2020 17:51:07 -0500
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:29378 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729259AbgAWWvH (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 23 Jan 2020 17:51:07 -0500
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 00NMp3v7015837;
        Thu, 23 Jan 2020 14:51:03 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=date : from : to :
 cc : subject : in-reply-to : message-id : references : mime-version :
 content-type; s=pfpt0818; bh=F6N8YR+BC18PgNYYRH7SZFHm43suo4cBPPCWwK8uDqA=;
 b=Z0rf6ib5IX96f/zCLLQusqkVh1CabRWe2/CLepIZUm9XK5hXlN4hV2ptUj4jjMrMyUIb
 Arb4OJ+FCQmjjZo8fSZb+ls8HS7UVySbmtZ/wysYlsppROEGmcipeAz4XVQHDhqSRRkn
 bkkiZS5snqwcpmnVzBkBOKZhlgzLHKQZlCkJ4FCiShh5t02NafMjIZIdaLrr9Zz87qir
 jF73fBtQpv6a2+qkUkg5WJ2t/igIOHsNXiGwvg8guq80Ywt3NzvreRDHHIJXBg5TF//p
 rJtSrnTlnvXdAOXyupZGI1eE15323lULuVoWaINKrV9P8cah4K/F2S9Vwcjk+iQklMWK 4Q== 
Received: from sc-exch02.marvell.com ([199.233.58.182])
        by mx0b-0016f401.pphosted.com with ESMTP id 2xm2dtdy7w-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Thu, 23 Jan 2020 14:51:03 -0800
Received: from SC-EXCH01.marvell.com (10.93.176.81) by SC-EXCH02.marvell.com
 (10.93.176.82) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Thu, 23 Jan
 2020 14:51:01 -0800
Received: from maili.marvell.com (10.93.176.43) by SC-EXCH01.marvell.com
 (10.93.176.81) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Thu, 23 Jan 2020 14:51:01 -0800
Received: from irv1user01.caveonetworks.com (unknown [10.104.116.179])
        by maili.marvell.com (Postfix) with ESMTP id 826FF3F7040;
        Thu, 23 Jan 2020 14:51:01 -0800 (PST)
Received: from localhost (aeasi@localhost)
        by irv1user01.caveonetworks.com (8.14.4/8.14.4/Submit) with ESMTP id 00NMp1QR016991;
        Thu, 23 Jan 2020 14:51:01 -0800
X-Authentication-Warning: irv1user01.caveonetworks.com: aeasi owned process doing -bs
Date:   Thu, 23 Jan 2020 14:51:00 -0800
From:   Arun Easi <aeasi@marvell.com>
X-X-Sender: aeasi@irv1user01.caveonetworks.com
To:     "Martin K. Petersen" <martin.petersen@oracle.com>
CC:     "Elliott, Robert (Servers)" <elliott@hpe.com>,
        Himanshu Madhani <hmadhani@marvell.com>,
        "James.Bottomley@HansenPartnership.com" 
        <James.Bottomley@HansenPartnership.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
Subject: Re: [EXT] Re: [PATCH v4] qla2xxx: Fix unbound NVME response length
In-Reply-To: <yq1d0bbexkk.fsf@oracle.com>
Message-ID: <alpine.LRH.2.21.9999.2001231450240.15850@irv1user01.caveonetworks.com>
References: <20200121192710.32314-1-hmadhani@marvell.com>
 <DF4PR8401MB1241B973AEE70A60D1D08133AB0C0@DF4PR8401MB1241.NAMPRD84.PROD.OUTLOOK.COM>
 <alpine.LRH.2.21.9999.2001221611360.15850@irv1user01.caveonetworks.com>
 <yq1d0bbexkk.fsf@oracle.com>
User-Agent: Alpine 2.21.9999 (LRH 334 2019-03-29)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.572
 definitions=2020-01-23_13:2020-01-23,2020-01-23 signatures=0
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Wed, 22 Jan 2020, 6:06pm, Martin K. Petersen wrote:

> Arun,
> 
> > I can post a follow on patch, with the WARN/log message under driver 
> > debug.
> 
> Just send a v5. Thanks!
> 

Will do. Thanks Martin.

Regards,
-Arun
