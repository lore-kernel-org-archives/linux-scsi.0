From: Feng Li <lifeng1519@gmail.com>
Subject: virtio-console downgrade the virtio-pci-blk performance
Date: Sun, 30 Sep 2018 13:25:58 +0800
Message-ID: <CAEK8JBDPNqTap-LnoBxUZh4Bj9b+VgrsPm53QAivfOsLG7wuGw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel <linux-kernel@vger.kernel.org>, qemu-discuss@nongnu.org, qemu-devel@nongnu.org, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

Hi,
I found an obvious performance downgrade when virtio-console combined
with virtio-pci-blk.

This phenomenon exists in nearly all Qemu versions and all Linux
(CentOS7, Fedora 28, Ubuntu 18.04) distros.

This is a disk cmd:
-drive file=iscsi://127.0.0.1:3260/iqn.2016-02.com.test:system:fl-iscsi/1,format=raw,if=none,id=drive-virtio-disk0,cache=none,aio=native
-device virtio-blk-pci,scsi=off,bus=pci.0,addr=0x6,drive=drive-virtio-disk0,id=virtio-disk0,bootindex=1,write-cache=on

If I add "-device
virtio-serial-pci,id=virtio-serial0,bus=pci.0,addr=0x5  ", the virtio
disk 4k iops (randread/randwrite) would downgrade from 60k to 40k.

In VM, if I rmmod virtio-console, the performance will back to normal.

Any idea about this issue?

I don't know this is a qemu issue or kernel issue.


Thanks in advance.
-- 
Thanks and Best Regards,
Alex
