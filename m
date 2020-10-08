Return-Path: <SRS0=XwCY=DP=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.9 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4E74DC433DF
	for <linux-scsi@archiver.kernel.org>; Thu,  8 Oct 2020 20:50:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E57F921D6C
	for <linux-scsi@archiver.kernel.org>; Thu,  8 Oct 2020 20:50:16 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="lr4ilGRc"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726858AbgJHUuN (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 8 Oct 2020 16:50:13 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:54898 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726692AbgJHUuN (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 8 Oct 2020 16:50:13 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 098Ke1Qi152494;
        Thu, 8 Oct 2020 20:49:39 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : mime-version :
 content-type; s=corp-2020-01-29;
 bh=9QPpECvTRhPLXtDdl1S5Iws60RZ3bVfVQJEgRwWMouY=;
 b=lr4ilGRc8i4R0TO1OtZi392Hm+pUvuGtxxmhrzgEfRoaOlsXeyLUhYCvgt/l16+QMpMs
 VN/RfYy8EO2s9TIJ/ReBmWxvMse5IKYtauD7DvXibtvZ2AcTs84Ix0PhBSqMt8LhvEbL
 uO5PKSlo8f+Cc4kG3VsqYzPJj952f8ql4wBsTNJHC1/ojW1Bvi5HBDlrtlhMP7EbQW8I
 sgu+R0mQ3Azm82DZ/7jFtl6KejvYGyENpIMfuORn0xrTyZ1JDBOBTWdZWLiW3++SwoYJ
 W1DeMCykAg4Lh18mPIipPbwU36nyXu/yJVZo0MGqPKYZEpsAzrsl+CCoIKQ+xnESG1ma /g== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by aserp2120.oracle.com with ESMTP id 3429jur6p0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Thu, 08 Oct 2020 20:49:38 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 098KjNN5132770;
        Thu, 8 Oct 2020 20:49:38 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3030.oracle.com with ESMTP id 3429kk0yrj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 08 Oct 2020 20:49:38 +0000
Received: from abhmp0019.oracle.com (abhmp0019.oracle.com [141.146.116.25])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 098KnL8r024666;
        Thu, 8 Oct 2020 20:49:21 GMT
Received: from ca-mkp.ca.oracle.com (/10.159.214.123)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 08 Oct 2020 13:49:20 -0700
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Tony Asleson <tasleson@redhat.com>,
        Christoph Hellwig <hch@infradead.org>,
        linux-scsi@vger.kernel.org, linux-block@vger.kernel.org,
        linux-ide@vger.kernel.org, Hannes Reinecke <hare@suse.de>,
        pmladek@suse.com, David Lehman <dlehman@redhat.com>,
        sergey.senozhatsky@gmail.com, jbaron@akamai.com,
        James.Bottomley@hansenpartnership.com,
        linux-kernel@vger.kernel.org, rafael@kernel.org,
        martin.petersen@oracle.com, kbusch@kernel.org, axboe@fb.com,
        sagi@grimberg.me, akpm@linux-foundation.org, orson.zhai@unisoc.com,
        viro@zeniv.linux.org.uk
Subject: Re: [v5 01/12] struct device: Add function callback durable_name
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq1tuv41m8u.fsf@ca-mkp.ca.oracle.com>
References: <20200925161929.1136806-1-tasleson@redhat.com>
        <20200925161929.1136806-2-tasleson@redhat.com>
        <20200929175102.GA1613@infradead.org>
        <20200929180415.GA1400445@kroah.com>
        <20e220a6-4bde-2331-6e5e-24de39f9aa3b@redhat.com>
        <20200930073859.GA1509708@kroah.com>
        <c6b031b8-f617-0580-52a5-26532da4ee03@redhat.com>
        <20201001114832.GC2368232@kroah.com>
        <72be0597-a3e2-bf7b-90b2-799d10fdf56c@redhat.com>
        <20201008044849.GA163423@kroah.com>
Date:   Thu, 08 Oct 2020 16:49:17 -0400
In-Reply-To: <20201008044849.GA163423@kroah.com> (Greg Kroah-Hartman's message
        of "Thu, 8 Oct 2020 06:48:49 +0200")
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9768 signatures=668681
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=1 mlxlogscore=934
 spamscore=0 adultscore=0 mlxscore=0 malwarescore=0 phishscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2010080147
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9768 signatures=668681
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 mlxlogscore=929 mlxscore=0
 phishscore=0 bulkscore=0 suspectscore=1 lowpriorityscore=0 spamscore=0
 clxscore=1011 malwarescore=0 priorityscore=1501 impostorscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2010080146
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Greg,

>> > What text is changing? The format of of the prefix of dev_*() is well
>> > known and has been stable for 15+ years now, right?  What is difficult
>> > in parsing it?
>> 
>> Many of the storage layer messages are using printk, not dev_printk.
>
> Ok, then stop right there.  Fix that up.  Don't try to route around the
> standard way of displaying log messages by creating a totally different
> way of doing things.

Couldn't agree more!

-- 
Martin K. Petersen	Oracle Linux Engineering
