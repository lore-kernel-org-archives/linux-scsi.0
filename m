From: Masao Fukuchi <fukuchi.masao@jp.fujitsu.com>
Subject: Re: [ANNOUNCE] MPT Fusion driver 3.02.06 update
Date: Tue, 26 Oct 2004 17:09:32 +0900
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <200410260809.AA03711@fukuchi.jp.fujitsu.com>
References: <0E3FA95632D6D047BA649F95DAB60E57053AF031@exa-atlanta>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-2022-jp
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:41172 "EHLO
	fgwmail6.fujitsu.co.jp") by vger.kernel.org with ESMTP
	id S262181AbUJZIKW (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 26 Oct 2004 04:10:22 -0400
Received: from m5.gw.fujitsu.co.jp ([10.0.50.75]) by fgwmail6.fujitsu.co.jp (8.12.10/Fujitsu Gateway)
	id i9Q8AKqK006729 for <linux-scsi@vger.kernel.org>; Tue, 26 Oct 2004 17:10:20 +0900
	(envelope-from fukuchi.masao@jp.fujitsu.com)
Received: from s1.gw.fujitsu.co.jp by m5.gw.fujitsu.co.jp (8.12.10/Fujitsu Domain Master)
	id i9Q8AJkt025357 for <linux-scsi@vger.kernel.org>; Tue, 26 Oct 2004 17:10:19 +0900
	(envelope-from fukuchi.masao@jp.fujitsu.com)
Received: from s1.gw.fujitsu.co.jp (s1 [127.0.0.1])
	by s1.gw.fujitsu.co.jp (Postfix) with ESMTP id 7B209216F54
	for <linux-scsi@vger.kernel.org>; Tue, 26 Oct 2004 17:10:19 +0900 (JST)
Received: from fjmail506.fjmail.jp.fujitsu.com (fjmail506-0.fjmail.jp.fujitsu.com [10.59.80.106])
	by s1.gw.fujitsu.co.jp (Postfix) with ESMTP id 2557E216FBF
	for <linux-scsi@vger.kernel.org>; Tue, 26 Oct 2004 17:10:19 +0900 (JST)
Received: from fukuchi.jp.fujitsu.com
 (fjscan503-0.fjmail.jp.fujitsu.com [10.59.80.124])
 by fjmail506.fjmail.jp.fujitsu.com
 (Sun Internet Mail Server sims.4.0.2001.07.26.11.50.p9)
 with SMTP id <0I6600MYGMP5SR@fjmail506.fjmail.jp.fujitsu.com> for
 linux-scsi@vger.kernel.org; Tue, 26 Oct 2004 17:10:18 +0900 (JST)
In-reply-to: <0E3FA95632D6D047BA649F95DAB60E57053AF031@exa-atlanta>
List-Id: linux-scsi@vger.kernel.org
To: "Moore, Eric Dean" <Emoore@lsil.com>
Cc: linux-scsi@vger.kernel.org

Hi Eric,

I installed Fusion MPT driver 3.02.06 into my tiger4(SR870BN4).
But I have some problems.

1.compile error
  When I compiled your driver with kernel 2.6.9, compile operation
  failed with error.
  I checked mptbase.c(and mptbase.h) and found your code shows:
   #if (LINUX_VERSION_CODE > KERNEL_VERSION(2,6,8))
         pci_save_state(pdev);
   #else
         pci_save_state(pdev, ioc->PciState);
   #endif
  But pci_save_state() in kernel 2.6.9 has two parameters.
  (I don't know which kernel version has 1 parameter)

2.startup sequence fail
  I fixed above problem temporarily and compiled it.
  The compile operation finished with no error.
  Then I started Linux, but the startup sequence failed with
  following error.
  >mptbase: Initiating ioc0 bringup
  >mptbase: ioc0: ERROR - Diagnostic reset FAILED! (142h)
  >mptbase: ioc0 NOT READY WARNING!
  >mptbase: WARNING - ioc0 did not initialize properly! (-1)
  >mptbase: probe of 0000:04:02.0 failed with error -1

  This message shows, IOC didn't become ready.
  The LSI53C1030 on Tiger4 has no flash ROM, I think the cause
  of the problem was fusion MPT driver didn' execute  Firmware
  Download Boot operation.

If you have any questions or comments, please let me know.

Thanks,
M.Fukuchi

Moore, Eric Dean wrote:
>All,
>
>We are pleased to announce the MPT Fusion release candidate for lk 2.6
>
>Highlights of this release:
>キ	SAS Support - 1064, 1066, 1068
>キ	mpi headers v1.5.2
>キ	csmi ioctl support
>キ	MSI Support
>キ	fc_transport support
>キ	several patches incorporated from Christoph Hellwig 
>
>
>This patch applied against bk://linux-scsi.bkbits.net/scsi-misc-2.6
>
>Here is a link to this patch:
>ftp://ftp.lsil.com/HostAdapterDrivers/linux/Fusion-MPT/2.6-kernel/3.02.06/mp
>tlinux-3.02.06.patch
>
>
>Full source and release notes are also provided at link above.
>
>Eric Moore
>LSI Logic Corporation
>
>
>
>-
>To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
>the body of a message to majordomo@vger.kernel.org
>More majordomo info at  http://vger.kernel.org/majordomo-info.html
