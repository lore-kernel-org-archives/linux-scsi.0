From: Mike Christie <mchristi@redhat.com>
Subject: [PATCH 00/19] target/target_core_user: changes for 4.16
Date: Sun, 29 Oct 2017 22:44:20 -0500
Message-ID: <1509335079-5276-1-git-send-email-mchristi@redhat.com>
Return-path: <target-devel-owner@vger.kernel.org>
Sender: target-devel-owner@vger.kernel.org
To: martin.petersen@oracle.com, jejb@linux.vnet.ibm.com, linux-scsi@vger.kernel.org, target-devel@vger.kernel.org, nab@linux-iscsi.org
List-Id: linux-scsi@vger.kernel.org

The following patches made over linus's tree, and also apply over
Nicks target-pending master branch, and Martin and James's for-next branches,
fix several bugs and add features to the target_core_user module for
LIO.

- Patches 1 -3 are target_core_user fixes/changes that have been sitting
on the list for a while and have been reviewed.

- Patches 4 - 18 are changes to target_core_user that fixes bugs in
the ring buffer (buffer used to pass commands and responses between
user/kernel space) and allow the user to config the ring size and how
long we wait for memory to free up.

- Patch 19 is a change to the core target code that allows backend modules
like target_core_user to return SAM STAT TASK SET FULL when a condition
like the ring buffer is full temporarily.

I know it is already rc7 and I am not pushing these for 4.15, so
that is why the subject mentions the next next kernel.

Note:

These patches have conflicts with Nicks's for next branch. Nick's
for next has 3 patches which are not needed with my patchset.

This patch:

commit b8501553476c2eabbd15da79e152a84a9a67dc5a
Author: Xiubo Li <lixiubo@cmss.chinamobile.com>
Date:   Wed Jul 12 15:16:07 2017 +0800

    tcmu: Add fifo type waiter list support to avoid starvation

is bad and can just be dropped/reverted. My patch fixes the same
issue and fixes regressions/bugs that that patch has.

This patch

commit 04229774f69250e0f7e63b4d1b50ba8371c9d165
Author: Dan Carpenter <dan.carpenter@oracle.com>
Date:   Tue Aug 1 23:09:17 2017 +0300

    tcmu: Oops in unmap_thread_fn()

fixes a bug with the above patch and can just be dropped if the above
patch is also dropped.

And I included:

commit 1b0a5fda1cd7e9001d4c16cbb6dfc5e963f08bd7
Author: Xiubo Li <lixiubo@cmss.chinamobile.com>
Date:   Thu Jul 13 14:33:50 2017 +0800

    tcmu: clean up the scatter helper

this patch in my set.

Nick, I am assuming, if you come back soon'ish you can just drop the
those patches or revert them like you have done in the past. Or,
if someone else picks up these patches then they do not need to worry
about what was sitting in your branches.
