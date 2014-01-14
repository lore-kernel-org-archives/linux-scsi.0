From: Loc Ho <lho@apm.com>
Subject: Re: [PATCH v8 3/4] ata: Add APM X-Gene SoC SATA host controller driver
Date: Tue, 14 Jan 2014 08:21:28 -0800
Message-ID: <CAPw-ZTmn6JiDku=vz=m9v5MNuFrK_-d0ehU_88drCYGHM8Wv=Q@mail.gmail.com>
References: <1389031922-4309-3-git-send-email-lho@apm.com>
	<1389031922-4309-4-git-send-email-lho@apm.com>
	<52D052F9.8050703@redhat.com>
	<20140111193104.GD3257@mtj.dyndns.org>
	<6EB44142-06DA-4C9D-8999-CFA9EE30E03D@apm.com>
	<20140112114958.GA8509@mtj.dyndns.org>
	<CAPw-ZTmfKfPY3DRfJT6FQP78ULwfcjGG76cNfr9yk7UMdrO4wg@mail.gmail.com>
	<20140113160843.GB29053@htj.dyndns.org>
	<CAPw-ZT=A=c9-3BfP-LoDBXByQqfvATpAdS4NPPWB9+R1+GHfDA@mail.gmail.com>
	<20140114160312.GH12131@htj.dyndns.org>
	<20140114160419.GI12131@htj.dyndns.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from exprod5og116.obsmtp.com ([64.18.0.147]:45506 "HELO
	exprod5og116.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751642AbaANQVa (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 14 Jan 2014 11:21:30 -0500
Received: by mail-qe0-f46.google.com with SMTP id 8so2259000qea.5
        for <linux-scsi@vger.kernel.org>; Tue, 14 Jan 2014 08:21:28 -0800 (PST)
In-Reply-To: <20140114160419.GI12131@htj.dyndns.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Tejun Heo <tj@kernel.org>
Cc: David Milburn <dmilburn@redhat.com>, "olof@lixom.net" <olof@lixom.net>, "arnd@arndb.de" <arnd@arndb.de>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>, "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>, "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>, "jcm@redhat.com" <jcm@redhat.com>, "patches@apm.com" <patches@apm.com>, Tuan Phan <tphan@apm.com>, Suman Tripathi <stripathi@apm.com>

Hi,


>> > As mentioned, the flush requires immediately after reading the CI.
>> > Otherwise, there is still an chance that the command is completed and
>> > the OS notified the upper layer while the data is still in flight. For
>> > the initial version, I will remove the flush (IRQ wrapper) and submit
>> > separate patch.
>>
>> The function is called with ap->lock held.  Nothing can happen
>> inbetween.
>
> Oh, or do you mean that upper layer may get data which hasn't finish
> transferring without the flush?
>

In the ISR, the AHCI library code reads the CI register and then
performs XOR to determine which commands are completed. Then it goes
and processes the completed command(s). I am worry that the process of
processing the completed command(s), the upper layer may act on the
data before the data arrived at the DDR/cache. In answering your
question, yes.

-Loc.
