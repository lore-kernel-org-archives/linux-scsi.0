From: "David Somayajulu" <david.somayajulu@qlogic.com>
Subject: RE: [RFC] [PATCH 4/5] qla4xxx: Add IPv6 support and misc
Date: Mon, 7 May 2007 11:50:58 -0700
Message-ID: <0BB3E5E7462EEA4295BC02D49691DC07B1E75F@AVEXCH1.qlogic.org>
References: <463F7070.5080601@cs.wisc.edu>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from avexch1.qlogic.com ([198.70.193.115]:33681 "EHLO
	avexch1.qlogic.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965536AbXEGSvY convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 7 May 2007 14:51:24 -0400
Content-class: urn:content-classes:message
In-Reply-To: <463F7070.5080601@cs.wisc.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mike Christie <michaelc@cs.wisc.edu>
Cc: linux-scsi@vger.kernel.org, David Wagner <david.wagner@qlogic.com>

> From: Mike Christie [mailto:michaelc@cs.wisc.edu]
> Sent: Monday, May 07, 2007 11:31 AM
> David C Somayajulu wrote:
> > Signed-off-by: David Somayajulu <david.somayajulu@qlogic.com>
> >
> > ---
> >  drivers/scsi/qla4xxx/ql4_mbx.c     |  190 ++++++++++------
> >
> > diff --git a/drivers/scsi/qla4xxx/ql4_mbx.c
b/drivers/scsi/qla4xxx/ql4_mbx.c
> > index 7f28657..0ef777a 100644
> > --- a/drivers/scsi/qla4xxx/ql4_mbx.c
> > +++ b/drivers/scsi/qla4xxx/ql4_mbx.c
> > @@ -6,6 +6,10 @@
> >   */
> >
> >  #include "ql4_def.h"
> > +#include "ql4_version.h"
> > +#include "ql4_glbl.h"
> > +#include "ql4_dbg.h"
> > +#include "ql4_inline.h"
> 
> Did you need to bring in all of these? You did not need version did
you?
Thanks for pointing it out. In fact it is needed only in ql4_os.c. I
think I will get rid of the ql4_version.h and simply place the version#
in ql4_os.c

> 
> >
> > -	memset((void *)fw_ddb_entry->iSCSIAlias, 0,
> > -	       sizeof(fw_ddb_entry->iSCSIAlias));
> > +	memset((void *)fw_ddb_entry->iscsi_alias, 0,
> > +	       sizeof(fw_ddb_entry->iscsi_alias));
> >
> > -	memset((void *)fw_ddb_entry->iscsiName, 0,
> > -	       sizeof(fw_ddb_entry->iscsiName));
> > +	memset((void *)fw_ddb_entry->iscsi_name, 0,
> > +	       sizeof(fw_ddb_entry->iscsi_name));
> >
> > -	memset((void *)fw_ddb_entry->ipAddr, 0,
sizeof(fw_ddb_entry->ipAddr));
> > -	memset((void *)fw_ddb_entry->targetAddr, 0,
> > -	       sizeof(fw_ddb_entry->targetAddr));
> > +	memset((void *)fw_ddb_entry->ip_addr, 0,
sizeof(fw_ddb_entry->ip_addr));
> > +	memset((void *)fw_ddb_entry->tgt_addr, 0,
> > +	       sizeof(fw_ddb_entry->tgt_addr));
> >
> 
> I am not sure if it is a big deal or if it clutters the code, but I do
> not think you need the void * casts in there.
Will clean it as well.
-david S.
