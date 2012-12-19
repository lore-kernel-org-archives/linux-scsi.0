From: Scott Guthridge <guthridg@us.ibm.com>
Subject: Re: [PATCH 0/2] Change type-2 dif to use rq embedded 32 byte cdb
Date: Wed, 19 Dec 2012 05:34:03 -0500
Message-ID: <201212191034.qBJAY3gk007148@d01av04.pok.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e7.ny.us.ibm.com ([32.97.182.137]:57396 "EHLO e7.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751049Ab2LSKe5 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 19 Dec 2012 05:34:57 -0500
Received: from /spool/local
	by e7.ny.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-scsi@vger.kernel.org> from <guthridg@us.ibm.com>;
	Wed, 19 Dec 2012 05:34:57 -0500
Received: from d01relay04.pok.ibm.com (d01relay04.pok.ibm.com [9.56.227.236])
	by d01dlp03.pok.ibm.com (Postfix) with ESMTP id 6DC27C9001C
	for <linux-scsi@vger.kernel.org>; Wed, 19 Dec 2012 05:34:54 -0500 (EST)
Received: from d01av04.pok.ibm.com (d01av04.pok.ibm.com [9.56.224.64])
	by d01relay04.pok.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id qBJAYs7g348328
	for <linux-scsi@vger.kernel.org>; Wed, 19 Dec 2012 05:34:54 -0500
Received: from d01av04.pok.ibm.com (loopback [127.0.0.1])
	by d01av04.pok.ibm.com (8.14.4/8.13.1/NCO v10.0 AVout) with ESMTP id qBJAYsKt010046
	for <linux-scsi@vger.kernel.org>; Wed, 19 Dec 2012 05:34:54 -0500
Received: from 9.80.5.232 ([9.80.5.232])
	by d01av04.pok.ibm.com (8.14.4/8.13.1/NCO v10.0 AVin) with SMTP id qBJAY3gk007148
	for linux-scsi@vger.kernel.org; Wed, 19 Dec 2012 05:34:39 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

The patch we suggested where we simply changed BLK_MAX_CDB and MAX_COMMAND_SIZE from 16 to 32 was meant to be a "stick in the sand".  It's the simplest description of the functionality we're looking for.  Other approaches that accomplish the same thing would be fine.

I don't know if the reason that "sd" went with the mempool for 32-byte commands was binary compatibility with modules, concerns about memory usage on small/embedded systems, or both.  But given that "sd" uses the mempool, it's reasonable to assume that greater than 16 byte pass-through requests might also take this approach.  A potential advantage of using a mempool or other dynamic allocation for the pass-through CDB is that it could be implemented to allow arbitrary CDB sizes, which would be more general than just increasing the fixed limit from 16 to 32.

>> We did the mempool because we did not want to penalize everybody else by
>> always allocating 32-byte CDBs. Type 2 is a really rare corner case.

All of the SCSI drives we're seeing now come from the vendor formatted with PI type 2.  Linux automatically detects the format and uses PI, so it's no longer a corner case -- it's now the normal case.

If you accept that dynamically allocated CDB's have become the rule rather than the exception, then it makes sense that the fixed size __cmd buffer in struct request should eventually be phased out.

Two places in the kernel accept SG_IO (pass-through) requests.  One is the "sg" driver; the other (and the one we actually care about more) is scsi_cmd_ioctl in block/scsi_ioctl.c, which handles pass-through requests sent directly to an "sd" device.

What we are looking for is simply to be able to send 32-byte pass-through commands.  These commands do not have the  prot_op and prot_type fields of struct scsi_cmnd set, so from the perspective of the Linux SCSI subsystem and the adapter firmware, they are -not- PI I/O's.  But if a pass-through command sent to the device happened to be a 32-byte read with RDPROTECT=3, for example, then the drive will return the PI interleaved with the data -- it's this raw pass-through functionality that we need.  Conveniently, increasing the CDB size doesn't break binary compatibility with the existing sg_io_hdr_t.

One could develop a more general pass-through command that gave the user access to the prot_op and prot_type fields and that provided a DIX style side-buffer to hold de-interleaved PI data.  That would be a nice extension, but it's not something we currently need.

Scott Guthridge
IBM Almaden Research Center

