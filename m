Return-Path: <SRS0=ePHC=6P=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 884EAC47256
	for <linux-scsi@archiver.kernel.org>; Fri,  1 May 2020 07:54:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6F78A20787
	for <linux-scsi@archiver.kernel.org>; Fri,  1 May 2020 07:54:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728311AbgEAHyj (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 1 May 2020 03:54:39 -0400
Received: from mout.kundenserver.de ([217.72.192.75]:44285 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728297AbgEAHyj (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 1 May 2020 03:54:39 -0400
Received: from mail-lj1-f170.google.com ([209.85.208.170]) by
 mrelayeu.kundenserver.de (mreue109 [212.227.15.145]) with ESMTPSA (Nemesis)
 id 1N0G5h-1jHH8E0lfj-00xHal; Fri, 01 May 2020 09:54:37 +0200
Received: by mail-lj1-f170.google.com with SMTP id a21so1906139ljj.11;
        Fri, 01 May 2020 00:54:37 -0700 (PDT)
X-Gm-Message-State: AGi0PuaRqW7A38kkyHYIro5w0xkHg4k3aBJxzLBV03np427cHCpLVv20
        LrxcXBnpnTTGcpMAD5rNffzsaEI213dVN6f7Mtw=
X-Google-Smtp-Source: APiQypK9XxKmNDgvOMy8b+tWTMnraiAmtgvl0xYr2ja0V3HQRSNFcbQsUMyn8cFKY4jvb06ogfuOp1f350deYi6ABfY=
X-Received: by 2002:a2e:8999:: with SMTP id c25mr1783117lji.73.1588319676583;
 Fri, 01 May 2020 00:54:36 -0700 (PDT)
MIME-Version: 1.0
References: <20200430213101.135134-1-arnd@arndb.de> <20200430213101.135134-14-arnd@arndb.de>
 <b5e6ef12-c2ac-d0ce-b7a1-a58d4c8de300@huawei.com>
In-Reply-To: <b5e6ef12-c2ac-d0ce-b7a1-a58d4c8de300@huawei.com>
From:   Arnd Bergmann <arnd@arndb.de>
Date:   Fri, 1 May 2020 09:54:19 +0200
X-Gmail-Original-Message-ID: <CAK8P3a1=5dmgB+k9B_jk2qBhBPnMSFMWrByP4jRvyvaJwBo94A@mail.gmail.com>
Message-ID: <CAK8P3a1=5dmgB+k9B_jk2qBhBPnMSFMWrByP4jRvyvaJwBo94A@mail.gmail.com>
Subject: Re: [PATCH 13/15] scsi: sas: avoid gcc-10 zero-length-bounds warning
To:     John Garry <john.garry@huawei.com>
Cc:     "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        James Bottomley <James.Bottomley@steeleye.com>,
        James Bottomley <James.Bottomley@hansenpartnership.com>,
        Hannes Reinecke <hare@suse.com>,
        linux-scsi <linux-scsi@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Provags-ID: V03:K1:Em+LOawMdZ4ZerbkGILf+HD8qhs9bgYTOMuYF5u3WNI5g1kBRQ6
 FvXR2xmwTyARjzH85bYcf3tavTAemMXRCRmIVFM6D496aA5kIGMIFRUt61Q1QvxTiPNjOF3
 j2OfmWlg+g8UznkluKTqiUlBRm5vVtUqbPx0nUCkcGHNGdOEU3bHRg8+9J7q3jIIlmzLzFC
 5qc6JYafS0/Y9E8IyPv4Q==
X-UI-Out-Filterresults: notjunk:1;V03:K0:epb4JoXj490=:bkJVDm7tCfqAIPUXB9qfPD
 8ckCte5iUuP3MvJaZwjQshC9NsFPttxLO4OtxqIz5TotNjzLBR5l7Nr+9MoQxWd+LVnZhjDjJ
 C9foMf/bGqm6maJ38IDS9t8TYyw8ot0Tqt6eeGdu1QmDkEOn0gMkUzbTkNJpfpTx9TOIa49Sa
 BAqGAkprm3KVqICGDp/r93u4/vHVEq2L42yeB+8UyUSZa0uCjpQt9uBnYw5lTiXodaERAVQJP
 +ZFmMvuCzWMw2SRai+OyNaEBqx+SrqzzqvzUnErWn9g5BzRD97W++9emajVZQu1T4Wk6VxUKY
 /04fLMCObD0w1dui6ohHgcQnHPuVhDSjw0bxjcwPZS1pyk+8az7Xu8mZxZI5G96QhV79AAGJN
 y0NTdKkW7g778QaLL+WG9YifZFctB7aTGjj8X2OAOGgzHjcvqLtrIBYH50umx+7Sk0a1wleZI
 +vvYEvXNKeGP3kkjcl24eIvoFsiZGpsugmKQjtG0V1FtIYg3KvfcazhryXS3xDWdT62o/kKRi
 IToXi68lsifhxNhe+76GtvSvCQSTDpacvfu5H5HjMPiiM9vhTysV0f1P0srXXZVTLfZAztVYo
 0zBhS7QW3QJXlCs5RRqswmW7zgyOGJAD5bk2lOhz5RLfpGjdl0LgVV0qdKLS8zELmokzeSbVc
 LtfZymIWcHL6lDNi/71siXRYg3dkCbdPEvq5w/4tA4cGTjPZBFy+Wa8z31/j/Tojnb08Q8+G2
 O+d0W2upltTUDGr4/uyB3Sc6PbjwW/GZqc6BrUpG05rEYUXwr69pqqriAFLmBheJdMiEdRnPb
 Iel+3YSeSDH7dcDAeSt3jbfE2nQrKMhq0jv4Ozb8szqy+tAKX4=
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Fri, May 1, 2020 at 9:48 AM John Garry <john.garry@huawei.com> wrote:
> On 30/04/2020 22:30, Arnd Bergmann wrote:

> > This should really be a flexible-array member, but the structure
> > already has such a member, swapping it out with sense_data[] would
> > cause many more warnings elsewhere.
> >
>
>
> Hi Arnd,
>
> If we really prefer flexible-array members over zero-length array
> members, then could we have a union of flexible-array members? I'm not
> sure if that's a good idea TBH (or even permitted), as these structures
> are defined by the SAS spec and good practice to keep as consistent as
> possible, but just wondering.

gcc does not allow flexible-array members inside of a union, or more than
one flexible-array member at the end of a structure.

I found one hack that would work, but I think it's too ugly and likely not
well-defined either:

struct ssp_response_iu {
...
        struct {
                u8      dummy[0]; /* a struct must have at least one
non-flexible member */
                u8      resp_data[]; /* allowed here because it's at
the one of a struct */
        };
        u8     sense_data[];
} __attribute__ ((packed));

> Apart from that:
>
> Reviewed-by: John Garry <john.garry@huawei.com>

Thanks!

     Arnd
