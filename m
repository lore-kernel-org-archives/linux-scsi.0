From: Dag Nygren <dag@newtech.fi>
Subject: Re: blocksize limitations in scsi tape driver (st) when used with
 DLT1 tape drives?
Date: Fri, 06 Sep 2002 01:07:56 +0300
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20020905220756.27473.qmail@dag.newtech.fi>
References: <3D77C5C7.3010909@fl.priv.at>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Return-path: <linux-scsi-owner@vger.kernel.org>
In-Reply-To: Your message of "Thu, 05 Sep 2002 22:59:51 +0200."
             <3D77C5C7.3010909@fl.priv.at>
List-Id: linux-scsi@vger.kernel.org
To: Linux-SCSI Mailingliste <linux-scsi@vger.kernel.org>
Cc: dag@newtech.fi

> Dag Nygren wrote:

> I used variable blocksize (=0) before but then after about 3.5 gigs stored
> on the tape I get scsi-error and arkeia interprets this as end-of-tape.
> 
> Aug  6 02:13:50 filesrv kernel: st0: Error with sense data: Info fld=0x2000, Deferred st09:00: sns = f1  3
> Aug  6 02:13:50 filesrv kernel: ASC=80 ASCQ= 1
> Aug  6 02:13:50 filesrv kernel: Raw sense data:0xf1 0x00 0x03 0x00 0x00 0x20 0x00 0x16 0x00 0x00 0xe6 0xc2 0x80 0x01 0x00 0x00 0x00 0x00 0x83 0x00 0x37 0x00 0x00 0x00 0x21 0x00 0x90 0x7f 0x3a 0x00
> Aug  6 02:13:50 filesrv kernel: klogd 1.4.1, ---------- state change ----------
> Aug  6 02:13:50 filesrv kernel: Inspecting /boot/System.map-2.4.18-64GB-SMP
> Aug  6 02:13:50 filesrv kernel: Loaded 13537 symbols from /boot/System.map-2.4.18-64GB-SMP.
> Aug  6 02:13:50 filesrv kernel: Symbols match kernel version 2.4.18.
> Aug  6 02:13:50 filesrv kernel: Loaded 481 symbols from 13 modules.
> Aug  6 02:13:50 filesrv kernel: st0: Error with sense data: Info fld=0x1, Current st09:00: sns = f0  3
> Aug  6 02:13:50 filesrv kernel: ASC= c ASCQ= 0
> Aug  6 02:13:50 filesrv kernel: Raw sense data:0xf0 0x00 0x03 0x00 0x00 0x00 0x01 0x16 0x00 0x00 0xe6 0xc2 0x0c 0x00 0x00 0x00 0x00 0x00 0x83 0x00 0x37 0x00 0x00 0x00 0x21 0x00 0x90 0x7f 0x3a 0x00

Have you checked what this sense data indicates ?
Do you have the SCSI manual for your DLT ?
Sense Key 0x03 and Additional Sense Key=0xe6

Sense key= 0x03 means MEDIUM_ERROR
ASK=0xe6 is Vendor Specific but could tell you more about the 
medium error

> I had this problem with LTO drives too and here the arkeia faq tells one
> to set fixed block size.

This sounds very strange........

> And when you look a the HP document referenced in my last mail:
> 
>     ISSUE: Block sizes of LESS THAN 64 KB for DLT1/DLT VS80 and 32 KB for
>            all other DAT and DLT drives can drastically increase the backup/restore
>            time and severely affect the performance of the drive.
> 
> SOLUTION: Most backup applications allow viewing and adjusting the block
>            size used for a particular device. See below for advice on how
>            to achieve this for CA ARCserve, Veritas Backup Exec and Tapeware.

And they are certainly right on that, I recently made a study on blocksizes in
Linux-tapes for a customer and the performance was significantly better up to
16 k blocks, after this the perf. increase was in the regions of 2-3 %.

> 
> (I capitalized "less than" to emphasis its occurance)
> 
> I you missed the link here it is again:
>    http://www.hp.com/cposupport/information_storage/support_doc/lpg50167.html
> 
> Did you check with mt after Legato Networker did a backup which blocksize
> it set?

It will not be set to anything else than 0. Using 0 just tells the driver that
it shall write all the data given in ONE write() call to the driver in one 
block
to the device. Thus the application (in this case Legato) can determine which
size of blocks to use.
When using fixed blocks, the driver will split the write into that big chunks 
and
write those onto the tape one by one.

> 
> -- 
> MfG / Regards
> Friedrich Lobenstock
> 
> 


