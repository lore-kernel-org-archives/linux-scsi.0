From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH 05 of 16] Block layer data integrity
Date: Tue, 06 May 2008 21:56:43 -0400
Message-ID: <yq1d4nyyizo.fsf@sermon.lab.mkp.net>
References: <patchbomb.1209165122@sermon.lab.mkp.net>
	<26ccaf2ccdc5548c4c9f.1209165127@sermon.lab.mkp.net>
	<20080506202909.GA25904@us.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from rgminet01.oracle.com ([148.87.113.118]:15634 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751649AbYEGB4y (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 6 May 2008 21:56:54 -0400
Received: from agmgw1.us.oracle.com (agmgw1.us.oracle.com [152.68.180.212])
	by rgminet01.oracle.com (Switch-3.2.4/Switch-3.1.6) with ESMTP id m471uq7v000510
	for <linux-scsi@vger.kernel.org>; Tue, 6 May 2008 19:56:52 -0600
Received: from acsmt355.oracle.com (acsmt355.oracle.com [141.146.40.155])
	by agmgw1.us.oracle.com (Switch-3.2.0/Switch-3.2.0) with ESMTP id m46NElpJ029308
	for <linux-scsi@vger.kernel.org>; Tue, 6 May 2008 19:56:52 -0600
In-Reply-To: <20080506202909.GA25904@us.ibm.com> (malahal@us.ibm.com's message of "Tue\, 6 May 2008 13\:29\:09 -0700")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

>>>>> "Malahal" == malahal  <malahal@us.ibm.com> writes:

Malahal> Martin K. Petersen [martin.petersen@oracle.com] wrote:
>> */ blk_partition_remap(bio);
>> 
>> + if (bio_integrity_enabled(bio) && bio_integrity_prep(bio)) + goto
>> end_io;
>> +
>> if (old_sector != -1) blk_add_trace_remap(q, bio, old_dev,
>> bio->bi_sector, old_sector);

Malahal> It is expected that the bio's data should NOT be changed
Malahal> until this I/O is sent out to the HBA for WRITES. How do you
Malahal> ensure that applications or file systems don't modify the
Malahal> data of a bio that is in progress?

As I mentioned on dm-devel a few weeks ago it's a big problem for ext2
in particular due to lack of locking the page down while I/O is in
flight.  So ext2 fails spectacularly.

I have been unable to trip XFS and btrfs.  I had one mismatch with
ext3 but that might have been something else.  In any case I have not
been able to reproduce it.  Even with artificially induced delays in
queuecommand.

But generally, yes.  It is up to the submitter to guarantee that the
page isn't being modified during I/O.  This requirement will trickle
all the way to the top of the stack for things like direct I/O.

-- 
Martin K. Petersen	Oracle Linux Engineering

