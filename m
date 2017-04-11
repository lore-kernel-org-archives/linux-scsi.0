From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Subject: Re: Race to power off harming SATA SSDs
Date: Mon, 10 Apr 2017 23:02:35 -0300
Message-ID: <20170411020235.GD10185@khazad-dum.debian.net>
References: <20170410232118.GA4816@khazad-dum.debian.net>
 <20170410235206.GA28603@wtj.duckdns.org>
 <1491868675.2473.22.camel@HansenPartnership.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1491868675.2473.22.camel@HansenPartnership.com>
Sender: linux-kernel-owner@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Tejun Heo <tj@kernel.org>, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org, Hans de Goede <hdegoede@redhat.com>
List-Id: linux-scsi@vger.kernel.org

On Mon, 10 Apr 2017, James Bottomley wrote:
> On Tue, 2017-04-11 at 08:52 +0900, Tejun Heo wrote:
> [...]
> > > Any comments?  Any clues on how to make the delay "smarter" to 
> > > trigger only once during platform shutdown, but still trigger per
> > > -device when doing per-device hotswapping ?
> > 
> > So, if this is actually an issue, sure, we can try to work around;
> > however, can we first confirm that this has any other consequences
> > than a SMART counter being bumped up?  I'm not sure how meaningful
> > that is in itself.
> 
> Seconded; especially as the proposed patch is way too invasive: we run

It is a proof of concept thing.  It even says so in the patch commit
log, and in the cover text.

I don't want an one second delay per device.  I never proposed that,
either.  In fact, I *specifically* asked for something else in the
paragraph you quoted.

I would much prefer an one- or two-seconds delay per platform *power
off*.  And that's for platforms that do ACPI-like heavy-duty S3/S4/S5
like x86/x86-64.  Opportunistic high-frequency suspend on mobile likely
requires no such handling.

The per-device delay would be needed only for hotplug removal (device
delete), and that's just because some hardware powers down bays (like
older thinkpads with ATA-compatible bays, and some industrial systems).

-- 
  Henrique Holschuh
