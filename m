From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: [PATCH 2/2] target_core_spc: bounds check for
 spc_emulate_inquiry()
Date: Sat, 21 Dec 2013 18:53:33 -0800
Message-ID: <1387680813.5567.88.camel@haakon3.risingtidesystems.com>
References: <1387460172-27396-1-git-send-email-hare@suse.de>
	 <1387460172-27396-3-git-send-email-hare@suse.de>
	 <1387491087.5567.62.camel@haakon3.risingtidesystems.com>
	 <52B3E7FD.9030504@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.linux-iscsi.org ([67.23.28.174]:60968 "EHLO
	linux-iscsi.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751122Ab3LVCwa (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 21 Dec 2013 21:52:30 -0500
In-Reply-To: <52B3E7FD.9030504@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: Nic Bellinger <nab@daterainc.com>, target-devel@vger.kernel.org, linux-scsi@vger.kernel.org

On Fri, 2013-12-20 at 07:47 +0100, Hannes Reinecke wrote:
> On 12/19/2013 11:11 PM, Nicholas A. Bellinger wrote:
> > On Thu, 2013-12-19 at 14:36 +0100, Hannes Reinecke wrote:
> >> Instead of using a static buffer for inquiry data we should
> >> rather use the command-provided buffer and implement proper
> >> bounds checking when writing to it.
> >> Inquiry is by no means time-critical ...
> >>
> >> Signed-off-by: Hannes Reinecke <hare@suse.de>
> >> ---
> >>  drivers/target/target_core_spc.c     | 391 +++++++++++++++++++++--------------
> >>  include/target/target_core_backend.h |   2 +-
> >>  2 files changed, 235 insertions(+), 158 deletions(-)
> >>
> > 
> > Mmmmm, so this used to be the case once upon a time, and was changed to
> > the current local buffer copy + possible truncate for simplicities sake.
> > 
> > I still favor the copy to an oversized local buffer vs. adding explicit
> > size checks to every possible assignment..
> > 
> > How about changing the local buffer to heap memory instead, and bumping
> > SE_INQUIRY_BUF to 1024 bytes..?
> > 
> Ok. But then we should have a quick check at the start
> 
> if (cmd->data_length > SE_INQUIRY_BUF)
>   len = cmd->data_length
> else
>   len = SE_INQUIRY_BUF
> 
> to catch oversized requests.
> 

I don't think this is necessary, as the min_t() for the memcpy() length
at the bottom of spc_emulate_inquiry() takes the lower of the two, and
the rbuf is already being zero-filled.

--nab

