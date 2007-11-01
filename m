From: Boaz Harrosh <bharrosh@panasas.com>
Subject: [RFC 0/4] varlen extended and vendor-specific cdbs
Date: Thu, 01 Nov 2007 19:54:30 +0200
Message-ID: <472A12D6.805@panasas.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from gw-colo-pa.panasas.com ([66.238.117.130]:18862 "EHLO
	cassoulet.panasas.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753228AbXKAR5Q (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 1 Nov 2007 13:57:16 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>, Jens Axboe <jens.axboe@oracle.com>, Mike Christie <michaelc@cs.wisc.edu>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, linux-scsi
Cc: Pete Wyckoff <pw@osc.edu>, Benny Halevy <bhalevy@panasas.com>

This is a proposal for adding support for variable-length, extended, and 
vendor specific CDBs. It should now cover the entire range of the
SCSI standard.

This patchset extends my original submission (over a year old) in
that it starts with cleaning up scsi_cmnd, hence the first patch. The
other three are similar to the ones submitted before.

This effort is orthogonal to the bidi and scsi_data_buffer effort
and can be accepted now. The patchset, however, is presented in this RFC
on top of the scsi_data_buffer patches, as they sit in my tree. They
can easily be rebased to current scsi-misc. The iscsi patch is on top
of the iscsi branch of the iscsi-git-tree.

(Matthew, these patches will conflict with your scsi_cmnd cleanup patches
I promise to rebase them before submission)

A complete git-tree based on scsi-misc which includes a complete bidi
and varlen work can be fetched from:
 - git://git.bhalevy.com/open-osd bidi branch (varlen branch is this work)
 - http://www.bhalevy.com/git - has the gitweb GUI

[1/4] Let scsi_cmnd->cmnd use request->cmd buffer
  Here I let scsi_cmnd->cmnd point to the space allocated by
  request->cmd, instead of copying the data. The scsi_cmnd->cmd_len
  is guaranteed to contain the right length of the command.
  I have tried to go over every single place in the kernel that uses
  scsi_cmnd->cmnd and make sure it looks sane. Surprisingly to me,
  that was not at all bad. I hope I did not miss anything.

  I've tested on an x86_64 machine booting from a sata disk and
  ran the iscsi regression tests as well as my bidi and varlen tests
  on top of the complete patchset and all tests passed.

[2/4] block layer varlen-cdb
  Unlike the scsi approach (see below), I did not want to unify
  cmd[]/cmd_len and the *varlen_cdb and varlen_cdb_len
  members of struct request. This is because unlike scsi, block
  devices do not have a .max_cmd_len parameter to protect them
  from unexpected large commands. 
  In the case varlen_cdb and varlen_cdb_len are used the cmd[] 
  buffer is ignored and the cmd_len will be set to zero.

[3/4] scsi: varlen extended and vendor-specific cdbs
  Adds support for variable length, extended, and vendor-specific
  cdbs at the scsi mid-layer.

[4/4] iscsi: extended cdb support
  This is on top of the iscsi branch. In the URL above there
  are the three missing patches for iscsi, that add support
  for AHSs.

Boaz
