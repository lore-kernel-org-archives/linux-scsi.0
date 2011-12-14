From: Biblioteka UR <biblio@univ.rzeszow.pl>
Subject: Re: mptspi init failure on Sparc SMP in Linux 3.0
Date: Wed, 14 Dec 2011 09:31:10 +0100
Message-ID: <4EE85ECE.8080101@univ.rzeszow.pl>
References: <4EB7D137.7090903@univ.rzeszow.pl>	 <20111107205409.GG3366@decadent.org.uk> <4EB858E8.6090304@univ.rzeszow.pl> <1320721518.18929.15.camel@deadeye> <A6888A6805518E4EA4AF7072A28264A6047262C728@inbmail02.lsi.com> <4EE5F1F4.3000006@univ.rzeszow.pl> <A6888A6805518E4EA4AF7072A28264A6047278DE4C@inbmail02.lsi.com> <A11ADD3877B3C543B65BE8E196B7BDFF0144B0300C@cosmail02.lsi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from atena.univ.rzeszow.pl ([62.93.43.134]:34059 "EHLO
	atena.univ.rzeszow.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754418Ab1LNIbi (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 14 Dec 2011 03:31:38 -0500
In-Reply-To: <A11ADD3877B3C543B65BE8E196B7BDFF0144B0300C@cosmail02.lsi.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Krishnamoorthy, Praveen" <Praveen.Krishnamoorthy@lsi.com>
Cc: "Nandigama, Nagalakshmi" <Nagalakshmi.Nandigama@lsi.com>, Ben Hutchings <ben@decadent.org.uk>, "Moore, Eric" <Eric.Moore@lsi.com>, "647900@bugs.debian.org" <647900@bugs.debian.org>, linux-scsi <linux-scsi@vger.kernel.org>, DL-MPT Fusion Linux <DL-MPTFusionLinux@lsi.com>

Praveen,

Thank you for your response.

This is Sparc server and here is silo, not grub. So I do not know how 
well I tried your suggestions.

root@fire:/boot# ls -l
total 28506
lrwxrwxrwx 1 root root        1 Nov  5 08:28 boot -> .
-rw-r--r-- 1 root root    88515 Nov 14 16:35 config-3.1.0-1-sparc64
-rw-r--r-- 1 root root    88956 Nov 14 16:47 config-3.1.0-1-sparc64-smp
lrwxrwxrwx 1 root root        1 Nov  5 08:28 etc -> .
-rw-r--r-- 1 root root     1024 Aug 26  2010 fd.b
-rw-r--r-- 1 root root      512 Aug 26  2010 first.b
-rw-r--r-- 1 root root     1024 Aug 26  2010 generic.b
-rw-r--r-- 1 root root      692 Aug 26  2010 ieee32.b
lrwxrwxrwx 1 root root       30 Nov 23 08:13 initrd.img -> 
initrd.img-3.1.0-1-sparc64-smp
-rw-r--r-- 1 root root 10201990 Nov 23 08:05 initrd.img-3.1.0-1-sparc64
-rw-r--r-- 1 root root 10293974 Dec 12 10:34 initrd.img-3.1.0-1-sparc64-smp
lrwxrwxrwx 1 root root       26 Nov 23 08:04 initrd.img.old -> 
initrd.img-3.1.0-1-sparc64
-rw-r--r-- 1 root root     7704 Aug 26  2010 isofs.b
drwxr-xr-x 2 root root    12288 Nov  5 08:22 lost+found
-rw-r--r-- 1 root root     7680 Nov  5 08:28 old.b
-rw-r--r-- 1 root root    78336 Nov  5 08:28 second.b
-rw-r--r-- 1 root root      199 Dec 14 08:36 silo.conf
-rw-r--r-- 1 root root    76387 Aug 26  2010 silotftp.b
-rw-r--r-- 1 root root  1629480 Nov 14 16:35 System.map-3.1.0-1-sparc64
-rw-r--r-- 1 root root  1676706 Nov 14 16:47 System.map-3.1.0-1-sparc64-smp
-rw-r--r-- 1 root root      512 Aug 26  2010 ultra.b
lrwxrwxrwx 1 root root       27 Nov 23 08:13 vmlinuz -> 
vmlinuz-3.1.0-1-sparc64-smp
-rw-r--r-- 1 root root  2385979 Nov 14 16:34 vmlinuz-3.1.0-1-sparc64
-rw-r--r-- 1 root root  2504212 Nov 14 16:46 vmlinuz-3.1.0-1-sparc64-smp
lrwxrwxrwx 1 root root       23 Nov 23 08:04 vmlinuz.old -> 
vmlinuz-3.1.0-1-sparc64

I tried:
root@fire:/boot# cat silo.conf
root=/dev/sda2
partition=1
default=LinuxOLD
read-only
timeout=100

image=/vmlinuz
         label=Linux
         initrd=/initrd.img
         append="pci=routeirq"

image=/vmlinuz.old
         label=LinuxOLD
         initrd=/initrd.img.old

and

root@fire:/boot# cat silo.conf
root=/dev/sda2
partition=1
default=LinuxOLD
read-only
timeout=100

image=/vmlinuz
         label=Linux
         initrd=/initrd.img
         append="irqpoll"

image=/vmlinuz.old
         label=LinuxOLD
         initrd=/initrd.img.old


These changes have not helped. I have the same error messages.

Unfortunately I can't collect the kernel messages with smp linux-image. 
I set in rsyslog.conf

kern.debug                      -/var/log/kern.debug

I had already set

*.=debug;\
         auth,authpriv.none;\
         news.none;mail.none     -/var/log/debug

but there is no log messages from broken boot. I can collect messages 
only from putty.

Regards,
Mariusz

PS. Sorry for my English. :)

W dniu 2011-12-13 19:36, Krishnamoorthy, Praveen pisze:
> Mariusz,
>
>>>> [   68.319518] mptbase: ioc0: WARNING - Issuing Reset from
>> mpt_config!!, doorbell=0x24000000
>>>> [   69.175505] mptbase: ioc0: Attempting Retry Config request type
>> 0x3, page 0x, action 0
>>>> [   84.267524] mptbase: ioc0: WARNING - Issuing Reset from
>> mpt_config!!, doorbell=0x24000000
> As Nagalakshmi pointed out, the series of reset happens because the config request for reading the page header fails. This is the first time the message queues are used when the card is coming up, therefore taking into account, that the same driver and same card works perfectly on non-smp linux kernel,  I am guessing that the config request would have been sent successfully and the firmware would have processed the request and raised an interrupt through the IRQ line assigned for this card, it is somehow not routed to our driver's interrupt service routine. Therefore could you try the following to check if any of it works?
>
> 1. add pci=routeirq to the kernel boot parameters in /boot/grub/menu.lst
> Eg) 	
> title          Debian XYZ
> root           (hdX,X)
> kernel         /boot/vmlinuz-XYZ root=XX ro quiet splash pci=routeirq
> initrd         /boot/initrd.img-XYZ
>
> 2. add irqpoll to the kernel boot parameters in /boot/grub/menu.lst
> Eg) 	
> title          Debian XYZ
> root           (hdX,X)
> kernel         /boot/vmlinuz-XYZ root=XX ro quiet splash irqpoll
> initrd         /boot/initrd.img-XYZ
>
> Regards,
> Praveen
>

