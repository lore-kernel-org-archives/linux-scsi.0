From: "Surekha.PC" <surekhap@cisco.com>
Subject: RE: Request for review of Linux iSCSI driver version 4.0.0.2
Date: Mon, 1 Dec 2003 16:16:25 +0530
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <002b01c3b7f8$5e6fbf20$a0074d0a@apac.cisco.com>
References: <20031128120338.A8954@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from india-ironport-1.cisco.com ([64.104.129.195]:2343 "EHLO
	india-ironport-1.cisco.com") by vger.kernel.org with ESMTP
	id S262827AbTLAKqc (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 1 Dec 2003 05:46:32 -0500
In-Reply-To: <20031128120338.A8954@infradead.org>
List-Id: linux-scsi@vger.kernel.org
To: 'Christoph Hellwig' <hch@infradead.org>, 'Naveen Burmi' <naveenb@cisco.com>
Cc: linux-scsi@vger.kernel.org, davmyers@cisco.com



>> 10.  - the procfs code is a mess.  Please move it over to
>>         proper per-device / per-host sysfs attributes as procfs
>>         support in HBA drivers is deprecated.

>please don't add an attribute group, just use the shost_attrs field in
the host template.
 
Can you please let me know why we should not use attribute group? Isn't
it recommended for the driver writers to use it?

The main reason for using this was to have all iSCSI specific files in
one place so that its' easier for the user to find them. There are many
iSCSI attributes which will need to be changed/read, so we preferred to
put in one place.

>iscsi_show_device() doesn't look like a good idea,what about adding an
iscsi pseudo 
device as parent to identify the device as iscsi in sysfs?

iscsi_show_device() creates sysfs file "device_type" which is checked
while parsing "udev.config" for iSCSI device activation. Since device
attributes like vendor, model etc reside in this directory, isn't it ok
to have it here?

If not, would like to know what field we need to use, for adding iscsi
peusdo device as parent, I doubt this can be done with shost_attrs and
sdev_attrs of host template.   

>This whole find_keyword business is not good.  sysfs files are supposed
to have a single >value.  We should probably do some brainstorming on
the right API for this..

Our driver has lot of user space attributes. Making each attribute as a
separate file will endup with lots of files. So we want to have all
target specific attributes together in one file and lun specific
attributes in another file for convinience. find_keyword() will help
search for these keys from the cmdline specified.

Pls let me know your suggestions.

Thanks,
surekha

