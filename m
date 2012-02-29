From: Dan Williams <dan.j.williams@intel.com>
Subject: Re: [PATCH v8 08/13] libsas: libsas.force_hard_reset module parameter
Date: Wed, 29 Feb 2012 15:22:13 -0800
Message-ID: <CABE8wwt3tMT7wmSG=k_z6FOvBaStwuG1NF68Cjqi0qacaQVA0Q@mail.gmail.com>
References: <20120210084411.25701.94502.stgit@dwillia2-linux.jf.intel.com>
	<20120210084520.25701.83280.stgit@dwillia2-linux.jf.intel.com>
	<1330552551.8846.24.camel@dabdike>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <1330552551.8846.24.camel@dabdike>
Sender: linux-ide-owner@vger.kernel.org
To: James Bottomley <James.Bottomley@hansenpartnership.com>
Cc: linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org, Jack Wang <jack_wang@usish.com>, Luben Tuikov <ltuikov@yahoo.com>, Xiangliang Yu <yuxiangl@marvell.com>
List-Id: linux-scsi@vger.kernel.org

On Wed, Feb 29, 2012 at 1:55 PM, James Bottomley
<James.Bottomley@hansenpartnership.com> wrote:
> On Fri, 2012-02-10 at 00:45 -0800, Dan Williams wrote:
>> It is possible for a host to get "locked out" from talking to sata
>> devices in the domain if, for example, its sas address changes but t=
he
>> expander topology has existing affiliations with the old address. =A0=
If
>> the system is booted userspace can write to
>> /sys/class/sas_phy/<phy-X>/hard_reset to clear the affiliation, howe=
ver
>> if this condition exists for the root device the module parameter ca=
n be
>> used to promote all ata resets to hard resets.
>
> I don't quite understand this. =A0Are you saying we can't (or shouldn=
't)
> execute
>
> /sys/class/sas_phy/<phy-X>/hard_reset
>
> on the root device for some reason?

The case I ran into was accidentally changing the host sas address
between reboots.  If the sata device had been a root device then I
would not have been able boot the system.  But now that I think about
it, if Linux could not boot then neither could the pre-os
option-rom/efi driver.

>> After the system is booted this state can be cleared via
>> /sys/module/libsas/parameters/force_hard_reset
>
> I really don't think a module parameter for this is such a good idea =
=2E..
> it effectively promotes all soft resets to being hard ones, which can
> have a lot of unintended consequences.

Yes, it was only meant as a temporary "get out of a sticky situation"
option, but given the above pre-os-driver realization it is not even
useful for that case.  So I'm fine killing this patch.

--
Dan
