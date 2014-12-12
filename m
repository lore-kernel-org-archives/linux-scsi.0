From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: T10-PI: Getting failed tag info
Date: Fri, 12 Dec 2014 15:15:20 -0800
Message-ID: <1418426120.10743.73.camel@haakon3.risingtidesystems.com>
References: <54892468.5060300@vlnb.net> <yq1r3w5blys.fsf@sermon.lab.mkp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.linux-iscsi.org ([67.23.28.174]:45112 "EHLO
	linux-iscsi.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753416AbaLLXPV (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 12 Dec 2014 18:15:21 -0500
In-Reply-To: <yq1r3w5blys.fsf@sermon.lab.mkp.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Vladislav Bolkhovitin <vst@vlnb.net>, linux-scsi@vger.kernel.org

On Thu, 2014-12-11 at 22:12 -0500, Martin K. Petersen wrote:
> >>>>> "Vlad" == Vladislav Bolkhovitin <vst@vlnb.net> writes:
> 
> Vlad,
> 
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
> 
> One thing that needs to be done is to make returning these new errors to
> userland conditional on !BIP_BLOCK_INTEGRITY. I'll put that on my list.
> 

Any chance this patch will be merged up soon..? 

I still need the same logic for IBLOCK backends to propagate up the
correct sense codes from bio completion in the event of GUARD check or
REF tag failure.

Also, AFAICT this patch still doesn't set the failed LBA, right..?
Any thoughts about the most sane way to get the failed LBA information
back to a caller like IBLOCK performing submission with bio + bip..?

--nab





