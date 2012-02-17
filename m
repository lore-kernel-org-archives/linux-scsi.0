From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: [PATCH 0/4] target/tcm_qla2xxx: Add TMR_ABORT_TASK support
Date: Fri, 17 Feb 2012 00:13:24 -0800
Message-ID: <1329466404.5093.412.camel@haakon2.linux-iscsi.org>
References: <1329133347-13359-1-git-send-email-nab@linux-iscsi.org>
	 <4F3DAEDB.1070904@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.linux-iscsi.org ([67.23.28.174]:58349 "EHLO
	linux-iscsi.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751805Ab2BQIN1 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 17 Feb 2012 03:13:27 -0500
In-Reply-To: <4F3DAEDB.1070904@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andy Grover <agrover@redhat.com>
Cc: target-devel <target-devel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, Andrew Vasquez <andrew.vasquez@qlogic.com>, Giridhar Malavali <giridhar.malavali@qlogic.com>, Arun Easi <arun.easi@qlogic.com>, Christoph Hellwig <hch@lst.de>, Roland Dreier <roland@purestorage.com>, Madhuranath Iyengar <mni@risingtidesystems.com>

On Thu, 2012-02-16 at 17:35 -0800, Andy Grover wrote:
> On 02/13/2012 03:42 AM, Nicholas A. Bellinger wrote:
> > The following series adds explict TMR_ABORT_TASK support using session
> > command list descriptors for target_submit_cmd() fabric module users.
> 
> <snip>
> 
> > The code can use some more testing and review, but so far these changes
> > with simulated I/O delays are generating SAM_STAT_TASK_ABORTED status for
> > the aborted tag, or failing with TMR_TASK_DOES_NOT_EXIST as expected..
> > 
> > Please have a look,
> 
> Reviewed, looks good.
> 
> Do you have plans to implement ABORT_TASK_SET as well?
> 

Hi Andy,

At some point, I'd like to add generic support for ABORT_TASK_SET into
target-core.

The conversion of iscsi-target to use per session cmd list probably
needs to happen so that ABORT_TASK + ABORT_TASK_SET can be properly
supported there first.

Also, I'm not currently aware of a method to generate ABORT_TASK_SET for
testing using simulated failures with qla2xxx (other than an FC
jammer..?), and current libiscsi clients do not generate ABORT_TASK_SET.

I imagine it would be easier to test ABORT_TASK_SET if libscsi could
generate this TMR for testing purposes (via SG ioctl perhaps..?) 

--nab



