Return-Path: <SRS0=HoCN=7I=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 59AB3C433E0
	for <linux-scsi@archiver.kernel.org>; Tue, 26 May 2020 12:29:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 379572088E
	for <linux-scsi@archiver.kernel.org>; Tue, 26 May 2020 12:29:12 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="srv5/tS5"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731577AbgEZM3J (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 26 May 2020 08:29:09 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:51258 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731488AbgEZM3J (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 26 May 2020 08:29:09 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 04QCLYV7077972;
        Tue, 26 May 2020 12:29:03 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=JueZGH4jRyV/FbA7prhvrV2KXyPZ+erywDSfRyAqt/s=;
 b=srv5/tS5UrVkWeig9LYApeK/xwASJntbgqp5M/Af8Ze1vVV15/efKf+BE3NRUKenT8a6
 oupjHM7lMXtKkZYmoP1PjoLJSKMhMtyeZXLDvZ0hU7EM8yp4evvqdXkjkO2dVY/0/rrB
 7zRpUVS0lLjxG0Vm8eTlWRwsL69W6if+NJXg6AXv6pHC6kNX2JOdDso3x6nxpF7GWaZL
 bE2TdsOOFq28wJHnunEG8R+4/MUWXY0s6sBgOKf7GLAAR+HP1syap9rQWb3qLHucAB5S
 FCh1HPyXLevCPQG8M+if31dKpt+Q/oOfC7danR8s2tTULos9JMG/BgBGHSB5h6+DnYVn WQ== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2130.oracle.com with ESMTP id 316u8qscb7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Tue, 26 May 2020 12:29:03 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 04QCIwcG181230;
        Tue, 26 May 2020 12:27:02 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3030.oracle.com with ESMTP id 317ddnsngu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 26 May 2020 12:27:02 +0000
Received: from abhmp0020.oracle.com (abhmp0020.oracle.com [141.146.116.26])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 04QCR14d007013;
        Tue, 26 May 2020 12:27:01 GMT
Received: from kadam (/41.57.98.10)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 26 May 2020 05:27:00 -0700
Date:   Tue, 26 May 2020 15:26:45 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     Bodo Stroesser <bstroesser@ts.fujitsu.com>
Cc:     "Martin K. Petersen" <martin.petersen@oracle.com>,
        Mike Christie <mchristi@redhat.com>,
        linux-scsi@vger.kernel.org, target-devel@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Subject: Re: [PATCH] scsi: target: tcmu: Fix a use after free in
 tcmu_check_expired_queue_cmd()
Message-ID: <20200526122645.GG22511@kadam>
References: <20200523101129.GB98132@mwanda>
 <68d6b1e9-65fa-e91c-e55e-f520839b5efe@ts.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <68d6b1e9-65fa-e91c-e55e-f520839b5efe@ts.fujitsu.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9632 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 bulkscore=0 mlxscore=0
 phishscore=0 adultscore=0 suspectscore=2 spamscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2004280000
 definitions=main-2005260094
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9632 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 mlxscore=0
 priorityscore=1501 spamscore=0 cotscore=-2147483648 suspectscore=2
 phishscore=0 clxscore=1015 mlxlogscore=999 bulkscore=0 adultscore=0
 lowpriorityscore=0 impostorscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2004280000 definitions=main-2005260094
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Mon, May 25, 2020 at 11:11:38AM +0200, Bodo Stroesser wrote:
> On 05/23/20 12:11, Dan Carpenter wrote:
> > The pr_debug() dereferences "cmd" after we already freed it by calling
> > tcmu_free_cmd(cmd).  The debug printk needs to be done earlier.
> > 
> > Fixes: 61fb24822166 ("scsi: target: tcmu: Userspace must not complete queued commands")
> > Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
> > ---
> >   drivers/target/target_core_user.c | 6 +++---
> >   1 file changed, 3 insertions(+), 3 deletions(-)
> > 
> 
> Thank you.
> 
> I'm very sorry for this stupid bug.

Bugs like this are super common.  Part of being human.  It would have
been hard to discover via testing because you have disable memory
poisoning on free and debugging at the same time.

regards,
dan carpenter

