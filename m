From: Tom Yan <tom.ty89@gmail.com>
Subject: Re: configurable discard parameters
Date: Fri, 26 Jun 2015 15:05:50 +0800
Message-ID: <CAGnHSEk3cry5WwRZbWmptu+xWcAuhFnzcNnCxS=0W_QXvhSaQQ@mail.gmail.com>
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
	<yq1fv5g37wj.fsf@sermon.lab.mkp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <yq1fv5g37wj.fsf@sermon.lab.mkp.net>
Sender: linux-ide-owner@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On 25 June 2015 at 09:15, Martin K. Petersen <martin.petersen@oracle.com> wrote:
>
> The drive reporting deterministic zero is not enough. It needs to be
> explicitly whitelisted before we report discard_zeroes_data=1.
>

Not sure what you mean here. I just meant I don't think the "lower
limit" thing I am experiencing is related to the "type" of TRIM, at
least not for any Deterministic TRIM. (Although I don't really know
what exactly does Deterministic Read Data means. Perhaps it means
vendor would make sure the LBA after TRIM reads either zero or a
specific pattern of data?)

>
> I have several older drives that expect a single contiguous LBA
> range. They don't handle multiple discontiguous ranges at all.
>

Well discontiguous is somewhat inaccurate here. I guess what you mean
is they simply don't handle the next range until the previous one is
used up. For example, "0:65528, 65528:65528" are definitely
contiguous, but not fulfiling the requirement of your drives; while
"0:65535 131072:65535" are definitely not contiguous, but your drives
take them fine.

By the way what are the consequences? Data loss? System hang?
