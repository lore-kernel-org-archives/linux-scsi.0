From: Maurizio Lombardi <mlombard@redhat.com>
Subject: Re: [RFC PATCH 0/3] fix *pbl format support
Date: Mon, 21 Sep 2015 16:54:59 +0200
Message-ID: <56001A43.6050501@redhat.com>
References: <1442394523-19176-1-git-send-email-mlombard@redhat.com>
 <87d1xi4kic.fsf@rasmusvillemoes.dk> <20150916174536.GE3243@mtj.duckdns.org>
 <877fnq2jc0.fsf@rasmusvillemoes.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:56082 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756481AbbIUOzD (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 21 Sep 2015 10:55:03 -0400
In-Reply-To: <877fnq2jc0.fsf@rasmusvillemoes.dk>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Rasmus Villemoes <linux@rasmusvillemoes.dk>, Tejun Heo <tj@kernel.org>
Cc: joe@perches.com, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, dgilbert@interlog.com

Hi Rasmus,

On 09/16/2015 10:35 PM, Rasmus Villemoes wrote:
> 
> I just remembered: I noticed a while ago that the qualifier member is
> only used inside format_decode (in the end, the information is folded
> into the type member), so one might as well use a local variable for
> that. This gives option (3): Make field_width a 24 bit bitfield. I think
> that should be sufficient for any realistic bitmap that one would
> print. The patch is also rather small. Surprisingly, bloat-o-meter even
> says that it's also a net win in code size:

I tested your patch with scsi-debug and it works for me:

# modprobe scsi-debug dev_size_mb=256 lbpu=1 lbpws10=1
# cat /sys/bus/pseudo/drivers/scsi_debug/map

# vgcreate tsvg /dev/sdb
  Physical volume "/dev/sdb" successfully created
  Volume group "tsvg" successfully created
# cat /sys/bus/pseudo/drivers/scsi_debug/map
0-15
# lvcreate -V200m -l99%FREE -T tsvg/pool -n lv1 --discards ignore
  Logical volume "lv1" created.
# cat /sys/bus/pseudo/drivers/scsi_debug/map
0-31,2048-2055,501760-501871

Thanks,
Maurizio Lombardi


> 
> add/remove: 18/16 grow/shrink: 3/2 up/down: 5551/-5775 (-224)
> 
> (the huge absolute numbers are due to stuff like 
> 
> pointer                                        -    1148   +1148
> pointer.isra                                1116       -   -1116
> 
> so the functions haven't actually changed that much). I'll have to check
> how this can be (smaller might still be worse), but at least it doesn't
> seem to be a catastrophe in terms of .text bloat.
> 
> [Grr, why don't we have a way to do a compile-time assert outside
> function context?]
> 
> Only compile-tested.
> 
> From: Rasmus Villemoes <linux@rasmusvillemoes.dk>
> Date: Wed, 16 Sep 2015 22:06:14 +0200
> Subject: [RFC] lib/vsprintf.c: expand field_width to 24 bits
> 
> Maurizio Lombardi reported a problem with the %pb extension: It
> doesn't work for sufficiently large bitmaps, since the size is stashed
> in the field_width field of the struct printf_spec, which is currently
> an s16. Concretely, this manifested itself in
> /sys/bus/pseudo/drivers/scsi_debug/map being empty, since the bitmap
> printer got a size of 0, which is the 16 bit truncation of the actual
> bitmap size.
> 
> We do want to keep struct printf_spec at 8 bytes so that it can
> cheaply be passed by value. The qualifier field is only used for
> internal bookkeeping in format_decode, so we might as well use a local
> variable for that. This gives us an additional 8 bits, which we can
> then use for the field width. To stay in 8 bytes, we need to do a
> little rearranging and make the type member a bitfield as well.
> 
> Signed-off-by: Rasmus Villemoes <linux@rasmusvillemoes.dk>
> ---
>  lib/vsprintf.c | 33 +++++++++++++++++----------------
>  1 file changed, 17 insertions(+), 16 deletions(-)
> 
> diff --git a/lib/vsprintf.c b/lib/vsprintf.c
> index 95cd63b43b99..cce2a780a82e 100644
> --- a/lib/vsprintf.c
> +++ b/lib/vsprintf.c
> @@ -380,13 +380,13 @@ enum format_type {
>  };
>  
>  struct printf_spec {
> -	u8	type;		/* format_type enum */
> +	u8	type:8;		/* format_type enum */
> +	s32	field_width:24;	/* width of output field */
>  	u8	flags;		/* flags to number() */
>  	u8	base;		/* number base, 8, 10 or 16 only */
> -	u8	qualifier;	/* number qualifier, one of 'hHlLtzZ' */
> -	s16	field_width;	/* width of output field */
>  	s16	precision;	/* # of digits/chars */
>  };
> +extern char __check_printf_spec[1-2*(sizeof(struct printf_spec) != 8)];
>  
>  static noinline_for_stack
>  char *number(char *buf, char *end, unsigned long long num,
> @@ -1633,6 +1633,7 @@ static noinline_for_stack
>  int format_decode(const char *fmt, struct printf_spec *spec)
>  {
>  	const char *start = fmt;
> +	char qualifier;
>  
>  	/* we finished early by reading the field width */
>  	if (spec->type == FORMAT_TYPE_WIDTH) {
> @@ -1715,16 +1716,16 @@ precision:
>  
>  qualifier:
>  	/* get the conversion qualifier */
> -	spec->qualifier = -1;
> +	qualifier = 0;
>  	if (*fmt == 'h' || _tolower(*fmt) == 'l' ||
>  	    _tolower(*fmt) == 'z' || *fmt == 't') {
> -		spec->qualifier = *fmt++;
> -		if (unlikely(spec->qualifier == *fmt)) {
> -			if (spec->qualifier == 'l') {
> -				spec->qualifier = 'L';
> +		qualifier = *fmt++;
> +		if (unlikely(qualifier == *fmt)) {
> +			if (qualifier == 'l') {
> +				qualifier = 'L';
>  				++fmt;
> -			} else if (spec->qualifier == 'h') {
> -				spec->qualifier = 'H';
> +			} else if (qualifier == 'h') {
> +				qualifier = 'H';
>  				++fmt;
>  			}
>  		}
> @@ -1781,19 +1782,19 @@ qualifier:
>  		return fmt - start;
>  	}
>  
> -	if (spec->qualifier == 'L')
> +	if (qualifier == 'L')
>  		spec->type = FORMAT_TYPE_LONG_LONG;
> -	else if (spec->qualifier == 'l') {
> +	else if (qualifier == 'l') {
>  		BUILD_BUG_ON(FORMAT_TYPE_ULONG + SIGN != FORMAT_TYPE_LONG);
>  		spec->type = FORMAT_TYPE_ULONG + (spec->flags & SIGN);
> -	} else if (_tolower(spec->qualifier) == 'z') {
> +	} else if (_tolower(qualifier) == 'z') {
>  		spec->type = FORMAT_TYPE_SIZE_T;
> -	} else if (spec->qualifier == 't') {
> +	} else if (qualifier == 't') {
>  		spec->type = FORMAT_TYPE_PTRDIFF;
> -	} else if (spec->qualifier == 'H') {
> +	} else if (qualifier == 'H') {
>  		BUILD_BUG_ON(FORMAT_TYPE_UBYTE + SIGN != FORMAT_TYPE_BYTE);
>  		spec->type = FORMAT_TYPE_UBYTE + (spec->flags & SIGN);
> -	} else if (spec->qualifier == 'h') {
> +	} else if (qualifier == 'h') {
>  		BUILD_BUG_ON(FORMAT_TYPE_USHORT + SIGN != FORMAT_TYPE_SHORT);
>  		spec->type = FORMAT_TYPE_USHORT + (spec->flags & SIGN);
>  	} else {
> 
