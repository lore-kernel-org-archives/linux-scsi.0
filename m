From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: UNMAP command parameter list
Date: Mon, 10 Nov 2014 11:44:39 -0500
Message-ID: <yq17fz36m4o.fsf@sermon.lab.mkp.net>
References: <loom.20141108T001847-741@post.gmane.org>
	<94D0CD8314A33A4D9D801C0FE68B40295937B4CE@G4W3202.americas.hpqcorp.net>
	<loom.20141108T211736-836@post.gmane.org>
	<loom.20141110T164410-58@post.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:30198 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751973AbaKJQoq (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 10 Nov 2014 11:44:46 -0500
In-Reply-To: <loom.20141110T164410-58@post.gmane.org> (Andras Kovacs's message
	of "Mon, 10 Nov 2014 15:56:11 +0000 (UTC)")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andras Kovacs <akovacs@fixstars.com>
Cc: linux-scsi@vger.kernel.org

>>>>> "Andras" == Andras Kovacs <akovacs@fixstars.com> writes:

>> Thank you. Then I guess I'll find the Paramerer List in the struct
>> scsi_data_buffer sdb variable (within struct scsi_cmnd). Will check
>> on Monday.

Andras> I've looked into it, but struct scsi_data_buffer doesn't contain
Andras> a byte array (rather a struct sg_table variable and some
Andras> housekeeping vars). So my question is still: where can I find
Andras> the Parameter List associated with a particular UNMAP command?

You'll have to traverse scatterlist and extract the descriptor from
there. You can use scsi_for_each_sg() to walk the list.

If you only care about in-kernel discards it's pretty easy since we only
issue a single descriptor. If you want to support arbitrary block pc
UNMAP commands you'll have to be able to deal with multiple descriptors
across multiple scatterlist elements. But the accessor macro makes that
easy so I suggest you take that approach.

-- 
Martin K. Petersen	Oracle Linux Engineering
