From: Luben Tuikov <luben@splentec.com>
Subject: Re: [PATCH / RFC] scsi_error handler update. (1/4)
Date: Tue, 11 Feb 2003 11:49:22 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <3E492992.90502@splentec.com>
References: <20030211081351.GA1368@beaverton.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org
To: Mike Anderson <andmike@us.ibm.com>
Cc: linux-scsi@vger.kernel.org

Mike Anderson wrote:
> This patch series is against scsi-misc-2.5.
> 
> These patches modify the scsi error handler to process cmds needing
> recovery off a list. The error handler policy has been altered to do the
> following:
> 	1.) Check for legacy behavior of requesting sense.
> 	2.) Abort commands marked needing to be canceled.
> 	3.) Ready devices through tur and eh handlers.
> 	4.) disposition each command on the list to be retried or
> 	finished.
> 
> 00_serror-cmd-list-1.diff:
> 	- Add per host eh_cmd_list list head.
> 	- Add per cmd eh_list list head.

Could you call this ``eh_cmd_entry'' or ``eh_entry''*,
or why don't you use the already provided ``list'' entry.

* The rest of the kernel calls ".*_?entry_?.*" list_heads
which will be used as _part_ of lists and lists themselves
as ".*_?list_?.*". (both regex)

My point here is that ``eh_list'' is symbolically quite similar
to ``eh_cmd_list'', all the while ``eh_list'' is not the ADT* List,
but an entry to/of a list.  Forget about the name of the type, i.e.
that it is struct list_head for both lists and entries of lists --
this is the whole beauty of the linux lists.

* ADT, Abstract Data Type.

The already provided ``list'' in cmd struct entry is so ambiguous
that there's no other way but to conclude that it is the entry to
a list.

In fact this is the whole point when I added it (``list'') -- so
that the cmd struct would be part of a list depending on it's _state_ ,
as I've mentioned before. ((This seems to be forming slowly.))

Question: Could you explain when a command becomes a member of
the eh_cmd_list, and when it ceases to be a member of this list?
I.e. what is true and false when a command is part and not
part of this list?  I couldn't quite get it, just looking from the code,
and probably should've looked ``closer'', but am pressed for time.
... I suspect it's something we've discussed here.

Thanks,
-- 
Luben


