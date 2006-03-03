From: Luben Tuikov <ltuikov@yahoo.com>
Subject: RE: [PATCH] make some sas class properties optional
Date: Fri, 3 Mar 2006 10:37:22 -0800 (PST)
Message-ID: <20060303183722.98821.qmail@web31811.mail.mud.yahoo.com>
References: <1141403881.5397.1.camel@mulgrave.il.steeleye.com>
Reply-To: ltuikov@yahoo.com
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from web31811.mail.mud.yahoo.com ([68.142.207.74]:23163 "HELO
	web31811.mail.mud.yahoo.com") by vger.kernel.org with SMTP
	id S1751337AbWCCShY (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 3 Mar 2006 13:37:24 -0500
In-Reply-To: <1141403881.5397.1.camel@mulgrave.il.steeleye.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>, "Moore, Eric" <Eric.Moore@lsil.com>
Cc: Christoph Hellwig <hch@infradead.org>, linux-scsi <linux-scsi@vger.kernel.org>

--- James Bottomley <James.Bottomley@SteelEye.com> wrote:
> As you can see, for a driver that provides an SMP tap, like aic94xx then

Please don't call it a "tap".  Use storage terminology please.

> these parameters can be got by the transport class sending the SMP
> queries ... the driver doesn't need to know about it.

Exactly what the SAS stack does.

Furthermore you need to understand that this is _not_ anything special.
I've explained that before: aic94xx only provides access to SDS, and
then the SAS stack uses that.  That is, the "scsi_host" abstraction is
at the SAS stack layer, not at "aic94xx".

This is the provision which "sas_ha->lldd_execute_task" wants and
which aic94xx provides.  It could be any task supported by the SDS.
See "struct sas_task" in include/scsi/sas/sas_task.h.

So, you can safely presume that any transport would support executing
a SCSI task, which is the abstraction at SCSI Core level.  But
at the transport (lower) level, "struct sas_task" supports SCSI task
as well as transport specific tasks.

      Luben

