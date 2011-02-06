From: <Shyam_Iyer@Dell.com>
Subject: RE: [LSF/MM TOPIC] Sparseness in storage
Date: Mon, 7 Feb 2011 03:48:11 +0530
Message-ID: <DBFB1B45AF80394ABD1C807E9F28D1570264CAA094@BLRX7MCDC203.AMER.DELL.COM>
References: <4D498F4B.3050207@interlog.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="Windows-1252"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ausc60ps301.us.dell.com ([143.166.148.206]:18959 "EHLO
	ausc60ps301.us.dell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752859Ab1BFWTM convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 6 Feb 2011 17:19:12 -0500
In-Reply-To: <4D498F4B.3050207@interlog.com>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: dgilbert@interlog.com, linux-scsi@vger.kernel.org

> -----Original Message-----
> From: linux-scsi-owner@vger.kernel.org [mailto:linux-scsi-
> owner@vger.kernel.org] On Behalf Of Douglas Gilbert
> Sent: Wednesday, February 02, 2011 12:07 PM
> To: linux-scsi
> Subject: [LSF/MM TOPIC] Sparseness in storage
> 
> There are a lot of zeros out there. Efficient use of sparseness
> involves techniques to detect large quantities of zeros in
> advance rather than just reading them all. And on the write side
> there are standard techniques to append zeros to a file without
> actually writing them.
> 
> Seems a damn shame to read a terabyte of zeros and then write them
> to another device or file. Carrying the idea further: if we know
> random data has no meaning *** and we are asked to copy it,
> why not "write" zeros to the output file? 
> Over the last few years various commands have been added to the
> SCSI and ATA command sets to better handle sparseness (and
> trim/unmap/write_same can be viewed in this light). File systems
> are improving their sparseness handling as well, with Linux
> playing "catch up" to NTFS in this regard (e.g. the new
> FALLOC_FL_PUNCH_HOLE flag in fallocate() ).
> 
> So I am proposing a discussion of the:
>    - existing SCSI commands to support sparseness
>    - existing ATA commands to support sparseness
>    - suggestions for more sparseness support to be
>      added to the SCSI and ATA command sets
>    - user space tools that support sparseness
>    - file system support for sparseness
> 

On the last point I was talking to Ted on the same topic in Plumbers more so in the context of thin provisioned LUNs and he suggested creating profiles ...

The zeroes out there also tend to change I/O patterns which are quite tied to low-level chunk size details in storage SANs.  I had like to think that the hole size could be linked to the chunk sizes exported by the Storage SANs and so it makes a lot of sense to create profiles.


> Perhaps the latter point should involve the file system track as
> well.
> 
> Doug Gilbert
> 20100202
> 
> 
> *** For example: after ATA CRYPTO SCRAMBLE EXT command (which
>      is one of the "sanitize device" commands and is fast) the
>      data read will be random and meaningless. If the disk does
>      "read zero after trim" why not follow the scramble with a
>      trim/unmap of the whole disk?
> --
> To unsubscribe from this list: send the line "unsubscribe linux-scsi"
> in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
