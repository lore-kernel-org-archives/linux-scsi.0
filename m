From: Douglas Gilbert <dougg@torque.net>
Subject: Re: sd_remove() called on a tape device - Linux 2.6.8.1 kernel
Date: Thu, 26 Aug 2004 21:24:34 +1000
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <412DC872.3010203@torque.net>
References: <1093494731.3549.117.camel@swtf.comptex.com.au> <412DB089.1090403@optonline.net>
Reply-To: dougg@torque.net
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from borg.st.net.au ([65.23.158.22]:43236 "EHLO borg.st.net.au")
	by vger.kernel.org with ESMTP id S268729AbUHZLZX (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 26 Aug 2004 07:25:23 -0400
In-Reply-To: <412DB089.1090403@optonline.net>
List-Id: linux-scsi@vger.kernel.org
To: Nathan Bryant <nbryant@optonline.net>
Cc: Burn Alting <burn@goldweb.com.au>, SCSI development list <linux-scsi@vger.kernel.org>

Nathan Bryant wrote:
> Burn Alting wrote:
> 
>> I'm running Fedora Core 2 with a ftp.kernel.org 2.6.8.1 kernel.
>>
>> I've noticed that for some reason, when I reboot the system, it sends a
>> SCSI Synchronize Cache command to a tape device I have attached to the
>> system. This occurs at the end of the shutdown process just before doing
>> a reset into the BIOS (or whatever).
>>
>> The tape is at LUN 0 and a disk is at LUN 7, the only scsi devices on
>> this system (hanging off an LSI Logic FC controller). The main disk is
>> an IDE.
>>
>> Is there anything I can do to further track this down? I know that for
>>  
>>
> Add a call to WARN_ON to the locations that can send the SYNCHRONIZE 
> CACHE command. That will force a stack trace.
> 
> Disable PM poweroff before you halt the system so that you can see the 
> trace.
> 
>> some reason the sd_remove() routine is being called rather than
>> st_remove() - but not sure why. The system recognises the tape quite
>> happily and reads/writes to it, so it knows what's at that scsi bus
>> location.

Burn,
The scsi_debug driver can simulate tape drives (although the
streaming command set support is weak). For example:

  # modprobe scsi_debug ptype=1 opts=1

will simulate one tape drive and log commands sent to it.

Doug Gilbert
