From: Martin Wilck <mwilck@suse.com>
Subject: Re: [PATCH v2 3/4] scsi_dh_alua: do not call BUG_ON when updating
 port group
Date: Mon, 15 May 2017 20:30:19 +0200
Message-ID: <1494873019.4728.11.camel@suse.com>
References: <20170512131508.3231-1-mwilck@suse.com>
         <20170512131508.3231-4-mwilck@suse.com>
         <1494606261.14477.3.camel@sandisk.com> <1494836189.4728.2.camel@suse.com>
         <1494864202.2567.1.camel@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from victor.provo.novell.com ([137.65.250.26]:59438 "EHLO
        prv3-mh.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933211AbdEOSag (ORCPT
        <rfc822;groupwise-linux-scsi@vger.kernel.org:0:0>);
        Mon, 15 May 2017 14:30:36 -0400
In-Reply-To: <1494864202.2567.1.camel@sandisk.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bart Van Assche <Bart.VanAssche@sandisk.com>, "hare@suse.de" <hare@suse.de>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>
Cc: "mauricfo@linux.vnet.ibm.com" <mauricfo@linux.vnet.ibm.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

On Mon, 2017-05-15 at 16:03 +0000, Bart Van Assche wrote:
> On Mon, 2017-05-15 at 10:16 +0200, Martin Wilck wrote:
> > On Fri, 2017-05-12 at 16:24 +0000, Bart Van Assche wrote:
> > > Allowing races like the one this patch tries to address to exist
> > > makes the ALUA code harder to maintain than necessary. Have you
> > > considered to make alua_bus_detach() wait until ALUA work has
> > > finished by using e.g. cancel_work_sync() or rcu_synchronize()?
> > 
> > to be honest, no, I didn't consider this yet. The current kernel
> > crashes with BUG() if an ALUA device is detached at an inopportune
> > point in time (not just theoretically, we actually observed this).
> > The
> > goal of my patch was to fix this with minimum risk to introduce
> > other
> > problems. The addition in patch 4/4 was an attempt to address the
> > concern you had expressed in your review of the v1 patch.
> > 
> > I'm not opposed to try to find a better solution, but could we
> > maybe
> > get the fix for the BUG() (i.e. patch 3/4) applied in the first
> > place?
> > AFAICS it would not conflict with a solution like the one you
> > suggested.
> 
> Hello Martin,
> 
> Sorry but I don't think it's a good idea to merge patch 3/4 in the
> upstream
> kernel. Even with that patch applied there is nothing that prevents
> that
> h->handler_data would be freed while alua_rtpg() is in progress and
> hence
> that h->sdev is a completely random pointer if alua_rtpg() is
> executed
> concurrently with alua_bus_detach(). Please do not try to paper over
> race
> conditions but fix these properly.

Hello Bart,

please be assured that I'm not trying to paper over anything. Your
concern about sdev->handler_data is justified. While I think that it's
a separate issue from what my patches were supposed to address, let me
see if I can come up with something more comprehensive.

It will take time, though, until I fully comprehend the locking concept
of scsi_dh_alua.c.

Regards,
Martin

-- 
Dr. Martin Wilck <mwilck@suse.com>, Tel. +49 (0)911 74053 2107
SUSE Linux GmbH, GF: Felix Imendörffer, Jane Smithard, Graham Norton
HRB 21284 (AG Nürnberg)
