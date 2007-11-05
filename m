From: Boaz Harrosh <bharrosh@panasas.com>
Subject: Re: [PATCH 2/4] block layer varlen-cdb
Date: Mon, 05 Nov 2007 11:17:59 +0200
Message-ID: <472EDFC7.5040104@panasas.com>
References: <472A12D6.805@panasas.com> <472A1552.6030700@panasas.com> <20071101184000.GM15111@parisc-linux.org> <472AC46C.2050707@panasas.com> <20071102111719.GP15111@parisc-linux.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from gw-colo-pa.panasas.com ([66.238.117.130]:21491 "EHLO
	cassoulet.panasas.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753564AbXKEJTW (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 5 Nov 2007 04:19:22 -0500
In-Reply-To: <20071102111719.GP15111@parisc-linux.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Matthew Wilcox <matthew@wil.cx>
Cc: Benny Halevy <bhalevy@panasas.com>, James Bottomley <James.Bottomley@SteelEye.com>, Jens Axboe <jens.axboe@oracle.com>, Mike Christie <michaelc@cs.wisc.edu>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, linux-scsi <linux-scsi@vger.kernel.org>, open-iscsi@googlegroups.com, Pete Wyckoff <pw@osc.edu>

On Fri, Nov 02 2007 at 13:17 +0200, Matthew Wilcox <matthew@wil.cx> wrote:
> On Fri, Nov 02, 2007 at 08:32:12AM +0200, Benny Halevy wrote:
>> I agree this is probably the cleanest implementation but when Boaz and I
>> initially discussed this approach he convinced me that LL block devices assume
>> that req->cmd_len <= BLK_MAX_CDB and it is unsafe at the moment to expose them
>> potentially larger commands.
> 
> We'll never submit a command to a low level driver that is longer than
> the max_cmd_len in the Scsi_Host.  So if they've set it higher than they
> really can deal with, that's an easy bug to fix.
> 
This is true for scsi devices, and is what I did in patches 1/4 + 3/4, but
for none-scsi, block devices, there is not such a ".max_cmd_len".
There are no clients of large commands that are not scsi, so there is no
use fixing any of that. The pointer at request is for the scsi case only.
(Or can be used by new code for additional private command info)

Boaz

