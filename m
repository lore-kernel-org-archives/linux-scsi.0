From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH 01/12] scsi_debug: cleanup naming and bit crunching
Date: Tue, 26 Apr 2016 11:27:35 -0700
Message-ID: <1461695255.2348.21.camel@HansenPartnership.com>
References: <1461600999-28893-1-git-send-email-dgilbert@interlog.com>
	 <1461600999-28893-2-git-send-email-dgilbert@interlog.com>
	 <571FAFD2.3030902@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:43542 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752119AbcDZS1o (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 26 Apr 2016 14:27:44 -0400
In-Reply-To: <571FAFD2.3030902@sandisk.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bart Van Assche <bart.vanassche@sandisk.com>, Douglas Gilbert <dgilbert@interlog.com>, linux-scsi@vger.kernel.org
Cc: martin.petersen@oracle.com, tomas.winkler@intel.com, emilne@redhat.com

On Tue, 2016-04-26 at 11:13 -0700, Bart Van Assche wrote:
> On 04/25/2016 09:16 AM, Douglas Gilbert wrote:
> > @@ -580,8 +580,8 @@ static int sdebug_sectors_per;		/
> > * sectors per cylinder */
> > 
> >   static unsigned int scsi_debug_lbp(void)
> >   {
> > -	return ((0 == scsi_debug_fake_rw) &&
> > -		(scsi_debug_lbpu | scsi_debug_lbpws |
> > scsi_debug_lbpws10));
> > +	return ((0 == sdebug_fake_rw) &&
> > +		(sdebug_lbpu | sdebug_lbpws | sdebug_lbpws10));
> >   }
> 
> Since you are changing this code, please remove the superfluous 
> parentheses, place the constant at the right side of the comparison 
> and change "|" into "||" since the intention of the above code is to
> perform a logical or and this code is not in a performance-critical
> path.

This is getting completely pointless.  We're not slaves to checkpatch
and the Maintainer has considerable leeway to decide the style for
their code.  I personally don't like the const == rvalue form of compar
ison, but it does pick up an erroneous '=' instead of '==', so I'm not
going to object to a maintainer who wishes to use it.

Plus, if you only alter it in one place, the file becomes a mess of
styles and thus harder to read.

James


