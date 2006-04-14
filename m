From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: [PATCH 2/3] - mpt fusion -
Date: Fri, 14 Apr 2006 09:47:59 -0500
Message-ID: <1145026079.3520.12.camel@mulgrave.il.steeleye.com>
References: <664A4EBB07F29743873A87CF62C26D70080B51@NAMAIL4.ad.lsil.com>
	 <20060414010405.GB23580@infradead.org>
	 <002c01c65f69$319745c0$201015ac@ericmoore>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat9.steeleye.com ([209.192.50.41]:6090 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S964960AbWDNOsF (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 14 Apr 2006 10:48:05 -0400
In-Reply-To: <002c01c65f69$319745c0$201015ac@ericmoore>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Moore, Eric" <Eric.Moore@lsil.com>
Cc: Christoph Hellwig <hch@infradead.org>, linux-scsi@vger.kernel.org

On Thu, 2006-04-13 at 20:14 -0600, Moore, Eric wrote:
> Christoph can you help me on this, please?
> The original sas_rphy_add() function from three weeks back works for mptsas.
> I'm not sure why that change was made, and whether reverting back to its orginal code
> would break the other sas driver.  

Does this fix the problem?

James

diff --git a/drivers/scsi/scsi_transport_sas.c b/drivers/scsi/scsi_transport_sas.c
index 2c96fc5..8b6d65e 100644
--- a/drivers/scsi/scsi_transport_sas.c
+++ b/drivers/scsi/scsi_transport_sas.c
@@ -845,6 +845,8 @@ int sas_rphy_add(struct sas_rphy *rphy)
 	    (identify->target_port_protocols &
 	     (SAS_PROTOCOL_SSP|SAS_PROTOCOL_STP|SAS_PROTOCOL_SATA)))
 		rphy->scsi_target_id = sas_host->next_target_id++;
+	else if (identify->device_type == SAS_END_DEVICE)
+		rphy->scsi_target_id = -1;
 	mutex_unlock(&sas_host->lock);
 
 	if (identify->device_type == SAS_END_DEVICE &&


