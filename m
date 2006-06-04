From: Brian King <brking@us.ibm.com>
Subject: Re: Fw: SCSI device not spinning up on rw
Date: Sun, 04 Jun 2006 17:11:46 -0500
Message-ID: <44835AA2.1070809@us.ibm.com>
References: <20060603182302.7136831f.akpm@osdl.org> <44825D9F.9070305@torque.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e36.co.us.ibm.com ([32.97.110.154]:9107 "EHLO e36.co.us.ibm.com")
	by vger.kernel.org with ESMTP id S932283AbWFDWLw (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 4 Jun 2006 18:11:52 -0400
Received: from westrelay02.boulder.ibm.com (westrelay02.boulder.ibm.com [9.17.195.11])
	by e36.co.us.ibm.com (8.12.11.20060308/8.12.11) with ESMTP id k54MBpob031850
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-scsi@vger.kernel.org>; Sun, 4 Jun 2006 18:11:51 -0400
Received: from d03av03.boulder.ibm.com (d03av03.boulder.ibm.com [9.17.195.169])
	by westrelay02.boulder.ibm.com (8.13.6/NCO/VER7.0) with ESMTP id k54MBp5S046716
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-scsi@vger.kernel.org>; Sun, 4 Jun 2006 16:11:51 -0600
Received: from d03av03.boulder.ibm.com (loopback [127.0.0.1])
	by d03av03.boulder.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id k54MBoXs028059
	for <linux-scsi@vger.kernel.org>; Sun, 4 Jun 2006 16:11:51 -0600
In-Reply-To: <44825D9F.9070305@torque.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: dougg@torque.net
Cc: Andrew Morton <akpm@osdl.org>, linux-scsi@vger.kernel.org, Ruben Faelens <parasietje@gmail.com>

Douglas Gilbert wrote:
>> I have a SCSI disk, which I want to spin down when the system is not in
>> use. I do this by using sdparm, scsi-spin or sg-utils. These tools all
>> spin down the SCSI drive by using an IOCTL.
>>
>> Problem is that the kernel doesn't spin the drive back up. When a
>> process requests data from the disk (a simple ls), the kernel responds
>> with an I/O error. After some of these errors, reiserfs marks the drive
>> read-only.

Setting sdev->allow_restart in struct scsi_device will cause sense
key/code/qual of 02/04/02 (not ready, initialization command required)
to wake up the scsi error handler and will force scsi core to issue
a start unit command to the disk. I added this a while back to handle
ipr raid arrays which need a start unit command each time the adapter
gets reset. It would be easy enough for sd to use this, either
all the time, or only when directed to, or we could add a sysfs attribute
to the disk to enable/disable this behavior.

Brian

