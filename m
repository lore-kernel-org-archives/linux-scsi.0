From: Denis Vlasenko <vda@port.imtp.ilyichevsk.odessa.ua>
Subject: Re: SCSI aic7xxx driver: Initialization Failure over a kdump reboot
Date: Fri, 7 Jan 2005 19:36:25 +0200
Message-ID: <200501071936.25993.vda@port.imtp.ilyichevsk.odessa.ua>
References: <1105014959.2688.296.camel@2fwv946.in.ibm.com> <20050106195043.4b77c63e.akpm@osdl.org> <41DE15C7.6030102@nit.ca>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="koi8-r"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner+glk-linux-kernel=40m.gmane.org-S261373AbVAGRlL@vger.kernel.org>
In-Reply-To: <41DE15C7.6030102@nit.ca>
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
To: Lukasz Kosewski <lkosewsk@nit.ca>, Andrew Morton <akpm@osdl.org>
Cc: Arjan van de Ven <arjan@infradead.org>, vgoyal@in.ibm.com, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Friday 07 January 2005 06:53, Lukasz Kosewski wrote:
> Andrew Morton wrote:
> >> looks like the following is happening:
> >> the controller wants to send an irq (probably from previous life)
> >> then suddenly the driver gets loaded
> >> * which registers an irq handler
> >> * which does pci_enable_device()
> >> and .. the irq goes through. 
> >> the irq handler just is not yet expecting this irq, so
> >> returns "uh dunno not mine"
> >> the kernel then decides to disable the irq on the apic level
> >> and then the driver DOES need an irq during init
> >> ... which never happens.
> >>
> > 
> > 
> > yes, that's exactly what e100 was doing on my laptop last month.  Fixed
> > that by arranging for the NIC to be reset before the call to
> > pci_set_master().
> 
> I noticed the exact same thing with a usb-uhci hub on a VIA MicroATX
> board a month back.  I rewrote the init sequence of the driver so that
> it resets all of the hubs in the system first, and THEN registers their
> interrupts.

"Me too".

prism54 had similar bug long ago.
--
vda
