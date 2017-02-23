From: "Martin K. Petersen" <martin.petersen-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] libiscsi: add lock around task lists to fix list corruption regression
Date: Thu, 23 Feb 2017 17:11:58 -0500
Message-ID: <yq1fuj45zgx.fsf@oracle.com>
References: <20170221173536.32024-1-cleech@redhat.com>
Reply-To: open-iscsi-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <open-iscsi+bncBDVIJONZ3YDRBNF4XXCQKGQEMCVCUBY-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
Sender: open-iscsi-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org
In-Reply-To: <20170221173536.32024-1-cleech-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> (Chris Leech's message
	of "Tue, 21 Feb 2017 09:35:36 -0800")
List-Post: <https://groups.google.com/group/open-iscsi/post>, <mailto:open-iscsi-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
List-Help: <https://groups.google.com/support/>, <mailto:open-iscsi+help-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
List-Archive: <https://groups.google.com/group/open-iscsi
List-Subscribe: <https://groups.google.com/group/open-iscsi/subscribe>, <mailto:open-iscsi+subscribe-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
List-Unsubscribe: <mailto:googlegroups-manage+856124926423+unsubscribe-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>,
 <https://groups.google.com/group/open-iscsi/subscribe>
To: Chris Leech <cleech-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, open-iscsi-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org, lduncan-IBi9RG/b67k@public.gmane.org, martin.petersen-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org, jejb-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org
List-Id: linux-scsi@vger.kernel.org

>>>>> "Chris" == Chris Leech <cleech-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> writes:

Chris> There's a rather long standing regression from commit 659743b
Chris> [SCSI] libiscsi: Reduce locking contention in fast path

Chris> Depending on iSCSI target behavior, it's possible to hit the case
Chris> in iscsi_complete_task where the task is still on a pending list
Chris> (!list_empty(&task->running)).  When that happens the task is
Chris> removed from the list while holding the session back_lock, but
Chris> other task list modification occur under the frwd_lock.  That
Chris> leads to linked list corruption and eventually a panicked system.

Chris> Rather than back out the session lock split entirely, in order to
Chris> try and keep some of the performance gains this patch adds
Chris> another lock to maintain the task lists integrity.

Chris> Major enterprise supported kernels have been backing out the lock
Chris> split for while now, thanks to the efforts at IBM where a lab
Chris> setup has the most reliable reproducer I've seen on this issue.
Chris> This patch has been tested there successfully.

Reviews, please!

-- 
Martin K. Petersen	Oracle Linux Engineering

-- 
You received this message because you are subscribed to the Google Groups "open-iscsi" group.
To unsubscribe from this group and stop receiving emails from it, send an email to open-iscsi+unsubscribe-/JYPxA39Uh5TLH3MbocFF+G/Ez6ZCGd0@public.gmane.org
To post to this group, send email to open-iscsi-/JYPxA39Uh5TLH3MbocFF+G/Ez6ZCGd0@public.gmane.org
Visit this group at https://groups.google.com/group/open-iscsi.
For more options, visit https://groups.google.com/d/optout.
