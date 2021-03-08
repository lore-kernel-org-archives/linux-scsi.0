Return-Path: <SRS0=zduL=IG=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2DB2AC433E0
	for <linux-scsi@archiver.kernel.org>; Mon,  8 Mar 2021 04:28:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DBA896513A
	for <linux-scsi@archiver.kernel.org>; Mon,  8 Mar 2021 04:28:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234119AbhCHE2V (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 7 Mar 2021 23:28:21 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:38138 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232313AbhCHE14 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 7 Mar 2021 23:27:56 -0500
Received: from pps.filterd (m0098393.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 12843bxa133135;
        Sun, 7 Mar 2021 23:27:50 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : subject :
 from : reply-to : to : cc : date : in-reply-to : references : content-type
 : mime-version : content-transfer-encoding; s=pp1;
 bh=NP39ZWoz9Xd3g1UX+nyLKlZg2ptzC85JVgl8ySjGpMg=;
 b=Ls+2TA4BL20oss8ZT3APYSTJf4FJ3jY3G/J9/DG4mbYmIjWyyg8EgqDaYAXP4hZooZcU
 nKVwyrPL9U6oKqzKTthvUGM5gAJ0oEHL2F8UnWHJWgoFW0hI/N7NnvSKRlFLApBQo0Tq
 MohRR7rOXGDv/DcUDgWNvhh9seIt4CXqYs5676Qs48Ns/e1QeSzoPoxhYYPl+gtINBJ+
 76XcAxQZFjw5X5cy8LWw0+zhxH3W1SneDE0j2U6JHO1qzb1WGwOiZ6GAqEjteoQttDds
 5rUzlo19FXqRPeHGz1YXNi6F36vTVR6Y2stSXNMiWoz41jFwv63vXr4OgUOGfoTpebNq 3g== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3757ww5dpk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Sun, 07 Mar 2021 23:27:50 -0500
Received: from m0098393.ppops.net (m0098393.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 12843kaI133704;
        Sun, 7 Mar 2021 23:27:49 -0500
Received: from ppma05wdc.us.ibm.com (1b.90.2fa9.ip4.static.sl-reverse.com [169.47.144.27])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3757ww5dpc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Sun, 07 Mar 2021 23:27:49 -0500
Received: from pps.filterd (ppma05wdc.us.ibm.com [127.0.0.1])
        by ppma05wdc.us.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 1284MpYh023807;
        Mon, 8 Mar 2021 04:27:48 GMT
Received: from b03cxnp08025.gho.boulder.ibm.com (b03cxnp08025.gho.boulder.ibm.com [9.17.130.17])
        by ppma05wdc.us.ibm.com with ESMTP id 3741c93yx3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 08 Mar 2021 04:27:48 +0000
Received: from b03ledav004.gho.boulder.ibm.com (b03ledav004.gho.boulder.ibm.com [9.17.130.235])
        by b03cxnp08025.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 1284Rlka26411308
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 8 Mar 2021 04:27:47 GMT
Received: from b03ledav004.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 577327805C;
        Mon,  8 Mar 2021 04:27:47 +0000 (GMT)
Received: from b03ledav004.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id E057B78063;
        Mon,  8 Mar 2021 04:27:45 +0000 (GMT)
Received: from jarvis.int.hansenpartnership.com (unknown [9.80.211.242])
        by b03ledav004.gho.boulder.ibm.com (Postfix) with ESMTP;
        Mon,  8 Mar 2021 04:27:45 +0000 (GMT)
Message-ID: <2b90f003bbf8064c2372cba6a61b31cb8dec7a69.camel@linux.ibm.com>
Subject: Re: [PATCH] scsi: iscsi: Switch to using the new API kobj_to_dev()
From:   James Bottomley <jejb@linux.ibm.com>
Reply-To: jejb@linux.ibm.com
To:     Jiapeng Chong <jiapeng.chong@linux.alibaba.com>, lduncan@suse.com
Cc:     cleech@redhat.com, martin.petersen@oracle.com,
        open-iscsi@googlegroups.com, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date:   Sun, 07 Mar 2021 20:27:44 -0800
In-Reply-To: <1615174470-45135-1-git-send-email-jiapeng.chong@linux.alibaba.com>
References: <1615174470-45135-1-git-send-email-jiapeng.chong@linux.alibaba.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.34.4 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.369,18.0.761
 definitions=2021-03-08_01:2021-03-03,2021-03-08 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxlogscore=999 adultscore=0
 spamscore=0 clxscore=1011 priorityscore=1501 phishscore=0
 lowpriorityscore=0 bulkscore=0 suspectscore=0 mlxscore=0 malwarescore=0
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2103080018
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Mon, 2021-03-08 at 11:34 +0800, Jiapeng Chong wrote:
> Fix the following coccicheck warnings:
> 
> ./drivers/scsi/scsi_transport_iscsi.c:930:60-61: WARNING opportunity
> for kobj_to_dev().

I have to ask, what is the point of this?  container_of is usually
pretty safe ... as in it will detect when you screw up the usage.  The
only real misuse you can get is when the input type has an object of
the same name and return type and you got confused between two objects
with this property, but misuses like this resulting in bugs are very,
very rare.

Usually we wrap container_of because the wrapping is a bit shorter as
you can see: kobj_to_dev is about half the size of the container_of
form ... but is there any other reason to do it?

The problem is that container_of is a standard way of doing cast outs
in the kernel and we have hundreds of them.  To be precise, in scsi
alone:

jejb@jarvis:~/git/linux/drivers/scsi> git grep container_of|wc -l
496

So we really don't want to encourage wrapping them all because the
churn would be unbelievable and the gain minute.  So why should this
one case especially be wrapped when we don't want to wrap the others?

James


