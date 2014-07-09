From: Hans de Goede <hdegoede@redhat.com>
Subject: Re: uas - kernel panic on drive connection
Date: Wed, 09 Jul 2014 09:06:43 +0200
Message-ID: <53BCEA03.30304@redhat.com>
References: <20140704104028.2014aaf4@earthlink.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:37075 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751114AbaGIHGs (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 9 Jul 2014 03:06:48 -0400
In-Reply-To: <20140704104028.2014aaf4@earthlink.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jonathan.625266@earthlink.net
Cc: linux-scsi@vger.kernel.org

Hi, Jonathan

Fri, 04 Jul 2014, Jonathan wrote:

> Beginning with kernel 3.15.1, I am getting hard lockups every time I connect a
> drive to my USB 3 HDD dock with ASMedia ASM1051E UASP compliant chipset. The
> only way I am able work around this is to set the quirk to ignore uas for the
> device. Here are the kernel messages during connection followed by a backtrace:
>
> [  229.882190] usb 2-1: new SuperSpeed USB device number 3 using xhci_hcd
> [  229.908001] usb-storage 2-1:1.0: USB Mass Storage device detected
> [  229.908218] usb-storage 2-1:1.0: Quirks match for vid 174c pid 55aa: 400000
> [  229.908349] scsi7 : usb-storage 2-1:1.0
> [  230.912633] scsi 7:0:0:0: Direct-Access     ASMT     2105             0     PQ: 0 ANSI: 6
> [  230.914818] sd 7:0:0:0: [sdc] Attached SCSI removable disk
> [  289.680267] usb 2-1: USB disconnect, device number 3
> [  319.599862] usb 2-1: new SuperSpeed USB device number 4 using xhci_hcd
> [  319.626881] scsi8 : uas
> [  319.628221] xhci_hcd 0000:02:00.0: ERROR Transfer event TRB DMA ptr not part  of current TD
> [  320.029323] BUG: unable to handle kernel paging request at 0000000001000003

This looks like something is going wrong in the XHCI code, likely something
related to bulk-streams.

I've a dock with an ASMedia ASM1053E chipset myself and that one works fine with both
Nec and Intel XHCI controllers. What type of XHCI controller do you have ?

Can you please do "lspci" on the machine in question and include the output in your
next mail ?

Regards,

Hans
