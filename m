From: Mike Anderson <andmike@us.ibm.com>
Subject: Re: 2.6.16-rc1 crash in scsi_target_reap_work
Date: Wed, 22 Feb 2006 08:47:50 -0800
Message-ID: <20060222164750.GA433@us.ibm.com>
References: <20060209200529.GA8968@suse.de> <20060210101124.GA6253@suse.de> <1139580295.3084.3.camel@mulgrave.il.steeleye.com> <20060210141012.GA12147@suse.de> <20060210230140.GA26423@suse.de> <43ED1FE0.1000805@us.ibm.com> <20060210232935.GA27760@suse.de> <43FA49F9.4020309@us.ibm.com> <20060222083657.GA24802@suse.de> <43FC774B.8050301@us.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e36.co.us.ibm.com ([32.97.110.154]:18647 "EHLO
	e36.co.us.ibm.com") by vger.kernel.org with ESMTP id S1030304AbWBVQwy
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 22 Feb 2006 11:52:54 -0500
Received: from d03relay04.boulder.ibm.com (d03relay04.boulder.ibm.com [9.17.195.106])
	by e36.co.us.ibm.com (8.12.11/8.12.11) with ESMTP id k1MGqnxG019078
	for <linux-scsi@vger.kernel.org>; Wed, 22 Feb 2006 11:52:49 -0500
Received: from d03av01.boulder.ibm.com (d03av01.boulder.ibm.com [9.17.195.167])
	by d03relay04.boulder.ibm.com (8.12.10/NCO/VERS6.8) with ESMTP id k1MGtR4R181720
	for <linux-scsi@vger.kernel.org>; Wed, 22 Feb 2006 09:55:27 -0700
Received: from d03av01.boulder.ibm.com (loopback [127.0.0.1])
	by d03av01.boulder.ibm.com (8.12.11/8.13.3) with ESMTP id k1MGqmDD031952
	for <linux-scsi@vger.kernel.org>; Wed, 22 Feb 2006 09:52:48 -0700
Content-Disposition: inline
In-Reply-To: <43FC774B.8050301@us.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Brian King <brking@us.ibm.com>
Cc: Olaf Hering <olh@suse.de>, James Bottomley <James.Bottomley@SteelEye.com>, linux-scsi@vger.kernel.org

Brian King <brking@us.ibm.com> wrote:
> I would guess that the -EEXIST is coming from:
> 
> create_dir
> sysfs_create_dir
> create_dir
> kobject_add
> device_add
> 
> Looking at the scsi_target reap code, it looks like there is a race condition. The
> target is removed from the hosts list of targets under the host lock, then the host
> lock is released. If another thread tries to add the same target that is being
> tore down at this point (before device_del), the device_add will fail with EEXIST
> since the sysfs directory for the device still exists.
> 
> Any reason we can't protect the target reaping code from this by grabbing the 
> scan_mutex?


Another manifestation is a bug I was recently looking at where a BUG_ON is
triggered in the aic7xxx driver if someone is removing and adding devices
repeatably.

"Feb  8 14:21:52 test klogd: kernel BUG at
drivers/scsi/aic7xxx/aic7xxx_osm.c:535!"

The scan mutex I believe would not help in the case I describe above as
the issue in this instance is the widow between the call of
"list_del_init(&starget->siblings);" and the call to target_destroy.

-andmike
--
Michael Anderson
andmike@us.ibm.com
