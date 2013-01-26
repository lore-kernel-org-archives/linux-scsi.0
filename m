From: "=?utf-8?B?c3ByZW4uZ21AZ21haWwuY29t?=" <spren.gm@gmail.com>
Subject: =?utf-8?B?bXB0MnNhczogZGV2aWNlX2Jsb2NrZWQgcXVlc3Rpb24=?=
Date: Sat, 26 Jan 2013 11:52:14 +0800
Message-ID: <201301261152058902951@gmail.com>
References: <20130123212033.GA15800@logfs.org>,
 <87k3r310jr.fsf@nemi.mork.no>,
 <20130125171255.GA22141@logfs.org>,
 <20130125180044.GC22141@logfs.org>,
 <20130125192039.GE22141@logfs.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pa0-f52.google.com ([209.85.220.52]:39099 "EHLO
	mail-pa0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755293Ab3AZDw2 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 25 Jan 2013 22:52:28 -0500
Received: by mail-pa0-f52.google.com with SMTP id fb1so611304pad.25
        for <linux-scsi@vger.kernel.org>; Fri, 25 Jan 2013 19:52:26 -0800 (PST)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: =?utf-8?B?SsO2cm5FbmdlbA==?= <joern@logfs.org>, =?utf-8?B?QmrDuHJuTW9yaw==?= <bjorn@mork.no>, =?utf-8?B?TmFnYWxha3NobWkgTmFuZGlnYW1h?= <Nagalakshmi.Nandigama@lsi.com>, =?utf-8?B?U3JlZWthbnRoIFJlZGR5?= <Sreekanth.Reddy@lsi.com>, =?utf-8?B?c3VwcG9ydEBsc2kuY29t?= <support@lsi.com>, =?utf-8?B?SmFtZXMgRS5KLiBCb3R0b21sZXk=?= <JBottomley@parallels.com>, =?utf-8?B?REwtTVBURnVzaW9uTGludXhAbHNpLmNvbQ==?= <DL-MPTFusionLinux@lsi.com>
Cc: =?utf-8?B?bGludXgtc2NzaUB2Z2VyLmtlcm5lbC5vcmc=?= <linux-scsi@vger.kernel.org>

Hi,
  we encounter a problem that a disk is blocked forever, the key log is:

mpt2sas0: TEST_UNIT_READY: handle(0x000a), lun(0)
mpt2sas0: TEST_UNIT_READY: handle(0x000a), lun(0)
mpt2sas0: Spinning up disk.... handle(0x000a), lun(0)
mpt2sas0: TEST_UNIT_READY: handle(0x000a), lun(0)
mpt2sas0: Spinning up disk.... handle(0x000a), lun(0)
mpt2sas0: TEST_UNIT_READY: handle(0x000a), lun(0)
mpt2sas0: Spinning up disk.... handle(0x000a), lun(0)
sd 2:0:1:0: device_blocked, handle(0x000a)

  looking into the driver code, it seems that the device is blocked by function 
_scsih_block_io_to_children_attached_directly() in mpt2sas/mpt2sas_scsih.c
with reason_code == MPI2_EVENT_SAS_TOPO_RC_DELAY_NOT_RESPONDING,
  what does this reason_code mean please? when should it be returned? and any way to handle it?

Best Regards,
spren
2013-01-26

