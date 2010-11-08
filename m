From: =?utf-8?B?TWljaGHFgiBOYXphcmV3aWN6?= <m.nazarewicz@samsung.com>
Subject: Re: [PATCH] [USB] UAS: eliminate infinite loop; add debug print
Date: Mon, 08 Nov 2010 18:40:47 +0100
Message-ID: <op.vlu4p9uc7p4s8u@pikus>
References: <272723.33242.qm@web31808.mail.mud.yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8;
	format=flowed	delsp=yes
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mailout3.w1.samsung.com ([210.118.77.13]:52501 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755087Ab0KHRkt convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 8 Nov 2010 12:40:49 -0500
In-reply-to: <272723.33242.qm@web31808.mail.mud.yahoo.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Matthew Wilcox <willy@linux.intel.com>, Luben Tuikov <ltuikov@yahoo.com>
Cc: Greg KH <greg@kroah.com>, linux-usb@vger.kernel.org, linux-scsi@vger.kernel.org

>> -0700, Luben Tuikov wrote:
>> > Also add a debug option and a few debug prints.

> --- On Mon, 11/8/10, Matthew Wilcox <willy@linux.intel.com> wrote:
>> Why have you added your own debug scheme instead of using
>> dev_dbg?

On Mon, 08 Nov 2010 18:27:22 +0100, Luben Tuikov <ltuikov@yahoo.com> wr=
ote:
> Because, this debug "scheme" produces copious and otherwise unnecessa=
ry
> volume of debug information in a working driver. And because you can =
turn
> it on/off just for this driver. It is intended to be used only for
> debugging this driver and the UAS device(s) to which the driver
> communicates. 99.9% of the time, this setting will be a 'N' out there=
=2E
> And this is what the Kconfig help entry says: "If unsure, say 'N'."

dev_dbg() and pr_debug() are no-ops when DEBUG is not defined, so
proper way to do things is to use dev_dbg() and put the following
before any #includes:

#ifdef CONFIG_USB_UAS_DEBUG
#  define DEBUG 1
#endif

--=20
Best regards,                                        _     _
| Humble Liege of Serenely Enlightened Majesty of  o' \,=3D./ `o
| Computer Science,  Micha=C5=82 "mina86" Nazarewicz       (o o)
+----[mina86*mina86.com]---[mina86*jabber.org]----ooO--(_)--Ooo--
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
