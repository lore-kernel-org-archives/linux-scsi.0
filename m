From: Steve deRosier <derosier@pianodisc.com>
Subject: CDROMREADAUDIO ioctl EINVAL error with 2.6.1; it works with 2.4.21
Date: Thu, 29 Jan 2004 16:20:46 -0800
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <4019A35E.5050000@pianodisc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ip201.pianodisc.com ([207.173.133.201]:56097 "EHLO
	EXCHANGE01-Srv.pianodisc.com") by vger.kernel.org with ESMTP
	id S265895AbUA3ATc (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 29 Jan 2004 19:19:32 -0500
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

All,

We have a CDROM audio application that works properly with 2.4.21, but when we try to run it under 2.6.1 it receives an error (EINVAL) from the ioctl CDROMREADAUDIO call.

Details:
It is a via-based mini-ITX format computer using a USB CDROM drive.  The kernel is 2.4.21 for the working version of the program (referred henceforth as "pdcd").  The 2.6.1 kernel causes pdcd to fail on the call to ioctl with a return of '22':
if( (err = ioctl( mCDh, CDROMREADAUDIO, &mCDAudio)) >= 0 )

with the following declarations:
int err;
int mCDh;
struct cdrom_read_audio mCDAudio;

Example fragment (we do more, I trimmed it to show the immediate data going into the ioctl call):
----
// Open the CDROM 
mCDh = open( "/dev/cdrom", O_RDONLY | O_NONBLOCK );
if( mCDh < 0 )
{
  return false;
}

// Prepare to read audio directly
mCDAudio.addr_format = CDROM_MSF;
mCDAudio.addr.msf.minute = mCDMSF.cdmsf_min0;
mCDAudio.addr.msf.second = mCDMSF.cdmsf_sec0;
mCDAudio.addr.msf.frame = mCDMSF.cdmsf_frame0;
mCDAudio.nframes = CD_FRAMES;

// Allocate RAM for reading buffer
mFramesBuffer = new Byte[P_BUFFSIZE];
// connect the buffer to the audio stuff
mCDAudio.buf = mFramesBuffer;

// Attempt to read frames
int err = 0;
if( (err = ioctl( mCDh, CDROMREADAUDIO, &mCDAudio)) >= 0 )

----
The ioctl returns with -1 with errno reporting a value of 22 (EINVAL).

Ok, so this code works just fine running on a 2.4.21 kernel, but now doesn't work with the 2.6.1 kernel.  Has something changed in the implementation or cdrom API?  Maybe we're doing something sloppy that was accepted in 2.4.x but is now tagged as invalid under 2.6.1?  Interestingly, cdparanoia seems to use the same ioctl calls, though it uses addr_format == CDROM_LBA, and it seems to still work.  I'm compiling against older header files, but those don't seem to have changed; also we never recompiled cdparanoia (using 9.8 it looks like), so if that was the problem I'd expect to have problems there too.  

Hopefully I chose the right list for this problem, but if I didn't, let me know which list might be more appropriate.

Thanks,
- Steve


