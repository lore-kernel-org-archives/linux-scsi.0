From: Luben Tuikov <luben_tuikov@adaptec.com>
Subject: Re: BUG: CD driver sends command during host removal
Date: Wed, 29 Sep 2004 17:20:31 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <415B271F.7080902@adaptec.com>
References: <Pine.LNX.4.44L0.0409291452120.1700-100000@ida.rowland.org><1096487461.2028.134.camel@mulgrave> <20040929203104.GB6179@us.ibm.com><1096490471.2028.140.camel@mulgrave>  <20040929210751.GC6179@us.ibm.com> <1096492496.1762.148.camel@mulgrave>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from magic.adaptec.com ([216.52.22.17]:30855 "EHLO magic.adaptec.com")
	by vger.kernel.org with ESMTP id S269056AbUI2VUr (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 29 Sep 2004 17:20:47 -0400
In-Reply-To: <1096492496.1762.148.camel@mulgrave>
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: Mike Anderson <andmike@us.ibm.com>, Alan Stern <stern@rowland.harvard.edu>, SCSI development list <linux-scsi@vger.kernel.org>, Mohammed Sameer <uniball@gmx.net>, USB users list <linux-usb-users@lists.sourceforge.net>

James Bottomley wrote:
> On Wed, 2004-09-29 at 17:07, Mike Anderson wrote:
>  > ok, thanks for the clarification. Your previous statement seemed to 
> imply
>  > once scsi_remove_host was called the LLDD had no responsibility for
>  > calling done on commands sent to the LLDDs queuecommand.
> 
> Hang on a minute, there are two cases:
> 
> Existing in-flight commands:
> 
> Here, either the LLD returns done on them or the mid-layer will cancel
> them during the invocation of scsi_remove_host().  In the latter case,
> the LLD doesn't need to call done on them.

Is it possible that there could be a slight race when
the LLDD starts calling scsi_done() on pending commands,
_after_ it has called scsi_remove_host()?

BTW, why have/leave two alternate paths for this behavior?
This may bite us back in the future when things get more
complicated, i.e. dealing with more complicated devices,
transports, etc.

> New Commands going down into queuecommand:
> 
> These the LLD must error out (by returning done with an error status).

Right at queuecommand() invocation.

	Luben


>  > So now that this thread and the other thread related to similar
>  > shutdown issues has grown long is the next step to see if we can get the
>  > usb queuecommand to return DID_NO_CONNECT in this shutdown case.
> 
> Yes, that sounds correct.
> 
> James
> 
> 

