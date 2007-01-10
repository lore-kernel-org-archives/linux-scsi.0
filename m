From: linas@austin.ibm.com (Linas Vepstas)
Subject: crash on lpfc rmmod
Date: Wed, 10 Jan 2007 17:09:11 -0600
Message-ID: <20070110230910.GC6177@austin.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e1.ny.us.ibm.com ([32.97.182.141]:37725 "EHLO e1.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965161AbXAJXJO (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 10 Jan 2007 18:09:14 -0500
Received: from d01relay04.pok.ibm.com (d01relay04.pok.ibm.com [9.56.227.236])
	by e1.ny.us.ibm.com (8.13.8/8.12.11) with ESMTP id l0AN9CSb026842
	for <linux-scsi@vger.kernel.org>; Wed, 10 Jan 2007 18:09:12 -0500
Received: from d01av04.pok.ibm.com (d01av04.pok.ibm.com [9.56.224.64])
	by d01relay04.pok.ibm.com (8.13.6/8.13.6/NCO v8.1.1) with ESMTP id l0AN9C5e301380
	for <linux-scsi@vger.kernel.org>; Wed, 10 Jan 2007 18:09:12 -0500
Received: from d01av04.pok.ibm.com (loopback [127.0.0.1])
	by d01av04.pok.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id l0AN9BNL013110
	for <linux-scsi@vger.kernel.org>; Wed, 10 Jan 2007 18:09:12 -0500
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bino.Sebastian@Emulex.Com
Cc: linux-scsi@vger.kernel.org, rlary@us.ibm.com

Hi Bino,

Fiddling with the lpfc driver on 2.6.20-rc4, shortly after 
booting, I attempted to rmmod the lpfc module and got a crash:

io-raiders:~ # rmmod lpfc
cpu 0x0: Vector: 300 (Data Access) at [c0000003c86075a0]
    pc: d0000000008d0988: .lpfc_free_sysfs_attr+0x1c/0x58 [lpfc]
    lr: d0000000008c458c: .lpfc_pci_remove_one+0x3c/0x278 [lpfc]
    sp: c0000003c8607820
   msr: 9000000000009032
   dar: 11c0
 dsisr: 40000000
  current = 0xc0000003bf4b4c80
  paca    = 0xc000000000674080
    pid   = 12977, comm = rmmod
[ 3005.329608] ------------[ cut here ]------------

at which point the system locked up hard (I was expecting it to
go into xmon).

Suggestions?

--linas

