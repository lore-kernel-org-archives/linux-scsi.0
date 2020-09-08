Return-Path: <SRS0=d5MZ=CR=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.4 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 56378C43461
	for <linux-scsi@archiver.kernel.org>; Tue,  8 Sep 2020 06:58:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 19EC221973
	for <linux-scsi@archiver.kernel.org>; Tue,  8 Sep 2020 06:58:55 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b="SRN3KVOm"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729158AbgIHG6w (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 8 Sep 2020 02:58:52 -0400
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:44084 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728922AbgIHG6u (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 8 Sep 2020 02:58:50 -0400
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0886t7rI030774;
        Mon, 7 Sep 2020 23:58:46 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=date : from : to :
 cc : subject : in-reply-to : message-id : references : mime-version :
 content-type; s=pfpt0220; bh=R1oTpZmA2x3Yv8mOLp6sTtbJd7UKNZAzMbXgw9yuxdM=;
 b=SRN3KVOmoi9x0Za0/okEf6n1iuJ5VqqDsQfffgOKQxh8k+U7pfh7yhldMGE3o7oanGea
 PKUqwlg6MaEyuZuuB3yAGDTPzIgESSsJe2LvDjKySmseolNC62sMj7/Zen61hoiz96EJ
 OoiUBYtQiJcuIyok2Q5xa6DmE3/o6hfVulEsgaUFj7W3M2WJ6Lf+rrDCxDJeUsiypU0N
 n8ANx7UsQ2h+4CCnWLu1uE2sl3v8JR33v+9ape2uNnEv9ULvmVs0upgHtxlJXai5YTe7
 pmdMUjtljCmAS0UGBce4IprbvPhIHbsDbPRjr8Zwnyd7nr3VrmFH+IfbPia7bScFR0Oo lQ== 
Received: from sc-exch02.marvell.com ([199.233.58.182])
        by mx0a-0016f401.pphosted.com with ESMTP id 33c81pth25-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Mon, 07 Sep 2020 23:58:46 -0700
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by SC-EXCH02.marvell.com
 (10.93.176.82) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Mon, 7 Sep
 2020 23:58:46 -0700
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Mon, 7 Sep
 2020 23:58:45 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Mon, 7 Sep 2020 23:58:45 -0700
Received: from irv1user01.caveonetworks.com (unknown [10.104.116.179])
        by maili.marvell.com (Postfix) with ESMTP id CF1BA3F7043;
        Mon,  7 Sep 2020 23:58:44 -0700 (PDT)
Received: from localhost (aeasi@localhost)
        by irv1user01.caveonetworks.com (8.14.4/8.14.4/Submit) with ESMTP id 0886whxf004299;
        Mon, 7 Sep 2020 23:58:43 -0700
X-Authentication-Warning: irv1user01.caveonetworks.com: aeasi owned process doing -bs
Date:   Mon, 7 Sep 2020 23:58:43 -0700
From:   Arun Easi <aeasi@marvell.com>
X-X-Sender: aeasi@irv1user01.caveonetworks.com
To:     "Martin K. Petersen" <martin.petersen@oracle.com>
CC:     Lukas Bulwahn <lukas.bulwahn@gmail.com>,
        Roman Bolshakov <r.bolshakov@yadro.com>,
        "James E . J . Bottomley" <jejb@linux.ibm.com>,
        <linux-scsi@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sudarsana Kalluru <sudarsana.kalluru@qlogic.com>,
        <linux-spdx@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <GR-QLogic-Storage-Upstream@marvell.com>
Subject: Re: [EXT] Re: [PATCH] MAINTAINERS: orphan sections with qlogic.com
 group alias
In-Reply-To: <yq1h7smkcqc.fsf@ca-mkp.ca.oracle.com>
Message-ID: <alpine.LRH.2.21.9999.2009072352300.28578@irv1user01.caveonetworks.com>
References: <20200828070824.8032-1-lukas.bulwahn@gmail.com>
 <20200828091758.GF54274@SPB-NB-133.local>
 <alpine.DEB.2.21.2008281524360.11562@felia>
 <yq1h7smkcqc.fsf@ca-mkp.ca.oracle.com>
User-Agent: Alpine 2.21.9999 (LRH 334 2019-03-29)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-09-08_02:2020-09-08,2020-09-08 signatures=0
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Fri, 28 Aug 2020, 8:39am, Martin K. Petersen wrote:

> 
> Lukas,
> 
> > So, if these drivers are not orphans, you can answer Thomas Gleixner's
> > original email from 2019. If you can quickly ack that patch set, I am
> > happy to do the donkey work to get this apply nicely on the current
> > master (please CC me on that response).
> 
> This is the first I hear of this since the patches weren't CC:ed to
> linux-scsi. And not all of these changes pertain to storage drivers but
> to networking so I am also not sure that mails sent to the above Storage
> alias would have ended up in the right place.
> 
> But we'll get this fixed up. Reaching out to our contacts at Marvell.
> 

Just to keep this thread updated, we are checking with the legal before 
ack-ing the change on spdx. Nilesh has already updated Thomas G. about 
this on the orignal spdx thread.

Regards,
-Arun
PS: Thanks Roman for the CC. These days our spam filters are a little
    unfriendly towards the linux-* e-mails.
