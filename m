From: Douglas Gilbert <dougg@torque.net>
Subject: Re: lsscsi for lk 2.5.51
Date: Wed, 18 Dec 2002 11:13:55 +1100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <3DFFBDC3.9070009@torque.net>
References: <3DFBE00B.1070805@torque.net>
Reply-To: dougg@torque.net
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org
To: dougg@torque.net
Cc: linux-scsi@vger.kernel.org, patmans@us.ibm.com

Done a bit more work on lsscsi:
  - entries now sorted by host,channel,id,lun tuple
  - "classic" option ('-c') that outputs just like
    'cat /proc/scsi/scsi'
  - added a few more switches and fixed some bugs.

There is a small web page at:
    http://www.torque.net/scsi/lsscsi.html
On it there are links to a tarball, binary and source rpms.

Doug Gilbert


Douglas Gilbert wrote:
> Since sysfs now contains a reasonable amount of data about
> scsi devices, it is possible to write an application
> that scans this information and presents it in a "ls"
> form (akin to lspci and lsusb).
> 
> Attached is a toy program called lsssci that could
> grow into something more useful. It requires lk 2.5.51
> or later.
> 
> $ lsscsi
> [4:0:0:0]  CDROM   CREATIVE CD5233E          1.00  /dev/sr0
> [3:0:0:0]  disk    Linux    scsi_debug       0004  /dev/sdb
> [2:0:6:0]  tape    SONY     SDT-7000         0192
> [0:0:8:0]  disk    FUJITSU  MAM3184MP        0105  /dev/sda
> 
> 
> This output corresponds to my system which has these "scsi"
> devices:
> 
> $ cat /proc/scsi/scsi
> Attached devices:
> Host: scsi0 Channel: 00 Id: 08 Lun: 00
>   Vendor: FUJITSU  Model: MAM3184MP        Rev: 0105
>   Type:   Direct-Access                    ANSI SCSI revision: 03
> Host: scsi2 Channel: 00 Id: 06 Lun: 00
>   Vendor: SONY     Model: SDT-7000         Rev: 0192
>   Type:   Sequential-Access                ANSI SCSI revision: 02
> Host: scsi3 Channel: 00 Id: 00 Lun: 00
>   Vendor: Linux    Model: scsi_debug       Rev: 0004
>   Type:   Direct-Access                    ANSI SCSI revision: 03
> Host: scsi4 Channel: 00 Id: 00 Lun: 00
>   Vendor: CREATIVE Model: CD5233E          Rev: 1.00
>   Type:   CD-ROM                           ANSI SCSI revision: 02
> 
> 
> sysfs doesn't provide the ANSI SCSI revision number associated
> with each device (hopefully Pat can add that in the future).
> Otherwise, all the information that /proc/scsi/scsi uses 3
> lines per device for, can be compressed onto one line. Putting
> the device node (e.g. /dev/sda) seems a useful addition.
> [That latter addition is only done currently for block scsi
> devices (hence it doesn't appear for the tape).]
> 
> Doug Gilbert



