Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.2 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 03D33C433C1
	for <linux-scsi@archiver.kernel.org>; Fri, 26 Mar 2021 00:54:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A797261A0D
	for <linux-scsi@archiver.kernel.org>; Fri, 26 Mar 2021 00:54:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229898AbhCZAxf (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 25 Mar 2021 20:53:35 -0400
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:21968 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S229847AbhCZAxH (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 25 Mar 2021 20:53:07 -0400
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 12Q0eGIk002241
        for <linux-scsi@vger.kernel.org>; Thu, 25 Mar 2021 17:53:07 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=date : from : to :
 cc : subject : in-reply-to : message-id : references : mime-version :
 content-type; s=pfpt0220; bh=HRYTNNesnXZVUEDlysh6uo8lsKlzUcKreoLMW1+kbyI=;
 b=NBtKDtV6sKRsJYKhHIH3RaIqtSKJ6ZxjQGNvDG2xQ9WSaJimYNx0xqLRgMvCFD5hBAoL
 g/R5hz6iBWkdrvG0YclqBb1e9S+Fq1Qb6UKUK/aUm06H1yJdMS7c0C7HQIpA/KqXOweF
 yOYBeJ5J4qkLSay5ftmJwiLoGNZ5KBqzisltBSt854viDkcAHzly+kkYRZT9KfMSDnbt
 ip4PhlO8SgoIz33B8h1HuIFmRIhpwdRY3tHnxYVzBpQYvsrvSUyqA1WD57jRgMI34p9d
 MSyqS9igX+4n5B13bK/48KvM2U0FMCsPpalEyDkbMZsvem/95BtXGZ/CwLY3dHrQvVqW wQ== 
Received: from dc5-exch02.marvell.com ([199.233.59.182])
        by mx0a-0016f401.pphosted.com with ESMTP id 37h11jgpw0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT)
        for <linux-scsi@vger.kernel.org>; Thu, 25 Mar 2021 17:53:07 -0700
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Thu, 25 Mar
 2021 17:52:13 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Thu, 25 Mar 2021 17:52:13 -0700
Received: from irv1user01.caveonetworks.com (unknown [10.104.116.179])
        by maili.marvell.com (Postfix) with ESMTP id AFA863F703F;
        Thu, 25 Mar 2021 17:53:05 -0700 (PDT)
Received: from localhost (aeasi@localhost)
        by irv1user01.caveonetworks.com (8.14.4/8.14.4/Submit) with ESMTP id 12Q0r5GV002492;
        Thu, 25 Mar 2021 17:53:05 -0700
X-Authentication-Warning: irv1user01.caveonetworks.com: aeasi owned process doing -bs
Date:   Thu, 25 Mar 2021 17:53:05 -0700
From:   Arun Easi <aeasi@marvell.com>
X-X-Sender: aeasi@irv1user01.caveonetworks.com
To:     Himanshu Madhani <himanshu.madhani@oracle.com>
CC:     Nilesh Javali <njavali@marvell.com>,
        Martin Petersen <martin.petersen@oracle.com>,
        linux-scsi <linux-scsi@vger.kernel.org>,
        "GR-QLogic-Storage-Upstream@marvell.com" 
        <GR-QLogic-Storage-Upstream@marvell.com>
Subject: Re: [PATCH 01/11] qla2xxx: Fix IOPS drop seen in some adapters
In-Reply-To: <A1070793-F934-4ECD-8A3F-1DC351595F5E@oracle.com>
Message-ID: <alpine.LRH.2.21.9999.2103251749440.13940@irv1user01.caveonetworks.com>
References: <20210323044257.26664-1-njavali@marvell.com>
 <20210323044257.26664-2-njavali@marvell.com>
 <A1070793-F934-4ECD-8A3F-1DC351595F5E@oracle.com>
User-Agent: Alpine 2.21.9999 (LRH 334 2019-03-29)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
X-Proofpoint-GUID: TRpegCzP5qnj0rUXHatdkrA5YpyjJRAO
X-Proofpoint-ORIG-GUID: TRpegCzP5qnj0rUXHatdkrA5YpyjJRAO
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.369,18.0.761
 definitions=2021-03-25_10:2021-03-25,2021-03-25 signatures=0
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Himanshu,

Thanks for the review. Comments inline..

On Wed, 24 Mar 2021, 8:46am, Himanshu Madhani wrote:

> 
> 
> > On Mar 22, 2021, at 11:42 PM, Nilesh Javali <njavali@marvell.com> wrote:
> > 
> > From: Arun Easi <aeasi@marvell.com>
> > 
> > Removing the response queue processing in the send path is showing IOPS
> > drop. Add back the process_response_queue() call in the send path.
> > 
> 
> Can you share some details of what effect this change made into IOPS? 
> 

I do not remember off the top of my head, I think a few K. I dont have the 
perf setup anymore. Would you still prefer a re-spin of this patch?

Regards,
-Arun
