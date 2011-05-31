From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: [PATCH 39/42] target: Call transport_new_cmd instead of adding
	to cmd queue
Date: Tue, 31 May 2011 04:22:03 -0700
Message-ID: <1306840923.8193.211.camel@haakon2.linux-iscsi.org>
References: <1306523240-15543-1-git-send-email-agrover@redhat.com>
	 <1306523240-15543-40-git-send-email-agrover@redhat.com>
	 <1306834367.8193.169.camel@haakon2.linux-iscsi.org>
	 <20110531094800.GA31240@lst.de>
	 <1306836641.8193.185.camel@haakon2.linux-iscsi.org>
	 <20110531102200.GA31697@lst.de>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.linux-iscsi.org ([67.23.28.174]:34916 "EHLO
	linux-iscsi.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752571Ab1EaLa0 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 31 May 2011 07:30:26 -0400
In-Reply-To: <20110531102200.GA31697@lst.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: linux-iscsi-target-dev@googlegroups.com, target-devel <target-devel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>

On Tue, 2011-05-31 at 12:22 +0200, Christoph Hellwig wrote:
> > +++ b/drivers/target/iscsi/iscsi_target.c
> > @@ -1118,7 +1118,7 @@ attach_cmd:
> >          * the underlying transport plugin has allocated the buffer to
> >          * receive the Immediate Write Data into.
> >          */
> > -       transport_generic_handle_cdb(SE_CMD(cmd));
> > +       transport_generic_new_cmd(SE_CMD(cmd));
> 
> This is still missing the error handling, as well as the other callers
> in the iscsi code.  When adding the proper error handling please do it
> by checking the transport_generic_new_cmd return value instead of
> through transport_new_cmd_failure.  With a bit more work this should
> also allow killing off the SCF_SE_CMD_FAILED flag.
> 

<nod>.

I will have a look getting this addressed later today as well and send
out a follow-up patch on top of what has been pushed so far of Andy's
patches into lio-core-2.6.git.

Thanks,

--nab


