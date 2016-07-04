From: Zhangfei Gao <zhangfei.gao@gmail.com>
Subject: how to test pscsi with vhost
Date: Mon, 4 Jul 2016 15:32:18 +0800
Message-ID: <CAMj5BkgpyoBY0GLoqbDdOa5LeYXsWNVxQUBRaH3AYgERzP-VMw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-qt0-f176.google.com ([209.85.216.176]:34829 "EHLO
	mail-qt0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752680AbcGDHke (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 4 Jul 2016 03:40:34 -0400
Received: by mail-qt0-f176.google.com with SMTP id f89so84122581qtd.2
        for <linux-scsi@vger.kernel.org>; Mon, 04 Jul 2016 00:40:33 -0700 (PDT)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

I am testing with pscsi, but fail to find any block device under /dev to mount.
The scsi_probe_lun seems can not return correctly, scsi scan: INQUIRY failes.

Is this usage correct?

/backstores/pscsi> create name=pscsi_backend dev=/dev/sdb
Note: block backstore recommended for SCSI block devices
Created pscsi storage object pscsi_backend using /dev/sdb

/backstores/pscsi> cd /vhost
/vhost> create wwn=naa.60014052cc816bf4
/vhost> cd naa.60014052cc816bf4/tpg1/luns
/vhost/naa.60...bf4/tpg1/luns> create /backstores/pscsi/pscsi_backend
Selected LUN 0.
Created LUN 0.

/vhost/naa.60...bf4/tpg1/luns> cd /
/> ls
o- / ..................................................................... [...]
  o- backstores .......................................................... [...]
  | o- fileio ............................................... [0 Storage Object]
  | o- iblock ............................................... [0 Storage Object]
  | o- pscsi ................................................ [1 Storage Object]
  | | o- pscsi_backend .................................... [/dev/sdb activated]
  | o- rd_mcp ............................................... [0 Storage Object]
  o- iscsi ......................................................... [0 Targets]
  o- loopback ...................................................... [0 Targets]
  o- vhost .......................................................... [1 Target]
    o- naa.60014052cc816bf4 ............................................ [1 TPG]
      o- tpg1 ........................................... [naa.6001405030badd8a]
        o- luns ........................................................ [1 LUN]
          o- lun0 ............................. [pscsi/pscsi_backend (/dev/sdb)]
/>

/> saveconfig


qemu.git/aarch64-softmmu/qemu-system-aarch64 \
    -enable-kvm -nographic -kernel Image \
    -device vhost-scsi-pci,wwpn=naa.60014052cc816bf4 \
    -m 512 -M virt -cpu host \
    -append "earlyprintk console=ttyAMA0 mem=512M"


root@(none)$ ls /dev
autofs              ptyp8               tty30               tty62
console             ptyp9               tty31               tty63
cpu_dma_latency     ptypa               tty32               tty7
cuse                ptypb               tty33               tty8
full                ptypc               tty34               tty9
fuse                ptypd               tty35               ttyAMA0
input               ptype               tty36               ttyS0
kmem                ptypf               tty37               ttyS1
kmsg                random              tty38               ttyS2
loop-control        snd                 tty39               ttyS3
loop0               tty                 tty4                ttyp0
loop1               tty0                tty40               ttyp1
loop2               tty1                tty41               ttyp2
loop3               tty10               tty42               ttyp3
loop4               tty11               tty43               ttyp4
loop5               tty12               tty44               ttyp5
loop6               tty13               tty45               ttyp6
loop7               tty14               tty46               ttyp7
mem                 tty15               tty47               ttyp8
memory_bandwidth    tty16               tty48               ttyp9
net                 tty17               tty49               ttypa
network_latency     tty18               tty5                ttypb
network_throughput  tty19               tty50               ttypc
null                tty2                tty51               ttypd
port                tty20               tty52               ttype
psaux               tty21               tty53               ttypf
ptmx                tty22               tty54               urandom
ptyp0               tty23               tty55               vcs
ptyp1               tty24               tty56               vcs1
ptyp2               tty25               tty57               vcsa
ptyp3               tty26               tty58               vcsa1
ptyp4               tty27               tty59               vga_arbiter
ptyp5               tty28               tty6                vhost-scsi
ptyp6               tty29               tty60               zero
ptyp7               tty3                tty61

Thanks
