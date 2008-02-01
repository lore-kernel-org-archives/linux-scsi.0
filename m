From: James Smart <James.Smart@Emulex.Com>
Subject: Re: Open-FCoE on linux-scsi
Date: Thu, 31 Jan 2008 20:53:38 -0500
Message-ID: <47A27BA2.3090906@emulex.com>
References: <200801031035.m03AZYcJ012171@mbox.iij4u.or.jp>	 <10A7D0016239E24092DEF05CCC582E4302BB789B@fmsmsx411.amr.corp.intel.com>	 <477E1C69.9010203@s5r6.in-berlin.de>	 <20080104205938U.fujita.tomonori@lab.ntt.co.jp>	 <08FE5CC30C9A3F41BF819A502CF7BF6E029FF0B8@fmsmsx411.amr.corp.intel.com>	 <477EC411.9040703@s5r6.in-berlin.de>	 <477ECAD4.8010809@s5r6.in-berlin.de>	 <10A7D0016239E24092DEF05CCC582E4302CFB7F7@fmsmsx411.amr.corp.intel.com>	 <478D3152.4080508@emulex.com> <41b516cb0801282142n70509ad2h9953ae7308097ae0@mail.gmail.com>
Reply-To: James.Smart@Emulex.Com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from emulex.emulex.com ([138.239.112.1]:39262 "EHLO
	emulex.emulex.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752781AbYBABy0 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 31 Jan 2008 20:54:26 -0500
In-Reply-To: <41b516cb0801282142n70509ad2h9953ae7308097ae0@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: chris.leech@gmail.com
Cc: "Love, Robert W" <robert.w.love@intel.com>, Stefan Richter <stefanr@s5r6.in-berlin.de>, "Dev, Vasu" <vasu.dev@intel.com>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, tomof@acm.org, "Zou, Yi" <yi.zou@intel.com>, linux-scsi@vger.kernel.org



Chris Leech wrote:
> In thinking about how FC should be represented, it seems to me that in
> order to provide good interfaces at multiple levels of functionality
> we have to make sure the we have the right data structures at each
> level.  At the highest level there's scsi_cmd, then there's sequence
> based interfaces that would need some sort of a sequence structure
> with a scatter gather list, and at the lowest level interfaces work
> directly with FC frames.

I think the only thing that will actually talk frames will either be
a fc mac, which we haven't seen yet, or a FCOE entity.  Consider the
latter to be the predominant case.

> I'd like to talk about how we should go about representing FC frames.
> Currently, our libfc code introduces an fc_frame struct but allows the
> LLDD to provide an allocation function and control how the fc_frames
> are allocated.  The fcoe module uses this capability to map the data
> buffer of an fc_frame to that of an sk_buff.  As someone coming from a
> networking background, and interested in FCoE which ends up sending
> frames via an Ethernet driver, I tend to think this is overly complex
> and just want to use sk_buffs directly.

If the predominant user is fcoe, then I think describing the frame in
the context of a sk_buff is fine.

> Would SCSI/FC developers be opposed to dealing with sk_buffs for frame
> level interfaces, or do we need to keep a seperate fc_frame structure
> around?  I'd argue that skbs do a fine job of representing all sorts
> of frame structures, that any device that supports IP over FC has to
> deal with skbs in its driver anyway, and that at the frame level FC is
> just another network.  But then again, I am biased as skbs seem
> friendly and familiar to me as I venture further into the alien
> landscape that is scsi.
> 
> - Chris

-- james s
