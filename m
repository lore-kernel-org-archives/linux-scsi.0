From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: [patch 6/8] mptfusion: fc transport
Date: 25 Nov 2004 14:54:32 -0600
Message-ID: <1101416079.1717.26.camel@mulgrave>
References: <91888D455306F94EBD4D168954A9457C5468AD@nacos172.co.lsil.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from zeus.kernel.org ([204.152.189.113]:42947 "EHLO zeus.kernel.org")
	by vger.kernel.org with ESMTP id S262449AbUKZTar (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 26 Nov 2004 14:30:47 -0500
Received: from hancock.sc.steeleye.com (stat16.steeleye.com [209.192.50.48])
	by zeus.kernel.org (8.12.11/8.11.6) with ESMTP id iAPLHstK029141
	for <linux-scsi@vger.kernel.org>; Thu, 25 Nov 2004 13:17:55 -0800
In-Reply-To: <91888D455306F94EBD4D168954A9457C5468AD@nacos172.co.lsil.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Moore, Eric Dean" <Eric.Moore@lsil.com>
Cc: SCSI Mailing List <linux-scsi@vger.kernel.org>

On Fri, 2004-11-19 at 09:39, Moore, Eric Dean wrote:
> This provides fc_transport support, exporting
> port_id, port_name, node_name.

This:

@@ -4,6 +4,7 @@
 config FUSION
        tristate "Fusion MPT (base + ScsiHost) drivers"
        depends on PCI && SCSI
+        select SCSI_FC_ATTRS
        ---help---

Doesn't look correct.  It will force the FC attrs to be built even if
you're only building for a purely SPI device.  Worse, module
dependencies will force the FC transport to load even if you're only
attaching to a SCSI device.  This isn't really optimal, especially as
the FC transport class is growing in size now.

How difficult would it be to separate out the scsi and FC pieces of the
fusion driver, so we could allow more fined grained control of this?

James


