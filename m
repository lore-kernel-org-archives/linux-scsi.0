From: James Bottomley <James.Bottomley@steeleye.com>
Subject: RE: [PATCH] Fix error handler offline behaviour
Date: 17 Mar 2004 11:47:25 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1079542049.2137.6.camel@mulgrave>
References: <547AF3BD0F3F0B4CBDC379BAC7E4189F64E6BB@otce2k03.adaptec.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat1.steeleye.com ([65.114.3.130]:41124 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S261872AbUCQQre (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 17 Mar 2004 11:47:34 -0500
In-Reply-To: <547AF3BD0F3F0B4CBDC379BAC7E4189F64E6BB@otce2k03.adaptec.com>
List-Id: linux-scsi@vger.kernel.org
To: "Salyzyn, Mark" <mark_salyzyn@adaptec.com>
Cc: SCSI Mailing List <linux-scsi@vger.kernel.org>

On Wed, 2004-03-17 at 11:29, Salyzyn, Mark wrote:
> There was a scsi_device_online(Sdev) handler used in the patch, why not
> a scsi_device_set_online(Sdev) and a scsi_device_set_offline(Sdev)?

Because I want to abstract out the online checks.  At the moment it's
simply != SDEV_OFFLINE, but this might change.

Firstly, at the moment, the state model has *two* possible transitions
for SDEV_OFFLINE, so a function setting online wouldn't necessarily know
where to go and secondly I'm dubious about the wisdom of drivers
actually mucking with the online flags and certainly don't want to
encourage it.

James


