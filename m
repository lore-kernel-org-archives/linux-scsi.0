From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: 2.6.16-rc1 crash in scsi_target_reap_work
Date: Wed, 22 Feb 2006 11:05:44 -0600
Message-ID: <1140627944.3227.20.camel@mulgrave.il.steeleye.com>
References: <20060209200529.GA8968@suse.de> <20060210101124.GA6253@suse.de>
	 <1139580295.3084.3.camel@mulgrave.il.steeleye.com>
	 <20060210141012.GA12147@suse.de> <20060210230140.GA26423@suse.de>
	 <43ED1FE0.1000805@us.ibm.com> <20060210232935.GA27760@suse.de>
	 <43FA49F9.4020309@us.ibm.com> <20060222083657.GA24802@suse.de>
	 <43FC774B.8050301@us.ibm.com>  <20060222164750.GA433@us.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat9.steeleye.com ([209.192.50.41]:3222 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S1750804AbWBVRGC (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 22 Feb 2006 12:06:02 -0500
In-Reply-To: <20060222164750.GA433@us.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mike Anderson <andmike@us.ibm.com>
Cc: Brian King <brking@us.ibm.com>, Olaf Hering <olh@suse.de>, linux-scsi@vger.kernel.org

On Wed, 2006-02-22 at 08:47 -0800, Mike Anderson wrote:
> Another manifestation is a bug I was recently looking at where a BUG_ON is
> triggered in the aic7xxx driver if someone is removing and adding devices
> repeatably.
> 
> "Feb  8 14:21:52 test klogd: kernel BUG at
> drivers/scsi/aic7xxx/aic7xxx_osm.c:535!"
> 
> The scan mutex I believe would not help in the case I describe above as
> the issue in this instance is the widow between the call of
> "list_del_init(&starget->siblings);" and the call to target_destroy.

Right, I have a fix for this which also gets around the
execute_in_process_context() multiple times problem too ... I just need
to find time to clean it up and post it.

James



