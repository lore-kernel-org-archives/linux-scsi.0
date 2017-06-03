From: Dan Carpenter <dan.carpenter@oracle.com>
Subject: Re: [PATCH] Remove an extra out label in _fcoe_create function
Date: Sat, 3 Jun 2017 05:30:29 +0300
Message-ID: <20170603023029.tfk76tzx6alim2bo@mwanda>
References: <0d0539e8-ec2e-eac3-a91b-bfda55e83eca@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <kernel-janitors-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <0d0539e8-ec2e-eac3-a91b-bfda55e83eca@redhat.com>
Sender: kernel-janitors-owner@vger.kernel.org
To: "Milan P. Gandhi" <mgandhi@redhat.com>
Cc: linux-scsi@vger.kernel.org, kernel-janitors@vger.kernel.org, Laurence Oberman <loberman@redhat.com>, Johannes Thumshirn <jth@kernel.org>
List-Id: linux-scsi@vger.kernel.org

On Thu, Jun 01, 2017 at 05:38:55PM +0530, Milan P. Gandhi wrote:
> This patch removes an extra out label in _fcoe_create function
> where we return if creation of FCOE interface is failed.
> 
> Signed-off-by: Milan P. Gandhi <mgandhi@redhat.com>
> ---
>  drivers/scsi/fcoe/fcoe.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/scsi/fcoe/fcoe.c b/drivers/scsi/fcoe/fcoe.c
> index 7b960d3..ea21e7b 100644
> --- a/drivers/scsi/fcoe/fcoe.c
> +++ b/drivers/scsi/fcoe/fcoe.c
> @@ -2258,7 +2258,7 @@ static int _fcoe_create(struct net_device *netdev, enum fip_mode fip_mode,
>  		fcoe_interface_cleanup(fcoe);
>  		mutex_unlock(&fcoe_config_mutex);
>  		fcoe_ctlr_device_delete(ctlr_dev);
> -		goto out;
> +		return rc;

I don't like do nothing gotos, but I also don't like churn too much.

It doesn't really make sense to do:

		rc = -EIO;
		...
		return rc;

We should probably preserve the error code?  There is a second
"return rc;" later which is more annoying.

drivers/scsi/fcoe/fcoe.c
  2274          /*
  2275           * If the fcoe_ctlr_device is to be set to DISABLED
  2276           * it must be done after the lport is added to the
  2277           * hostlist, but before the rtnl_lock is released.
  2278           * This is because the rtnl_lock protects the
  2279           * hostlist that fcoe_device_notification uses. If
  2280           * the FCoE Controller is intended to be created
  2281           * DISABLED then 'enabled' needs to be considered
  2282           * handling link events. 'enabled' must be set
  2283           * before the lport can be found in the hostlist
  2284           * when a link up event is received.
  2285           */
  2286          if (link_state == FCOE_CREATE_LINK_UP)
  2287                  ctlr_dev->enabled = FCOE_CTLR_ENABLED;
  2288          else
  2289                  ctlr_dev->enabled = FCOE_CTLR_DISABLED;
  2290  
  2291          if (link_state == FCOE_CREATE_LINK_UP &&
  2292              !fcoe_link_ok(lport)) {
  2293                  rtnl_unlock();
  2294                  fcoe_ctlr_link_up(ctlr);
  2295                  mutex_unlock(&fcoe_config_mutex);
  2296                  return rc;
                        ^^^^^^^^^
This is the same as "return 0;" and I guess it's supposed to be a
success return?  But it would look more clear if we changed it to return
a literal instead of rc.

  2297          }
  2298  
  2299  out_nodev:
  2300          rtnl_unlock();

regards,
dan carpenter

