Return-Path: <SRS0=IzRR=ZR=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.7 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 69664C432C0
	for <linux-scsi@archiver.kernel.org>; Mon, 25 Nov 2019 07:43:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 41B3A20637
	for <linux-scsi@archiver.kernel.org>; Mon, 25 Nov 2019 07:43:49 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="jZjGIWCD";
	dkim=pass (1024-bit key) header.d=amazonses.com header.i=@amazonses.com header.b="Ze8vI+uQ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725823AbfKYHnp (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 25 Nov 2019 02:43:45 -0500
Received: from a27-21.smtp-out.us-west-2.amazonses.com ([54.240.27.21]:47308
        "EHLO a27-21.smtp-out.us-west-2.amazonses.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725535AbfKYHnp (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 25 Nov 2019 02:43:45 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/simple;
        s=zsmsymrwgfyinv5wlfyidntwsjeeldzt; d=codeaurora.org; t=1574667824;
        h=MIME-Version:Content-Type:Content-Transfer-Encoding:Date:From:To:Cc:Subject:In-Reply-To:References:Message-ID;
        bh=38XBh07YX5GeTtsELU1klOdb/Ja+dN91/lAfvPbITss=;
        b=jZjGIWCD3iQqHlEwFp64qAXEdAaUp6iFixe+xafbgop8f+zPucTx1m5TAZP6kgKH
        7uAmO+2y+pdn79UGhAJtAuZY4atAHYagd7j63O7+rxJ0Fc4AiTJdTjV5cffgEdNkMaN
        0Ghh9YcobxHtmGxyq/MPC6YyW+YYUvDqk8hLRbA8=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/simple;
        s=gdwg2y3kokkkj5a55z2ilkup5wp5hhxx; d=amazonses.com; t=1574667824;
        h=MIME-Version:Content-Type:Content-Transfer-Encoding:Date:From:To:Cc:Subject:In-Reply-To:References:Message-ID:Feedback-ID;
        bh=38XBh07YX5GeTtsELU1klOdb/Ja+dN91/lAfvPbITss=;
        b=Ze8vI+uQmXGkIxWi7uQWxQ9ghIZe/CkgF5UqQoeTr8hFAvlG+fcyG1nOzq5zZAo3
        NeBpB4A28izJIENqBvBwasvbLCZilVS7iRONEMw80G8HV0Lylq4b1AtO3knBrFjPYO7
        ioS6NXCxEpTptFa1nwnoCTW58yNPh7oHSSg5bUBM=
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Mon, 25 Nov 2019 07:43:44 +0000
From:   cang@codeaurora.org
To:     Avri Altman <Avri.Altman@wdc.com>
Cc:     asutoshd@codeaurora.org, nguyenb@codeaurora.org,
        rnayak@codeaurora.org, linux-scsi@vger.kernel.org,
        kernel-team@android.com, saravanak@google.com, salyzyn@google.com,
        Alim Akhtar <alim.akhtar@samsung.com>,
        Pedro Sousa <pedrom.sousa@synopsys.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Bean Huo <beanhuo@micron.com>,
        Tomas Winkler <tomas.winkler@intel.com>,
        open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v4 5/5] scsi: ufs: Do not free irq in suspend
In-Reply-To: <MN2PR04MB69913C6C9ED425F99302D870FC4F0@MN2PR04MB6991.namprd04.prod.outlook.com>
References: <1573624824-671-1-git-send-email-cang@codeaurora.org>
 <1573624824-671-6-git-send-email-cang@codeaurora.org>
 <MN2PR04MB69913C6C9ED425F99302D870FC4F0@MN2PR04MB6991.namprd04.prod.outlook.com>
Message-ID: <0101016ea1842c0d-bbb3ea3d-c240-472f-87a6-d6b55edfb4a5-000000@us-west-2.amazonses.com>
X-Sender: cang@codeaurora.org
User-Agent: Roundcube Webmail/1.3.9
X-SES-Outgoing: 2019.11.25-54.240.27.21
Feedback-ID: 1.us-west-2.CZuq2qbDmUIuT3qdvXlRHZZCpfZqZ4GtG9v3VKgRyF0=:AmazonSES
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2019-11-20 23:36, Avri Altman wrote:
>> 
>> If PM QoS is enabled and we set request type to PM_QOS_REQ_AFFINE_IRQ
>> then freeing up the irq makes the free_irq() print out warning with 
>> call stack.
>> We don't really need to free up irq during suspend, disabling it 
>> during suspend
>> and reenabling it during resume should be good enough.
>> 
>> Signed-off-by: Can Guo <cang@codeaurora.org>
> Your approach seems reasonable,
> However I failed to locate in the kernel PM_QOS_REQ_AFFINE_IRQ,
> Just in codeaurora.
> 
> Is the WARN_ON in free_irq still applies?
> 
> Thanks,
> Avri

Hi Avri,

Thanks for pointing. It seems PM_QOS_REQ_AFFINE_IRQ is not present
on upstream yet. But this change is still applicable.
How about changing the commit message to below?

"Since ufshcd irq resource is allocated with the device resource
management aware IRQ request implementation, we don't really need
to free up irq during suspend, disabling it during suspend and
reenabling it during resume should be good enough."

Thanks,
Can Guo
