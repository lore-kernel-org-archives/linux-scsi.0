From: Manoj Kumar <manoj@linux.vnet.ibm.com>
Subject: Re: [PATCH 2/5] ipr: Clear NO_ULEN_CHK bit when resource is a vset.
Date: Fri, 30 Oct 2015 12:52:24 -0500
Message-ID: <5633AE58.2060002@linux.vnet.ibm.com>
References: <1446223749-17416-1-git-send-email-krisman@linux.vnet.ibm.com>
 <1446223749-17416-2-git-send-email-krisman@linux.vnet.ibm.com>
Reply-To: manoj@linux.vnet.ibm.com
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e18.ny.us.ibm.com ([129.33.205.208]:42548 "EHLO
	e18.ny.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759478AbbJ3RwD (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 30 Oct 2015 13:52:03 -0400
Received: from localhost
	by e18.ny.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-scsi@vger.kernel.org> from <manoj@linux.vnet.ibm.com>;
	Fri, 30 Oct 2015 13:52:03 -0400
Received: from b01cxnp23032.gho.pok.ibm.com (b01cxnp23032.gho.pok.ibm.com [9.57.198.27])
	by d01dlp01.pok.ibm.com (Postfix) with ESMTP id 53A5E38C8039
	for <linux-scsi@vger.kernel.org>; Fri, 30 Oct 2015 13:52:00 -0400 (EDT)
Received: from d01av04.pok.ibm.com (d01av04.pok.ibm.com [9.56.224.64])
	by b01cxnp23032.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id t9UHq0hj61866010
	for <linux-scsi@vger.kernel.org>; Fri, 30 Oct 2015 17:52:00 GMT
Received: from d01av04.pok.ibm.com (localhost [127.0.0.1])
	by d01av04.pok.ibm.com (8.14.4/8.14.4/NCO v10.0 AVout) with ESMTP id t9UHpxX2028992
	for <linux-scsi@vger.kernel.org>; Fri, 30 Oct 2015 13:51:59 -0400
In-Reply-To: <1446223749-17416-2-git-send-email-krisman@linux.vnet.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Gabriel Krisman Bertazi <krisman@linux.vnet.ibm.com>, linux-scsi@vger.kernel.org
Cc: brking@linux.vnet.ibm.com, wenxiong@linux.vnet.ibm.com

On 10/30/2015 11:49 AM, Gabriel Krisman Bertazi wrote:
>
>   	if (ipr_is_gscsi(res) || ipr_is_vset_device(res)) {
> -		if (scsi_cmd->underflow == 0)
> +		if (scsi_cmd->underflow == 0 && !ipr_is_vset_device(res))

This section is getting quite convoluted. If there isn't really that
much common between ipr_is_gscsi(res) and ipr_is_vset_device(res)
anymore, it would read much better as distinct segments:

if (ipr_is_gscsi(res))
...
if (ipr_is_vset_devices(res))
...

This will avoid having multiple calls to ipr_is_gscsi() and
ipr_is_vset_device() in the same section of code.

---
Manoj Kumar

