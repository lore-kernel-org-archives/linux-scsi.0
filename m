From: "H.Rosmanith (Kernel Mailing List)" <kernel@wildsau.enemy.org>
Subject: *panic* on "send diagnostic"
Date: Wed, 29 Dec 2004 19:01:16 +0100 (MET)
Message-ID: <200412291801.iBTI1GFC022288@wildsau.enemy.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from wildsau.idv.uni.linz.at ([193.170.194.34]:47503 "EHLO
	wildsau.enemy.org") by vger.kernel.org with ESMTP id S261385AbUL2SFW
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 29 Dec 2004 13:05:22 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: "H.Rosmanith (Kernel Mailing List)" <kernel@wildsau.enemy.org>


good evening,

I have a small progamm which does a "send diagnostic" command to some
device. Since I just started experimenting with the SG_IO interface,
the program may be wrong, but: nevertheless it should not be possible
to make the kernel panic.

kernel is 2.6.10

the program below (let's call it "sg_test") does:
1) when started on e.g. /dev/hda, it says: "scsi: unknown opcode 0x1d"m
   but according to scsi-specs (s2-r10l.pdf) , 0x1d == send diagnostic
   is mandatory for self test command.

2) when started on /dev/sda, where sda is a 3ware RAID controller,
   the kernel will panick. could anyone verify this? I don't have a
   ksymoops here.

here's the nasty code:
--- snip ---
/* 
 * Wed Dec 29 19:03:48 CET 2004 herp - Herbert Rosmanith
 *
 * send a "send diagnostic" scsi command
 *
 */

#include        <sys/types.h>
#include        <fcntl.h>
#include        <scsi/sg.h>

void die(char *s) {
        perror(s);
        exit(-1);
}

u_char snsbuf[32];
sg_io_hdr_t ioh;
u_char scsiCmd[5]={0x1d,};

int main(int argc,char *argv[]) {
int fd;
int i;

        if (argc!=2)
                die("usage");
        if ((fd=open(argv[1],O_RDONLY|O_NDELAY))==-1)
                die("open");
        if (ioctl(fd,SG_GET_VERSION_NUM,&i)==-1)
                die("ioctl");
        if (i<30000)
                die("version");

        memset(&ioh,0,sizeof(ioh));
        ioh.interface_id='S';
        ioh.cmdp=scsiCmd;
        ioh.cmd_len=sizeof(scsiCmd);
        ioh.sbp=snsbuf;
        ioh.mx_sb_len=sizeof(snsbuf);
        ioh.dxfer_direction=SG_DXFER_NONE;
        ioh.timeout=500;
        if (ioctl(fd,SG_IO,&ioh)==-1)
                die("SG_IO");
        printf("info=%.2x\n",ioh.info);
        if ((ioh.info&SG_INFO_OK_MASK)!=SG_INFO_OK) {
                printf("command failed\n");
        }
        for(i=0;i<sizeof(snsbuf);i++)
                printf("%.2x ",snsbuf[i]);
        printf("\n");
        close(fd);
}

