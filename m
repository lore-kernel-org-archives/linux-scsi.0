From: Jon Bendtsen <jonbendtsen@jbit.dk>
Subject: Re: understanding the sg_ses --raw output? so I can turn on the faulty
 light
Date: Tue, 08 Feb 2011 15:15:50 +0100
Message-ID: <4D515016.6050801@jbit.dk>
References: <4D500EFC.1040801@jbit.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mgw2.diku.dk ([130.225.96.92]:53585 "EHLO mgw2.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754489Ab1BHOQD (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 8 Feb 2011 09:16:03 -0500
Received: from localhost (localhost [127.0.0.1])
	by mgw2.diku.dk (Postfix) with ESMTP id 8A21F19BC07
	for <linux-scsi@vger.kernel.org>; Tue,  8 Feb 2011 15:15:58 +0100 (CET)
Received: from mgw2.diku.dk ([127.0.0.1])
 by localhost (mgw2.diku.dk [127.0.0.1]) (amavisd-new, port 10024) with ESMTP
 id 20793-13 for <linux-scsi@vger.kernel.org>;
 Tue,  8 Feb 2011 15:15:55 +0100 (CET)
Received: from nhugin.diku.dk (nhugin.diku.dk [130.225.96.140])
	by mgw2.diku.dk (Postfix) with ESMTP id 5FD8019BC0E
	for <linux-scsi@vger.kernel.org>; Tue,  8 Feb 2011 15:15:55 +0100 (CET)
Received: from imap.diku.dk (imap.diku.dk [130.225.96.139])
	by nhugin.diku.dk (Postfix) with ESMTP id 13DD96DF823
	for <linux-scsi@vger.kernel.org>; Tue,  8 Feb 2011 15:10:00 +0100 (CET)
Received: from dkjonb.laerdal.global (212-60-115-150.ip.cust.zensystems.net [212.60.115.150])
	by imap.diku.dk (Postfix) with ESMTP id 247EF61DCD
	for <linux-scsi@vger.kernel.org>; Tue,  8 Feb 2011 15:15:55 +0100 (CET)
In-Reply-To: <4D500EFC.1040801@jbit.dk>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

On 07/02/11 16.25, Jon Bendtsen wrote:
> Hi
> 
> There has earlier been 2 threads on sg_ses 21 may 2007 and 10 june 2010,
> but unfortunately neither seemed to include information about how to
> understand the --raw output from sg_ses.
> 
> When I run this command
> 	sg_ses --page=2 /dev/sg30 --raw
> 
> I get output that looks like:
>         00 00 00 00 00 00 00 00  01 00 00 00 01 00 00 00
>         01 00 00 00 01 00 00 00  01 00 00 00 01 00 00 00
>         01 00 00 00 01 00 00 00  01 00 00 00 01 00 00 00
>         01 00 00 00 01 00 00 00  01 00 00 00 01 00 00 00
>         01 00 00 00 01 00 00 00  01 00 00 00 01 00 00 00
>         01 00 00 00 01 00 00 00  01 00 00 00 01 00 00 00
>         01 00 00 00 01 00 00 00  00 00 01 00 01 00 01 00
>         00 00 00 40 06 00 00 47  06 00 00 47 06 00 00 47
>         00 00 00 00 01 00 2c 00  06 00 00 00 06 00 00 00
>         06 00 00 00 06 00 00 00  06 00 00 00 06 00 00 00
>         06 00 00 00 06 00 00 00  06 00 00 00 06 00 00 00
>         06 00 00 00 06 00 00 00  06 00 00 00 06 00 00 00
>         06 00 00 00 06 00 00 00  06 00 00 00 06 00 00 00
>         06 00 00 00 06 00 00 00  06 00 00 00 06 00 00 00
>         06 00 00 00 06 00 00 00

I cracked it using this PDF
http://www.snia.org/events/storage-developer2008/presentations/monday/RajendraDivecha_SCSI_SES.pdf

Page 26 top diagram tells me they use 4 byte segments, aka 01 00 00 00
is one device slot.

Page 26 middle diagram tells me that 01 from the above segment must be
changed to 81 to select this device slot.

Page 27 diagram tells me that the 2. byte is not important.
Page 27 diagram tells me that the 3. byte should be 02 to signal RQST
IDENT. The result on my system is that the device slot starts to blink.

Page 27 diagram also tells me that if I set the 4. byte to 20, then I
select RSQT FAULT. The result on my systems is that the same device slot
turns on but does not blink, it stays static.

If I set both 3. byte to 02 and 4. byte to 20, then it blinks.

Below you can see the raw data blob which selects slot 16 and sets RQST
fault.

        00 00 00 00 00 00 00 00  01 00 00 00 01 00 00 00
        01 00 00 00 01 00 00 00  01 00 00 00 01 00 00 00
        01 00 00 00 01 00 00 00  01 00 00 00 01 00 00 00
        01 00 00 00 01 00 00 00  01 00 00 00 01 00 00 00
        01 00 00 00 81 00 00 20  01 00 00 00 01 00 00 00
        01 00 00 00 01 00 00 00  01 00 00 00 01 00 00 00
        01 00 00 00 01 00 00 00  00 00 01 00 01 00 01 00
        00 00 00 40 06 00 00 47  06 00 00 47 06 00 00 47
        00 00 00 00 01 00 2c 00  06 00 00 00 06 00 00 00
        06 00 00 00 06 00 00 00  06 00 00 00 06 00 00 00
        06 00 00 00 06 00 00 00  06 00 00 00 06 00 00 00
        06 00 00 00 06 00 00 00  06 00 00 00 06 00 00 00
        06 00 00 00 06 00 00 00  06 00 00 00 06 00 00 00
        06 00 00 00 06 00 00 00  06 00 00 00 06 00 00 00
        06 00 00 00 06 00 00 00

And here are the sg_ses output without --raw

    Individual element 16 status:
        Predicted failure=0, Disabled=0, Swap=0, status: OK
        OK=0, Reserved device=0, Hot spare=0, Cons check=0
        In crit array=0, In failed array=0, Rebuild/remap=0, R/R abort=0
        App client bypass A=0, Don't remove=0, Enc bypass A=0, Enc
bypass B=0
        Ready to insert=0, RMV=0, Ident=0, Report=0
        App client bypass B=0, Fault sensed=0, Fault reqstd=1, Device off=0
        Bypassed A=0, Bypassed B=0, Dev bypassed A=0, Dev bypassed B=0



JonB

