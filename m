From: Matthew Wilcox <matthew@wil.cx>
Subject: Re: [PATCH] Add support for asynchronous scans to libata
Date: Mon, 11 Dec 2006 09:09:45 -0700
Message-ID: <20061211160945.GC21070@parisc-linux.org>
References: <20061208211236.GC29763@parisc-linux.org> <457D800E.5070908@pobox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from palinux.external.hp.com ([192.25.206.14]:33210 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S936965AbWLKQJq (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 11 Dec 2006 11:09:46 -0500
Content-Disposition: inline
In-Reply-To: <457D800E.5070908@pobox.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jeff Garzik <jgarzik@pobox.com>
Cc: linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org

On Mon, Dec 11, 2006 at 10:58:06AM -0500, Jeff Garzik wrote:
> The time-consuming portion already takes place in a thread.  Do you mean 
> multiple threads?  Or, ATA's scan is in one thread, while work continues 
> in other threads?
> 
> Patch seems sane, provided that I am educated a bit :)

Each host will be scanned in its own thread.  So boot-up and
initialisation of other devices (eg, USB, networking, PS/2, etc) will
continue.  Drive ordering and numbering is maintained, and the default
configuration right now is to not enable this feature.

We have infrastructure in place to make sure that all discs are found
before we try to start init or autorun RAID.  If there's anywhere we're
missing a call to scsi_complete_async_scans(), it'll affect SCSI as much
as it will IDE, and I'm extremely interested in fixing it.

