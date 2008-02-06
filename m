From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: ABORT_TASK defined in aic94xx_sas.h
Date: Wed, 06 Feb 2008 09:46:26 -0600
Message-ID: <1202312786.3112.28.camel@localhost.localdomain>
References: <47A9B859.6020208@panasas.com>
	 <1202310808.3112.8.camel@localhost.localdomain>
	 <47A9D374.2010607@panasas.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from accolon.hansenpartnership.com ([76.243.235.52]:45511 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751637AbYBFPq2 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 6 Feb 2008 10:46:28 -0500
In-Reply-To: <47A9D374.2010607@panasas.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Boaz Harrosh <bharrosh@panasas.com>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, Luben Tuikov <luben_tuikov@adaptec.com>

On Wed, 2008-02-06 at 17:34 +0200, Boaz Harrosh wrote:
> On Wed, Feb 06 2008 at 17:13 +0200, James Bottomley <James.Bottomley@HansenPartnership.com> wrote:
> > On Wed, 2008-02-06 at 15:38 +0200, Boaz Harrosh wrote:
> >> include/scsi/scsi.h as a definition:
> >> #define ABORT_TASK          0x0d
> >>
> >> on the other hand drivers/scsi/aic94xx/aic94xx_sas.h has:
> >> #define ABORT_TASK              0x03
> >>
> >> am I right in thinking that aic94xx_sas.h is wrong in
> >> polluting the global name-space?
> >>
> >> If you ask me aic94xx_sas.h is a global name-space minefield
> >>
> >> (This gives me problems when trying to pull in scsi_eh.h into
> >> aic94xx source files)
> > 
> > Well, no, not in those terms.  The global namespace exists in shared
> > headers which it's a little hard to argue that aic94xx_sas.h is, being
> > unusable by anything other than a single driver.
> > 
> > It is correct to say that include/scsi/scsi.h is polluting the global
> > namespace, because that is pulled into a large section of the kernel.
> > 
> > The message code #defines in scsi.h are a horrible mess of SPI message
> > defines and task management function defines each of which should
> > arguably have a SPI_ and TMF_ global namespace discriminator (and the
> > SPI_ ones be shovelled off into the SPI transport class header).
> > 
> > However, this looks like a reasonable hack.
> > 
> > James
> > 
> > 
> Point taken, you are right.
> 
> Please see that you approve of the name I gave it,
> I just got it from the nearest comment so I'm not
> even sure if it's related.

Yes, it's a sequencer control block opcode, so prefixing it with SCB_ is
reasonable.

James


