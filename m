From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH 1/1] dpt_i2o: delete unnecessary null test on array
Date: Fri, 08 Aug 2014 09:59:39 -0700
Message-ID: <1407517179.2044.13.camel@jarvis.lan>
References: <1407321551-27479-1-git-send-email-Julia.Lawall@lip6.fr>
	 <1407321551-27479-2-git-send-email-Julia.Lawall@lip6.fr>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1407321551-27479-2-git-send-email-Julia.Lawall@lip6.fr>
Sender: linux-kernel-owner@vger.kernel.org
To: Julia Lawall <Julia.Lawall@lip6.fr>
Cc: Adaptec OEM Raid Solutions <aacraid@adaptec.com>, kernel-janitors@vger.kernel.org, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, joe@perches.com
List-Id: linux-scsi@vger.kernel.org

On Wed, 2014-08-06 at 12:39 +0200, Julia Lawall wrote:
> From: Julia Lawall <Julia.Lawall@lip6.fr>
> 
> Delete NULL test on array (always false).
> 
> A simplified version of the semantic match that finds this problem is as
> follows: (http://coccinelle.lip6.fr/)
> 
> // <smpl>
> @r@
> type T;
> T [] e;
> position p;
> @@
> e ==@p NULL
> 
> @ disable fld_to_ptr@
> expression e;
> identifier f;
> position r.p;
> @@
> * e.f ==@p NULL
> // </smpl>
> 
> Signed-off-by: Julia Lawall <Julia.Lawall@lip6.fr>
> 
> ---
> I don't know if this is the correct change, or if some other test was
> intended.  But the code has been this way since at least 2.4.20, so it
> would seem that no one has been bothered by the lack of whatever this was
> supposed to test for.
> 
>  drivers/scsi/dpt_i2o.c |    5 -----
>  1 file changed, 5 deletions(-)
> 
> diff --git a/drivers/scsi/dpt_i2o.c b/drivers/scsi/dpt_i2o.c
> index 67283ef..62e276b 100644
> --- a/drivers/scsi/dpt_i2o.c
> +++ b/drivers/scsi/dpt_i2o.c
> @@ -1169,11 +1169,6 @@ static struct adpt_device* adpt_find_device(adpt_hba* pHba, u32 chan, u32 id, u6
>  	if(chan < 0 || chan >= MAX_CHANNEL)
>  		return NULL;
>  	
> -	if( pHba->channel[chan].device == NULL){
> -		printk(KERN_DEBUG"Adaptec I2O RAID: Trying to find device before they are allocated\n");
> -		return NULL;
> -	}

dpt_i2o is always weirdly fun, but I think, based on the message, this
check is supposed to be 

if( pHba->channel[chan].device[id] == NULL){

Since device is an array of device pointers which are allocated by
parsing data.

James
