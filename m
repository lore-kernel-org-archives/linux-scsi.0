From: Arne Redlich <arne.redlich@xiranet.com>
Subject: Re: [PATCH] srp.h: avoid padding of structs
Date: Fri, 28 Apr 2006 16:53:25 +0200
Message-ID: <1146236005.13938.12.camel@confield.dd.xiranet.com>
References: <20060416193443.GA1806@cheetah> <20060417091752.GA2947@cheetah>
	 <adavet6j2cs.fsf_-_@cisco.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.126.183]:21231 "EHLO
	moutng.kundenserver.de") by vger.kernel.org with ESMTP
	id S1030419AbWD1Oxc (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 28 Apr 2006 10:53:32 -0400
In-Reply-To: <adavet6j2cs.fsf_-_@cisco.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@SteelEye.com
Cc: linux-scsi@vger.kernel.org, Roland Dreier <rdreier@cisco.com>

Am Dienstag, den 18.04.2006, 09:05 -0700 schrieb Roland Dreier:
> Thanks for pointing out this problem.  However I don't think we should
> pack every structure in the file, because packing structures that
> don't need it leads to gcc generating horrible code on architectures
> like ia64.  I'd prefer something like the following.
> 
> James, can you queue this up?  I'd be happy to merge it through my
> tree but it seems more appropriate for it to go through the SCSI tree.
> It's probably 2.6.17 material at this point in the cycle.
> 
> Thanks,
>   Roland
> 
> 
> 
> Several structs in <scsi/srp.h> get padded to a multiple of 8 bytes on
> 64-bit architectures and end up with a size that does not match the
> definition in the SRP spec:
> 
>                                      SRP spec     64-bit
>     sizeof (struct indirect_buf)        20          24
>     sizeof (struct srp_login_rsp)       52          56
>     sizeof (struct srp_rsp)             36          40
> 
> Fix this by adding __attribute__((packed)) to the offending structs.
> 
> Problem pointed out by Arne Redlich <arne.redlich@xiranet.com>.
> 
> Signed-off-by: Roland Dreier <rolandd@cisco.com>

James,

since this one isn't in scsi-rc-fixes-2.6 yet and you didn't comment on
it, either, I assume you missed this one:

http://marc.theaimsgroup.com/?l=linux-scsi&m=114537635902712&w=2

Arne
-- 
Arne Redlich
Xiranet Communications GmbH

