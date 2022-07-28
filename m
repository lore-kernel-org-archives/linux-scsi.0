Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 837DBC04A68
	for <linux-scsi@archiver.kernel.org>; Thu, 28 Jul 2022 21:26:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229963AbiG1V0f (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 28 Jul 2022 17:26:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50114 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229570AbiG1V0e (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 28 Jul 2022 17:26:34 -0400
Received: from mail-ej1-x636.google.com (mail-ej1-x636.google.com [IPv6:2a00:1450:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 951135B04F
        for <linux-scsi@vger.kernel.org>; Thu, 28 Jul 2022 14:26:32 -0700 (PDT)
Received: by mail-ej1-x636.google.com with SMTP id ss3so5227644ejc.11
        for <linux-scsi@vger.kernel.org>; Thu, 28 Jul 2022 14:26:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:subject:from:to:cc:date:in-reply-to:references
         :content-transfer-encoding:user-agent:mime-version;
        bh=gOm5WzTFcp6H1IZFGOjdTMXk3A3yXZdzdCMWdzGm6XM=;
        b=HOhRdQU+mkVcqXA0SwSceYUDsOYp3cQTUQp33i5l/isCD+eWR/FkCNRf+5ruq623yU
         3Kp89ReMWspmMKIWuifPkuE6pGWSEEbiOq/B9DY0yO1iSZ/BzifnDNlHSAa4SGfHC/ws
         KchLVp1vsdBkzyT7dww+hstw3/w6SBRxEYHb0+ZDMV6nvnRbR0LdL5EAGMs3uNt99gSI
         ioO5EZQ7VhgUcThIojfugYl4MHHRtP5+rdMG8U8I8JAUJ1O3vqmQ9e7eqCP2InzJIZY4
         ZANUP0zz7tRqrK0JqRpl8+YxtH6zPzSwQvIcEQpZu0Zxm/v2UhHsqxb/HRSXR01+mK9p
         OjJg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:content-transfer-encoding:user-agent:mime-version;
        bh=gOm5WzTFcp6H1IZFGOjdTMXk3A3yXZdzdCMWdzGm6XM=;
        b=D/pfbOdARVRd+cYMdyhdZ6/+ms7sGoB0Ztf5jrQ1mJtWCtlwbsAMuMD5zXHQXdcsgv
         CyZIaDKpi0XHC06yiWMxMWBsBTW6zZBO6yizWIgC4FscKP006scE1/7P4KCL3ykPezuL
         s8cwkzYdWFc2rWyOhP5WNLdxOlrXHVw0BToPpGWLp3S1EMmy6T9bv1XsldmUDOJnyXyT
         DUk/Vik3yDYFaUj7/uSTioQwOL8kMy3cM0dffo9TK0e2LUeEin2mk6Qkne51IWWRIGFL
         TgAkZ4kXD1l697O6DLnz5ZIlXmcNTefIUq/3/E4mK4/0JbuwWarhAK+0iUWUDLf29Ld2
         jG/w==
X-Gm-Message-State: AJIora/UJG1bCiTMph0lecPsKFNQr3EHfnbGHqKmEf95B33xT1aUc+RS
        3RGlqjppronJpinTTtvNI7M=
X-Google-Smtp-Source: AGRyM1sjMC9NeXxDwGxrbYL6KH/FQzVMzZ1dXYM4nN6jLAFPMfO0gGy9dUfKZGZZUyhKSxd0H5ZhzA==
X-Received: by 2002:a17:906:58d1:b0:72e:e049:cf00 with SMTP id e17-20020a17090658d100b0072ee049cf00mr571193ejs.361.1659043590978;
        Thu, 28 Jul 2022 14:26:30 -0700 (PDT)
Received: from p200300c5870e1483ac11a16c0f4ae195.dip0.t-ipconnect.de (p200300c5870e1483ac11a16c0f4ae195.dip0.t-ipconnect.de. [2003:c5:870e:1483:ac11:a16c:f4a:e195])
        by smtp.googlemail.com with ESMTPSA id wi7-20020a170906fd4700b0072f03d10fa0sm814398ejb.207.2022.07.28.14.26.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 28 Jul 2022 14:26:30 -0700 (PDT)
Message-ID: <e2fba3fe9b10d060a9906c440dd1f55e52404d77.camel@gmail.com>
Subject: Re: [PATCH v1 0/2] ufs: allow vendor disable wb toggle in clock
 scaling
From:   Bean Huo <huobean@gmail.com>
To:     Bart Van Assche <bvanassche@acm.org>, peter.wang@mediatek.com,
        stanley.chu@mediatek.com, linux-scsi@vger.kernel.org,
        martin.petersen@oracle.com, avri.altman@wdc.com,
        alim.akhtar@samsung.com, jejb@linux.ibm.com
Cc:     wsd_upstream@mediatek.com, linux-mediatek@lists.infradead.org,
        chun-hung.wu@mediatek.com, alice.chao@mediatek.com,
        cc.chou@mediatek.com, chaotian.jing@mediatek.com,
        jiajie.hao@mediatek.com, powen.kao@mediatek.com,
        qilin.tan@mediatek.com, lin.gui@mediatek.com
Date:   Thu, 28 Jul 2022 23:26:29 +0200
In-Reply-To: <968f5255-f7b9-e011-2bd3-aa711bdd142a@acm.org>
References: <20220728071637.22364-1-peter.wang@mediatek.com>
         <968f5255-f7b9-e011-2bd3-aa711bdd142a@acm.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.44.1-0ubuntu1 
MIME-Version: 1.0
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Thu, 2022-07-28 at 14:09 -0700, Bart Van Assche wrote:
> On 7/28/22 00:16, peter.wang@mediatek.com=C2=A0wrote:
> > Mediatek ufs do not want to toggle write booster when clock
> > scaling.
> > This patch set allow vendor disable wb toggle in clock scaling.
>=20
> I don't like this approach. Whether or not to toggle the write
> booster=20
> when scaling the clock is not dependent on the host controller and
> hence=20
> should not depend on the host controller driver.
>=20
> Has it been considered to add a sysfs attribute in the UFS driver
> core=20
> to control this behavior?
>=20

Bart,=20
we already have wb_on sysfs node, but it only allows to write this node
when clock scaling is not supported.


static ssize_t wb_on_store(..)
{
	struct ufs_hba *hba =3D dev_get_drvdata(dev);
	unsigned int wb_enable;
	ssize_t res;

	if (ufshcd_is_clkscaling_supported(hba)) {
		/*
		 * If the platform supports
UFSHCD_CAP_AUTO_BKOPS_SUSPEND,
		 * turn WB on/off will be done while clock scaling
up/down.
		 */
		dev_warn(dev, "To control WB through wb_on is not
allowed!\n");
		return -EOPNOTSUPP;
	}


Kind regards,
Bean

> Thanks,
>=20
> Bart.

