From: Andy Shevchenko <andy.shevchenko@gmail.com>
Subject: Re: [PATCH 3/4] scsi: fix compiler warning for sg
Date: Thu, 5 Nov 2015 10:48:26 +0200
Message-ID: <CAHp75VfB1ToEZXRbxeWkU7xsWJkMz3v3A1O5QsH9LiiV4Be-iw@mail.gmail.com>
References: <1446698789-19308-1-git-send-email-okaya@codeaurora.org>
	<1446698789-19308-3-git-send-email-okaya@codeaurora.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1446698789-19308-3-git-send-email-okaya@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Sinan Kaya <okaya@codeaurora.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, timur@codeaurora.org, cov@codeaurora.org, jcm@redhat.com, Doug Gilbert <dgilbert@interlog.com>, "James E.J. Bottomley" <JBottomley@odin.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On Thu, Nov 5, 2015 at 6:46 AM, Sinan Kaya <okaya@codeaurora.org> wrote:
> The MULDIV macro has been designed for small
> numbers. It emits an overflow warning on 64 bit
> systems. This patch places type casts in the
> parameters to fix the compiler warning.
>
> Signed-off-by: Sinan Kaya <okaya@codeaurora.org>
> ---
>  drivers/scsi/sg.c | 5 ++++-
>  1 file changed, 4 insertions(+), 1 deletion(-)
>
> diff --git a/drivers/scsi/sg.c b/drivers/scsi/sg.c
> index 9d7b7db..eb2739d 100644
> --- a/drivers/scsi/sg.c
> +++ b/drivers/scsi/sg.c
> @@ -88,7 +88,10 @@ static void sg_proc_cleanup(void);
>   * Of course an overflow is inavoidable if the result of muldiv doesn't fit
>   * in 32 bits.
>   */
> -#define MULDIV(X,MUL,DIV) ((((X % DIV) * MUL) / DIV) + ((X / DIV) * MUL))
> +static inline u64 MULDIV(u64 X, u32 MUL, u32 DIV)
> +{
> +       return ((((X % DIV) * MUL) / DIV) + ((X / DIV) * MUL));
> +}

Like kbuild bot already told you it would be nice to think of 32-bit
architectures.

Moreover we have mult_frac() macro already for 32-bit numbers.

For 64 bit numbers you need to do do_div().

Like:

static inline u64 mult_frac64(u64 x, u32 m, u32 n)
{
u64 ret;

ret = do_div(x, n);
return ret * m;
}


>
>  #define SG_DEFAULT_TIMEOUT MULDIV(SG_DEFAULT_TIMEOUT_USER, HZ, USER_HZ)
>
> --
> Qualcomm Technologies, Inc. on behalf of Qualcomm Innovation Center, Inc.
> Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum, a Linux Foundation Collaborative Project
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html



-- 
With Best Regards,
Andy Shevchenko
