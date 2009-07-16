From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH 1/4] scsi: Allow hosts to be flagged as hotpluggable
Date: Thu, 16 Jul 2009 14:53:29 +0000
Message-ID: <1247756009.6606.9.camel@mulgrave.site>
References: <1247701438-18266-1-git-send-email-mjg@redhat.com>
	 <4A5F3975.70503@s5r6.in-berlin.de> <20090716143828.GB13924@srcf.ucam.org>
	 <1247755399.6606.4.camel@mulgrave.site>
	 <20090716144536.GB14345@srcf.ucam.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S932420AbZGPOxe@vger.kernel.org>
In-Reply-To: <20090716144536.GB14345@srcf.ucam.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Matthew Garrett <mjg59@srcf.ucam.org>
Cc: Stefan Richter <stefanr@s5r6.in-berlin.de>, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Thu, 2009-07-16 at 15:45 +0100, Matthew Garrett wrote:
> On Thu, Jul 16, 2009 at 02:43:19PM +0000, James Bottomley wrote:
> > On Thu, 2009-07-16 at 15:38 +0100, Matthew Garrett wrote:
> > > Exactly.
> > 
> > OK, so if this is only in relation to SATA power management, put it in
> > libata and call it something like pm_capable.  That way we don't have to
> > work out what to do with it for the rest of SCSI.
> 
> I have vague memories of this coming up before and it being suggested 
> that it should be done at the SCSI layer instead, but I can't find that 
> now. Doing it entirely in libata certainly isn't a problem.

Well, a flag that says 'hotplug' and means both the controller and bus
support hotplugging might be SCSI specific.  However, the fact is that
most people make such a determination on the bus type, so it's a bit
redundant (in true SCSI there really is no controller on a hotplug bus
that doesn't support hotplug because they can't scan the bus without
it).  If you intend to use it to make link power management decisions,
that's completely different because SAS PM support still isn't
standardised and most of the rest of SCSI doesn't have it either.  So it
sounds to me you're looking for a flag that says "might have a problem
with SATA link power management" ... in which case this is currently
libata specific.  We might be able to expand it to libsas if (when) we
actually get link power management standardised, but a lot of the other
busses aren't even going to have a concept of link power management.

James
