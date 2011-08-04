From: "Nandigama, Nagalakshmi" <Nagalakshmi.Nandigama@lsi.com>
Subject: RE: [PATCH 2/11] drivers/message/fusion/mptsas.c: trivial: use
 BUG_ON
Date: Thu, 4 Aug 2011 12:24:50 +0530
Message-ID: <A6888A6805518E4EA4AF7072A28264A6042ABC7D09@inbmail02.lsi.com>
References: <1312281304-11847-1-git-send-email-julia@diku.dk>
 <1312281304-11847-3-git-send-email-julia@diku.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from na3sys009aog108.obsmtp.com ([74.125.149.199]:40838 "EHLO
	na3sys009aog108.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750934Ab1HDGyQ convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 4 Aug 2011 02:54:16 -0400
In-Reply-To: <1312281304-11847-3-git-send-email-julia@diku.dk>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Julia Lawall <julia@diku.dk>, "Moore, Eric" <Eric.Moore@lsi.com>, "trivial@kernel.org" <trivial@kernel.org>
Cc: "kernel-janitors@vger.kernel.org" <kernel-janitors@vger.kernel.org>, Support <support@lsi.com>, DL-MPT Fusion Linux <DL-MPTFusionLinux@lsi.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>

The patch seem to be fine. Please consider this patch as an Acked by me

Regards,
Nagalakshmi


-----Original Message-----
From: Julia Lawall [mailto:julia@diku.dk] 
Sent: Tuesday, August 02, 2011 4:05 PM
To: Moore, Eric; trivial@kernel.org
Cc: kernel-janitors@vger.kernel.org; Support; DL-MPT Fusion Linux; linux-scsi@vger.kernel.org; linux-kernel@vger.kernel.org
Subject: [PATCH 2/11] drivers/message/fusion/mptsas.c: trivial: use BUG_ON

From: Julia Lawall <julia@diku.dk>

Use BUG_ON(x) rather than if(x) BUG();

The semantic patch that fixes this problem is as follows:
(http://coccinelle.lip6.fr/)

// <smpl>
@@ identifier x; @@
-if (x) BUG();
+BUG_ON(x);

@@ identifier x; @@
-if (!x) BUG();
+BUG_ON(!x);
// </smpl>

Signed-off-by: Julia Lawall <julia@diku.dk>

---
 drivers/message/fusion/mptsas.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff -u -p a/drivers/message/fusion/mptsas.c b/drivers/message/fusion/mptsas.c
--- a/drivers/message/fusion/mptsas.c
+++ b/drivers/message/fusion/mptsas.c
@@ -3410,8 +3410,7 @@ mptsas_expander_event_add(MPT_ADAPTER *i
 	__le64 sas_address;
 
 	port_info = kzalloc(sizeof(struct mptsas_portinfo), GFP_KERNEL);
-	if (!port_info)
-		BUG();
+	BUG_ON(!port_info);
 	port_info->num_phys = (expander_data->NumPhys) ?
 	    expander_data->NumPhys : 1;
 	port_info->phy_info = kcalloc(port_info->num_phys,

