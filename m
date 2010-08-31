From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: libfc_lport.c:fc_lport_recv_req() dropping struct fc_seq parameter
	for v2.6.36-rc3..?
Date: Tue, 31 Aug 2010 13:14:23 -0700
Message-ID: <1283285663.32007.476.camel@haakon2.linux-iscsi.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp101.sbc.mail.gq1.yahoo.com ([67.195.15.60]:25604 "HELO
	smtp101.sbc.mail.gq1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753740Ab0HaUSL (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 31 Aug 2010 16:18:11 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Joe Eykholt <jeykholt@cisco.com>, "Love, Robert W" <robert.w.love@intel.com>
Cc: openfcoe-devel <devel@open-fcoe.org>, linux-scsi <linux-scsi@vger.kernel.org>

Hi Joe and Robert,

So after jumping to v2.6.36-rc3 for the lio-core-2.6.git/lio-4.0 branch
recently and fixing some minor breakage around the original struct
fc4_prov patches I merged from Joe in the spring, mostly having to do
with drivers/scsi/libfc/libfc_lport.c:fc_lport_recv_req() changes from
this commit:

[SCSI] libfc: don't require a local exchange for incomining requests
http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commitdiff;h=922611569572d3c1aa0ed6491d21583fb3fcca22

I was able to get libfc + struct fc4_prov compiling after fixing the
conflicts.  However, I have run into non-trivial breakage in the
Open-FCoE.org / TCM_FC fabric module itself because of it's dependence
bit upon having direct access to the passed struct fc_seq.   The code
currently assigns to struct fc_seq * to struct ft_cmd->seq, and gets
used in a number of subsequent areas after the struct fc4_prov->recv()
entry hook at drivers/target/tcm_fc/tfc_cmd.c:ft_recv_cmd() gets called.

I took a very brief look at trying to resolve the breakage myself, but
quickly got a bit lost in terms of what TCM_FC actually needs to be
accessing struct fc_seq directly for.  Would either of you gentlemen
mind giving me a bit of insight into what you think would be required by
TCM_FC in order to function with the recent libfc fc_lport_recv_req()
changes..?

Thanks!

--nab

