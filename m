From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH] scsi: advansys: use struct_size() in kzalloc()
Date: Fri, 11 Jan 2019 16:46:46 +0100
Message-ID: <05420a5c-c268-b87d-9d75-f5d18a4b7f7a@suse.de>
References: <20190104212209.GA15250@embeddedor>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190104212209.GA15250@embeddedor>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: "Gustavo A. R. Silva" <gustavo@embeddedor.com>, Matthew Wilcox <willy@infradead.org>, Hannes Reinecke <hare@suse.com>, "James E.J. Bottomley" <jejb@linux.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On 1/4/19 10:22 PM, Gustavo A. R. Silva wrote:
> One of the more common cases of allocation size calculations is finding the
> size of a structure that has a zero-sized array at the end, along with memory
> for some number of elements for that array. For example:
> 
> struct foo {
>      int stuff;
>      void *entry[];
> };
> 
> instance = kzalloc(sizeof(struct foo) + sizeof(void *) * count, GFP_KERNEL);
> 
> Instead of leaving these open-coded and prone to type mistakes, we can now
> use the new struct_size() helper:
> 
> instance = kzalloc(struct_size(instance, entry, count), GFP_KERNEL);
> 
> This code was detected with the help of Coccinelle.
> 
> Signed-off-by: Gustavo A. R. Silva <gustavo@embeddedor.com>
> ---
>   drivers/scsi/advansys.c | 4 ++--
>   1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/scsi/advansys.c b/drivers/scsi/advansys.c
> index d37584403c33..6c274e6e1c33 100644
> --- a/drivers/scsi/advansys.c
> +++ b/drivers/scsi/advansys.c
> @@ -7576,8 +7576,8 @@ static int asc_build_req(struct asc_board *boardp, struct scsi_cmnd *scp,
>   			return ASC_ERROR;
>   		}
>   
> -		asc_sg_head = kzalloc(sizeof(asc_scsi_q->sg_head) +
> -			use_sg * sizeof(struct asc_sg_list), GFP_ATOMIC);
> +		asc_sg_head = kzalloc(struct_size(asc_sg_head, sg_list, use_sg),
> +				      GFP_ATOMIC);
>   		if (!asc_sg_head) {
>   			scsi_dma_unmap(scp);
>   			scp->result = HOST_BYTE(DID_SOFT_ERROR);
> 
If you want ...

Reviewed-by: Hannes Reinecke <hare@suse.com>

Cheers,

Hannes
