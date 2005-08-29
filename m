From: Jeff Garzik <jgarzik@pobox.com>
Subject: Re: [RFC] SCSI EH document
Date: Mon, 29 Aug 2005 14:50:35 -0400
Message-ID: <431358FB.6050005@pobox.com>
References: <20050826035326.GA13392@htj.dyndns.org> <430F8AE0.7080806@pobox.com> <4312D213.9000402@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.dvmed.net ([216.237.124.58]:21954 "EHLO mail.dvmed.net")
	by vger.kernel.org with ESMTP id S1751298AbVH2Su6 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 29 Aug 2005 14:50:58 -0400
In-Reply-To: <4312D213.9000402@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Tejun Heo <htejun@gmail.com>
Cc: James.Bottomley@steeleye.com, luben_tuikov@adaptec.com, albertcc@tw.ibm.com, linux-scsi@vger.kernel.org

Tejun Heo wrote:
>> Both all the list-heads need to be cleared, otherwise there may be 
>> list corruption next time the element is added to the list_head.
>>
> 
>  scmd->eh_entry is never used as list head.  It's always used as list 
> entry.  So, technically, it needs not be cleared, I think.  No?  The 
> problem we had was w/ shost->eh_cmd_q not being cleared.

Every node is a list_head.  You want all pointers for all nodes pointing 
to something useful, even if they are not actively present on a list, so 
that they may be easily and corrected added to a list at a later time. 
Read list_del_init() for example.

	Jeff


