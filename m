From: Vasu Dev <vasu.dev-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Subject: Re: [PATCH -resend 1/1] fcoe: use continue instead of
	goto+label
Date: Tue, 06 Oct 2015 15:34:07 -0700
Message-ID: <1444170847.5825.8.camel@lin-nd1-054.jf.intel.com>
References: <1444134465-3693-1-git-send-email-jslaby@suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <fcoe-devel-bounces-s9riP+hp16TNLxjTenLetw@public.gmane.org>
In-Reply-To: <1444134465-3693-1-git-send-email-jslaby-AlSwsSmVLrQ@public.gmane.org>
List-Unsubscribe: <http://lists.open-fcoe.org/mailman/options/fcoe-devel>,
 <mailto:fcoe-devel-request-s9riP+hp16TNLxjTenLetw@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.open-fcoe.org/pipermail/fcoe-devel/>
List-Post: <mailto:fcoe-devel-s9riP+hp16TNLxjTenLetw@public.gmane.org>
List-Help: <mailto:fcoe-devel-request-s9riP+hp16TNLxjTenLetw@public.gmane.org?subject=help>
List-Subscribe: <http://lists.open-fcoe.org/mailman/listinfo/fcoe-devel>,
 <mailto:fcoe-devel-request-s9riP+hp16TNLxjTenLetw@public.gmane.org?subject=subscribe>
Errors-To: fcoe-devel-bounces-s9riP+hp16TNLxjTenLetw@public.gmane.org
Sender: "fcoe-devel" <fcoe-devel-bounces-s9riP+hp16TNLxjTenLetw@public.gmane.org>
To: Jiri Slaby <jslaby-AlSwsSmVLrQ@public.gmane.org>
Cc: linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, JBottomley-O3H1v1f1dlM@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kxie-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org, fcoe-devel-s9riP+hp16TNLxjTenLetw@public.gmane.org, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org
List-Id: linux-scsi@vger.kernel.org

On Tue, 2015-10-06 at 14:27 +0200, Jiri Slaby wrote:
> There is a label pointing to the start of a while loop and a goto
> nested only in the loop. The goto jumps to the label in some cases.
> Replace the goto and the label by simple continue.
> 
> Signed-off-by: Jiri Slaby <jslaby-AlSwsSmVLrQ@public.gmane.org>
> Cc: Robert Love <robert.w.love-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> Cc: fcoe-devel-s9riP+hp16TNLxjTenLetw@public.gmane.org
> ---
> Sent on:
> May 5
> 
>  drivers/scsi/fcoe/fcoe.c | 3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)
> 
> diff --git a/drivers/scsi/fcoe/fcoe.c b/drivers/scsi/fcoe/fcoe.c
> index d3eb80c46bbe..d187ba9b361d 100644
> --- a/drivers/scsi/fcoe/fcoe.c
> +++ b/drivers/scsi/fcoe/fcoe.c
> @@ -1873,7 +1873,6 @@ static int fcoe_percpu_receive_thread(void *arg)
>  
>  	set_user_nice(current, MIN_NICE);
>  
> -retry:
>  	while (!kthread_should_stop()) {
>  
>  		spin_lock_bh(&p->fcoe_rx_list.lock);
> @@ -1883,7 +1882,7 @@ retry:
>  			set_current_state(TASK_INTERRUPTIBLE);
>  			spin_unlock_bh(&p->fcoe_rx_list.lock);
>  			schedule();
> -			goto retry;
> +			continue;
>  		}
>  
>  		spin_unlock_bh(&p->fcoe_rx_list.lock);

Acked-by: Vasu Dev <vasu.dev-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
