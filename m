From: Loc Ho <lho@apm.com>
Subject: Re: [PATCH v8 3/4] ata: Add APM X-Gene SoC SATA host controller driver
Date: Tue, 14 Jan 2014 07:57:19 -0800
Message-ID: <CAPw-ZT=A=c9-3BfP-LoDBXByQqfvATpAdS4NPPWB9+R1+GHfDA@mail.gmail.com>
References: <1389031922-4309-1-git-send-email-lho@apm.com>
	<1389031922-4309-2-git-send-email-lho@apm.com>
	<1389031922-4309-3-git-send-email-lho@apm.com>
	<1389031922-4309-4-git-send-email-lho@apm.com>
	<52D052F9.8050703@redhat.com>
	<20140111193104.GD3257@mtj.dyndns.org>
	<6EB44142-06DA-4C9D-8999-CFA9EE30E03D@apm.com>
	<20140112114958.GA8509@mtj.dyndns.org>
	<CAPw-ZTmfKfPY3DRfJT6FQP78ULwfcjGG76cNfr9yk7UMdrO4wg@mail.gmail.com>
	<20140113160843.GB29053@htj.dyndns.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <20140113160843.GB29053@htj.dyndns.org>
Sender: linux-ide-owner@vger.kernel.org
To: Tejun Heo <tj@kernel.org>
Cc: David Milburn <dmilburn@redhat.com>, "olof@lixom.net" <olof@lixom.net>, "arnd@arndb.de" <arnd@arndb.de>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>, "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>, "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>, "jcm@redhat.com" <jcm@redhat.com>, "patches@apm.com" <patches@apm.com>, Tuan Phan <tphan@apm.com>, Suman Tripathi <stripathi@apm.com>
List-Id: linux-scsi@vger.kernel.org

Hi,

>>
>> 1. For Query ID, these two functions - ahci_read_id and ahci_qc_issue
>> requires override.
>
> But the comment in ahci_qc_issue() says it's for PMP.

Yes... ahci_qc_issue is only needed with PMP due to query ID errata. I
will drop the ahci_qc_issue in the next version as I will only provide
the basic driver as recommended. Then submit individual patch for each
errata.

>
>> 2. For PMP support, these two functions - ahci_qc_prep and
>> ahci_qc_fill_rtf requires override.
>
> But the only difference between xgene_ahci_do_softreset() and
> ahci_do_softreset() is that the former removes fbs handling from the
> latter.  Why not just turn off HOST_CAP_FBS?

Okay... I will remove support for PMP/FBS for this initial version.

>
>> 3. For softreset, softreset requires override to add additional flags
>> in call to ahci_exec_polled_cmd.
>
> which is what?  It's the same for the xgene and normal functions.

I will remove this override for the initial version as this is only
required for PMP. We need "AHCI_CMD_RESET" and "AHCI_CMD_CLR_BUSY" set
when call into function ahci_exec_polled_cmd when issue the second D2H
register FIS.

>
>> 4. For IRQ and ensure data consistent for read operation, function
>> ahci_interrupt and ahci_port_intr requires override. But it only
>> requires an flush call right after reading from the CI register.
>> 5. For hardreset, no need to explain this one as all SATA drivers
>> require its only method.
>
> No, they don't and the comments in your driver don't really explain
> what's going on.  Why are we having retry loops inside hardreset
> itself?  This can prolong recovery time significantly in corner cases.
> Why is this necessary?

There are two retry in the hardreset. The first retry is due to the
requirement to have slightly modified PHY setting for different speed
of the attached disk. The default is Gen3. If it is Gen1 or Gen2 disk
attached, HW will require slightly modified PHY setting. The second
retry is due to the fact that link may not link up the first time due
to HW errata. For the initial version, I will remove the second retry
and submit an separate patch.

>
> I'm having a lot of trouble understanding what you're trying to do
> with your driver.  Maybe it'd help to submit as multiple patches where
> the first one implements bare minimum to function and then later
> patches adding more workarounds to achieve more functionalities?  I
> can't apply the patch as it currently stands.

I agree.

>
> Some general comments.
>
> * Let's use fully winged comments for multiline comments.
>
> * I really don't like wrapping basic functions like readl/writel() in
>   low level drivers.

I will remove these wrapper in next version.

>
> * If your driver needs to append or prepent something to the existing
>   one, export the existing one and then wrap that one with the extra
>   logic around it.  Do not copy function body unnecessarily.  Even for
>   the port_interrupt, it looks like you can just call the flush after
>   invoking the normal ahci_handle_port_interrupt(), no?

As mentioned, the flush requires immediately after reading the CI.
Otherwise, there is still an chance that the command is completed and
the OS notified the upper layer while the data is still in flight. For
the initial version, I will remove the flush (IRQ wrapper) and submit
separate patch.

-Loc
