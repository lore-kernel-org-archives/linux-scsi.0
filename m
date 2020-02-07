Return-Path: <SRS0=jGTy=33=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BDDB7C2BA83
	for <linux-scsi@archiver.kernel.org>; Fri,  7 Feb 2020 18:48:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8BBC3217BA
	for <linux-scsi@archiver.kernel.org>; Fri,  7 Feb 2020 18:48:55 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=delphix.com header.i=@delphix.com header.b="WJ18hF+2"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727032AbgBGSsz (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 7 Feb 2020 13:48:55 -0500
Received: from mail-pl1-f177.google.com ([209.85.214.177]:40356 "EHLO
        mail-pl1-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726900AbgBGSsy (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 7 Feb 2020 13:48:54 -0500
Received: by mail-pl1-f177.google.com with SMTP id y1so99677plp.7
        for <linux-scsi@vger.kernel.org>; Fri, 07 Feb 2020 10:48:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=delphix.com; s=google;
        h=from:content-transfer-encoding:mime-version:subject:message-id:date
         :cc:to;
        bh=WKYG7uHLuw5zu/XfR3nOMsSP/505akRacuNI3jXI7JM=;
        b=WJ18hF+2pA8IFUzWeJCU4F23QuPiehFCqzozoKgnwA5MurYGjZAFm7JUY6PB0lqCXU
         SH1As98g5c3Ca+xKchk55hOGqR778nvaTs1XHAPn+A1/pEI5Oz1Ob6jym8w6BQenI4mq
         RVIva1h1W6gUm6ZQFQAgA+O3yH34znfOG4s7A=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:content-transfer-encoding:mime-version
         :subject:message-id:date:cc:to;
        bh=WKYG7uHLuw5zu/XfR3nOMsSP/505akRacuNI3jXI7JM=;
        b=SkAKHquZiWdbiEEFGeArNZ8YUZmS7/WCDzluyJ0FhBJcfko4KS4TnIHsIv/fvUKtK8
         qwjHuUZkP8RSjEn4zJE2VCvTxbUCBKDGFe9s/RS0vtnHTrci8Cn1aWTlh+0ia+13eotM
         bTCzd2VxiUZ0q0dgX318+EoLPH6ZXyJh82TkOQrK4u22vlj/WSggoXSdmbukpgQ2FOtR
         h2yWqCy/OMRQtAntqM+efxyZHwPOurhTTwU383rhCeWTYmNRZ9jg82pLWvyFESv1GIjj
         rI99qP9BvEfAU2fWlqTUHyIyYhysGMWQ9yGyv0Iz7oaPfzmuQfRe0UbdbQLZMjuqHv/3
         JG3w==
X-Gm-Message-State: APjAAAUXkE039ron2VmG6tps+1afXCrSi9QPc1w33trY190tPpJnfIJM
        hsukG3+91E2NUfwpoUYeObrXUg==
X-Google-Smtp-Source: APXvYqwUuMxdAZKIQUNQaYA9S7+7HnMs8TcULkUthMzArS+Mq4XmJ8PtHUl6QnQS9Ij+PBwlQA6VDQ==
X-Received: by 2002:a17:90a:ec0f:: with SMTP id l15mr5166767pjy.39.1581101333995;
        Fri, 07 Feb 2020 10:48:53 -0800 (PST)
Received: from [192.168.0.103] (modemcable127.167-81-70.mc.videotron.ca. [70.81.167.127])
        by smtp.gmail.com with ESMTPSA id x11sm3799095pfn.53.2020.02.07.10.48.52
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 07 Feb 2020 10:48:53 -0800 (PST)
From:   Pavel Zakharov <pavel.zakharov@delphix.com>
Content-Type: text/plain;
        charset=utf-8
Content-Transfer-Encoding: quoted-printable
Mime-Version: 1.0 (Mac OS X Mail 12.4 \(3445.104.11\))
Subject: [LIO-target] BUG: Deleting a LUN hangs in transport_clear_lun_ref
Message-Id: <9A92D656-A796-4858-85CD-3750BDACFA28@delphix.com>
Date:   Fri, 7 Feb 2020 13:48:51 -0500
Cc:     linux-scsi@vger.kernel.org, target-devel@vger.kernel.org,
        linux-kernel@vger.kernel.org
To:     martin.petersen@oracle.com, bvanassche@acm.org
X-Mailer: Apple Mail (2.3445.104.11)
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

The issue is that deleting a LUN on the target will hang until IO is =
attempted to this LUN from the initiator.

I suspect the following patch introduced a regression:

commit 83f85b8ec305be9d65284de2921d8eeb6c7fcf12
Author: Bart Van Assche <bvanassche@acm.org>
Date:   Fri Jan 25 10:34:46 2019 -0800

    scsi: target/core: Inline transport_lun_remove_cmd()

REPRODUCER:

Target: Ubuntu 18.04.4 LTS running 5.3.0-28-generic
Initiator: Windows Server 2012 Build 9600
Both Running as VMs on ESX

1. Ubuntu: Upgrade & Install packages
$ sudo apt dist-upgrade && sudo apt install =
linux-image-generic-hwe-18.04 targetcli-fb && sudo reboot

2. Ubuntu: Setup iSCSI Target
$ sudo targetcli /iscsi create
Created target =
iqn.2003-01.org.linux-iscsi.ubuntu18.x8664:sn.6efb4b5956b3.
Created TPG 1.
Global pref auto_add_default_portal=3Dtrue
Created default portal listening on all IPs (0.0.0.0), port 3260.
$ sudo targetcli =
/iscsi/iqn.2003-01.org.linux-iscsi.ubuntu18.x8664:sn.6efb4b5956b3/tpg1/acl=
s create wwn=3Diqn.1991-05.com.microsoft:10-44-13-164.ad.delphix.com
Created Node ACL for =
iqn.1991-05.com.microsoft:10-44-13-164.ad.delphix.com
$ sudo targetcli /backstores/fileio create filedisk1 /filedisk1 1G
Created fileio filedisk1 with size 1073741824
$ sudo targetcli =
/iscsi/iqn.2003-01.org.linux-iscsi.ubuntu18.x8664:sn.6efb4b5956b3/tpg1/lun=
s create lun=3D0 storage_object=3D/backstores/fileio/filedisk1
Created LUN 0.
Created LUN 0->0 mapping in node ACL =
iqn.1991-05.com.microsoft:10-44-13-164.ad.delphix.com

3. Windows: Connect to iSCSI target, then go to Disk Management: Rescan =
Disks, Online Disk, Initialize Disk, Create Volume

4. Ubuntu: Delete LUN
$ sudo targetcli =
/iscsi/iqn.2003-01.org.linux-iscsi.ubuntu18.x8664:sn.6efb4b5956b3/tpg1/lun=
s delete 0
<Command hangs here>
In another window:
$ sudo cat /proc/$(pgrep targetcli)/stack
[<0>] core_tpg_remove_lun+0x35/0x100 [target_core_mod]
[<0>] core_dev_del_lun+0x26/0x70 [target_core_mod]
[<0>] target_fabric_port_unlink+0x4a/0x50 [target_core_mod]
[<0>] configfs_unlink+0xea/0x1b0
[<0>] vfs_unlink+0x111/0x200
[<0>] do_unlinkat+0x2ad/0x320
[<0>] __x64_sys_unlink+0x23/0x30
[<0>] do_syscall_64+0x5a/0x130
[<0>] entry_SYSCALL_64_after_hwframe+0x44/0xa9

Left for some time, you can see this in dmesg:
[ 1330.438613] INFO: task iscsicmd:24572 blocked for more than 120 =
seconds.
[ 1330.439554]       Tainted: P           OE     5.3.0-26-generic =
#28~18.04.1-Ubuntu
[ 1330.440594] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" =
disables this message.
[ 1330.441666] iscsicmd        D    0 24572   8910 0x00000080
[ 1330.441668] Call Trace:
[ 1330.441674]  __schedule+0x2a8/0x670
[ 1330.441676]  schedule+0x33/0xa0
[ 1330.441678]  schedule_timeout+0x1d3/0x2f0
[ 1330.441682]  ? __kfifo_to_user_r+0xb0/0xb0
[ 1330.441684]  wait_for_completion+0xba/0x140
[ 1330.441688]  ? wake_up_q+0x80/0x80
[ 1330.441704]  transport_clear_lun_ref+0x27/0x30 [target_core_mod]
[ 1330.441711]  core_tpg_remove_lun+0x35/0x100 [target_core_mod]
[ 1330.441716]  core_dev_del_lun+0x26/0x70 [target_core_mod]
[ 1330.441721]  target_fabric_port_unlink+0x4a/0x50 [target_core_mod]
[ 1330.441724]  configfs_unlink+0xea/0x1b0
[ 1330.441727]  vfs_unlink+0x111/0x200
[ 1330.441729]  do_unlinkat+0x2ad/0x320
[ 1330.441731]  __x64_sys_unlink+0x23/0x30
[ 1330.441734]  do_syscall_64+0x5a/0x130
[ 1330.441736]  entry_SYSCALL_64_after_hwframe+0x44/0xa9

5. Workaround: Windows: Rescan Disks. This will send some IO to the LUN =
and let the task resume

ANALYSIS

=46rom my debugging, the issue is that a lun_ref is being held at all =
times by an iscsi_cmd that is in iscsi_conn.conn_cmd_list.
Normally iscsit_ack_from_expstatsn() is supposed to take care of =
cleaning up iscsi_conn.conn_cmd_list, however due to the =
"iscsi_sna_lt(cmd->stat_sn, exp_statsn)=E2=80=9D check, the latest =
command is always left on that list.
Prior to the patch that removed the explicit call of =
transport_lun_remove_cmd(), the lun_ref would be cleaned up whenever the =
command would be completed. So even if the command was still in =
iscsi_conn.conn_cmd_list it would not hold a lun_ref.

I=E2=80=99ve done some live tracing and compared the 5.0 kernel (which =
doesn=E2=80=99t have the issue and the patch) with the 5.3 kernel, and =
as soon as some IO as performed on the LUN on the 5.3 kernel there is =
always this outstanding lun_ref.
I didn't dig as to why sending IO to a LUN that is being deleted =
unblocks the deletion, but my guess is that new lun_refs are not created =
because percpu_ref_tryget_live() fails, however =
iscsit_ack_from_expstatsn() is then run with a higher exp_statsn, so it =
frees up the iscsi_cmd that was holding the previous ref.

Using bpftrace while the deletion was hanging and running Rescan Disks =
on the initiator did somewhat confirm that:
$ sudo bpftrace -e 'k:core_tpg_lun_ref_release{printf("%s",kstack())}=E2=80=
=99
...
        core_tpg_lun_ref_release+1
        transport_generic_free_cmd+117
        iscsit_free_cmd+89
        iscsit_ack_from_expstatsn+393
        iscsit_process_scsi_cmd+62
        iscsit_get_rx_pdu+1635
        iscsi_target_rx_thread+187
        kthread+289
        ret_from_fork+31

I haven=E2=80=99t yet tried rebuilding the kernel with the patch =
reverted, but that is the next step I=E2=80=99m planning to try once I =
figure out how to do it.


