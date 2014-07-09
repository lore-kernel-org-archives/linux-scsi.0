From: loody <miloody@gmail.com>
Subject: Re: dummy scsi read or scsi command periodically for external USB
 Hard Disk
Date: Wed, 9 Jul 2014 21:27:57 +0800
Message-ID: <CANudz+tQ4pJFmLTRsHtL=VjuCg30Af+7CpK1qRQM5TwwShoQtA@mail.gmail.com>
References: <CANudz+vNcLEJSX9L4FsPMMgJfp7rZxcryPcRmPs0-k5nB61dDg@mail.gmail.com>
	<Pine.LNX.4.44L0.1407081524460.1283-100000@iolanthe.rowland.org>
	<CANudz+vdVQAJgz1YYN=yFQn+749XFbvi3Hqnd+n5zkM5FxuJtQ@mail.gmail.com>
	<063D6719AE5E284EB5DD2968C1650D6D1726EEFA@AcuExch.aculab.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-wi0-f180.google.com ([209.85.212.180]:36345 "EHLO
	mail-wi0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753145AbaGIN17 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 9 Jul 2014 09:27:59 -0400
In-Reply-To: <063D6719AE5E284EB5DD2968C1650D6D1726EEFA@AcuExch.aculab.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: David Laight <David.Laight@aculab.com>
Cc: Alan Stern <stern@rowland.harvard.edu>, "Bryn M. Reeves" <bmr@redhat.com>, "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>, SCSI development list <linux-scsi@vger.kernel.org>

hi all:
I try 2 methods today but there is no read command firing from usb
host to device
(I double check the existence of command by CATC protocol analyzer)
appreciate all your kind suggestion.

1. use busybox like below command
dd if=/dev/sda1 of=/dev/null bs=512 count=1 conv=sync
my dd in busybox doesn't have iflags option
# ./busybox.new dd help

BusyBox v1.19.2 (2014-07-09 13:43:36 CST) multi-call binary.
Usage: dd [if=FILE] [of=FILE] [ibs=N] [obs=N] [bs=N] [count=N] [skip=N]
        [seek=N] [conv=notrunc|noerror|sync|fsync]
Copy a file with converting and formatting
        if=FILE         Read from FILE instead of stdin
        of=FILE         Write to FILE instead of stdout
        bs=N            Read and write N bytes at a time
        ibs=N           Read N bytes at a time
        obs=N           Write N bytes at a time
        count=N         Copy only N input blocks
        skip=N          Skip N input blocks
        seek=N          Skip N output blocks
        conv=notrunc    Don't truncate output file
        conv=noerror    Continue after read errors
        conv=sync       Pad blocks with zeros
        conv=fsync      Physically write data out before finishing

2. write c source file and open with O_DIRECT flag.
#include <stdio.h>
#include <stdlib.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <fcntl.h>

char message[] = "/mnt/usb/4854344154343452/test.txt";
int main()
{
   int fd;
   char buffer[5];
   int count = 0;
   char *buf="1234567890";
   if((fd=open(message,O_CREAT|O_TRUNC|O_RDWR|O_DIRECT, 0777))<0)
   {
       perror("open");
       return -1;
   }
   printf("fd=%d\n", fd);
   write(fd, buf, strlen(buf));
   while(1){
       lseek(fd,0,SEEK_SET);
       sleep(3);
       count = read(fd, buffer, 3);
       printf("count=%d,%x,%x,%x\n", count,buffer[0],buffer[1],buffer[2]);
   }

}

2014-07-09 16:37 GMT+08:00 David Laight <David.Laight@aculab.com>:
> From: loody
> ...
>> but what it really do is read sector, not media_change or test_unit_ready.
>
> Maybe one of the programs that reads the mbr partition table can
> be persuaded to do a direct read?
>
>         David
>



-- 
Regards,
