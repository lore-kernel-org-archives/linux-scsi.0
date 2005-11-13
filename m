From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: Bug#338089: New aic7xxx driver fails spectacularly on 2940UW
Date: Sun, 13 Nov 2005 12:21:26 -0600
Message-ID: <1131906086.3291.10.camel@mulgrave>
References: <20051113180358.35896.qmail@web88004.mail.re2.yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat9.steeleye.com ([209.192.50.41]:30900 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S1750730AbVKMSWO (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 13 Nov 2005 13:22:14 -0500
In-Reply-To: <20051113180358.35896.qmail@web88004.mail.re2.yahoo.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Graham Knap <graham.knap@rogers.com>
Cc: Doug Ledford <dledford@redhat.com>, Horms <horms@debian.org>, 338089@bugs.debian.org, linux-scsi@vger.kernel.org

On Sun, 2005-11-13 at 13:03 -0500, Graham Knap wrote:
> Doug Ledford <dledford@redhat.com> wrote:
> > You already said it didn't help with the problem, 
> 
> I meant that I don't think I successfully disabled DV, because the boot
> messages were *identical*, except for the line where the kernel shows
> the "Kernel command line".
> 
> I had added this argument at the end of the line:  aic7xxx=dv:{0}
> 
> I've re-read "aic7xxx.txt" and I'm not sure what I'm doing wrong. If
> you can tell me how to disable DV, I'd be happy to give it a try.

aic7xxx.txt is out of date.  The aic7xxx (and 79xx) drivers use the
generic domain validation code now rather than the old aic specific ones
(which is what the dv:{0} option is referring to).  If you try the code
in the prior email, I think that will disable the piece of DV that's
causing the problem.

If the test code succeeds, the problem is pretty nasty:  Apparently the
device claims DT support but in fact rejects DT in the negotiation.  We
use DT support to begin the check for an echo buffer, which starts with
READ_BUFFERS for the descriptor.  Apparently this device returns a valid
descriptor with a reasonable echo buffer size and then promptly throws a
wobbly when we try to use it.

James


