From: Mike Anderson <andmike@us.ibm.com>
Subject: Re: Need help with another aic94xx sequencer problem
Date: Tue, 22 Aug 2006 16:58:20 -0700
Message-ID: <20060822235820.GA19794@us.ibm.com>
References: <1156278519.19615.31.camel@mulgrave.il.steeleye.com> <20060822205315.GA16638@us.ibm.com> <1156286656.21487.0.camel@mulgrave.il.steeleye.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e6.ny.us.ibm.com ([32.97.182.146]:49592 "EHLO e6.ny.us.ibm.com")
	by vger.kernel.org with ESMTP id S1750747AbWHVX7u (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 22 Aug 2006 19:59:50 -0400
Received: from d01relay04.pok.ibm.com (d01relay04.pok.ibm.com [9.56.227.236])
	by e6.ny.us.ibm.com (8.12.11.20060308/8.12.11) with ESMTP id k7MNxkEe029082
	for <linux-scsi@vger.kernel.org>; Tue, 22 Aug 2006 19:59:46 -0400
Received: from d01av03.pok.ibm.com (d01av03.pok.ibm.com [9.56.224.217])
	by d01relay04.pok.ibm.com (8.13.6/8.13.6/NCO v8.1.1) with ESMTP id k7MNxmY2275044
	for <linux-scsi@vger.kernel.org>; Tue, 22 Aug 2006 19:59:49 -0400
Received: from d01av03.pok.ibm.com (loopback [127.0.0.1])
	by d01av03.pok.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id k7MNxmqU020747
	for <linux-scsi@vger.kernel.org>; Tue, 22 Aug 2006 19:59:48 -0400
Content-Disposition: inline
In-Reply-To: <1156286656.21487.0.camel@mulgrave.il.steeleye.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: "Tarte, Robert" <Robert_Tarte@adaptec.com>, "Hammer, Jack" <Jack_Hammer@adaptec.com>, linux-scsi <linux-scsi@vger.kernel.org>

James Bottomley <James.Bottomley@HansenPartnership.com> wrote:
> On Tue, 2006-08-22 at 13:53 -0700, Mike Anderson wrote:
> > Does this help any? While Alexis and I where working on a expander timeout
> > issue the abort was never working for us. I compared the adp abort and the
> > aic94xx abort code and made these changes. This appears to make the abort
> > work for us now. A few lines of the changes are not related to the abort.
> > YMMV, a better solution would be to know the exact format of the abort.
> 
> Actually, no.  I still seem to get the same problem (at least it BUGs in
> the same place ... I haven't dug down to see if I'm getting the same
> return value).

Well the adp driver had a comment that the 0x1D error code means that it
cannot find the command in its execution queue as it already has sent the
command to the target(if I mapped this right between the two drivers).
What looks odd is in the adp driver that move to a higher level of
recovery (i.e., lun reset) if they receive this code, but in the aic94xx
we mark the task TMF_RESP_FUNC_COMPLETE which appears wrong as you found
out with the BUG_ON.

-andmike
--
Michael Anderson
andmike@us.ibm.com
