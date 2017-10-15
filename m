From: Masanori Goto <gotom@debian.or.jp>
Subject: Re: [PATCH] scsi: nsp32: fix logic bug in error handling
Date: Mon, 16 Oct 2017 08:51:22 +0900
Message-ID: <CALZLnaF=ih9nC7dYusxwOKeYhGHa_mRy8k8gGOHpaUvyBkD2kA@mail.gmail.com>
References: <20170905075139.518406-1-arnd@arndb.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20170905075139.518406-1-arnd@arndb.de>
Sender: linux-kernel-owner@vger.kernel.org
To: Arnd Bergmann <arnd@arndb.de>
Cc: YOKOTA Hiroshi <yokota@netlab.is.tsukuba.ac.jp>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Hannes Reinecke <hare@suse.com>, Johannes Thumshirn <jthumshirn@suse.de>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

2017-09-05 16:51 GMT+09:00 Arnd Bergmann <arnd@arndb.de>:
> gcc-8 points out a logic error that has existed since the start
> of the git history:
>
> drivers/scsi/nsp32.c: In function 'nsp32_selection_autoscsi':
> drivers/scsi/nsp32.c:607:27: error: bitwise comparison always evaluates to false [-Werror=tautological-compare]
>   if(((phase & BUSMON_BSY) == 1) || (phase & BUSMON_SEL) == 1) {
>                            ^~
>
> Presumably the author intended to check if one of two bits was
> set, so that's what I'm changing the code to. This will obviously
> change the behavior of the code, hopefully to do the right thing,
> but I have not tested this or checked if the new "(phase & BUSMON_BSY)
> || (phase & BUSMON_SEL)" condition should indeed be treated as a
> fatal error.
>

This is what I originally intended to, thank you!

Signed-off-by: GOTO Masanori <gotom@debian.or.jp>

> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> ---
>  drivers/scsi/nsp32.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/drivers/scsi/nsp32.c b/drivers/scsi/nsp32.c
> index 107e191bf023..8620ac5d6e41 100644
> --- a/drivers/scsi/nsp32.c
> +++ b/drivers/scsi/nsp32.c
> @@ -604,7 +604,7 @@ static int nsp32_selection_autoscsi(struct scsi_cmnd *SCpnt)
>          * check bus line
>          */
>         phase = nsp32_read1(base, SCSI_BUS_MONITOR);
> -       if(((phase & BUSMON_BSY) == 1) || (phase & BUSMON_SEL) == 1) {
> +       if ((phase & BUSMON_BSY) || (phase & BUSMON_SEL)) {
>                 nsp32_msg(KERN_WARNING, "bus busy");
>                 SCpnt->result = DID_BUS_BUSY << 16;
>                 status = 1;
> --
> 2.9.0
>
