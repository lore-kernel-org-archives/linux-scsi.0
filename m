From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH v8 08/13] libsas: libsas.force_hard_reset module
 parameter
Date: Wed, 29 Feb 2012 15:55:51 -0600
Message-ID: <1330552551.8846.24.camel@dabdike>
References: <20120210084411.25701.94502.stgit@dwillia2-linux.jf.intel.com>
	 <20120210084520.25701.83280.stgit@dwillia2-linux.jf.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <20120210084520.25701.83280.stgit@dwillia2-linux.jf.intel.com>
Sender: linux-ide-owner@vger.kernel.org
To: Dan Williams <dan.j.williams@intel.com>
Cc: linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org, Jack Wang <jack_wang@usish.com>, Luben Tuikov <ltuikov@yahoo.com>, Xiangliang Yu <yuxiangl@marvell.com>
List-Id: linux-scsi@vger.kernel.org

On Fri, 2012-02-10 at 00:45 -0800, Dan Williams wrote:
> It is possible for a host to get "locked out" from talking to sata
> devices in the domain if, for example, its sas address changes but the
> expander topology has existing affiliations with the old address.  If
> the system is booted userspace can write to
> /sys/class/sas_phy/<phy-X>/hard_reset to clear the affiliation, however
> if this condition exists for the root device the module parameter can be
> used to promote all ata resets to hard resets.

I don't quite understand this.  Are you saying we can't (or shouldn't)
execute 

/sys/class/sas_phy/<phy-X>/hard_reset

on the root device for some reason?

> After the system is booted this state can be cleared via
> /sys/module/libsas/parameters/force_hard_reset

I really don't think a module parameter for this is such a good idea ...
it effectively promotes all soft resets to being hard ones, which can
have a lot of unintended consequences.

James


