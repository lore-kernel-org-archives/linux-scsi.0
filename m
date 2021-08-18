Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8C6DCC4338F
	for <linux-scsi@archiver.kernel.org>; Wed, 18 Aug 2021 00:54:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 61D6D61056
	for <linux-scsi@archiver.kernel.org>; Wed, 18 Aug 2021 00:54:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237071AbhHRAyq (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 17 Aug 2021 20:54:46 -0400
Received: from out2-smtp.messagingengine.com ([66.111.4.26]:45833 "EHLO
        out2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235604AbhHRAyp (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 17 Aug 2021 20:54:45 -0400
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailout.nyi.internal (Postfix) with ESMTP id AA9665C0178;
        Tue, 17 Aug 2021 20:54:11 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute4.internal (MEProxy); Tue, 17 Aug 2021 20:54:11 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=Zz+2Cl
        8Uy7Fh+ejBShZ+UblbJYguC8B5HiE28CeGbhs=; b=Ov5ucLyuSWx9/V7SgvPj2S
        teM9PIItYKVZFzRtMVZ4TqJRDKVSJAm/7oCzvcLV8nhtybayC6WGm+fHWzvdw4aK
        +66i7T1Aq8gGLtCf3szmh1qK3zHW2vJ5R0oSs92w1vQ2Jk5/pn9QqwYWrclkERvY
        NXhdJUnn9XWq0EOh+YZ+FpDiDVHKsOEO9CuhrBJOqaaDwQQHbAeTpvBr4s/ncHkl
        wx/rCW2E7Ilx+N5z03jWLslhX+r+/9UO4S7vS709C85O61vfPv7k5eHSFZuX31gB
        gT3k6CEVs/UXHz9aqTTDKo/T3pyCPD6HhoIOouwYZqR5qul7P/b5XRL+gba1SAbg
        ==
X-ME-Sender: <xms:MlocYfKaaAUsMCNVFDRBtoRVPsWJ8Xaasf_96byai6Vb41MHindPiQ>
    <xme:MlocYTKBzUNcf_NMrBBH_kxjZaQklzLcFd2tntZ9kRWsNNTem3gbLfKn41qccmWzz
    TzrIL8FFWEcFbv7sUQ>
X-ME-Received: <xmr:MlocYXtGC-6uxQvovZpaqmL8Gklzs3faBzI7OEsjI0OUthfUhFRKJWZg1srzI0wt4EtkOfyIzm033DSiERqZw-xGeeaJOnY4dPGyHA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvtddrleeggdefkecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenuc
    fjughrpeffhffvufgjkfhfgggtsehttdertddttddvnecuhfhrohhmpefhihhnnhcuvfhh
    rghinhcuoehfthhhrghinheslhhinhhugidqmheikehkrdhorhhgqeenucggtffrrghtth
    gvrhhnpeffudfhgeefvdeitedugfelueegheekkeefveffhfeiveetledvhfdtveffteeu
    udenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehfth
    hhrghinheslhhinhhugidqmheikehkrdhorhhg
X-ME-Proxy: <xmx:MlocYYbwZmSZDWItsWow3fqV22Az3B3y8kII2odtPcP43eyIFO9ucA>
    <xmx:MlocYWaRuGdaMt-YF2sdWsgei4GuQzvg3uBOOzD7l9j7RLsWp6zmBA>
    <xmx:MlocYcAoJvvZMzDNQ9CyCuexFloG5cQjegdXY7VIF0_xbN4R04gLYQ>
    <xmx:M1ocYbOg2tGoOQXd03i6EM3LvTdiwltL4pJt6RvVkm--oyEnpnBvAw>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Tue,
 17 Aug 2021 20:54:08 -0400 (EDT)
Date:   Wed, 18 Aug 2021 10:54:06 +1000 (AEST)
From:   Finn Thain <fthain@linux-m68k.org>
To:     Nathan Chancellor <nathan@kernel.org>
cc:     =?UTF-8?Q?Kai_M=C3=A4kisara?= <Kai.Makisara@kolumbus.fi>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        "Gustavo A. R. Silva" <gustavoars@kernel.org>,
        Nick Desaulniers <ndesaulniers@google.com>,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        clang-built-linux@googlegroups.com
Subject: Re: [PATCH] scsi: st: Add missing break in switch statement in
 st_ioctl()
In-Reply-To: <20210817235531.172995-1-nathan@kernel.org>
Message-ID: <7843ce6b-92ae-7b6c-1fc-acb0ffe2bbc0@linux-m68k.org>
References: <20210817235531.172995-1-nathan@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Tue, 17 Aug 2021, Nathan Chancellor wrote:

> Clang + -Wimplicit-fallthrough warns:
> 
> drivers/scsi/st.c:3831:2: warning: unannotated fall-through between
> switch labels [-Wimplicit-fallthrough]
>         default:
>         ^
> drivers/scsi/st.c:3831:2: note: insert 'break;' to avoid fall-through
>         default:
>         ^
>         break;
> 1 warning generated.
> 
> Clang's -Wimplicit-fallthrough is a little bit more pedantic than GCC's,
> requiring every case block to end in break, return, or fallthrough,
> rather than allowing implicit fallthroughs to cases that just contain
> break or return. Add a break so that there is no more warning, as has
> been done all over the tree already.
> 
> Fixes: 2e27f576abc6 ("scsi: scsi_ioctl: Call scsi_cmd_ioctl() from scsi_ioctl()")
> Signed-off-by: Nathan Chancellor <nathan@kernel.org>
> ---
>  drivers/scsi/st.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/drivers/scsi/st.c b/drivers/scsi/st.c
> index 2d1b0594af69..0e36a36ed24d 100644
> --- a/drivers/scsi/st.c
> +++ b/drivers/scsi/st.c
> @@ -3828,6 +3828,7 @@ static long st_ioctl(struct file *file, unsigned int cmd_in, unsigned long arg)
>  	case CDROM_SEND_PACKET:
>  		if (!capable(CAP_SYS_RAWIO))
>  			return -EPERM;
> +		break;
>  	default:
>  		break;
>  	}
> 
> base-commit: 58dd8f6e1cf8c47e81fbec9f47099772ab75278b
> 

Well, that sure is ugly.

Do you think the following change would cause any static checkers to spit 
their dummys and throw their toys out of the pram?

@@ -3828,6 +3828,7 @@ static long st_ioctl(struct file *file, unsigned int cmd_in, unsigned long arg)
 	case CDROM_SEND_PACKET:
 		if (!capable(CAP_SYS_RAWIO))
 			return -EPERM;
+		break;
-	default:
-		break;
 	}
 	
