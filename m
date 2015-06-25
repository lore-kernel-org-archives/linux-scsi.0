From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: configurable discard parameters
Date: Wed, 24 Jun 2015 21:15:40 -0400
Message-ID: <yq1fv5g37wj.fsf@sermon.lab.mkp.net>
References: <CAGnHSEmDQ6xaJsw9i=v23BffWQ8RncrgNBsGWy3ziC36QK+9yQ@mail.gmail.com>
	<yq1fv5l9ajd.fsf@sermon.lab.mkp.net>
	<CAGnHSEk+=r1CwQaGd9n4nUm3_e3O7GOL_iFDeJTuNyaSq9WFYg@mail.gmail.com>
	<CAGnHSEnevg=advtq=CW2FvV5b93GX3kNwrFu587O2V7hf1J8hA@mail.gmail.com>
	<CAGnHSEnBvgWKw6g=c4vpCNEfpdh_45orz5JcSmfM7jadxjpxzQ@mail.gmail.com>
	<CAGnHSEnLACL6XisaFn3axRETAD3CjOa7fGrHKR7s6GOroQXkew@mail.gmail.com>
	<yq1616f796w.fsf@sermon.lab.mkp.net>
	<CAGnHSEn4EPC_RHTJXtvFC8dj8L+aDd_pRvSsDWNaqHz3Tdxj5w@mail.gmail.com>
	<yq1bng65te8.fsf@sermon.lab.mkp.net>
	<CAGnHSEm89yFPPTVUtbk1s84wanKK6RTY5hdZCMdbw+a+vwecDA@mail.gmail.com>
	<yq1mvzq4at7.fsf@sermon.lab.mkp.net>
	<CAGnHSEkF+uXh2=wpq9dwjK8_NrjF5kqcasXeuCF_=TONu6Q7Cw@mail.gmail.com>
	<yq1egl246yd.fsf@sermon.lab.mkp.net>
	<CAGnHSEnJ=_NV8Ed_=Ykr+30C+YSLFDPzyzeSY9b4p6pyaNOE4A@mail.gmail.com>
	<yq1616d4xxe.fsf@sermon.lab.mkp.net>
	<CAGnHSEk_PoY=UQXrcEeBVpWBJApsUcySKSRnHuLM5vOdC429Eg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:44204 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751614AbbFYBPo (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 24 Jun 2015 21:15:44 -0400
In-Reply-To: <CAGnHSEk_PoY=UQXrcEeBVpWBJApsUcySKSRnHuLM5vOdC429Eg@mail.gmail.com>
	(Tom Yan's message of "Wed, 24 Jun 2015 20:46:02 +0800")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Tom Yan <tom.ty89@gmail.com>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org

>>>>> "Tom" == Tom Yan <tom.ty89@gmail.com> writes:

Tom> First of all it wouldn't really solve problem for all devices which
Tom> have different limits.

Only by virtue of us generally aligning on large power of two
boundaries.

The only reason I am entertaining this in the first place is that I have
one drive that behaves in a way similar to yours. And if we can make
things slightly better (but not perfect) for several drives without
causing any regressions then that's worth exploring.

Tom> Secondly I doubt it's related to Deterministic Zero AT ALL. (For
Tom> one the SanDisk drive I have shows Deterministic Zero, still it
Tom> behaves similarly as the Intel drive.)

The drive reporting deterministic zero is not enough. It needs to be
explicitly whitelisted before we report discard_zeroes_data=1.

Tom> The only patching which would really mean something is to allow
Tom> user to configure blocks per range and ranges per command, so that
Tom> for users can tune kernel TRIM per device if they really want to,
Tom> while leaving the "safe default" intact.

I'll think about it.

Tom> However I am really curious how the drives "blow up" on less blocks
Tom> per range. Isn't that even more of a firmware bug than the problem
Tom> I have?

I have several older drives that expect a single contiguous LBA
range. They don't handle multiple discontiguous ranges at all.

-- 
Martin K. Petersen	Oracle Linux Engineering
