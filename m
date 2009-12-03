From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Subject: Re: [PATCH] [SCSI] mpt fusion: Fix 32 bit platforms with 64 bit
	resources.
Date: Thu, 03 Dec 2009 13:59:50 +1100
Message-ID: <1259809190.2076.1194.camel@pasglop>
References: <1259805106-23636-1-git-send-email-pbathija@amcc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linuxppc-dev-bounces+glppd-linuxppc64-dev=m.gmane.org@lists.ozlabs.org>
In-Reply-To: <1259805106-23636-1-git-send-email-pbathija@amcc.com>
List-Unsubscribe: <https://lists.ozlabs.org/options/linuxppc-dev>,
	<mailto:linuxppc-dev-request@lists.ozlabs.org?subject=unsubscribe>
List-Archive: <http://lists.ozlabs.org/pipermail/linuxppc-dev>
List-Post: <mailto:linuxppc-dev@lists.ozlabs.org>
List-Help: <mailto:linuxppc-dev-request@lists.ozlabs.org?subject=help>
List-Subscribe: <https://lists.ozlabs.org/listinfo/linuxppc-dev>,
	<mailto:linuxppc-dev-request@lists.ozlabs.org?subject=subscribe>
Sender: linuxppc-dev-bounces+glppd-linuxppc64-dev=m.gmane.org@lists.ozlabs.org
Errors-To: linuxppc-dev-bounces+glppd-linuxppc64-dev=m.gmane.org@lists.ozlabs.org
To: Pravin Bathija <pbathija@amcc.com>
Cc: linuxppc-dev@ozlabs.org, Eric.Moore@lsi.com, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Wed, 2009-12-02 at 17:51 -0800, Pravin Bathija wrote:
> Powerpc 44x uses 36 bit real address while the real address defined
>     in MPT Fusion driver is of type 32 bit. This causes ioremap to fail and driver
>     fails to initialize. This fix changes the data types representing the real
>     address from unsigned long 32-bit types to resource_size_t which is 64-bit. The
>     driver has been tested, the disks get discovered correctly and can do IO.
> 
> Signed-off-by: Pravin Bathija <pbathija@amcc.com>

Acked-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>
---

James, this one should be good ;-)

> Acked-by: Feng Kan <fkan@amcc.com>
> Acked-by: Fushen Chen <fchen@amcc.com>
> Acked-by: Loc Ho <lho@amcc.com>
> Acked-by: Tirumala Reddy Marri <tmarri@amcc.com>
> Acked-by: Victor Gallardo <vgallardo@amcc.com>
> ---
>  drivers/message/fusion/mptbase.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/message/fusion/mptbase.c b/drivers/message/fusion/mptbase.c
> index 5d496a9..9f14a60 100644
> --- a/drivers/message/fusion/mptbase.c
> +++ b/drivers/message/fusion/mptbase.c
> @@ -1511,7 +1511,7 @@ mpt_mapresources(MPT_ADAPTER *ioc)
>  {
>  	u8		__iomem *mem;
>  	int		 ii;
> -	unsigned long	 mem_phys;
> +	resource_size_t	 mem_phys;
>  	unsigned long	 port;
>  	u32		 msize;
>  	u32		 psize;
