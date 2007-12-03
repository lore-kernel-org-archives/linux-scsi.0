From: "Darrick J. Wong" <djwong@us.ibm.com>
Subject: Re: aic94xx or libsas crash on X7DB3 supermicro with enclosure and
	sata drives
Date: Mon, 3 Dec 2007 13:31:48 -0800
Message-ID: <20071203213148.GC7066@tree.beaverton.ibm.com>
References: <200711301022.08001.kb@sysmikro.com.pl> <20071130213313.GA7066@tree.beaverton.ibm.com> <200712031709.54168.kb@sysmikro.com.pl> <20071203193652.GB7066@tree.beaverton.ibm.com> <47545C4D.1070708@garzik.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e2.ny.us.ibm.com ([32.97.182.142]:54902 "EHLO e2.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750937AbXLCVcS (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 3 Dec 2007 16:32:18 -0500
Received: from d01relay04.pok.ibm.com (d01relay04.pok.ibm.com [9.56.227.236])
	by e2.ny.us.ibm.com (8.13.8/8.13.8) with ESMTP id lB3LWDeN018592
	for <linux-scsi@vger.kernel.org>; Mon, 3 Dec 2007 16:32:13 -0500
Received: from d01av03.pok.ibm.com (d01av03.pok.ibm.com [9.56.224.217])
	by d01relay04.pok.ibm.com (8.13.8/8.13.8/NCO v8.7) with ESMTP id lB3LWDv6138766
	for <linux-scsi@vger.kernel.org>; Mon, 3 Dec 2007 16:32:13 -0500
Received: from d01av03.pok.ibm.com (loopback [127.0.0.1])
	by d01av03.pok.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id lB3LWCks002653
	for <linux-scsi@vger.kernel.org>; Mon, 3 Dec 2007 16:32:13 -0500
Content-Disposition: inline
In-Reply-To: <47545C4D.1070708@garzik.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jeff Garzik <jeff@garzik.org>
Cc: Krzysztof B??aszkowski <kb@sysmikro.com.pl>, linux-scsi@vger.kernel.org, vst@vlnb.net, Alexis Bruemmer <alexisb@us.ibm.com>

On Mon, Dec 03, 2007 at 02:43:09PM -0500, Jeff Garzik wrote:

> But what do you mean by "device removal code can get hung up"?  That sounds 
> like a bug we should fix.

At the moment, libsas' sas_rphy_remove function doesn't distinguish between
removing a device before or after the disk has been disconnected.
Hence, sd_shutdown tries to tell the disk to flush the write cache, even
in the case that the disk is already gone.  Maybe the solution is to
modify aic94xx to remove the device's DDB registration prior to sending
the "device gone" event to libsas so that all subsequent commands bounce
with "no such device" instead of going out to lunch.

(I'll look into this later, as I myself am going out to lunch right now.)

--D
