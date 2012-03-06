From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH 2/7] block: Implement support for WRITE SAME
Date: Tue, 06 Mar 2012 12:54:52 -0500
Message-ID: <yq1lindlimr.fsf@sermon.lab.mkp.net>
References: <1330658571-12958-1-git-send-email-martin.petersen@oracle.com>
	<1330658571-12958-3-git-send-email-martin.petersen@oracle.com>
	<20120302220823.GI26315@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from rcsinet15.oracle.com ([148.87.113.117]:19265 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755294Ab2CFRzF (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 6 Mar 2012 12:55:05 -0500
In-Reply-To: <20120302220823.GI26315@redhat.com> (Vivek Goyal's message of
	"Fri, 2 Mar 2012 17:08:23 -0500")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Vivek Goyal <vgoyal@redhat.com>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, jaxboe@fusionio.com, James.Bottomley@hansenpartnership.com, snitzer@redhat.com, michaelc@cs.wisc.edu, linux-scsi@vger.kernel.org

>>>>> "Vivek" == Vivek Goyal <vgoyal@redhat.com> writes:

Vivek> Thinking loud. Will it logically make sense to account for whole
Vivek> BIO (all the sectors and not just 1). Target device did the
Vivek> actual work of writing the sector. Just that we reduced the data
Vivek> transfer overhead.

We have absolutely no idea how much work the storage device will do. It
could be doing zero-detect or dedup causing it to update an internal
allocation map instead of actually writing out blocks. Or it could be
forced to do more I/O than we requested due to wear leveling or because
it is a RAID device which has to write out full stripes and parity
blocks.


Vivek> I thought it will make more sense to count WRITE_SAME towards
Vivek> number of sectors written and not DISCARDS. Not sure why it make
Vivek> sense to count discard sectors towards sectors written in
Vivek> disk/part stat.

But we're measuring page out activity, right?

In my mind the only thing we can reliably measure is the I/O we're
transmitting to or receiving from the device. So I'd personally like to
see zero for discard and logical block size for write same.

-- 
Martin K. Petersen	Oracle Linux Engineering
