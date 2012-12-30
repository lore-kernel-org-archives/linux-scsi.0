From: Douglas Gilbert <dgilbert@interlog.com>
Subject: Re: [PATCH 0/2] Change type-2 dif to use rq embedded 32 byte cdb
Date: Sat, 29 Dec 2012 19:52:38 -0500
Message-ID: <50DF9056.5050908@interlog.com>
References: <201212191034.qBJAY3gk007148@d01av04.pok.ibm.com>
Reply-To: dgilbert@interlog.com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.infotech.no ([82.134.31.41]:56032 "EHLO smtp.infotech.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753587Ab2L3Awm (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 29 Dec 2012 19:52:42 -0500
In-Reply-To: <201212191034.qBJAY3gk007148@d01av04.pok.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Scott Guthridge <guthridg@us.ibm.com>
Cc: linux-scsi@vger.kernel.org

On 12-12-19 05:34 AM, Scott Guthridge wrote:
> The patch we suggested where we simply changed BLK_MAX_CDB and MAX_COMMAND_SIZE from 16 to 32 was meant to be a "stick in the sand".  It's the simplest description of the functionality we're looking for.  Other approaches that accomplish the same thing would be fine.
>
> I don't know if the reason that "sd" went with the mempool for 32-byte commands was binary compatibility with modules, concerns about memory usage on small/embedded systems, or both.  But given that "sd" uses the mempool, it's reasonable to assume that greater than 16 byte pass-through requests might also take this approach.  A potential advantage of using a mempool or other dynamic allocation for the pass-through CDB is that it could be implemented to allow arbitrary CDB sizes, which would be more general than just increasing the fixed limit from 16 to 32.
>
>>> We did the mempool because we did not want to penalize everybody else by
>>> always allocating 32-byte CDBs. Type 2 is a really rare corner case.
>
> All of the SCSI drives we're seeing now come from the vendor formatted with PI type 2.  Linux automatically detects the format and uses PI, so it's no longer a corner case -- it's now the normal case.
>
> If you accept that dynamically allocated CDB's have become the rule rather than the exception, then it makes sense that the fixed size __cmd buffer in struct request should eventually be phased out.
>
> Two places in the kernel accept SG_IO (pass-through) requests.  One is the "sg" driver; the other (and the one we actually care about more) is scsi_cmd_ioctl in block/scsi_ioctl.c, which handles pass-through requests sent directly to an "sd" device.

Scott,
You overlooked the bsg driver which will allow you to issue
32 byte cdbs (and larger). It is probably about time I
submitted a patch to allow the sg driver to handle cdbs
larger than 16 bytes.

> What we are looking for is simply to be able to send 32-byte pass-through commands.  These commands do not have the  prot_op and prot_type fields of struct scsi_cmnd set, so from the perspective of the Linux SCSI subsystem and the adapter firmware, they are -not- PI I/O's.  But if a pass-through command sent to the device happened to be a 32-byte read with RDPROTECT=3, for example, then the drive will return the PI interleaved with the data -- it's this raw pass-through functionality that we need.  Conveniently, increasing the CDB size doesn't break binary compatibility with the existing sg_io_hdr_t.

If you follow the code for sg_write_same in sg3_utils (version 1.34)
there is a case in which the 32 byte cdb is issued. To work in Linux
it must take the path for bsg through my lower level library. That
will end up populating an instance of struct sg_io_v4 and sending
it to a bsg device node via the SG_IO ioctl.

You might also look at the examples/bsg_queue_tst.c file in the
sg3_utils tarball.

Doug Gilbert

