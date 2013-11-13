From: Kishon Vijay Abraham I <kishon@ti.com>
Subject: Re: [PATCH v2 3/5] ata: Add APM X-Gene SATA driver
Date: Wed, 13 Nov 2013 10:50:46 +0530
Message-ID: <52830C2E.1040603@ti.com>
References: <1383980431-6572-1-git-send-email-lho@apm.com>	<201311110954.32904.arnd@arndb.de>	<CAPw-ZT=aVyw2yducpQMD2_rPPV7abKJZOH-Fs3bT2Ja=0tUNSQ@mail.gmail.com>	<201311121411.54423.arnd@arndb.de> <CAPw-ZTnqQk5cEJKSn239m=v9A7KmL8iVPcVnHWgq1E1TRCJ+og@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bear.ext.ti.com ([192.94.94.41]:47092 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751085Ab3KMFVZ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 13 Nov 2013 00:21:25 -0500
In-Reply-To: <CAPw-ZTnqQk5cEJKSn239m=v9A7KmL8iVPcVnHWgq1E1TRCJ+og@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Loc Ho <lho@apm.com>, Arnd Bergmann <arnd@arndb.de>
Cc: "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>, Olof Johansson <olof@lixom.net>, Suman Tripathi <stripathi@apm.com>, linux-scsi@vger.kernel.org, Jon Masters <jcm@redhat.com>, Tejun Heo <tj@kernel.org>, Tuan Phan <tphan@apm.com>

Hi,

On Wednesday 13 November 2013 04:09 AM, Loc Ho wrote:
> Hi Arnd,
> 
> I looked at the PHY generic framework and come across this statement
> below. Our SATA PHY is embedded into the SoC. Should I ignore this

Is your PHY embedded into the SoC or embedded into the SATA controller? If it's
within the SoC but not embedded into the SATA controller, you can use PHY
framework as the PHY is in a different IP and has a separate address space for
itself.
If it's within the SATA controller, then you might very well implement the PHY
logic in your SATA controller driver itself.
> statement below and implement the PHY driver using this framework?
> 
> +This framework will be of use only to devices that use external PHY (PHY
> +functionality is not embedded within the controller).

It means for PHYs embedded within the SATA controller and not within the SoC ;-)

Thanks
Kishon
> 
> -Loc
> 
> 
> On Tue, Nov 12, 2013 at 5:11 AM, Arnd Bergmann <arnd@arndb.de> wrote:
>> On Tuesday 12 November 2013, Loc Ho wrote:
>>> Hi Arnd/Olof,
>>>
>>> I looked over the phy code for USB and NET. There isn't such PHY
>>> infrastructure for SATA from what I can tell. It seems like I will
>>> need to put this all together. I am thinking about porting the USB
>>> version over (with changes for SATA) and put it under
>>> "./drivers/ata/phy". Any suggestion?
>>
>> Please have a look at the patches under the subject "Generic PHY Framework"
>> posted by Kishon Vijay Abraham. I thought they would have made it in
>> by now, but I have not followed the recent kernels closely since I am
>> on parental leave at the moment.
>>
>> IIRC they should unify USB, SATA and other PHY codes, but not network.
>>
>>         Arnd

