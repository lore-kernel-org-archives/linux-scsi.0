From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: Re: [PATCH 1/2] [tgt]: Add proper STGT LUN backstore passthrough
 support
Date: Fri, 4 Jun 2010 17:39:19 +0900
Message-ID: <20100604173848Q.fujita.tomonori@lab.ntt.co.jp>
References: <1275382245-17668-1-git-send-email-nab@linux-iscsi.org>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sh.osrg.net ([192.16.179.4]:38871 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754431Ab0FDIjr (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 4 Jun 2010 04:39:47 -0400
In-Reply-To: <1275382245-17668-1-git-send-email-nab@linux-iscsi.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: nab@linux-iscsi.org
Cc: stgt@vger.kernel.org, linux-scsi@vger.kernel.org, fujita.tomonori@lab.ntt.co.jp, michaelc@cs.wisc.edu, bharrosh@panasas.com, James.Bottomley@suse.de, dgilbert@interlog.com

On Tue,  1 Jun 2010 01:50:45 -0700
"Nicholas A. Bellinger" <nab@linux-iscsi.org> wrote:

> This patch adds two new queueing and completion function pointers to
> struct scsi_lu called ->cmd_perform() and ->cmd_done() for handling
> existing internal STGT port emulation and the struct scsi_cmd

Using new function pointers look fine. However, have you tried the
existing non passthrough code? This patch seems to break it. I've not
looked at the details though.

I don't think you need to touch to sbc.c. we should not need to know
the type of underlying devices with passthough. Can you add a new
device type such as struct device_type_template sg_template?

__cmd_done_passthrough() doesn't need to call post_cmd_done(), I
think because post_cmd_done() checks the pending commands. With
passthrough, there is no pending commands.


Thanks,
