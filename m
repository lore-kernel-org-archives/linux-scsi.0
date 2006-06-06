From: Jiri Slaby <jirislaby@gmail.com>
Subject: Re: usb device problem
Date: Wed, 07 Jun 2006 00:45:03 +0159
Message-ID: <44860586.5080308@gmail.com>
References: <44859A9B.6080202@gmail.com> <4485A299.7070007@rtr.ca> <4485A855.1020602@gmail.com> <4485C446.2040203@rtr.ca> <4485C5D8.5070907@rtr.ca> <4485F590.8000304@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from nf-out-0910.google.com ([64.233.182.191]:21514 "EHLO
	nf-out-0910.google.com") by vger.kernel.org with ESMTP
	id S1751126AbWFFWp4 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 6 Jun 2006 18:45:56 -0400
Received: by nf-out-0910.google.com with SMTP id k27so17747nfc
        for <linux-scsi@vger.kernel.org>; Tue, 06 Jun 2006 15:45:54 -0700 (PDT)
In-Reply-To: <4485F590.8000304@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jiri Slaby <jirislaby@gmail.com>
Cc: Mark Lord <lkml@rtr.ca>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, linux-scsi@vger.kernel.org, linux-usb-devel@lists.sourceforge.net

Jiri Slaby napsal(a):
> Mark Lord napsal(a):
>> Mmm.. okay, a quick glance at the USB storage code revealed one instance:
>>
>>        /* Did we transfer less than the minimum amount required? */
>>        if (srb->result == SAM_STAT_GOOD &&
>>                        srb->request_bufflen - srb->resid < srb->underflow)
>>                srb->result = (DID_ERROR << 16) | (SUGGEST_RETRY << 24);
>>
>>        return;
>>
>> So I suppose this *could* be the driver thinking it had a bad sector,
>> but it really looks like it's guessing.  The code also appears to be
>> instrumented for some kind of USB tracing.. If you can figure out how
>> to turn that on, then the trace will probably tell us what is really
>> going on there.
>> Look for a file called "usbmon.txt" in the Documentation/usb/ subdir
>> of your kernel source tree.  It describes how to do the tracing.
> 
> Did you want me to do something like this:
> http://www.fi.muni.cz/~xslaby/sklad/usbmon/?M=A
> 
> usb2 means usb bus 2.
> 
> without "a"s commands was:
> 
> [connect the device]
> mount /dev/sdb usb/ [filesystem is vfat]
> dd if=/dev/zero of=usb/zero1 bs=1k count=3
> [wait some time to let system syncing automagically]
> umount usb/
> [disconnect the device]
> 
> 
> 
> with "a" there is only difference in dd command:
> ...
> dd if=/dev/zero of=usb/zero2 bs=1k count=5
> ...
> 
> The first serie is without the error in the latter one appeared (some time after
> `dd', when system syncs):
> sd 6:0:0:0: SCSI error: return code = 0x10070000
> end_request: I/O error, dev sdb, sector 8223
> [same as before]
> 
> 
> 
> I have i386 arch, so 4096 is PAGE_SIZE, when it syncs only one dirty page, it
> seems to be OK, otherwise it's not, if this helps in any way.
> 

Just a notice, I've just returned from the big w*ows system and it's working
there ... huh ... better to say, it doesn't complain ... hum ... it means almost
nothing ... But seems to work.

regards,
-- 
Jiri Slaby         www.fi.muni.cz/~xslaby
\_.-^-._   jirislaby@gmail.com   _.-^-._/
B67499670407CE62ACC8 22A032CC55C339D47A7E
