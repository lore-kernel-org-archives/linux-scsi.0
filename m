From: Vasily Averin <vvs@sw.ru>
Subject: 64bit DMA in i2o_block
Date: Fri, 22 Sep 2006 13:10:23 +0400
Message-ID: <4513A87F.8040809@sw.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=KOI8-R
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mailhub.sw.ru ([195.214.233.200]:33089 "EHLO relay.sw.ru")
	by vger.kernel.org with ESMTP id S1750950AbWIVJKf (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 22 Sep 2006 05:10:35 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Markus Lidel <Markus.Lidel@shadowconnect.com>, linux-scsi@vger.kernel.org, devel@openvz.org

Markus,

I've found that your driver does not work correctly with following options:
CONFIG_I2O_EXT_ADAPTEC=y
# CONFIG_I2O_EXT_ADAPTEC_DMA64 is not set

I've checked it on 2.6.18 kernel on x86_64 node with 4Gb memory.

I would note that I've not noticed any bugs on x86 kernels, but x86_64 does not
work at all.

The behaviors of x86_64 kernels can differ:
sometimes driver can not find partition table:
i2o/hda: unknown partition table

sometimes it find not all partition:
i2o/hda: i2o/hda1 i2o/hda2 i2o/hda3 i2o/hda4 < >

in other cases it detects devices well but corrupt the memory and filesystem:
Sep 21 16:46:09 ts10 block-osm: registered device at major 80
Sep 21 16:46:09 ts10  i2o/hda: i2o/hda1 i2o/hda2 i2o/hda3 i2o/hda4 < i2o/hda5 >
Sep 21 16:46:09 ts10 block-osm: device added (TID: 207): i2o/hda
Sep 21 16:46:09 ts10 kjournald starting.  Commit interval 5 seconds
Sep 21 16:46:09 ts10 EXT3-fs: mounted filesystem with ordered data mode.
Sep 21 16:46:10 ts10 Freeing unused kernel memory: 236k freed
Sep 21 16:46:10 ts10 hotplug[961]: segfault at 0000000000000008 rip
00000032411088cf rsp 00007fff5b189050 error 4

When I enabled CONFIG_I2O_EXT_ADAPTEC_DMA64 -- all the troubles went away.

I've tried to investigate this issue, but I've not found and documentation
described format of Adaptec's private messages.

I would like to ask you, is this behavior specific for my hardware (Adaptec
ASR-2010S I2O Zero Channel)? If not, I believe it makes sense to enable
 CONFIG_I2O_EXT_ADAPTEC_DMA64 in Kconfig by default for 64-bit kernels.

Thank you,
	Vasily Averin
