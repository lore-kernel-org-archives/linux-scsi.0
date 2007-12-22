From: Pete Wyckoff <pw@osc.edu>
Subject: bidi, varlen, bsg success report
Date: Sat, 22 Dec 2007 15:15:58 -0500
Message-ID: <20071222201558.GA25063@osc.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from quasar.osc.edu ([192.148.249.15]:47240 "EHLO quasar.osc.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752854AbXLVU1F (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 22 Dec 2007 15:27:05 -0500
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Boaz Harrosh <bharrosh@panasas.com>
Cc: James Bottomley <James.Bottomley@SteelEye.com>, Jens Axboe <jens.axboe@oracle.com>, Mike Christie <michaelc@cs.wisc.edu>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, linux-scsi <linux-scsi@vger.kernel.org>

I spent the last couple of days rebasing my working set of kernel
patches from 2.6.22-rc5 to 2.6.24-rc6.  I want to use the BSG
interface from userspace to submit variable-length bidirectional
SCSI commands to targets via iSCSI TCP.

Many thanks to all the work with scsi data accessors and iscsi that
makes this much easier, and to Boaz for continuing to maintain
patches.  Here's what I needed to do to make it work.

Start with linus-2.6.24-rc6.
Merge scsi-misc.
Apply the following outstanding patches from Boaz:

bidi
    scsi: scsi_data_buffer
    http://marc.info/?l=linux-scsi&m=119754650614813&w=2

    scsi: bidi support
    http://marc.info/?l=linux-scsi&m=119754667915055&w=2

varlen
    [PATCH 1/3] Let scsi_cmnd->cmnd use request->cmd buffer
    http://marc.info/?l=linux-scsi&m=119798523823750&w=2

    [PATCH 2/2] block layer varlen-cdb
    http://marc.info/?l=linux-scsi&m=119798548624218&w=2

    [PATCH 3/3] scsi: varlen extended and vendor-specific cdbs
    http://marc.info/?l=linux-scsi&m=119798563924476&w=2

Then a few more, two modified from earlier Boaz patches, and three
new ones by me, mainly to make bsg work.  They follow.

1. iscsi: extended cdb support
Adapted from Boaz
http://marc.info/?l=linux-scsi&m=119394074127857&w=2

2. iscsi: bidi support
Adapted from two old Boaz patches that can be found in this git:
http://www.bhalevy.com/git/gitweb.cgi?p=open-osd/.git;a=commitdiff;h=b5a97649eadb9434acbc4170a8aebd962af6d960
http://www.bhalevy.com/git/gitweb.cgi?p=open-osd/.git;a=commitdiff;h=cf3d4684a22bde6787f2eccee66d7b0ee9c9182c

3. bsg: accept varlen commands

4. bsg: bidi fix

5. iscsi tcp: bidi capable

Suggestions:  Boaz is probably the best qualified to shepherd his
outstanding five patches plus the two others I mention above (#1,
#2).  The first bsg patch (#3) won't apply without the varlen
patches.  The last two (#4, #5) are harmless and can go in now, but
won't matter until the bidi patches are in.  Comments on these
welcome.

Hope this is helpful.  I'm definitely looking forward to seeing
all this merged into mainline eventually.

		-- Pete
