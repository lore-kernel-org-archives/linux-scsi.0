From: Douglas Gilbert <dougg@torque.net>
Subject: Re: SCSI passthrough ioctl calls vs. sd/sg devices
Date: Sun, 25 Apr 2004 16:49:45 +1000
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <408B5F89.1030403@torque.net>
References: <519672568F040C41B6FAC21ADF51B18FEFBE@mailnode1.commstor.crossroads.com> <4089E7B2.5060803@torque.net> <Pine.LNX.4.58.0404240950330.7758@kai.makisara.local> <20040424124205.GW13443@serve.riede.org>
Reply-To: dougg@torque.net
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bunyip.cc.uq.edu.au ([130.102.2.1]:13841 "EHLO
	bunyip.cc.uq.edu.au") by vger.kernel.org with ESMTP id S261915AbUDYGtv
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 25 Apr 2004 02:49:51 -0400
In-Reply-To: <20040424124205.GW13443@serve.riede.org>
List-Id: linux-scsi@vger.kernel.org
To: osst@riede.org
Cc: Kai Makisara <Kai.Makisara@kolumbus.fi>, Lee Xing <lxing@Crossroads.com>, linux-scsi@vger.kernel.org

Willem Riede wrote:
> On 2004.04.24 02:58, Kai Makisara wrote:
> 
>>On Sat, 24 Apr 2004, Douglas Gilbert wrote:
>>
>>...
>>
>>>In the lk 2.6 series the SG_IO ioctl is available for block
>>>devices which include SCSI disks and ATAPI dvd/cd drives.
>>>The SG_IO ioctl is currently not available for SCSI char
>>>device drivers (e.g. st and osst) other than sg itself.
>>
>>SG_IO is available for st in current 2.6 (Patrick Mansfield added a few 
>>lines of code to st.c). Similar changes could be probably done to osst.
> 
> 
> I'll be happy to do that (make the equivalent change to osst) if that's 
> the best way to complete the SG_IO support.

Willem,
The st mods for SG_IO seem to be working fine in lk 2.6.6-rc2.
See st's call to scsi_cmd_ioctl(). [As well as calling the SG_IO
ioctl, CDROM_SEND_PACKET is also available?! ]

So a recent version of sg3_utils (like version 1.06 beta on
http://www.torque.net/sg ) can know use /dev/st* device
names. For example:

# sg_modes -6 /dev/st0
     SONY      SDT-7000          0192   peripheral_type: tape [0x1]
Mode parameter header from 6 byte MODE SENSE:
   Mode data length=72, medium type=0x00, specific param=0x10, longlba=0
   Block descriptor length=8
 > General mode parameter block descriptors:
    Density code=0x13
  00     13 00 00 00 00 00 02 00

 >> page_code: Disconnect-Reconnect, page_control: current
  00     02 0e 00 00 00 00 00 00  00 00 01 ee 00 00 00 00
 >> page_code: Data Compression, page_control: current
  00     0f 0e c0 80 00 00 00 20  00 00 00 20 00 00 00 00
 >> page_code: Device config, page_control: current
  00     10 0e 08 00 00 00 00 32  60 00 18 00 00 00 00 00
 >> page_code: Medium Partition [1], page_control: current
  00     11 0a 01 00 10 03 00 00  0e 73 00 00

Also on that site is a beta of lsscsi version 0.12 for
lk 2.6.6 :

# lsscsi
[3:0:6:0]    tape    SONY     SDT-7000         0192  /dev/st0
[root@dink devices]# lsscsi -g
[3:0:6:0]    tape    SONY     SDT-7000         0192  /dev/st0  /dev/sg0
# lsscsi -l
[3:0:6:0]    tape    SONY     SDT-7000         0192  /dev/st0
   state=running queue_depth=1 scsi_level=3 type=1 device_blocked=0

# lsscsi -H
[3]    aha152x
# lsscsi -Hv
  sysfsroot: /sys
[3]    aha152x
   dir: /sys/class/scsi_host/host3
   device dir:/sys/devices/platform/host3
# lsscsi -Hl
[3]    aha152x
   cmd_per_lun=1    host_busy=0    sg_tablesize=255  unchecked_isa_dma=0



Doug Gilbert



