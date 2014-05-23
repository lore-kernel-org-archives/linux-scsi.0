From: Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: dangling pointers and/or reentrancy in scmd_eh_abort_handler?
Date: Fri, 23 May 2014 11:22:13 +0200
Message-ID: <537F1345.5030704@redhat.com>
References: <537A105B.4080504@redhat.com> <537A1E88.9080803@acm.org> <537A2CB8.9060302@redhat.com> <537A34C6.7090905@acm.org> <loom.20140521T161608-391@post.gmane.org> <537D0DC9.5010900@redhat.com> <94D0CD8314A33A4D9D801C0FE68B402956F3F758@G9W0745.americas.hpqcorp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:40566 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751178AbaEWJWU (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 23 May 2014 05:22:20 -0400
In-Reply-To: <94D0CD8314A33A4D9D801C0FE68B402956F3F758@G9W0745.americas.hpqcorp.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Elliott, Robert (Server Storage)" <Elliott@hp.com>, Mark Wu <wudx05@gmail.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

Il 23/05/2014 03:28, Elliott, Robert (Server Storage) ha scritto:
> Depending on the transport, there may be a race condition between
> the command status and the ABORT TASK response; the ABORT TASK
> response might get back first.  I think that means
> scsi_eh_abort_handler's call to scsi_finish_command could
> happen during or after scsi_softirq_done has called
> scsi_finish_command.

That was my doubt, in fact.  But actually Bart explained that this is 
not the case.  Either scsi_eh_abort_handler will be called via the work 
item, or the command will never be sent to the softirq.

Paolo

