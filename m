From: Friedrich Lobenstock <fl@fl.priv.at>
Subject: Re: [Incident 020905-000011] Re: blocksize limitations in scsi tape
 driver (st) when used withDLT1 tape drive
Date: Fri, 06 Sep 2002 12:25:03 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <3D78827F.1030000@fl.priv.at>
References: <3D786AEC.000001.22911@websc06.int.rightnowtech.com>
Reply-To: Linux-SCSI Mailingliste <linux-scsi@vger.kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org
To: support@arkeia.com
Cc: linux-scsi@vger.kernel.org

support@arkeia.com wrote:
> Recently you requested personal assistance from our on-line support
> center. Below is a summary of your request and our response.
> We will assume your issue has been resolved if we do not hear from you
> within 7 days.
> Thank you for allowing us to be of service to you.
> 
> 
> Subject
> ---------------------------------------------------------------
> Re: blocksize limitations in scsi tape driver (st) when used withDLT1 tape drive
> 
> 
> Discussion Thread
> ---------------------------------------------------------------
> Response (Richard) - 09/06/2002 01:44 AM
> Hi,
> 
> is this mail really supposed to be for the Arkeia support team? I 
 > understand that this is about Arkeia but what is your exact problem?
> As far as block size are concerned, you should set Arkeia to use 1024
 > bytes block size to use with LTO drives and use variable block size
 > for others (eventually force the variable block size with AIT drives).
 > If you use greater block size, it may seem to work in backups, but you'll
 > eventually run into problems in restoration.

OK, here are my two original postings:


-------- Original Message --------
Subject: blocksize limitations in scsi tape driver (st) when used with DLT1 tape drives?
Date: Thu, 05 Sep 2002 21:35:50 +0200
From: Friedrich Lobenstock <fl@fl.priv.at>
Reply-To: Linux-SCSI Mailingliste <linux-scsi@vger.kernel.org>
To: Linux-SCSI Mailingliste <linux-scsi@vger.kernel.org>
CC: Linux-Kernel Mailingliste <linux-kernel@vger.kernel.org>

Hi!

I'm having an odd problem here. I use SuSE Linux 8.0 with kernel
2.4.18-64GB-SMP, arkeia as backup software and a Tandberg
VS80 (DLT1) streamer.

After some trial and error I found out that I have to use a fixed block
size for DLT streamers (same applies to LTO ones). This document,
found at HP, tells you in details about which blocksize to use:
    http://www.hp.com/cposupport/information_storage/support_doc/lpg50167.html

Now I told arkeia to use a blocksize of 65536, 32768 and 16384 and it
could not write to the tape. All I got in the log was:

Sep  4 22:04:50 filesrv kernel: st: Unloaded.
Sep  4 22:08:40 filesrv kernel: st: Version 20020205, bufsize 32768, wrt 30720, max init. bufs 4, s/g segs 16
Sep  4 22:08:40 filesrv kernel: st0: Block limits 2 - 16777214 bytes.
Sep  4 22:08:41 filesrv kernel: st0: Incorrect block size.
Sep  4 22:08:45 filesrv kernel: st0: Write not multiple of tape block size.

Sep  4 23:20:06 filesrv kernel: st: Unloaded.
Sep  4 23:20:30 filesrv kernel: st: Version 20020205, bufsize 524288, wrt 522240, max init. bufs 16, s/g segs 64
Sep  4 23:20:30 filesrv kernel: st0: Block limits 2 - 16777214 bytes.
Sep  4 23:20:33 filesrv kernel: st0: Incorrect block size.
Sep  4 23:20:35 filesrv kernel: st0: Write not multiple of tape block size.

(As you might have notice in the second case I'm loading st with buffer_kbs=512,
max_buffers=16 and max_sg_segs=64 but that makes no difference compared to the
default values)


BUT now comes the cloo: at and below a blocksize of 8192 it was possible
to write to the tape. At 1024 the backup slowed down from 20 min to 4 hours,
but at 8192 the backup speed is normal (the later on with the st options
you can see above, but haven't tested if that makes a difference).

LTO drives in contrast to DLT drives are happy with a blocksize of 1024
and backup speed is normal at this blocksize.

Everytime when arkeia could not write to the tape I checked with mt to
display the blocksize and I verified that arkeia set it to the value I
told it to. Now with arkeia set to a blocksize of 8192:

filesrv:~ # mt -f /dev/st0 status
drive type = Generic SCSI-2 tape
drive status = 1073750016
sense key error = 0
residue count = 0
file number = 0
block number = 0
Tape block size 8192 bytes. Density code 0x40 (unknown).
Soft error count since last status=0
General status bits on (41010000):
   BOT ONLINE IM_REP_EN

I think there must be something wrong in the scsi tape driver(st).
Can someone shine some light on this?

PS: Reply-to set to linux-scsi.

-- 
MfG / Regards
Friedrich Lobenstock


-------- Original Message --------
Subject: Re: blocksize limitations in scsi tape driver (st) when used with  DLT1 tape drives?
Date: Thu, 05 Sep 2002 22:59:51 +0200
From: Friedrich Lobenstock <fl@fl.priv.at>
Reply-To: Linux-SCSI Mailingliste <linux-scsi@vger.kernel.org>
To: Dag Nygren <dag@newtech.fi>
CC: Linux-SCSI Mailingliste <linux-scsi@vger.kernel.org>,   Linux-Kernel Mailingliste <linux-kernel@vger.kernel.org>
References: <20020905200208.22430.qmail@dag.newtech.fi>

Dag Nygren wrote:
 > I have successfully been using Legato Networker with a
 > blocksize of 32k with my DLT here.
 >
 > But the way Legato wants to do it is to decide about the
 > blocksize itself.
 > This means that the driver should NOT decide on the BS, but
 > pass on anything written through it, meaning a blocksize setting
 > of 0 (or variable blocksize).
 >
 > Perhaps Arkeia works the same way ?

I used variable blocksize (=0) before but then after about 3.5 gigs stored
on the tape I get scsi-error and arkeia interprets this as end-of-tape.

Aug  6 02:13:50 filesrv kernel: st0: Error with sense data: Info fld=0x2000, Deferred st09:00: sns = f1  3
Aug  6 02:13:50 filesrv kernel: ASC=80 ASCQ= 1
Aug  6 02:13:50 filesrv kernel: Raw sense data:0xf1 0x00 0x03 0x00 0x00 0x20 0x00 0x16 0x00 0x00 0xe6 0xc2 0x80 0x01 0x00 0x00 0x00 0x00 0x83 0x00 0x37 0x00 0x00 0x00 0x21 0x00 0x90 0x7f 0x3a 0x00
Aug  6 02:13:50 filesrv kernel: klogd 1.4.1, ---------- state change ----------
Aug  6 02:13:50 filesrv kernel: Inspecting /boot/System.map-2.4.18-64GB-SMP
Aug  6 02:13:50 filesrv kernel: Loaded 13537 symbols from /boot/System.map-2.4.18-64GB-SMP.
Aug  6 02:13:50 filesrv kernel: Symbols match kernel version 2.4.18.
Aug  6 02:13:50 filesrv kernel: Loaded 481 symbols from 13 modules.
Aug  6 02:13:50 filesrv kernel: st0: Error with sense data: Info fld=0x1, Current st09:00: sns = f0  3
Aug  6 02:13:50 filesrv kernel: ASC= c ASCQ= 0
Aug  6 02:13:50 filesrv kernel: Raw sense data:0xf0 0x00 0x03 0x00 0x00 0x00 0x01 0x16 0x00 0x00 0xe6 0xc2 0x0c 0x00 0x00 0x00 0x00 0x00 0x83 0x00 0x37 0x00 0x00 0x00 0x21 0x00 0x90 0x7f 0x3a 0x00

I had this problem with LTO drives too and here the arkeia faq tells one
to set fixed block size.

And when you look a the HP document referenced in my last mail:

     ISSUE: Block sizes of LESS THAN 64 KB for DLT1/DLT VS80 and 32 KB for
            all other DAT and DLT drives can drastically increase the backup/restore
            time and severely affect the performance of the drive.

SOLUTION: Most backup applications allow viewing and adjusting the block
            size used for a particular device. See below for advice on how
            to achieve this for CA ARCserve, Veritas Backup Exec and Tapeware.

(I capitalized "less than" to emphasis its occurance)

I you missed the link here it is again:
    http://www.hp.com/cposupport/information_storage/support_doc/lpg50167.html

Did you check with mt after Legato Networker did a backup which blocksize
it set?

-- 
MfG / Regards
Friedrich Lobenstock


