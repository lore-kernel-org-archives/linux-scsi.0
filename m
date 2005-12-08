From: Michael Reed <mdr@sgi.com>
Subject: Re: [PATCH] OOPS due to clearing eh_action prior to aborting	eh	command
Date: Wed, 07 Dec 2005 20:31:56 -0600
Message-ID: <43979B1C.60400@sgi.com>
References: <43975A8C.2030208@sgi.com> <1133993204.3303.46.camel@mulgrave>	 <43975F24.4040904@sgi.com> <1133998497.3898.4.camel@mulgrave>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from omx2-ext.sgi.com ([192.48.171.19]:41682 "EHLO omx2.sgi.com")
	by vger.kernel.org with ESMTP id S932673AbVLHCcA (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 7 Dec 2005 21:32:00 -0500
In-Reply-To: <1133998497.3898.4.camel@mulgrave>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: linux-scsi@vger.kernel.org



James Bottomley wrote:
> On Wed, 2005-12-07 at 16:16 -0600, Michael Reed wrote: 
>> FWIW, the situation I'm reporting isn't done after timeout, it's
>> the scsi error handler calling the LLDD abort routine, which actually
>> aborts the command and completes it.  The eh_action is cleared before
>> the abort, violating what appears to be the accepted protocol of having
>> the LLDD complete aborted commands.
>>
>> Am I missing something in your comment?  (It wouldn't surprise me!)
> 
> The timeout race still exists, though.  Both fixes would solve both
> problems. It would just be easier to follow if the logic of the error
> handler done follows that of the normal done function (i.e. don't do
> anything after the command times out).

"Ah ha", he said.  Further examination of the code clarifies what you were
suggesting.  I'll see what I can work up.

Thanks,
 Mike
