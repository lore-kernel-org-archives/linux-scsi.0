From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH 0/2] mpt3sas: Reference counting fixes from in-flight
 mpt2sas
Date: Sun, 30 Aug 2015 09:14:42 -0700
Message-ID: <1440951282.2204.23.camel@HansenPartnership.com>
References: <1440562184-23945-1-git-send-email-nab@daterainc.com>
	 <20150826235434.GA8843@mail.thefacebook.com>
	 <1440633514.31814.3.camel@haakon3.risingtidesystems.com>
	 <CAK=zhgr6gpyW9-+VYcW4Aiv8-m-qdQ=fTeEAm2=OPUDN0FbOAQ@mail.gmail.com>
	 <1440686414.2196.107.camel@HansenPartnership.com>
	 <1440702941.24282.2.camel@haakon3.risingtidesystems.com>
	 <1440793538.2202.55.camel@HansenPartnership.com>
	 <1440919326.2104.111.camel@haakon3.risingtidesystems.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:60331 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753089AbbH3QOo (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sun, 30 Aug 2015 12:14:44 -0400
In-Reply-To: <1440919326.2104.111.camel@haakon3.risingtidesystems.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Cc: Sreekanth Reddy <sreekanth.reddy@avagotech.com>, Calvin Owens <calvinowens@fb.com>, "Nicholas A. Bellinger" <nab@daterainc.com>, linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>, Christoph Hellwig <hch@infradead.org>, "MPT-FusionLinux.pdl" <MPT-FusionLinux.pdl@avagotech.com>, kernel-team@fb.com

On Sun, 2015-08-30 at 00:22 -0700, Nicholas A. Bellinger wrote:
> On Fri, 2015-08-28 at 13:25 -0700, James Bottomley wrote:
> > On Thu, 2015-08-27 at 12:15 -0700, Nicholas A. Bellinger wrote:
> > > On Thu, 2015-08-27 at 07:40 -0700, James Bottomley wrote:
> > > > On Thu, 2015-08-27 at 10:37 +0530, Sreekanth Reddy wrote:
> > > > > HI Nicholas & Calvin,
> > > > > 
> > > > > Thanks for the patchset. Sure We will review and we do some unit
> > > > > testing on this patch series. Currently my bandwidth is occupied with
> > > > > some internal activity, so by end of next week I will acknowledge this
> > > > > series if all the thing are fine with this patch series.
> > > > 
> > > > Calvin responded to your review feedback and that series has been
> > > > outstanding for a while, so I'm not going to drop it from the misc tree.
> > > > However, I will reorder to make it ready for the second push. You have
> > > > until Friday week to find a problem with it.
> > > > 
> > > 
> > > James, as mentioned this series is functionally identical to Calvin's
> > > mpt2sas series.
> > > 
> > > Please consider merging it to scsi.git/for-next, so both series are
> > > together and in-sync.
> > 
> > Unfortunately, the driver isn't, thanks to drift between v2 and v3 of
> > the mpt_sas code bases.  This patch is also dangerous: the early
> > versions left unremoved objects lying around, so  getting some stress
> > testing from avago is very useful.  At this point in the cycle, the risk
> > vs reward of doing a blind upport to mpt3_sas is just too great and the
> > time for review and stress testing too limited within the merge window.
> 
> To clarify, this series is Calvin's latest -v4 mpt2sas changes that
> you've already merged into for-next, and that have been applied (by
> hand) to v4.2-rc1 mpt3sas code.
> 
> If you look closer, this series is an obvious bug-fix for a class of
> long-standing bugs within mpt*sas, and I don't see how keeping the
> broken list_head dereferences in one LLD, but not the other makes any
> sense at this point. 

Look, Nic, the original patches went through four reviews with issues
uncovered and fixed at most of them.  They're now sitting at the head of
the misc tree while they get stress tested so they can easily be ejected
without affecting the rest of the tree should anything fail.

They're hardly "an obvious bug fix" they actually introduce a separated
lifetime for _sas_device and fw_event_work.

Separated lifetime patches should always be a last resort because they
introduce a whole new set of lifetime handling rules for the objects.
Get one of them wrong and either you free it too early (oops) or pin it
forever.  The general rule of thumb is never do separated lifetime
objects unless you really really have to.  Ideally pin them to existing
core objects.  The only reason I'm considering this is because no one
can see how to pin _sas_device to the natural core object (scsi_device).
The firmware event one doesn't make sense to me at all so I'm relying on
the reviewers.  Ideally a fw event is allocated in the event setup and
freed in the event fire (or cancel)  I really don't see we need a
separated lifetime object here.  you have a callback to mediate exactly
whether the event fired or not in the cancel, so there's no ambiguity
about ownership.

Simply because of this, your upport to mp3sas can't go in without the
same level of review and testing.

> Unfortunately, the mpt3sas patches you've merged this week add yet more
> bogus mpt3sas_scsih_sas_device_find_by_sas_address() usage.  Really,
> adding more broken code to mpt3sas can't possibly be better than just
> merging this bug-fix series.

Well, it had two reviewers per patch, one of whom was Martin Petersen
who doesn't give reviewed by lightly.  Funnily enough it seems the list
lost your review feedback for this patch set.

James


