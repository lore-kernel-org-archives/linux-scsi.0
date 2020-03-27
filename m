Return-Path: <SRS0=+SnX=5M=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.4 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0E58EC43331
	for <linux-scsi@archiver.kernel.org>; Fri, 27 Mar 2020 17:57:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D8E8520714
	for <linux-scsi@archiver.kernel.org>; Fri, 27 Mar 2020 17:57:42 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b="aipLD54O"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727125AbgC0R5m (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 27 Mar 2020 13:57:42 -0400
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:22684 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726770AbgC0R5m (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 27 Mar 2020 13:57:42 -0400
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 02RHsho8022676;
        Fri, 27 Mar 2020 10:57:39 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=date : from : to :
 cc : subject : in-reply-to : message-id : references : mime-version :
 content-type; s=pfpt0818; bh=aP0hdURuNiCq721uoVPQfCzmJYvlMPW5b5MENKqoA68=;
 b=aipLD54OhVBZ+sQCRAEmaOCJVR+dby68oeW4ctuL7O54GRrUWCBY6JZGyuNeMbECPGJH
 B9e63ISI+UajnGga4UaUcJKPJUHJkMklE6LdDycG1HFx98XuT0atxul4UBIzJxH+OYjx
 JAI7K9f6rnwOjJPBXMVLOyAZrXudOIy/cNzrzq6Gk1jltHL3Djx57sb4nRmmZKR5riWx
 LV1dvUdoEP53u3vqMoTRGPAqpS02q1kz3V8H/2pZFQeR8C0GuTUvuyAcH5u6+qVubG11
 prVQG9lHQeSWaYSHSWbtHjM+fR4NiKf4Is/SugMHK4BZbcdEXxwfMTJxSM5L1s27EQvD Ng== 
Received: from sc-exch02.marvell.com ([199.233.58.182])
        by mx0a-0016f401.pphosted.com with ESMTP id 2ywg9p3xpn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Fri, 27 Mar 2020 10:57:39 -0700
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by SC-EXCH02.marvell.com
 (10.93.176.82) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Fri, 27 Mar
 2020 10:57:38 -0700
Received: from SC-EXCH01.marvell.com (10.93.176.81) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Fri, 27 Mar
 2020 10:57:37 -0700
Received: from maili.marvell.com (10.93.176.43) by SC-EXCH01.marvell.com
 (10.93.176.81) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Fri, 27 Mar 2020 10:57:37 -0700
Received: from irv1user01.caveonetworks.com (unknown [10.104.116.179])
        by maili.marvell.com (Postfix) with ESMTP id 4B5313F703F;
        Fri, 27 Mar 2020 10:57:37 -0700 (PDT)
Received: from localhost (aeasi@localhost)
        by irv1user01.caveonetworks.com (8.14.4/8.14.4/Submit) with ESMTP id 02RHvaXL029579;
        Fri, 27 Mar 2020 10:57:36 -0700
X-Authentication-Warning: irv1user01.caveonetworks.com: aeasi owned process doing -bs
Date:   Fri, 27 Mar 2020 10:57:36 -0700
From:   Arun Easi <aeasi@marvell.com>
X-X-Sender: aeasi@irv1user01.caveonetworks.com
To:     "Martin K. Petersen" <martin.petersen@oracle.com>
CC:     Quinn Tran <qutran@marvell.com>,
        "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>,
        <linux-scsi@vger.kernel.org>, Bart Van Assche <bvanassche@acm.org>
Subject: Re: [EXT] Re: [PATCH v3 0/6] Fix qla2xxx endianness annotations
In-Reply-To: <yq17dz6ed94.fsf@oracle.com>
Message-ID: <alpine.LRH.2.21.9999.2003271054190.12727@irv1user01.caveonetworks.com>
References: <20200305045431.30061-1-bvanassche@acm.org>
 <yq17dz6ed94.fsf@oracle.com>
User-Agent: Alpine 2.21.9999 (LRH 334 2019-03-29)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.645
 definitions=2020-03-27_06:2020-03-27,2020-03-27 signatures=0
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Thu, 26 Mar 2020, 7:35pm, Martin K. Petersen wrote:

>
> Arun, Quinn: This series still needs review.
> 
> Thanks!

Hi Martin,

Yes, we will provide a review. As this is a big change, we would need some 
more time for the review and testing.

I had some early thoughts on the series, I will take another look at it 
and respond.

Regards,
-Arun

> 
> > This patch series fixes the endianness annotations in the qla2xxx
> > driver.  Please consider this patch series for the v5.7 kernel.
> >
> > Thanks,
> >
> > Bart.
> >
> > Changes compared to v2:
> > - Removed one BUILD_BUG_ON() statement.
> >
> > Changes compared to v1:
> > - Left out the raw_smp_processor_id() patch because it may take time to achieve
> >   agreement about this patch.
> > - Added three patches to this series: two patches for verifying structure size
> >   at compile time and one patch for changing function names from upper case to
> >   lower case.
> >
> > Bart Van Assche (6):
> >   qla2xxx: Sort BUILD_BUG_ON() statements alphabetically
> >   qla2xxx: Add more BUILD_BUG_ON() statements
> >   qla2xxx: Fix endianness annotations in header files
> >   qla2xxx: Fix endianness annotations in source files
> >   qla2xxx: Fix the code that reads from mailbox registers
> >   qla2xxx: Change {RD,WRT}_REG_*() function names from upper case into
> >     lower case
> >
> >  drivers/scsi/qla2xxx/qla_attr.c    |   3 +-
> >  drivers/scsi/qla2xxx/qla_bsg.c     |   4 +-
> >  drivers/scsi/qla2xxx/qla_dbg.c     | 672 +++++++++++++-------------
> >  drivers/scsi/qla2xxx/qla_dbg.h     | 442 ++++++++---------
> >  drivers/scsi/qla2xxx/qla_def.h     | 711 ++++++++++++++-------------
> >  drivers/scsi/qla2xxx/qla_fw.h      | 738 ++++++++++++++---------------
> >  drivers/scsi/qla2xxx/qla_init.c    | 279 +++++------
> >  drivers/scsi/qla2xxx/qla_inline.h  |   8 +-
> >  drivers/scsi/qla2xxx/qla_iocb.c    | 121 ++---
> >  drivers/scsi/qla2xxx/qla_isr.c     | 217 +++++----
> >  drivers/scsi/qla2xxx/qla_mbx.c     | 111 +++--
> >  drivers/scsi/qla2xxx/qla_mr.c      | 111 +++--
> >  drivers/scsi/qla2xxx/qla_mr.h      |  32 +-
> >  drivers/scsi/qla2xxx/qla_nvme.c    |  12 +-
> >  drivers/scsi/qla2xxx/qla_nvme.h    |  46 +-
> >  drivers/scsi/qla2xxx/qla_nx.c      | 161 +++----
> >  drivers/scsi/qla2xxx/qla_nx.h      |  36 +-
> >  drivers/scsi/qla2xxx/qla_nx2.c     |  12 +-
> >  drivers/scsi/qla2xxx/qla_os.c      | 128 +++--
> >  drivers/scsi/qla2xxx/qla_sup.c     | 345 +++++++-------
> >  drivers/scsi/qla2xxx/qla_target.c  |  84 ++--
> >  drivers/scsi/qla2xxx/qla_target.h  | 208 ++++----
> >  drivers/scsi/qla2xxx/qla_tmpl.c    |  12 +-
> >  drivers/scsi/qla2xxx/tcm_qla2xxx.c |  14 +
> >  24 files changed, 2317 insertions(+), 2190 deletions(-)
> 
> 
