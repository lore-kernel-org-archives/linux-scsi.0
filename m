From: Tom Coughlan <coughlan@redhat.com>
Subject: Re: [linux-iscsi-devel] [question] deferred sense
Date: Thu, 06 Jan 2005 11:37:57 -0500
Message-ID: <1105029477.20393.187.camel@bianchi.boston.redhat.com>
References: <41DB21D7.5080904@us.ibm.com> <20050104234700.GA18343@visi.com>
	 <20050105092144.GB26793@lst.de> <20050105152112.GA8472@visi.com>
	 <20050105152333.GA1453@lst.de>  <1104943469.3997.8.camel@mulgrave>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:39869 "EHLO mx1.redhat.com")
	by vger.kernel.org with ESMTP id S262914AbVAFQnY (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 6 Jan 2005 11:43:24 -0500
In-Reply-To: <1104943469.3997.8.camel@mulgrave>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: Christoph Hellwig <hch@lst.de>, "Scott M. Ferris" <sferris@acm.org>, Mike Christie <mikenc@us.ibm.com>, linux-iscsi-devel <linux-iscsi-devel@lists.sourceforge.net>, SCSI Mailing List <linux-scsi@vger.kernel.org>

On Wed, 2005-01-05 at 11:44, James Bottomley wrote:
> On Wed, 2005-01-05 at 16:23 +0100, Christoph Hellwig wrote:
> > On Wed, Jan 05, 2005 at 09:21:12AM -0600, Scott M. Ferris wrote:
> > > To be more specific, there were some devices that would fail a command
> > > and return deferred sense.  The command didn't complete at the target,
> > > and the kernel wasn't retrying it because the sense was deferred
> > > rather than current.  For those devices, the translation produced the
> > > desired retry.
> > 
> > Do you remember these devices?  Might be worth adding a midlayer
> > blacklist entry for them.
> 
> That's certainly possible ... although we'd need a lot more details.
> Any device that returns deferred sense for a current error is pretty
> badly broken according to the spec.

If a current command returns deferred sense, the SCSI spec. requires
that the current command shall not have been executed [1]. So, if at
some point in the past the kernel did not retry a current command that
returned deferred sense, the iscsi folks would have forced the retry by
converting deferred sense to current sense. The scenario does not
require a device that is working incorrectly.

The big flaw in what iscsi did is the case where the deferred sense
indicates a non-fatal error. In that case, iscsi converts it to current,
the mitlayer examines it and determines that it does not require a
retry. This causes the current command to complete to the application
even though it was not executed by the device. 

It looks to me as though the 2.4 iscsi driver is susceptible to this. It
is probably not seen in practice because disk devices that return
non-fatal deferred sense are rare (it probably requires the PER bit set
in the error recovery mode page?). Anyone know for sure?

[1] If the task terminates with CHECK CONDITION status and the sense
data describes a deferred error the command for the terminated task
shall not have been processed. (SPC-3) 


