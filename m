From: Douglas Gilbert <dougg@torque.net>
Subject: Re: lsscsi-0.09
Date: Fri, 04 Apr 2003 22:55:45 +1000
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <3E8D80D1.9070902@torque.net>
References: <3E8D1D76.7050203@torque.net> <20030404124617.A24518@infradead.org>
Reply-To: dougg@torque.net
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bunyip.cc.uq.edu.au ([130.102.2.1]:15891 "EHLO
	bunyip.cc.uq.edu.au") by vger.kernel.org with ESMTP id S263766AbTDDMnI (for <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 4 Apr 2003 07:43:08 -0500
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-scsi@vger.kernel.org

Christoph Hellwig wrote:
> On Fri, Apr 04, 2003 at 03:51:50PM +1000, Douglas Gilbert wrote:
> 
>>lsscsi is a utility the uses sysfs in kernels >= lk 2.5.50
>>to list information about all SCSI devices (including devices
>>that use the SCSI stack such as USB mass storage devices)
>>and SCSI hosts. Both a compact format (default), one line
>>per device, and a "classic" format (like the output of
>>'cat /proc/scsi/scsi') are supported for devices.
> 
> 
> That reminds me that I wanted to get rid of /proc/scsi/scsi eventually.
> Does someone have an idea for a replacement of it's write routine?
> Some of them don't fit nicely into the sysfs model unfortunatley.

Christoph,
The scsi mid level is just another driver (singleton device?)
so it can have driver parameters in sysfs. If sysfs is going to
displace writes to /proc/scsi/scsi then some of its rules may
have to bend (if they haven't already been). The "one parameter
one file node" rule would make for an ugly replacement of:
   # echo "scsi add-single-device 1 2 3 4" > /proc/scsi/scsi

Actually, scsi_debug's sysfs interface is not far away from
doing something like that (adding hosts rather than individual
devices) but I'm not sure the syntax is very clear:
   # echo 3 > num_tgts
   # echo 64 > max_luns
   # echo 2 > add_host    # add 2 hosts, each with 3 targets,
                          #  each with 64 luns
   # echo -1 > add_hosts  # remove highest numbered host

Doug Gilbert


