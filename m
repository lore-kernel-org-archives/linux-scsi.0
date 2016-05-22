From: Tom Yan <tom.ty89-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [regression] uas no longer queues commands since v4.5.2
Date: Sun, 22 May 2016 18:40:35 +0800
Message-ID: <CAGnHSEkLKyCPNc8pTGbNXWzTu=Jq=p0Kb78SjauNs5PkFcDdVA@mail.gmail.com>
References: <CAGnHSEnR8n3-zxn767DEQv7eoDbA0cc3d_7xo8OZmO+g4jth+w@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAGnHSEnR8n3-zxn767DEQv7eoDbA0cc3d_7xo8OZmO+g4jth+w-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-usb-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, hdegoede-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org
Cc: linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-scsi@vger.kernel.org

Btw, I suppose `.can_queue = MAX_CMNDS` in the host template is
unnecessary (unless we are going to revert `shost->can_queue =
devinfo->qdepth - 2`)?

On 22 May 2016 at 18:39, Tom Yan <tom.ty89-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
> With commit 198de51dbc3454d95b015ca0a055b673f85f01bb, uas no longer
> set `queue_depth` with scsi_change_queue_depth(), so now `queue_depth`
> of UAS drives are 1. Even though `can_queue` is set to
> `devinfo->qdepth - 2`, but apparently that does not help, since I can
> see performance impact.
>
> Suppose limiting `can_queue` is the right way to fix this bug
> (https://bugzilla.redhat.com/show_bug.cgi?id=1315013), do we really
> need to eliminate scsi_change_queue_depth() at the same time though?
> If so, how should we deal with the regression?
--
To unsubscribe from this list: send the line "unsubscribe linux-usb" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
