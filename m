From: Mike Anderson <andmike@us.ibm.com>
Subject: Re: timeout during sas discovery (aic94xx)
Date: Tue, 29 Aug 2006 09:50:18 -0700
Message-ID: <20060829165018.GA11897@us.ibm.com>
References: <20060828231832.GA1037@us.ibm.com> <44F3D428.60705@us.ibm.com> <1156859623.3458.3.camel@mulgrave.il.steeleye.com> <20060829160307.GA11028@us.ibm.com> <1156868572.3458.25.camel@mulgrave.il.steeleye.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e31.co.us.ibm.com ([32.97.110.149]:19924 "EHLO
	e31.co.us.ibm.com") by vger.kernel.org with ESMTP id S965152AbWH2Qwx
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 29 Aug 2006 12:52:53 -0400
Received: from westrelay02.boulder.ibm.com (westrelay02.boulder.ibm.com [9.17.195.11])
	by e31.co.us.ibm.com (8.13.8/8.12.11) with ESMTP id k7TGqngv017289
	for <linux-scsi@vger.kernel.org>; Tue, 29 Aug 2006 12:52:49 -0400
Received: from d03av03.boulder.ibm.com (d03av03.boulder.ibm.com [9.17.195.169])
	by westrelay02.boulder.ibm.com (8.13.6/8.13.6/NCO v8.1.1) with ESMTP id k7TGqnik317938
	for <linux-scsi@vger.kernel.org>; Tue, 29 Aug 2006 10:52:49 -0600
Received: from d03av03.boulder.ibm.com (loopback [127.0.0.1])
	by d03av03.boulder.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id k7TGqmXU019821
	for <linux-scsi@vger.kernel.org>; Tue, 29 Aug 2006 10:52:49 -0600
Content-Disposition: inline
In-Reply-To: <1156868572.3458.25.camel@mulgrave.il.steeleye.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>, "Hammer, Jack" <Jack_Hammer@adaptec.com>
Cc: "Darrick J. Wong" <djwong@us.ibm.com>, linux-scsi@vger.kernel.org, alexisb@us.ibm.com

James Bottomley <James.Bottomley@SteelEye.com> wrote:
> On Tue, 2006-08-29 at 09:03 -0700, Mike Anderson wrote:
> > I think this failure mode is a different path than what your patch tries to
> > address. We sending a inquiry to the device and coming through the
> > standard IO path and not through sas_execute_task.
> > 
> > I still think for these cases that we need to be running the patch I
> > previous sent to the list to try and get the abort to work (this patch is
> > not in the git tree so one needs to add this on top of the git source).
> > This will not solve the timeout, but would at least address the tmf time
> > out.
> 
> OK ... I was waiting for Adaptec to comment on that one since it's
> messing with undocumented sequencer bits.  However, prove it works in
> this case and I can put it in.

ok, yes it would be good for Adaptec to comment on the proper format for
the abort_hscb as add I did was set the values to match what the adp
driver was doing as the aic94xx abort_task always timed out for our cases.

> 
> > We need to also address the first issue of the inquiry timeout. Previous
> > runs showed that we where hitting this error a lot on the inquiry to the
> > Vitesse SES device which the adp driver has created a work around (unclear
> > if the work around solves the issue or not).
> 
> What is the work around?

Link reset wait 4 seconds and then retry. Since this is a timeout on a
scan inquiry getting a retry to happen in scsi_probe_lun once the error
handler has started up will not be easy.

-andmike
--
Michael Anderson
andmike@us.ibm.com
