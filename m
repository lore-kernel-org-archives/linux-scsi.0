From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH v8 08/13] libsas: libsas.force_hard_reset module
 parameter
Date: Thu, 01 Mar 2012 08:27:45 -0600
Message-ID: <1330612065.2888.8.camel@dabdike.int.hansenpartnership.com>
References: <20120210084411.25701.94502.stgit@dwillia2-linux.jf.intel.com>
	 <20120210084520.25701.83280.stgit@dwillia2-linux.jf.intel.com>
	 <1330552551.8846.24.camel@dabdike>
	 <CABE8wwt3tMT7wmSG=k_z6FOvBaStwuG1NF68Cjqi0qacaQVA0Q@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <CABE8wwt3tMT7wmSG=k_z6FOvBaStwuG1NF68Cjqi0qacaQVA0Q@mail.gmail.com>
Sender: linux-ide-owner@vger.kernel.org
To: Dan Williams <dan.j.williams@intel.com>
Cc: linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org, Jack Wang <jack_wang@usish.com>, Luben Tuikov <ltuikov@yahoo.com>, Xiangliang Yu <yuxiangl@marvell.com>
List-Id: linux-scsi@vger.kernel.org

On Wed, 2012-02-29 at 15:22 -0800, Dan Williams wrote:
> On Wed, Feb 29, 2012 at 1:55 PM, James Bottomley
> <James.Bottomley@hansenpartnership.com> wrote:
> > On Fri, 2012-02-10 at 00:45 -0800, Dan Williams wrote:
> >> It is possible for a host to get "locked out" from talking to sata
> >> devices in the domain if, for example, its sas address changes but the
> >> expander topology has existing affiliations with the old address.  If
> >> the system is booted userspace can write to
> >> /sys/class/sas_phy/<phy-X>/hard_reset to clear the affiliation, however
> >> if this condition exists for the root device the module parameter can be
> >> used to promote all ata resets to hard resets.
> >
> > I don't quite understand this.  Are you saying we can't (or shouldn't)
> > execute
> >
> > /sys/class/sas_phy/<phy-X>/hard_reset
> >
> > on the root device for some reason?
> 
> The case I ran into was accidentally changing the host sas address
> between reboots.  If the sata device had been a root device then I
> would not have been able boot the system.  But now that I think about
> it, if Linux could not boot then neither could the pre-os
> option-rom/efi driver.
> 
> >> After the system is booted this state can be cleared via
> >> /sys/module/libsas/parameters/force_hard_reset
> >
> > I really don't think a module parameter for this is such a good idea ...
> > it effectively promotes all soft resets to being hard ones, which can
> > have a lot of unintended consequences.
> 
> Yes, it was only meant as a temporary "get out of a sticky situation"
> option, but given the above pre-os-driver realization it is not even
> useful for that case.  So I'm fine killing this patch.

Great, I'll drop it, thanks.

James


