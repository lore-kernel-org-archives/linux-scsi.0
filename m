Return-Path: <SRS0=ICpX=ZG=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D713DC432C3
	for <linux-scsi@archiver.kernel.org>; Thu, 14 Nov 2019 01:03:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E04D0206E6
	for <linux-scsi@archiver.kernel.org>; Thu, 14 Nov 2019 01:03:17 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="UwZVJT0P";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="AL/Phc4b"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726434AbfKNBDO (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 13 Nov 2019 20:03:14 -0500
Received: from smtp.codeaurora.org ([198.145.29.96]:59954 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726363AbfKNBDO (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 13 Nov 2019 20:03:14 -0500
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id A76FC60DAE; Thu, 14 Nov 2019 01:03:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1573693392;
        bh=mtDzRp609jVa8P6rGZmHkR8KyMo+8LG+VpVhw6EWN3c=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=UwZVJT0PbYWh5sPRHorsWeFIUEErNjMBLMQKMZTS1kcF9JP1t+qG65ByLDTyV4A/a
         C33jMTKXSVUViLFHQOsywMSG2WJUEOmQO/W1g9MhZV7zPggZtJdTOVWvE06xSZGPjM
         Q944WJzOaTU0rIxZqakPFoiaZWkbzbrfJa51uMgc=
Received: from mail.codeaurora.org (localhost.localdomain [127.0.0.1])
        by smtp.codeaurora.org (Postfix) with ESMTP id C31856092C;
        Thu, 14 Nov 2019 01:03:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1573693390;
        bh=mtDzRp609jVa8P6rGZmHkR8KyMo+8LG+VpVhw6EWN3c=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=AL/Phc4bSaB4DjALScQ96lTPexLPY8Ovl2HcEXO6p+5X+w7pOLOBi2m048aFeZIGE
         OllJw4kGKpdnBTML0OoAlmi+SdNgyhnRQCFLr1WWJlyLxj37rwp5/DxqizB7SjaPTA
         3vGrZktpBiTyRf03/4Vizc1eVh2K8cSY+AX2kb7w=
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Thu, 14 Nov 2019 09:03:10 +0800
From:   cang@codeaurora.org
To:     "Bean Huo (beanhuo)" <beanhuo@micron.com>
Cc:     asutoshd@codeaurora.org, nguyenb@codeaurora.org,
        rnayak@codeaurora.org, linux-scsi@vger.kernel.org,
        kernel-team@android.com, saravanak@google.com, salyzyn@google.com,
        Alim Akhtar <alim.akhtar@samsung.com>,
        Avri Altman <avri.altman@wdc.com>,
        Pedro Sousa <pedrom.sousa@synopsys.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Subhash Jadavani <subhashj@codeaurora.org>,
        Tomas Winkler <tomas.winkler@intel.com>,
        open list <linux-kernel@vger.kernel.org>,
        Can Guo <cang@codeaurora.org>
Subject: Re: [EXT] [PATCH v1 5/5] scsi: ufs: Complete pending requests in host
 reset and restore path
In-Reply-To: <BN7PR08MB56849EEE83414549F4787BCEDB760@BN7PR08MB5684.namprd08.prod.outlook.com>
References: <1573200932-384-1-git-send-email-cang@codeaurora.org>
 <1573200932-384-6-git-send-email-cang@codeaurora.org>
 <BN7PR08MB56849EEE83414549F4787BCEDB760@BN7PR08MB5684.namprd08.prod.outlook.com>
Message-ID: <0dc202a1decb6bbc103253b8c3c8c8ce@codeaurora.org>
X-Sender: cang@codeaurora.org
User-Agent: Roundcube Webmail/1.2.5
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2019-11-14 06:04, Bean Huo (beanhuo) wrote:
>> 
>> In UFS host reset and restore path, before probe, we stop and start 
>> the host
>> controller once. After host controller is stopped, the pending 
>> requests, if any,
>> are cleared from the doorbell, but no completion IRQ would be raised 
>> due to the
>> hba is stopped.
>> These pending requests shall be completed along with the first NOP_OUT
>> command(as it is the first command which can raise a transfer 
>> completion
>> IRQ) sent during probe.
> 
> Hi, Can
> I am not sure for this point, because there is HW/SW device reset
> before or after host reset/restore.
> Device HW/SW reset also will clear the pended tasks in device side.
> That will be better.
> I think Qcom platform already enabled HW reset.
> 
> //Bean
> 

Hi Bean,

By pending tasks here, it means the requests sent down from scsi/block 
layer,
but have not yet been handled by ufs driver(cmd->scsi_done() have not 
been called yet for these requests).
For these requests, although removed by host and UFS device in their HW 
queues(doorbell),
UFS driver still needs to complete them from SW side(call 
cmd->scsi_done() for each one of them) to
let upper layer know that they are finished(although not successfully) 
to avoid hitting
timeout of these pending tasks. I hope I make my explanation clearly.

Best Regards,
Can Guo.

>> Since the OCSs of these pending requests are not SUCCESS(because they 
>> are not
>> yet literally finished), their UPIUs shall be dumped. When there are 
>> multiple
>> pending requests, the UPIU dump can be overwhelming and may lead to 
>> stability
>> issues because it is in atomic context.
>> Therefore, before probe, complete these pending requests right after 
>> host
>> controller is stopped.
