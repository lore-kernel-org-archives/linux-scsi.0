From: Mike Anderson <andmike@us.ibm.com>
Subject: Re: [PATCH / RFC] scsi_error handler update. (1/4)
Date: Tue, 11 Feb 2003 09:22:56 -0800
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030211172256.GC3164@beaverton.ibm.com>
References: <20030211081351.GA1368@beaverton.ibm.com> <3E492992.90502@splentec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <3E492992.90502@splentec.com>
List-Id: linux-scsi@vger.kernel.org
To: Luben Tuikov <luben@splentec.com>
Cc: linux-scsi@vger.kernel.org

Luben Tuikov [luben@splentec.com] wrote:
> Could you call this ``eh_cmd_entry'' or ``eh_entry''*,
> or why don't you use the already provided ``list'' entry.
> 

I could change the name.

I wanted a list just for the error handler I was concerned in the
timeout (cancel cases) that until ownership was reclaimed that I did not
want to risk modification of another scsi_cmnd list_head. We should be
protected by the scsi_done scsi_delete_timer so I could possibly use the
other list head.

> Question: Could you explain when a command becomes a member of
> the eh_cmd_list, and when it ceases to be a member of this list?
> I.e. what is true and false when a command is part and not
> part of this list?  I couldn't quite get it, just looking from the code,
> and probably should've looked ``closer'', but am pressed for time.
> ... I suspect it's something we've discussed here.

A command becomes a member of the eh_cmd_list:
	- If a scsi_cmnd times out.
	- A call to scsi_set_device_offline with scsi_cmnds active.
	- A command completes with DID_TIME_OUT and is not a TUR or
	  Inquiry.
	- A command completes with message byte of != COMMAND_COMPLETE.
	- A few other cases in scsi_decide_disposition. I will document
	  them.

A command is removed from this list when:
	- Legacy request sense is done.
	- Abort was successful.
	- A function in the sequence done by scsi_eh_ready_devs is
	  successful.
-andmike
--
Michael Anderson
andmike@us.ibm.com

