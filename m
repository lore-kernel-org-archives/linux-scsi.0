From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH 2/2] export command allocation and freeing functions
	independently of the host
Date: Thu, 13 Mar 2008 13:20:51 -0500
Message-ID: <1205432452.2893.44.camel@localhost.localdomain>
References: <1205427224.2893.23.camel@localhost.localdomain>
	 <47D966E6.9080606@panasas.com>
	 <1205430360.2893.35.camel@localhost.localdomain>
	 <47D96BDE.8090607@panasas.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from accolon.hansenpartnership.com ([76.243.235.52]:57057 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753701AbYCMSUz (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 13 Mar 2008 14:20:55 -0400
In-Reply-To: <47D96BDE.8090607@panasas.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Boaz Harrosh <bharrosh@panasas.com>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, Matthew Wilcox <matthew@wil.cx>

On Thu, 2008-03-13 at 20:01 +0200, Boaz Harrosh wrote:
> On Thu, Mar 13 2008 at 19:46 +0200, James Bottomley <James.Bottomley@HansenPartnership.com> wrote:
> > On Thu, 2008-03-13 at 19:39 +0200, Boaz Harrosh wrote:
> >> On Thu, Mar 13 2008 at 18:53 +0200, James Bottomley <James.Bottomley@HansenPartnership.com> wrote:
> >> Looking long term. This will clash with Matthew Wilcox's effort of 
> >> overridable per host command pool.
> > 
> > Not really, since the design is to obtain commands outside of the normal
> > host pool allocations for special purposes.  All that needs to be
> > updated for the per host override is the setup and teardown path, which
> > can be done in a few lines.
> > 
> 
> Again the concept was that an host might want a special size command for
> the + host_priv additions that will get allocated once. This still applies
> with "special purpose" commands, they need to be the size the host expects
> them to be, so it can use container_of() macro to retrieve the real structure.
> (Or any other dynamic size calculations)

Well, the currently presented interface is to tidy up the command use
for precisely two drivers, neither of which seems to want to use special
sized commands.  Even if that patch set were ready for merging (which it
isn't), adding it to the command allocators with no users would still be
over engineering.

> >>  I do have a scsi_host in the USB
> >> initialization. Perhaps:
> >>
> >> +struct scsi_cmnd *scsi_allocate_command(struct Scsi_Host*, gfp_t gfp_mask);
> >> +void scsi_free_command(gfp_t gfp_mask, struct scsi_cmnd *cmd);
> > 
> > James
> > 
> 
> I guess it can change later when needed. Just that I wanted that new users of the
> API get used to the need of an Scsi_Host

Yes, for just two users, particularly when there's doubt over whether
they'd even need the potential feature set, simpler is better.

James


