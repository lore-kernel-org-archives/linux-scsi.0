Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1464FC433FE
	for <linux-scsi@archiver.kernel.org>; Thu, 17 Nov 2022 10:51:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234811AbiKQKvc (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 17 Nov 2022 05:51:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40950 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233502AbiKQKvb (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 17 Nov 2022 05:51:31 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D68561835B
        for <linux-scsi@vger.kernel.org>; Thu, 17 Nov 2022 02:50:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1668682227;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=GBLjqaxD9YXzB2a0G4EC2tB+BR3145svbgGOvljSx80=;
        b=NVocBVwJMBCdj6ZEl6AzbeQUJIChGglCHAl2lod3/8JfSuuDeGwU7XSVaYND1wf+CcWHrJ
        XmVYOjYVRoSTru3bB7lUfJpMoD4iiTRQm4XNnWqKBOdD5xnkizpz4ngkTR4TdhLGmIpNhS
        TZK8WsxpHCw0kTdob9VgS/SZMlhwnK8=
Received: from mail-qv1-f72.google.com (mail-qv1-f72.google.com
 [209.85.219.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-453-DJgM7kSKP4C_506U1jjgQg-1; Thu, 17 Nov 2022 05:50:26 -0500
X-MC-Unique: DJgM7kSKP4C_506U1jjgQg-1
Received: by mail-qv1-f72.google.com with SMTP id e13-20020ad450cd000000b004bb49d98da4so1259338qvq.9
        for <linux-scsi@vger.kernel.org>; Thu, 17 Nov 2022 02:50:26 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=GBLjqaxD9YXzB2a0G4EC2tB+BR3145svbgGOvljSx80=;
        b=Dthma7EWPbc6CehtyBPPcrO/+9duK+rkYEDD+VGPbAFb5C7Q+AiLKn4h9rVm7CgsaV
         CXjqEoN0fMG2tICMsVd1luUB4Mx/yssfFKcjW8iiCz5S2rVFHGu46Z1L6C/6NIPIVcZr
         R6q3dIORduEHQ30VGY9LryhyGsWQ2jWrZbu5vhUPTJwQPpQAzdgeoIvAaXV6Wbu7QuhC
         pJ5JNr+ZI7g8NVK3OItizZeEgWWPC+pTJiKjVB1tETVwyt/EumxLmgvHjI1OUuLF2OGT
         ygU+kU9V/1eSXJr2bvNqXJyyNIjeZO0i7aBC7kdplv0fKFJD9Tc30yzENxXJJNf4AFzu
         NIuQ==
X-Gm-Message-State: ANoB5pkNDQMAucchlvKC8yXFmWz4pyT3iBhcXOa5igs6H/VgojUDe8Lx
        lhOjA7dO40MDx+R6WjBp+/XEmFCspeusaQM/DiLeoUlI1dEqVD0vZNu4GG2MqaK+DkGF7xW2e9m
        H3yfo98GiY8/42oEe0b8C3A==
X-Received: by 2002:ac8:4e47:0:b0:3a5:c306:324 with SMTP id e7-20020ac84e47000000b003a5c3060324mr1650353qtw.116.1668682226063;
        Thu, 17 Nov 2022 02:50:26 -0800 (PST)
X-Google-Smtp-Source: AA0mqf5Hp8ueJ2odeFAiwGWASh3iAkry+xnk/8bkoOGXMK9ipdlHU+fDlbp30euEWUKaHFyqpmn8jQ==
X-Received: by 2002:ac8:4e47:0:b0:3a5:c306:324 with SMTP id e7-20020ac84e47000000b003a5c3060324mr1650342qtw.116.1668682225822;
        Thu, 17 Nov 2022 02:50:25 -0800 (PST)
Received: from x1.redhat.com (c-73-214-169-22.hsd1.pa.comcast.net. [73.214.169.22])
        by smtp.gmail.com with ESMTPSA id i15-20020a05620a248f00b006fa9d101775sm236022qkn.33.2022.11.17.02.50.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 17 Nov 2022 02:50:25 -0800 (PST)
From:   Brian Masney <bmasney@redhat.com>
To:     andersson@kernel.org
Cc:     agross@kernel.org, konrad.dybcio@linaro.org, robh+dt@kernel.org,
        krzysztof.kozlowski+dt@linaro.org, jejb@linux.ibm.com,
        martin.petersen@oracle.com, linux-arm-msm@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-scsi@vger.kernel.org
Subject: [PATCH 0/2] qcom: add basic interconnect support to UFS
Date:   Thu, 17 Nov 2022 05:49:55 -0500
Message-Id: <20221117104957.254648-1-bmasney@redhat.com>
X-Mailer: git-send-email 2.38.1
MIME-Version: 1.0
Content-type: text/plain
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

This patch set adds very basic support for the interconnect framework
to the Qualcomm portion of the UFS framework since the firmware on
these platforms expects the interconnect votes to be present. The
maximum throughput is requested to match what's already done in a few
other drivers.

Here's the relevant entries from the interconnect_summary file in
debugfs that shows the two ICC paths are setup for the first UFS
host controller on the SA8540p automotive board (sc8280xp).

 node                                  tag          avg         peak
--------------------------------------------------------------------
xm_ufs_mem                                            0   4294967295
  1d84000.ufs                            0            0   4294967295
qns_a1noc_snoc                                        0   4294967295
  1d84000.ufs                            0            0   4294967295
qnm_gemnoc_cnoc                                     115   4294967295
  1d84000.ufs                            0            0   4294967295
  a6f8800.usb                            0            0        40000
  884000.serial                          0          115          115
qhs_ufs_mem_cfg                                       0   4294967295
  1d84000.ufs                            0            0   4294967295
chm_apps                                            115   4294967295
  1d84000.ufs                            0            0   4294967295
  a6f8800.usb                            0            0        40000
  884000.serial                          0          115          115
qnm_snoc_sf                                     1000000   4294967295
  1d84000.ufs                            0            0   4294967295
  a6f8800.usb                            0      1000000      2500000
qns_gem_noc_cnoc                                    115   4294967295
  1d84000.ufs                            0            0   4294967295
  a6f8800.usb                            0            0        40000
  884000.serial                          0          115          115
qns_llcc                                        1000000   4294967295
  1d84000.ufs                            0            0   4294967295
  a6f8800.usb                            0      1000000      2500000
llcc_mc                                         1000000   4294967295
  1d84000.ufs                            0            0   4294967295
  a6f8800.usb                            0      1000000      2500000
ebi                                             1000000   4294967295
  1d84000.ufs                            0            0   4294967295
  a6f8800.usb                            0      1000000      2500000
qnm_aggre1_noc                                        0   4294967295
  1d84000.ufs                            0            0   4294967295
qns_gemnoc_sf                                   1000000   4294967295
  1d84000.ufs                            0            0   4294967295
  a6f8800.usb                            0      1000000      2500000


Brian Masney (2):
  scsi: ufs: ufs-qcom: add basic interconnect support
  arm64: dts: qcom: sc8280xp: add interconnect properties to ufs nodes

 arch/arm64/boot/dts/qcom/sc8280xp.dtsi |  8 ++++++++
 drivers/ufs/host/ufs-qcom.c            | 25 +++++++++++++++++++++++++
 2 files changed, 33 insertions(+)

-- 
2.38.1

