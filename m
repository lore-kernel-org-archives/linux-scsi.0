From: Mike Anderson <andmike@us.ibm.com>
Subject: Re: Another SCSI Sync
Date: Wed, 5 Mar 2003 10:10:03 -0800
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030305181003.GC1090@beaverton.ibm.com>
References: <1046315953.1834.177.camel@mulgrave> <Pine.LNX.4.44.0303050753080.4759-100000@home.transmeta.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44.0303050753080.4759-100000@home.transmeta.com>
List-Id: linux-scsi@vger.kernel.org
To: Linus Torvalds <torvalds@transmeta.com>
Cc: James Bottomley <James.Bottomley@steeleye.com>, linux-scsi@vger.kernel.org

I am looking at this now. I switched my config from new AIC to old AIC
and see a failure similar to what Andrew Morton was seeing when he switched.

It looks to be a bug in error handling while probing.

Linus Torvalds [torvalds@transmeta.com] wrote:
> 
> Hmm.. Some part of the last syncs seem to break for a lot of people. See
> the linux kernel mailing list. One report (Rob Radez <rob@osinvestor.com>)  
> chased it down some:
> 
> 	On Tue, Mar 04, 2003 at 11:42:41PM -0600, David van Hoose wrote:
> 	> Kernels 2.5.63 and 2.5.64 lock up when displaying the information for my 
> 	> ZipDrive during SCSI probe. Attached is my .config for 2.5.64.
> 
> 	I suspect I'm seeing something similar.  On SPARC, I'm getting a hang
> 	after displaying the information for my SCSI CD-ROM drive.
> 
> 	scsi0 : Sparc ESP100A-FAST
> 	Vendor: SEAGATE   Model: ST31200W SUN1.05  Rev: 8724
> 	Type:   Direct-Access                      ANSI SCSI revision: 02
> 	Vendor: SEAGATE   Model: ST32155W SUN2.1G  Rev: 8456
> 	Type:   Direct-Access                      ANSI SCSI revision: 02
> 	Vendor: TOSHIBA   Model: XM-4101TASUNSLCD  Rev: 1755
> 	Type:   CD-ROM                             ANSI SCSI revision: 02
> 	<hang>
> 
> 	Worked fine in 2.5.62, hangs in 2.5.63. Reverting the scsi changes
> 	listed at
> 		http://osinvestor.com/sparc/patch/2.5.63-revertscsi.diff
> 	allows 2.5.63 to boot.
> 
> Please check it out.. The common thread seems to be "non-disk".
> 
> 		Linus
> 
> -
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
-andmike
--
Michael Anderson
andmike@us.ibm.com

