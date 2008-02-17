From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH] ieee1394: sbp2: fix rescan-scsi-bus
Date: Sun, 17 Feb 2008 10:03:05 -0600
Message-ID: <1203264186.3082.33.camel@localhost.localdomain>
References: <tkrat.e8f3d31fb5f9fe01@s5r6.in-berlin.de>
	<tkrat.e66f8acfe9d89925@s5r6.in-berlin.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux1394-devel-bounces@lists.sourceforge.net>
In-Reply-To: <tkrat.e66f8acfe9d89925@s5r6.in-berlin.de>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/linux1394-devel>,
	<mailto:linux1394-devel-request@lists.sourceforge.net?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=linux1394-devel>
List-Post: <mailto:linux1394-devel@lists.sourceforge.net>
List-Help: <mailto:linux1394-devel-request@lists.sourceforge.net?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/linux1394-devel>,
	<mailto:linux1394-devel-request@lists.sourceforge.net?subject=subscribe>
Sender: linux1394-devel-bounces@lists.sourceforge.net
Errors-To: linux1394-devel-bounces@lists.sourceforge.net
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
Cc: linux1394-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org


On Sun, 2008-02-17 at 14:57 +0100, Stefan Richter wrote:
> rescan-scsi-bus used to add SBP-2 targets which weren't there.
> 
> Signed-off-by: Stefan Richter <stefanr@s5r6.in-berlin.de>
> ---
>  drivers/ieee1394/sbp2.c |    3 +++
>  1 file changed, 3 insertions(+)
> 
> Index: linux/drivers/ieee1394/sbp2.c
> ===================================================================
> --- linux.orig/drivers/ieee1394/sbp2.c
> +++ linux/drivers/ieee1394/sbp2.c
> @@ -1974,6 +1974,9 @@ static int sbp2scsi_slave_alloc(struct s
>  {
>  	struct sbp2_lu *lu = (struct sbp2_lu *)sdev->host->hostdata[0];
>  
> +	if (sdev->lun != 0 || sdev->id != lu->ud->id || sdev->channel != 0)
> +		return -ENODEV;
> +

It's hard to know what to say about this.  The infrastructure for
scanning did move to separate scanned (old parallel and a few other)
busses from hotplug ones (which is what sbp2 is).  You really need to
look at the scan_finished and user_scan callbacks.  Unfortunately the
latter is a transport class function and how all the modern busses (FC,
SAS and the like do this).

James



-------------------------------------------------------------------------
This SF.net email is sponsored by: Microsoft
Defy all challenges. Microsoft(R) Visual Studio 2008.
http://clk.atdmt.com/MRT/go/vse0120000070mrt/direct/01/
