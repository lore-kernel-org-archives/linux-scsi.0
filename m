From: Mike Anderson <andmike@us.ibm.com>
Subject: Re: Bad reactions to QUEUE FULL
Date: Wed, 30 Apr 2003 09:08:51 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030430160851.GA2350@beaverton.ibm.com>
References: <20030429220259.A13386@jose.vato.org> <1051714713.1818.32.camel@mulgrave>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e31.co.us.ibm.com ([32.97.110.129]:4533 "EHLO e31.co.us.ibm.com")
	by vger.kernel.org with ESMTP id S262352AbTD3PyK (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 30 Apr 2003 11:54:10 -0400
Content-Disposition: inline
In-Reply-To: <1051714713.1818.32.camel@mulgrave>
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@steeleye.com>
Cc: Tim Pepper <tpepper@vato.org>, SCSI Mailing List <linux-scsi@vger.kernel.org>, Jens Axboe <axboe@suse.de>, olh@suse.de

James Bottomley [James.Bottomley@steeleye.com] wrote:
> On Wed, 2003-04-30 at 00:02, Tim Pepper wrote:
> > Anybody interested in having a look at this or is it a known issue?
> 
> Actually, I'd be most interested in knowing what the problem is that the
> patch solves.
> 
> The "old" fields (and all inconsistently named) are designed to keep a
> copy of the original command for when the actual command gets re-used. 
> This re-use happens in the error handler (to get sense, send TURs etc)
> and sometimes in the device drivers if they simulate ACA).  Everything
> that replaces the command is supposed to copy the old one back after
> it's finished using it.
> 
> However, QUEUE FULL is a status return, not a sense code, so any command
> that gets QUEUE FULL should be an original command, and thus not need
> the fields replacing.  Even more curious, if the command were replaced,
> then more fields than just the data direction would need putting back.
> 
> A viable theory seems to be that the drivers (qlogic and emulex) change
> the sc_data_direction field for their own purposes and forget to restore
> it again.  I don't have the source, so I can't check this.
> 
> Does anyone have any other theories?
> 

Previously I have seen a failure similar to this. The signature of the
failure differs depending on which LLDD you are using, the types of
errors and possibly which kernel you are using (vendor, mainline, etc). 

The failure happens due to a command being re-enqueued for retry and
getting the SPECIAL flag set.  Then sometime later having this flag set
cause the code to make some assumptions which are not correct. The order
is important. 

One scenario is:

1.) During some error condition the LLDD returns a non-zero value from
queuecommand. This cause scsi_mlqueue_insert to be called.
scsi_mlqueue_insert calls scsi_insert_special_cmd which calls
__scsi_insert_special. __scsi_insert_special sets request cmd field to
SPECIAL. 

2.) Sometime later the LLDD queuecommand accepts the command, but
completes the IO with a non-good status.

3.) scsi_io_completion is eventually called on the IO. At the top of
scsi_io_completion we free the sg list. Now when this IO finally makes
it back to scsi_request_fn the SPECIAL flag will cause the IO to not get
scsi_init_io_fn called to allocate the sg list again.

The patch below is a hack to work around this one case, but there could
be other issues you are hitting.

-andmike
--
Michael Anderson
andmike@us.ibm.com

 scsi_lib.c |   11 +++++++++++
 1 files changed, 11 insertions(+)

--- linux-2.4/drivers/scsi/scsi_lib.c		Wed Apr 30 09:04:16 2003
+++ linux-2.4-p/drivers/scsi/scsi_lib.c		Wed Apr 30 09:04:17 2003
@@ -256,6 +256,17 @@
 	if (SCpnt != NULL) {
 
 		/*
+		 * This is a work around for a case where this Scsi_Cmnd
+		 * may have been through the busy retry paths already. We
+		 * clear the special flag and try to restore the
+		 * read/write request cmd value.
+		 */
+		if (SCpnt->request.cmd == SPECIAL)
+			SCpnt->request.cmd = 
+				(SCpnt->sc_data_direction ==
+				 SCSI_DATA_WRITE) ? WRITE : READ;
+
+		/*
 		 * For some reason, we are not done with this request.
 		 * This happens for I/O errors in the middle of the request,
 		 * in which case we need to request the blocks that come after

