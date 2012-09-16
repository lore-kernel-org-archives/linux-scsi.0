From: Bjorn Helgaas <bhelgaas@google.com>
Subject: Re: Fail to probe qla2xxx fiber channel card while doing pci hotplug
Date: Sat, 15 Sep 2012 21:30:50 -0600
Message-ID: <CAErSpo6OkAV-wwKnpMRAvisQ_Jj=w9dxLbO3JxkX2A_Vd8QX=Q@mail.gmail.com>
References: <505456FD.6040801@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-lb0-f174.google.com ([209.85.217.174]:59884 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751692Ab2IPDbM (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 15 Sep 2012 23:31:12 -0400
Received: by lbbgj3 with SMTP id gj3so3550744lbb.19
        for <linux-scsi@vger.kernel.org>; Sat, 15 Sep 2012 20:31:10 -0700 (PDT)
In-Reply-To: <505456FD.6040801@huawei.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Yijing Wang <wangyijing@huawei.com>
Cc: Andrew Vasquez <andrew.vasquez@qlogic.com>, linux-driver@qlogic.com, linux-scsi@vger.kernel.org, PCI <linux-pci@vger.kernel.org>

On Sat, Sep 15, 2012 at 4:22 AM, Yijing Wang <wangyijing@huawei.com> wrote:
> Hi all,
>    I encountered a very strange problem when I hot plug a fiber channel card(using qla2xxx driver).
> I did the hotplug in arch x86 machine, using pciehp driver for hotplug, this platform supports pci hot-plug triggering from both
> sysfs and attention button. If a hot-plug slot is empty when system boot-up, then hotplug FC card in this slot is ok.
> If a hot-plug slot has been embeded a FC card when system boot-up, hot-remove this card is ok, but hot-add this card will fail.
> I used
> #modprobe qla2xxx ql2xextended_error_logging=0x7fffffff
> to get all probe info. As bellow:
>
> Can anyone give me any suggestion for this problem?

It sounds like you did this:

  1) Power down system
  2) Remove FC card from slot
  3) Boot system
  4) Hot-add FC card
  5) Load qla2xxx driver
  6) qla2xxx driver claims FC card
  7) FC card works correctly

  8) Power down system
  9) Install FC card in slot
 10) Boot system
 11) Load qla2xxx driver
 12) qla2xxx driver claims FC card
 13) FC card works correctly
 14) Hot-remove card
 15) Hot-add card
 16) qla2xxx driver claims FC card
 17) FC card does not work

and I assume the dmesg log you included is just from steps 15 and 16
(correct me if I'm wrong).

It would be useful to see the entire log showing all these events so
we can compare the working cases with the non-working one.  If you use
the pciehp_debug module parameter, we should also see some pciehp
events that would help me understand that driver.
