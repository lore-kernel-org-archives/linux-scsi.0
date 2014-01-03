From: Loc Ho <lho@apm.com>
Subject: Re: [PATCH v7 4/4] arm64: Add APM X-Gene SoC SATA host controller DTS entries
Date: Fri, 3 Jan 2014 09:23:55 -0800
Message-ID: <CAPw-ZTnpG_qOWs7tZjDc2z+1nG0h7p6ojfuk5ZOLAYxRrb7N=A@mail.gmail.com>
References: <1388708539-333-1-git-send-email-lho@apm.com>
	<1388708539-333-4-git-send-email-lho@apm.com>
	<1388708539-333-5-git-send-email-lho@apm.com>
	<201401031633.18110.arnd@arndb.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from exprod5og105.obsmtp.com ([64.18.0.180]:52341 "HELO
	exprod5og105.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751217AbaACRX4 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 3 Jan 2014 12:23:56 -0500
Received: by mail-qc0-f177.google.com with SMTP id m20so14791914qcx.22
        for <linux-scsi@vger.kernel.org>; Fri, 03 Jan 2014 09:23:55 -0800 (PST)
In-Reply-To: <201401031633.18110.arnd@arndb.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Arnd Bergmann <arnd@arndb.de>
Cc: Olof Johansson <olof@lixom.net>, Tejun Heo <tj@kernel.org>, Linux SCSI List <linux-scsi@vger.kernel.org>, "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>, "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>, "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>, Jon Masters <jcm@redhat.com>, "patches@apm.com" <patches@apm.com>, Tuan Phan <tphan@apm.com>, Suman Tripathi <stripathi@apm.com>

Hi,

>> +                       sata23clk: sata23clk@1f22c000 {
>> +                               compatible = "apm,xgene-device-clock";
>> +                               #clock-cells = <1>;
>> +                               clocks = <&socplldiv2 0>;
>> +                               clock-names = "sata23clk";
>
>> +                       };
>> +
>> +                       sata45clk: sata45clk@1f23c000 {
>> +                               compatible = "apm,xgene-device-clock";
>> +                               #clock-cells = <1>;
>> +                               clocks = <&socplldiv2 0>;
>> +                               clock-names = "sata45clk";
>
> Something is wrong here: You have two devices with the same "compatible"
> string but using different "clock-names" strings. The binding document
> lists this as an optional property with the description  "shall be
> the name of the device clock. If missing, use the device name", which
> doesn't seem to make any sense.
>
> Please fix the binding and the existing users of this, and don't introduce
> any more broken instances. Since each device clock is documented to
> have only one parent anyway, please just make it an anonymous clock.

Okay I miss understood this... I will need to fix the X-Gene device
parent clocks as well in an separate patch to the clock driver owner.

-Loc
