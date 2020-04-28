Return-Path: <SRS0=LQeo=6M=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EA6BBC83000
	for <linux-scsi@archiver.kernel.org>; Tue, 28 Apr 2020 06:11:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C3644206D7
	for <linux-scsi@archiver.kernel.org>; Tue, 28 Apr 2020 06:11:19 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="cjHDvHPe"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726285AbgD1GLT (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 28 Apr 2020 02:11:19 -0400
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:20231 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726333AbgD1GLS (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 28 Apr 2020 02:11:18 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1588054277;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=LnQz2ZWcsGPQ8AtEk1u4P2rsisz1ZvWQ7ZOagv78dQI=;
        b=cjHDvHPe8JQvjiCpH9GflPqIk5IPqEQ/AlcRfL/yj88A3EqxAOQEPDaN86txOCO4pMym0L
        EatBgciejLMMPp98xlkyTlfpv9nu+G4KKZKAAhM+ftwRQnG/FGAStRho9sKVmekINVVt8V
        jkyYgWpQjijOV3prY4M3a2bN5Zi4Jvc=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-115-XnTTC7IlOUerR-9p6-CiHw-1; Tue, 28 Apr 2020 02:11:14 -0400
X-MC-Unique: XnTTC7IlOUerR-9p6-CiHw-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 4C8201005510;
        Tue, 28 Apr 2020 06:11:13 +0000 (UTC)
Received: from rh2.redhat.com (ovpn-116-120.rdu2.redhat.com [10.10.116.120])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 3C9D110001B2;
        Tue, 28 Apr 2020 06:11:12 +0000 (UTC)
From:   Mike Christie <mchristi@redhat.com>
To:     bvanassche@acm.org, bstroesser@ts.fujitsu.com,
        martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        target-devel@vger.kernel.org
Subject: [PATCH 00/11] target: add sysfs support
Date:   Tue, 28 Apr 2020 01:10:58 -0500
Message-Id: <20200428061109.3042-1-mchristi@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Content-Transfer-Encoding: quoted-printable
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

The following patches made over Linus's current tree allow lio to
export info about structs that the kernel initiates creation of
via events like initiator login where there is no user interaction
like a mkdir. These patches specificially focus on the
I_T_nexus/session but could be used for other objects if we want.

Why sysfs when we have configfs?

I started with configfs and hit bugs like:

commit cc57c07343bd071cdf1915a91a24ab7d40c9b590
Author: Mike Christie <mchristi@redhat.com>
Date:   Sun Jul 15 18:16:17 2018 -0500

    configfs: fix registered group removal

but it turns out that bug was not really a bug and was just how
configfs was meant to work. It seems it was not meant to be used
where the kernel initiates creation of dirs/files as a result of
some internal action. It's more geared to the user initiating
the creation, and my patch just lead to other bugs and was
reverted:

commit f19e4ed1e1edbfa3c9ccb9fed17759b7d6db24c6
Author: Al Viro <viro@zeniv.linux.org.uk>
Date:   Thu Aug 29 23:13:30 2019 -0400

    configfs_register_group() shouldn't be (and isn't) called in
rmdirable parts

So to export the session info we have debugfs, sysfs, ioctl,
netlink, etc. sysfs just seemed like a decent fit since one of the
primary users is rtslib and it already has lots of file/dir
handling code.

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


