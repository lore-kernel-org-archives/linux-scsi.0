From: Mike Christie <michaelc@cs.wisc.edu>
Subject: [PATCH RFC 0/3] add fc transport events
Date: Thu, 27 May 2004 00:25:11 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <40B597D7.3080909@cs.wisc.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:45316 "EHLO sabe.cs.wisc.edu")
	by vger.kernel.org with ESMTP id S261680AbUE0HZU (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 27 May 2004 03:25:20 -0400
Received: from cs.wisc.edu ([199.108.226.254])
	(authenticated (0 bits))
	by sabe.cs.wisc.edu (8.11.3/8.11.3) with ESMTP id i4R7PCw07585
	(using TLSv1/SSLv3 with cipher RC4-MD5 (128 bits) verified NO)
	for <linux-scsi@vger.kernel.org>; Thu, 27 May 2004 02:25:19 -0500
List-Id: linux-scsi@vger.kernel.org
To: SCSI Mailing List <linux-scsi@vger.kernel.org>

The following patches begin to address the problem of allowing
a userspace program to online or offline a scsi device. The major
change is the layout of the transport class so that devices are
presented under an adapter with the fc_transport class node the root
for adapters. There's still no adapter level attributes so the host's
class_device is really just being used as way to nicely structure things,
and the class_device in the scsi_device has been converted to a kobject.


Here is a partial tree:

elm3a38:/sys/class/fc_transport # tree
.
|-- host4
|   |-- 4:0:0:0
|   |   |-- node_name
|   |   |-- port_id
|   |   `-- port_name
|   |-- 4:0:1:0
|   |   |-- node_name
|   |   |-- port_id
|   |   `-- port_name
|   `-- device -> ../../../devices/pci0000:02/0000:02:03.0/host4
`-- host5
     |-- 5:0:0:0
     |   |-- node_name
     |   |-- port_id
     |   `-- port_name
     |-- 5:0:1:0
.
.
.

01-add-host-transport-classdev.patch - adds the transport class_device to
the scsi_host structure.

02-sdev-transport-kobj.patch - converts the transport class_device in the
scsi_device to a kobject.

03-convert-fc-class.patch - converts the fc class from a class_device
scsi_device to a kobject and adds a basic link_up/down event fucntion.

(I did not convert the spi class yet, becuase I wasn't sure how people
would feel about such a change)

Mike Christie


