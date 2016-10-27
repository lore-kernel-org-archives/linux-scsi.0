From: Sagi Grimberg <sagi@grimberg.me>
Subject: Re: [PATCH] Avoid that SCSI device removal through sysfs triggers a
 deadlock
Date: Thu, 27 Oct 2016 12:36:30 +0300
Message-ID: <2b64c1d7-e6b4-01a9-0c6e-1d8590714595@grimberg.me>
References: <14379fd1-c9bd-ad75-ca7c-0632f3e3c5d1@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-wm0-f67.google.com ([74.125.82.67]:34719 "EHLO
        mail-wm0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932498AbcJ0O6I (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 27 Oct 2016 10:58:08 -0400
Received: by mail-wm0-f67.google.com with SMTP id y138so3112889wme.1
        for <linux-scsi@vger.kernel.org>; Thu, 27 Oct 2016 07:57:54 -0700 (PDT)
In-Reply-To: <14379fd1-c9bd-ad75-ca7c-0632f3e3c5d1@sandisk.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bart Van Assche <bart.vanassche@sandisk.com>, James Bottomley <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Hannes Reinecke <hare@suse.de>, Johannes Thumshirn <jthumshirn@suse.de>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

Hey Bart,

> The solution I prefer is to modify the SCSI scanning code such that
> the scan_mutex is only held while performing the actual LUN scanning
> and while ensuring that no SCSI device has been created yet for a
> certain LUN number but not while the Linux device and its sysfs
> attributes are created. Since that approach would require extensive
> changes in the SCSI scanning code, another approach has been chosen,
> namely to make self-removal asynchronous. This patch avoids that
> self-removal triggers the following deadlock:

Is this a real deadlock? or just a lockdep complaint?

Wouldn't making scsi_remove_device() taking single depth
mutex_lock_nested suffice here?
