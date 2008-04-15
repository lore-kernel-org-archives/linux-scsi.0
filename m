From: Boaz Harrosh <bharrosh@panasas.com>
Subject: [PATCH 0/3] scsi: variable-length CDBs support
Date: Tue, 15 Apr 2008 15:24:42 +0300
Message-ID: <48049E8A.7030700@panasas.com>
References: <20080414010112W.tomof@acm.org> <1208170266-1676-1-git-send-email-fujita.tomonori@lab.ntt.co.jp>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bzq-219-195-70.pop.bezeqint.net ([62.219.195.70]:34503 "EHLO
	bh-buildlin2.bhalevy.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751324AbYDOM0D (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 15 Apr 2008 08:26:03 -0400
In-Reply-To: <1208170266-1676-1-git-send-email-fujita.tomonori@lab.ntt.co.jp>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: linux-scsi@vger.kernel.org, Jens Axboe <jens.axboe@oracle.com>, Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>, James Bottomley <James.Bottomley@HansenPartnership.com>, Alasdair G Kergon <agk@redhat.com>, Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>

Based on TOMO's block patches for supporting large commands
These patches will enable support for variable-length, extended,
and vendor specific CDBs. It should now cover the entire range of the 
SCSI standard.

These patches are independent of TOMO's patches to the block layer, 
because the block layer API for drivers did not change. So all I did
was make sure nothing will break when large commands start coming.
They are based on scsi-misc and could go in as is. 

I have tested my OSD setup with scsi-misc + for-2.6.26 branch from
Jens + these patches and it all works fine. So I'm happy.

[1/3] Let scsi_cmnd->cmnd use request->cmd buffer
  Here I let scsi_cmnd->cmnd point to the space allocated by
  request->cmd, instead of copying the data. The scsi_cmnd->cmd_len
  is guaranteed to contain the right length of the command.
  I have tried to go over every single place in the kernel that uses
  scsi_cmnd->cmnd and make sure it looks sane. Surprisingly to me,
  that was not at all bad. I hope I did not miss anything.

  I've tested on an x86_64 machine booting from a sata disk and
  ran the iscsi regression tests as well as my bidi and varlen tests
  on top of the complete patchset and all tests passed.

[2/3] scsi: varlen extended and vendor-specific cdbs
  Adds support for variable length, extended, and vendor-specific
  cdbs at the scsi mid-layer.

[3/3] iscsi_tcp: Enable large commands
  One liner for iscsi_tcp. Mike please ACK this patch

Boaz

