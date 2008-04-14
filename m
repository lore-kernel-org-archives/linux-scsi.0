From: Leonid Kalmankin <lvk@mashcenter.ru>
Subject: aic94xx + ST3146855SS still failing under heavy load
Date: Mon, 14 Apr 2008 21:03:37 +0400
Message-ID: <1208192617.10361.18.camel@lvk-nb.localdomain>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ns.mashcenter.ru ([195.14.58.214]:55576 "EHLO ns.mashcenter.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755626AbYDNRNb (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 14 Apr 2008 13:13:31 -0400
Received: from localhost (localhost [127.0.0.1])
	by ns.mashcenter.ru (Postfix) with ESMTP id 1DC511F415
	for <linux-scsi@vger.kernel.org>; Mon, 14 Apr 2008 21:03:08 +0400 (MSD)
Received: from ns.mashcenter.ru ([127.0.0.1])
	by localhost (mail.mashcenter.ru [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id l-0pzsOBj7Iu for <linux-scsi@vger.kernel.org>;
	Mon, 14 Apr 2008 21:03:06 +0400 (MSD)
Received: from [172.16.1.10] (unknown [172.16.1.10])
	by ns.mashcenter.ru (Postfix) with ESMTP id 5EA121F411
	for <linux-scsi@vger.kernel.org>; Mon, 14 Apr 2008 21:03:06 +0400 (MSD)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Hello!

We have a system with:

vanilla 2.6.25-rc8 (2.6.23, 2.6.24 have the same behaviour)

Adaptec AIC-9410W SAS (Razor ASIC RAID) (rev 09)
aic94xx: Found sequencer Firmware version 1.1 (V30)
  (Firmware version 1.1 (V17/10c6) makes no difference)
scsi 2:0:0:0: Direct-Access  SEAGATE ST3146855SS 0002 PQ: 0 ANSI: 5


It reliably fails under heavy IO:

> sas: command 0xffff81022c5f5640, task 0xffff8101f6b0f000, timed out: EH_NOT_HANDLED
> sas: command 0xffff81022c5f5500, task 0xffff8101f6b0f1c0, timed out: EH_NOT_HANDLED
> ....
> sas: Enter sas_scsi_recover_host
> sas: trying to find task 0xffff8101f6b0f000
> sas: sas_scsi_find_task: aborting task 0xffff8101f6b0f000
> aic94xx: task 0xffff8101f6b0f000 done with opcode 0x1e resp 0x0 stat 0x8d but aborted by upper layer!
> aic94xx: tmf tasklet complete
> aic94xx: tmf came back
> aic94xx: asd_abort_task: task 0xffff8101f6b0f000 done
> aic94xx: task 0xffff8101f6b0f000 aborted, res: 0x0
> sas: sas_scsi_find_task: task 0xffff8101f6b0f000 is done
> sas: sas_eh_handle_sas_errors: task 0xffff8101f6b0f000 is done
> sas: --- Exit sas_scsi_recover_host

Sometimes it successfully recovers; sometimes the disk is lost until the reboot.

I've read http://archive.netbsd.se/?ml=linux-scsi&a=2008-01&t=6260524
Asked Seagate about firmware update; they told me they do not have any.

As I understood, the root of this problem is protocol errors in disk's firmware
(other disks, for example FUJITSU MBA3147RC work fine); however, that kind of errors
should be recoverable by sas/aic94xx drivers.

If that is true, I could test some patches/ideas, where should I start?

