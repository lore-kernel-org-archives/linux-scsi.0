From: Mark Rutland <mark.rutland@arm.com>
Subject: Re: [PATCH v2 02/32] devicetree: bindings: scsi: HiSi SAS
Date: Tue, 27 Oct 2015 15:03:41 +0000
Message-ID: <20151027150341.GH3091@leverpostej>
References: <1445868903-183817-1-git-send-email-john.garry@huawei.com>
 <1445868903-183817-3-git-send-email-john.garry@huawei.com>
 <20151026144523.GB12277@leverpostej>
 <562F777B.6020407@huawei.com>
 <20151027143939.GG3091@leverpostej>
 <562F9016.50807@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <562F9016.50807@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
To: zhangfei <zhangfei.gao@linaro.org>
Cc: John Garry <john.garry@huawei.com>, JBottomley@odin.com, robh+dt@kernel.org, pawel.moll@arm.com, ijc+devicetree@hellion.org.uk, galak@codeaurora.org, arnd@arndb.de, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, devicetree@vger.kernel.org, linuxarm@huawei.com, john.garry2@mail.dcu.ie, hare@suse.de, xuwei5@hisilicon.com
List-Id: linux-scsi@vger.kernel.org

> >>>>+  - ctrl-reg : offset to the following SAS control registers (in order):
> >>>>+		- reset assert
> >>>>+		- clock disable
> >>>>+		- reset status
> >>>>+		- reset de-assert
> >>>>+		- clock enable

[...]

> >It would be better to have each offset in a separate property.
> >
> These register are not used for different purpose.
> Instead, they are all used for one purpose, reset the sas controller;
> Though a bit complicated, the silicon has special requirement here.

While they are indeed used together, they are separate registers, as
listed above. There may be other registers in future that turn out to
be useful for the SAS controller, or it might turn out a new system
doesn't have all of the existing registers.

> So still prefer using the original method,
> ctrl-reg = <0xa60 0x33c 0x5a30 0xa64 0x338>;
> Since we can simply use of_property_read_u32_array.

That may be simpler now, but makes future maintenance harder.

Use separate properties.

Mark.
