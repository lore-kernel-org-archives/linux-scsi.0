From: Loc Ho <lho@apm.com>
Subject: Re: [PATCH v8 3/4] ata: Add APM X-Gene SoC SATA host controller driver
Date: Sat, 11 Jan 2014 19:58:04 -0800
Message-ID: <6EB44142-06DA-4C9D-8999-CFA9EE30E03D@apm.com>
References: <1389031922-4309-1-git-send-email-lho@apm.com> <1389031922-4309-2-git-send-email-lho@apm.com> <1389031922-4309-3-git-send-email-lho@apm.com> <1389031922-4309-4-git-send-email-lho@apm.com> <52D052F9.8050703@redhat.com> <20140111193104.GD3257@mtj.dyndns.org>
Mime-Version: 1.0 (1.0)
Content-Type: text/plain;
	charset=us-ascii
Content-Transfer-Encoding: 8BIT
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <20140111193104.GD3257@mtj.dyndns.org>
Sender: linux-ide-owner@vger.kernel.org
To: Tejun Heo <tj@kernel.org>
Cc: David Milburn <dmilburn@redhat.com>, "olof@lixom.net" <olof@lixom.net>, "arnd@arndb.de" <arnd@arndb.de>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>, "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>, "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>, "jcm@redhat.com" <jcm@redhat.com>, "patches@apm.com" <patches@apm.com>, Tuan Phan <tphan@apm.com>, Suman Tripathi <stripathi@apm.com>
List-Id: linux-scsi@vger.kernel.org

Hi,

> On Jan 11, 2014, at 11:31 AM, Tejun Heo <tj@kernel.org> wrote:
> 
> Hello, David.
> 
>> On Fri, Jan 10, 2014 at 02:07:21PM -0600, David Milburn wrote:
>> Tejun, to avoid some of the interrupt handling code duplication, would
>> it better to have a AHCI_HFLAG_FLUSH and then change
>> 
>> this driver to set flush
>> 
>> hpriv->hpriv.flush = (void *) xgene_ahci_iob_flush;
>> 
>> and then standard code flush when necessary
>> 
>> ahci_handle_port_interrupt
>> 
>>       /* board-specific flush before servicing completed cmds */
>>       if (hpriv-> flags & AHCI_HFLAG_FLUSH)
>>               hpriv->flush(hpriv);
> 
> And this would be the only spot that this would be necessary?  If so,
> why not just wrap the interrupt handler?

The flush has to occurred immediately after reading the CI register. It can not wrap around the isr routine and issue the flush after or before the library ahci isr routine.

-Loc
