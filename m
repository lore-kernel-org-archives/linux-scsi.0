From: Rabeeh Khoury <rabeeh@il.marvell.com>
Subject: NMI Watchdog timeout problem
Date: Wed, 20 Aug 2003 14:53:17 +0300
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <3F43612D.5060909@il.marvell.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pop3.galileo.co.il ([199.203.130.130]:55513 "EHLO
	mail.galileo.co.il") by vger.kernel.org with ESMTP id S261941AbTHTLvI
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 20 Aug 2003 07:51:08 -0400
Received: from il.marvell.com (linux2.galileo.co.il [10.2.40.2])
	by mail.galileo.co.il (8.12.6/8.12.6) with ESMTP id h7KCmN6D009706
	for <linux-scsi@vger.kernel.org>; Wed, 20 Aug 2003 14:48:23 +0200 (GMT-2)
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Hi All,

I'm having a problem with my SCSI detect function.
I have a dual CPU machine running kernel 2.4.19-SMP and I have two cards 
in the system (our own cards that we do internal development on).
The detect function (as pointed to by the host template data structure) 
takes long time for initializing 8 drives connected to both cards (~8 
seconds) ; this is part of the initialization sequence and a must to do 
path.
During this time the detect function goes to first card, ioremaps the 
PCI BAR spaces and initilzlies 4 drives (~4 seconds) then goes to the 
other card and ioremaps the PCI BAR space and then initializes the other 
4 drives (another ~4 seconds).
What I'm seeing is that in random places within the detect function I 
get an NMI watchdog timer and the system crashes.

Notes -
1.. The detect function doesn't disable interrupts on local CPU or any 
other CPU.
2.. The driver works perfectly on a single CPU machine.

Can any one please explain to me why the watchog timer expires, even 
though interrupts are enabled ?
Do you have any suggestion how to workaround this ?

Thank you,
Rabeeh



