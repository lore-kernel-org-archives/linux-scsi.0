From: Matthew Wilcox <matthew@wil.cx>
Subject: Re: [PATCH 2/4] block layer varlen-cdb
Date: Fri, 2 Nov 2007 05:17:19 -0600
Message-ID: <20071102111719.GP15111@parisc-linux.org>
References: <472A12D6.805@panasas.com> <472A1552.6030700@panasas.com> <20071101184000.GM15111@parisc-linux.org> <472AC46C.2050707@panasas.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from palinux.external.hp.com ([192.25.206.14]:42825 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753074AbXKBLRV (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 2 Nov 2007 07:17:21 -0400
Content-Disposition: inline
In-Reply-To: <472AC46C.2050707@panasas.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Benny Halevy <bhalevy@panasas.com>
Cc: Boaz Harrosh <bharrosh@panasas.com>, James Bottomley <James.Bottomley@SteelEye.com>, Jens Axboe <jens.axboe@oracle.com>, Mike Christie <michaelc@cs.wisc.edu>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, linux-scsi <linux-scsi@vger.kernel.org>, open-iscsi@googlegroups.com, Pete Wyckoff <pw@osc.edu>

On Fri, Nov 02, 2007 at 08:32:12AM +0200, Benny Halevy wrote:
> I agree this is probably the cleanest implementation but when Boaz and I
> initially discussed this approach he convinced me that LL block devices assume
> that req->cmd_len <= BLK_MAX_CDB and it is unsafe at the moment to expose them
> potentially larger commands.

We'll never submit a command to a low level driver that is longer than
the max_cmd_len in the Scsi_Host.  So if they've set it higher than they
really can deal with, that's an easy bug to fix.

-- 
Intel are signing my paycheques ... these opinions are still mine
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
