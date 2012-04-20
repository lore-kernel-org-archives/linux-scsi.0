From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [RESEND][PATCH] [SCSI] scsi_dh: allow 3rd party multipath
 drivers to use scsi_dh_detach
Date: Fri, 20 Apr 2012 19:17:16 +0400
Message-ID: <1334935036.13001.27.camel@dabdike>
References: <20111215214440.GA17677@redhat.com> <4EF039D5.5010201@suse.de>
	 <20120405144721.GA18437@redhat.com> <20120420144538.GB8155@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20120420144538.GB8155@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Mike Snitzer <snitzer@redhat.com>
Cc: linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>, Chandra Seetharaman <sekharan@us.ibm.com>, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Fri, 2012-04-20 at 10:45 -0400, Mike Snitzer wrote:
> Allow 3rd party multipath drivers to programatically detach a scsi_dh
> using the scsi_dh_detach() interface.  This is as improvement over
> requiring them to write 'detach' to /sys/block/sdX/queue/dh_state
> 
> End result is both Linux and 3rd party multipath drivers can coexist
> without compromising Linux's default handling of multipath LUNs.
> 
> Linux has suffered from races associated with attaching a scsi_dh to a
> device too late (after an HBA driver has started the SCSI device scan).
> Attaching a scsi_dh too late results in default sense handling that does
> not silently fail IO to passive paths, which creates excessive delays
> and IO errors during normal boot on a system with hundreds of LUNs.
> 
> To fix this the appropriate scsi_dh must be attached before the HBA
> driver(s) are even loaded.  But some scsi_dh are known to conflict with
> 3rd party multipath drivers (e.g. both scsi_dh_alua and scsi_dh_emc
> conflict with EMC PowerPath).  This patch allows 3rd party drivers to
> resolve the conflict by detaching an attached scsi_dh.

This changelog is a bit misleading, isn't it?

The basic problem is that binary only third party drivers can't use the
scsi_dh_detach callback because it's GPL only.  The only module I know
which suffers this problem is powerpath, is that right?

So this patch actually relaxes our GPL only policy to allow powerpath to
detach correctly. I really don't like the characterisation in the
current proposed changelog of this being a "third party" problem because
quite a few third party modules actually provide source and are thus GPL
compliant.

The whole point of GPL only symbols is to make life difficult for binary
modules, so I could just say this might be indicative of the success of
that policy.  On the other hand, I'm not going to be religious about
this.  If you get the ack of the dh handler maintainer (Chandra
Seetharaman) I'll apply this policy relaxation with a proper changelog
that says what we're doing (allowing powerpath to bind to the symbol).

James
