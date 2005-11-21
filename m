From: Brian King <brking@us.ibm.com>
Subject: Re: aic7xxx support for >2TB volumes?
Date: Mon, 21 Nov 2005 09:27:17 -0600
Message-ID: <4381E755.5060607@us.ibm.com>
References: <200511161208.02374.kilian.cavalotti@lip6.fr> <200511211109.19490.kilian.cavalotti@lip6.fr> <4381DE2B.8060509@us.ibm.com> <200511211609.47828.kilian.cavalotti@lip6.fr>
Reply-To: brking@us.ibm.com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e3.ny.us.ibm.com ([32.97.182.143]:10950 "EHLO e3.ny.us.ibm.com")
	by vger.kernel.org with ESMTP id S1750786AbVKUP1T (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 21 Nov 2005 10:27:19 -0500
Received: from d01relay04.pok.ibm.com (d01relay04.pok.ibm.com [9.56.227.236])
	by e3.ny.us.ibm.com (8.12.11/8.12.11) with ESMTP id jALFRIMt016967
	for <linux-scsi@vger.kernel.org>; Mon, 21 Nov 2005 10:27:18 -0500
Received: from d01av01.pok.ibm.com (d01av01.pok.ibm.com [9.56.224.215])
	by d01relay04.pok.ibm.com (8.12.10/NCO/VERS6.8) with ESMTP id jALFRIZ8119432
	for <linux-scsi@vger.kernel.org>; Mon, 21 Nov 2005 10:27:18 -0500
Received: from d01av01.pok.ibm.com (loopback [127.0.0.1])
	by d01av01.pok.ibm.com (8.12.11/8.13.3) with ESMTP id jALFRHXN021115
	for <linux-scsi@vger.kernel.org>; Mon, 21 Nov 2005 10:27:18 -0500
In-Reply-To: <200511211609.47828.kilian.cavalotti@lip6.fr>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Kilian CAVALOTTI <kilian.cavalotti@lip6.fr>
Cc: linux-scsi@vger.kernel.org

Kilian CAVALOTTI wrote:
> On Monday 21 November 2005 15:48, Brian King wrote:
> 
>>Quite possibly. Looking at ahc_linux_run_command in aic7xxx_osm.c it
>>appears that commands with a cdb length of > 12 are sent to the adapter in
>>a different way. 
> 
> 
> Do you mean: ?
>         hscb->cdb_len = cmd->cmd_len;
>         if (hscb->cdb_len <= 12) {
>                 memcpy(hscb->shared_data.cdb, cmd->cmnd, hscb->cdb_len);
>         } else {
>                 memcpy(hscb->cdb32, cmd->cmnd, hscb->cdb_len);
>                 scb->flags |= SCB_CDB32_PTR;
>         }

Yes.

>>Perhaps this method does not work on the card you have. 
> 
> 
> Isn't there a way to determine if the HBA has an hardware limitation, or the 
> size of the max command length it accepts?

I've never seen a hardware spec for these adapters, so I can't really comment.
Hopefully someone else on the list can help on this one...


-- 
Brian King
eServer Storage I/O
IBM Linux Technology Center
