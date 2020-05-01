Return-Path: <SRS0=ePHC=6P=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C5503C47258
	for <linux-scsi@archiver.kernel.org>; Fri,  1 May 2020 17:37:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B40D424957
	for <linux-scsi@archiver.kernel.org>; Fri,  1 May 2020 17:37:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730170AbgEARhP (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 1 May 2020 13:37:15 -0400
Received: from mout.kundenserver.de ([212.227.126.134]:49037 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729705AbgEARhO (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 1 May 2020 13:37:14 -0400
Received: from mail-qv1-f41.google.com ([209.85.219.41]) by
 mrelayeu.kundenserver.de (mreue009 [212.227.15.129]) with ESMTPSA (Nemesis)
 id 1MrhLw-1iq1jJ1XPg-00nhip; Fri, 01 May 2020 19:37:13 +0200
Received: by mail-qv1-f41.google.com with SMTP id ck5so5044288qvb.11;
        Fri, 01 May 2020 10:37:13 -0700 (PDT)
X-Gm-Message-State: AGi0PuauzeuCKuBoOTcwGnIyEL/8FOQS54WSVUIh+iKKthAW5UxVYlGa
        uaMl4eCZVlGTzx66w4ycNaXK0miWHVBQHyAvpZo=
X-Google-Smtp-Source: APiQypJ76OecAT4JRkELVMGL7nVDYe5c/NgtmrMhJvbU+ti51agb2oCYWekUuVifbHUREw/ttX5+H+Iorlemv8zo2vg=
X-Received: by 2002:a0c:eb11:: with SMTP id j17mr5062637qvp.197.1588354632183;
 Fri, 01 May 2020 10:37:12 -0700 (PDT)
MIME-Version: 1.0
References: <20200430213101.135134-1-arnd@arndb.de> <20200430213101.135134-14-arnd@arndb.de>
 <b5e6ef12-c2ac-d0ce-b7a1-a58d4c8de300@huawei.com> <CAK8P3a1=5dmgB+k9B_jk2qBhBPnMSFMWrByP4jRvyvaJwBo94A@mail.gmail.com>
 <1588344818.3428.18.camel@linux.ibm.com>
In-Reply-To: <1588344818.3428.18.camel@linux.ibm.com>
From:   Arnd Bergmann <arnd@arndb.de>
Date:   Fri, 1 May 2020 19:36:55 +0200
X-Gmail-Original-Message-ID: <CAK8P3a2nTi6AOf-4xJN3wurCXC52mLPBVbjgvcv6Cz=8A05X0A@mail.gmail.com>
Message-ID: <CAK8P3a2nTi6AOf-4xJN3wurCXC52mLPBVbjgvcv6Cz=8A05X0A@mail.gmail.com>
Subject: Re: [PATCH 13/15] scsi: sas: avoid gcc-10 zero-length-bounds warning
To:     James Bottomley <jejb@linux.ibm.com>
Cc:     John Garry <john.garry@huawei.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        James Bottomley <James.Bottomley@steeleye.com>,
        Hannes Reinecke <hare@suse.com>,
        linux-scsi <linux-scsi@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Provags-ID: V03:K1:Yn9pe+bgLmCVwhi7YwwfmpuvUlqqpff2IqM+sqv9UcQqCE0MCRj
 xwBd3kzBm3yKaBlRux5yWaSmhRhTW+l+OU52aCfL1kiTsApwDFcL77r9/GQVwg/uPiI9FPb
 nV/CJNC0Z66KWcRrBib2OtMl83Z6Aduy91K5zi4KMi6hrShRGRyQLhOC+x07ZxAqMuxuast
 6f+MXpqKJTyPL6p3un5Jg==
X-UI-Out-Filterresults: notjunk:1;V03:K0:oQxc4oroxpI=:ehXWVPLIDHEnyVyg50sJeB
 R+c0m6Q41X1oFype8KF9PcW/sOYmRr71EDmAs/He7/IizuC188qiCGfhg5WbmjdTEf6VbiMZU
 A2NP9EHOLGWtBVXgpt3Ak6HxYW3ahGumyazRUV58M0v/6wobDcT2Jq/n77TWlDs28/GVFF6t9
 iabc23ua5ZscDUXnYBrBbhQ2zEfu3QVlA7YvCiHhLA7oNwHKfGjIu5kOCJYl8RjNvbDJpMMFn
 cIhCfIc6TXcLiywnmepX4Hrohtw9NH9Sw3cdJ1hfakzxjwkUZiuxJ2QclPNz3nxo8IQQZRvdl
 5vrRM0V2vAgwDWNImu4qUmm5EqJ5aIaF+u5MMDnNvqNCV5d9DPEwybLesedFicCyRIt1ZGo+J
 QNVGcIuMKv4mujvS9PJv/CPdTO5tmXM2SEOLFzeyba+pCS4QJL1SC3ks8iiusCANS9beTo4U1
 qlfKJT/11A47h1Xe88y1VoE+Zk7A1cmzjL7AciqSA6p+ec6ddtaoKnzMysTYcHVXZDKKHFeZk
 Ia/IKIQ45PjWhC7pF4CPjK2ELjRMpcEjqYtc1ItQ5oE0olBUGLgh7LfATAfbTnfVRmJnWB+A1
 BKejFi8mcOAvGB58t7QyvEcCRzn5te2G0K2uWgN3CK/3/TviNDo3w2EeX6gwFZK7t/gP+sM+Y
 aq8+LLZAOFsSxBB0vjNBNFY8xdFlYKErjOTagdO8dmBIt+AOwr7jGLbnGbHbCclt/8IZKeOSh
 oiDHvnXt/JZixtFu7bIDDmQSNCE9SAU4u1ICySd+kVzT42e6/lQC93nZRAqCKETWWrJy7m7KD
 /XhUN8P/YMrgkBS8zNZVKi1Z1x79SeRasEbfUETN5uVAhf+aRc=
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Fri, May 1, 2020 at 4:53 PM James Bottomley <jejb@linux.ibm.com> wrote:
> On Fri, 2020-05-01 at 09:54 +0200, Arnd Bergmann wrote:
> > On Fri, May 1, 2020 at 9:48 AM John Garry <john.garry@huawei.com>
> > wrote:
> > I found one hack that would work, but I think it's too ugly and
> > likely not well-defined either:
> >
> > struct ssp_response_iu {
> > ...
> >         struct {
> >                 u8      dummy[0]; /* a struct must have at least one
> > non-flexible member */
>
> If gcc is now warning about zero length members, why isn't it warning
> about this one ... are unions temporarily excluded?

It does not warn about all zero-length arrays, but it does warn when you
try to access an array with an out-of-range index, and this apparently
got extended in gcc-10 to any index for zero-length arrays.

> >                 u8      resp_data[]; /* allowed here because it's at
> > the one of a struct */
> >         };
> >         u8     sense_data[];
> > } __attribute__ ((packed));
>
> Let's go back to what the standard says:  we want the data beyond the
> ssp_response_iu to be addressable either as sense_data if it's an error
> return or resp_data if it's a real response.  What about trying to use
> an alias attribute inside the structure ... will that work on gcc-10?

I think alias attributes only work for functions and variables, but not
for struct members.

A "#define sense_data resp_data" would obviously work, but it's
rather error-prone when other code uses the same identifiers.

Another option would be an inline helper like

static inline u8 *ssp_response_data(struct ssp_response_iu *iu)
{
      return iu.resp_data;
}

      Arnd
