From: Luben Tuikov <ltuikov@yahoo.com>
Subject: Re: Need help with another aic94xx sequencer problem
Date: Thu, 24 Aug 2006 02:08:32 -0700 (PDT)
Message-ID: <20060824090832.37507.qmail@web31802.mail.mud.yahoo.com>
References: <20060822235820.GA19794@us.ibm.com>
Reply-To: ltuikov@yahoo.com
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from web31802.mail.mud.yahoo.com ([68.142.207.65]:14261 "HELO
	web31802.mail.mud.yahoo.com") by vger.kernel.org with SMTP
	id S1750964AbWHXJId (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 24 Aug 2006 05:08:33 -0400
In-Reply-To: <20060822235820.GA19794@us.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mike Anderson <andmike@us.ibm.com>, James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: "Tarte, Robert" <Robert_Tarte@adaptec.com>, "Hammer, Jack" <Jack_Hammer@adaptec.com>, linux-scsi <linux-scsi@vger.kernel.org>

--- Mike Anderson <andmike@us.ibm.com> wrote:
> James Bottomley <James.Bottomley@HansenPartnership.com> wrote:
> > On Tue, 2006-08-22 at 13:53 -0700, Mike Anderson wrote:
> > > Does this help any? While Alexis and I where working on a expander timeout
> > > issue the abort was never working for us. I compared the adp abort and the
> > > aic94xx abort code and made these changes. This appears to make the abort
> > > work for us now. A few lines of the changes are not related to the abort.
> > > YMMV, a better solution would be to know the exact format of the abort.
> > 
> > Actually, no.  I still seem to get the same problem (at least it BUGs in
> > the same place ... I haven't dug down to see if I'm getting the same
> > return value).
> 
> Well the adp driver had a comment that the 0x1D error code means that it
> cannot find the command in its execution queue as it already has sent the
> command to the target(if I mapped this right between the two drivers).
> What looks odd is in the adp driver that move to a higher level of
> recovery (i.e., lun reset) if they receive this code, but in the aic94xx
> we mark the task TMF_RESP_FUNC_COMPLETE which appears wrong as you found
> out with the BUG_ON.

There is much more to that. If you followed my previous email... SSP is
handled differently so you cannot just do LU Reset.  Depening on other
factors, you may or you may not.  If you always did then you're "error
recovery thrashing", and performance would suffer, so you might as well
use SATA...

    Luben


> 
> -andmike
> --
> Michael Anderson
> andmike@us.ibm.com
> -
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

