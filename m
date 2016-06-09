From: James Bottomley <jejb@linux.vnet.ibm.com>
Subject: Re: [PATCH v3] storvsc: use small sg_tablesize on x86
Date: Thu, 09 Jun 2016 10:25:59 -0700
Message-ID: <1465493159.2259.14.camel@linux.vnet.ibm.com>
References: <20160609162553.10290-1-olaf@aepfle.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:58619 "EHLO
	mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751393AbcFIR0K (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 9 Jun 2016 13:26:10 -0400
Received: from pps.filterd (m0098421.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.16.0.11/8.16.0.11) with SMTP id u59HNmB3077783
	for <linux-scsi@vger.kernel.org>; Thu, 9 Jun 2016 13:26:09 -0400
Received: from e33.co.us.ibm.com (e33.co.us.ibm.com [32.97.110.151])
	by mx0a-001b2d01.pphosted.com with ESMTP id 23e9m51ym2-1
	(version=TLSv1.2 cipher=AES256-SHA bits=256 verify=NOT)
	for <linux-scsi@vger.kernel.org>; Thu, 09 Jun 2016 13:26:09 -0400
Received: from localhost
	by e33.co.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-scsi@vger.kernel.org> from <jejb@linux.vnet.ibm.com>;
	Thu, 9 Jun 2016 11:26:08 -0600
In-Reply-To: <20160609162553.10290-1-olaf@aepfle.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Olaf Hering <olaf@aepfle.de>, "K. Y. Srinivasan" <kys@microsoft.com>, Haiyang Zhang <haiyangz@microsoft.com>, "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: devel@linuxdriverproject.org, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org

On Thu, 2016-06-09 at 18:25 +0200, Olaf Hering wrote:
> Reducing the sg_tablesize allows booting of 32bit kernels in VMs,
> after
> commit be0cf6ca301c61458dc4aa1a37acf4f58d2ed3d6 ("scsi: storvsc: Set
> the
> tablesize based on the information given by the host")
> 
> [    5.567138] hv_storvsc vmbus_1: adjusting sg_tablesize 0x800 -> 
> 0x20

Are you really sure 32 is the correct size?  That caps transfers at 128
k.  Even in the dim, dark, pre-64bit (at least on x86) days, our static
limit for sg tablesize was 128 (0.5M).

I know 32 it what it had before, but the reason for the commit you
quote was to improve performance ...

James

