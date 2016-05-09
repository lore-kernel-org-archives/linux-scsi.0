From: Dan Carpenter <dan.carpenter@oracle.com>
Subject: Re: [PATCH] megaraid: add scsi_cmnd NULL check before use
Date: Mon, 9 May 2016 11:05:51 +0300
Message-ID: <20160509080551.GH29510@mwanda>
References: <1462668011.32105.7.camel@petros-ultrathin>
 <alpine.LNX.2.00.1605081235490.19865@nippy.intranet>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:49444 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751729AbcEIIGS (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 9 May 2016 04:06:18 -0400
Content-Disposition: inline
In-Reply-To: <alpine.LNX.2.00.1605081235490.19865@nippy.intranet>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Finn Thain <fthain@telegraphics.com.au>
Cc: Petros Koutoupis <petros@petroskoutoupis.com>, kashyap.desai@avagotech.com, sumit.saxena@avagotech.com, uday.lingala@avagotech.com, megaraidlinux.pdl@avagotech.com, linux-scsi@vger.kernel.org

Smatch doesn't quite catch it because we check "cmd_fusion->scmd" for
NULL then assign "scmd_local = cmd_fusion->scmd;" and dereference
scmd_local unconditionally...

It does catch part of the bug if you have cross function analysis:

  drivers/scsi/megaraid/megaraid_sas_fusion.c:2318 complete_cmd_fusion()
  error: we previously assumed 'cmd_fusion->scmd' could be null (see line 2281)

But that code was from 2010 so I never reported it to the original
author or the list.

regards,
dan carpenter

