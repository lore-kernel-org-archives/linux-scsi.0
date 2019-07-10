From: Lee Duncan <LDuncan-IBi9RG/b67k@public.gmane.org>
Subject: Re: [PATCH] Check sk before sendpage
Date: Wed, 10 Jul 2019 17:47:31 +0000
Message-ID: <1bc364ff-5bff-47ac-611a-f75c43f4bd1b@suse.com>
References: <1562743809-31133-1-git-send-email-yang.bin18@zte.com.cn>
Reply-To: open-iscsi-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <open-iscsi+bncBD54HHNYIIILNT4Y5ECRUBBS4XV2M-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
Sender: open-iscsi-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org
In-Reply-To: <1562743809-31133-1-git-send-email-yang.bin18-Th6q7B73Y6EnDS1+zs4M5A@public.gmane.org>
Content-Language: en-US
Content-ID: <F3B3AF6B642FCC40B3B4B1F936A8554A-WIijndS0fTycE4WynfumptQqCkab/8FMAL8bYrjMMd8@public.gmane.org>
List-Post: <https://groups.google.com/group/open-iscsi/post>, <mailto:open-iscsi-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
List-Help: <https://groups.google.com/support/>, <mailto:open-iscsi+help-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
List-Archive: <https://groups.google.com/group/open-iscsi
List-Subscribe: <https://groups.google.com/group/open-iscsi/subscribe>, <mailto:open-iscsi+subscribe-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
List-Unsubscribe: <mailto:googlegroups-manage+856124926423+unsubscribe-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>,
 <https://groups.google.com/group/open-iscsi/subscribe>
To: Yang Bin <yang.bin18-Th6q7B73Y6EnDS1+zs4M5A@public.gmane.org>
Cc: "open-iscsi-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org" <open-iscsi-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>, "jejb-tEXmvtCZX7AybS5Ee8rs3A@public.gmane.org" <jejb-tEXmvtCZX7AybS5Ee8rs3A@public.gmane.org>, "martin.petersen-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org" <martin.petersen-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, "cleech-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <cleech-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "wang.liang82-Th6q7B73Y6EnDS1+zs4M5A@public.gmane.org" <wang.liang82-Th6q7B73Y6EnDS1+zs4M5A@public.gmane.org>, "wang.yi59-Th6q7B73Y6EnDS1+zs4M5A@public.gmane.org" <wang.yi59-Th6q7B73Y6EnDS1+zs4M5A@public.gmane.org>, "xue.zhihong-Th6q7B73Y6EnDS1+zs4M5A@public.gmane.org" <xue.zhihong-Th6q7B73Y6EnDS1+zs4M5A@public.gmane.org>
List-Id: linux-scsi@vger.kernel.org

On 7/10/19 12:30 AM, Yang Bin wrote:

> From: " Yang Bin "<yang.bin18-Th6q7B73Y6EnDS1+zs4M5A@public.gmane.org>
>
> Before xmit,iscsi may disconnect just now.
> So must check connection sock NULL or not,or kernel will crash for
> accessing NULL pointer.
>
> Signed-off-by: Yang Bin <yang.bin18-Th6q7B73Y6EnDS1+zs4M5A@public.gmane.org>
> ---
>  drivers/scsi/iscsi_tcp.c | 3 +++
>  1 file changed, 3 insertions(+)
>
> diff --git a/drivers/scsi/iscsi_tcp.c b/drivers/scsi/iscsi_tcp.c
> index 7bedbe8..a59c49f 100644
> --- a/drivers/scsi/iscsi_tcp.c
> +++ b/drivers/scsi/iscsi_tcp.c
> @@ -264,6 +264,9 @@ static int iscsi_sw_tcp_xmit_segment(struct iscsi_tcp_conn *tcp_conn,
>  	unsigned int copied = 0;
>  	int r = 0;
>  
> +	if (!sk)
> +		return -ENOTCONN;
> +
>  	while (!iscsi_tcp_segment_done(tcp_conn, segment, 0, r)) {
>  		struct scatterlist *sg;
>  		unsigned int offset, copy;
>

If the socket can be closed right before iscsi_sw_tcp_xmit_segment() is
called, can it be called in the middle of sending segments? (In which
case the check would have to be in the while loop.)

-- 

Lee Duncan

-- 
You received this message because you are subscribed to the Google Groups "open-iscsi" group.
To unsubscribe from this group and stop receiving emails from it, send an email to open-iscsi+unsubscribe-/JYPxA39Uh5TLH3MbocFF+G/Ez6ZCGd0@public.gmane.org
To post to this group, send email to open-iscsi-/JYPxA39Uh5TLH3MbocFF+G/Ez6ZCGd0@public.gmane.org
Visit this group at https://groups.google.com/group/open-iscsi.
To view this discussion on the web visit https://groups.google.com/d/msgid/open-iscsi/1bc364ff-5bff-47ac-611a-f75c43f4bd1b%40suse.com.
For more options, visit https://groups.google.com/d/optout.
