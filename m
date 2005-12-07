From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: [PATCH] OOPS due to clearing eh_action prior to aborting
	eh	command
Date: Wed, 07 Dec 2005 18:34:57 -0500
Message-ID: <1133998497.3898.4.camel@mulgrave>
References: <43975A8C.2030208@sgi.com> <1133993204.3303.46.camel@mulgrave>
	 <43975F24.4040904@sgi.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat9.steeleye.com ([209.192.50.41]:2019 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S1751812AbVLGXfK (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 7 Dec 2005 18:35:10 -0500
In-Reply-To: <43975F24.4040904@sgi.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Michael Reed <mdr@sgi.com>
Cc: linux-scsi@vger.kernel.org

On Wed, 2005-12-07 at 16:16 -0600, Michael Reed wrote: 
> FWIW, the situation I'm reporting isn't done after timeout, it's
> the scsi error handler calling the LLDD abort routine, which actually
> aborts the command and completes it.  The eh_action is cleared before
> the abort, violating what appears to be the accepted protocol of having
> the LLDD complete aborted commands.
> 
> Am I missing something in your comment?  (It wouldn't surprise me!)

The timeout race still exists, though.  Both fixes would solve both
problems. It would just be easier to follow if the logic of the error
handler done follows that of the normal done function (i.e. don't do
anything after the command times out).

James


