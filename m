From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: [PATCH] drivers: target: target_core_mod: use div64_u64_rem()
 instead of operator '%' for u64
Date: Sat, 21 Dec 2013 18:56:37 -0800
Message-ID: <1387680997.5567.91.camel@haakon3.risingtidesystems.com>
References: <52B4F837.1010403@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <52B4F837.1010403@gmail.com>
Sender: target-devel-owner@vger.kernel.org
To: Chen Gang <gang.chen.5i5j@gmail.com>
Cc: James Hogan <james.hogan@imgtec.com>, linux-scsi@vger.kernel.org, target-devel@vger.kernel.org, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

Hi Chen,

On Sat, 2013-12-21 at 10:08 +0800, Chen Gang wrote:
> In kernel, need use div64_u64_rem() instead of operator '%' for u64, or
> can not pass compiling (with allmodconfig under metag):
> 
>     MODPOST 2909 modules
>   ERROR: "__umoddi3" [drivers/target/target_core_mod.ko] undefined!
> 
> Also need u64 type cast for u32 variable multiply u32 variable, or will
> cause type overflow issue.
> 
> 
> Signed-off-by: Chen Gang <gang.chen.5i5j@gmail.com>
> ---
>  drivers/target/target_core_alua.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 

FYI, this unsigned long long division in core_alua_state_lba_dependent()
was fixed for 32-bit in linux-next >= 12192013 code.

Regardless, thanks for your patch.

--nab

> diff --git a/drivers/target/target_core_alua.c b/drivers/target/target_core_alua.c
> index dc0d399..ff2aadc 100644
> --- a/drivers/target/target_core_alua.c
> +++ b/drivers/target/target_core_alua.c
> @@ -489,7 +489,8 @@ static inline int core_alua_state_lba_dependent(
>  			u64 first_lba = map->lba_map_first_lba;
>  
>  			if (segment_mult) {
> -				start_lba = lba % (segment_size * segment_mult);
> +				u64 tmp = (u64)segment_size * segment_mult;
> +				div64_u64_rem(lba, tmp, &start_lba);
>  				last_lba = first_lba + segment_size - 1;
>  				if (start_lba >= first_lba &&
>  				    start_lba <= last_lba) {
