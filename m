From: "Salyzyn, Mark" <mark_salyzyn@adaptec.com>
Subject: RE: [PATCH] Fix error handler offline behaviour
Date: Wed, 17 Mar 2004 13:16:43 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <547AF3BD0F3F0B4CBDC379BAC7E4189F64E6C9@otce2k03.adaptec.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from magic.adaptec.com ([216.52.22.17]:5792 "EHLO magic.adaptec.com")
	by vger.kernel.org with ESMTP id S261898AbUCQSQo convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 17 Mar 2004 13:16:44 -0500
content-class: urn:content-classes:message
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: SCSI Mailing List <linux-scsi@vger.kernel.org>


We are on the same page, I *like* scsi_device_online, but I don't see
the similar abstraction when (a driver does the) setting of the
online/offline state.

Sincerely -- Mark Salyzyn

-----Original Message-----
From: James Bottomley [mailto:James.Bottomley@SteelEye.com] 
Sent: Wednesday, March 17, 2004 11:47 AM
To: Salyzyn, Mark
Cc: SCSI Mailing List
Subject: RE: [PATCH] Fix error handler offline behaviour

On Wed, 2004-03-17 at 11:29, Salyzyn, Mark wrote:
> There was a scsi_device_online(Sdev) handler used in the patch, why
not
> a scsi_device_set_online(Sdev) and a scsi_device_set_offline(Sdev)?

Because I want to abstract out the online checks.  At the moment it's
simply != SDEV_OFFLINE, but this might change.

Firstly, at the moment, the state model has *two* possible transitions
for SDEV_OFFLINE, so a function setting online wouldn't necessarily know
where to go and secondly I'm dubious about the wisdom of drivers
actually mucking with the online flags and certainly don't want to
encourage it.

James


