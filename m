From: Nishanth Aravamudan <nacc@us.ibm.com>
Subject: Re: [PATCH] scsi_debug [was: scsi_debug issues]
Date: Mon, 18 Oct 2004 16:23:52 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20041018232352.GA4747@us.ibm.com>
References: <20041015190154.GA3073@us.ibm.com> <4170C505.3000805@torque.net> <1097932370.1962.4.camel@mulgrave> <4173C8DB.8030009@torque.net> <20041018183747.GA3530@us.ibm.com> <41743E41.8020707@torque.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e6.ny.us.ibm.com ([32.97.182.106]:5100 "EHLO e6.ny.us.ibm.com")
	by vger.kernel.org with ESMTP id S267792AbUJRXYS (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 18 Oct 2004 19:24:18 -0400
Content-Disposition: inline
In-Reply-To: <41743E41.8020707@torque.net>
List-Id: linux-scsi@vger.kernel.org
To: Douglas Gilbert <dougg@torque.net>
Cc: James Bottomley <James.Bottomley@SteelEye.com>, SCSI Mailing List <linux-scsi@vger.kernel.org>, hch@infradead.org

On Tue, Oct 19, 2004 at 08:05:53AM +1000, Douglas Gilbert wrote:
> Nishanth Aravamudan wrote:
> >On Mon, Oct 18, 2004 at 11:44:59PM +1000, Douglas Gilbert wrote:
> >
> >>James Bottomley wrote:
> >>
> >>>On Sat, 2004-10-16 at 01:51, Douglas Gilbert wrote:
> >>>
> >>>
> >>>>So this problem seems related to highmem.
> >
> >
> ><snip>
> >
> >>The above required a fair few changes to scsi_debug.
> >>Attached is a patch that rolls "kmap" changes with
> >>patches I have sent recently for scsi_debug.
> >>Attachment is gzipped (due to size) and applies against
> >>lk 2.6.8.1 -> lk 2.6.9-rc4 .
> >>
> >>Nishanth, could you test this with highmem?
> >
> >
> >Doug,
> >
> >I ran 2.6.9-rc4 with your patch applied and had several dump_stack()s
> >occur (complaining about sleeping in an invalid context) and a final
> >panic during mkfs :) I think something is still wrong... ;) Output is
> >below and attached.
> 
> Ok, it looks like kmap_atomic() is needed.
> Could you try this additional patch.

Great! That patch seems to have fixed it. I am able to vi files, sync
the scsi_debug 'disks' and not have any hangs. It is noticeably slower,
though, it seems. Might that just be a side effect of the atomic calls?

Thanks again!

-Nish
