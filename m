From: Luben Tuikov <luben_tuikov@adaptec.com>
Subject: Re: [PATCH] - mptfusion - adding back the spin locks in eh handle
 rs
Date: Thu, 23 Jun 2005 16:37:57 -0400
Message-ID: <42BB1DA5.6000302@adaptec.com>
References: <91888D455306F94EBD4D168954A9457C02D506D4@nacos172.co.lsil.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from magic.adaptec.com ([216.52.22.17]:57820 "EHLO magic.adaptec.com")
	by vger.kernel.org with ESMTP id S263084AbVFWUiH (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 23 Jun 2005 16:38:07 -0400
In-Reply-To: <91888D455306F94EBD4D168954A9457C02D506D4@nacos172.co.lsil.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Moore, Eric Dean" <Eric.Moore@lsil.com>
Cc: linux scsi <linux-scsi@vger.kernel.org>, James Bottomley <James.Bottomley@SteelEye.com>

On 06/23/05 16:12, Moore, Eric Dean wrote:
> Ok, explain that to me why having our driver hang is a good thing.
> The task managment requests to our firmware stack are done in interrupt
> mode,
> thus we have sleep and have interrupts enabled in the eh threads waiting on
> the commands to complete.
> Christoph H. requested this change about 6 months ago, asking that we remove
> our watchdog timers in the eh threads, in favor of this design.

Hi Eric,

It is up to the LLDD to know how to deliver a TMF to the device.
Whether this is done purely in process context (iSCSI) or
in mixed context is up to the LLDD.

Also, most often than not, you'd want to wait for the TMF to
return (iSCSI), to know its status (although you can assume it without fault).

Nevertheless, calling the eh routines in process context is the way
to go. (in order to allow for "sleeping", on delivery you can disable ints
as appropriate for the hw)

	Luben
