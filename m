Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E0297CE7A91
	for <linux-scsi@archiver.kernel.org>; Mon, 25 Sep 2023 01:11:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231492AbjIYBLb (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 24 Sep 2023 21:11:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38486 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231503AbjIYBLa (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 24 Sep 2023 21:11:30 -0400
X-Greylist: delayed 302 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Sun, 24 Sep 2023 18:11:22 PDT
Received: from ciao.gmane.io (ciao.gmane.io [116.202.254.214])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9E657107
        for <linux-scsi@vger.kernel.org>; Sun, 24 Sep 2023 18:11:22 -0700 (PDT)
Received: from list by ciao.gmane.io with local (Exim 4.92)
        (envelope-from <lnx-linux-scsi@m.gmane-mx.org>)
        id 1qka3E-000464-Re
        for linux-scsi@vger.kernel.org; Mon, 25 Sep 2023 03:06:16 +0200
X-Injected-Via-Gmane: http://gmane.org/
To:     linux-scsi@vger.kernel.org
From:   deloptes <emanoil.kotsev@deloptes.org>
Subject: Re: SSD SATA 3.3 and Broadcom / LSI SAS1068E PCI-Express Fusion-MPT SAS
Followup-To: gmane.linux.scsi
Date:   Mon, 25 Sep 2023 03:06:11 +0200
Message-ID: <ueqme3$35h$1@ciao.gmane.io>
References: <ubgv7c$43t$1@ciao.gmane.io> <20230815231517.GA271814@bhelgaas>
Reply-To: emanoil.kotsev@deloptes.org
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8Bit
User-Agent: KNode/0.10.9
X-Face: &bB+dG6r\D$gd^NFeYm<f{n8m&2W,Lr'h>#MNOHtI/(z<->Su~)mL1rYXAE7W:U2d;tQAEP  ?3('tC@:iV_x)~3Kq.-X\\j1HU;i6/u\An"y=\gO%d`v#QdRgaw9JySH|xOp&6giT2q+z3j<t`[9@b  _&-<C%rE*@-)n9uI5?P_u9`8x.@SeM*h,'bBR~v^^XiU[Y&\/L6(jEpen8eNtlhu!p)GYOW6Iny
Cc:     linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Bjorn Helgaas wrote:

> Haha, yeah, I know!  I noticed in your response to Sathya that you're
> running a 4.19.288 kernel, which is really, really old.  If it's
> practical, the first thing I would try is booting a current kernel,
> e.g., v6.4, on the chance that something has been fixed since v4.19.
> I didn't try to compare the mptsas driver to see if it has changed
> since then, so I don't know whether it's likely.
> 

Hi,
writing politely in reply to your politeness :). I upgraded to 5.15.131. I
need a stable system and do not want to jump that far to 6.x.

But it seems this issue is related to a defect in the firmware of the
controller. I will try to reflash a newer version during the week. I hope
it helps.

Current version is 01.26.00.00 (see [1]). In the readme[2], I read

Phase21 Pre-Alpha Release Version 00.33.01.00 - SAS1_FW_Ph_21
(SCGCQ00177063) Change Summary ( Defects=5)
SCGCQ00173656 (DFCT) - 6G SATA drive negotiates to 1.5G speed

I will also check the BIOS settings, when in front of the machine it could
be that link speed is enforcable

BR



[1]         Adapter Selected is a LSI SAS 1068E(B3):

Controller Number:              2
Controller:                     1068E(B3)
PCI Address:                    00:08:00:00
SAS Address:                    500605b-0-02d0-f3b0
NVDATA Version (Default):       0x2d00
NVDATA Version (Persistent):    0x2d00
Product ID:                     0x2704
Firmware Version:               01.26.00.00
NVDATA Vendor:                  Intel
NVDATA Product ID:              SASUC8I
BIOS Version:                   06.24.00.00
BIOS Alternate Version:         N/A
EFI BSD Version:                N/A
FCODE Version:                  N/A


[2] 
 SCG Engineering Release Notice
Product: Firmware
Version: 01.33.00.00
Release Date: 22-AUG-11
Release Type: GCA


-- 
FCD6 3719 0FFB F1BF 38EA 4727 5348 5F1F DCFE BCB0

