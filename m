From: Guido Guenther <agx@sigxcpu.org>
Subject: Re: EMC Symmetrix vs. no storage on LUN 0
Date: Fri, 28 Apr 2006 20:45:55 +0200
Message-ID: <20060428184555.GA4404@bogon.ms20.nix>
References: <20060427091322.GA19126@bogon.ms20.nix>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from honk1.physik.uni-konstanz.de ([134.34.140.224]:51337 "EHLO
	honk1.physik.uni-konstanz.de") by vger.kernel.org with ESMTP
	id S1751439AbWD1Szk convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 28 Apr 2006 14:55:40 -0400
Received: from localhost (localhost.localnet [127.0.0.1])
	by honk1.physik.uni-konstanz.de (Postfix) with ESMTP id DA2BC3A993
	for <linux-scsi@vger.kernel.org>; Fri, 28 Apr 2006 20:55:39 +0200 (CEST)
Received: from honk1.physik.uni-konstanz.de ([127.0.0.1])
	by localhost (honk [127.0.0.1]) (amavisd-new, port 10024) with ESMTP
	id 08951-47 for <linux-scsi@vger.kernel.org>;
	Fri, 28 Apr 2006 20:55:32 +0200 (CEST)
Received: from bogon.sigxcpu.org (xdsl-87-78-23-63.netcologne.de [87.78.23.63])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by honk1.physik.uni-konstanz.de (Postfix) with ESMTP id E07223A992
	for <linux-scsi@vger.kernel.org>; Fri, 28 Apr 2006 20:55:31 +0200 (CEST)
Content-Disposition: inline
In-Reply-To: <20060427091322.GA19126@bogon.ms20.nix>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

On Thu, Apr 27, 2006 at 11:13:22AM +0200, Guido Guenther wrote:
> we have a rather old EMC Symmetrix which always has a peripheral
> qualifier of 001b on LUN0. This has the problem that the
> scsi_probe_and_add_lun code bails out to out_free_result: before we
> apply the device flags (that we got from scsi_probe_lun just before this
> check) to bflagsp. The result is that (without these flags) we stop
[..snip..] 
The previously attached patch has the issue that we add a device though
not actually present just to safe the bflags. This version should do
better:

--- orig/linux-2.6.16.7/drivers/scsi/scsi_scan.c	2006-03-20 06:53:29.000000000 +0100
+++ linux-2.6.16.7/drivers/scsi/scsi_scan.c	2006-04-28 20:38:01.000000000 +0200
@@ -868,6 +868,12 @@ static int scsi_probe_and_add_lun(struct
 					"scsi scan: peripheral qualifier of 3,"
 					" no device added\n"));
 		res = SCSI_SCAN_TARGET_PRESENT;
+
+		/* don't discard the already fetched bflags for lun 0 so
+		 * __scsi_scan_target knows about them */
+		if (bflagsp && lun == 0)
+			*bflagsp = bflags;
+	   	
 		goto out_free_result;
 	}
 
Signed-Off-By: Guido Guenther <agx@sigxcpu.org>
Cheers,
 -- Guido
