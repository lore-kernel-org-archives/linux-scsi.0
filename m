From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH 1/5] SCSI: Add support for 32-byte CDBs
Date: Wed, 09 Sep 2009 00:31:10 -0400
Message-ID: <yq18wgo4u41.fsf@sermon.lab.mkp.net>
References: <1252053394-24886-1-git-send-email-martin.petersen@oracle.com>
	<1252053394-24886-2-git-send-email-martin.petersen@oracle.com>
	<4AA395E8.8020300@panasas.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from acsinet11.oracle.com ([141.146.126.233]:23432 "EHLO
	acsinet11.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751094AbZIIEbQ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 9 Sep 2009 00:31:16 -0400
In-Reply-To: <4AA395E8.8020300@panasas.com> (Boaz Harrosh's message of "Sun,
	06 Sep 2009 13:58:48 +0300")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Boaz Harrosh <bharrosh@panasas.com>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org

>>>>> "Boaz" == Boaz Harrosh <bharrosh@panasas.com> writes:

Boaz> Again, This might have a potential live-lock problem as we've seen
Boaz> a few times in the passed. Two threads are fighting between the
Boaz> allocation of a command+sense and here, each one is able to
Boaz> allocate one part but not the second. This is why command+sense is
Boaz> needed to be allocated atomically, and fail as a whole.

Boaz> I think you need to move this check and allocation to
Boaz> scsi_host_alloc_command().

It's not that simple.

Originally I wanted to do the allocation at the block layer to avoid
wasting the existing 16 byte command array.  I did this by moving
__cmd[] to the end of struct request.  I had a queue flag (set by sd.c)
that would toggle between blk_request_16 and blk_request_32 pools.

However, there are several places where we allocate a struct request
statically or on the stack, and those assume that it has a fixed size.
The patch that attempted to clean up this stuff grew bigger and bigger.
Next hurdle was finding corner cases that zeroed out struct request,
zapping the 16/32 flag in the process and subsequently leading to
de-allocation failures.  Eventually Jens recommended that I abandon that
idea and just do it in SCSI for now.  It seemed that the block approach
was more effort than it was worth.

Doing the allocation in SCSI opens up another set of problems, however.
Namely the host free_list.  Things are going to blow up if we mix 16 and
32-byte CDBs.  So that means switching all DIF Type 2-capable scsi_hosts
to 32-byte CDBs wholesale.  Or we can postpone such a switch until a
Type 2 target is discovered and then empty free_list and make all
subsequent commands bigger.  Or we could have a separate list +
scsi_host_cmd_pool that we allocate from if it's a Type 2 dev.  That
requires passing the scsi_device info through to the allocation
routines.  Right now they are scsi_host centric.

I tried several approaches, none of which ended up being very small, nor
pretty.

There's less than a handful of Type 2 devices out there.  No array
vendor I know of plan to support Type 2 on the host side, only on the
back end.  DIF disk drives will ship formatted with Type 1.  The main
intent with my patch was to ensure that a Type 2 drive would work if you
pulled it from an array and hooked it up directly.

Short of bumping BLK_MAX_CDB to 32 the patch I posted a few days was by
far the least intrusive solution.  It only causes an allocation for FS
requests, and only for Type 2 drives, and only if the HBA supports DIF
Type 2.

I've had a several requests for Type 2 support in Linux (mainly for
target device testing) so I wanted to get some code out there.  But I'm
happy to spend more time on the various approaches if people feel that's
justified.  I'd just like to know which one before I burn more cycles.
So far it's been a huge time sink.

James: What's your take on this?


Boaz> BTW: I think I found a bug in __scsi_get_command() in regard to:
Boaz> 	"scsi_host_get_prot(shost) >= SHOST_DIX_TYPE0_PROTECTION"

Boaz> this here will reset the cmd->prot_sdb pointer, which will leak
Boaz> eventually. And will be missing for this operation.

Good spotting!  Will fix.

-- 
Martin K. Petersen	Oracle Linux Engineering
