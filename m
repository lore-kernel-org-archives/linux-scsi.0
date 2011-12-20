From: Alan Stern <stern-nwvwT67g6+6dFdvTe/nMLpVzexx5G7lz@public.gmane.org>
Subject: Re: [PATCH] usb/uas: one only one status URB/host on stream-less
 connection
Date: Tue, 20 Dec 2011 10:49:06 -0500 (EST)
Message-ID: <Pine.LNX.4.44L0.1112201035240.1690-100000@iolanthe.rowland.org>
References: <20111220150126.GA29286@linutronix.de>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20111220150126.GA29286-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>
Sender: linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sebastian Andrzej Siewior <bigeasy-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>
Cc: Sarah Sharp <sarah.a.sharp-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, Matthew Wilcox <willy-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, linux-usb-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, USB Storage List <usb-storage-ijkIwGHArpdIPJnuZ7Njw4oP9KaGy4wf@public.gmane.org>
List-Id: linux-scsi@vger.kernel.org

On Tue, 20 Dec 2011, Sebastian Andrzej Siewior wrote:

> The status/sense URB is allocated on per-command basis. A read/write
> looks the following way on a stream-less connection:
> 
> - send cmd tag X, queue status
> - receive status, oh it is a read for tag X. queue status & read
> - receive read
> - receive status, oh I'm done for tag X. Cool call complete and free
>   status urb.
> 
> This block repeats itself 1:1 for further commands and looks great so
> far. Lets take a look now what happens if we do allow multiple commands:
> 
> - send cmd tag X, queue statusX (belongs to the command with the X tag)
> - send cmd tag Y, queue statusY (belongs to the command with the Y tag)
> - receive statusX, oh it is a read for tag X. queue statusX & a read
> - receive read
> - receive statusY, oh I'm done for tag X. Cool call complete and free statusY.
> - receive statusX, oh it is a read for tag Y. queue statusY & before we
>   queue the read the the following message can be observed:
>   |sd 0:0:0:0: [sda] sense urb submission failure
>   followed by a second attempt with the same result.
> 
> In order to address this problem there only one status URB for each scsi
> host (as suggested by Matthew) in case we don't have stream support.
> This URB is requeued until the device removed. Nothing changes on stream
> based endpoints.
> 
> Signed-off-by: Sebastian Andrzej Siewior <bigeasy-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>
> ---
> Okay. That is the third patch of my UAS series. The only issue I'm aware
> now is the fact that uas does not work on hcds which do not support sgs.
> One bug at a time.....
> 
>  drivers/usb/storage/uas.c |   71 ++++++++++++++++++++++++++++++++++++++------
>  1 files changed, 61 insertions(+), 10 deletions(-)
> 
> diff --git a/drivers/usb/storage/uas.c b/drivers/usb/storage/uas.c
> index ecf2070..e3b936e 100644
> --- a/drivers/usb/storage/uas.c
> +++ b/drivers/usb/storage/uas.c
> @@ -99,6 +99,8 @@ struct uas_dev_info {
>  	unsigned use_streams:1;
>  	unsigned uas_sense_old:1;
>  	struct scsi_cmnd *cmnd;
> +	/* only used if no stream support is available */
> +	struct urb *status_urb;
>  };
>  
>  enum {
> @@ -117,6 +119,7 @@ struct uas_cmd_info {
>  	unsigned int state;
>  	unsigned int stream;
>  	struct urb *cmd_urb;
> +	/* only used if stream support is available */
>  	struct urb *status_urb;
>  	struct urb *data_in_urb;
>  	struct urb *data_out_urb;

Very minor stylistic point...  It's not clear whether the comments
apply to the items preceding them or the items following them.  You
might want to put each comment on the same line with its respective
item.

Alan Stern

P.S.: Another very minor point, this time grammatical.  (In fact this
is an _extremely_ common mistake -- virtually everybody does it, native
English speakers included.)

The word "only" generally modifies the term following it.  So when you
write "X is only used if Y", the grammatical meaning is: "If Y is true
then X is used but nothing else happens to X -- for example, X isn't
changed or deleted".  (As an illustration of this point, consider the
sentence "The disk is only read, not written, if the read-protect 
flag is set".)

Instead you should write "X is used only if Y", which means what you
want: "If Y isn't true then X isn't used".  Or in this case: "used only 
if stream support is available".

--
To unsubscribe from this list: send the line "unsubscribe linux-usb" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
