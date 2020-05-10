Return-Path: <SRS0=m8SI=6Y=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5F488C38A2A
	for <linux-scsi@archiver.kernel.org>; Sun, 10 May 2020 21:57:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 343AA20801
	for <linux-scsi@archiver.kernel.org>; Sun, 10 May 2020 21:57:54 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="If6iRWzV"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729401AbgEJV5y (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 10 May 2020 17:57:54 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:26310 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727771AbgEJV5x (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 10 May 2020 17:57:53 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1589147872;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=d9rX/zfDWHGn5HkavCodZaas52U6Kq+3RTu4U00tsvw=;
        b=If6iRWzVGR4He/kDshQJ5nd5J6Gn4zpvVt8hzlcQhg167L815imIffX1MjrDSUhmdNU/NG
        r9L7VT3lNm+6iAjhNxAZUSOU+cOARyX5vIKgLqjMN1TmHn+oLjdSBtMlDx/2+t8koc1aXv
        FVPLdXI82TYO4VAfe3IfuBVZkLeINwk=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-432-CZ7KVWy9OZ6FQIRhuR6tfQ-1; Sun, 10 May 2020 17:57:48 -0400
X-MC-Unique: CZ7KVWy9OZ6FQIRhuR6tfQ-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 764731899520;
        Sun, 10 May 2020 21:57:47 +0000 (UTC)
Received: from rh2.redhat.com (ovpn-113-0.rdu2.redhat.com [10.10.113.0])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 81F761002382;
        Sun, 10 May 2020 21:57:46 +0000 (UTC)
From:   Mike Christie <mchristi@redhat.com>
To:     bvanassche@acm.org, bstroesser@ts.fujitsu.com,
        martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        target-devel@vger.kernel.org
Subject: [PATCH v5 00/15] target: add sysfs support
Date:   Sun, 10 May 2020 16:57:29 -0500
Message-Id: <20200510215744.21999-1-mchristi@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

The following patches made over Linus's current tree allow lio to export
info about structs like the se_session that the kernel initiates creation
of via events like initiator login where there is no local user interaction
like a mkdir.

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

So to export the session info we have debugfs, sysfs, ioctl, netlink, etc.
sysfs just seemed like a decent fit since one of the primary users is
rtslib and it already has lots of file/dir handling code.


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


