From: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
Subject: Re: [RFC 4/8] IB/srp: don't move active requests to their own list
Date: Mon, 27 Dec 2010 16:50:48 +0100
Message-ID: <AANLkTinuOD919iV+ixcWhZpSkJP1QP=+OyphzVSq4_aO@mail.gmail.com>
References: <1293139893-11678-1-git-send-email-dillowda@ornl.gov> <1293139893-11678-5-git-send-email-dillowda@ornl.gov>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1293139893-11678-5-git-send-email-dillowda-1Heg1YXhbW8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: David Dillow <dillowda-1Heg1YXhbW8@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-scsi@vger.kernel.org

On Thu, Dec 23, 2010 at 10:31 PM, David Dillow <dillowda-1Heg1YXhbW8@public.gmane.org> wrote:
> We use req->scmnd != NULL to indicate an active request, so there's no
> need to keep a separate list for them. We can afford the array iteration
> during error handling, and dropping it gives us one less item that needs
> lock protection.
> [ ... ]

Before this patch a request was either on the free_reqs list or on the
req_queue list. After this patch has been applied a request is either
on the free_reqs list or not on any list. So it doesn't make sense
anymore to invoke list_move_tail() from srp_remove_req() - that
function should be modified such that it invokes list_add_tail(). And
once that is done the list_del_init() call added by this patch can be
replaced by a list_del() call.

Bart.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
