From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: [PATCH 1/2] [tgt]: Add proper CDB passthrough for SG_IO
	backstores
Date: Sun, 30 May 2010 19:45:45 -0700
Message-ID: <1275273945.32585.34.camel@haakon2.linux-iscsi.org>
References: <1274159582-6074-1-git-send-email-nab@linux-iscsi.org>
	 <4C023192.9080503@panasas.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp126.sbc.mail.sp1.yahoo.com ([69.147.65.185]:45999 "HELO
	smtp126.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1755395Ab0EaCsS (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sun, 30 May 2010 22:48:18 -0400
In-Reply-To: <4C023192.9080503@panasas.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Boaz Harrosh <bharrosh@panasas.com>
Cc: stgt-devel <stgt@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, Mike Christie <michaelc@cs.wisc.edu>, James Bottomley <James.Bottomley@suse.de>, Douglas Gilbert <dgilbert@interlog.com>, Hannes Reinecke <hare@suse.de>, Gerd Hoffmann <kraxel@redhat.com>, Kevin Wolf <kwolf@redhat.com>

On Sun, 2010-05-30 at 12:36 +0300, Boaz Harrosh wrote:
> On 05/18/2010 08:13 AM, Nicholas A. Bellinger wrote:
> > From: Nicholas Bellinger <nab@linux-iscsi.org>
> > 
> > This patch updates usr/bs_sg.c:bs_sg_cmd_submit() to process incoming scsi-generic IO
> > of type SG_DXFER_TO_DEV and SG_DXFER_FROM_DEV using a single new struct scsi_cmnd->sg_iovec
> > set using existing scsi_cmd.h scsi_get_[out,in]_[buffer,length]() macros.
> > 
> > It also makes set_cmd_failed() properly return SAM_STAT_CHECK_CONDITION, which is expected
> > by the bs_sg_cmd_submit() caller in usr/scsi.c:scsi_cmd_perform()
> > 
> > Finally, this patch adds struct backingstore_template->bs_passthrough=1 that is used by
> > bs_sg.c here and the next patch to hand off struct scsi_cmd for CDB passthrough.
> > 
> > Signed-off-by: Nicholas A. Bellinger <nab@linux-iscsi.org>
> > ---
> >  usr/bs_sg.c     |   31 ++++++++++++++++++++++++-------
> 
> Why not add a new bs_bsg.c backing store that goes through BSG and not SG
> and do it properly for all type of targets and commands?
> 
> Just a thought.

Greetings Boaz,

I completely agree with you here and think that BSG is the next logical
direction for expanding our target capabilities and for adding some
manner of I_T nexus auto-configuration between STGT userspace fabric
modules <-> TCM_Loop multi-fabric target port LUNs.  That said, I will
start groking BSG and look at adding a new bs_bsg backstore for STGT
soon for extended user -> kernel passthrough ops soon.

Also, the BSG direction is going to make alot of sense with the QEMU-KVM
HBA Emulation <-> TCM_Loop efforts too.   However I believe at least for
megraid_sas that TMRs are handled in the driver for LDs and not
processed directly by the 8708EM2 PowerPC Core firmware. ;)

Best,

--nab


