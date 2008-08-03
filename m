From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: RE: Sample implementation of a scheme to handle missing interrupts
Date: Sun, 03 Aug 2008 12:59:11 -0500
Message-ID: <1217786351.4179.23.camel@localhost.localdomain>
References: <660360F4F2570145BD872F298951B17A3AC7E4BF@cosmail03.lsi.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from accolon.hansenpartnership.com ([76.243.235.52]:37903 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751628AbYHCR7Q (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 3 Aug 2008 13:59:16 -0400
In-Reply-To: <660360F4F2570145BD872F298951B17A3AC7E4BF@cosmail03.lsi.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Moore, Eric" <Eric.Moore@lsi.com>
Cc: Matthew Wilcox <matthew@wil.cx>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "Prakash, Sathya" <Sathya.Prakash@lsi.com>

On Tue, 2008-07-29 at 17:38 -0600, Moore, Eric wrote:
> On Monday, July 28, 2008 2:45 PM, James Bottomley wrote:
> > >
> > > In my case, the MSI problem will manifest itself well before we bind
> > > with the scsi midlayer.    Meaning when there is a MSI problem, we
> > > can't even bring up the card.  Hence adding code in a eh_timed_out
> > > callback handler would be meaningless in solving our problem. What I
> > > need to do is find a problematic card, so I can verify some things.
> >
> > Actually, you don't need this.  I verified the behaviour of the MSI
> > problem simply by commenting out the request_irq.  It looks
> > like there's
> > no simple way to simulate MSI misrouting, but perhaps I should look at
> > that, since it would be useful.
> >
> 
> Well today I found at FC929X where it fails when MSI enabled.   The problem is occuring at the end of mpt_do_ioc_recovery, after we enable interrupts, we are asking for random manufacturing config pages. I see it randomly timing out on the config pages, meaning some time GetLanConfigPages works, then other times it fails. Sometimes it fails later on for either GetIoUnitPage2 or mpt_get_manufacturing_pg_0.  So its randomly timing out on config pages, but most the time is the first one.   So did the following patch (hopefully its not butcherd by ccmail). What I'm doing is failling back to IOAPIC routing after we have a config page timeout.   This works scsi_misc tip with drives attached to both channels of the multifunction FC card.      I'm thinking we may still need do what Matt W. sugge
 sted just as I pointed, I see random timeouts with the config pages.  A side note, I found that pci_disable_msi() is not working in SLES10 SP2..    Did you have any other suggestion where th
 is
>   could be handled in a generic common method?

Actually, I think mpt_config is too deep.  The first time we use it to
get a page is when the failure occurs ... I think that's the point we
can intercept and retry.

I'll send a common coded routine (plus a bit of generic infrastructure
to make this more standard) shortly.

James


