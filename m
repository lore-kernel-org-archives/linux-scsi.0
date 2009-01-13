From: Andrew McGill <list2008-x9yJDnhTiMLk1uMJSBkQmQ@public.gmane.org>
Subject: Re: [PATCH] iscsi: Fix some debug printf types
Date: Tue, 13 Jan 2009 08:11:29 +0200
Message-ID: <200901130811.29281.list2008@lunch.za.net>
References: <496B621A.6000300@panasas.com>
Reply-To: open-iscsi-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <grbounce-FC1hwAUAAAA0O9VQcsxVj1UPjHD9r3x_=glio-open-iscsi=m.gmane.org-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
In-Reply-To: <496B621A.6000300-C4P08NqkoRlBDgjK7y7TUQ@public.gmane.org>
Sender: open-iscsi-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org
List-Post: <mailto:open-iscsi-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
List-Help: <mailto:open-iscsi+help-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
List-Unsubscribe: <http://googlegroups.com/group/open-iscsi/subscribe>,
	<mailto:open-iscsi+unsubscribe-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
To: open-iscsi-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org
Cc: Boaz Harrosh <bharrosh-C4P08NqkoRlBDgjK7y7TUQ@public.gmane.org>, Mike Christie <michaelc-hcNo3dDEHLuVc3sceRu5cw@public.gmane.org>, linux-scsi <linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-scsi@vger.kernel.org


My man page for (glibc) printf says that "Z" is specific to libc5, and 
that "z" is better -- man -P 'less -p" z "' fprintf   Does the underlying 
printf support "Z" rather than "z"?

QOTD>>
 z 
  A following integer conversion corresponds to a size_t or ssize_t argument.
  (Linux libc5 has Z with this meaning. Don't use it.)

&:-)


On Monday 12 January 2009 17:30:34 Boaz Harrosh wrote:
> A couple of prints at lib/iscsi_tcp had the %Z missing from the
> kprint format string. Just to show that debug_prints are not enabled
> much.
>
> Signed-off-by: Boaz Harrosh <bharrosh-C4P08NqkoRlBDgjK7y7TUQ@public.gmane.org>
> ---
>  drivers/scsi/iscsi_tcp.c    |    2 +-
>  drivers/scsi/libiscsi_tcp.c |    2 +-
>  2 files changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/scsi/iscsi_tcp.c b/drivers/scsi/iscsi_tcp.c
> index 23808df..a566aa9 100644
> --- a/drivers/scsi/iscsi_tcp.c
> +++ b/drivers/scsi/iscsi_tcp.c
> @@ -415,7 +415,7 @@ iscsi_sw_tcp_send_linear_data_prep(struct iscsi_conn
> *conn, void *data, struct hash_desc *tx_hash = NULL;
>  	unsigned int hdr_spec_len;
>
> -	debug_tcp("%s(%p, datalen=%d%s)\n", __func__, tcp_conn, len,
> +	debug_tcp("%s(%p, datalen=%Zd%s)\n", __func__, tcp_conn, len,
>  		  conn->datadgst_en? ", digest enabled" : "");
>
>  	/* Make sure the datalen matches what the caller
> diff --git a/drivers/scsi/libiscsi_tcp.c b/drivers/scsi/libiscsi_tcp.c
> index a745f91..12354c5 100644
> --- a/drivers/scsi/libiscsi_tcp.c
> +++ b/drivers/scsi/libiscsi_tcp.c
> @@ -356,7 +356,7 @@ iscsi_segment_seek_sg(struct iscsi_segment *segment,
>  	struct scatterlist *sg;
>  	unsigned int i;
>
> -	debug_scsi("iscsi_segment_seek_sg offset %u size %llu\n",
> +	debug_scsi("iscsi_segment_seek_sg offset %u size %Zu\n",
>  		  offset, size);
>  	__iscsi_segment_init(segment, size, done, hash);
>  	for_each_sg(sg_list, sg, sg_count, i) {
