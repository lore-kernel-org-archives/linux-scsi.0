From: Jeffrey Lane <bladernr@samuraipoet.com>
Subject: ips.o driver for ServRAID cards works so far on Opteron and RHEL
 3
Date: Tue, 28 Oct 2003 22:27:33 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <3F9F33A5.7030203@samuraipoet.com>
References: <E1AEBNm-0007gk-SL@svr16.ehostpros.com> <3F9D59F7.2090900@wanadoo.es> <3F9DB238.10400@samuraipoet.com> <3F9DB64B.2010703@wanadoo.es>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pimout3-ext.prodigy.net ([207.115.63.102]:19856 "EHLO
	pimout3-ext.prodigy.net") by vger.kernel.org with ESMTP
	id S261845AbTJ2D0i (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 28 Oct 2003 22:26:38 -0500
In-Reply-To: <3F9DB64B.2010703@wanadoo.es>
List-Id: linux-scsi@vger.kernel.org
To: taroon-list@redhat.com

Just FYI Everyone, I ran tests on the ServRAID cards using the IPS 
driver that I had to compile for the Opteron processor, and it worked 
like a champ.

Just a recap,  the x86-64 version of AS3 does not include a driver for 
teh ServRAID cards (ips.o)

So, I compiled the driver using the kernel source that comes with AS3.

The code is ips.c and ips.h.  To compile it, you will have to comment 
out the three lines (or is it 4) that test to see if the machine 
architecture is x86 or itanium.  Those lines test arch, and if arch is 
not x86 or itanium then the compile dies with an error saying that the 
driver has not been compiled.

So, comment out those lines, edit the kernel make file to make sure you 
remove the work custom from the verson (teh version numbers have to 
match the kernel you are running) and then do the following:

make mrproper
cp configs/<version>-x86_64.config .config
make menuconfig

then in the scsi drivers section, select M (module) support for the IBM 
ServRAID cards (this is the ips.o driver) save the config and exit.

next you do this:

make dep && make SUBDIRS=drivers/scsi modules (this will make only the 
scsi drivers)

cp drivers/scsi/ips.o /lib/modules/<kernelversion>/kernel/drivers/scsi/
insmod ips.o

and you should then be able to see any disks or arrays connected to the 
ServRAID cards...

I ahve tested this so far on a 4Lx card and a 6M card, and both worked 
well when tested overnight under load.

THought I would throw that out there for anyone using these cards.

Cheers
J
Xose Vazquez Perez wrote:
> Jeffrey Lane wrote:
> 
> 
>>make clean
> 
>   ^^^^^^^^^^
> this step is -->>
> 
>>make mrproper
>>cp configs/<version>-x86_64.config .config
>>make menuconfig
> 
> 
>>turned on the IBM ServRAID support (set to M for module) then:
>>
>>make dep && make SUBDIRS=drivers/scsi modules
> 
>           ^
> -->> HERE
> 
> 
>>Officially, yes, but unofficially, no, it does work on an AMD 64.
> 
> 
> If it's reliable send a note to ipslinux@adaptec.com and
> to linux-scsi@vger.kernel.org ;-)
> 
> -thanks-

