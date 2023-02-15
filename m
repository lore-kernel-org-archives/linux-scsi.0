Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A4D0DC636CC
	for <linux-scsi@archiver.kernel.org>; Wed, 15 Feb 2023 04:43:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233065AbjBOEnU (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 14 Feb 2023 23:43:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59940 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229483AbjBOEnQ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 14 Feb 2023 23:43:16 -0500
Received: from esa2.hgst.iphmx.com (esa2.hgst.iphmx.com [68.232.143.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AA58D1422E
        for <linux-scsi@vger.kernel.org>; Tue, 14 Feb 2023 20:43:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1676436188; x=1707972188;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=rllAuMPvoBr0L1lHfSbaKvi2l3urZy0SiU0ZdfBD6O0=;
  b=Kx421RkRgioVqEbNNPGLQB/uxtVkfcnARCwM4eKOCWa+WzDuSXexGC1o
   3JNzLSp/cGSlayJwAjBDiVynw9qA3PQBNdPD4vDvBvjXhyIJdEAjNjalP
   FkYTqfng5jYlsVytBMVv5aTiD379VkbHCzw+IZsfWv0HK+LbyT6k3Tb6s
   ob0TLQ1qdiRU4wgy6eBh7E3Z8IuVausUlOo3DpRQUe8ntxugXNXA8NWXk
   siaav+MQ2ypSU5ArCHGVhsjAUEcP3FgshbbBjUaC0bc6JfpUcX1QTttoO
   82LRB2LMU9HR7EpnwT2a7Q17e4Bj0yFC+A8Pz48mQCSddJ/A2ABWK+2nB
   g==;
X-IronPort-AV: E=Sophos;i="5.97,298,1669046400"; 
   d="scan'208";a="327634830"
Received: from uls-op-cesaip01.wdc.com (HELO uls-op-cesaep01.wdc.com) ([199.255.45.14])
  by ob1.hgst.iphmx.com with ESMTP; 15 Feb 2023 12:43:03 +0800
IronPort-SDR: EVFDcFlpRjrbFHI2c2ijxalNfBwdIvT4pgu7En6jmIDd0+G+6EskcQvQyMVDH6wUDs25qCV+cj
 qxrJYALljgTkKvOhh0F6qk3v7Yo6BS/jcwY3MT1UjqffjBAbhokcLqGWTP5qfngn7RWcj4urKV
 pFrFg8pYa8r+czP6iwTb1BLYnbXfBdaobIGxgglVYW8QZ4Gq2BsfF9GOwO7zb3fHCR/sMcx4U1
 FyXXkfmM2O9VPCtpWXG3Hwl3Kt1LgmF6ATRtff2R7G9d3G9ITyGmRtz1qvN1SfoKO28q067w0Z
 C50=
Received: from uls-op-cesaip01.wdc.com ([10.248.3.36])
  by uls-op-cesaep01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 14 Feb 2023 20:00:10 -0800
IronPort-SDR: eT8xiJ/Da9mCDmaFXnExjsJ2RuJgJ/qdmXHPo+NpYU+oGzH4mP+76ONB9s+NdP2BamoFL25OfK
 3222tvL8G61kVL+9tTSsCO7G13c054tk6p6Y/7/Alz+Loih/aSOf0hsCqVF39IO1Hd1vv7VND0
 aeoTCC9leMtMuLam+EBL7NabYQkCcOVtwHxCxPFFiHJ2e4uS8q5zODJ9IqtVOBWLsh9VlronY9
 8P+DOAk+SjQzMb5QqmUjfRCiuERVOb3k2fewmmghwF7gySMYCqeoaHa/XIrLSaddjCcU0dinO8
 g0M=
WDCIronportException: Internal
Received: from usg-ed-osssrv.wdc.com ([10.3.10.180])
  by uls-op-cesaip01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 14 Feb 2023 20:43:04 -0800
Received: from usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTP id 4PGlnM1VSzz1RwtC
        for <linux-scsi@vger.kernel.org>; Tue, 14 Feb 2023 20:43:03 -0800 (PST)
Authentication-Results: usg-ed-osssrv.wdc.com (amavisd-new); dkim=pass
        reason="pass (just generated, assumed good)"
        header.d=opensource.wdc.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=
        opensource.wdc.com; h=content-transfer-encoding:content-type
        :in-reply-to:organization:from:references:to:content-language
        :subject:user-agent:mime-version:date:message-id; s=dkim; t=
        1676436182; x=1679028183; bh=rllAuMPvoBr0L1lHfSbaKvi2l3urZy0SiU0
        ZdfBD6O0=; b=dHQcYyajSSXM3vLe5O/aieZcOGHfjTcjzMVab0z7BQxFXU3AFt7
        iBcfAg5kHGp/5Re1Suib2SfpNsfA4/wXnNbUEeMf+xcGJRae9VnnWCpttZnYHcJA
        iF3CnB2ioq64V9Zsb88hVrkAUeWavmELQzeY9PylCte00lyxUXOiO0XvDYoSZtJA
        KCML8nF4cHwSngLEW5vuVrKsFCakIfeQq3Df1QAEUBnZ/TL2faF2sIS0F05PGV79
        ia3cjxFss3JRqxvvKkElS7ooNpl9zzv1ldvSZrBzqdPflMvhbUxhK9P+vF0YOkYB
        SAeE0lIHOkiyeoYDOEqfDTBIGGrBL7qYxUA==
X-Virus-Scanned: amavisd-new at usg-ed-osssrv.wdc.com
Received: from usg-ed-osssrv.wdc.com ([127.0.0.1])
        by usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id YvmGrB-GKLTz for <linux-scsi@vger.kernel.org>;
        Tue, 14 Feb 2023 20:43:02 -0800 (PST)
Received: from [10.225.163.116] (unknown [10.225.163.116])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTPSA id 4PGlnJ0CZsz1RvLy;
        Tue, 14 Feb 2023 20:42:59 -0800 (PST)
Message-ID: <63b3aeca-d219-264c-c944-eb4e85f36f9f@opensource.wdc.com>
Date:   Wed, 15 Feb 2023 13:42:58 +0900
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.1
Subject: Re: [PATCH] [v2] scsi: ipr: work around fortify-string warning
Content-Language: en-US
To:     Arnd Bergmann <arnd@kernel.org>, Brian King <brking@us.ibm.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Nathan Chancellor <nathan@kernel.org>,
        Nick Desaulniers <ndesaulniers@google.com>,
        James Bottomley <James.Bottomley@SteelEye.com>
Cc:     Arnd Bergmann <arnd@arndb.de>, Kees Cook <keescook@chromium.org>,
        Niklas Cassel <niklas.cassel@wdc.com>,
        John Garry <john.g.garry@oracle.com>,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        llvm@lists.linux.dev
References: <20230214132831.2118392-1-arnd@kernel.org>
From:   Damien Le Moal <damien.lemoal@opensource.wdc.com>
Organization: Western Digital Research
In-Reply-To: <20230214132831.2118392-1-arnd@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2/14/23 22:28, Arnd Bergmann wrote:
> From: Arnd Bergmann <arnd@arndb.de>
> 
> The ipr_log_vpd_compact() function triggers a fortified memcpy() warning
> about a potential string overflow with all versions of clang:
> 
> In file included from drivers/scsi/ipr.c:43:
> In file included from include/linux/string.h:254:
> include/linux/fortify-string.h:520:4: error: call to '__write_overflow_field' declared with 'warning' attribute: detected write beyond size of field (1st parameter); maybe use struct_group()? [-Werror,-Wattribute-warning]
>                         __write_overflow_field(p_size_field, size);
>                         ^
> include/linux/fortify-string.h:520:4: error: call to '__write_overflow_field' declared with 'warning' attribute: detected write beyond size of field (1st parameter); maybe use struct_group()? [-Werror,-Wattribute-warning]
> 2 errors generated.
> 
> I don't see anything actually wrong with the function, but this is the
> only instance I can reproduce of the fortification going wrong in the
> kernel at the moment, so the easiest solution may be to rewrite the
> function into something that does not trigger the warning.
> 
> Instead of having a combined buffer for vendor/device/serial strings,
> use three separate local variables and just truncate the whitespace
> individually.
> 
> Fixes: 8cf093e275d0 ("[SCSI] ipr: Improved dual adapter errors")
> Cc: Kees Cook <keescook@chromium.org>
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>

Looks good to me.

Reviewed-by: Damien Le Moal <damien.lemoal@opensource.wdc.com>

-- 
Damien Le Moal
Western Digital Research

