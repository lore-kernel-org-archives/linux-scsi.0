From: Meng Xu <mengxu.gatech@gmail.com>
Subject: mptfusion: holding wrong mutex due to iocnum mismatch
Date: Sun, 24 Sep 2017 11:14:50 -0400
Message-ID: <1506266090-22958-1-git-send-email-mengxu.gatech@gmail.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: sathya.prakash@broadcom.com, chaitra.basappa@broadcom.com, suganath-prabu.subramani@broadcom.com, MPT-FusionLinux.pdl@broadcom.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: meng.xu@gatech.edu, sanidhya@gatech.edu, taesoo@gatech.edu, Meng Xu <mengxu.gatech@gmail.com>
List-Id: linux-scsi@vger.kernel.org

In __mptctl_ioctl() of file drivers/message/fusion/mptctl.c, there seems
to be a way to cause a confused deputy attack by racing condition in 
userspace.

1. In the first userspace fetch, copy_from_user(&khdr, uhdr, sizeof(khdr),
a user process can put, say, 01, in uhdr->iocnum which will be fetched
into khdr.iocnum and later used to get the MPT_ADAPTER iocp.

2. Later the mutex lock of iocp (01) is held before the operations like
mptctl_fw_download(), mptctl_mpt_command(), etc.

3. With these function, say, mptctl_fw_download(), the same userspace (ufwdl) 
memory is fetched again and put into kfwdl. However, at this time, a user
process can put a different value, say, 02, in kfwdl.iocnum.

4. In my understanding, this means that we are holding iocp(01)'s lock 
while iocp(02) is actually doing the work (be it download, command, etc).

I'd like to seek your opinion on this matter and what do you think should
be the way to patch it. I cannot come with with an easy fix (within 10 LoC)
as once we are in mptctl_fw_download(), etc, we lose the context to know
which iocp's lock is actually held. One possible way is to add an argument
to these functions (either iocnum or iocp) to inform this context.
