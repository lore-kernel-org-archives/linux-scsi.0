From: "Moore, Eric Dean" <Eric.Moore@lsil.com>
Subject: Adding/Removing SCSI Devices in LLD's in 2.6 Kernel
Date: Mon, 31 Jan 2005 11:46:57 -0700
Message-ID: <91888D455306F94EBD4D168954A9457C010BAC51@nacos172.co.lsil.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail0.lsil.com ([147.145.40.20]:22694 "EHLO mail0.lsil.com")
	by vger.kernel.org with ESMTP id S261305AbVAaSrb (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 31 Jan 2005 13:47:31 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@SteelEye.com, hch@lst.de, hch@infradead.org, linux-scsi@vger.kernel.org

I was wondering what the policy on using 
scsi_add_device and scsi_remove_device in the scsi 
lower layer drivers?  

The mpt fusion driver can receive device add/remove
asynchronous events from the firmware.
The driver is notified of device change events from
contents of the driver interrupt routine. 

(1) Is it okay for scsi lower layer drivers
report device changes to the scsi mid-layer when 
the events are received, using scsi_add_device and
scsi_remove_device?

(2) Or do we have to do this thru applications? 
Meaning using SySFS and the following:

echo "1" > /sys/class/scsi_host/host0/scan 
echo "1" > /sys/class/scsi_device/H:C:T:L/device/delete

(3) How does the app know about the asyn events?
Is it okay for scsi lower layer driver use the async API:

kill_fasync(handle, SIGIO,POLL_IN)
fasync_helper()
.fasync entry point in the IOCTL path?

Eric Moore
Standard Storage Products Division
LSI Logic Corporation
