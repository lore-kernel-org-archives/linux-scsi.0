From: Julia Lawall <Julia.Lawall-L2FTfq7BK8M@public.gmane.org>
Subject: [PATCH 0/8] reduce indentation
Date: Sun, 30 Dec 2018 16:53:07 +0100
Message-ID: <1546185195-25676-1-git-send-email-Julia.Lawall@lip6.fr>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <iommu-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
List-Unsubscribe: <https://lists.linuxfoundation.org/mailman/options/iommu>,
	<mailto:iommu-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.linuxfoundation.org/pipermail/iommu/>
List-Post: <mailto:iommu-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
List-Help: <mailto:iommu-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=help>
List-Subscribe: <https://lists.linuxfoundation.org/mailman/listinfo/iommu>,
	<mailto:iommu-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=subscribe>
Sender: iommu-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org
Errors-To: iommu-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org
To: freedreno-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org
Cc: devel-gWbeCf7V1WCQmaza687I9mD2FQJk+8+b@public.gmane.org, linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Zorik Machulsky <zorik-vV1OtcyAfmbQT0dZR+AlfA@public.gmane.org>, linux-arm-msm-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-usb-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kernel-janitors-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, dri-devel-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org, iommu-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org, intel-wired-lan-qjLDD68F18P21nG7glBr7A@public.gmane.org, netdev-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Saeed Bishara <saeedb-vV1OtcyAfmbQT0dZR+AlfA@public.gmane.org>
List-Id: linux-scsi@vger.kernel.org

These patches fix cases where a subsequent statement is aligned
with the right hand side of an assignment rather than the left
hand side.  This was done using the following semantic match
(http://coccinelle.lip6.fr/).  It has a lot of false positives,
because Coccinelle doesn't record the difference between a space
and a tab, but these issues are easy to skip over.

// <smpl>
@r@
expression x,e;
statement S;
position p0,p1,p2;
@@
x@p0 = e@p1;
S@p2

@script:ocaml@
p0 << r.p0;
p1 << r.p1;
p2 << r.p2;
@@
if ((List.hd p0).col < (List.hd p1).col &&
    (List.hd p1).col = (List.hd p2).col)
then Coccilib.print_main "" p1
// </smpl>

---

 drivers/firmware/stratix10-svc.c              |   12 ++++++------
 drivers/gpu/drm/msm/dsi/phy/dsi_phy.c         |    2 +-
 drivers/iommu/msm_iommu.c                     |    8 ++++----
 drivers/net/ethernet/amazon/ena/ena_eth_com.c |    4 ++--
 drivers/net/ethernet/intel/i40e/i40e_main.c   |    2 +-
 drivers/scsi/pm8001/pm8001_sas.c              |    2 +-
 drivers/staging/rtl8192e/rtl8192e/rtl_wx.c    |    6 +++---
 drivers/usb/gadget/udc/snps_udc_core.c        |   17 ++++++++---------
 8 files changed, 26 insertions(+), 27 deletions(-)
