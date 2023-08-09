Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A4DABEB64DD
	for <linux-scsi@archiver.kernel.org>; Wed,  9 Aug 2023 07:14:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231633AbjHIHOB (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 9 Aug 2023 03:14:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32884 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231638AbjHIHNy (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 9 Aug 2023 03:13:54 -0400
Received: from wout5-smtp.messagingengine.com (wout5-smtp.messagingengine.com [64.147.123.21])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DB02A2136;
        Wed,  9 Aug 2023 00:13:43 -0700 (PDT)
Received: from compute6.internal (compute6.nyi.internal [10.202.2.47])
        by mailout.west.internal (Postfix) with ESMTP id 47CE43200065;
        Wed,  9 Aug 2023 03:13:43 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute6.internal (MEProxy); Wed, 09 Aug 2023 03:13:43 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=wizy.org; h=cc
        :content-transfer-encoding:content-type:content-type:date:date
        :from:from:in-reply-to:message-id:mime-version:reply-to:sender
        :subject:subject:to:to; s=fm3; t=1691565222; x=1691651622; bh=1n
        4s7ge6Jy90+tWaqd2JFCyJxn/WoD7tBFdrYlyDtOM=; b=PgkqsvSz81e3M09I0f
        cl5U8/CIaB+5af7m2wY/ZXz1NQlCII9xWdNwmoaLdCD4oVuL4reE5+MTcLZ1+T8I
        n/RYhPKly8YapvrAYEkFX+k4sr6DYM/WzP3YKjivm0TbvvfIX5ng2O9/DVgRIpDm
        +wcoA7DMQWFLwNbr8RgI5MklPIIyzs4EhjJoNuiLHJk5636ht8yMPmvBeu3+Pw1D
        VREoECci316guZgKCPOGbo0/LlO/S2PqMeVmX8a6A7+fAH08oQbBeQWC4yq5ON1c
        9QzMuzkUtCUTQ9cU0CP8QOHgtEUGRVX2rH+cVF4xxRJbs+W/A/8zqpB+rKk8sweH
        +nIg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :content-type:date:date:feedback-id:feedback-id:from:from
        :in-reply-to:message-id:mime-version:reply-to:sender:subject
        :subject:to:to:x-me-proxy:x-me-proxy:x-me-sender:x-me-sender
        :x-sasl-enc; s=fm3; t=1691565222; x=1691651622; bh=1n4s7ge6Jy90+
        tWaqd2JFCyJxn/WoD7tBFdrYlyDtOM=; b=knji+iY9Td7qEB30G/sbWOK4IIAy7
        BuJlrB6aiHJViOeDuNngVZBbNvCNwbNLRB8eA5zL9oDkuKFj6Gu0iESdrQ2IfyKo
        sE6bs2muGRD7BiL65WmXPDwlxnYr2pka/bZzXYQIX0Mw+PAolakztGEGIRkvZFiV
        pYg4mwpfIwe8vx9F48gEbDEzxTxEoRlsyoBkBqPXCXLII83WsGh2HOOuTiemvTlO
        EbgPW3c4wrhMGNibcM1eVfDeJLXDV/n8ndglzkAXRtbgo+WznFNju8qt2aacipY/
        hXxzcbeXVylhmpGxZitfoWHSvahL/b0Y7/3MgfrMxeAZG3OzW/nFj4hSg==
X-ME-Sender: <xms:pjzTZKuqh5VuzFpJeVKsV7dMymQluuwsWv8Rgpzr9IYp8EJ1zQSwJQ>
    <xme:pjzTZPdos3Vh7zvcgQsFHK9ElxrMvW7zuUhVDFwqi4WuU6xeg0dt6JDxOETQtGjA_
    DoRGdCFQrqY_X-HKPQ>
X-ME-Received: <xmr:pjzTZFzzxTqxajY0orUZL_IF4v_WZjy7wE_yQY4JkEudlGZ6ZDwnvuP3hQnuc9yWMXUxHg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedviedrleefgdduudehucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpegggfgtfffkvffuhffosehtqhertd
    ertdejnecuhfhrohhmpedftfhitggrrhguohcuvehorhhrvghirgdfuceolhhinhhugidq
    uhhssgdqshgtshhiseifihiihidrohhrgheqnecuggftrfgrthhtvghrnhepffejjeduie
    fgjefffeelteegffffhfffhfehleffvdekveekheeiiedugfdtffeknecuvehluhhsthgv
    rhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomheplhhinhhugidquhhssgdqsh
    gtshhiseifihiihidrohhrgh
X-ME-Proxy: <xmx:pjzTZFOyoEQUGvX2Uqz80G-hskvsEefAgH9k7qfWttRe3XTM96a9dA>
    <xmx:pjzTZK9DajP-fwHoKG3iTmDMJoJNhserBskP13CeDzuQsSG8tr2l7A>
    <xmx:pjzTZNWnSAVoo7jh65k9GV3NbJ3eMpJGY1ZzkazRh5cecPg-igQJOg>
    <xmx:pjzTZPGfQ_4rQ7nlEfuorey7ZhSgLGrk-e_F_cEiZ0QTR1SunVFedg>
Feedback-ID: i46b94775:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Wed,
 9 Aug 2023 03:13:41 -0400 (EDT)
Received: by mx3.wizy.org (OpenSMTPD) with ESMTP id f1c6593b;
        Wed, 9 Aug 2023 07:13:39 +0000 (UTC)
Received: by wizylap.wizy.org (OpenSMTPD) with ESMTP id bb0d2808;
        Wed, 9 Aug 2023 07:13:38 +0000 (UTC)
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date:   Wed, 09 Aug 2023 07:13:38 +0000
Message-Id: <CUNTTPCNZJDR.3T7MC38PK0INK@wizylap>
To:     <linux-usb@vger.kernel.org>, <linux-scsi@vger.kernel.org>
Subject: TRIM support not always initialized correctly
From:   "Ricardo Correia" <linux-usb-scsi@wizy.org>
X-Mailer: aerc 0.14.0
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi,

I'm running kernel 6.1.43 and I'm running into an issue with a JMS578/JMS57=
9 USB-SATA adapter connected to an SSD.

When I first connect the adapter to the USB port of my laptop, TRIM support=
 seems to be disabled:

$ lsblk -D | head -n 2
NAME        DISC-ALN DISC-GRAN DISC-MAX DISC-ZERO
sda                0        4K       0B         0

(Notice the DISC-MAX value).

However, if immediately after that, I remove and insert the uas module, the=
n TRIM support seems to work fine:

$ modprobe -r uas
$ modprobe uas

$ lsblk -D | head -n 2
NAME        DISC-ALN DISC-GRAN DISC-MAX DISC-ZERO
sda                0        4K       4G         0

This seems to happen very consistently (both the disabled TRIM when first c=
onnecting the device and the enabled TRIM
when reloading the module).

As far as I know I don't have any udev rules for this device, but I don't k=
now how to verify this for sure.

Any ideas of what could be wrong?

Thank you.
