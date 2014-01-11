From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH v8 3/4] ata: Add APM X-Gene SoC SATA host controller
 driver
Date: Sat, 11 Jan 2014 14:31:04 -0500
Message-ID: <20140111193104.GD3257@mtj.dyndns.org>
References: <1389031922-4309-1-git-send-email-lho@apm.com>
 <1389031922-4309-2-git-send-email-lho@apm.com>
 <1389031922-4309-3-git-send-email-lho@apm.com>
 <1389031922-4309-4-git-send-email-lho@apm.com>
 <52D052F9.8050703@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-ide-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <52D052F9.8050703@redhat.com>
Sender: linux-ide-owner@vger.kernel.org
To: David Milburn <dmilburn@redhat.com>
Cc: Loc Ho <lho@apm.com>, olof@lixom.net, arnd@arndb.de, linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org, devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org, jcm@redhat.com, patches@apm.com, Tuan Phan <tphan@apm.com>, Suman Tripathi <stripathi@apm.com>
List-Id: linux-scsi@vger.kernel.org

Hello, David.

On Fri, Jan 10, 2014 at 02:07:21PM -0600, David Milburn wrote:
> Tejun, to avoid some of the interrupt handling code duplication, would
> it better to have a AHCI_HFLAG_FLUSH and then change
> 
> this driver to set flush
> 
> hpriv->hpriv.flush = (void *) xgene_ahci_iob_flush;
> 
> and then standard code flush when necessary
> 
> ahci_handle_port_interrupt
> 
>        /* board-specific flush before servicing completed cmds */
>        if (hpriv-> flags & AHCI_HFLAG_FLUSH)
>                hpriv->flush(hpriv);

And this would be the only spot that this would be necessary?  If so,
why not just wrap the interrupt handler?

Thanks.

-- 
tejun
