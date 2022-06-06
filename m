Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D0A3AC43334
	for <linux-scsi@archiver.kernel.org>; Mon,  6 Jun 2022 02:48:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352237AbiFFCsK (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 5 Jun 2022 22:48:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47862 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242467AbiFFCsI (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 5 Jun 2022 22:48:08 -0400
Received: from esa6.hgst.iphmx.com (esa6.hgst.iphmx.com [216.71.154.45])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 50527140F6
        for <linux-scsi@vger.kernel.org>; Sun,  5 Jun 2022 19:48:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1654483687; x=1686019687;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=D/wS6F2qtObb/FfuG5OxzP+ia1M5T+oSNe0EBUl49xg=;
  b=fCgseHhT0em9GDLiu4/ytS/FosGgLdcyjVUzYnWYR/4jfbFm9+48xPjM
   HPKx0sszxS4UHDcRUn4abiKbX7FV8WlGIuYDsQFbRod1uT8ETMBbdJr1K
   7VqBln5DjXGCv7NCX6xxVnMrvwYuDdg5OQbLF3lnXsGkTU+v40+f/wP5w
   X4LjsQEvta8Dy8L4Jw+NOgNB+AFoULdddGEyiEuwWBSlev4rtv6MLMauZ
   9kM5YaorR90KTYeNK4KbkYGLPk3l88Na6BGc9YKHLhitY7lVkSWGBKU9h
   tEjc7EQHFEc2VyQKIrvPZbx64Qpc68Lj/jhDfYJO7COmBqysbH7RnHDxY
   g==;
X-IronPort-AV: E=Sophos;i="5.91,280,1647273600"; 
   d="scan'208";a="203119275"
Received: from uls-op-cesaip01.wdc.com (HELO uls-op-cesaep01.wdc.com) ([199.255.45.14])
  by ob1.hgst.iphmx.com with ESMTP; 06 Jun 2022 10:48:07 +0800
IronPort-SDR: Psk+Oz7xv7SgFg5Lt/gnSRFc/Xlsd8AkyDjTUkvkIN943ZD8KoKGBW5+Ucz+hA2Nm1ZeEmT7SA
 DlakD0gzEW/eKQVrLD72f3EuW1//kmkbQdpcGsn32Scd8B2cTE6BPmr8OL+Rl/E8u84LtuEpuP
 NiVAe/cg7+CYatYD25PSkoGvnMJn90CPGBqXe0AeNzJWyn40RjMU3xaDJi6bSqwykASPgplf7f
 vg/ZR6tjFxT2BbvBwVmJFhBGMci6phLv1EgOkztm1pqTn+0sjm77pMddMqDcyGZ4pFoJJh+48f
 HTp/RQaPk6Z1vldLiiEJ/eAT
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 05 Jun 2022 19:11:27 -0700
IronPort-SDR: lqjCxefmwW9loe/N09XAnMlC+lHWOv2XL2S7BjsEz1BO0FTqd+OGogUfvXoQxY7l29CpriKNW3
 KL88RqgLFNNwaEqDZsXrI664Kg+QfG1VgMzbgYN6fcgW5NmNVQB1Ad9QDKYSgppdWW9FKvQZRo
 0jHA+HsYHOnTGA2GmC0oU53oZ69duJuDCmxh8mdm4YtLE/YpKrCFWuCykwhmsbBfLRCBCWori6
 wI2IWrNh72JZymLSLI6SAWsQqk7pUuUBBPKEmPVRKZOQ3CCC2qrtkWarqERuURbB0KW8j64dMx
 vY8=
WDCIronportException: Internal
Received: from usg-ed-osssrv.wdc.com ([10.3.10.180])
  by uls-op-cesaip02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 05 Jun 2022 19:48:07 -0700
Received: from usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTP id 4LGdFy0FsNz1SVnx
        for <linux-scsi@vger.kernel.org>; Sun,  5 Jun 2022 19:48:06 -0700 (PDT)
Authentication-Results: usg-ed-osssrv.wdc.com (amavisd-new); dkim=pass
        reason="pass (just generated, assumed good)"
        header.d=opensource.wdc.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=
        opensource.wdc.com; h=content-transfer-encoding:content-type
        :in-reply-to:organization:from:references:to:content-language
        :subject:user-agent:mime-version:date:message-id; s=dkim; t=
        1654483685; x=1657075686; bh=D/wS6F2qtObb/FfuG5OxzP+ia1M5T+oSNe0
        EBUl49xg=; b=d3dlbZMa6gaY3hULhIWoEKv6PVGRqRPMuhOz0C2c2KhqPDJM6yr
        7LZI1PPTTX/14vzTEcmERaWpNWrjm/dclvcOVvQo98bYDCeEIH5fVWRAwS8HIjzD
        AT2uy8O9hWtwGGNzTd5GPvps3u2Q9VCbVKQAjizuCbGfdObJChsS5siq+/1hAbzU
        65yTiuBF0gVI1nXbmFB3KVOsto+2WXaodQlAZpVMdS+bBZ2scyPWZswunlT3Nw01
        ly94Vvpkf7LLdV9UURUrqdKsHT4AkgnPQZ2oBjQrmeX2Qj30sYcktr+9HYzt+Xft
        m2j031FcpSh5iHLlzEPPmeLUQ1eLoDqElHQ==
X-Virus-Scanned: amavisd-new at usg-ed-osssrv.wdc.com
Received: from usg-ed-osssrv.wdc.com ([127.0.0.1])
        by usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id hgR1RZ9ezhuG for <linux-scsi@vger.kernel.org>;
        Sun,  5 Jun 2022 19:48:05 -0700 (PDT)
Received: from [10.225.163.72] (unknown [10.225.163.72])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTPSA id 4LGdFt50L7z1Rvlc;
        Sun,  5 Jun 2022 19:48:02 -0700 (PDT)
Message-ID: <3c400db6-d251-c4bd-b019-b9dc1d807212@opensource.wdc.com>
Date:   Mon, 6 Jun 2022 11:48:01 +0900
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.10.0
Subject: Re: [RESEND PATCH] scsi: ufs: sysfs: support writing boot_lun attr
Content-Language: en-US
To:     Bart Van Assche <bvanassche@acm.org>,
        Avri Altman <Avri.Altman@wdc.com>,
        Caleb Connolly <caleb.connolly@linaro.org>,
        "a5b6@riseup.net" <a5b6@riseup.net>,
        Alim Akhtar <alim.akhtar@samsung.com>,
        "James E . J . Bottomley" <jejb@linux.ibm.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Cc:     "~postmarketos/upstreaming@lists.sr.ht" 
        <~postmarketos/upstreaming@lists.sr.ht>,
        "phone-devel@vger.kernel.org" <phone-devel@vger.kernel.org>
References: <20220525164013.93748-1-a5b6@riseup.net>
 <DM6PR04MB65750969ACD36EEEB48374DFFCD69@DM6PR04MB6575.namprd04.prod.outlook.com>
 <8d25171a-5d86-9acc-0f94-1a3c6efdb360@riseup.net>
 <DM6PR04MB65752422396C86EAD4591701FCD89@DM6PR04MB6575.namprd04.prod.outlook.com>
 <a7f46ad1-6d9e-a38e-31cc-29fddfa2b496@linaro.org>
 <DM6PR04MB65751A3B1D0BA4467CADDA93FCDF9@DM6PR04MB6575.namprd04.prod.outlook.com>
 <a4746c67-fa74-8af1-3f2d-7853e9fae8a6@acm.org>
From:   Damien Le Moal <damien.lemoal@opensource.wdc.com>
Organization: Western Digital Research
In-Reply-To: <a4746c67-fa74-8af1-3f2d-7853e9fae8a6@acm.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 6/5/22 12:55, Bart Van Assche wrote:
> On 6/1/22 10:05, Avri Altman wrote:
>> As a design rule, sysfs attribute files should not be used to make
>> persistent modifications to a device configuration. This rule applies
>> to all subsystems and ufs is no different.
> 
> Hmm ... where does that rule come from? I can't find it in
> Documentation/admin-guide/sysfs-rules.rst. Did I perhaps overlook something?

I am not aware of any writable sysfs attribute file that can be used to
make persistent device configuration changes, at least in storage area.
I know of plenty that do change a device setting, but without saving this
setting to maintain it across power cycles. Do you know of any such
attribute ? I was under the impression that sysfs should not be used to
persistently reconfigure a device...

-- 
Damien Le Moal
Western Digital Research
