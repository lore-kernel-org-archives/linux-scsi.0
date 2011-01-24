From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: [PATCH] target: Call proc_mkdir + remove_proc_entry with NULL
	parameter
Date: Mon, 24 Jan 2011 12:54:22 -0800
Message-ID: <1295902462.24778.40.camel@haakon2.linux-iscsi.org>
References: <1295738425-4814-1-git-send-email-nab@linux-iscsi.org>
	 <1295791971.3007.0.camel@mulgrave.site>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.linux-iscsi.org ([67.23.28.174]:56636 "EHLO
	linux-iscsi.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752671Ab1AXUy0 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 24 Jan 2011 15:54:26 -0500
In-Reply-To: <1295791971.3007.0.camel@mulgrave.site>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@suse.de>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, Fubo Chen <fubo.chen@gmail.com>, Christoph Hellwig <hch@lst.de>, "J.H." <warthog9@kernel.org>, Joel Becker <jlbec@evilplan.org>

On Sun, 2011-01-23 at 08:12 -0600, James Bottomley wrote:
> On Sat, 2011-01-22 at 15:20 -0800, Nicholas A. Bellinger wrote:
> > From: Nicholas Bellinger <nab@linux-iscsi.org>
> > 
> > This patch makes proc_mkdir() and remove_proc_entry() use a NULL
> > parameter to fix the following sparse warning:
> > 
> > CHECK   drivers/target/target_core_configfs.c
> > drivers/target/target_core_configfs.c:3131:54: warning: Using plain integer as NULL pointer
> > drivers/target/target_core_configfs.c:3145:50: warning: Using plain integer as NULL pointer
> > drivers/target/target_core_configfs.c:3212:42: warning: Using plain integer as NULL pointer
> 
> Um, so I thought this interface was being replaced ... there's not a lot
> of point in sparse fixing it.
> 

Hi James,

So my plan here is to move these statistics in /proc/scsi_target/ into
configfs specific contexts for TCM v4.1.  This also includes moving
iscsi_target_mod -> /proc/iscsi_target/ to use 
/sys/kernel/config/target/iscsi/ context attributes using our existing
CONFIGFS_EATTR() based macros in target_core_fabric_configfs.h
to provide the fabric dependent attributes.

So for target core this should be easy enough to split up short term in
'for-39', but the generic fabric statistics piece will require some new
logic that allows CONFIGFS_EATTR() macros to be seq_list() aware in
order to cat more than PAGE_SIZE for a individual configfs statistic
attribute some (one..?) special case. (jlbec CC'ed)

The reason we need this is to handle the N possible dynamic demo mode
struct se_node_acl (Initiator NodeACL) per TargetName+TargetPortalGroup
endpoint that we need for BKO ops.  (J.H CC'ed)

--nab


