From: Mark Rutland <mark.rutland@arm.com>
Subject: Re: [PATCH 01/23] devicetree: bindings: hisi_sas: add v2 HW bindings
Date: Fri, 8 Jan 2016 16:49:10 +0000
Message-ID: <20160108164910.GD32692@leverpostej>
References: <1452262542-64589-1-git-send-email-john.garry@huawei.com>
 <1452262542-64589-2-git-send-email-john.garry@huawei.com>
 <20160108145256.GG3097@leverpostej>
 <568FD281.4050207@huawei.com>
 <20160108151934.GA32692@leverpostej>
 <568FD70D.1090303@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <568FD70D.1090303@huawei.com>
Sender: linux-kernel-owner@vger.kernel.org
To: John Garry <john.garry@huawei.com>
Cc: JBottomley@odin.com, martin.petersen@oracle.com, robh+dt@kernel.org, pawel.moll@arm.com, ijc+devicetree@hellion.org.uk, galak@codeaurora.org, linuxarm@huawei.com, zhangfei.gao@linaro.org, xuwei5@hisilicon.com, john.garry2@mail.dcu.ie, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, arnd@arndb.de, devicetree@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Fri, Jan 08, 2016 at 03:34:37PM +0000, John Garry wrote:
> 
> >>>>+Optional main node properties:
> >>>>+ - am-max-trans : limit controller for am max transmissions
> >>>
> >>>Is this a boolean? Number?
> >>>
> >>
> >>This is a boolean. It is for dealing with a quirk in the chipset: an
> >>instance of the controller in the hip06 chipset requires registers
> >>set with a different init value.
> >
> >Ok. I think the property at needs a better description for that.
> >
> >It's not clear to me how "limit controller for am max transmissions"
> >maps to writing a specific value to some registers, but I don't know
> >much about SAS.
> >
> >Is this some well-known thing, or values specific to hip06?
> >
> >Thanks,
> >Mark.
> >
> 
> This is a specific issue for hip06 chipset.

Ok. So is this:

* a bug within the SAS controller in hip06, or:

* a requirement/bug of an endpoint attached to the controller, or:

* a requirement/bug of some interconnect between the controller and
  endpoint, or:

* some other integration bug?

Please describe what the issue is that you're trying to work around, not
only your solution to it.

> There is a bug in the HW on hip06 where controller #1 has to set to 2
> registers to non-default values to limit "am-max-transmissions".

I got that. However, I have no idea what "am-max-transmissions" is, no
idea why you need to limit it (hopefully you can describe that a little
better above), nor what the semantics are for "limit".

The description of the property is an imperative, which reads like a
description of a specific driver behaviour rather than a property of the
hardware that leads to that behaviour being necessary. That's a warning
sign that the property is ill-defined, and we may encounter problems in
future due to changes in Linux.

Without knowing _why_ it's necessary to limit this, it's not possible to
know if the property is both necessary and sufficient to solve the
problem such that it doesn't rear its ugly head in future.

For example, if this is simply one way to work around a hip06-specific
integration bug that we cannot imagine occurring elsewhere, it may be
better to instead key off of a platform-specific compatible string for
the v2 SAS controller in hip06. That gives us more freedom to apply
different workarounds if we have to.

I see that the presence of this property will cause the driver to writes
hard-coded values two two registers. Not knowing the format of those
registers, their default values, nor how they respond to writes, I can't
tell:

* If the writes have other effects.

* If the limit is a single bit being flipped (i.e. this is a boolean in
  hardware too).

* If the limit is some arbitrary chosen value which is not described in
  the property or the binding, nor what that value is. If we encounter a
  similar bug requiring a different bound in future, it may be
  problematic to have chosen an arbitrary fixed value, and it may make
  more sense to describe the value in the DT.

So, please:

* Update the DT property description to describe the specific HW issue
  that needs to be worked around, with a full description in the commit
  message.

* Add a comment to the driver to explain what the effect of the register
  writes is intended to be, i.e. what value am max transmissions is
  being set to, and why that value isn't arbitrary.

> This would not be a common SAS/SCSI controller property and is
> specific to our HW.

Ok.

Thanks,
Mark.
