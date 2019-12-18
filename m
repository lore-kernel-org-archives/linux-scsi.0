Return-Path: <SRS0=fPmA=2I=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D1E51C2D0CD
	for <linux-scsi@archiver.kernel.org>; Wed, 18 Dec 2019 16:51:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A41CF218AC
	for <linux-scsi@archiver.kernel.org>; Wed, 18 Dec 2019 16:51:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727368AbfLRQvt (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 18 Dec 2019 11:51:49 -0500
Received: from h4.fbrelay.privateemail.com ([131.153.2.45]:47347 "EHLO
        h4.fbrelay.privateemail.com." rhost-flags-OK-OK-FAIL-FAIL)
        by vger.kernel.org with ESMTP id S1727217AbfLRQvt (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 18 Dec 2019 11:51:49 -0500
Received: from MTA-06-3.privateemail.com (mta-06.privateemail.com [68.65.122.16])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by h3.fbrelay.privateemail.com (Postfix) with ESMTPS id F105080A23
        for <linux-scsi@vger.kernel.org>; Wed, 18 Dec 2019 11:40:26 -0500 (EST)
Received: from MTA-06.privateemail.com (localhost [127.0.0.1])
        by MTA-06.privateemail.com (Postfix) with ESMTP id F103160043;
        Wed, 18 Dec 2019 11:40:25 -0500 (EST)
Received: from localhost.localdomain (unknown [10.20.151.206])
        by MTA-06.privateemail.com (Postfix) with ESMTPA id 458D06004F;
        Wed, 18 Dec 2019 16:40:25 +0000 (UTC)
From:   rattard@ryanattard.info
To:     axboe@kernel.dk, linux-scsi@vger.kernel.org, dgilbert@interlog.com,
        JBottomley@parallels.com
Subject: [PATCH 0/1] Allow non-root users to perform ZBC commands 
Date:   Wed, 18 Dec 2019 10:40:07 -0600
Message-Id: <20191218164008.99155-1-rattard@ryanattard.info>
X-Mailer: git-send-email 2.24.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

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




