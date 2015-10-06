From: Julian Calaby <julian.calaby@gmail.com>
Subject: Re: RFC: reduce CONFIG_SCSI_CONSTANTS impact by 4k
Date: Tue, 6 Oct 2015 12:32:47 +1100
Message-ID: <CAGRGNgXt6qt4K+O9u+Y45rZNh07X=6wh7CdCwJ4mwiYkjXyCWA@mail.gmail.com>
References: <87h9mbg6h1.fsf@rasmusvillemoes.dk> <20151003171437.GA20847@infradead.org>
 <87bncf1u4p.fsf@rasmusvillemoes.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-io0-f176.google.com ([209.85.223.176]:33670 "EHLO
	mail-io0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750902AbbJFBdH (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 5 Oct 2015 21:33:07 -0400
In-Reply-To: <87bncf1u4p.fsf@rasmusvillemoes.dk>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Cc: Christoph Hellwig <hch@infradead.org>, Hannes Reinecke <hare@suse.de>, "James E.J. Bottomley" <JBottomley@odin.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>

Hi Rasmus,

On Sun, Oct 4, 2015 at 9:09 AM, Rasmus Villemoes
<linux@rasmusvillemoes.dk> wrote:
> Subject: [PATCH 2/2] scsi: reduce CONFIG_SCSI_CONSTANTS=y impact by 8k
>
> On 64 bit, struct error_info has 6 bytes of padding, which amounts to
> over 4k of wasted space in the additional[] array. We could easily get
> rid of that by instead using separate arrays for the codes and the
> pointers. However, we can do even better than that and save an
> additional 6 bytes per entry: In the table, just store the sizeof()
> the corresponding string literal. The cumulative sum of these is then
> the appropriate offset into additional_text, which is built from the
> concatenation (with '\0's inbetween) of the strings.
>
> $ scripts/bloat-o-meter /tmp/vmlinux vmlinux
> add/remove: 0/0 grow/shrink: 1/1 up/down: 24/-8488 (-8464)
> function                                     old     new   delta
> scsi_extd_sense_format                       136     160     +24
> additional                                 11312    2824   -8488

Quick question:

> Signed-off-by: Rasmus Villemoes <linux@rasmusvillemoes.dk>
> ---
>  drivers/scsi/constants.c   | 25 +++++++++++++++++++++----
>  drivers/scsi/sense_codes.h |  2 --
>  2 files changed, 21 insertions(+), 6 deletions(-)
>
> diff --git a/drivers/scsi/constants.c b/drivers/scsi/constants.c
> index 47aaccd5e68e..ccd34b0481cd 100644
> --- a/drivers/scsi/constants.c
> +++ b/drivers/scsi/constants.c
> @@ -292,17 +292,31 @@ bool scsi_opcode_sa_name(int opcode, int service_action,
>
>  struct error_info {
>         unsigned short code12;  /* 0x0302 looks better than 0x03,0x02 */
> -       const char * text;
> +       unsigned short size;
>  };
>
>
> +/*
> + * There are 700+ entries in this table. To save space, we don't store
> + * (code, pointer) pairs, which would make sizeof(struct
> + * error_info)==16 on 64 bits. Rather, the second element just stores
> + * the size (including \0) of the corresponding string, and we use the
> + * sum of these to get the appropriate offset into additional_text
> + * defined below. This approach saves 12 bytes per entry.
> + */
>  static const struct error_info additional[] =
>  {
> -#define SENSE_CODE(c, s) {c, s},
> +#define SENSE_CODE(c, s) {c, sizeof(s)},
>  #include "sense_codes.h"
>  #undef SENSE_CODE
>  };
>
> +static const char *additional_text =
> +#define SENSE_CODE(c, s) s "\0"
> +#include "sense_codes.h"
> +#undef SENSE_CODE
> +       ;
> +
>  struct error_info2 {
>         unsigned char code1, code2_min, code2_max;
>         const char * str;
> @@ -364,11 +378,14 @@ scsi_extd_sense_format(unsigned char asc, unsigned char ascq, const char **fmt)
>  {
>         int i;
>         unsigned short code = ((asc << 8) | ascq);
> +       unsigned offset = 0;
>
>         *fmt = NULL;
> -       for (i = 0; additional[i].text; i++)
> +       for (i = 0; i < ARRAY_SIZE(additional); i++) {
>                 if (additional[i].code12 == code)
> -                       return additional[i].text;
> +                       return additional_text + offset;
> +               offset += additional[i].size;

You don't seem to be accounting for the null bytes here.

Thanks,

-- 
Julian Calaby

Email: julian.calaby@gmail.com
Profile: http://www.google.com/profiles/julian.calaby/
