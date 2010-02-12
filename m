From: James Bottomley <James.Bottomley@suse.de>
Subject: Re: [PATCH 06/11] qla4xxx: added srb referance counter
Date: Fri, 12 Feb 2010 13:19:08 -0500
Message-ID: <1265998748.4621.39.camel@mulgrave.site>
References: <20100130062856.GG10274@linux-qf4p> <4B671BFC.90107@cs.wisc.edu>
	 <20100211110852.GB8237@linux-qf4p>  <4B758FEC.9090407@cs.wisc.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:59383 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754056Ab0BLSTQ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 12 Feb 2010 13:19:16 -0500
In-Reply-To: <4B758FEC.9090407@cs.wisc.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mike Christie <michaelc@cs.wisc.edu>
Cc: Ravi Anand <ravi.anand@qlogic.com>, Linux-SCSI Mailing List <linux-scsi@vger.kernel.org>, Karen Higgins <karen.higgins@qlogic.com>, Vikas Chaudhary <vikas.chaudhary@qlogic.com>

On Fri, 2010-02-12 at 11:29 -0600, Mike Christie wrote:
> On 02/11/2010 05:08 AM, Ravi Anand wrote:
> > On Mon, 01 Feb 2010, Mike Christie wrote:
> >>
> >> On 01/30/2010 12:28 AM, Ravi Anand wrote:
> >>>
> >>> -		msleep(2000);
> >>> -	} while (max_wait_time--);
> >>> +		if (got_ref&&   (atomic_read(&rp->ref_count) == 1)) {
> >>> +			done++;
> >>> +			break;
> >>> +		}
> >>> +
> >>> +		msleep(ABORT_POLLING_PERIOD);
> >>
> >>
> >> Did you want to use krefs for the refcounting?
> >
> > We will add it to our to do list and submit a patch later on.
> > For right now we will like to stick to it as kref will require
> > additional testing.
> >
> 
> Please use krefs from the start. Other drivers like beiscsi have had to 
> switch from its own refcount code to krefs, and have had to retest their 
> patchsets. You have to change your code in some other patches and maybe 
> this one too, so you have to retest everything either way.

That goes for me too, please ... it's a standard kernel paradigm and all
the queries about what the refs were doing earlier would have been a lot
simpler since the embedded krefs would largely have answered the
questions.

James


