From: Frans Klaver <fransklaver@gmail.com>
Subject: Re: [PATCH] [SCSI] FlashPoint: optimize string comparison
Date: Tue, 7 Jul 2015 10:45:32 +0200
Message-ID: <CAH6sp9PzQUPo2_VczkEtwzhYW8AcNTqNYWF6kwMvk_N8peGhxg@mail.gmail.com>
References: <1436247543-7326-1-git-send-email-christophe.jaillet@wanadoo.fr>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1436247543-7326-1-git-send-email-christophe.jaillet@wanadoo.fr>
Sender: linux-kernel-owner@vger.kernel.org
To: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Cc: khalid@gonehiking.org, JBottomley@odin.com, linux-scsi@vger.kernel.org, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, kernel-janitors@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Tue, Jul 7, 2015 at 7:39 AM, Christophe JAILLET
<christophe.jaillet@wanadoo.fr> wrote:
> Stop comparing the strings as soon as we know that they don't match.
>
> Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
> ---
>  drivers/scsi/FlashPoint.c | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
>
> diff --git a/drivers/scsi/FlashPoint.c b/drivers/scsi/FlashPoint.c
> index 5c74e4c..24a4d1a 100644
> --- a/drivers/scsi/FlashPoint.c
> +++ b/drivers/scsi/FlashPoint.c
> @@ -6280,8 +6280,10 @@ static unsigned char FPT_scmachid(unsigned char p_card,
>                 match = 1;
>
>                 for (k = 0; k < ID_STRING_LENGTH; k++) {
> -                       if (p_id_string[k] != FPT_scamInfo[i].id_string[k])
> +                       if (p_id_string[k] != FPT_scamInfo[i].id_string[k]) {
>                                 match = 0;
> +                               break;
> +                       }
>                 }
>
>                 if (match) {

Why doesn't this use strncmp?

Thanks,
Frans
