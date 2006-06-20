From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: RE: [PATCH] scsi_transport_sas: introduce a sas_port entity
Date: Tue, 20 Jun 2006 16:43:48 -0500
Message-ID: <1150839828.2531.31.camel@mulgrave.il.steeleye.com>
References: <664A4EBB07F29743873A87CF62C26D7019A05F@NAMAIL4.ad.lsil.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat9.steeleye.com ([209.192.50.41]:6632 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S1751213AbWFTVnw (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 20 Jun 2006 17:43:52 -0400
In-Reply-To: <664A4EBB07F29743873A87CF62C26D7019A05F@NAMAIL4.ad.lsil.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Moore, Eric" <Eric.Moore@lsil.com>
Cc: linux-scsi <linux-scsi@vger.kernel.org>

On Tue, 2006-06-20 at 13:11 -0600, Moore, Eric wrote:
> Stack traceback for pid 7313
> 0xffff81001e111040     7313     7300  1    1   R  0xffff81001e111370
> *insmod
> RSP           RIP                Function (args)
> 0xffff810006e61b60 0xffffffff802645cc
> attribute_container_device_trigger+0x49 (0xffff81000e06c488,
> 0xffff81000927b8c0, 0xffff81000e06c4e0)
> 0xffff810006e61b78 0xffffffff802645cf
> attribute_container_device_trigger+0x4c (0xffff8100041c11d8,
> 0xffff8100041c11d8, 0xffff8100041c1000, 0x0, 0xffff8100041c11d8)
> 0xffff810006e61b98 0xffffffff802643a0
> attribute_container_add_device+0x57 (0xffffffffffffffff,
> 0xffffffffffffffff, 0xffff81001e4f1090, 0xffff81001e4f0ed0,

Oh, this one's actually quite simple: the phys aren't being deleted from
the expander.  Try this fix:

James

diff --git a/drivers/scsi/scsi_transport_sas.c b/drivers/scsi/scsi_transport_sas.c
index 2a5899d..e79d6d3 100644
--- a/drivers/scsi/scsi_transport_sas.c
+++ b/drivers/scsi/scsi_transport_sas.c
@@ -1176,7 +1176,7 @@ sas_rphy_delete(struct sas_rphy *rphy)
 		break;
 	case SAS_EDGE_EXPANDER_DEVICE:
 	case SAS_FANOUT_EXPANDER_DEVICE:
-		device_for_each_child(dev, NULL, do_sas_phy_delete);
+		sas_remove_children(dev);
 		break;
 	default:
 		break;


