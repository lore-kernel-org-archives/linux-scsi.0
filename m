From: Friedrich Lobenstock <fl@fl.priv.at>
Subject: Re: blocksize limitations in scsi tape driver (st) when used with
 DLT1 tape drives?
Date: Fri, 06 Sep 2002 00:15:18 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <3D77D776.7040408@fl.priv.at>
References: <Pine.LNX.4.44.0209060009560.1912-100000@kai.makisara.local>
Reply-To: Linux-SCSI Mailingliste <linux-scsi@vger.kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org
To: Linux-SCSI Mailingliste <linux-scsi@vger.kernel.org>
Cc: support@arkeia.com

Kai Makisara wrote:
> On Thu, 5 Sep 2002, Friedrich Lobenstock wrote:
> 
> 
>>Hi!
>>
>>I'm having an odd problem here. I use SuSE Linux 8.0 with kernel
>>2.4.18-64GB-SMP, arkeia as backup software and a Tandberg
>>VS80 (DLT1) streamer.
>>
>>After some trial and error I found out that I have to use a fixed block
>>size for DLT streamers (same applies to LTO ones). This document,
>>found at HP, tells you in details about which blocksize to use:
>>   http://www.hp.com/cposupport/information_storage/support_doc/lpg50167.html
>>
>>Now I told arkeia to use a blocksize of 65536, 32768 and 16384 and it
>>could not write to the tape. All I got in the log was:
>>
>>Sep  4 22:04:50 filesrv kernel: st: Unloaded.
>>Sep  4 22:08:40 filesrv kernel: st: Version 20020205, bufsize 32768, wrt 30720, max init. bufs 4, s/g segs 16
>>Sep  4 22:08:40 filesrv kernel: st0: Block limits 2 - 16777214 bytes.
>>Sep  4 22:08:41 filesrv kernel: st0: Incorrect block size.
>>Sep  4 22:08:45 filesrv kernel: st0: Write not multiple of tape block size.
> 
>                                        ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
> The write() byte count from Arkeia is not a multiple of the tape block
> size. If you use fixed block size, you must take care that this constraint
> is not violated. When you set the block size to 8192 or something that
> multiplies to 8192, this constraint is obeyed. If Arkeia sets the block
> size, I don't know why it does not obey the constraint. Seems to be an
> application problem.
> 
> In most cases, it is best to use variable block mode
> (i.e., mt setblk 0) and let the application to decide the tape block size.
> In order to have good efficiency, you should make sure that the
> application uses large enough byte counts in its write() calls, i.e., set
> the Arkeia block size to 65536.

Hmmm...I whish I could, but LTO and as it seems DLT drives too do not
cope well with variable block sizes.

All blocksizes greater than 8192 do make troubles. At and below this
value all is fine.


-- 
MfG / Regards
Friedrich Lobenstock

