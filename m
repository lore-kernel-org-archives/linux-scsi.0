From: Bart Van Assche <bvanassche@acm.org>
Subject: Re: [PATCH 1/2] IB/srp: Fix SCSI scanning
Date: Mon, 20 Jun 2011 19:53:16 +0200
Message-ID: <BANLkTinVL6AVLipCwdeAbhZ1JY064KZOYA@mail.gmail.com>
References: <201106191348.24122.bvanassche@acm.org> <1308504469.14467.5.camel@obelisk.thedillows.org>
 <BANLkTi=5nBDB-SGd0U0UZDgR4gKBDqaj0w@mail.gmail.com> <20110620113736.GA406@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-vx0-f174.google.com ([209.85.220.174]:50903 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754003Ab1FTRxh convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 20 Jun 2011 13:53:37 -0400
In-Reply-To: <20110620113736.GA406@infradead.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: David Dillow <dillowda@ornl.gov>, linux-scsi@vger.kernel.org, linux-rdma@vger.kernel.org, Roland Dreier <roland@purestorage.com>, Brian King <brking@linux.vnet.ibm.com>

On Mon, Jun 20, 2011 at 1:37 PM, Christoph Hellwig <hch@infradead.org> =
wrote:
> We really shouldn't require workaround for this in every SCSI driver.
>
> scsi_scan_host_selected already makes sure never to scan above
> shost->max_channel. =A0Could it be that you don't have that one set
> properly in the srp driver? =A0It not we'll need to debug why it happ=
ens
> instead of adding hacks like this.

As far as I can see the default value for max_channel is zero. The patc=
h
below also avoids creation of duplicate SCSI targets on my setup.

Signed-off-by: Bart Van Assche <bvanassche@acm.org>

---
 drivers/infiniband/ulp/srp/ib_srp.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/infiniband/ulp/srp/ib_srp.c
b/drivers/infiniband/ulp/srp/ib_srp.c
index ee165fd..4ab1271 100644
--- a/drivers/infiniband/ulp/srp/ib_srp.c
+++ b/drivers/infiniband/ulp/srp/ib_srp.c
@@ -2127,6 +2127,7 @@ static ssize_t srp_create_target(struct device *d=
ev,
 		return -ENOMEM;

 	target_host->transportt  =3D ib_srp_transport_template;
+	target_host->max_id      =3D 1;
 	target_host->max_lun     =3D SRP_MAX_LUN;
 	target_host->max_cmd_len =3D sizeof ((struct srp_cmd *) (void *) 0L)-=
>cdb;

--=20
1.7.3.4
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
