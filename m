Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 75E43C433EF
	for <linux-scsi@archiver.kernel.org>; Thu, 30 Dec 2021 02:29:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234754AbhL3C3o (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 29 Dec 2021 21:29:44 -0500
Received: from rap-us.hgst.com ([199.255.44.250]:64724 "EHLO
        usg-ed-osssrv.wdc.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S234694AbhL3C3b (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 29 Dec 2021 21:29:31 -0500
Received: from usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTP id 4JPXBn1yNhz1RvTn
        for <linux-scsi@vger.kernel.org>; Wed, 29 Dec 2021 18:23:45 -0800 (PST)
Authentication-Results: usg-ed-osssrv.wdc.com (amavisd-new); dkim=pass
        reason="pass (just generated, assumed good)"
        header.d=opensource.wdc.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=
        opensource.wdc.com; h=content-transfer-encoding:content-type
        :in-reply-to:organization:from:references:to:content-language
        :subject:user-agent:mime-version:date:message-id; s=dkim; t=
        1640831024; x=1643423025; bh=LHXRdu+llkcJh+s2lfndU36wRPEZYERnL9b
        2+jtEmbY=; b=c+usjiOA9skKtwJ8Z0yT+bzlHdDnqT9OqlpG8B1NnUP54iS57R8
        xu+eZGHeMKPFiTesdWtXEGGdq0bPqG53jMZ71YQVgmHB2AqU7aoJ5fhyqBEAdQ62
        3VXXhLZU6wi4tPMhgJXu55NNfF0QU7ZmQ8CfjwLeHZh6GO2RqOtBGOYJ5+Y2buwD
        dM/7tEsEy8M97bUyb+PAwuFB2miWq+t8k5yzlF6vLdBBkb9QGElRbKnOaiqggnX+
        SVuk6viw18wVRa2C8hS1uwK3bv84jp81j7iSA7T4CPZQC5Os14t2FFtZMvTv2XwS
        eCXz4b2dBu2FWKALwaUab+uME6TZgHx6B4Q==
X-Virus-Scanned: amavisd-new at usg-ed-osssrv.wdc.com
Received: from usg-ed-osssrv.wdc.com ([127.0.0.1])
        by usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id s7KB4oDgGYzG for <linux-scsi@vger.kernel.org>;
        Wed, 29 Dec 2021 18:23:44 -0800 (PST)
Received: from [10.225.163.41] (unknown [10.225.163.41])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTPSA id 4JPXBl2qzwz1RtVG;
        Wed, 29 Dec 2021 18:23:43 -0800 (PST)
Message-ID: <b16b20d3-fd5e-ce5c-f744-be5022b4156f@opensource.wdc.com>
Date:   Thu, 30 Dec 2021 11:23:42 +0900
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.4.0
Subject: Re: [PATCH 0/1] t10-pi bio split fix
Content-Language: en-US
To:     "Lyashkov, Alexey" <alexey.lyashkov@hpe.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     Jens Axboe <axboe@kernel.dk>, Bart Van Assche <bvanassche@acm.org>,
        Dmitry Fomichev <dmitry.fomichev@wdc.com>,
        linux-block@vger.kernel.org, linux-scsi@vger.kernel.org
References: <20211220134422.1045336-1-alexey.lyashkov@hpe.com>
 <yq1wnjzi6oc.fsf@ca-mkp.ca.oracle.com>
 <82F812AE-BEFA-4F57-A134-C1EED7F1928E@hpe.com>
From:   Damien Le Moal <damien.lemoal@opensource.wdc.com>
Organization: Western Digital Research
In-Reply-To: <82F812AE-BEFA-4F57-A134-C1EED7F1928E@hpe.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 12/24/21 21:16, Lyashkov, Alexey wrote:

This thread should really be addressed to linux-block@vger.kernel.org
and linux-scsi@vger.kernel.org.

Added to cc here.


> Martin,
>=20
> Sorry about delay.
>=20
> I don't agree with you about T10 PI reference tag in current code.
> t10_pi_generate works with virtual block numbers and virtual reference =
tags.
> Virtual tag mapped into real tag later in the=20
> static void t10_pi_type1_prepare(struct request *rq)
> ...
>                                 if (be32_to_cpu(pi->ref_tag) =3D=3D vir=
t)
>                                         pi->ref_tag =3D cpu_to_be32(ref=
_tag);
>=20
> ...
> So, we need just a pair between these functions to have a good mapping =
and good real reference tag=20
> Once t10_pi_generate have shift a "virtual" ref tag for 4 it make a bio=
_integrity_advance to be happy.
> And t10_pi_type1_prepare also happy but it need to be shift with 4 as s=
imilar to the generate function.
>=20
> This patch tested with software raid (raid 1 / raid 6) over over NMVe d=
evices with 4k block size.
> In lustre case it caused a bio integrity prepare called before bio_subm=
it so integrity will be splits before sends to the nvme devices.
> Without patch it caused an T10 write errors for each write over 4k, wit=
h patch - no errors.
>=20
> Alex
>=20
> =EF=BB=BFOn 20/12/2021, 19:29, "Martin K. Petersen" <martin.petersen@or=
acle.com> wrote:
>=20
>=20
>     Alexey,
>=20
>     > t10_pi_generate / t10_pi_type1_prepare have just a increment by =E2=
=80=9C1=E2=80=9D for=20
>     > the integrity internal which is 4k in my case,
>     > so any bio_integrity_advance call will be move an iterator outsid=
e of
>     > generated sequence and t10_pi_type1_prepare can=E2=80=99t be foun=
d a good virtual
>     > sector for the mapping.
>     > Changing an increment by =E2=80=9C1=E2=80=9D to be related to the=
 real integrity size=20
>     > solve a problem completely.
>=20
>     By definition the T10 PI reference tag is incremented by one per
>     interval (typically the logical block size). If you implement it by=
 a
>     different value than one then it is no longer valid protection
>     information.
>=20
>     Seems like the splitting logic is broken somehow although I haven't=
 seen
>     any failures with 4K on SCSI. What does your storage stack look lik=
e?
>=20
>     --=20
>     Martin K. Petersen	Oracle Linux Engineering
>=20


--=20
Damien Le Moal
Western Digital Research
