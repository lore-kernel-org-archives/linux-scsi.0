From: Arnd Bergmann <arnd@arndb.de>
Subject: Re: contention on long-held spinlock
Date: Tue, 23 Aug 2011 18:24:48 +0200
Message-ID: <201108231824.48512.arnd@arndb.de>
References: <4E4E2B2A.40100@odi.ch> <CAF_S4t_5qfx1H+nm+fvYd24k4ezF__JDFLvg6gv_so8SeVqKvA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.126.186]:53670 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752890Ab1HWQYw (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 23 Aug 2011 12:24:52 -0400
In-Reply-To: <CAF_S4t_5qfx1H+nm+fvYd24k4ezF__JDFLvg6gv_so8SeVqKvA@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bryan Donlan <bdonlan@gmail.com>
Cc: Ortwin =?iso-8859-1?q?Gl=FCck?= <odi@odi.ch>, linux-kernel@vger.kernel.org, Andrew Vasquez <andrew.vasquez@qlogic.com>, linux-driver@qlogic.com, linux-scsi@vger.kernel.org

On Friday 19 August 2011, Bryan Donlan wrote:
> That's what mutexes are for. Note, however, that interrupt handlers
> cannot use mutexes as they cannot sleep, nor can they wait for lock
> holders which may themselves sleep.

I agree that there is probably some other bug that needs to be fixed
in the driver, but for testing it may well be worth replacing
the spinlock with a mutex and the request_irq with request_threaded_irq.
A threaded IRQ is slower than a normal one but does allow mutexes.

	Arnd
