From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: Drivers: scsi: FLUSH timeout
Date: Fri, 04 Oct 2013 09:27:57 -0700
Message-ID: <1380904077.1987.18.camel@dabdike.int.hansenpartnership.com>
References: <1379705547-15028-1-git-send-email-kys@microsoft.com>
	 <20130920203222.GA14306@kroah.com>
	 <a97d266e2c284d688d2dd7ad43f179b8@SN2PR03MB061.namprd03.prod.outlook.com>
	 <524180B7.7090307@gmail.com>
	 <3413dbd7fa254fd380a84fe6d9cd87e1@SN2PR03MB061.namprd03.prod.outlook.com>
	 <5241C9E7.2000404@cs.wisc.edu>
	 <bf168ab724a140f989ab3dfe877b750f@SN2PR03MB061.namprd03.prod.outlook.com>
	 <CAMuHMdV-BsKc-c1YhzqFrUGJhw+jMZEXXTcT2xyDLnw-JQuVaQ@mail.gmail.com>
	 <ff6a93ed5d234c14874d03415812a3ec@SN2PR03MB061.namprd03.prod.outlook.com>
	 <1380802143.19256.95.camel@haakon3.risingtidesystems.com>
	 <CADOQvuPWaSntci+4pNCbsP-Ug6P=xf1_5ZqqoaA+fXumgfHmeA@mail.gmail.com>
	 <2cc1bcb3a157418eb66bd2d91cf911c1@SN2PR03MB061.namprd03.prod.outlook.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-15"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:41968 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754634Ab3JDQ2F (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 4 Oct 2013 12:28:05 -0400
In-Reply-To: <2cc1bcb3a157418eb66bd2d91cf911c1@SN2PR03MB061.namprd03.prod.outlook.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: KY Srinivasan <kys@microsoft.com>
Cc: Eric Seppanen <eric@purestorage.com>, "Nicholas A. Bellinger" <nab@linux-iscsi.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

On Fri, 2013-10-04 at 15:02 +0000, KY Srinivasan wrote:
> 
> > -----Original Message-----
> > From: Eric Seppanen [mailto:eric@purestorage.com]
> > Sent: Thursday, October 03, 2013 1:49 PM
> > To: Nicholas A. Bellinger
> > Cc: KY Srinivasan; linux-kernel@vger.kernel.org; devel@linuxdriverproject.org;
> > linux-scsi@vger.kernel.org
> > Subject: Re: Drivers: scsi: FLUSH timeout
> > 
> > On Thu, Oct 3, 2013 at 5:09 AM, Nicholas A. Bellinger
> > <nab@linux-iscsi.org> wrote:
> > >
> > > On Wed, 2013-10-02 at 18:29 +0000, KY Srinivasan wrote:
> > > > Ideally, I want this to be adjustable like the way we can change the I/O
> > timeout.
> > > > Since that has been attempted earlier and rejected (not clear what the
> > reasons were),
> > > > I was suggesting that we pick a larger number. James, let me know how I
> > should proceed here.
> > > >
> > >
> > > I think the objection was to making a module parameter for doing this
> > > globally for all struct scsi_disk, and not the idea of making it
> > > adjustable on an individual basis per-say..
> > >
> > > What about adding a /sys/class/scsi_disk/$HCTL/flush_timeout..?
> > 
> > Do I/O timeouts and flush timeouts need to be independently adjusted?
> > If you're having trouble with slow operations, it seems likely to be
> > across the board.
> > 
> > Flush timeout could be defined as 2x the read/write timeout.  Any
> > other command-specific timeouts could be scaled the same way.
> 
> I like this idea and would result in minimal changes. James, if it ok with you,
> I could send you the patch.

Depends: I still prefer the per-target override, but if the proposal is
to take the existing variable timeout for the queue and have 2x that for
the flush, so you plan to increase the per-device timeout with hyper-v
to 90s via sysfs, then I'm OK with it.

James


