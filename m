From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH v8 3/4] ata: Add APM X-Gene SoC SATA host controller
 driver
Date: Mon, 13 Jan 2014 11:08:43 -0500
Message-ID: <20140113160843.GB29053@htj.dyndns.org>
References: <1389031922-4309-1-git-send-email-lho@apm.com>
 <1389031922-4309-2-git-send-email-lho@apm.com>
 <1389031922-4309-3-git-send-email-lho@apm.com>
 <1389031922-4309-4-git-send-email-lho@apm.com>
 <52D052F9.8050703@redhat.com>
 <20140111193104.GD3257@mtj.dyndns.org>
 <6EB44142-06DA-4C9D-8999-CFA9EE30E03D@apm.com>
 <20140112114958.GA8509@mtj.dyndns.org>
 <CAPw-ZTmfKfPY3DRfJT6FQP78ULwfcjGG76cNfr9yk7UMdrO4wg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-ide-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CAPw-ZTmfKfPY3DRfJT6FQP78ULwfcjGG76cNfr9yk7UMdrO4wg@mail.gmail.com>
Sender: linux-ide-owner@vger.kernel.org
To: Loc Ho <lho@apm.com>
Cc: David Milburn <dmilburn@redhat.com>, "olof@lixom.net" <olof@lixom.net>, "arnd@arndb.de" <arnd@arndb.de>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>, "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>, "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>, "jcm@redhat.com" <jcm@redhat.com>, "patches@apm.com" <patches@apm.com>, Tuan Phan <tphan@apm.com>, Suman Tripathi <stripathi@apm.com>
List-Id: linux-scsi@vger.kernel.org

Hello, Loc.

On Sun, Jan 12, 2014 at 08:01:59PM -0800, Loc Ho wrote:
> Yes but Let me summary what overrides are required for this X-Gene
> SATA controller driver:
>
> 1. For Query ID, these two functions - ahci_read_id and ahci_qc_issue
> requires override.

But the comment in ahci_qc_issue() says it's for PMP.

> 2. For PMP support, these two functions - ahci_qc_prep and
> ahci_qc_fill_rtf requires override.

But the only difference between xgene_ahci_do_softreset() and
ahci_do_softreset() is that the former removes fbs handling from the
latter.  Why not just turn off HOST_CAP_FBS?

> 3. For softreset, softreset requires override to add additional flags
> in call to ahci_exec_polled_cmd.

which is what?  It's the same for the xgene and normal functions.

> 4. For IRQ and ensure data consistent for read operation, function
> ahci_interrupt and ahci_port_intr requires override. But it only
> requires an flush call right after reading from the CI register.
> 5. For hardreset, no need to explain this one as all SATA drivers
> require its only method.

No, they don't and the comments in your driver don't really explain
what's going on.  Why are we having retry loops inside hardreset
itself?  This can prolong recovery time significantly in corner cases.
Why is this necessary?

I'm having a lot of trouble understanding what you're trying to do
with your driver.  Maybe it'd help to submit as multiple patches where
the first one implements bare minimum to function and then later
patches adding more workarounds to achieve more functionalities?  I
can't apply the patch as it currently stands.

Some general comments.

* Let's use fully winged comments for multiline comments.

* I really don't like wrapping basic functions like readl/writel() in
  low level drivers.

* If your driver needs to append or prepent something to the existing
  one, export the existing one and then wrap that one with the extra
  logic around it.  Do not copy function body unnecessarily.  Even for
  the port_interrupt, it looks like you can just call the flush after
  invoking the normal ahci_handle_port_interrupt(), no?

-- 
tejun
