From: Jens Axboe <axboe@suse.de>
Subject: Re: CDROMREADAUDIO ioctl EINVAL error with 2.6.1; it works with 2.4.21
Date: Fri, 30 Jan 2004 12:11:05 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040130111105.GM11683@suse.de>
References: <4019A35E.5050000@pianodisc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ns.virtualhost.dk ([195.184.98.160]:32967 "EHLO virtualhost.dk")
	by vger.kernel.org with ESMTP id S262603AbUA3LLI (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 30 Jan 2004 06:11:08 -0500
Content-Disposition: inline
In-Reply-To: <4019A35E.5050000@pianodisc.com>
List-Id: linux-scsi@vger.kernel.org
To: Steve deRosier <derosier@pianodisc.com>
Cc: linux-scsi@vger.kernel.org

On Thu, Jan 29 2004, Steve deRosier wrote:
> All,
> 
> We have a CDROM audio application that works properly with 2.4.21, but when 
> we try to run it under 2.6.1 it receives an error (EINVAL) from the ioctl 
> CDROMREADAUDIO call.
> 
> Details:
> It is a via-based mini-ITX format computer using a USB CDROM drive.  The 
> kernel is 2.4.21 for the working version of the program (referred 
> henceforth as "pdcd").  The 2.6.1 kernel causes pdcd to fail on the call to 
> ioctl with a return of '22':
> if( (err = ioctl( mCDh, CDROMREADAUDIO, &mCDAudio)) >= 0 )
> 
> with the following declarations:
> int err;
> int mCDh;
> struct cdrom_read_audio mCDAudio;
> 
> Example fragment (we do more, I trimmed it to show the immediate data going 
> into the ioctl call):
> ----
> // Open the CDROM 
> mCDh = open( "/dev/cdrom", O_RDONLY | O_NONBLOCK );
> if( mCDh < 0 )
> {
>  return false;
> }
> 
> // Prepare to read audio directly
> mCDAudio.addr_format = CDROM_MSF;
> mCDAudio.addr.msf.minute = mCDMSF.cdmsf_min0;
> mCDAudio.addr.msf.second = mCDMSF.cdmsf_sec0;
> mCDAudio.addr.msf.frame = mCDMSF.cdmsf_frame0;
> mCDAudio.nframes = CD_FRAMES;

CD_FRAMES is too big, 2.6 will reject this (where 2.4 silently allowed
it, but allocated smaller chunks in the loop). Use 64 for now.

-- 
Jens Axboe

