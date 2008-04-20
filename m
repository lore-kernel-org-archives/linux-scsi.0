From: David Miller <davem@davemloft.net>
Subject: Re: esp_scsi incorrect unsigned test
Date: Sat, 19 Apr 2008 17:59:13 -0700 (PDT)
Message-ID: <20080419.175913.166084026.davem@davemloft.net>
References: <Pine.LNX.4.64.0804182101200.14832@ask.diku.dk>
	<20080419140555.GJ20637@parisc-linux.org>
	<1208614598.3280.11.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:40086
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1752776AbYDTA7M (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sat, 19 Apr 2008 20:59:12 -0400
In-Reply-To: <1208614598.3280.11.camel@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com
Cc: matthew@wil.cx, julia@diku.dk, linux-scsi@vger.kernel.org, 12o3l@tiscali.nl, kernel-janitors@vger.kernel.org, kernelnewbies-bounce@nl.linux.org

From: James Bottomley <James.Bottomley@HansenPartnership.com>
Date: Sat, 19 Apr 2008 09:16:38 -0500

> It look fine to me ... although an alternative (and possibly simpler)
> fix would just be to remove the unsigned from the two residue
> definitions in the struct.

I think that's the better approach too.  James, please
apply.

esp_scsi: Make cur_residue and tot_residue signed.

Many of the overflow checks test whether the value has
gone negative, and we want to retain such checks.

Reported by Julia Lawall.

Signed-off-by: David S. Miller <davem@davemloft.net>

diff --git a/drivers/scsi/esp_scsi.h b/drivers/scsi/esp_scsi.h
index d5576d5..9367a88 100644
--- a/drivers/scsi/esp_scsi.h
+++ b/drivers/scsi/esp_scsi.h
@@ -240,9 +240,9 @@ struct esp_cmd_priv {
 		int		num_sg;
 	} u;
 
-	unsigned int		cur_residue;
+	int			cur_residue;
 	struct scatterlist	*cur_sg;
-	unsigned int		tot_residue;
+	int			tot_residue;
 };
 #define ESP_CMD_PRIV(CMD)	((struct esp_cmd_priv *)(&(CMD)->SCp))
 
