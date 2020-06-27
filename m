Return-Path: <SRS0=t7w2=AI=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_GIT autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3D07DC433DF
	for <linux-scsi@archiver.kernel.org>; Sat, 27 Jun 2020 04:37:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1C28720857
	for <linux-scsi@archiver.kernel.org>; Sat, 27 Jun 2020 04:37:25 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="u/4b3mhS"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725948AbgF0EhY (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 27 Jun 2020 00:37:24 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:60032 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725797AbgF0EhY (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 27 Jun 2020 00:37:24 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 05R4X21h078462;
        Sat, 27 Jun 2020 04:37:15 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id; s=corp-2020-01-29;
 bh=9BIv/Cpi1aUWEgR/P93x5VT8gzYRCKQy7bmS7pcrJoY=;
 b=u/4b3mhS8hAhMrfj2rbO8xcyNo5bAr8hyTqJiTUPUMXvJ/YcsOiftSAHrmnEfGfUgQhb
 ov9VlRRzNl9gHziNOI75JKhMrnQttU96BZaoKJ+T9TrrCDUEO1lpj6mAzxPll4YG+NZl
 P5n4AcDaD4zmu+qnBCZ7KFFIWx7nczXY5IfH2r06T2azy69pniYEXYnkAYxf1ZegyzML
 ADmajaIk5eoZrWV/Kz1ey9Dt3uP1HJuOwxPnp6ysL6dF4+MacTHrZACGl1mvwrjhmJox
 +N84ufE4o2RqNmi/xcQWJbaPrKtyDDhjCYKFBw4H3oiNbn0feP1/oKheEG15pQYAtx9X 2Q== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2120.oracle.com with ESMTP id 31wxrmr10s-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Sat, 27 Jun 2020 04:37:15 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 05R4Y9ZF122007;
        Sat, 27 Jun 2020 04:35:14 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3030.oracle.com with ESMTP id 31wv58v89h-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 27 Jun 2020 04:35:14 +0000
Received: from abhmp0014.oracle.com (abhmp0014.oracle.com [141.146.116.20])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 05R4ZBM7030581;
        Sat, 27 Jun 2020 04:35:11 GMT
Received: from ol2.localdomain (/73.88.28.6)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Sat, 27 Jun 2020 04:35:10 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     hare@suse.de, bvanassche@acm.org, bstroesser@ts.fujitsu.com,
        martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        target-devel@vger.kernel.org
Subject: [RFC PATCH 00/10] target: add configfs interface
Date:   Fri, 26 Jun 2020 23:34:59 -0500
Message-Id: <1593232509-13720-1-git-send-email-michael.christie@oracle.com>
X-Mailer: git-send-email 1.8.3.1
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9664 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 suspectscore=0 bulkscore=0
 mlxscore=0 mlxlogscore=999 malwarescore=0 spamscore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2004280000
 definitions=main-2006270030
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9664 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 mlxlogscore=999
 priorityscore=1501 impostorscore=0 bulkscore=0 clxscore=1015
 malwarescore=0 phishscore=0 adultscore=0 cotscore=-2147483648
 lowpriorityscore=0 suspectscore=0 spamscore=0 classifier=spam adjust=0
 reason=mlx scancount=1 engine=8.12.0-2004280000
 definitions=main-2006270030
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

The following patches made over linus's current tree (also apply
over Martin's 5.9 scsi queue branch) add a configfs interface to
export LIO's sessions.

With Hannes not liking the refcounting/tricks in the sysfs approach
I took another stab at configfs. This approach works similar to the
loop/vhost/usb/xen nexus interface where there is a special file
that allows userspace to add/remove sessions.

Because the kernel is making sessions for most drivers, we do not
have mkdir/rmdir support for the session dir, but using the special
file approach we can still remove children session in the correct
order and avoid the issues I hit before. The interface is a little
odd configfs wise because we use the special file, but it has the
benefit everything is in the one interface so it's easy to update
the tools.

If this approach is preferred over the sysfs one then I can repost
with some other fixes, the transport id patches and the iscsi
conversion one.


