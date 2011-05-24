From: James Smart <james.smart@emulex.com>
Subject: Re: [PATCH 3/9] [SCSI] lpfc: Silence DEBUG_STRICT_USER_COPY_CHECKS=y
 warning
Date: Tue, 24 May 2011 09:32:47 -0400
Message-ID: <5b0f759a-66ec-4f31-bcdf-084e3a6aa4c3@exht1.ad.emulex.com>
References: <1305244212-19183-1-git-send-email-sboyd@codeaurora.org> <1305244212-19183-4-git-send-email-sboyd@codeaurora.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1305244212-19183-4-git-send-email-sboyd@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Stephen Boyd <sboyd@codeaurora.org>
Cc: "James E.J. Bottomley" <James.Bottomley@suse.de>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "Iannicelli, Alex" <Alex.Iannicelli@Emulex.Com>
List-Id: linux-scsi@vger.kernel.org

Acked-by: James Smart <james.smart@emulex.com>

Thanks

-- james


On 5/12/2011 7:50 PM, Stephen Boyd wrote:
> Enabling DEBUG_STRICT_USER_COPY_CHECKS causes the following
> warning:
>
> In file included from arch/x86/include/asm/uaccess.h:573,
>                   from include/linux/uaccess.h:5,
>                   from include/linux/highmem.h:7,
>                   from include/linux/pagemap.h:10,
>                   from include/linux/blkdev.h:12,
>                   from drivers/scsi/lpfc/lpfc_debugfs.c:21:
> In function 'copy_from_user':
> arch/x86/include/asm/uaccess_64.h:65:
> warning: call to 'copy_from_user_overflow' declared with
> attribute warning: copy_from_user() buffer size is not provably
> correct
>
> presumably due to buf_size being signed causing GCC to fail to
> see that buf_size can't become negative.
>
> Cc: James Smart<james.smart@emulex.com>
> Signed-off-by: Stephen Boyd<sboyd@codeaurora.org>
> ---
>   drivers/scsi/lpfc/lpfc_debugfs.c |    3 ++-
>   1 files changed, 2 insertions(+), 1 deletions(-)
>
> diff --git a/drivers/scsi/lpfc/lpfc_debugfs.c b/drivers/scsi/lpfc/lpfc_debugfs.c
> index 3d96774..0af53a6 100644
> --- a/drivers/scsi/lpfc/lpfc_debugfs.c
> +++ b/drivers/scsi/lpfc/lpfc_debugfs.c
> @@ -1305,7 +1305,8 @@ static int lpfc_idiag_cmd_get(const char __user *buf, size_t nbytes,
>   {
>   	char mybuf[64];
>   	char *pbuf, *step_str;
> -	int bsize, i;
> +	int i;
> +	size_t bsize;
>
>   	/* Protect copy from user */
>   	if (!access_ok(VERIFY_READ, buf, nbytes))
