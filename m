Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1C8AAC43334
	for <linux-scsi@archiver.kernel.org>; Tue,  7 Jun 2022 16:45:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345160AbiFGQp6 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 7 Jun 2022 12:45:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56130 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243262AbiFGQp5 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 7 Jun 2022 12:45:57 -0400
Received: from alexa-out-sd-01.qualcomm.com (alexa-out-sd-01.qualcomm.com [199.106.114.38])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A6301F504E;
        Tue,  7 Jun 2022 09:45:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=quicinc.com; i=@quicinc.com; q=dns/txt; s=qcdkim;
  t=1654620356; x=1686156356;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=ctq6LVQOfjVVOtYv+AplzA6gCINpMNCuS0OiKyvIDb0=;
  b=rFi5n/FBQqwxD1WLRGhtmdiq5aL9xeboWPV2IHPisjxDlZAfnJBNF5VQ
   Of8Le1sKSBU5UraVnRSujwysD6kvL+P+V5kY74Pz/ZGqI1jRcTzVvAtsM
   1K4TqukzYsHWXXP7kvoCmLVNo0h1O/UC/fZn8cnxnDNR5pTa+Pap5jLcO
   c=;
Received: from unknown (HELO ironmsg-SD-alpha.qualcomm.com) ([10.53.140.30])
  by alexa-out-sd-01.qualcomm.com with ESMTP; 07 Jun 2022 09:45:56 -0700
X-QCInternal: smtphost
Received: from unknown (HELO nasanex01a.na.qualcomm.com) ([10.52.223.231])
  by ironmsg-SD-alpha.qualcomm.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Jun 2022 09:45:55 -0700
Received: from asutoshd-linux1.qualcomm.com (10.80.80.8) by
 nasanex01a.na.qualcomm.com (10.52.223.231) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.22; Tue, 7 Jun 2022 09:45:55 -0700
Date:   Tue, 7 Jun 2022 09:45:55 -0700
From:   Asutosh Das <quic_asutoshd@quicinc.com>
To:     Eric Biggers <ebiggers@kernel.org>
CC:     Jaegeuk Kim <jaegeuk@kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-scsi@vger.kernel.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Bart Van Assche <bvanassche@acm.org>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Asutosh Das <asutoshd@codeaurora.org>,
        Avri Altman <avri.altman@wdc.com>,
        Bean Huo <beanhuo@micron.com>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Can Guo <cang@codeaurora.org>
Subject: Re: [PATCH] scsi: ufs: add a quirk to disable FUA support
Message-ID: <20220607164555.GA30890@asutoshd-linux1.qualcomm.com>
References: <20220531201053.3300018-1-jaegeuk@kernel.org>
 <YpZ71MU7+DRedq5S@gmail.com>
 <YpaATWTiipNERoVF@google.com>
 <YpaHwds1zYRwua3+@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; format=flowed
Content-Disposition: inline
In-Reply-To: <YpaHwds1zYRwua3+@gmail.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
X-Originating-IP: [10.80.80.8]
X-ClientProxiedBy: nasanex01a.na.qualcomm.com (10.52.223.231) To
 nasanex01a.na.qualcomm.com (10.52.223.231)
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Tue, May 31 2022 at 14:25 -0700, Eric Biggers wrote:
>On Tue, May 31, 2022 at 01:53:33PM -0700, Jaegeuk Kim wrote:
>> > Also, this patch does nothing by itself.  Which UFS host driver(s) need this
>> > quirk bit?  Can you update them to use it?  Or do they all need this, in which
>> > case a quirk bit would be unnecessary?
>>
>> Likewise other quick bits, using this is up to SoC or UFS vendors. I
>> think that combination is up to OEMs who is building the product.
>
>Of the UFS host drivers in the upstream kernel, which ones actually need this?
>

Qualcomm UFSHC would need this.
>- Eric
