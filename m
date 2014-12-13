From: Vladislav Bolkhovitin <vst@vlnb.net>
Subject: Re: T10-PI: Getting failed tag info
Date: Fri, 12 Dec 2014 19:57:05 -0800
Message-ID: <548BB911.6090905@vlnb.net>
References: <54892468.5060300@vlnb.net> <yq1r3w5blys.fsf@sermon.lab.mkp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mout.kundenserver.de ([212.227.126.130]:64510 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964951AbaLMD5Z (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 12 Dec 2014 22:57:25 -0500
In-Reply-To: <yq1r3w5blys.fsf@sermon.lab.mkp.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org

Martin K. Petersen wrote on 12/11/2014 07:12 PM:
>>>>>> "Vlad" == Vladislav Bolkhovitin <vst@vlnb.net> writes:
> Vlad> We are currently developing a SCSI target system with T10-PI. We
> Vlad> are using block integrity interface and found a problem that this
> Vlad> interface fundamentally can not pass Oracle T10-PI certification
> Vlad> tests. Those tests require to receive on the initiator side
> Vlad> information about which particular tag failed the target checks,
> Vlad> but the block integrity interface does not preserve this
> Vlad> information, hence the target can not deliver it to the initiator
> Vlad> => certification failure. The storage provides the right sense,
> Vlad> but then in scsi_io_completion() it is dropped and replaced by a
> Vlad> single EILSEQ.
> 
> Vlad> What would be the best way to fix that? By making a patch
> Vlad> introducing new -EXXXXXX error codes for the PI errors?
> 
> I posted such a patch a while back. We use that in our qualification
> tooling to ensure that the right things are reported when a PI error is
> injected at various places in the stack.

Thanks, this is exactly what is needed.

Reviewed-by: Vladislav Bolkhovitin <vst@vlnb.net>

> One thing that needs to be done is to make returning these new errors to
> userland conditional on !BIP_BLOCK_INTEGRITY. I'll put that on my list.

Ever without it this patch is quite valuable.

Vlad


