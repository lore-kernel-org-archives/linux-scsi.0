From: "Salyzyn, Mark" <mark_salyzyn@adaptec.com>
Subject: RE: [PATCH] dpt_i2o changes for 2.6.2 kernel in support of 64 bit and bitrot (part 1)
Date: Mon, 5 Apr 2004 13:56:12 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <547AF3BD0F3F0B4CBDC379BAC7E4189F64F204@otce2k03.adaptec.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from magic.adaptec.com ([216.52.22.17]:11450 "EHLO magic.adaptec.com")
	by vger.kernel.org with ESMTP id S263039AbUDER4O convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 5 Apr 2004 13:56:14 -0400
content-class: urn:content-classes:message
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>
Cc: Christoph Hellwig <hch@infradead.org>

We need a means for an application to tell if a scsi device is currently
in use; one of in-error or with any I/O still pending or opened or
mounted. This is necessary to inform users of the RAID management
applications that the device is not to be adjusted.

In-error is easy enough, test_bit(SHOST_RECOVERY,
&pHba->host->host_state) for 2.6, and pHba->host->in_recovery for 2.4.

I/O pending can be determined with Scsi_Device::access_count for 2.6.

Unfortunately new members like struct scsi_disk::openers are
inaccessible to the scsi driver to indicate whether there are any
applications that have the scsi device open.

This is complicated further if the device is accessed via the sg layer
as well (sd's openers does not meter sg's openers).

Are there any suggestions, either for the application, or for the scsi
driver to meter disk in-use? Without this, it is *impossible* for us to
support reliable native RAID management applications; a user application
should *never* be a source of an OS panic (whether it be someone
destroying the boot array, or simply a file system driver panicking when
a device no longer exists)

Sincerely -- Mark Salyzyn

-----Original Message-----
From: Christoph Hellwig [mailto:hch@infradead.org] 
Sent: Tuesday, February 10, 2004 4:22 PM
To: Salyzyn, Mark
Cc: linux-scsi
Subject: Re: [PATCH] dpt_i2o changes for 2.6.2 kernel in support of 64
bit and bitrot (part 1)

< snip >

+	case DPT_TARGET_BUSY & 0xFFFF:
+	case DPT_TARGET_BUSY:
+	{
+		TARGET_BUSY_T busy;
+		struct adpt_device* d;
+
+		if (copy_from_user((void*)&busy, (void*)arg,
sizeof(TARGET_BUSY_T))) {
+			return -EFAULT;
+		}
+
+		d = adpt_find_device(pHba, busy.channel, busy.id,
busy.lun);
+		if(d == NULL){
+			return -ENODEV;
+		}
+		busy.isBusy = ((d->pScsi_dev)
+		 && (d->pScsi_dev->device_busy /* Imperfect */
+		  || test_bit(SHOST_RECOVERY,
&pHba->host->shost_state)));
+		if (copy_to_user ((char*)arg, &busy, sizeof(busy))) {
+			return -EFAULT;
+		}
+		break;
+	}

	This ioctl was removed because it's broken.  Don't readd it.
