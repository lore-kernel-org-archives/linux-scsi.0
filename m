From: Mike Christie <michaelc@cs.wisc.edu>
Subject: Re: [Patch] plug async scan race at 1st node scan
Date: Sat, 01 Mar 2008 05:44:29 -0600
Message-ID: <47C9419D.1040402@cs.wisc.edu>
References: <1187615436.3897.5.camel@localhost.localdomain> <20070820134918.GC30019@parisc-linux.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:46092 "EHLO sabe.cs.wisc.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750708AbYCALq1 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 1 Mar 2008 06:46:27 -0500
In-Reply-To: <20070820134918.GC30019@parisc-linux.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Matthew Wilcox <matthew@wil.cx>
Cc: James Smart <James.Smart@Emulex.Com>, linux-scsi@vger.kernel.org, tore@linpro.no

Matthew Wilcox wrote:
> On Mon, Aug 20, 2007 at 09:10:35AM -0400, James Smart wrote:
>> In testing 2.6.23-rc3, there is a small window where the async-per-target
>> scan of the transport can beat the call from the LLDD to scsi_scan_host().
> 
> I'd assumed that events wouldn't come in until ->scan_start was called.
> I see lpfc doesn't have one; is it possible to restructure it to have one?
> 
> (In any case, good job tracking this down; it was really annoying me.)
> 
> Possibly we should be less forgiving, and require drivers to have a
> scan_start, otherwise they can't avoid this race.
> 

I am hitting this problem with qla4xxx (added async scanning to 
2.6.25-rc). Was the final decision that we have to add a scan_start? I 
did not see scan_start be made mandatory and I did not see James's patch 
go in.
