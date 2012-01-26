From: Mike Christie <michaelc-hcNo3dDEHLuVc3sceRu5cw@public.gmane.org>
Subject: Re: [PATCH] iscsi: don't hang in endless loop if no targets present
Date: Wed, 25 Jan 2012 23:31:34 -0600
Message-ID: <4F20E536.7090808@cs.wisc.edu>
References: <1327547776-2890-1-git-send-email-levinsasha928@gmail.com>
Reply-To: open-iscsi-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <open-iscsi+bncCLPJla3WGRDByoP5BBoEpbcWhw-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
In-Reply-To: <1327547776-2890-1-git-send-email-levinsasha928-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
List-Post: <http://groups.google.com/group/open-iscsi/post?hl=en_US>, <mailto:open-iscsi-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
List-Help: <http://groups.google.com/support/?hl=en_US>, <mailto:open-iscsi+help-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
List-Archive: <http://groups.google.com/group/open-iscsi?hl=en_US>
Sender: open-iscsi-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org
List-Subscribe: <http://groups.google.com/group/open-iscsi/subscribe?hl=en_US>,
 <mailto:open-iscsi+subscribe-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
List-Unsubscribe: <http://groups.google.com/group/open-iscsi/subscribe?hl=en_US>,
 <mailto:googlegroups-manage+856124926423+unsubscribe-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
To: Sasha Levin <levinsasha928-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: JBottomley-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org, open-iscsi-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org, linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-scsi@vger.kernel.org

On 01/25/2012 09:16 PM, Sasha Levin wrote:
> iscsi_if_send_reply() may return -ESRCH if there were no targets to send
> data to. Currently we're ignoring this value and looping in attempt to do it
> over and over, which will usually lead in a hung task like this one:
> 
> [ 4920.817298] INFO: task trinity:9074 blocked for more than 120 seconds.
> [ 4920.818527] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
> [ 4920.819982] trinity         D 0000000000000000  5504  9074   2756 0x00000004
> [ 4920.825374]  ffff880003961a98 0000000000000086 ffff8800001aa000 ffff8800001aa000
> [ 4920.826791]  00000000001d4340 ffff880003961fd8 ffff880003960000 00000000001d4340
> [ 4920.828241]  00000000001d4340 00000000001d4340 ffff880003961fd8 00000000001d4340
> [ 4920.833231]
> [ 4920.833519] Call Trace:
> [ 4920.834010]  [<ffffffff826363fa>] schedule+0x3a/0x50
> [ 4920.834953]  [<ffffffff82634ac9>] __mutex_lock_common+0x209/0x5b0
> [ 4920.836226]  [<ffffffff81af805d>] ? iscsi_if_rx+0x2d/0x990
> [ 4920.837281]  [<ffffffff81053943>] ? sched_clock+0x13/0x20
> [ 4920.838305]  [<ffffffff81af805d>] ? iscsi_if_rx+0x2d/0x990
> [ 4920.839336]  [<ffffffff82634eb0>] mutex_lock_nested+0x40/0x50
> [ 4920.840423]  [<ffffffff81af805d>] iscsi_if_rx+0x2d/0x990
> [ 4920.841434]  [<ffffffff810dffed>] ? sub_preempt_count+0x9d/0xd0
> [ 4920.842548]  [<ffffffff82637bb0>] ? _raw_read_unlock+0x30/0x60
> [ 4920.843666]  [<ffffffff821f71de>] netlink_unicast+0x1ae/0x1f0
> [ 4920.844751]  [<ffffffff821f7997>] netlink_sendmsg+0x227/0x350
> [ 4920.845850]  [<ffffffff821857bd>] ? sock_update_netprioidx+0xdd/0x1b0
> [ 4920.847060]  [<ffffffff82185732>] ? sock_update_netprioidx+0x52/0x1b0
> [ 4920.848276]  [<ffffffff8217f226>] sock_aio_write+0x166/0x180
> [ 4920.849348]  [<ffffffff810dfe41>] ? get_parent_ip+0x11/0x50
> [ 4920.850428]  [<ffffffff811d0d9a>] do_sync_write+0xda/0x120
> [ 4920.851465]  [<ffffffff810dffed>] ? sub_preempt_count+0x9d/0xd0
> [ 4920.852579]  [<ffffffff810dfe41>] ? get_parent_ip+0x11/0x50
> [ 4920.853608]  [<ffffffff81791887>] ? security_file_permission+0x27/0xb0
> [ 4920.854821]  [<ffffffff811d0f4c>] vfs_write+0x16c/0x180
> [ 4920.855781]  [<ffffffff811d104f>] sys_write+0x4f/0xa0
> [ 4920.856798]  [<ffffffff82638e79>] system_call_fastpath+0x16/0x1b
> [ 4920.877487] 1 lock held by trinity/9074:
> [ 4920.878239]  #0:  (rx_queue_mutex){+.+...}, at: [<ffffffff81af805d>] iscsi_if_rx+0x2d/0x990
> [ 4920.880005] Kernel panic - not syncing: hung_task: blocked tasks
> 
> Signed-off-by: Sasha Levin <levinsasha928-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
> ---
>  drivers/scsi/scsi_transport_iscsi.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/scsi/scsi_transport_iscsi.c b/drivers/scsi/scsi_transport_iscsi.c
> index cfd4914..c26707a 100644
> --- a/drivers/scsi/scsi_transport_iscsi.c
> +++ b/drivers/scsi/scsi_transport_iscsi.c
> @@ -2110,7 +2110,7 @@ iscsi_if_rx(struct sk_buff *skb)
>  				break;
>  			err = iscsi_if_send_reply(group, nlh->nlmsg_seq,
>  				nlh->nlmsg_type, 0, 0, ev, sizeof(*ev));
> -		} while (err < 0 && err != -ECONNREFUSED);
> +		} while (err < 0 && err != -ECONNREFUSED && err != -ESRCH);
>  		skb_pull(skb, rlen);
>  	}
>  	mutex_unlock(&rx_queue_mutex);


Looks ok. Thanks for debugging and the patch.

Acked-by: Mike Christie <michaelc-hcNo3dDEHLuVc3sceRu5cw@public.gmane.org>

-- 
You received this message because you are subscribed to the Google Groups "open-iscsi" group.
To post to this group, send email to open-iscsi-/JYPxA39Uh5TLH3MbocFF+G/Ez6ZCGd0@public.gmane.org
To unsubscribe from this group, send email to open-iscsi+unsubscribe-/JYPxA39Uh5TLH3MbocFF+G/Ez6ZCGd0@public.gmane.org
For more options, visit this group at http://groups.google.com/group/open-iscsi?hl=en.
