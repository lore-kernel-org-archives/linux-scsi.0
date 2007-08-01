From: Kristen Carlson Accardi <kristen.c.accardi@intel.com>
Subject: Re: [patch 3/4] Enable link power management for ata drivers
Date: Wed, 1 Aug 2007 14:11:54 -0700
Message-ID: <20070801141154.3246a20d.kristen.c.accardi@intel.com>
References: <20070705194909.337398431@intel.com>
	<20070705130530.5873afeb.kristen.c.accardi@intel.com>
	<46B043FB.5090005@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:17468 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751273AbXHAVOu (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 1 Aug 2007 17:14:50 -0400
In-Reply-To: <46B043FB.5090005@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Tejun Heo <htejun@gmail.com>
Cc: jeff@garzik.org, akpm@linux-foundation.org, linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org, James.Bottomley@steeleye.com, edwintorok@gmail.com, axboe@kernel.dk, linux-scsi@vger.kernel.org

On Wed, 01 Aug 2007 17:27:39 +0900
Tejun Heo <htejun@gmail.com> wrote:

> Kristen Carlson Accardi wrote:
<snippy>
> Is it safe to use ALPM on a device which only claims to support DIPM?

Yes - I doubled checked this with the AHCI people - and of course you
have Edvin's testing to prove it does fine.

> I think this should be ATA_HORKAGE_IPM.

OK - I changed it.

> > @@ -321,6 +321,8 @@ struct ata_taskfile {
> >  	  ((u64) (id)[(n) + 0]) )
> >  
> >  #define ata_id_cdb_intr(id)	(((id)[0] & 0x60) == 0x20)
> > +#define ata_id_has_hipm(id)	((id)[76] & (1 << 9))
> > +#define ata_id_has_dipm(id)	((id)[78] & (1 << 3))
> 
> We probably need !0xffff test here.

Thanks, I fixed that too.

As far as moving the enable/disable_pm calls to EH - can you take
a look at the other patch I sent which implements the shost_attrs
to see if I still need to do this?  I really don't know much about
the EH stuff - can you explain why we need to use it to set the
link pm?

thanks for your review, 
Kristen
