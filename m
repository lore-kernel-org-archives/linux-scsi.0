From: "Edwards, Scott (MED, Kelly IT Resouces)" <James.Edwards@med.ge.com>
Subject: RE: Help - looking for a Linux SCSI testing utility
Date: Wed, 26 May 2004 15:24:49 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1F6D1D1660975A4887628A011443A1BC0305E3CF@uswaumsx13medge.med.ge.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ext-nj2gw-5.online-age.net ([64.14.56.41]:61136 "EHLO
	ext-nj2gw-5.online-age.net") by vger.kernel.org with ESMTP
	id S265786AbUEZUZB (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 26 May 2004 16:25:01 -0400
Received: from int-nj2gw-3.online-age.net (int-nj2gw-3 [3.159.236.67])
	by ext-nj2gw-5.online-age.net (8.12.9/8.12.9/990426-RLH) with ESMTP id i4QKOxae001167
	for <linux-scsi@vger.kernel.org>; Wed, 26 May 2004 16:24:59 -0400 (EDT)
Received: from uswaumsxb4medge.am.med.ge.com (localhost [127.0.0.1])
	by int-nj2gw-3.online-age.net (8.12.9/8.12.8/990426-RLH) with ESMTP id i4QKOvI9016699
	for <linux-scsi@vger.kernel.org>; Wed, 26 May 2004 16:24:59 -0400 (EDT)
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org


I know this is slightly off topic for this list, but I have been
fighting with this for about a month now and I feel like I'm getting
nowhere.  I tried the plscsi and scu utilities.  One of them I couldn't
make heads or tails of.  The other one would read the "inquiry" command
ok, but I couldn't figure out how to make it give me the output of the
"IDENTIFY" command (0xEC).  This is what I really need to read.

I have written (mostly copied from other stuff) a little program to just
turn off the write cache.  (I have included the source below.)  But
without being able to read the results of the identify I can't tell if
it actually works or not.  I have tried writing a program myself that
just sends the (0xEC) command, but all I get back is 70 00 05 00 00 00
00 06 00 00 00 00 20 00 00 00 which I'm guessing are the sense bytes?
(Excuse my ignorance the last time I messed with this stuff it was
called SASI instead of SCSI.)

Can anyone tell me if I can use any of these other utilities to read the
IDENTIFY data?  Or how I read that data back using ioctl or something
equivelant.

Thanks
   -Scott

------------------------------------------------------------------------
--------------------------

#include <stdlib.h>
#include <unistd.h>
#include <stdio.h>
#include <errno.h>
#include <sys/ioctl.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <fcntl.h>
#include <linux/hdreg.h>
#include <scsi/scsi_ioctl.h>

/* See http://tldp.org/HOWTO/SCSI-Generic-HOWTO/scsi_snd_cmd.html */
struct sdata {
    unsigned int inlen;      /* [i] Length of data written to device
*/
    unsigned int outlen;     /* [i] Length of data read from device
*/
    unsigned char cmd[6];    /* [i] SCSI command (6 <= x <= 16)
*/
                             /* [o] Data read from device starts here
*/
                             /* [o] On error, sense buffer starts here
*/
    unsigned char wdata[10]; /* [i] Data written to device starts here
*/
};

int main()
{
    int fd;
    int result;
    int i;

    struct sdata args = { 1, 16, { 0xEF, 0x00, 0x82, 0x00, 0x00 } };
    fd = open("/dev/sda", O_RDONLY|O_NONBLOCK);
    if (fd < 0) {
        perror("/dev/sda");
        exit(errno);
    }
    result = ioctl(fd, SCSI_IOCTL_SEND_COMMAND, &args);
    if (result < 0) {
        perror(" SCSI_IOCTL_SEND_COMMAND(setcache) failed");
    }
    else {
        printf("OK! %d\n", result);
    }
    for (i = 0; i < 16; i++) {
        printf("%02x ", (unsigned char) args.cmd[i]);
    }
    printf("\n");
    close(fd);
    return result;
}


-----Original Message-----
From: Randy.Dunlap [mailto:rddunlap@osdl.org]
Sent: Tuesday, May 25, 2004 9:09 AM
To: Edwards, Scott (MED, Kelly IT Resouces)
Cc: lxing@Crossroads.com; linux-scsi@vger.kernel.org
Subject: Re: Help - looking for a Linux SCSI testing utility


On Tue, 25 May 2004 09:56:19 -0500 Edwards, Scott (MED, Kelly IT
Resouces) wrote:

| 
| I have been trying to find a way to send a write cache command to a
scsi
| drive.  I found the sg_utils which I haven't gotten to send a write
| cache command, but they might do what you want.
| 
| http://www.torque.net/sg

Others to consider/try:

http://members.aol.com/plscsi/linux/plscsi.tar.gz

http://www.bit-net.com/~rmiller/scu.html  (binary only)


| -Scott
| 
| 
| -----Original Message-----
| From: linux-scsi-owner@vger.kernel.org
| [mailto:linux-scsi-owner@vger.kernel.org]On Behalf Of Lee Xing
| Sent: Tuesday, May 25, 2004 8:43 AM
| To: linux-scsi@vger.kernel.org
| Subject: Help - looking for a Linux SCSI testing utility
| 
| 
| Hi,
| 
| When we were working on Windows platform, we had a couple of tools
that
| can issue selected SCSI command(s) to selected device(s).  Is there a
| similar tool for Linux?  It would be great if we can use it to send
| different SCSI command(s) to selected sd/sg device(s).
| 
| Thanks,
| 
| 
| Lee 


--
~Randy
