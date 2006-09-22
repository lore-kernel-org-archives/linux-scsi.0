From: Markus Lidel <Markus.Lidel@shadowconnect.com>
Subject: Re: 64bit DMA in i2o_block
Date: Fri, 22 Sep 2006 12:14:27 +0200
Message-ID: <4513B783.70008@shadowconnect.com>
References: <4513A87F.8040809@sw.ru>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------080504070408080202060504"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from s0006.shadowconnect.net ([213.202.216.60]:39952 "EHLO
	mail.shadowconnect.com") by vger.kernel.org with ESMTP
	id S1750705AbWIVKO3 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 22 Sep 2006 06:14:29 -0400
In-Reply-To: <4513A87F.8040809@sw.ru>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Vasily Averin <vvs@sw.ru>
Cc: linux-scsi@vger.kernel.org, devel@openvz.org

This is a multi-part message in MIME format.
--------------080504070408080202060504
Content-Type: text/plain; charset=KOI8-R; format=flowed
Content-Transfer-Encoding: 7bit

Hello,

Vasily Averin wrote:
> I've found that your driver does not work correctly with following options:
> CONFIG_I2O_EXT_ADAPTEC=y
> # CONFIG_I2O_EXT_ADAPTEC_DMA64 is not set
> I've checked it on 2.6.18 kernel on x86_64 node with 4Gb memory.

That could be the reason for the problems. I've only tried it on x86_64 
machines with < 4 GB memory...

> I would note that I've not noticed any bugs on x86 kernels, but x86_64 does not
> work at all.
> The behaviors of x86_64 kernels can differ:
> sometimes driver can not find partition table:
> i2o/hda: unknown partition table
> sometimes it find not all partition:
> i2o/hda: i2o/hda1 i2o/hda2 i2o/hda3 i2o/hda4 < >
> in other cases it detects devices well but corrupt the memory and filesystem:
> Sep 21 16:46:09 ts10 block-osm: registered device at major 80
> Sep 21 16:46:09 ts10  i2o/hda: i2o/hda1 i2o/hda2 i2o/hda3 i2o/hda4 < i2o/hda5 >
> Sep 21 16:46:09 ts10 block-osm: device added (TID: 207): i2o/hda
> Sep 21 16:46:09 ts10 kjournald starting.  Commit interval 5 seconds
> Sep 21 16:46:09 ts10 EXT3-fs: mounted filesystem with ordered data mode.
> Sep 21 16:46:10 ts10 Freeing unused kernel memory: 236k freed
> Sep 21 16:46:10 ts10 hotplug[961]: segfault at 0000000000000008 rip
> 00000032411088cf rsp 00007fff5b189050 error 4
> When I enabled CONFIG_I2O_EXT_ADAPTEC_DMA64 -- all the troubles went away.
> I've tried to investigate this issue, but I've not found and documentation
> described format of Adaptec's private messages.
> I would like to ask you, is this behavior specific for my hardware (Adaptec
> ASR-2010S I2O Zero Channel)? If not, I believe it makes sense to enable
>  CONFIG_I2O_EXT_ADAPTEC_DMA64 in Kconfig by default for 64-bit kernels.

I believe it's a driver issue. Do you have a testing-system where you 
could try out the appended patch?

Thank you very much.


Best regards,


Markus Lidel
------------------------------------------
Markus Lidel (Senior IT Consultant)

Shadow Connect GmbH
Carl-Reisch-Weg 12
D-86381 Krumbach
Germany

Phone:  +49 82 82/99 51-0
Fax:    +49 82 82/99 51-11

E-Mail: Markus.Lidel@shadowconnect.com
URL:    http://www.shadowconnect.com

--------------080504070408080202060504
Content-Type: text/x-patch;
 name="i2o-test-32bit-dma.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="i2o-test-32bit-dma.patch"

--- include/linux/i2o.h	2006-09-22 12:07:29.286557446 +0200
+++ include/linux/i2o.h	2006-09-22 12:08:01.904303452 +0200
@@ -776,6 +776,8 @@
 #ifdef CONFIG_I2O_EXT_ADAPTEC_DMA64
 		if ((sizeof(dma_addr_t) > 4) && c->pae_support)
 			*mptr++ = cpu_to_le32(i2o_dma_high(dma_addr));
+#else
+		BUG_ON((u32) ((u64) dma_addr >> 32));
 #endif
 		*sg_ptr = mptr;
 	}
@@ -835,6 +837,8 @@
 #ifdef CONFIG_I2O_EXT_ADAPTEC_DMA64
 		if ((sizeof(dma_addr_t) > 4) && c->pae_support)
 			*mptr++ = cpu_to_le32(i2o_dma_high(sg_dma_address(sg)));
+#else
+		BUG_ON((u32) ((u64) sg_dma_address(sg) >> 32));
 #endif
 		sg++;
 	}

--------------080504070408080202060504--
