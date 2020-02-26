Return-Path: <SRS0=mj/2=4O=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AFBB5C4BA18
	for <linux-scsi@archiver.kernel.org>; Wed, 26 Feb 2020 17:18:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7EED1206E6
	for <linux-scsi@archiver.kernel.org>; Wed, 26 Feb 2020 17:18:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726695AbgBZRSW (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 26 Feb 2020 12:18:22 -0500
Received: from h1.fbrelay.privateemail.com ([131.153.2.42]:51431 "EHLO
        h1.fbrelay.privateemail.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726536AbgBZRSW (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 26 Feb 2020 12:18:22 -0500
X-Greylist: delayed 738 seconds by postgrey-1.27 at vger.kernel.org; Wed, 26 Feb 2020 12:18:21 EST
Received: from MTA-09-4.privateemail.com (mta-09.privateemail.com [198.54.127.58])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by h1.fbrelay.privateemail.com (Postfix) with ESMTPS id A6ECE80D1A;
        Wed, 26 Feb 2020 12:06:02 -0500 (EST)
Received: from MTA-09.privateemail.com (localhost [127.0.0.1])
        by MTA-09.privateemail.com (Postfix) with ESMTP id 2728B60034;
        Wed, 26 Feb 2020 12:05:49 -0500 (EST)
Received: from localhost.localdomain (unknown [10.20.151.236])
        by MTA-09.privateemail.com (Postfix) with ESMTPA id D5D2D60043;
        Wed, 26 Feb 2020 17:05:42 +0000 (UTC)
From:   Ryan Attard <ryanattard@ryanattard.info>
To:     linux-scsi@vger.kernel.org, linux-block@vger.kernel.org
Cc:     ryanattard@ryanattard.info, axboe@kernel.dk, dgilbert@interlog.com,
        jejb@linux.vnet.ibm.com, martin.petersen@oracle.com
Subject: [PATCH 0/1 RESEND] Allow non-root users to perform ZBC commands.
Date:   Wed, 26 Feb 2020 11:05:17 -0600
Message-Id: <20200226170518.92963-1-ryanattard@ryanattard.info>
X-Mailer: git-send-email 2.24.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Resending since I missed some emails on the first:

The source of this issue is that a group is configured that allows a service
user to perform read and writes to a specific set of disks, and the permissions
on the sd device entries for a host managed device have permissions 0660, same
as the sg device entry. Operations succeed on the sg device (since there is
a different code path for handling those operations).

There was some hand wringing around adding CAP_SYS_RAWIO capabilities to that
user, since it includes things like /dev/mem access which was not desired or
required to perform disk write operations.

Example failure:
root@device_with_zbc_disks:~# su -s /bin/bash -c 'sg_rep_zones -vv /dev/sdh -m 128' USER_LOW_PERMS
open /dev/sdh with flags=0x802
    Report zones cdb: 95 00 00 00 00 00 00 00 00 00 00 00 00 80 00 00
ioctl(SG_IO v3) failed: Operation not permitted (errno=1)
report zones: pass through os error: Operation not permitted
Report zones command: Sense category: -1
root@device_with_zbc_disks:~# su -s /bin/bash -c 'sg_rep_zones -vv /dev/sg7 -m 128' USER_LOW_PERMS
open /dev/sdh with flags=0x802
    Report zones cdb: 95 00 00 00 00 00 00 00 00 00 00 00 00 80 00 00
zl_len available is 2624, response length is 128
Report zones response:
  Same=0: zone type and length may differ in each descriptor
<snip>


Example with patch:
root@device_with_zbc_disks:~# su -s /bin/bash -c 'sg_rep_zones -vv /dev/sdh -m 128' USER_LOW_PERMS
open /dev/sdh with flags=0x802
    Report zones cdb: 95 00 00 00 00 00 00 00 00 00 00 00 00 80 00 00
zl_len available is 2624, response length is 128
Report zones response:
  Same=0: zone type and length may differ in each descriptor
<snip>


Thanks,

Ryan

