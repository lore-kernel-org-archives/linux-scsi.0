From: Kai Makisara <Kai.Makisara@kolumbus.fi>
Subject: Re: [PATCH] message fix of st.c
Date: Wed, 31 Mar 2004 22:31:25 +0300 (EEST)
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <Pine.LNX.4.58.0403312224060.1158@kai.makisara.local>
References: <040801c4171c$4dd73890$2987110a@lsd.css.fujitsu.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from fep19-0.kolumbus.fi ([193.229.0.45]:34723 "EHLO
	fep19-app.kolumbus.fi") by vger.kernel.org with ESMTP
	id S262374AbUCaTb1 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 31 Mar 2004 14:31:27 -0500
In-Reply-To: <040801c4171c$4dd73890$2987110a@lsd.css.fujitsu.com>
List-Id: linux-scsi@vger.kernel.org
To: Hironobu Ishii <ishii.hironobu@jp.fujitsu.com>
Cc: linux-scsi <linux-scsi@vger.kernel.org>

On Wed, 31 Mar 2004, Hironobu Ishii wrote:

> Hi Kai,
> 
> st.c has some messages that does not tell us the error device.
> This patch adds device name to such messages.
> This is a patch for linux-2.6.5-rc3.
> 
> Please apply!
> 
> Thanks,
> Hironobu Ishii.
> 
> 
> diff -urN linux-2.6.5-rc3/drivers/scsi/st.c linux-2.6.5-rc3-work/drivers/scsi/st.c
> --- linux-2.6.5-rc3/drivers/scsi/st.c 2004-03-30 19:02:47.000000000 +0900
> +++ linux-2.6.5-rc3-work/drivers/scsi/st.c 2004-03-30 22:25:30.000000000 +0900
> @@ -174,12 +174,12 @@
>  static int modes_defined;
>  
>  static ST_buffer *new_tape_buffer(int, int, int);
> -static int enlarge_buffer(ST_buffer *, int, int);
> -static void normalize_buffer(ST_buffer *);
> -static int append_to_buffer(const char *, ST_buffer *, int);
> -static int from_buffer(ST_buffer *, char *, int);
> -static void move_buffer_data(ST_buffer *, int);
> -static void buf_to_sg(ST_buffer *, unsigned int);
> +static int enlarge_buffer(Scsi_Tape *, int, int);
> +static void normalize_buffer(Scsi_Tape *);
> +static int append_to_buffer(const char *, Scsi_Tape *, int);
> +static int from_buffer(Scsi_Tape *, char *, int);
> +static void move_buffer_data(Scsi_Tape *, int);
> +static void buf_to_sg(Scsi_Tape *, unsigned int);
>  
I don't like these changes. The functions operate on tape buffers and this 
is why the arguments are pointers to buffers. It is true that currently 
only one buffer is attached to each tape but this may not be the case 
forever.

The patch corrects mostly debugging output and I don't think changing the 
function prototypes for this is worth the trouble. There is one case where 
the message may have some significance to "real" users: enlarge_buffer() 
telling that it can't allocate the extra space. enlarge_buffer() is called 
at two places. In one place the calling code prints an error message 
telling the tape name. Similar printk could be put after the other call 
and the printk() from enlarge_buffer() could be removed. After these 
changes, the tape name would be printed in all messages where it really 
matters.

-- 
Kai
