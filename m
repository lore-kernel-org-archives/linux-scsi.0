From: Dan Carpenter <dan.carpenter@oracle.com>
Subject: Re: [patch] iscsi-target: remove some dead code
Date: Thu, 17 May 2012 13:26:23 +0300
Message-ID: <20120517102622.GM16984@mwanda>
References: <20120517070814.GD14660@elgon.mountain>
 <4FB4CBD0.8000503@bfs.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from acsinet15.oracle.com ([141.146.126.227]:33582 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761595Ab2EQKXF (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 17 May 2012 06:23:05 -0400
Content-Disposition: inline
In-Reply-To: <4FB4CBD0.8000503@bfs.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: walter harms <wharms@bfs.de>
Cc: "Nicholas A. Bellinger" <nab@linux-iscsi.org>, Andy Grover <agrover@redhat.com>, Jesper Juhl <jj@chaosbits.net>, Joern Engel <joern@logfs.org>, Roland Dreier <roland@kernel.org>, linux-scsi@vger.kernel.org, kernel-janitors@vger.kernel.org

On Thu, May 17, 2012 at 11:58:40AM +0200, walter harms wrote:
> 
> 
> Am 17.05.2012 09:08, schrieb Dan Carpenter:
> > Neither "acceptor_values" nor "proposer_values" can be NULL here.
> > Smatch complains because we are not allowed to pass NULL pointers to
> > strchr().
> > 
> > Also I removed a second later check for "!acceptor_values" because it
> > gets checked on the next line in the do while condition.
> > 
> > Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
> > ---
> > Compile tested only.  Please review carefully.
> > 
> > diff --git a/drivers/target/iscsi/iscsi_target_parameters.c b/drivers/target/iscsi/iscsi_target_parameters.c
> > index ad3b3c1..ed5241e 100644
> > --- a/drivers/target/iscsi/iscsi_target_parameters.c
> > +++ b/drivers/target/iscsi/iscsi_target_parameters.c
> > @@ -1037,13 +1037,6 @@ static char *iscsi_check_valuelist_for_support(
> >  			tmp2 = strchr(acceptor_values, ',');
> >  			if (tmp2)
> >  				*tmp2 = '\0';
> this looks like strchrnul(). I realy do not know is this supported inside the kernel ?
> 

It can't be NULL here.  Adding bogus checks is the wrong idea and
static checkers are right to ask about needless checks.

regards,
dan carpenter

