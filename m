From: Sagi Grimberg <sagig@dev.mellanox.co.il>
Subject: Re: [PATCH] target: Allow non-supporting backends to set pi_prot_type
 to 0
Date: Wed, 16 Apr 2014 14:13:18 +0300
Message-ID: <534E65CE.8080903@dev.mellanox.co.il>
References: <1397596392-32552-1-git-send-email-agrover@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <1397596392-32552-1-git-send-email-agrover@redhat.com>
Sender: target-devel-owner@vger.kernel.org
To: Andy Grover <agrover@redhat.com>, target-devel@vger.kernel.org
Cc: linux-scsi@vger.kernel.org, frirajder@gmail.com
List-Id: linux-scsi@vger.kernel.org

On 4/16/2014 12:13 AM, Andy Grover wrote:
> Userspace tools assume if a value is read from configfs, it is valid
> and will not cause an error if the same value is written back. The only
> valid value for pi_prot_type for backends not supporting DIF is 0, so allow
> this particular value to be set without returning an error.
>
> Reported-by: Krzysztof Chojnowski <frirajder@gmail.com>
> Signed-off-by: Andy Grover <agrover@redhat.com>
> ---
>   drivers/target/target_core_device.c | 4 ++++
>   1 file changed, 4 insertions(+)
>
> diff --git a/drivers/target/target_core_device.c b/drivers/target/target_core_device.c
> index 65001e1..382b66b 100644
> --- a/drivers/target/target_core_device.c
> +++ b/drivers/target/target_core_device.c
> @@ -936,6 +936,10 @@ int se_dev_set_pi_prot_type(struct se_device *dev, int flag)
>   		return 0;
>   	}
>   	if (!dev->transport->init_prot || !dev->transport->free_prot) {
> +		/* 0 is only allowed value for non-supporting backends */
> +		if (flag == 0)
> +			return 0;
> +
>   		pr_err("DIF protection not supported by backend: %s\n",
>   		       dev->transport->name);
>   		return -ENOSYS;

Makes sense.

Reviewed-by: Sagi Grimberg <sagig@mellanox.com>
