From: "Randy.Dunlap" <rddunlap@osdl.org>
Subject: Re: BUG: SCSI SYNCHRONIZE_CACHE on driver unload
Date: Thu, 5 Aug 2004 15:48:26 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040805154826.633ff4cd.rddunlap@osdl.org>
References: <4112BC7A.1040102@rtr.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from fw.osdl.org ([65.172.181.6]:5339 "EHLO mail.osdl.org")
	by vger.kernel.org with ESMTP id S267756AbUHEXJn (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 5 Aug 2004 19:09:43 -0400
In-Reply-To: <4112BC7A.1040102@rtr.ca>
List-Id: linux-scsi@vger.kernel.org
To: Mark Lord <lkml@rtr.ca>
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org

On Thu, 05 Aug 2004 19:02:18 -0400 Mark Lord wrote:

| On module removal of a SCSI Low-Level Driver (LLD),
| the mid-layer tries to do a SYNCHRONIZE_CACHE
| command to each device on each host of that driver.
| 
| But the command is issued *after* setting SHOST_CANCEL,
| which means that scsi_dispatch_cmd() will *always*
| fail the command inline, without passing to the LLD.
| 
| This bug shows up only for hosts/drives which support
| a write-back caching scheme.  For the more common
| write-thru scheme, the SYNCHRONIZE_CACHE command is
| never issued, so the bug never manifests.

Like this, when I unmount a zip drive (?):

Synchronizing SCSI cache for disk sde: <4>FAILED
  status = 0, message = 00, host = 1, driver = 00

--
~Randy
