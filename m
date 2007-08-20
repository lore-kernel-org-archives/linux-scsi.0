From: Matthew Wilcox <matthew@wil.cx>
Subject: Re: [Patch] plug async scan race at 1st node scan
Date: Mon, 20 Aug 2007 07:49:19 -0600
Message-ID: <20070820134918.GC30019@parisc-linux.org>
References: <1187615436.3897.5.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from palinux.external.hp.com ([192.25.206.14]:33755 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753570AbXHTNtU (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 20 Aug 2007 09:49:20 -0400
Content-Disposition: inline
In-Reply-To: <1187615436.3897.5.camel@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Smart <James.Smart@Emulex.Com>
Cc: linux-scsi@vger.kernel.org, tore@linpro.no

On Mon, Aug 20, 2007 at 09:10:35AM -0400, James Smart wrote:
> In testing 2.6.23-rc3, there is a small window where the async-per-target
> scan of the transport can beat the call from the LLDD to scsi_scan_host().

I'd assumed that events wouldn't come in until ->scan_start was called.
I see lpfc doesn't have one; is it possible to restructure it to have one?

(In any case, good job tracking this down; it was really annoying me.)

Possibly we should be less forgiving, and require drivers to have a
scan_start, otherwise they can't avoid this race.

-- 
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
