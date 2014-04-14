From: James Bottomley <James.Bottomley-d9PhHud1JfjCXq6kfMZ53/egYHeGw8Jk@public.gmane.org>
Subject: Re: [PATCH] hpsa: fix uninitialized trans_support in
	hpsa_put_ctlr_into_performant_mode()
Date: Mon, 14 Apr 2014 08:45:16 -0700
Message-ID: <1397490316.2207.23.camel@dabdike.int.hansenpartnership.com>
References: <20140410221704.GA22465@beardog.cce.hp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <iommu-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
In-Reply-To: <20140410221704.GA22465-3C9H9nn4BS4HL6m8NFMY+dBPR1lH4CV8@public.gmane.org>
List-Unsubscribe: <https://lists.linuxfoundation.org/mailman/options/iommu>,
	<mailto:iommu-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.linuxfoundation.org/pipermail/iommu/>
List-Post: <mailto:iommu-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
List-Help: <mailto:iommu-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=help>
List-Subscribe: <https://lists.linuxfoundation.org/mailman/listinfo/iommu>,
	<mailto:iommu-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=subscribe>
Sender: iommu-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org
Errors-To: iommu-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org
To: scameron-3C9H9nn4BS4HL6m8NFMY+dBPR1lH4CV8@public.gmane.org
Cc: linux-scsi <linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Baoquan He <bhe-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "linux-pci-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-pci-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "open list:INTEL IOMMU (VT-d)" <iommu-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>, Davidlohr Bueso <davidlohr-VXdhtT5mjnY@public.gmane.org>, Bjorn Helgaas <bhelgaas-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Jiang Liu <jiang.liu-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
List-Id: linux-scsi@vger.kernel.org

Your subject line is very tame.  It should be the one line summary of
why we apply the patch, so it should read something like

 hpsa: fix NULL deref in performant mode

On Thu, 2014-04-10 at 17:17 -0500, scameron-3C9H9nn4BS4HL6m8NFMY+dBPR1lH4CV8@public.gmane.org wrote:
> Without this, you'll see a null pointer dereference in
> hpsa_enter_performant_mode().

The description should be more comprehensible.

I'm clear that the use before initialisation is a bug ... I'm less clear
on why it causes an oops.

> Signed-off-by: Stephen M. Cameron <scameron-3C9H9nn4BS4HL6m8NFMY+dBPR1lH4CV8@public.gmane.org>
> ---
>  drivers/scsi/hpsa.c |    4 ++++
>  1 files changed, 4 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/scsi/hpsa.c b/drivers/scsi/hpsa.c
> index 8cf4a0c..ef4dfdd 100644
> --- a/drivers/scsi/hpsa.c
> +++ b/drivers/scsi/hpsa.c
> @@ -7463,6 +7463,10 @@ static void hpsa_put_ctlr_into_performant_mode(struct ctlr_info *h)
>  	if (hpsa_simple_mode)
>  		return;
>  
> +	trans_support = readl(&(h->cfgtable->TransportSupport));
> +	if (!(trans_support & PERFORMANT_MODE))
> +		return;
> +
>  	/* Check for I/O accelerator mode support */
>  	if (trans_support & CFGTBL_Trans_io_accel1) {
>  		transMethod |= CFGTBL_Trans_io_accel1 |

Shouldn't you be moving this check from its previous location, rather
than adding a new one that makes the original obsolete?

James

---

diff --git a/drivers/scsi/hpsa.c b/drivers/scsi/hpsa.c
index 8cf4a0c..9a6e4a2 100644
--- a/drivers/scsi/hpsa.c
+++ b/drivers/scsi/hpsa.c
@@ -7463,6 +7463,10 @@ static void hpsa_put_ctlr_into_performant_mode(struct ctlr_info *h)
 	if (hpsa_simple_mode)
 		return;
 
+	trans_support = readl(&(h->cfgtable->TransportSupport));
+	if (!(trans_support & PERFORMANT_MODE))
+		return;
+
 	/* Check for I/O accelerator mode support */
 	if (trans_support & CFGTBL_Trans_io_accel1) {
 		transMethod |= CFGTBL_Trans_io_accel1 |
@@ -7479,10 +7483,6 @@ static void hpsa_put_ctlr_into_performant_mode(struct ctlr_info *h)
 	}
 
 	/* TODO, check that this next line h->nreply_queues is correct */
-	trans_support = readl(&(h->cfgtable->TransportSupport));
-	if (!(trans_support & PERFORMANT_MODE))
-		return;
-
 	h->nreply_queues = h->msix_vector > 0 ? h->msix_vector : 1;
 	hpsa_get_max_perf_mode_cmds(h);
 	/* Performant mode ring buffer and supporting data structures */
