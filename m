Return-Path: <SRS0=iUlB=7U=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_GIT autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1CE71C433E1
	for <linux-scsi@archiver.kernel.org>; Sun,  7 Jun 2020 20:36:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id ECA202074B
	for <linux-scsi@archiver.kernel.org>; Sun,  7 Jun 2020 20:36:18 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="VFlHUdqj"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727804AbgFGUgR (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 7 Jun 2020 16:36:17 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:51634 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727779AbgFGUgR (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 7 Jun 2020 16:36:17 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 057KWwRc125872;
        Sun, 7 Jun 2020 20:36:11 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id; s=corp-2020-01-29;
 bh=4PUeBeGfK3iwPJSDxtgfUQoB/Xujvg8+bqox1gdv1dg=;
 b=VFlHUdqj3QSMv0sa5v9MS+U6ikOePOYhnILPTf9tpH0hIh4Vwue7V2eQlmSHeT9FzM4O
 BXJgtvQ06bd1c1gxMucrDFrGDjzX2Wl+2dBxb102bccma8HQvwZ5d2u2T4+rHvhllJVS
 02l/y/BvharAVLen7E8pP/siYkk0XTlsjTC/s/E9WqhzQ14PE+iHYxrayxgjlQmcAVRv
 o1OdirJUi2WxPTSEmaqOCQ6Q6dX5VhqZ6+DdNWzRvuwUBK+r1j8BwijcRLFzBf6PD4D4
 xJz9zkVy62UPPjtODBR3HsDIkI/lqU94GGDKMktL8CH67caDUpqp9QbLRADdJ9qkt0EJ zA== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2120.oracle.com with ESMTP id 31g3smkxfn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Sun, 07 Jun 2020 20:36:11 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 057KSGwp057077;
        Sun, 7 Jun 2020 20:36:11 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userp3020.oracle.com with ESMTP id 31gmwnynm6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sun, 07 Jun 2020 20:36:11 +0000
Received: from abhmp0008.oracle.com (abhmp0008.oracle.com [141.146.116.14])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 057Ka9FP023937;
        Sun, 7 Jun 2020 20:36:09 GMT
Received: from ol2.localdomain (/73.88.28.6)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Sun, 07 Jun 2020 13:36:09 -0700
From:   Mike Christie <michael.christie@oracle.com>
To:     bvanassche@acm.org, bstroesser@ts.fujitsu.com,
        martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        target-devel@vger.kernel.org
Subject: [PATCH v6 00/17] target: add sysfs support
Date:   Sun,  7 Jun 2020 15:35:47 -0500
Message-Id: <1591562164-9766-1-git-send-email-michael.christie@oracle.com>
X-Mailer: git-send-email 1.8.3.1
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9645 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=2 spamscore=0 adultscore=0
 mlxscore=0 mlxlogscore=999 bulkscore=0 malwarescore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2004280000
 definitions=main-2006070161
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9645 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 priorityscore=1501
 lowpriorityscore=0 impostorscore=0 cotscore=-2147483648 suspectscore=2
 spamscore=0 bulkscore=0 malwarescore=0 phishscore=0 mlxscore=0
 mlxlogscore=999 clxscore=1011 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2004280000 definitions=main-2006070161
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

The following patches made over Martin's for-next branch allow lio to
export info about structs like the se_session that the kernel initiates
creation of via events like initiator login where there is no local user
interaction like a mkdir.

Why sysfs when we have configfs?

I started with configfs and hit bugs like:

commit cc57c07343bd071cdf1915a91a24ab7d40c9b590
Author: Mike Christie <mchristi@redhat.com>
Date:   Sun Jul 15 18:16:17 2018 -0500

    configfs: fix registered group removal

and it turns out that bug was not really a bug and was just how configfs
was meant to work. It seems it was not meant to be used where the kernel
initiates creation of dirs/files as a result of some internal action. It's
more geared to the user initiating the creation, and my patch just lead
to other bugs and was reverted:

commit f19e4ed1e1edbfa3c9ccb9fed17759b7d6db24c6
Author: Al Viro <viro@zeniv.linux.org.uk>
Date:   Thu Aug 29 23:13:30 2019 -0400

    configfs_register_group() shouldn't be (and isn't) called in
rmdirable parts




V5:
- In previous versions we went wild and used kobjects directly and
made dirs and symlinks like crazy. This version just uses the
standard struct class and device interfaces and standard naming.
- Added fabric specific driver session attrs example using the iscsi
target driver to make sure the interface will work for the
broadcom driver.

V4:
- Don't drop const char use in fabric drivers.
- add Documentation/ABI
- use initaitor port prefix instead of generic "session"
- only make session_id file if iSCSI format=1 is being used.

V3:
- drop format field
- delay tpg deletion to allow fabric modules time to remove their
  sessions.
- Added root sessions dir for easier lookup if userspace has the
  session id.
- add session symlink
- use simple ida.
- Fix goto use. Actually moved sysfs addition call to after nego
  to avoid sysfs additions when login ends up failing.
- Dropped target_setup_session callback fixups and dropped the
  init/free session callback for now. It's not immediately needed
  for this base session sysfs info support.

V2:
- rename top level dir to scsi_target
- Fix extra newline
- Copy data that's exported to sysfs so we do not have to worry about
configfs and sysfs refcounts.
- Export session info needed for tracking sessions in userspace and
handling commands like PGRs there (still needs a way to notify userspace
when sessions are added/deleted, but that will be a different set since
the focus is different).

