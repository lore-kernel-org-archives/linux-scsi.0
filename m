From: Stephen Cameron <smcameron@yahoo.com>
Subject: App correlating PCI info with SCSI host number
Date: Thu, 27 Jan 2005 06:12:51 -0800 (PST)
Message-ID: <20050127141251.82212.qmail@web12308.mail.yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from web12308.mail.yahoo.com ([216.136.173.106]:12152 "HELO
	web12308.mail.yahoo.com") by vger.kernel.org with SMTP
	id S262628AbVA0OM7 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 27 Jan 2005 09:12:59 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org


I know on 2.6, I seem to be able to do 
something like this to correlate PCI 
(domain)/bus/dev/func with the linux 
assigned scsi host number.

myhost:/sys/bus/scsi/devices # find /sys/devices -name 'host[0-9]*' -print
/sys/devices/pci0000:64/0000:64:01.1/host15
/sys/devices/pci0000:64/0000:64:01.0/host14
/sys/devices/pci0000:62/0000:62:01.1/host11
/sys/devices/pci0000:62/0000:62:01.0/host10
/sys/devices/pci0000:60/0000:60:03.1/host9
/sys/devices/pci0000:60/0000:60:03.0/host8
/sys/devices/pci0000:60/0000:60:02.1/host7
/sys/devices/pci0000:60/0000:60:02.0/host6
/sys/devices/pci0000:38/0000:38:01.1/host5
/sys/devices/pci0000:38/0000:38:01.0/host4
/sys/devices/pci0000:34/0000:34:01.1/host13
/sys/devices/pci0000:34/0000:34:01.0/host12
/sys/devices/pci0000:20/0000:20:03.1/host3
/sys/devices/pci0000:20/0000:20:03.0/host2
/sys/devices/pci0000:20/0000:20:02.1/host1
/sys/devices/pci0000:20/0000:20:02.0/host0

Is there any generic way to make the same sort
of correlation on 2.4 kernels?

I know I can do, for instance, 

myhost:/sys/bus/scsi/devices # cat /proc/scsi/sym53c8xx/0
Chip sym53c1010-66, device id 0x21, revision id 0x1
At PCI address 0000:20:02.0, IRQ 50
Min. period factor 9, Wide SCSI BUS, DT capable
Max. started commands 448, max. commands per LUN 64

And so correlate scsi host 0 with "PCI address 0000:20:02.0"
However, that is of course different from driver to driver,
(on many the PCI info is not apparently available)
and even from version to version of the same driver, e.g:
here's a different version:

[root@myotherhost sym53c8xx]# cat /proc/scsi/sym53c8xx/0
General information:
  Chip sym53c1010-66, device id 0x21, revision id 0x1
  On PCI bus 33, device 1, function 0, IRQ 52
  Synchronous period factor 9, max commands per lun 32

So, is there any way that's not so hit-or-miss?

Thanks,

-- steve





		
__________________________________ 
Do you Yahoo!? 
Yahoo! Mail - Find what you need with new enhanced search.
http://info.mail.yahoo.com/mail_250
