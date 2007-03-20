From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: [PATCH] correct SCSI_WAIT_SCAN selection for non-modular
	SCSI_SCAN_ASYNC builds.
Date: Tue, 20 Mar 2007 14:32:33 -0500
Message-ID: <1174419153.3522.41.camel@mulgrave.il.steeleye.com>
References: <20070320185632.GB22866@dmccrory-d810.qlogic.org>
	 <1174417867.3522.35.camel@mulgrave.il.steeleye.com>
	 <20070320191940.GB23330@dmccrory-d810.qlogic.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from hancock.steeleye.com ([71.30.118.248]:49126 "EHLO
	hancock.sc.steeleye.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750991AbXCTTco (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 20 Mar 2007 15:32:44 -0400
In-Reply-To: <20070320191940.GB23330@dmccrory-d810.qlogic.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andrew Vasquez <andrew.vasquez@qlogic.com>
Cc: Linux SCSI Mailing List <linux-scsi@vger.kernel.org>

On Tue, 2007-03-20 at 12:19 -0700, Andrew Vasquez wrote:
> SCSI_SCAN_ASYNC was compiled non-modularly before merging the latest
> scsi-misc-2.6.git tree.  After the merge, and a rebuild of the kernel,
> was getting 'unknown symbol' failures during link as SCSI_WAIT_SCAN
> was now forced to be built as a module.  'select'ion of SCSI_WAIT_SCAN
> based on SCSI_SCAN_SYNC (a consumer) appeared to be the most natural
> way to address the problem.

There's something else going on here.  The only piece of code in the
entire tree that depends on SCSI_SCAN_ASYNC is this one (in
scsi_scan.c):

#ifdef CONFIG_SCSI_SCAN_ASYNC
#define SCSI_SCAN_TYPE_DEFAULT "async"
#else
#define SCSI_SCAN_TYPE_DEFAULT "sync"
#endif

There should be no way that setting this parameter to Y or N can have
the effects you describe ... could you debug a bit further?

Is MODULE set to 'n'?  It looks like the symbol export is guarded by
#ifdef MODULE for some reason ... other than that, I can't explain this.

Thanks,

James


