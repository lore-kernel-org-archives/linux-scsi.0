From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH] target: fix crash in cmd tracing when cmd didn't match
	a LUN
Date: Fri, 24 Jul 2015 12:52:06 +0200
Message-ID: <20150724105206.GA25162@lst.de>
References: <1437689973-22991-1-git-send-email-sbaugh@catern.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <target-devel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1437689973-22991-1-git-send-email-sbaugh@catern.com>
Sender: target-devel-owner@vger.kernel.org
To: Spencer Baugh <sbaugh@catern.com>
Cc: "Nicholas A. Bellinger" <nab@linux-iscsi.org>, Sagi Grimberg <sagig@mellanox.com>, Christoph Hellwig <hch@lst.de>, Bart Van Assche <bart.vanassche@sandisk.com>, Alexei Potashnik <alexei@purestorage.com>, Andy Grover <agrover@redhat.com>, Christophe Vu-Brugier <cvubrugier@fastmail.fm>, Roland Dreier <roland@purestorage.com>, "open list:TARGET SUBSYSTEM" <linux-scsi@vger.kernel.org>, "open list:TARGET SUBSYSTEM" <target-devel@vger.kernel.org>, open list <linux-kernel@vger.kernel.org>, Joern Engel <joern@purestorage.com>, Spencer Baugh <Spencer.baugh@purestorage.com>
List-Id: linux-scsi@vger.kernel.org

On Thu, Jul 23, 2015 at 03:19:32PM -0700, Spencer Baugh wrote:
> From: Alexei Potashnik <alexei@purestorage.com>
> 
> If command didn't match a LUN and we're sending check condition, the
> target_cmd_complete ftrace point will crash because it assumes that
> cmd->t_task_cdb has been set.
> 
> The fix will temporarily set t_task_cdb to the se_cmd buffer
> and copy first 6 bytes of cdb in there as soon as possible.
> At a later point t_task_cdb is reset to the correct buffer,
> but until then traces and printks don't cause a crash.

This is too ugly to live.  Just dropping the t_task_cdb dereference
from the trace point sounds like the simples quick fix for now,
and removing the crazy layering violation in iSCSI that opencode
target_submit_cmd is the proper long term fix.
