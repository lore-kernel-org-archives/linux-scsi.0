From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH] [SCSI]: print the msgbytes and statusbyte from scsi
 result
Date: Mon, 18 Mar 2013 10:14:49 +0000
Message-ID: <1363601689.2412.12.camel@dabdike.int.hansenpartnership.com>
References: <1363508951-3011-1-git-send-email-linkinjeon@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-15"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1363508951-3011-1-git-send-email-linkinjeon@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Namjae Jeon <linkinjeon@gmail.com>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, Namjae Jeon <namjae.jeon@samsung.com>, Amit Sahrawat <a.sahrawat@samsung.com>
List-Id: linux-scsi@vger.kernel.org

On Sun, 2013-03-17 at 17:29 +0900, Namjae Jeon wrote:
> From: Namjae Jeon <namjae.jeon@samsung.com>
> 
> Introduce msgbyte and statusbyte in the prints as part of the
> result which is returned by the lower layer driver in response to
> SCSI command issued, in case of any error conditions.
> 
> Purpose of adding these prints is to convey, during any I/O
> error case, which condition exactly has happened in lower device and
> from the prints we can directly deduce, what is the status of command
> issued. This will help to quickly debug the scenario and also making
> a test case to create new scenarios.
> 
> Also change the printk to more appropriate pr_* macro.
> 
> Signed-off-by: Namjae Jeon <namjae.jeon@samsung.com>
> Signed-off-by: Amit Sahrawat <a.sahrawat@samsung.com>
> ---
>  drivers/scsi/constants.c |    6 ++++--
>  1 file changed, 4 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/scsi/constants.c b/drivers/scsi/constants.c
> index 76e4c03..77bb1dc 100644
> --- a/drivers/scsi/constants.c
> +++ b/drivers/scsi/constants.c
> @@ -1445,8 +1445,10 @@ void scsi_show_result(int result)
>  
>  void scsi_show_result(int result)
>  {
> -	printk("Result: hostbyte=0x%02x driverbyte=0x%02x\n",
> -	       host_byte(result), driver_byte(result));
> +	pr_info("Result: hostbyte=0x%02x driverbyte=0x%02x"
> +			"msgbyte=0x%02x statusbyte=0x%02x\n",
> +	       host_byte(result), driver_byte(result), msg_byte(result),
> +							status_byte(result));

You didn't test this, did you? If you did, you'd have noticed the change
from printk to pr_info gives you an unwanted "6" in the message.

Also, what are you hoping to achieve? scsi_show_result() is only used by
sd in a very few special command situations.  I can't believe the msg
byte would be anything other than zero and the status byte check
condition.

James
