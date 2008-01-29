From: "Chris Leech" <christopher.leech@intel.com>
Subject: Re: Open-FCoE on linux-scsi
Date: Mon, 28 Jan 2008 21:42:38 -0800
Message-ID: <41b516cb0801282142n70509ad2h9953ae7308097ae0@mail.gmail.com>
References: <200801031035.m03AZYcJ012171@mbox.iij4u.or.jp>
	 <10A7D0016239E24092DEF05CCC582E4302BB789B@fmsmsx411.amr.corp.intel.com>
	 <477E1C69.9010203@s5r6.in-berlin.de>
	 <20080104205938U.fujita.tomonori@lab.ntt.co.jp>
	 <08FE5CC30C9A3F41BF819A502CF7BF6E029FF0B8@fmsmsx411.amr.corp.intel.com>
	 <477EC411.9040703@s5r6.in-berlin.de>
	 <477ECAD4.8010809@s5r6.in-berlin.de>
	 <10A7D0016239E24092DEF05CCC582E4302CFB7F7@fmsmsx411.amr.corp.intel.com>
	 <478D3152.4080508@emulex.com>
Reply-To: chris.leech@gmail.com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from fg-out-1718.google.com ([72.14.220.156]:48371 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752581AbYA2Fml (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 29 Jan 2008 00:42:41 -0500
Received: by fg-out-1718.google.com with SMTP id e21so1960291fga.17
        for <linux-scsi@vger.kernel.org>; Mon, 28 Jan 2008 21:42:39 -0800 (PST)
In-Reply-To: <478D3152.4080508@emulex.com>
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Smart@emulex.com
Cc: "Love, Robert W" <robert.w.love@intel.com>, Stefan Richter <stefanr@s5r6.in-berlin.de>, "Dev, Vasu" <vasu.dev@intel.com>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, tomof@acm.org, "Zou, Yi" <yi.zou@intel.com>, linux-scsi@vger.kernel.org

On Jan 15, 2008 2:18 PM, James Smart <James.Smart@emulex.com> wrote:
> True - it should become rather evident that FC should be its own
> i/o bus, with the hba LLDD providing bindings to each of the FC4 stacks.
> This would have worked really well for FCOE, with it creating a fc_port
> object, which could then layer a scsi_host on top of it, etc.
> Right now there's too much assumption that SCSI is the main owner of the
> port.  The NPIV vport stuff is a good illustration of this concept (why is
> the vport a subobject of the scsi_host ?).

In thinking about how FC should be represented, it seems to me that in
order to provide good interfaces at multiple levels of functionality
we have to make sure the we have the right data structures at each
level.  At the highest level there's scsi_cmd, then there's sequence
based interfaces that would need some sort of a sequence structure
with a scatter gather list, and at the lowest level interfaces work
directly with FC frames.

I'd like to talk about how we should go about representing FC frames.
Currently, our libfc code introduces an fc_frame struct but allows the
LLDD to provide an allocation function and control how the fc_frames
are allocated.  The fcoe module uses this capability to map the data
buffer of an fc_frame to that of an sk_buff.  As someone coming from a
networking background, and interested in FCoE which ends up sending
frames via an Ethernet driver, I tend to think this is overly complex
and just want to use sk_buffs directly.

Would SCSI/FC developers be opposed to dealing with sk_buffs for frame
level interfaces, or do we need to keep a seperate fc_frame structure
around?  I'd argue that skbs do a fine job of representing all sorts
of frame structures, that any device that supports IP over FC has to
deal with skbs in its driver anyway, and that at the frame level FC is
just another network.  But then again, I am biased as skbs seem
friendly and familiar to me as I venture further into the alien
landscape that is scsi.

- Chris
