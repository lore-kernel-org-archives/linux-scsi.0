From: sagi grimberg <sagig@mellanox.com>
Subject: Re: [PATCH 4/4] target/rd: T10-Dif: RAM disk is allocating more space
 than required.
Date: Sat, 29 Mar 2014 03:22:55 +0300
Message-ID: <5336125F.2020000@mellanox.com>
References: <1396047927-14189-1-git-send-email-quinn.tran@qlogic.com> <1396047927-14189-5-git-send-email-quinn.tran@qlogic.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from eu1sys200aog101.obsmtp.com ([207.126.144.111]:32800 "EHLO
	eu1sys200aog101.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751364AbaC2AXG (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 28 Mar 2014 20:23:06 -0400
In-Reply-To: <1396047927-14189-5-git-send-email-quinn.tran@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Quinn Tran <quinn.tran@qlogic.com>, target-devel@vger.kernel.org, linux-scsi@vger.kernel.org
Cc: giridhar.malavali@qlogic.com, saurav.kashyap@qlogic.com, andrew.vasquez@qlogic.com

On 3/29/2014 2:05 AM, Quinn Tran wrote:
> Ram disk is allocating 8x more space than required for diff data.
> For large RAM disk test, there is small potential for memory
> starvation.
>
> Signed-off-by: Nicholas Bellinger <nab@linux-iscsi.org>
> Signed-off-by: Giridhar Malavali <giridhar.malavali@qlogic.com>
> ---
>   drivers/target/target_core_rd.c | 6 +++++-
>   1 file changed, 5 insertions(+), 1 deletion(-)
>
> diff --git a/drivers/target/target_core_rd.c b/drivers/target/target_core_rd.c
> index 01dda0b..6df177a 100644
> --- a/drivers/target/target_core_rd.c
> +++ b/drivers/target/target_core_rd.c
> @@ -253,7 +253,11 @@ static int rd_build_prot_space(struct rd_dev *rd_dev, int prot_length)
>   	if (rd_dev->rd_flags & RDF_NULLIO)
>   		return 0;
>   
> -	total_sg_needed = rd_dev->rd_page_count / prot_length;
> +	/* prot_length=8byte dif data
> +	 * tot sg needed = rd_page_count * (PGSZ/512) * (prot_length/PGSZ) + pad
> +	 * PGSZ canceled each other.
> +	 */
> +	total_sg_needed = (rd_dev->rd_page_count * prot_length / 512) +1;

You probably will want to use block_size instead of hard-coding 512.
Other then that this makes sense.

>   
>   	sg_tables = (total_sg_needed / max_sg_per_table) + 1;
>   

