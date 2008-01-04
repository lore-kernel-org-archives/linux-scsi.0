From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: [ofa-general] Re: [2.6.24-rc BUGFIX] SRP transport: only remove our
	own entries
Date: Fri, 04 Jan 2008 11:54:17 +0900
Message-ID: <20080104115417Q.fujita.tomonori@lab.ntt.co.jp>
References: <1199393485.7561.51.camel@lap75545.ornl.gov>
	<20080104094722F.fujita.tomonori@lab.ntt.co.jp>
	<1199414089.3636.7.camel@obelisk.thedillows.org>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <general-bounces@lists.openfabrics.org>
In-Reply-To: <1199414089.3636.7.camel@obelisk.thedillows.org>
List-Unsubscribe: <http://lists.openfabrics.org/cgi-bin/mailman/listinfo/general>,
	<mailto:general-request@lists.openfabrics.org?subject=unsubscribe>
List-Archive: <http://lists.openfabrics.org/pipermail/general>
List-Post: <mailto:general@lists.openfabrics.org>
List-Help: <mailto:general-request@lists.openfabrics.org?subject=help>
List-Subscribe: <http://lists.openfabrics.org/cgi-bin/mailman/listinfo/general>,
	<mailto:general-request@lists.openfabrics.org?subject=subscribe>
Sender: general-bounces@lists.openfabrics.org
Errors-To: general-bounces@lists.openfabrics.org
To: James.Bottomley@HansenPartnership.com, dillowda@ornl.gov
Cc: linux-scsi@vger.kernel.org, rdreier@cisco.com, linux-kernel@vger.kernel.org, fujita.tomonori@lab.ntt.co.jp, general@lists.openfabrics.org, tomof@acm.org
List-Id: linux-scsi@vger.kernel.org

On Thu, 03 Jan 2008 21:34:49 -0500
Dave Dillow <dillowda@ornl.gov> wrote:

> The SCSI SRP transport class currently iterates over all children
> devices of the host that is being removed in srp_remove_host(). However,
> not all of those children were created by the SRP transport, and
> removing them will cause corruption and an oops when their creator tries
> to remove them.
> 
> Signed-off-by: David Dillow <dillowda@ornl.gov>
> Acked-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
> ---

Thanks!

James, please put this patch into scsi-rc-fixes.

> On Fri, 2008-01-04 at 09:47 +0900, FUJITA Tomonori wrote:
> > On Thu, 03 Jan 2008 15:51:25 -0500
> > I think that this is the root problem and the patch fixes it in the
> > right way. Please send this patch to linux-scsi@vger.kernel.org and a
> > patch to move srp_remove_host before scsi_remove_host in
> > srp_remove_one to Roland.
> > 
> > Acked-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
> 
> diff --git a/drivers/scsi/scsi_transport_srp.c b/drivers/scsi/scsi_transport_srp.c
> index 44a340b..65c584d 100644
> --- a/drivers/scsi/scsi_transport_srp.c
> +++ b/drivers/scsi/scsi_transport_srp.c
> @@ -265,7 +265,8 @@ EXPORT_SYMBOL_GPL(srp_rport_del);
>  
>  static int do_srp_rport_del(struct device *dev, void *data)
>  {
> -	srp_rport_del(dev_to_rport(dev));
> +	if (scsi_is_srp_rport(dev))
> +		srp_rport_del(dev_to_rport(dev));
>  	return 0;
>  }
>  
> 
> -
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
