From: Vasu Dev <vasu.dev-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Subject: Re: [PATCH] scsi: fcoe: Convert use of __constant_htons
 to htons
Date: Tue, 01 Sep 2015 15:43:24 -0700
Message-ID: <1441147404.19451.52.camel@lin-nd1-054.jf.intel.com>
References: <20150819054844.GA21960@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <fcoe-devel-bounces-s9riP+hp16TNLxjTenLetw@public.gmane.org>
In-Reply-To: <20150819054844.GA21960@localhost>
List-Unsubscribe: <http://lists.open-fcoe.org/mailman/options/fcoe-devel>,
 <mailto:fcoe-devel-request-s9riP+hp16TNLxjTenLetw@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.open-fcoe.org/pipermail/fcoe-devel/>
List-Post: <mailto:fcoe-devel-s9riP+hp16TNLxjTenLetw@public.gmane.org>
List-Help: <mailto:fcoe-devel-request-s9riP+hp16TNLxjTenLetw@public.gmane.org?subject=help>
List-Subscribe: <http://lists.open-fcoe.org/mailman/listinfo/fcoe-devel>,
 <mailto:fcoe-devel-request-s9riP+hp16TNLxjTenLetw@public.gmane.org?subject=subscribe>
Errors-To: fcoe-devel-bounces-s9riP+hp16TNLxjTenLetw@public.gmane.org
Sender: "fcoe-devel" <fcoe-devel-bounces-s9riP+hp16TNLxjTenLetw@public.gmane.org>
To: Vaishali Thakkar <vthakkar1994-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: fcoe-devel-s9riP+hp16TNLxjTenLetw@public.gmane.org, "James E.J.
 Bottomley" <JBottomley-wo1vFcy6AUs@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-scsi@vger.kernel.org

On Wed, 2015-08-19 at 11:18 +0530, Vaishali Thakkar wrote:
> In little endian cases, the macro htons unfolds to __swab16 which
> provides special case for constants. In big endian cases,
> __constant_htons and htons expand directly to the same expression.
> So, replace __constant_htons with htons with the goal of getting
> rid of the definition of __constant_htons completely.
> 
> The semantic patch that performs this transformation is as follows:
> 
> @@expression x;@@
> 
> - __constant_htons(x)
> + htons(x)
> 
> Signed-off-by: Vaishali Thakkar <vthakkar1994-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
> ---
>  drivers/scsi/fcoe/fcoe.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/scsi/fcoe/fcoe.c b/drivers/scsi/fcoe/fcoe.c
> index ec193a8..d3eb80c 100644
> --- a/drivers/scsi/fcoe/fcoe.c
> +++ b/drivers/scsi/fcoe/fcoe.c
> @@ -364,7 +364,7 @@ static int fcoe_interface_setup(struct fcoe_interface *fcoe,
>  	 * on the ethertype for the given device
>  	 */
>  	fcoe->fcoe_packet_type.func = fcoe_rcv;
> -	fcoe->fcoe_packet_type.type = __constant_htons(ETH_P_FCOE);
> +	fcoe->fcoe_packet_type.type = htons(ETH_P_FCOE);
>  	fcoe->fcoe_packet_type.dev = netdev;
>  	dev_add_pack(&fcoe->fcoe_packet_type);
>  

Acked-by: Vasu Dev <vasu.dev-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
