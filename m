From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [Cbe-oss-dev] [regression/bisected] corrupt CD
	data	after	media change and delay
Date: Tue, 10 Jun 2008 11:17:22 -0500
Message-ID: <1213114642.3440.26.camel@localhost.localdomain>
References: <Pine.LNX.4.64.0806061458300.6228@vixen.sonytel.be>
	 <1212765202.16182.5.camel@localhost.localdomain>
	 <Pine.LNX.4.64.0806091443000.17741@vixen.sonytel.be>
	 <Pine.LNX.4.64.0806091546260.22138@vixen.sonytel.be>
	 <1213023916.3508.23.camel@localhost.localdomain>
	 <Pine.LNX.4.64.0806091721040.22138@vixen.sonytel.be>
	 <1213111253.3440.5.camel@localhost.localdomain>
	 <484EA274.2060308@panasas.com>
	 <1213113379.3440.23.camel@localhost.localdomain>
	 <484EA7D3.1060606@panasas.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from accolon.hansenpartnership.com ([76.243.235.52]:36023 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751365AbYFJQR0 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 10 Jun 2008 12:17:26 -0400
In-Reply-To: <484EA7D3.1060606@panasas.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Boaz Harrosh <bharrosh@panasas.com>
Cc: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>, linux-scsi <linux-scsi@vger.kernel.org>

On Tue, 2008-06-10 at 19:12 +0300, Boaz Harrosh wrote:
> James Bottomley wrote:
> > On Tue, 2008-06-10 at 18:49 +0300, Boaz Harrosh wrote:
> >> I think, I recall that, any issued command, not only unit_ready, might be appended
> >> with UNIT_ATTENTION sense. So maybe as a deeper fix (with lots of testing) we want 
> >> to add this logic into the scsi_check_sense() processing. But I'm not sure either way.
> > 
> > We do .. it's in scsi_io_completion().  The problem is that by design
> > internally issued commands bypass this, so the problem was that the
> > internally issued command wasn't doing the correct update.
> > 
> > James
> > 
> > 
> 
> Yes, I was just staring at that code. It looks like this hunk could be move up
> to before the completion, since with BLOCK_PC commands we always complete the
> all command length, hence the code will never get there.
> 
> Should I attempt a fix, or could you do it?

Like I said, we deliberately let them see this, so moving the code would
be the wrong thing to do.

James


