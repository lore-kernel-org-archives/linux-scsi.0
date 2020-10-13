Return-Path: <SRS0=AAGU=DU=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F161FC43457
	for <linux-scsi@archiver.kernel.org>; Tue, 13 Oct 2020 23:19:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 84F0121D7B
	for <linux-scsi@archiver.kernel.org>; Tue, 13 Oct 2020 23:19:46 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="ZDYxu1Rr"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388685AbgJMXTn (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 13 Oct 2020 19:19:43 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:18494 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727344AbgJMXTm (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 13 Oct 2020 19:19:42 -0400
Received: from pps.filterd (m0098394.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 09DN3oTZ004355;
        Tue, 13 Oct 2020 19:19:33 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : subject :
 from : reply-to : to : date : in-reply-to : references : content-type :
 mime-version : content-transfer-encoding; s=pp1;
 bh=8A66wKI0TMK6r17n7LypUtMRYlFtZVsjNmDXnfqCUyA=;
 b=ZDYxu1RrxMW3eafWqtf2Gk/tJ3VokPlaA/f5PRkeIc/T4U8jBc6lB6YajrZOoeQ6+Eum
 AJ3eh0cbmY3yzpqredBoE966//QH3xf4vvRsrxKPjjXN4ENy8WHHRdf9+ISRZE3rkwIN
 3FCbc+ASlauzJmCcKMwMvxdh7Sy3BMtAP/dH7qxfYULdbmMsa9if/7ZL1tNYQKjoJkjx
 fQYJsnmGO7UmNJBNvfTNXqCsY7phCeZlvoaws5L71F8L5HKADx3lUZV4NFF8iN75JfBI
 OpmGjvzPUjg7lWEjn1vosgxwNAI7ua0lhbB1ccYGmpLKEgR5edKk61wukssLvEO2D03A QQ== 
Received: from ppma02dal.us.ibm.com (a.bd.3ea9.ip4.static.sl-reverse.com [169.62.189.10])
        by mx0a-001b2d01.pphosted.com with ESMTP id 345nbmrnd5-11
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 13 Oct 2020 19:19:32 -0400
Received: from pps.filterd (ppma02dal.us.ibm.com [127.0.0.1])
        by ppma02dal.us.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 09DN7qJb008779;
        Tue, 13 Oct 2020 23:08:13 GMT
Received: from b03cxnp07028.gho.boulder.ibm.com (b03cxnp07028.gho.boulder.ibm.com [9.17.130.15])
        by ppma02dal.us.ibm.com with ESMTP id 3434k9j95m-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 13 Oct 2020 23:08:13 +0000
Received: from b03ledav004.gho.boulder.ibm.com (b03ledav004.gho.boulder.ibm.com [9.17.130.235])
        by b03cxnp07028.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 09DN8Cpm46924058
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 13 Oct 2020 23:08:12 GMT
Received: from b03ledav004.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 5B9E27805F;
        Tue, 13 Oct 2020 23:08:12 +0000 (GMT)
Received: from b03ledav004.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id EFACC7805E;
        Tue, 13 Oct 2020 23:08:10 +0000 (GMT)
Received: from jarvis.int.hansenpartnership.com (unknown [9.85.148.2])
        by b03ledav004.gho.boulder.ibm.com (Postfix) with ESMTP;
        Tue, 13 Oct 2020 23:08:10 +0000 (GMT)
Message-ID: <95f493a39c2a6cc2f45da2f7fe73d7febee927df.camel@linux.ibm.com>
Subject: Re: general protection fault in scsi_queue_rq
From:   James Bottomley <jejb@linux.ibm.com>
Reply-To: jejb@linux.ibm.com
To:     syzbot <syzbot+0796b72dc61f223d8cc5@syzkaller.appspotmail.com>,
        hare@suse.de, hch@lst.de, linux-kernel@vger.kernel.org,
        linux-scsi@vger.kernel.org, martin.petersen@oracle.com,
        syzkaller-bugs@googlegroups.com
Date:   Tue, 13 Oct 2020 16:08:09 -0700
In-Reply-To: <00000000000047627e05b17a6ec9@google.com>
References: <00000000000047627e05b17a6ec9@google.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.34.4 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-10-13_16:2020-10-13,2020-10-13 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 adultscore=0 spamscore=0
 suspectscore=0 phishscore=0 mlxscore=0 priorityscore=1501 clxscore=1011
 lowpriorityscore=0 mlxlogscore=999 impostorscore=0 bulkscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2010130160
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Mon, 2020-10-12 at 07:51 -0700, syzbot wrote:
> Hello,
> 
> syzbot found the following issue on:
> 
> HEAD commit:    e4fb79c7 Add linux-next specific files for 20201008
> git tree:       linux-next
> console output: 
> https://syzkaller.appspot.com/x/log.txt?x=125c9a9f900000
> kernel config:  
> https://syzkaller.appspot.com/x/.config?x=568d41fe4341ed0f
> dashboard link: 
> https://syzkaller.appspot.com/bug?extid=0796b72dc61f223d8cc5
> compiler:       gcc (GCC) 10.1.0-syz 20200507
> syz repro:      
> https://syzkaller.appspot.com/x/repro.syz?x=12582fe7900000
> C reproducer:   
> https://syzkaller.appspot.com/x/repro.c?x=124ac7d0500000
> 
> The issue was bisected to:
> 
> commit 2ceda20f0a99a74a82b78870f3b3e5fa93087a7f
> Author: Christoph Hellwig <hch@lst.de>
> Date:   Mon Oct 5 08:41:23 2020 +0000
> 
>     scsi: core: Move command size detection out of the fast path

#syz: test git://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi.git scsi-misc


