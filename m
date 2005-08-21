From: mikellp <mikpolniak@adelphia.net>
Subject: Re: [Bugme-new] [Bug 5003] New: Problem with symbios	driver	on	recent	-mm trees
Date: Sun, 21 Aug 2005 12:16:01 -0400
Message-ID: <pan.2005.08.21.16.16.00.766934@adelphia.net>
References: <135040000.1123216397@[10.10.2.4]> <20050804233927.2d3abb16.akpm@osdl.org> <1123251892.5003.6.camel@mulgrave> <179280000.1123252564@[10.10.2.4]> <1123254086.5003.10.camel@mulgrave> <453380000.1123562466@[10.10.2.4]> <1123597604.5170.10.camel@mulgrave> <531000000.1123599581@[10.10.2.4]> <1123606536.5170.27.camel@mulgrave>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from zeus1.kernel.org ([204.152.191.4]:6606 "EHLO zeus1.kernel.org")
	by vger.kernel.org with ESMTP id S1751213AbVHUVo7 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sun, 21 Aug 2005 17:44:59 -0400
Received: from ciao.gmane.org (main.gmane.org [80.91.229.2])
	by zeus1.kernel.org (8.13.1/8.13.1) with ESMTP id j7LGYaGc028485
	for <linux-scsi@vger.kernel.org>; Sun, 21 Aug 2005 09:34:37 -0700
Received: from root by ciao.gmane.org with local (Exim 4.43)
	id 1E6siL-0007G9-Sj
	for linux-scsi@vger.kernel.org; Sun, 21 Aug 2005 18:30:29 +0200
Received: from 69-161-69-17.bflony.adelphia.net ([69.161.69.17])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-scsi@vger.kernel.org>; Sun, 21 Aug 2005 18:30:29 +0200
Received: from mikpolniak by 69-161-69-17.bflony.adelphia.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-scsi@vger.kernel.org>; Sun, 21 Aug 2005 18:30:29 +0200
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

On Tue, 09 Aug 2005 11:55:36 -0500, James Bottomley wrote:

> On Tue, 2005-08-09 at 07:59 -0700, Martin J. Bligh wrote:
>> Dear novice test examiner,
>> 
>> It's in http://test.kernel.org with everything else ;-)
>> 2.6.13-rc4-mm1+jejb_fix ... drills down to:
>> 
>> http://test.kernel.org/10080/debug/console.log
> 
> Well, OK, apparently some novice coder made an error converting from a
> stack allocated buffer to a kmalloc'd one in the sense handling
> routines.
> 
> I think this patch should fix it (or at least restore it to the level of
> bugginess it had before).
> 
> James
> 
> diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
> --- a/drivers/scsi/scsi_lib.c
> +++ b/drivers/scsi/scsi_lib.c
> @@ -342,12 +342,12 @@ int scsi_execute_req(struct scsi_device 
>  		sense = kmalloc(SCSI_SENSE_BUFFERSIZE, GFP_KERNEL);
>  		if (!sense)
>  			return DRIVER_ERROR << 24;
> -		memset(sense, 0, sizeof(*sense));
> +		memset(sense, 0, SCSI_SENSE_BUFFERSIZE);
>  	}
>  	result = scsi_execute(sdev, cmd, data_direction, buffer, bufflen,
>  				  sense, timeout, retries, 0);
>  	if (sshdr)
> -		scsi_normalize_sense(sense, sizeof(*sense), sshdr);
> +		scsi_normalize_sense(sense, SCSI_SENSE_BUFFERSIZE, sshdr);
>  
>  	kfree(sense);
>  	return result;
> 
> 

I tired kernel-2.6.13-rc-6-mm1 which has this patch and i still get
the speed drop due to  Domain Validation detected failure.

I am using a LSIU160/Symbios 53c1010 Ultra3 scsi adapter and it works at 
full speed (75 MB/sec) with kernel-2.6.12. And dmesg shows:

kernel:  target0:0:0: Beginning Domain Validation
kernel:  target0:0:0: asynchronous.
kernel: WIDTH IS 1
kernel:  target0:0:0: wide asynchronous.
kernel:  target0:0:0: FAST-80 WIDE SCSI 160.0 MB/s DT (12.5 ns, offset 62)
kernel:  target0:0:0: Ending Domain Validation
kernel: sym1: <1010-33> rev 0x1 at pci 0000:01:07.1 irq 11
kernel: sym1: Symbios NVRAM, ID 7, Fast-80, SE, parity checking
kernel: sym1: open drain IRQ line driver
kernel: sym1: using LOAD/STORE-based firmware.
kernel: sym1: handling phase mismatch from SCRIPTS.
kernel: sym1: SCSI BUS has been reset.
kernel: scsi1 : sym-2.2.0
kernel: libata version 1.11 loaded.

With kernel-2.6.13-rc6-mm1 the speed drops back to 2.70 MB/sec because of
validation failure and dmesg shows:

kernel:  target0:0:0: Beginning Domain Validation
kernel:  target0:0:0: asynchronous.
kernel:  target0:0:0: wide asynchronous.
kernel:  target0:0:0: FAST-80 WIDE SCSI 160.0 MB/s DT IU QAS (
kernel: sym0: unexpected disconnect
kernel:  target0:0:0: Write Buffer failure 700ff
kernel:  target0:0:0: Domain Validation Disabing Information units
kernel:  0:0:0:0: phase change 6-7 11@3fb3c3a8 resid=10.
kernel:  target0:0:0: asynchronous.
kernel: sym0: unexpected disconnect
target0:0:0: Write Buffer failure 700ff
target0:0:0: Domain Validation detected failure, dropping back
kernel:  target0:0:0: asynchronous.
target0:0:0: Ending Domain Validation
kernel: sym1: <1010-33> rev 0x1 at pci 0000:01:07.1 irq 11
kernel: sym1: Symbios NVRAM, ID 7, Fast-80, SE, parity checkingkernel: 
sym1:
 open drain IRQ line driver, using on-chip SRAM
kernel: sym1: using LOAD/STORE-based firmware.
kernel: sym1: handling phase mismatch from SCRIPTS.
kernel: sym1: SCSI BUS has been reset.
kernel: scsi1 : sym-2.2.1
kernel: libata version 1.11 loaded.

The kernel config has:

CONFIG_SCSI_SYM53C8XX_2=y
CONFIG_SCSI_SYM53C8XX_DMA_ADDRESSING_MODE=1
CONFIG_SCSI_SYM53C8XX_DEFAULT_TAGS=16
CONFIG_SCSI_SYM53C8XX_MAX_TAGS=64
# CONFIG_SCSI_SYM53C8XX_IOMAPPED is not set

 


