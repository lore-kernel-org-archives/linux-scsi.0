From: Marc Gonzalez <marc.w.gonzalez@free.fr>
Subject: Re: [PATCH v5 1/2] scsi: ufs: Do not disable vccq in UFSHC driver
Date: Wed, 13 Feb 2019 11:05:28 +0100
Message-ID: <cc915cc2-722b-5cae-6c8b-b0d50d90c56d@free.fr>
References: <494cd639-89a7-8868-b63a-ea7cdcba9777@free.fr>
 <be3ef9bf-438b-4e8a-62c4-f75458e8ecc0@free.fr>
 <20190211172340.GG22391@sirena.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190211172340.GG22391@sirena.org.uk>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Mark Brown <broonie@kernel.org>
Cc: SCSI <linux-scsi@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>, Jeffrey Hugo <jhugo@codeaurora.org>, Bjorn Andersson <bjorn.andersson@linaro.org>, Evan Green <evgreen@chromium.org>, Douglas Anderson <dianders@chromium.org>, Alim Akhtar <alim.akhtar@samsung.com>, Avri Altman <avri.altman@wdc.com>, Pedro Sousa <pedrom.sousa@synopsys.com>, Joao Pinto <jpinto@synopsys.com>, Liam Girdwood <lgirdwood@gmail.com>, Rob Herring <robh+dt@kernel.org>, Bart Van Assche <bart.vanassche@wdc.com>, Stanislav Nijnikov <stanislav.nijnikov@wdc.com>, Alex Lemberg <alex.lemberg@wdc.com>, Ohad Sharabi <ohad.sharabi@wdc.com>, Venkat Gopalakrishnan <venkatg@codeaurora.org>, Subhash Jadavani <subhashj@codeaurora.org>, Yaniv Gardi <ygardi@codeaurora.org>
List-Id: linux-scsi@vger.kernel.org

On 11/02/2019 18:23, Mark Brown wrote:

> On Mon, Feb 11, 2019 at 02:32:15PM +0100, Marc Gonzalez wrote:
> 
>> Unfortunately, this optimization breaks UFS on systems where vccq
>> powers not only the Flash chip, but the host controller as well,
>> such as APQ8098 MEDIABOX or MTP8998.
>> 
>> In my opinion, the rationale for the original patch is questionable.
>> If neither the UFSHC, nor the Flash chip, require any load from vccq,
>> then that power rail should simply not be specified at all in the DT.
> 
> If the supply is physically connected it should be valid to represent
> this in DT regardless of how or if the supply gets used at runtime.
> However it does sound like this support needs to be better thought
> through to make sure we have represented the supplies to the flash chip
> and the controller separately - it seems like right now there's no
> tracking of the supplies needed for the controller and the assumption is
> that only the flash chip needs managing which is breaking things.

As far as I'm aware, the conflation of host controller with their respective
storage medium occurs across several techs: UFS, NAND, SDHC, EMMC.

There might be room for improvement, but I don't think these considerations
should hold up this series, which fixes something that is broken *today*.

UFS reviewers (Alim, Avri, Pedro), can I get at least one Acked-by to remove
this small power optimization that breaks UFS on my system?

Regards.
