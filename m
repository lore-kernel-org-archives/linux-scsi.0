From: Tejun Heo <teheo@suse.de>
Subject: Re: MD/RAID time out writing superblock
Date: Mon, 14 Sep 2009 22:24:50 +0900
Message-ID: <4AAE4422.4040801@suse.de>
References: <d086b110526f8bac2f562850dfc70b03@localhost> <4A970154.2020507@redhat.com> <4A9B8583.9050601@kernel.org> <4A9BBC4A.6070708@redhat.com> <4A9BC023.10903@kernel.org> <20090907114442.GG18831@arachsys.com> <20090907115927.GU8710@arachsys.com> <20090909120218.GB21829@arachsys.com> <4AADF3C4.5060004@kernel.org> <4AADF471.2020801@suse.de> <20090914131114.GA32253@khazad-dum.debian.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:47952 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755549AbZINNYy (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 14 Sep 2009 09:24:54 -0400
In-Reply-To: <20090914131114.GA32253@khazad-dum.debian.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Cc: Chris Webb <chris@arachsys.com>, linux-scsi@vger.kernel.org, Ric Wheeler <rwheeler@redhat.com>, Andrei Tanas <andrei@tanas.ca>, NeilBrown <neilb@suse.de>, linux-kernel@vger.kernel.org, IDE/ATA development list <linux-ide@vger.kernel.org>, Jeff Garzik <jgarzik@redhat.com>, Mark Lord <mlord@pobox.com>

Henrique de Moraes Holschuh wrote:
> On Mon, 14 Sep 2009, Tejun Heo wrote:
>> Oooh, another possibility is the above continuous IDENTIFY tries.
>> Doing things like that generally isn't a good idea because vendors
>> don't expect IDENTIFY to be mixed regularly with normal IOs and
> 
> IMHO that means the kernel should be special-casing such commands, then (i.e
> quiesce drive, do command, quiesce driver, start IO again), probably
> rate-limiting it for good effect.
> 
> This is the kind of stuff that userspace should NOT have to worry about
> (because it will get it wrong and cause data corruption eventually).

If this indeed is the case (As Mark pointed out, there hasn't been any
precedence involving IDENTIFY but it's also the first time I see
IDENTIFY timeouts which are issued from userland), this is the kind
that userspace shouldn't do to begin with.

There was another similar problem.  Some acpi package in ubuntu issues
APM adjustment commands whenever power related stuff changes.  The
firmware on the drive which shipped on Samsung NC10 for some reason
locks up after being hit with enough of those commands.  It's just not
safe to assume these kind of stuff would reliably work.  If you're
ready to do some research and experiments, it's fine.  If you're doing
OEM customization with specific hardware and QA, sure, why not (this
is basically what windows OEMs do too).  But, doing things which
aren't _usually_ used that way repeatedly _by default_ is asking for
trouble.  There's a reason why these operations are root only.  :-)

Thanks.

-- 
tejun
