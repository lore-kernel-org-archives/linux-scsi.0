From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: [PATCH 14/24] target: Call proc_mkdir + remove_proc_entry with
	NULL parameter
Date: Sat, 29 Jan 2011 12:43:12 -0800
Message-ID: <1296333792.14831.196.camel@haakon2.linux-iscsi.org>
References: <1296326184-16664-1-git-send-email-nab@linux-iscsi.org>
	 <1296326184-16664-15-git-send-email-nab@linux-iscsi.org>
	 <1296332300.3020.42.camel@mulgrave.site>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.linux-iscsi.org ([67.23.28.174]:36038 "EHLO
	linux-iscsi.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750968Ab1A2UnR (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 29 Jan 2011 15:43:17 -0500
In-Reply-To: <1296332300.3020.42.camel@mulgrave.site>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: linux-scsi <linux-scsi@vger.kernel.org>

On Sat, 2011-01-29 at 12:18 -0800, James Bottomley wrote:
> On Sat, 2011-01-29 at 10:36 -0800, Nicholas A. Bellinger wrote:
> > From: Nicholas Bellinger <nab@linux-iscsi.org>
> > 
> > This patch makes proc_mkdir() and remove_proc_entry() use a NULL
> > parameter to fix the following sparse warning:
> > 
> > CHECK   drivers/target/target_core_configfs.c
> > drivers/target/target_core_configfs.c:3131:54: warning: Using plain integer as NULL pointer
> > drivers/target/target_core_configfs.c:3145:50: warning: Using plain integer as NULL pointer
> > drivers/target/target_core_configfs.c:3212:42: warning: Using plain integer as NULL pointer
> > 
> > Reported-by: Fubo Chen <fubo.chen@gmail.com>
> > Signed-off-by: Nicholas A. Bellinger <nab@linux-iscsi.org>
> > (cherry picked from commit d83fca37fa4a6c2bcb2806800f221528a76fc080)
> 
> Firstly, don't use git-cherry-pick -x ... it adds spurious information
> like this that I have to edit out manually.
> 

Er sorry, these should have been stripped out before sending.  I will
make sure these are removed for next series.

> Secondly, if, as you said, you're transitioning to debugfs based
> interfaces, don't do this, just strip the /proc based interface from
> mainline.
> 

Well, I would like them to eventually go into individual
target_core_configfs.c and target_core_fabric_configfs.c context
specific attributes, but we need to address the PAGE_SIZE limitiation in
configfs/sysfs attribute output before this can be done.  This was
briefly discussed here:

http://marc.info/?l=linux-scsi&m=129590246906137&w=2

In the mean time having proper SCSI MIB read-only statistics is still
very important for-38, so please consider this minor patch.

Thanks,

--nab

