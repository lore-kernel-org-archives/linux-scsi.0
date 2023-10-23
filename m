Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4EB28CDB474
	for <linux-scsi@archiver.kernel.org>; Mon, 23 Oct 2023 13:56:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229987AbjJWN4j (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 23 Oct 2023 09:56:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54112 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229476AbjJWN4i (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 23 Oct 2023 09:56:38 -0400
Received: from mail.alien8.de (mail.alien8.de [65.109.113.108])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 027FB100
        for <linux-scsi@vger.kernel.org>; Mon, 23 Oct 2023 06:56:36 -0700 (PDT)
Received: from localhost (localhost.localdomain [127.0.0.1])
        by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTP id 218C040E0187;
        Mon, 23 Oct 2023 13:56:34 +0000 (UTC)
X-Virus-Scanned: Debian amavisd-new at mail.alien8.de
Authentication-Results: mail.alien8.de (amavisd-new); dkim=pass (4096-bit key)
        header.d=alien8.de
Received: from mail.alien8.de ([127.0.0.1])
        by localhost (mail.alien8.de [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id LZWpBHGh31YH; Mon, 23 Oct 2023 13:56:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=alien8;
        t=1698069391; bh=/jf3Aw+157DSj+x3WYZ3ioN1WhAyTdxmgpy2sIv6h6k=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=OOIDemZPb6NMkwsKCM3In1ymwC+hKji5NJzgrbTqjg5XeAr360MilDX6jGEz/Y7Tr
         ooycWRer+nuL0A0lNAXRoTUIYTsEan/2UJTozlQTagVOa+YXm88pFcM8cBAtJL6YGV
         GWI9wvD6a/lTv6Zm2+5aVft3ZmotKsC/uuD3GoOX+PPexYfUZBjSmPt4ZNsinQwkyX
         JwGFHTvYU54VXuTHMcn3ReBJKNHsPAvU3tnKoELGJv55Y/PeDC3GLIQVbW8uCnX8xd
         n8aguekyJ5t4SAGdTV+WhqO8Sg/qnkPyYOrva9lKd3PfRTbDNzXtz9MBjvXESuE8Zi
         +xKwmq08e2fMqsxBI0E9Md/g3v6hr7fpWFFMa4NlKmMjLW9O1ZN8SHf7jMp+ao43UR
         dGsmE+BIHBXo7TZfpZcBtd6iMm07I6ZeaGOoOyC4wP2pP+BmTT2fINh4dN3yJra3jR
         9J6HYfapMfPMcfe25c+UfdjycAUfthskeXvSUHlt9Rf+7//GzGr+HKMrAd8gDAuKf/
         A+PdZ+qVR+OsvCB9TCgz3JFbWwX7WAHNfplA8Z3Wln7TO2sW29UmqSUaIamB0+NMQB
         Yh+SostJE2u1mFp8cDYqLvUGJlxuS0rXsDspMDdGwC70TKpQ1v12jEL2N/Qyo4eB+I
         PBWmCWCsnRf61JgmwYv4tR90=
Received: from zn.tnic (pd95304da.dip0.t-ipconnect.de [217.83.4.218])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature ECDSA (P-256) server-digest SHA256)
        (No client certificate requested)
        by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 3309640E0196;
        Mon, 23 Oct 2023 13:56:21 +0000 (UTC)
Date:   Mon, 23 Oct 2023 15:56:15 +0200
From:   Borislav Petkov <bp@alien8.de>
To:     Niklas Cassel <Niklas.Cassel@wdc.com>
Cc:     "MPT-FusionLinux.pdl@broadcom.com" <MPT-FusionLinux.pdl@broadcom.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        Sathya Prakash <sathya.prakash@broadcom.com>,
        Sreekanth Reddy <sreekanth.reddy@broadcom.com>,
        Suganath Prabu Subramani 
        <suganath-prabu.subramani@broadcom.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Kees Cook <keescook@chromium.org>, James Seo <james@equiv.tech>
Subject: Re: mpt3sas ubsan issues
Message-ID: <20231023135615.GBZTZ7fwRh48euq3ew@fat_crate.local>
References: <20231023082958.GAZTYvBlIB2UPUCUyA@fat_crate.local>
 <ZTZEw0NwY28foZPP@x1-carbon>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <ZTZEw0NwY28foZPP@x1-carbon>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi,

On Mon, Oct 23, 2023 at 10:02:45AM +0000, Niklas Cassel wrote:
> I think this series might solve your issues:
> 
> https://lore.kernel.org/linux-scsi/202310101748.5E39C3A@keescook/T/#t
> 
> However, the series hasn't been merged yet.
> (Apparently because the mpt3sas maintainers haven't yet acked the series.)

Yap, with them ontop of -rc7 it looks good.

Tested-by: Borislav Petkov (AMD) <bp@alien8.de>

Thx.

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
