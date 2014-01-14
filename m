From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH v8 3/4] ata: Add APM X-Gene SoC SATA host controller
 driver
Date: Tue, 14 Jan 2014 11:03:12 -0500
Message-ID: <20140114160312.GH12131@htj.dyndns.org>
References: <1389031922-4309-2-git-send-email-lho@apm.com>
 <1389031922-4309-3-git-send-email-lho@apm.com>
 <1389031922-4309-4-git-send-email-lho@apm.com>
 <52D052F9.8050703@redhat.com>
 <20140111193104.GD3257@mtj.dyndns.org>
 <6EB44142-06DA-4C9D-8999-CFA9EE30E03D@apm.com>
 <20140112114958.GA8509@mtj.dyndns.org>
 <CAPw-ZTmfKfPY3DRfJT6FQP78ULwfcjGG76cNfr9yk7UMdrO4wg@mail.gmail.com>
 <20140113160843.GB29053@htj.dyndns.org>
 <CAPw-ZT=A=c9-3BfP-LoDBXByQqfvATpAdS4NPPWB9+R1+GHfDA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-ide-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CAPw-ZT=A=c9-3BfP-LoDBXByQqfvATpAdS4NPPWB9+R1+GHfDA@mail.gmail.com>
Sender: linux-ide-owner@vger.kernel.org
To: Loc Ho <lho@apm.com>
Cc: David Milburn <dmilburn@redhat.com>, "olof@lixom.net" <olof@lixom.net>, "arnd@arndb.de" <arnd@arndb.de>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>, "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>, "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>, "jcm@redhat.com" <jcm@redhat.com>, "patches@apm.com" <patches@apm.com>, Tuan Phan <tphan@apm.com>, Suman Tripathi <stripathi@apm.com>
List-Id: linux-scsi@vger.kernel.org

Hey,

On Tue, Jan 14, 2014 at 07:57:19AM -0800, Loc Ho wrote:
> > No, they don't and the comments in your driver don't really explain
> > what's going on.  Why are we having retry loops inside hardreset
> > itself?  This can prolong recovery time significantly in corner cases.
> > Why is this necessary?
> 
> There are two retry in the hardreset. The first retry is due to the
> requirement to have slightly modified PHY setting for different speed
> of the attached disk. The default is Gen3. If it is Gen1 or Gen2 disk
> attached, HW will require slightly modified PHY setting. The second
> retry is due to the fact that link may not link up the first time due
> to HW errata. For the initial version, I will remove the second retry
> and submit an separate patch.

And please explain what's going on in more detail in the comments.

> > * If your driver needs to append or prepent something to the existing
> >   one, export the existing one and then wrap that one with the extra
> >   logic around it.  Do not copy function body unnecessarily.  Even for
> >   the port_interrupt, it looks like you can just call the flush after
> >   invoking the normal ahci_handle_port_interrupt(), no?
> 
> As mentioned, the flush requires immediately after reading the CI.
> Otherwise, there is still an chance that the command is completed and
> the OS notified the upper layer while the data is still in flight. For
> the initial version, I will remove the flush (IRQ wrapper) and submit
> separate patch.

The function is called with ap->lock held.  Nothing can happen
inbetween.

Thanks.

-- 
tejun
