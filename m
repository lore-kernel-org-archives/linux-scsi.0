From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: target: Fix excessive stack usage
Date: Fri, 07 Jan 2011 12:55:30 -0800
Message-ID: <1294433730.2895.135.camel@haakon2.linux-iscsi.org>
References: <1294187361.7879.21.camel@mulgrave.site>
	 <201101071732.27612.eike-kernel@sf-tec.de>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.linux-iscsi.org ([67.23.28.174]:53442 "EHLO
	linux-iscsi.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751760Ab1AGVB3 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 7 Jan 2011 16:01:29 -0500
In-Reply-To: <201101071732.27612.eike-kernel@sf-tec.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Rolf Eike Beer <eike-kernel@sf-tec.de>
Cc: James Bottomley <James.Bottomley@suse.de>, linux-scsi <linux-scsi@vger.kernel.org>

On Fri, 2011-01-07 at 17:32 +0100, Rolf Eike Beer wrote:
> James Bottomley wrote:
> 
> > @@ -1870,6 +1870,10 @@ static int __core_scsi3_update_aptpl_buf(
> >  				"No Registrations or Reservations\n");
> >  		return 0;
> >  	}
> > +	tmp = kmalloc(1024, GFP_KERNEL);
> > +	if (!tmp)
> > +		return -1;
> 
> Shouldn't this return useful errorcodes all over the place instead of just -1? 
> Like -ENOMEM?
> 

Hi Eike,

So I ended up dropping this allocation from James' original patch in
favour of shrinking the local stack usage for tmp from 1024 to 512 bytes
in order to avoid the extra kmalloc() here..

However there are still a number of cases in target_core_pr.c code where
we 'return -1' to signal a failure.  This was originally because these
failures never get propagated to any code that makes sense of errno, and
all of the conditional checks are looking for a non zero return.

So IMHO changing this does not provide much benefit, but I would still
accept a patch if you are interested.  ;)

Best,

--nab


