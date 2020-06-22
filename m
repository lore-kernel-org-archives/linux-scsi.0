Return-Path: <SRS0=lGnU=AD=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3BECAC433E1
	for <linux-scsi@archiver.kernel.org>; Mon, 22 Jun 2020 07:34:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0C68025473
	for <linux-scsi@archiver.kernel.org>; Mon, 22 Jun 2020 07:34:47 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="BP6jg2DQ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731402AbgFVHeq (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 22 Jun 2020 03:34:46 -0400
Received: from esa6.hgst.iphmx.com ([216.71.154.45]:21033 "EHLO
        esa6.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731323AbgFVHeq (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 22 Jun 2020 03:34:46 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1592811286; x=1624347286;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references;
  bh=cNsOPwJ9oc8d1MPoYKkuWDE/sHCL0CMDlmhsc2GLFqg=;
  b=BP6jg2DQr2oilZl6SsBjxno+H2SK1aYUCJBsGwk/hAeUOPE8XpMn30Q6
   cCDjRxu20bi2BZE5A1ASO82+jsfF91LAHKJC1BfxCjoQbVvFum6h/li/F
   rdR7PNlqmTvMgQYxZtwzw21x1BhIVgY+KR7Jg3JJEfTFNg7N2kr3fR+Oz
   9Zmf3Zvs6JQGADxWwAxDQaxJe8yWAj9ibLemBkUOr2bgsb3IWNrhwqr8A
   GL1BbW6dyNjJ6SDGJopMCn1BmVl0kZS5h9eagKrviMf02fiA6FgeHVGyK
   cu9JZeqdprJ2qm4YvEohecQjpP6G8YWU02IW6TQsW4JbBVg/9k/Tve14A
   g==;
IronPort-SDR: clcQr1jf+K7fTTDCLce91DixrMfyXo2XghlblXCeMJR8wdmxeixrXtLNfUdEwnqY9pMUM8FXb/
 XYmquIpoOvQ2p2QcIWmhKLk1MSqIAX7No3So7FpL2OyugiZpMMi5mnXIr48HptHanc2VPpvp+t
 VPKqaRXM1plnVf9UO+6NSAGuKi/zh6S6CTAaPU0/jWFB+Z/4kazCZdxotOSUVkf0N2UGG81lcq
 Oc9ZYoEn/mdx3bDs+X8v1CFiUZ7mSVFfBvAQv+II3/iHthVeWk/SXyqb/rD4dlsMePPrc1lgxE
 MzM=
X-IronPort-AV: E=Sophos;i="5.75,266,1589212800"; 
   d="scan'208";a="141963341"
Received: from h199-255-45-14.hgst.com (HELO uls-op-cesaep01.wdc.com) ([199.255.45.14])
  by ob1.hgst.iphmx.com with ESMTP; 22 Jun 2020 15:34:46 +0800
IronPort-SDR: zWIggy4ZTrUbT75hvFWiY0MBNuh2NKUpdLUgoY6azBx1DYB3mND++E3QFtGnQWEwe8uLhTT6Nd
 NbSoF4UVfL1jlP8SpPx/N2KKtvCKZCXeQ=
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Jun 2020 00:23:52 -0700
IronPort-SDR: vYZGVGAuX9gjpgiJlCjgM/8uTNItkRk8jthh6tKFkcQl5JrGqc7LPkSzoSFzd8BGKYqdQQRLUs
 zuI6MTSYNB7g==
WDCIronportException: Internal
Received: from ile422988.sdcorp.global.sandisk.com ([10.0.231.246])
  by uls-op-cesaip02.wdc.com with ESMTP; 22 Jun 2020 00:34:42 -0700
From:   Avri Altman <avri.altman@wdc.com>
To:     Eric Biggers <ebiggers@kernel.org>,
        Satya Tangirala <satyat@google.com>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        alim.akhtar@samsung.com, asutoshd@codeaurora.org,
        stanley.chu@mediatek.com, Zang Leigang <zangleigang@hisilicon.com>,
        linux-scsi@vger.kernel.org,
        Barani Muthukumaran <bmuthuku@qti.qualcomm.com>,
        Kuohong Wang <kuohong.wang@mediatek.com>,
        Kim Boojin <boojin.kim@samsung.com>,
        Avri Altman <avri.altman@wdc.com>
Subject: Re: [PATCH v2 3/3] scsi: ufs: Add inline encryption support to UFS
Date:   Mon, 22 Jun 2020 10:34:26 +0300
Message-Id: <1592811266-7224-1-git-send-email-avri.altman@wdc.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <20200618024736.97207-1-satyat@google.com>
References: <20200618024736.97207-1-satyat@google.com>
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

>ufshcd_prepare_req_desc_hdr
maybe pack all your additions to ufshcd_prepare_req_desc_hdr into a
ufshcd_prepare_req_desc_hdr_crypto helper, so the ifdefs can be avoided?

>ufshcd_compose_dev_cmd
same goes to ufshcd_compose_dev_cmd and ufshcd_issue_devman_upiu_cmd -
maybe just call ufshcd_prepare_lrbp_crypto (with some minor changes)
instead of those ifdefs?
