From: Sagi Grimberg <sagig@dev.mellanox.co.il>
Subject: Re: [PATCH] target/iscsi: fix digest computation for chained SGs
Date: Tue, 21 Jul 2015 11:57:57 +0300
Message-ID: <55AE0995.2010209@dev.mellanox.co.il>
References: <1437437534-17931-1-git-send-email-sbaugh@catern.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <1437437534-17931-1-git-send-email-sbaugh@catern.com>
Sender: target-devel-owner@vger.kernel.org
To: Spencer Baugh <sbaugh@catern.com>, "Nicholas A. Bellinger" <nab@linux-iscsi.org>, Sagi Grimberg <sagig@mellanox.com>, Christoph Hellwig <hch@lst.de>, Bart Van Assche <bart.vanassche@sandisk.com>, Andy Grover <agrover@redhat.com>, Christophe Vu-Brugier <cvubrugier@fastmail.fm>, "open list:TARGET SUBSYSTEM" <linux-scsi@vger.kernel.org>, "open list:TARGET SUBSYSTEM" <target-devel@vger.kernel.org>, open list <linux-kernel@vger.kernel.org>
Cc: joern@purestorage.com, Alexei Potashnik <alexei@purestorage.com>
List-Id: linux-scsi@vger.kernel.org

On 7/21/2015 3:12 AM, Spencer Baugh wrote:
> From: Alexei Potashnik <alexei@purestorage.com>
>
> Current implementation assumes that all the buffers of an IO are linked
> with a single SG list. Which makes it fail if SG chaining is used.
>
> Signed-off-by: Alexei Potashnik <alexei@purestorage.com>
> ---
>   drivers/target/iscsi/iscsi_target.c | 9 ++++-----
>   1 file changed, 4 insertions(+), 5 deletions(-)
>
> diff --git a/drivers/target/iscsi/iscsi_target.c b/drivers/target/iscsi/iscsi_target.c
> index 4e68b62..a4cf58c 100644
> --- a/drivers/target/iscsi/iscsi_target.c
> +++ b/drivers/target/iscsi/iscsi_target.c
> @@ -1209,7 +1209,6 @@ static u32 iscsit_do_crypto_hash_sg(
>   	u8 *pad_bytes)
>   {
>   	u32 data_crc;
> -	u32 i;
>   	struct scatterlist *sg;
>   	unsigned int page_off;
>
> @@ -1218,15 +1217,15 @@ static u32 iscsit_do_crypto_hash_sg(
>   	sg = cmd->first_data_sg;
>   	page_off = cmd->first_data_sg_off;
>
> -	i = 0;
>   	while (data_length) {
> -		u32 cur_len = min_t(u32, data_length, (sg[i].length - page_off));
> +		u32 cur_len = min_t(u32, data_length, (sg->length - page_off));
>
> -		crypto_hash_update(hash, &sg[i], cur_len);
> +		crypto_hash_update(hash, sg, cur_len);
>
>   		data_length -= cur_len;
>   		page_off = 0;
> -		i++;
> +		/* iscsit_map_iovec has already checked for invalid sg pointers */
> +		sg = sg_next(sg);
>   	}
>
>   	if (padding) {
>

How were you able to get a chained SG list in the target code?

In any event, looks good,

Reviewed-by: Sagi Grimberg <sagig@mellanox.com>
