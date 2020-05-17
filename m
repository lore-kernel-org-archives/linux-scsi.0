Return-Path: <SRS0=qdST=67=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 311C0C433E1
	for <linux-scsi@archiver.kernel.org>; Sun, 17 May 2020 17:32:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 07927207E8
	for <linux-scsi@archiver.kernel.org>; Sun, 17 May 2020 17:32:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726313AbgEQRcH (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 17 May 2020 13:32:07 -0400
Received: from m9a0014g.houston.softwaregrp.com ([15.124.64.90]:46131 "EHLO
        m9a0014g.houston.softwaregrp.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726276AbgEQRcG (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Sun, 17 May 2020 13:32:06 -0400
Received: FROM m9a0014g.houston.softwaregrp.com (15.121.0.190) BY m9a0014g.houston.softwaregrp.com WITH ESMTP;
 Sun, 17 May 2020 17:31:06 +0000
Received: from M4W0334.microfocus.com (2002:f78:1192::f78:1192) by
 M9W0067.microfocus.com (2002:f79:be::f79:be) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.1591.10; Sun, 17 May 2020 17:30:52 +0000
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (15.124.8.14) by
 M4W0334.microfocus.com (15.120.17.146) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.1591.10 via Frontend Transport; Sun, 17 May 2020 17:30:52 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jc9mGr/19U0hMXQVuWc9T4ZRWuczp5qu14NwVCJUfCppVDa1/BQ6b19+cMcQTUvFT5hq2rqPTuBOkBJo8jOxYNGREcq8qWl9Gl8DqpNePYsaCngs5LVPBPuPe52rN2lW6dH2sUTDCkoTrpI5r0CtsKHHqXuKA03iThLu6j86GCPuWCfk6b0DkmSdn1Y98ZqDITz0LEWkpPPxYwgMlPvX5mHs7KB9vN8GzMRzOcVd1lnOhHS0k3xYcaq47LwZc3fJKfkV+YzJue4X+/G3fKPeXcWzbFb5OqEZWiQnQci8M4AM8fpE63aJ6PmwHYQwVJckPJbIc72TYCC8HdBKB53+qA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wnffCo5PZ0jr2OkhNUVUTBAao5CK0X8jgrDGBO249a0=;
 b=FxSN9I2iCe2I9LYcGscvaj+SPhnV4czramemoH/hUbknVwX8lzL9akBjFz6vMBba8iAj+lTHzAMJGD0mA2tCRLfR3hdxHaccU3LtAeBVMt5ezjJJ5Ma8EC/cbb28OtEsCZuP4qzoxEM6AISDoesXo3WhYrpDpZbQuk8Jui/R7FuaPSEFZ4g6JSeubUgiknMe5l8v2axA9G+ZTuP+Aiil001TeAWN0N2QB80rnTjIPx0q4j1A5bfeiNSJxxyASjcOTo8CKlDG/l/IlCKtYK51Cngqtms52DyI69U6ka8No6n7wpx6LD0LitCbf4D0EroNBHDxEvE8oiJuuU7tBGfNfQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=suse.com; dmarc=pass action=none header.from=suse.com;
 dkim=pass header.d=suse.com; arc=none
Authentication-Results: google.com; dkim=none (message not signed)
 header.d=none;google.com; dmarc=none action=none header.from=suse.com;
Received: from BL0PR18MB2290.namprd18.prod.outlook.com (2603:10b6:207:48::11)
 by BL0PR18MB2260.namprd18.prod.outlook.com (2603:10b6:207:3f::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3000.20; Sun, 17 May
 2020 17:30:50 +0000
Received: from BL0PR18MB2290.namprd18.prod.outlook.com
 ([fe80::9ddc:db5b:9a5a:6b3d]) by BL0PR18MB2290.namprd18.prod.outlook.com
 ([fe80::9ddc:db5b:9a5a:6b3d%7]) with mapi id 15.20.3000.022; Sun, 17 May 2020
 17:30:50 +0000
Subject: Re: [PATCH] iscsi: Fix deadlock on recovery path during GFP_IO
 reclaim
To:     Gabriel Krisman Bertazi <krisman@collabora.com>
CC:     <cleech@redhat.com>, <martin.petersen@oracle.com>,
        <open-iscsi@googlegroups.com>, <linux-scsi@vger.kernel.org>,
        <kernel@collabora.com>, Khazhismel Kumykov <khazhy@google.com>
References: <20200508055954.843165-1-krisman@collabora.com>
From:   Lee Duncan <lduncan@suse.com>
Autocrypt: addr=lduncan@suse.com; keydata=
 xsFNBE6ockoBEADMQ+ZJI8khyuc2jMfgf4RmARpBkZrcHSs1xTKVVBUbpFooDEVi49D/bz0G
 XngCDUzLt1g7QwHkMl5hDe6h6zPcACkUf0vy3AkpbidveIbIUKhb29tnsuiAcvzmrE4Q5CcQ
 JCSFAUnBPliKauX+r0oHjJE02ifuims1nBQ9CK8sWGHqkkwH2vUW2GSX2Q8zGMemwEJdhclS
 3VOYZa+Cdm+hRxUxcEo4QigWM1IlgUqjhQp6ZXTYuNECHZTrL9NUbslW5Rbmc3m0ABrJcaAo
 LgG13TnT6HCreN/PO8VbSFdFU+3MX1GqZUHfPBA4UvGvcI8QgdYyCtyYF9PQ02Lr0kK0FwBD
 cm416qSMCsk0kaFPeL99Afg8ElXsA9bGW6ImJQap/L1uoWZTNL5q9KKO5As9rq6RHGlb2FFz
 9IPggMhBYsSVZNmLsvgGXvZToUCW58IMELG/X5ssI8Kr65KxKVNOT5gXGmTyV3sqomsRVVHm
 wA3RBwjnx7tM7QsV+7UboF3MOcMjBOCIDiw95dBVSM6+leThXC5dc4/17Idw912mnlo1CsxO
 uQSJddzWeD0A2hbL8EcRQN/z9YD0IwEgeNa2t1nQ6nGjbDZ5TiG6Mqxk+rdYJ5StA+b/TExl
 nZ29y2s6etx9wbTUBSA1aFiEPDN5U77CrjiM0H4y7eKldLezPwARAQABzSRMZWUgRHVuY2Fu
 IDxsZWVtYW4uZHVuY2FuQGdtYWlsLmNvbT7CwYEEEwECACsCGy8FCRLP94AGCwkIBwMCBhUI
 AgkKCwQWAgMBAh4BAheABQJOqHy+AhkBAAoJEMU8XTeNhnafp4YQAMgE1owepFfSgebbT3fj
 0/S83KvYloj2Fv/OiQKgjnEamy7k2n3XBl0+XYHe/0ZlKAYN8oCnlpr+PTh5iT79rq99CkZa
 1OENVypbnVGjeZQpNivmXtkKYATwVhqyWsWItJyQ7fqciDkPlCekjURhEMRliE8OcrpvXOxq
 w1apxuL6phkQxY0fQGSQzz9sXZcMIx4ZhotQRwGLr5FIpqIhToIlVhvkooL7NsDG0FlagV5f
 +Jr412zvk7f3rPKrLR8Bp1qTe/HLeEyhT38CWECiTM8+VAGFQ4+5HRg6F4322T8VynMX/zyp
 LUVHIymbmzyXXMj6xJsbrcN8UJsPglQ+fHmb5ojKsy+S92KgAgpnq4mmz63eCzZrKZ7B5AqB
 qMhZ0V8wjv0LzHdQbHH72ikM/IWkAvPfVYsvm08mxUdFMmwFXpjIZJeJJyxS6Glxcxt98usO
 cdrBBJE57Q77GQC69gbPJu2vmH7quAKp59PxMxqZPDMfn2nt/Qnxem3SYL3377rl3UAlZmbK
 2kKAOY3gngHfptoYtlJJ69bnoTIOXPNfE5jPkLrt3LbOQyfvrSKSTUOet26fWD9cME/tXtvC
 48hsyheShX3obqBVZO6UnW5J+f6DVLuHv1huDUEwQMvHyejpomfnOFpGX8LkaS26Btvm94h2
 szYB8xYSw5VfH3DKzsFNBE6ockoBEADAo38n1dd3etQL/i07qPVoqGSWmaMZqS6DSFAPfqLe
 RVRTQZRBltdHNlV4BcDhRHDQJCuhuKqhTe8TkM2wpFFOVyNYkXm4V5mEmUtQ8PDa76FfY2nn
 6cV4DIN/oCqt0SnWbi18LLd9x7knApsD+y1MnVYmQxw1x91GvHFJD4L4NwHNZJUO4YkIwhl/
 AMcDP0WYJRwR8vt657gEtfkZnD9N3Vb+gLk820VGMPpbDNqedqPxNEjMyNSn2AwBTJ5bxvCM
 +6eJA/F6/hIyvoAmb8oAXBpW6+GZQEi3D2xOmzQmgoMstLuxIzeK0gBg4lFg0dMsX6fq+CxW
 QtKR46HFs3R6xtLZkYOg0ZNlnSlJUOE0BiRgEOP0hJhSYFqnHuXvIxnTAr8gh0883KMI64nA
 sCOcUaO/SeRkGRvzg+Oh0Nnr2DG/U3TMygDlkr/MXZQDGi3H3760/HD3ipQjs28nLHtiqJNr
 5wwJwMv1iWcw9tuzNLt/5mmI5+veDJRObGCqQM43A2FMUx+zVZfVLVyVihnQ08eGdVTAsuSl
 FzyPaaIQUaPn224wRtnbDTTWg9HTR3R6Qxi0ayWeTVZV3va2lCXWrUecJpzvUFLyH3ViM2Iw
 LboM03qutGcjINkb4KuqqW6EHm3MkOC69TWgIFa4W2rpy1FPkDvXNf9nlqcgoNo0fQARAQAB
 wsOEBBgBAgAPBQJOqHJKAhsuBQkSz/eAAikJEMU8XTeNhnafwV0gBBkBAgAGBQJOqHJKAAoJ
 EF8LJ744L6KVhr4QAKGjq1s8WBup2uWOevIcncyAaKYaGX3gQj4Qf+lfklvPpnwUfPMbcYMU
 DhTo4H1lw1dDSBic65OsqMjz2pxJ+AYtLxrONKKCUQRyfO1mwB4etIv7ZF+E5HsclwqM/GWt
 Y9QijHgRbDiUK1h3Y2sQGc/MKg8m7EImZOGEEMQQj1tJ5r3ksH2e6KwO+K9y/uf+qLHd6lSb
 G2+niSSUhcA46PdW2tzx40dZp6d2aEl53f2jwsQbrog1BsGuxOA9+26xhF4p0Ag/hfOX9/n/
 mMzw+bXSFB/gJE0zQ83jksuHFCSJDHEsPzmKi4hVRKuEcEAryjGXH4bqoDkz/p3DRdIfnuKi
 Li/iwSsK76UgGekw6tjjP8ggz6UC8UVhdMv9q4hcewv5/omdnuHj/G6uSGlVcAi+5VJ88yEH
 5Am1IYbjSbqzSDQazEK3oAE6qXwzQXjq1iuqR9Xa6eXtcog+CHFSKU3aEuL+f8oUUzpEU+Xq
 ZSPuHpFgYHsNTkxUA8fuP6Tr53kqHD9PEqLb8+M1MlJBjiD+JSHIN5+C6LpZIZ0Zbp7qInu8
 Pu1eALxri4VgevZKQOQXTJUsNFWh4EYdsfNgcCbQoP8gFFns9YmQ0vXHnJG/dPjzBPAUfKZg
 PtVofEMK1B4J9gAm1fO3hqRxrtSkUZgopZpjHtC7ZuYSkwmEUoMjxpwP/j2ql5J6t06uIhUz
 OgHAEJ9+4ppeAPNQAUsRVrPk3m1PaV1xs7nx/D4yXbq+S0/iMA+g1k0Ovh3TSvdQfK/74Rp0
 48Tr+0Tm2uAESaN4+7WK0v8rONVPuqpSKf92o5KmFtlT+Yyz9ZRu52GE7BzkktMEnGp1sLBM
 zbwflhj/ZtMPOdQxmpBZS5h34alcBiYK3wVVZpzRNLhke3z8ZAn0e2xG8fOX56LiL7o1w8wF
 SA7PMuuhklq3NY/xTwBOpT8YiQU6VlELQQTR06unnHa6we3JcsNlTH2//7mZ0QVp9nPW6MEw
 FUvbjJliGQbs4e8z6vL8M7bgl1kgcTViSW4jL41CXnGlLSUm8pqvbQ95/gJhgs6PVBwH5FF8
 JGCvUKOeAFsICUPEFizy4BgQpPPYE++I07VqZ87/gaeN9EeFgZASolQwcZNRAWplDD4jIpj8
 u7wo+4j22HyVXuoQTg8+p5TVMV1Y0b2X4tJm98ways9e5LTQLXM6dcoGKeVF3Pt53RVBiv2n
 7WpDcR/bT0ADCwtg8piRWMtA8Boc8w5WG06vphxLlDIe/hDMkNlgCUy84gLiRI76VaBh9eFp
 v8Bn4aZBVOiuzj4s2DSAp4G3loUsTuj4uxGgDlfhK1xdJhBvKdO8omG+A73DZ7aKxLPaXd8p
 +B+giaT8a1b5hWuz85V0zsFNBE6ockoBEADAo38n1dd3etQL/i07qPVoqGSWmaMZqS6DSFAP
 fqLeRVRTQZRBltdHNlV4BcDhRHDQJCuhuKqhTe8TkM2wpFFOVyNYkXm4V5mEmUtQ8PDa76Ff
 Y2nn6cV4DIN/oCqt0SnWbi18LLd9x7knApsD+y1MnVYmQxw1x91GvHFJD4L4NwHNZJUO4YkI
 whl/AMcDP0WYJRwR8vt657gEtfkZnD9N3Vb+gLk820VGMPpbDNqedqPxNEjMyNSn2AwBTJ5b
 xvCM+6eJA/F6/hIyvoAmb8oAXBpW6+GZQEi3D2xOmzQmgoMstLuxIzeK0gBg4lFg0dMsX6fq
 +CxWQtKR46HFs3R6xtLZkYOg0ZNlnSlJUOE0BiRgEOP0hJhSYFqnHuXvIxnTAr8gh0883KMI
 64nAsCOcUaO/SeRkGRvzg+Oh0Nnr2DG/U3TMygDlkr/MXZQDGi3H3760/HD3ipQjs28nLHti
 qJNr5wwJwMv1iWcw9tuzNLt/5mmI5+veDJRObGCqQM43A2FMUx+zVZfVLVyVihnQ08eGdVTA
 suSlFzyPaaIQUaPn224wRtnbDTTWg9HTR3R6Qxi0ayWeTVZV3va2lCXWrUecJpzvUFLyH3Vi
 M2IwLboM03qutGcjINkb4KuqqW6EHm3MkOC69TWgIFa4W2rpy1FPkDvXNf9nlqcgoNo0fQAR
 AQABwsOEBBgBAgAPBQJOqHJKAhsuBQkSz/eAAikJEMU8XTeNhnafwV0gBBkBAgAGBQJOqHJK
 AAoJEF8LJ744L6KVhr4QAKGjq1s8WBup2uWOevIcncyAaKYaGX3gQj4Qf+lfklvPpnwUfPMb
 cYMUDhTo4H1lw1dDSBic65OsqMjz2pxJ+AYtLxrONKKCUQRyfO1mwB4etIv7ZF+E5HsclwqM
 /GWtY9QijHgRbDiUK1h3Y2sQGc/MKg8m7EImZOGEEMQQj1tJ5r3ksH2e6KwO+K9y/uf+qLHd
 6lSbG2+niSSUhcA46PdW2tzx40dZp6d2aEl53f2jwsQbrog1BsGuxOA9+26xhF4p0Ag/hfOX
 9/n/mMzw+bXSFB/gJE0zQ83jksuHFCSJDHEsPzmKi4hVRKuEcEAryjGXH4bqoDkz/p3DRdIf
 nuKiLi/iwSsK76UgGekw6tjjP8ggz6UC8UVhdMv9q4hcewv5/omdnuHj/G6uSGlVcAi+5VJ8
 8yEH5Am1IYbjSbqzSDQazEK3oAE6qXwzQXjq1iuqR9Xa6eXtcog+CHFSKU3aEuL+f8oUUzpE
 U+XqZSPuHpFgYHsNTkxUA8fuP6Tr53kqHD9PEqLb8+M1MlJBjiD+JSHIN5+C6LpZIZ0Zbp7q
 Inu8Pu1eALxri4VgevZKQOQXTJUsNFWh4EYdsfNgcCbQoP8gFFns9YmQ0vXHnJG/dPjzBPAU
 fKZgPtVofEMK1B4J9gAm1fO3hqRxrtSkUZgopZpjHtC7ZuYSkwmEUoMjxpwP/j2ql5J6t06u
 IhUzOgHAEJ9+4ppeAPNQAUsRVrPk3m1PaV1xs7nx/D4yXbq+S0/iMA+g1k0Ovh3TSvdQfK/7
 4Rp048Tr+0Tm2uAESaN4+7WK0v8rONVPuqpSKf92o5KmFtlT+Yyz9ZRu52GE7BzkktMEnGp1
 sLBMzbwflhj/ZtMPOdQxmpBZS5h34alcBiYK3wVVZpzRNLhke3z8ZAn0e2xG8fOX56LiL7o1
 w8wFSA7PMuuhklq3NY/xTwBOpT8YiQU6VlELQQTR06unnHa6we3JcsNlTH2//7mZ0QVp9nPW
 6MEwFUvbjJliGQbs4e8z6vL8M7bgl1kgcTViSW4jL41CXnGlLSUm8pqvbQ95/gJhgs6PVBwH
 5FF8JGCvUKOeAFsICUPEFizy4BgQpPPYE++I07VqZ87/gaeN9EeFgZASolQwcZNRAWplDD4j
 Ipj8u7wo+4j22HyVXuoQTg8+p5TVMV1Y0b2X4tJm98ways9e5LTQLXM6dcoGKeVF3Pt53RVB
 iv2n7WpDcR/bT0ADCwtg8piRWMtA8Boc8w5WG06vphxLlDIe/hDMkNlgCUy84gLiRI76VaBh
 9eFpv8Bn4aZBVOiuzj4s2DSAp4G3loUsTuj4uxGgDlfhK1xdJhBvKdO8omG+A73DZ7aKxLPa
 Xd8p+B+giaT8a1b5hWuz85V0
Message-ID: <eb7a3a10-bb04-f601-a01b-c50f482474fa@suse.com>
Date:   Sun, 17 May 2020 10:30:40 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
In-Reply-To: <20200508055954.843165-1-krisman@collabora.com>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO2P265CA0086.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:8::26) To BL0PR18MB2290.namprd18.prod.outlook.com
 (2603:10b6:207:48::11)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [192.168.20.3] (73.25.22.216) by LO2P265CA0086.GBRP265.PROD.OUTLOOK.COM (2603:10a6:600:8::26) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3000.26 via Frontend Transport; Sun, 17 May 2020 17:30:47 +0000
X-Originating-IP: [73.25.22.216]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 67e2baf1-5453-403b-dfd8-08d7fa880a52
X-MS-TrafficTypeDiagnostic: BL0PR18MB2260:
X-Microsoft-Antispam-PRVS: <BL0PR18MB2260A3B0C4644AD1A2562CF0DABB0@BL0PR18MB2260.namprd18.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-Forefront-PRVS: 040655413E
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ZoniWJSnX/YG298uNnBiU/r2d+VzjtU0NZx51Q4ecGNhxPpgN8BitqWg0lvHNARAjyqnvE7HVAu+UZApIvVXmdakO9T29q197BrtGPvBmYNWnDfmITn1NJD9dJ5Fvmoxn3x1xnyGCx5kbjSU5bQEhgtcZo0UTJSysZj9uUKeJm3Wy9sTUgUzlbP7D1P/Q85Vj3oZIM2TnQplnF7UJq5Njtod7kLGyOc9KcvfttOLZzFpYJW6DSIo0vp15ZpZuA0I4LFznPU9Y2QaUYAIPwBh3QNZdsI3luUrCVo1Ss8nVc7D15FgZGe8EdMzzU8F2dPsgTI16aMj7eg3SU1+r6Gw/+q8sVtmUvw82vDUtZO04TbgIGon11z4gJe284n2Q+6j20TXmghYP/x392SnmD5/FaIYre4UenfHNLazQmRpvuiHVYv94iOOB27V6aNTnZYftm1b9+UNOUoe/vzv0EH8LHjzeukJUax26auZdKoVc3APyFTs7+wyLyFsTr5/TArQ
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL0PR18MB2290.namprd18.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(136003)(366004)(346002)(396003)(39850400004)(376002)(66946007)(66476007)(4326008)(53546011)(8936002)(16526019)(31686004)(316002)(52116002)(2906002)(956004)(186003)(16576012)(36756003)(66556008)(5660300002)(6916009)(478600001)(6486002)(86362001)(26005)(31696002)(6666004)(2616005)(8676002)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: yW/vNAm9YBlNsQYv1TjpUiYwJKJWEdC0AwF16WAC8Mjk1nYWV0lFjYUW122bzj3XlaVaZMF5RBUvIfDpWDTJoP/85ioas2/0UjCJ84mJnphAC/SGRkg5rbeC0IIIa050OcZimjfT2286BdvDzfM/L2h0+WPFNAX/Wj+C5F0YUkii7od3BkRll7oO6Hv4FtVMLWMgfe1YDL+oxtuf71ka/9tceZ04lsPMCubAHFVl5Lbm5ICSZzepOLhfZCLxCyg+XV08+VtYZoJofSRxl27Cxi5abAcS7EHyaHimAtidTmWbK9FnICQakDOcFgYqnWtxaw08d7JASjeLTuvtMSdivsafJb9FLkkVIrgfZTK0LRfswaGXGt7aojEKZqueA9L9kD7tVnQlWlRi7MHyZDVXRAu4eGSbeol3ctVtSp9+p9eAxCxf6Zk0kHB9FoV4noKbz00TOpHbzcRkjMokKe8EVVjqzHHBUd6uMihL3+Slti8=
X-MS-Exchange-CrossTenant-Network-Message-Id: 67e2baf1-5453-403b-dfd8-08d7fa880a52
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 May 2020 17:30:49.9379
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 856b813c-16e5-49a5-85ec-6f081e13b527
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: +Ts8CTO1Sou6Mt496n+wKGIMs96mNANGeStLfqfGVV7KXL7M/w9q+da+TcBgbRX7eVwQOeltRfQ91D9vFmlt/A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL0PR18MB2260
X-OriginatorOrg: suse.com
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 5/7/20 10:59 PM, Gabriel Krisman Bertazi wrote:
> iscsi suffers from a deadlock in case a management command submitted via
> the netlink socket sleeps on an allocation while holding the
> rx_queue_mutex, if that allocation causes a memory reclaim that
> writebacks to a failed iscsi device.  Then, the recovery procedure can
> never make progress to recover the failed disk or abort outstanding IO
> operations to complete the reclaim (since rx_queue_mutex is locked),
> thus locking the system.
> 
> Nevertheless, just marking all allocations under rx_queue_mutex as
> GFP_NOIO (or locking the userspace process with something like
> PF_MEMALLOC_NOIO) is not enough, since the iscsi command code relies on
> other subsystems that try to grab locked mutexes, whose threads are
> GFP_IO, leading to the same deadlock. One instance where this situation
> can be observed is in the backtraces below, stitched from multiple bugs
> reports, involving the kobj uevent sent when a session is created.
> 
> The root of the problem is not the fact that iscsi does GFP_IO
> allocations, that is acceptable. The actual problem is that
> rx_queue_mutex has a very large granularity, covering every unrelated
> netlink command execution at the same time as the error recovery path.
> 
> The proposed fix leverages the recently added mechanism to stop failed
> connections from the kernel, by enabling it to execute even though a
> management command from the netlink socket is being run (rx_queue_mutex
> is held), provided that the command is known to be safe.  It splits the
> rx_queue_mutex in two mutexes, one protecting from concurrent command
> execution from the netlink socket, and one protecting stop_conn from
> racing with other connection management operations that might conflict
> with it.
> 
> It is not very pretty, but it is the simplest way to resolve the
> deadlock.  I considered making it a lock per connection, but some
> external mutex would still be needed to deal with iscsi_if_destroy_conn.
> 
> The patch was tested by forcing a memory shrinker (unrelated, but used
> bufio/dm-verity) to reclaim ISCSI pages every time
> ISCSI_UEVENT_CREATE_SESSION happens, which is reasonable to simulate
> reclaims that might happen with GFP_KERNEL on that path.  Then, a faulty
> hung target causes a connection to fail during intensive IO, at the same
> time a new session is added by iscsid.
> 
> The following stacktraces are stiches from several bug reports, showing
> a case where the deadlock can happen.
> 
>  iSCSI-write
>          holding: rx_queue_mutex
>          waiting: uevent_sock_mutex
> 
>          kobject_uevent_env+0x1bd/0x419
>          kobject_uevent+0xb/0xd
>          device_add+0x48a/0x678
>          scsi_add_host_with_dma+0xc5/0x22d
>          iscsi_host_add+0x53/0x55
>          iscsi_sw_tcp_session_create+0xa6/0x129
>          iscsi_if_rx+0x100/0x1247
>          netlink_unicast+0x213/0x4f0
>          netlink_sendmsg+0x230/0x3c0
> 
>  iscsi_fail iscsi_conn_failure
>          waiting: rx_queue_mutex
> 
>          schedule_preempt_disabled+0x325/0x734
>          __mutex_lock_slowpath+0x18b/0x230
>          mutex_lock+0x22/0x40
>          iscsi_conn_failure+0x42/0x149
>          worker_thread+0x24a/0xbc0
> 
>  EventManager_
>          holding: uevent_sock_mutex
>          waiting: dm_bufio_client->lock
> 
>          dm_bufio_lock+0xe/0x10
>          shrink+0x34/0xf7
>          shrink_slab+0x177/0x5d0
>          do_try_to_free_pages+0x129/0x470
>          try_to_free_mem_cgroup_pages+0x14f/0x210
>          memcg_kmem_newpage_charge+0xa6d/0x13b0
>          __alloc_pages_nodemask+0x4a3/0x1a70
>          fallback_alloc+0x1b2/0x36c
>          __kmalloc_node_track_caller+0xb9/0x10d0
>          __alloc_skb+0x83/0x2f0
>          kobject_uevent_env+0x26b/0x419
>          dm_kobject_uevent+0x70/0x79
>          dev_suspend+0x1a9/0x1e7
>          ctl_ioctl+0x3e9/0x411
>          dm_ctl_ioctl+0x13/0x17
>          do_vfs_ioctl+0xb3/0x460
>          SyS_ioctl+0x5e/0x90
> 
>  MemcgReclaimerD"
>          holding: dm_bufio_client->lock
>          waiting: stuck io to finish (needs iscsi_fail thread to progress)
> 
>          schedule at ffffffffbd603618
>          io_schedule at ffffffffbd603ba4
>          do_io_schedule at ffffffffbdaf0d94
>          __wait_on_bit at ffffffffbd6008a6
>          out_of_line_wait_on_bit at ffffffffbd600960
>          wait_on_bit.constprop.10 at ffffffffbdaf0f17
>          __make_buffer_clean at ffffffffbdaf18ba
>          __cleanup_old_buffer at ffffffffbdaf192f
>          shrink at ffffffffbdaf19fd
>          do_shrink_slab at ffffffffbd6ec000
>          shrink_slab at ffffffffbd6ec24a
>          do_try_to_free_pages at ffffffffbd6eda09
>          try_to_free_mem_cgroup_pages at ffffffffbd6ede7e
>          mem_cgroup_resize_limit at ffffffffbd7024c0
>          mem_cgroup_write at ffffffffbd703149
>          cgroup_file_write at ffffffffbd6d9c6e
>          sys_write at ffffffffbd6662ea
>          system_call_fastpath at ffffffffbdbc34a2
> 
> Reported-by: Khazhismel Kumykov <khazhy@google.com>
> Signed-off-by: Gabriel Krisman Bertazi <krisman@collabora.com>
> ---
>  drivers/scsi/scsi_transport_iscsi.c | 67 +++++++++++++++++++++--------
>  1 file changed, 49 insertions(+), 18 deletions(-)
> 
> diff --git a/drivers/scsi/scsi_transport_iscsi.c b/drivers/scsi/scsi_transport_iscsi.c
> index 17a45716a0fe..d99c17306dff 100644
> --- a/drivers/scsi/scsi_transport_iscsi.c
> +++ b/drivers/scsi/scsi_transport_iscsi.c
> @@ -1616,6 +1616,12 @@ static DECLARE_TRANSPORT_CLASS(iscsi_connection_class,
>  static struct sock *nls;
>  static DEFINE_MUTEX(rx_queue_mutex);
>  
> +/*
> + * conn_mutex protects the {start,bind,stop,destroy}_conn from racing
> + * against the kernel stop_connection recovery mechanism
> + */
> +static DEFINE_MUTEX(conn_mutex);
> +
>  static LIST_HEAD(sesslist);
>  static LIST_HEAD(sessdestroylist);
>  static DEFINE_SPINLOCK(sesslock);
> @@ -2442,6 +2448,32 @@ int iscsi_offload_mesg(struct Scsi_Host *shost,
>  }
>  EXPORT_SYMBOL_GPL(iscsi_offload_mesg);
>  
> +/*
> + * This can be called without the rx_queue_mutex, if invoked by the kernel
> + * stop work. But, in that case, it is guaranteed not to race with
> + * iscsi_destroy by conn_mutex.
> + */
> +static void iscsi_if_stop_conn(struct iscsi_cls_conn *conn, int flag)
> +{
> +	/*
> +	 * It is important that this path doesn't rely on
> +	 * rx_queue_mutex, otherwise, a thread doing allocation on a
> +	 * start_session/start_connection could sleep waiting on a
> +	 * writeback to a failed iscsi device, that cannot be recovered
> +	 * because the lock is held.  If we don't hold it here, the
> +	 * kernel stop_conn_work_fn has a chance to stop the broken
> +	 * session and resolve the allocation.
> +	 *
> +	 * Still, the user invoked .stop_conn() needs to be serialized
> +	 * with stop_conn_work_fn by a private mutex.  Not pretty, but
> +	 * it works.
> +	 */
> +	mutex_lock(&conn_mutex);
> +	conn->transport->stop_conn(conn, flag);
> +	mutex_unlock(&conn_mutex);
> +
> +}
> +
>  static void stop_conn_work_fn(struct work_struct *work)
>  {
>  	struct iscsi_cls_conn *conn, *tmp;
> @@ -2460,30 +2492,17 @@ static void stop_conn_work_fn(struct work_struct *work)
>  		uint32_t sid = iscsi_conn_get_sid(conn);
>  		struct iscsi_cls_session *session;
>  
> -		mutex_lock(&rx_queue_mutex);
> -
>  		session = iscsi_session_lookup(sid);
>  		if (session) {
>  			if (system_state != SYSTEM_RUNNING) {
>  				session->recovery_tmo = 0;
> -				conn->transport->stop_conn(conn,
> -							   STOP_CONN_TERM);
> +				iscsi_if_stop_conn(conn, STOP_CONN_TERM);
>  			} else {
> -				conn->transport->stop_conn(conn,
> -							   STOP_CONN_RECOVER);
> +				iscsi_if_stop_conn(conn, STOP_CONN_RECOVER);
>  			}
>  		}
>  
>  		list_del_init(&conn->conn_list_err);
> -
> -		mutex_unlock(&rx_queue_mutex);
> -
> -		/* we don't want to hold rx_queue_mutex for too long,
> -		 * for instance if many conns failed at the same time,
> -		 * since this stall other iscsi maintenance operations.
> -		 * Give other users a chance to proceed.
> -		 */
> -		cond_resched();
>  	}
>  }

I'm curious about why you removed the cond_resched() here. Is it because
it is no longer needed, with shorter (mutex) waiting time?

>  
> @@ -2843,8 +2862,11 @@ iscsi_if_destroy_conn(struct iscsi_transport *transport, struct iscsi_uevent *ev
>  	spin_unlock_irqrestore(&connlock, flags);
>  
>  	ISCSI_DBG_TRANS_CONN(conn, "Destroying transport conn\n");
> +
> +	mutex_lock(&conn_mutex);
>  	if (transport->destroy_conn)
>  		transport->destroy_conn(conn);
> +	mutex_unlock(&conn_mutex);
>  
>  	return 0;
>  }
> @@ -3686,9 +3708,12 @@ iscsi_if_recv_msg(struct sk_buff *skb, struct nlmsghdr *nlh, uint32_t *group)
>  			break;
>  		}
>  
> +		mutex_lock(&conn_mutex);
>  		ev->r.retcode =	transport->bind_conn(session, conn,
>  						ev->u.b_conn.transport_eph,
>  						ev->u.b_conn.is_leading);
> +		mutex_unlock(&conn_mutex);
> +
>  		if (ev->r.retcode || !transport->ep_connect)
>  			break;
>  
> @@ -3709,25 +3734,31 @@ iscsi_if_recv_msg(struct sk_buff *skb, struct nlmsghdr *nlh, uint32_t *group)
>  		break;
>  	case ISCSI_UEVENT_START_CONN:
>  		conn = iscsi_conn_lookup(ev->u.start_conn.sid, ev->u.start_conn.cid);
> -		if (conn)
> +		if (conn) {
> +			mutex_lock(&conn_mutex);
>  			ev->r.retcode = transport->start_conn(conn);
> +			mutex_unlock(&conn_mutex);
> +		}
>  		else
>  			err = -EINVAL;
>  		break;
>  	case ISCSI_UEVENT_STOP_CONN:
>  		conn = iscsi_conn_lookup(ev->u.stop_conn.sid, ev->u.stop_conn.cid);
>  		if (conn)
> -			transport->stop_conn(conn, ev->u.stop_conn.flag);
> +			iscsi_if_stop_conn(conn, ev->u.stop_conn.flag);
>  		else
>  			err = -EINVAL;
>  		break;
>  	case ISCSI_UEVENT_SEND_PDU:
>  		conn = iscsi_conn_lookup(ev->u.send_pdu.sid, ev->u.send_pdu.cid);
> -		if (conn)
> +		if (conn) {
> +			mutex_lock(&conn_mutex);
>  			ev->r.retcode =	transport->send_pdu(conn,
>  				(struct iscsi_hdr*)((char*)ev + sizeof(*ev)),
>  				(char*)ev + sizeof(*ev) + ev->u.send_pdu.hdr_size,
>  				ev->u.send_pdu.data_size);
> +			mutex_unlock(&conn_mutex);
> +		}
>  		else
>  			err = -EINVAL;
>  		break;
> 

My question above is for my own information, so I'll still say:

Reviewed-by: Lee Duncan <lduncan@suse.com>
