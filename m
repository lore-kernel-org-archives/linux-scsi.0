From: Douglas Gilbert <dougg@torque.net>
Subject: Re: registering lun: add-single-device does not work
Date: Fri, 23 Sep 2005 10:35:25 +1000
Message-ID: <43334DCD.2070709@torque.net>
References: <20050922094257.2734B3384B@ws7-3.us4.outblaze.com>
Reply-To: dougg@torque.net
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from zorg.st.net.au ([203.16.233.9]:6829 "EHLO borg.st.net.au")
	by vger.kernel.org with ESMTP id S1751232AbVIWAek (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 22 Sep 2005 20:34:40 -0400
In-Reply-To: <20050922094257.2734B3384B@ws7-3.us4.outblaze.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: akshat verma <akshat@lycos.com>
Cc: linux-scsi@vger.kernel.org

akshat verma wrote:
> 
>>I have been trying to register luns created on a FastT box with 
>>my linux box..
>>
>>the luns are visible to linux
>>cat /proc/scsi/qla2200/0 returns the following..  as one can see, 
>>the luns are not registered..
>>---------------
>>QLogic PCI to Fibre Channel Host Adapter for QLA22xx:
>>         Firmware version:  2.02.06, Driver version 7.01.01
>>Entry address = f8831060
>>HBA: QLA2200 , Serial# J17188
>>Request Queue = 0x2b300000, Response Queue = 0x2b7f0000
>>Request Queue count= 512, Response Queue count= 64
>>Total number of active commands = 0
>>Total number of interrupts = 51
>>Total number of IOCBs (used/max) = (0/600)
>>Total number of queued commands = 0
>>     Device queue depth = 0x20
>>Number of free request entries = 510
>>Number of mailbox timeouts = 0
>>Number of ISP aborts = 0
>>Number of loop resyncs = 4
>>Number of retries for empty slots = 0
>>Number of reqs in pending_q= 0, retry_q= 0, done_q= 0, scsi_retry_q= 0
>>Host adapter:loop state= <READY>, flags= 0x868811
>>Dpc flags = 0x0
>>MBX flags = 0x0
>>SRB Free Count = 4096
>>Link down Timeout = 000
>>Port down retry = 030
>>Login retry count = 030
>>Commands retried with dropped frame(s) = 0
>>
>>
>>SCSI Device Information:
>>scsi-qla0-adapter-node=200000e08b0dc4fe;
>>scsi-qla0-adapter-port=210000e08b0dc4fe;
>>scsi-qla0-target-0=200b00a0b80be4d7;
>>
>>SCSI LUN Information:
>>(Id:Lun)  * - indicates lun is not registered with the OS.
>>( 0: 0): Total reqs 1, Pending reqs 0, flags 0x0*, 0:0:82,
>>( 0: 1): Total reqs 0, Pending reqs 0, flags 0x0*, 0:0:82,
>>( 0: 5): Total reqs 0, Pending reqs 0, flags 0x0*, 0:0:82,
>>-------------------------------------------------------------------
>>
>>and so going thru the lists, I figured that an
>>echo "scsi add-single-device 0 0 0 0" > /proc/scsi/scsi
>>should be able to register the lun.. however, it does not change anything..
>>
>>I checked also at /proc/scsi/sg/devices but the device was not registered..

$ cat /proc/scsi/sg/device_hdr
host    chan    id      lun     type    opens   qdepth  busy    online
>>0       0       0       0       3       0       32      0       0
<snip>

Akshat,
Placing the header above that line shows device 0 0 0 0
is registered as /dev/sg0. It has peripheral device
type 3 which is for "processor". That will either be a SAFTE
(i.e. SES like) device or a scanner (unlikely).

If it is a SAFTE device then have a look at:
http://oss.metaparadigm.com/safte-monitor

Doug Gilbert
