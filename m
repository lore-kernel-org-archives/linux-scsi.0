From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: [PATCH 0/8] tcm_loop updates
Date: Mon, 06 Jul 2015 17:25:03 -0700
Message-ID: <1436228703.5138.2.camel@haakon3.risingtidesystems.com>
References: <1434620622-65391-1-git-send-email-hare@suse.de>
	 <20150619064855.GB1183@lst.de> <5583C117.4030103@suse.de>
	 <1435048143.7460.50.camel@haakon3.risingtidesystems.com>
	 <55892164.6020907@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.linux-iscsi.org ([67.23.28.174]:56722 "EHLO
	linux-iscsi.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754191AbbGGAZN (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 6 Jul 2015 20:25:13 -0400
In-Reply-To: <55892164.6020907@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: Christoph Hellwig <hch@lst.de>, Nic Bellinger <nab@daterainc.com>, target-devel@vger.kernel.org, linux-scsi@vger.kernel.org, Ewan Milne <emilne@redhat.com>

On Tue, 2015-06-23 at 11:05 +0200, Hannes Reinecke wrote:
> On 06/23/2015 10:29 AM, Nicholas A. Bellinger wrote:
> > On Fri, 2015-06-19 at 09:13 +0200, Hannes Reinecke wrote:
> >> On 06/19/2015 08:48 AM, Christoph Hellwig wrote:
> >>> What's the benefit of the SAS transport class writeout?  I honestly
> >>> always saw tcm_loop as a simple loopback driver, with the different
> >>> transport IDs in the PR code as a gimmick.  Note that vhost and
> >>> xen-blkback copies that style and I did plan to consolidate it
> >>> in common code.
> >>>
> >> The benefit is that tcm_loop will show up in the system as a 'real'
> >> SAS hba; long-term goal is to simulate SAS multipathing here.
> >> I was even planning on adding simlated FC infrastructure, too;
> >> with that we could simulate FC multipathing, too, and our QA would
> >> be _so_ happy...
> >>
> > 
> > Sounds like a reasonable use-case to support for loopback testing.
> > 
> >> Again, these patches are mainly a collection of patches I've done to
> >> test various scenarios, in the hope others might find them useful,
> >> too. So I can easily hold off these patches until you've posted your
> >> rework.
> >>
> > 
> > How different do you expect sas, fc, and iscsi transports to be..?
> > 
> > Do you think this would this be better served by a simple tcm_loop LLD
> > specific API for different multipath transports..?
> > 
> Actually, I would split off the various transport functions into
> separate files (tcm_loop_sas, tcm_loop_fc, etc), but keep a common
> tcm_loop module.
> We can even make transport classes optional by adding an explicit
> 'sas.XXX' prefix scanning when creating the device similar to what
> we do with the 'fc.XXX' prefix already.
> With that we would have a 'sas.XXX', 'fc.XXX', and 'iqn.XXX' WWN
> which would attach to the respective transport class, and any other
> WWN (which would be the default) would be getting the standard
> emulation without any transport class attached.

I'm open to merging the tcm_loop patches #1-#6 as-is for the sas
transport pieces, or wait until you've done a large split based on
transport class types.

It's really your call how the initial merge should look.

--nab



