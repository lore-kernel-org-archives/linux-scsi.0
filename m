From: Doug Maxey <dwm@maxeymade.com>
Subject: Re: [PATCH] fix sym2 negotiation
Date: Wed, 25 Aug 2004 08:43:07 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <200408251343.i7PDh7Wv009870@falcon30.maxeymade.com>
References: <20040825121129.GP2306@krispykreme>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from falcon30.maxeymade.com ([24.173.215.190]:59009 "EHLO
	falcon30.maxeymade.com") by vger.kernel.org with ESMTP
	id S267431AbUHYNnS (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 25 Aug 2004 09:43:18 -0400
In-reply-to: <20040825121129.GP2306@krispykreme> 
List-Id: linux-scsi@vger.kernel.org
To: Anton Blanchard <anton@samba.org>
Cc: Matthew Wilcox <willy@debian.org>, Olaf Hering <olh@suse.de>, James Bottomley <James.Bottomley@SteelEye.com>, SCSI Mailing List <linux-scsi@vger.kernel.org>


On Wed, 25 Aug 2004 22:11:29 +1000, Anton Blanchard wrote:
>
>> > This broken chip seems to be so popular on PPC64 that the arch maintainers
>> > want a PPC64 specific default. Oh well ...
>> > 
>> > +/* Some AChip ARC765 based DVD-ROM's take 15 or more seconds
>> > + * to reset.  A scan will fail if made right after a reset.
>> > + * It's completely broken device behaviour: SCSI specification
>> > + * says devices need to be able to respond to INQUIRY always
>> > + * (after a selection timeout ... of 250ms).
>> > + */
>> > +#ifdef __powerpc64__
>> > +static unsigned int scsi_inq_timeout = SCSI_TIMEOUT/HZ+25;
>> > +#else
>> >  static unsigned int scsi_inq_timeout = SCSI_TIMEOUT/HZ+3;
>> > +#endif
>> >  
>> >  module_param_named(inq_timeout, scsi_inq_timeout, int, S_IRUGO|S_IWUSR);
>> >  MODULE_PARM_DESC(inq_timeout, 
>> 
>> How about hacking the ppc64 bootloader to always pass inq_timeout=30 instead?
>
>Alternatively make scsi_inq_timeout non static and we can tweak this at
>boot in ppc64 arch code. Assuming we no longer use these POS drives we
>can avoid bumping the value on new machines.
>
  
  These ACARDs are on all iseries with optical drives, and it is a
  limitation of ATAPI devices.  You should actually wait 31 sec to
  be sure.

++doug
