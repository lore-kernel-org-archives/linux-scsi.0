Return-Path: <SRS0=DEWY=5Z=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A2E9EC2BB86
	for <linux-scsi@archiver.kernel.org>; Thu,  9 Apr 2020 11:48:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 79B4E20A8B
	for <linux-scsi@archiver.kernel.org>; Thu,  9 Apr 2020 11:48:33 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=gmx.net header.i=@gmx.net header.b="J+zaT7oE"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726594AbgDILsa (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 9 Apr 2020 07:48:30 -0400
Received: from mout.gmx.net ([212.227.17.21]:34895 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726082AbgDILsa (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 9 Apr 2020 07:48:30 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.net;
        s=badeba3b8450; t=1586432896;
        bh=H9Ga5jpyZLg1O/BF7Ps4kUP4WNWpS6cIcAAqD8cyaE0=;
        h=X-UI-Sender-Class:Date:From:To:Cc:Subject:References:In-Reply-To;
        b=J+zaT7oEkp3K672N4daAtIgiJjDfTC9LV6h/YnhP5a4+vvN0/Zgv6TYj4+3V7m5B2
         NIMwZZoHISUjwZb1m63CnWJ2n0/z8yXZdbOie7x4sWad7bLITVpokpS99QsGXKYRJK
         2ndI3ExpH4cWhKT0iOD5tOMt9MIVYIaaZ2nkgxiA=
X-UI-Sender-Class: 01bb95c1-4bf8-414a-932a-4f6e2808ef9c
Received: from medion ([82.19.195.159]) by mail.gmx.com (mrgmx104
 [212.227.17.174]) with ESMTPSA (Nemesis) id 1Mnaof-1iuuYf0iGL-00jW56; Thu, 09
 Apr 2020 13:48:16 +0200
Date:   Thu, 9 Apr 2020 12:48:13 +0100
From:   Alex Dewar <alex.dewar@gmx.co.uk>
To:     Markus Elfring <Markus.Elfring@web.de>
Cc:     linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        Hannes Reinecke <hare@suse.com>,
        "James E. J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Qiujun Huang <hqjagain@gmail.com>
Subject: Re: scsi: aic7xxx: Remove null pointer checks before kfree()
Message-ID: <20200409114813.g3k4phoguduz6pw2@medion>
References: <72bc89d5-cf50-3f3a-41e0-b46b134e754d@web.de>
 <20200407155453.sosj4brsw6r7fnot@lenovo-laptop>
 <99c64c9f-0a9f-aafb-2e32-da7e026f9940@web.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <99c64c9f-0a9f-aafb-2e32-da7e026f9940@web.de>
X-Provags-ID: V03:K1:5F/25Q3BIGIo0LirsLcAFEQpQX/CjNrAelAZcQ0qattnvTBVEX8
 VbvTgo5WhmDJsa/L2isZKOvt8yobFOXQtw2uwLWGYnm/uKaFZGtD7Pu+DGO6a8mjRhJZT96
 mX8TdAnZDjr+XzLt6l3nid+peWD8fINb47jydctPmdmuzgq4cIaPX7nhZoU/f/uOd6FrnGG
 baphLvxFbLJaSN90MFLMw==
X-UI-Out-Filterresults: notjunk:1;V03:K0:cOW6ZFxK+SA=:P3BSyZ3t1sTuATXurH+XWO
 kjXLk2Mu9q+ZLtZpPJuI179MHpaiG+gCG/1F2eoZYkNR8fud5BFH+7gszXJKgbiCkLCZzgnaH
 oJTTHHTQHYFTUnYTIunUGrSU+fMl2GJ7eiaD+F1FHt1UyutlMs8E+oTzZBKeLpBby0rszENcZ
 bip+B2fh23nA1fDF+/3zGXgLZlZTQJGuTxfPLZkwi2k0gs2Xbxc+dFVZ4d2srlt06RFwDVQpl
 1EwqyFynjiAb4Z0qswMSuYDCm6D+HZeT7zr711MtwBcp1+oM03Z7q7MxQWRqdjNd1or5pgApo
 WXCyJt7OXurabxbd+bc+QFaVJlbqZD9UMmPPTzx/LB7qVA+a17fWO4jOBSsc6VHc//O3MJTaK
 5BuNscFsLmJSY1w9abNj5+UilUkicTR2aQ8n2GUp1595mhNPsTGUBALMJiwZeFG+K7H6OkTkS
 jhgpOSl1KdDp91aa7cstob8EYp00JgLYnierzxZ9PlaoUTYUZdWW1B+SDKvTiN8d7Zs5na48w
 B+4gQnGTRb7bkfpwA89y6eJwCuHp4tX302Hf/B4dFnyzuiZz38TwRzMZGq0j79zLkwmyxM3y4
 ik+dekFAduPK5AsQhc6S5cIE6Zt/3NuEZ6OByjhSWgYTNu4F7CQ1LZkQpVXmEKBxGbwT5Cs42
 NfYPkjA7YCWYMkSwLnxkvf4sBXPnp8++kR0vPbrD0YEdxLOXDvq7HkQAEKunnC6HAsWycOmis
 SQdk4r6ZntwpxNQsfpWv5a9kbAYMdN9TiXLLRTJJ20i4vQy9r+lXWQIfhg9QlmSEZAVod5Ebp
 4l3ukLb/d5BD3Yv9qX6d1AiRIn+lyg/DaPj5FQvDGnjGHUn0Oh4Kgd9mecH/E9u5ryI1YX55Z
 fm8CTxYKcM+zxuM3WY5nE8vF47thizhXuI1otQGE0uZpwo1VlNYkW/Ko31guFxG8wNzdXate3
 btFYnCIjKVigjzKOOK6tJHKXMm0cmCU79pz/gVgYuLGhHiKXz9/oBocGjB6UmXQM5IQDWbWdP
 O4UnhNb+Qiumq+3wdVTCbBgGlBe7C2RGn7IW1u9GaxWbSiKRkV52gZTannR9hsib8A4eFhKZa
 5HWx8Qnsp1/D3gAJ9MIoBGeDdY7mJdEHBIhwtld3OLcxVQsUE3CxfV0fPGcvnwoPo9xT+z5Vi
 cL1nBReiNjEG88BW9WJ1JWp7X6vlt2QutrQ5XfbgHpKA8g3w4UltnBSOslDPJMiT3khsPNC5i
 Yhs/PH2Ix9Z3d90+w
Content-Transfer-Encoding: quoted-printable
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Tue, Apr 07, 2020 at 06:32:19PM +0200, Markus Elfring wrote:
> >> I hope that you would like to take another update suggestion into acc=
ount
> >> (besides a typo correction for your commit message).
> >> https://lore.kernel.org/patchwork/patch/1220189/
> >> https://lore.kernel.org/linux-scsi/20200403164712.49579-1-alex.dewar@=
gmx.co.uk/
> >
> > I'm not sure I understand the relevance.
>
> I pointed your patch out for another contributor.
>
>
> > Are you saying I should reference this other patch?
>
> I suggest to take another look at the development history for presented
> patches according to a known source code search pattern.

Ok, cool. How should I go about that?

The thing is that this seems like an obvious improvement (albeit not a
terribly critical one). It reduces SLoC and removes an unnecessary
check. AFAICS the patch you mention wasn't rejected on technical
grounds, but simply wasn't picked up. If there is a reason why this
change isn't warranted then I'd like to know why so I can send better
patches in future :-)

>
>
> > Thanks for the reference. I'll mention it in the commit if I do a v2.
>
> I am curious under which circumstances the affected source files
> will actually be improved in ways which were suggested a few times.
>
> Regards,
> Markus
