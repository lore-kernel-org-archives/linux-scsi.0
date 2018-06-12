From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH] target: add error handling for match_int
Date: Tue, 12 Jun 2018 14:21:25 -0700
Message-ID: <1528838485.24454.2.camel@HansenPartnership.com>
References: <1528779148-42485-1-git-send-email-jiazhouyang09@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1528779148-42485-1-git-send-email-jiazhouyang09@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Zhouyang Jia <jiazhouyang09@gmail.com>
Cc: "Nicholas A. Bellinger" <nab@linux-iscsi.org>, linux-scsi@vger.kernel.org, target-devel@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Tue, 2018-06-12 at 12:52 +0800, Zhouyang Jia wrote:
> When match_int fails, the lack of error-handling code may
> cause unexpected results.
> 
> This patch adds error-handling code after calling match_int.
> 
> Signed-off-by: Zhouyang Jia <jiazhouyang09@gmail.com>
> ---
>  drivers/target/target_core_rd.c | 6 ++++--
>  1 file changed, 4 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/target/target_core_rd.c
> b/drivers/target/target_core_rd.c
> index a6e8106..7bc89ff 100644
> --- a/drivers/target/target_core_rd.c
> +++ b/drivers/target/target_core_rd.c
> @@ -573,14 +573,16 @@ static ssize_t
> rd_set_configfs_dev_params(struct se_device *dev,
>  		token = match_token(ptr, tokens, args);
>  		switch (token) {
>  		case Opt_rd_pages:
> -			match_int(args, &arg);
> +			if (match_int(args, &arg))
> +				return -EINVAL;

The first observation is that this would leak the kmalloc'd orig
variable, but the second is that I don't think terminating parsing is
the right thing to do even if match_int() returns an error: just
ignoring this option and proceed to the next seems to be the best
course because that's what we do with unrecognised options (the
default: case).

James
