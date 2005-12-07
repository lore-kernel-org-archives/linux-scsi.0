From: Michael Reed <mdr@sgi.com>
Subject: Re: [PATCH] OOPS due to clearing eh_action prior to aborting eh	command
Date: Wed, 07 Dec 2005 16:16:04 -0600
Message-ID: <43975F24.4040904@sgi.com>
References: <43975A8C.2030208@sgi.com> <1133993204.3303.46.camel@mulgrave>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from omx3-ext.sgi.com ([192.48.171.20]:62143 "EHLO omx3.sgi.com")
	by vger.kernel.org with ESMTP id S1030390AbVLGWQH (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 7 Dec 2005 17:16:07 -0500
In-Reply-To: <1133993204.3303.46.camel@mulgrave>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: linux-scsi@vger.kernel.org



James Bottomley wrote:
> On Wed, 2005-12-07 at 15:56 -0600, Michael Reed wrote:
>> During my testing of fc transport attributes for the mpt fusion
>> driver, I came upon this OOPS.  (Actually, I've come upon it
>> too many times.  :(  )
>>
>> Attached is a patch which addresses the issue.  Please give it a look.
> 
> Isn't a better patch simply to copy the eh_action and check it for null
> before completing it?  That will close the done after timeout race.

FWIW, the situation I'm reporting isn't done after timeout, it's
the scsi error handler calling the LLDD abort routine, which actually
aborts the command and completes it.  The eh_action is cleared before
the abort, violating what appears to be the accepted protocol of having
the LLDD complete aborted commands.

Am I missing something in your comment?  (It wouldn't surprise me!)

Thanks,
 Mike
