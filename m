From: Douglas Gilbert <dgilbert@interlog.com>
Subject: Re: [PATCH] sg: recheck MMAP_IO request length with lock held
Date: Tue, 22 Aug 2017 17:37:10 -0400
Message-ID: <db6faa64-7ef2-9a72-f186-8691313ad18a@interlog.com>
References: <20170816044843.96697-1-toddpoynor@google.com>
Reply-To: dgilbert@interlog.com
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20170816044843.96697-1-toddpoynor@google.com>
Content-Language: en-CA
Sender: linux-kernel-owner@vger.kernel.org
To: Todd Poynor <toddpoynor@google.com>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, Hannes Reinecke <hare@suse.de>
List-Id: linux-scsi@vger.kernel.org

On 2017-08-16 12:48 AM, Todd Poynor wrote:
> Commit 1bc0eb044615 ("scsi: sg: protect accesses to 'reserved' page
> array") adds needed concurrency protection for the "reserve" buffer.
> Some checks that are initially made outside the lock are replicated once
> the lock is taken to ensure the checks and resulting decisions are made
> using consistent state.
> 
> The check that a request with flag SG_FLAG_MMAP_IO set fits in the
> reserve buffer also needs to be performed again under the lock to
> ensure the reserve buffer length compared against matches the value in
> effect when the request is linked to the reserve buffer.  An -ENOMEM
> should be returned in this case, instead of switching over to an
> indirect buffer as for non-MMAP_IO requests.
> 
> Signed-off-by: Todd Poynor <toddpoynor@google.com>
Acked-by: Douglas Gilbert <dgilbert@interlog.com>

Thanks.

> ---
>   drivers/scsi/sg.c | 7 +++++--
>   1 file changed, 5 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/scsi/sg.c b/drivers/scsi/sg.c
> index d7ff71e0c85c..3a44b4bc872b 100644
> --- a/drivers/scsi/sg.c
> +++ b/drivers/scsi/sg.c
> @@ -1735,9 +1735,12 @@ sg_start_req(Sg_request *srp, unsigned char *cmd)
>   		    !sfp->res_in_use) {
>   			sfp->res_in_use = 1;
>   			sg_link_reserve(sfp, srp, dxfer_len);
> -		} else if ((hp->flags & SG_FLAG_MMAP_IO) && sfp->res_in_use) {
> +		} else if (hp->flags & SG_FLAG_MMAP_IO) {
> +			res = -EBUSY; /* sfp->res_in_use == 1 */
> +			if (dxfer_len > rsv_schp->bufflen)
> +				res = -ENOMEM;
>   			mutex_unlock(&sfp->f_mutex);
> -			return -EBUSY;
> +			return res;
>   		} else {
>   			res = sg_build_indirect(req_schp, sfp, dxfer_len);
>   			if (res) {
> 
