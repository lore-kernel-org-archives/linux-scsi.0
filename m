From: Fabio Coatti <cova@ferrara.linux.it>
Subject: Re: Re: 2.6.10-rc2-mm2 usb storage still oopses
Date: Wed, 1 Dec 2004 02:06:36 +0100
Message-ID: <200412010206.37275.cova@ferrara.linux.it>
References: <Pine.LNX.4.44L0.0411301555260.1423-100000@ida.rowland.org>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8bit
Return-path: <linux-usb-devel-admin@lists.sourceforge.net>
In-Reply-To: <Pine.LNX.4.44L0.0411301555260.1423-100000@ida.rowland.org>
Content-Disposition: inline
Sender: linux-usb-devel-admin@lists.sourceforge.net
Errors-To: linux-usb-devel-admin@lists.sourceforge.net
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/linux-usb-devel>,
	<mailto:linux-usb-devel-request@lists.sourceforge.net?subject=unsubscribe>
List-Post: <mailto:linux-usb-devel@lists.sourceforge.net>
List-Help: <mailto:linux-usb-devel-request@lists.sourceforge.net?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/linux-usb-devel>,
	<mailto:linux-usb-devel-request@lists.sourceforge.net?subject=subscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum=linux-usb-devel>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: James Bottomley <James.Bottomley@steeleye.com>, Andrew Morton <akpm@osdl.org>, Pete Zaitcev <zaitcev@redhat.com>, Linux Kernel <linux-kernel@vger.kernel.org>, linux-usb-devel@lists.sourceforge.net, SCSI Mailing List <linux-scsi@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

Alle 21:58, martedì 30 novembre 2004, Alan Stern ha scritto:

> It may be that the device wants old_scheme_first to be set when it's
> operating at high speed and not set when operating at full speed!  You can
> test this guess by unloading one driver or the other and then plugging in
> the device.

Well, I've tried and in fact without 
old_scheme_first set ehci hands over the device to uhci, that fails to detect 
it.
And in fact uhci is loaded at boot before ehci. I've modified this, but the 
behaviour is not ok: it seems that the device is detected ok even if already 
present at boot, but then I've a keyoboard/mouse lockup

Dec  1 01:40:26 kefk kernel: ehci_hcd 0000:00:1d.7: port 3 high speed
Dec  1 01:40:26 kefk kernel: ehci_hcd 0000:00:1d.7: GetStatus port 3 status 
001005 POWER sig=se0  PE CONNECT
Dec  1 01:40:26 kefk kernel: usb 1-3: new high speed USB device using ehci_hcd 
and address 3
Dec  1 01:40:26 kefk kernel: usb 1-3: new device strings: Mfr=1, Product=2, 
SerialNumber=3
Dec  1 01:40:26 kefk kernel: usb 1-3: default language 0x0409
Dec  1 01:40:26 kefk kernel: usb 1-3: Product: Mass storage
Dec  1 01:40:26 kefk kernel: usb 1-3: Manufacturer: USB
Dec  1 01:40:26 kefk kernel: usb 1-3: SerialNumber: 142E19413C2FCA34
Dec  1 01:40:26 kefk kernel: usb 1-3: hotplug
Dec  1 01:40:26 kefk kernel: PCI: Setting latency timer of device 0000:00:1d.2 
to 64
Dec  1 01:40:26 kefk kernel: uhci_hcd 0000:00:1d.2: irq 169, io base 0xb400
Dec  1 01:40:26 kefk kernel: usb 1-3: adding 1-3:1.0 (config #1, interface 0)
Dec  1 01:40:26 kefk kernel: usb 1-3:1.0: hotplug


when cupds starts, that uses usb printer, the keyboard and mouse gets locked, 
simply no key press or mouse move are detected. (or, at least, it seems that 
cups driver loading causes the lockup, but I can try to repeat this).
the first log row after cups loading is this:
Dec  1 01:40:30 kefk kernel: ACPI: PCI interrupt 0000:03:04.0[A] -> GSI 20 
(level, low) -> IRQ 209

But I don't think taht this can be so useful.
Please let me know is different details are needed.


This happens only when ehci is loaded before uhci and flash key is present at 
boot. 
If I keep unplugged the flash key the boot sequence goes on without problem, 
then I can plug and use flash key.

I'm unable to see on the logs where something goes wrong, but if you can tell 
me if more data are needed I can cut&paste the logs.



-- 
Fabio Coatti       http://members.ferrara.linux.it/cova     
Ferrara Linux Users Group           http://ferrara.linux.it
GnuPG fp:9765 A5B6 6843 17BC A646  BE8C FA56 373A 5374 C703
Old SysOps never die... they simply forget their password.


-------------------------------------------------------
SF email is sponsored by - The IT Product Guide
Read honest & candid reviews on hundreds of IT Products from real users.
Discover which products truly live up to the hype. Start reading now. 
http://productguide.itmanagersjournal.com/
_______________________________________________
linux-usb-devel@lists.sourceforge.net
To unsubscribe, use the last form field at:
https://lists.sourceforge.net/lists/listinfo/linux-usb-devel
