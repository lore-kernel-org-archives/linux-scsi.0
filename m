From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: [PATCH 3/3] target: Minor sparse warning fixes and annotations
Date: Mon, 24 Jan 2011 15:25:57 -0800
Message-ID: <1295911557.24778.85.camel@haakon2.linux-iscsi.org>
References: <1295901446-17089-1-git-send-email-nab@linux-iscsi.org>
	 <1295901446-17089-4-git-send-email-nab@linux-iscsi.org>
	 <1295902567.15425.13.camel@mulgrave.site>
	 <1295904802.24778.47.camel@haakon2.linux-iscsi.org>
	 <4D3E08BA.6000105@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.linux-iscsi.org ([67.23.28.174]:44243 "EHLO
	linux-iscsi.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752245Ab1AXX0A (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 24 Jan 2011 18:26:00 -0500
In-Reply-To: <4D3E08BA.6000105@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Joe Eykholt <joe.eykholt@gmail.com>
Cc: linux-iscsi-target-dev@googlegroups.com, James Bottomley <James.Bottomley@HansenPartnership.com>, linux-scsi <linux-scsi@vger.kernel.org>, Fubo Chen <fubo.chen@gmail.com>, Christoph Hellwig <hch@lst.de>

On Mon, 2011-01-24 at 15:18 -0800, Joe Eykholt wrote:
> On 1/24/11 1:33 PM, Nicholas A. Bellinger wrote:
> > On Mon, 2011-01-24 at 14:56 -0600, James Bottomley wrote:
> >> On Mon, 2011-01-24 at 12:37 -0800, Nicholas A. Bellinger wrote:
> >>> -#define TASK_CMD(task) ((struct se_cmd *)task->task_se_cmd)
> >>> -#define TASK_DEV(task) ((struct se_device *)task->se_dev)
> >>> +#define TASK_CMD(task) ((task)->task_se_cmd)
> >>> +#define TASK_DEV(task) ((task)->se_dev)
> Part of the problem with the old code is that task was not parenthesized,
> so if TASK_CMD() were used with an expression, you might not get what
> you want.  If you did TASK_CMD(p + 5), for example, you would get
> 
>      ((struct se_cmd *)p + 5->task_se_cmd)
> 
> Which wouldn't compile, but maybe other examples would compile and
> would cause strange problems.   So, it's a bad macro as it is.
> Just my 2 cents.
> 

Good point here Joe..  AFAIK there are no cases of this in actual usage,
but for good measure all of these within target_core_base.h where
converted to:

 	#define TCM_FOO(p)  ((p)->member)

for:

commit b58b76cd21bf461308e7fba175931f8f8c089bd7
Author: Nicholas Bellinger <nab@linux-iscsi.org>
Date:   Mon Jan 24 14:29:08 2011 -0800

    target: Remove spurious double cast from structure macro accessors


Thanks for your comments!

--nab

