From: Douglas Gilbert <dgilbert@interlog.com>
Subject: Re: sg timeout problem
Date: Fri, 08 May 2009 14:14:59 +0200
Message-ID: <4A042243.1010608@interlog.com>
References: <BB8F41726E2941CEB399F732BB3ED9E5@DIAMOND8600> <20090506103852.19cb69b9@lxorguk.ukuu.org.uk> <AB775258E58247F6A0960B1AFEC0E103@DIAMOND8600>
Reply-To: dgilbert@interlog.com
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.infotech.no ([82.134.31.41]:58819 "EHLO
	elrond2.infotech.no" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758804AbZEHMPE (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 8 May 2009 08:15:04 -0400
In-Reply-To: <AB775258E58247F6A0960B1AFEC0E103@DIAMOND8600>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Norman Diamond <n0diamond@yahoo.co.jp>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org

Norman Diamond wrote:
>>> But if sg is running on top of an actual SCSI driver, someone aborts the
>>> ioctl after 3 seconds.  The ioctl returns success even though the
>>> operation didn't complete.  I tried this with two Adaptec drivers and 
>>> one
>>> NinjaSCSI driver with 100% repro.
>>>
>>> What am I missing?  I need the call to run to completion.
>>
>> If you set it to the max of a signed int does it behave, or to a large
>> value thats well under the limit. That will help tell if there is a
>> problem with sign handling in the scsi code somewhere or it is getting
>> multiplied up for some reason.
> 
> I have the impression now that the drives are lying and it's not the fault
> of the drivers or cards.  The same problem occured with a fourth card and a
> non-Linux system.
> 
> Anyway I also tried changing the timeout to 86400000 milliseconds (one day)
> and it made no difference.  So again I stop blaming the drivers.

Norman,
I'm not sure what version or distro of Linux you have
but I just did this quick test on Ubuntu 9.04 in which
a kernel tick seems to be around 4 milliseconds:

$  uname -a
Linux zink 2.6.28-11-generic #42-Ubuntu SMP Fri Apr 17 01:57:59 UTC 2009 i686 
GNU/Linux
$
$ modprobe scsi_debug delay=1000
$ lsscsi -g
[7:0:0:0]    disk    Linux    scsi_debug       0004  /dev/sdb   /dev/sg2

$ time sg_readcap /dev/sg2
Read Capacity results:
    Last logical block address=16383 (0x3fff), Number of blocks=16384
    Logical block length=512 bytes
Hence:
    Device size: 8388608 bytes, 8.0 MiB, 0.01 GB

real	0m3.999s
user	0m0.000s
sys	0m0.000s
$


See 'modinfo scsi_debug' for more about the arguments to the
scsi_debug driver. If the delay is too long then the kernel
may timeout registering the pseudo device. I picked 4 seconds
because you noted a failure above 3 seconds. The timeout on
sg_inq is set at 60 seconds.

Doug Gilbert




