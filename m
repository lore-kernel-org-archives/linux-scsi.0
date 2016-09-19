From: Tyrel Datwyler <turtle.in.the.kernel@gmail.com>
Subject: Re: [PATCH 1/1] ibmvfc: Fix I/O hang when port is not mapped
Date: Mon, 19 Sep 2016 09:14:48 -0700
Message-ID: <d37a6e14-9585-1db7-8ab6-ebf2ce7aae44@gmail.com>
References: <20160919135919.689C528041@b01ledav001.gho.pok.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-qt0-f175.google.com ([209.85.216.175]:35918 "EHLO
        mail-qt0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751015AbcISQOw (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 19 Sep 2016 12:14:52 -0400
Received: by mail-qt0-f175.google.com with SMTP id l91so73880056qte.3
        for <linux-scsi@vger.kernel.org>; Mon, 19 Sep 2016 09:14:52 -0700 (PDT)
In-Reply-To: <20160919135919.689C528041@b01ledav001.gho.pok.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Brian King <brking@linux.vnet.ibm.com>, James.Bottomley@HansenPartnership.com
Cc: martin.petersen@oracle.com, linux-scsi@vger.kernel.org, tyreld@linux.vnet.ibm.com

On 09/19/2016 06:59 AM, Brian King wrote:
> If a VFC port gets unmapped in the VIOS, it may not respond with a CRQ init
> complete following H_REG_CRQ. If this occurs, we can end up having called
> scsi_block_requests and not a resulting unblock until the init complete
> happens, which may never occur, and we end up hanging I/O requests.
> This patch ensures the host action stay set to IBMVFC_HOST_ACTION_TGT_DEL so
> we move all rports into devloss state and unblock unless we receive an
> init complete. 
> 
> Signed-off-by: Brian King <brking@linux.vnet.ibm.com>

Acked-by: Tyrel Datwyler <tyreld@linux.vnet.ibm.com>

