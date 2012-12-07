From: Dan Carpenter <dan.carpenter@oracle.com>
Subject: Re: [patch] [SCSI] mpt3sas: cut and paste bug storing trigger mpi
Date: Fri, 7 Dec 2012 14:00:43 +0300
Message-ID: <20121207110043.GO22569@mwanda>
References: <20121207062801.GD18220@elgon.mountain>
 <953b00ff89996c4a3681b3c8f425462b@sf-mail.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:37117 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755813Ab2LGLA6 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 7 Dec 2012 06:00:58 -0500
Content-Disposition: inline
In-Reply-To: <953b00ff89996c4a3681b3c8f425462b@sf-mail.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Rolf Eike Beer <eike-kernel@sf-tec.de>
Cc: Nagalakshmi Nandigama <Nagalakshmi.Nandigama@lsi.com>, Sreekanth Reddy <Sreekanth.Reddy@lsi.com>, support@lsi.com, "James E.J. Bottomley" <JBottomley@parallels.com>, DL-MPTFusionLinux@lsi.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org

On Fri, Dec 07, 2012 at 09:41:56AM +0100, Rolf Eike Beer wrote:
> > 	memset(&ioc->diag_trigger_mpi, 0,
> >-	    sizeof(struct SL_WH_EVENT_TRIGGERS_T));
> >+	    sizeof(struct SL_WH_MPI_TRIGGERS_T));
> > 	memcpy(&ioc->diag_trigger_mpi, buf, sz);
> > 	if (ioc->diag_trigger_mpi.ValidEntries > NUM_VALID_ENTRIES)
> > 		ioc->diag_trigger_mpi.ValidEntries = NUM_VALID_ENTRIES;
> 
> Then just use sizeof(ioc->diag_trigger_mpi), then it's irrelevant
> how that type is ever called.
> 

Yeah, that's the way I would have prefered to write this as well.
It took me a while to verify that the intent here was not to clear
only part of the struct.  Using sizeof(variable_name) instead of
sizeof(type) is more readable.

But then you get into the thing where the line before uses
sizeof(type)...

Oh well, I've sent both styles and the maintainer can choose.  :)

regards,
dan carpenter

