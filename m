From: "Kotian, Deepak" <Deepak.Kotian@patni.com>
Subject: FW: A bug RedHat AS 4.0 kernel , is it correct, can anyone confirm
Date: Fri, 4 Mar 2005 17:14:00 +0530
Message-ID: <374639AB1012AA4C840022842AA95BC204716B36@ruby.patni.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Received: from pcsmail.patni.com ([203.124.139.197]:35286 "EHLO
	pcsmail.patni.com") by vger.kernel.org with ESMTP id S262852AbVCDLzO convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 4 Mar 2005 06:55:14 -0500
Received: from ruby.patni.com (ruby [204.165.186.9])
	by pcsmail.patni.com (8.12.11/8.12.9) with ESMTP id j24BuTKt011223
	for <linux-scsi@vger.kernel.org>; Fri, 4 Mar 2005 17:26:35 +0530
Content-class: urn:content-classes:message
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Can linux-scsi@vger.kernel.org comment on this one if the understanding is
correct. 

Thanks and Regards
Deepak


-----Original Message-----
From: kernelnewbies-bounce@nl.linux.org
[mailto:kernelnewbies-bounce@nl.linux.org]On Behalf Of Kotian, Deepak
Sent: Friday, March 04, 2005 1:57 AM
To: kernelnewbies@nl.linux.org
Subject: A bug RedHat AS 4.0 kernel , is it correct, can anyone confirm


A bug RedHat AS 4.0 kernel , is it correct, can anyone confirm

Bug Description :-
The SCSI_IOCTL_GET_IDLUN ioctl fails for LUN number > 255

Bug Details :-
The  scsi_idlun structure is defined as follows
typedef struct scsi_idlun {
__u32 dev_id;
__u32 host_unique_id;
} Scsi_Idlun;

The dev_id is a 32 bit value and the HCLT is encoded here.
This is derived from the following code in scsi_ioctl.c

int scsi_ioctl(struct scsi_device *sdev, int cmd, void *arg)
{
.....
 case SCSI_IOCTL_GET_IDLUN:
if (verify_area(VERIFY_WRITE, arg, sizeof(struct scsi_idlun)))
 	return -EFAULT;
__put_user((sdev->id & 0xff)
	+ ((sdev->lun & 0xff) << 8)
	+ ((sdev->channel & 0xff) << 16)
	+ ((sdev->host->host_no & 0xff) << 24),
	&((struct scsi_idlun *)arg)->dev_id);
	__put_user(sdev->host->unique_id,
		&((struct scsi_idlun *)arg)->host_unique_id);
.......
}

This code clearly indicates that all the values (i.e H,C,L and T) are anded with 0xff and hence the limitation for each value (including LUN value) becomes 255.

But the scsi mid layer has the support for 512 LUNs.

So if one has to obtain the LUN number for LUNs > 255 the SCSI_IOCTL_GET_IDLUN ioctl would fail.

Thanks and Regards
Dee[al

--
Kernelnewbies: Help each other learn about the Linux kernel.
Archive:       http://mail.nl.linux.org/kernelnewbies/
FAQ:           http://kernelnewbies.org/faq/

