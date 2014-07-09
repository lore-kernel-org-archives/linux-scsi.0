From: Alan Stern <stern-nwvwT67g6+6dFdvTe/nMLpVzexx5G7lz@public.gmane.org>
Subject: Re: dummy scsi read or scsi command periodically for external USB
 Hard Disk
Date: Wed, 9 Jul 2014 10:25:09 -0400 (EDT)
Message-ID: <Pine.LNX.4.44L0.1407091022480.873-100000@iolanthe.rowland.org>
References: <CANudz+tQ4pJFmLTRsHtL=VjuCg30Af+7CpK1qRQM5TwwShoQtA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CANudz+tQ4pJFmLTRsHtL=VjuCg30Af+7CpK1qRQM5TwwShoQtA-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: loody <miloody-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: David Laight <David.Laight-JxhZ9S5GRejQT0dZR+AlfA@public.gmane.org>, "Bryn M. Reeves" <bmr-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "linux-usb-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-usb-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, SCSI development list <linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-scsi@vger.kernel.org

On Wed, 9 Jul 2014, loody wrote:

> hi all:
> I try 2 methods today but there is no read command firing from usb
> host to device
> (I double check the existence of command by CATC protocol analyzer)
> appreciate all your kind suggestion.
> 
> 1. use busybox like below command
> dd if=/dev/sda1 of=/dev/null bs=512 count=1 conv=sync
> my dd in busybox doesn't have iflags option
> # ./busybox.new dd help
> 
> BusyBox v1.19.2 (2014-07-09 13:43:36 CST) multi-call binary.
> Usage: dd [if=FILE] [of=FILE] [ibs=N] [obs=N] [bs=N] [count=N] [skip=N]
>         [seek=N] [conv=notrunc|noerror|sync|fsync]
> Copy a file with converting and formatting
>         if=FILE         Read from FILE instead of stdin
>         of=FILE         Write to FILE instead of stdout
>         bs=N            Read and write N bytes at a time
>         ibs=N           Read N bytes at a time
>         obs=N           Write N bytes at a time
>         count=N         Copy only N input blocks
>         skip=N          Skip N input blocks
>         seek=N          Skip N output blocks
>         conv=notrunc    Don't truncate output file
>         conv=noerror    Continue after read errors
>         conv=sync       Pad blocks with zeros
>         conv=fsync      Physically write data out before finishing
> 
> 2. write c source file and open with O_DIRECT flag.
> #include <stdio.h>
> #include <stdlib.h>
> #include <sys/types.h>
> #include <sys/stat.h>
> #include <fcntl.h>
> 
> char message[] = "/mnt/usb/4854344154343452/test.txt";
> int main()
> {
>    int fd;
>    char buffer[5];
>    int count = 0;
>    char *buf="1234567890";
>    if((fd=open(message,O_CREAT|O_TRUNC|O_RDWR|O_DIRECT, 0777))<0)
>    {
>        perror("open");
>        return -1;
>    }
>    printf("fd=%d\n", fd);
>    write(fd, buf, strlen(buf));
>    while(1){
>        lseek(fd,0,SEEK_SET);
>        sleep(3);
>        count = read(fd, buffer, 3);
>        printf("count=%d,%x,%x,%x\n", count,buffer[0],buffer[1],buffer[2]);
>    }
> 
> }

You can do what you want by using the SCSI Generic API.  See the Linux 
SCSI Generic (sg) HOWTO:

	http://tldp.org/HOWTO/SCSI-Generic-HOWTO/

With the proper ioctl call, you can send a READ(10) command telling the 
drive to read one block starting from block 0.

Alan Stern

--
To unsubscribe from this list: send the line "unsubscribe linux-usb" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
