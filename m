From: Julian Calaby <julian.calaby@gmail.com>
Subject: Re: [RFC PATCH 76/71] ncr5380: Enable PDMA for DTC chips
Date: Fri, 4 Dec 2015 11:12:10 +1100
Message-ID: <CAGRGNgU=6=XBGxpwe+Z+uU-Pq-L=aTyG2GukkWAqFVnJHTY3Og@mail.gmail.com>
References: <20151118083455.331768508@telegraphics.com.au> <1449183781-2163-1-git-send-email-linux@rainbow-software.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1449183781-2163-1-git-send-email-linux@rainbow-software.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Ondrej Zary <linux@rainbow-software.org>
Cc: Finn Thain <fthain@telegraphics.com.au>, Michael Schmitz <schmitzmic@gmail.com>, linux-m68k@vger.kernel.org, linux-scsi <linux-scsi@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

Hi Finn, Ondrej,

One small question:

On Fri, Dec 4, 2015 at 10:03 AM, Ondrej Zary <linux@rainbow-software.org> wrote:
> Add I/O register mapping for DTC chips and enable PDMA mode.
>
> These chips have 16-bit wide HOST BUFFER register (counter register at
> offset 0x0d increments by 2 on each HOST BUFFER read).
>
> Large PIO transfers crash at least the DTCT-436P chip (all reads result
> in 0xFF) so this patch actually makes it work.
>
> The chip also crashes when we bang the C400 host status register too
> heavily after PDMA write - a small udelay is needed.
>
> Signed-off-by: Ondrej Zary <linux@rainbow-software.org>
> ---
> # hdparm -t --direct /dev/sdb
>
> /dev/sdb:
>  Timing O_DIRECT disk reads:   4 MB in  3.78 seconds =   1.06 MB/sec
>
>
>  drivers/scsi/NCR5380.h   |    1 +
>  drivers/scsi/g_NCR5380.c |   47 +++++++++++++++++++++++-----------------------
>  2 files changed, 25 insertions(+), 23 deletions(-)
>
> diff --git a/drivers/scsi/g_NCR5380.c b/drivers/scsi/g_NCR5380.c
> index fae4332..04f6c29 100644
> --- a/drivers/scsi/g_NCR5380.c
> +++ b/drivers/scsi/g_NCR5380.c
> @@ -415,7 +415,8 @@ static int __init generic_NCR5380_detect(struct scsi_host_template *tpnt)
>                         hostdata->c400_blk_cnt = 1;
>                         hostdata->c400_host_buf = 4;
>                 }
> -               if (overrides[current_override].board == BOARD_NCR53C400A) {
> +               if (overrides[current_override].board == BOARD_NCR53C400A ||
> +                   overrides[current_override].board == BOARD_DTC3181E) {

These if statements are starting to get a bit long, would it make
sense to replace them with a flag or equivalent?

Thanks,

-- 
Julian Calaby

Email: julian.calaby@gmail.com
Profile: http://www.google.com/profiles/julian.calaby/
