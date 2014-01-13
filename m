From: Loc Ho <lho@apm.com>
Subject: Re: [PATCH v8 3/4] ata: Add APM X-Gene SoC SATA host controller driver
Date: Sun, 12 Jan 2014 20:01:59 -0800
Message-ID: <CAPw-ZTmfKfPY3DRfJT6FQP78ULwfcjGG76cNfr9yk7UMdrO4wg@mail.gmail.com>
References: <1389031922-4309-1-git-send-email-lho@apm.com>
	<1389031922-4309-2-git-send-email-lho@apm.com>
	<1389031922-4309-3-git-send-email-lho@apm.com>
	<1389031922-4309-4-git-send-email-lho@apm.com>
	<52D052F9.8050703@redhat.com>
	<20140111193104.GD3257@mtj.dyndns.org>
	<6EB44142-06DA-4C9D-8999-CFA9EE30E03D@apm.com>
	<20140112114958.GA8509@mtj.dyndns.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <20140112114958.GA8509@mtj.dyndns.org>
Sender: linux-ide-owner@vger.kernel.org
To: Tejun Heo <tj@kernel.org>
Cc: David Milburn <dmilburn@redhat.com>, "olof@lixom.net" <olof@lixom.net>, "arnd@arndb.de" <arnd@arndb.de>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>, "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>, "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>, "jcm@redhat.com" <jcm@redhat.com>, "patches@apm.com" <patches@apm.com>, Tuan Phan <tphan@apm.com>, Suman Tripathi <stripathi@apm.com>
List-Id: linux-scsi@vger.kernel.org

Hi,

> On Sat, Jan 11, 2014 at 07:58:04PM -0800, Loc Ho wrote:
>> The flush has to occurred immediately after reading the CI
>> register. It can not wrap around the isr routine and issue the flush
>> after or before the library ahci isr routine.
>
> I see.  So, you're saying that if PMP support is disabled for the
> controller, the driver would need to reimplement only the interrupt
> handler?
>

Yes but Let me summary what overrides are required for this X-Gene
SATA controller driver:

1. For Query ID, these two functions - ahci_read_id and ahci_qc_issue
requires override.
2. For PMP support, these two functions - ahci_qc_prep and
ahci_qc_fill_rtf requires override.
3. For softreset, softreset requires override to add additional flags
in call to ahci_exec_polled_cmd.
4. For IRQ and ensure data consistent for read operation, function
ahci_interrupt and ahci_port_intr requires override. But it only
requires an flush call right after reading from the CI register.
5. For hardreset, no need to explain this one as all SATA drivers
require its only method.

-Loc
