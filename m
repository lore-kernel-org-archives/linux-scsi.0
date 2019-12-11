Return-Path: <SRS0=S2y6=2B=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.7 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 85628C43603
	for <linux-scsi@archiver.kernel.org>; Wed, 11 Dec 2019 11:44:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5B55121556
	for <linux-scsi@archiver.kernel.org>; Wed, 11 Dec 2019 11:44:14 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="URraAc9u";
	dkim=pass (1024-bit key) header.d=amazonses.com header.i=@amazonses.com header.b="TD3NrOgx"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728265AbfLKLoK (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 11 Dec 2019 06:44:10 -0500
Received: from a27-56.smtp-out.us-west-2.amazonses.com ([54.240.27.56]:39350
        "EHLO a27-56.smtp-out.us-west-2.amazonses.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727365AbfLKLoK (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 11 Dec 2019 06:44:10 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/simple;
        s=zsmsymrwgfyinv5wlfyidntwsjeeldzt; d=codeaurora.org; t=1576064648;
        h=MIME-Version:Content-Type:Content-Transfer-Encoding:Date:From:To:Cc:Subject:In-Reply-To:References:Message-ID;
        bh=SsfCfJa0hJtH6mmOozBYFGjGWd8Fea0xhWkIg2GJsis=;
        b=URraAc9uX8ZPiqOn3n52TP2VHjePzZH6jysNOeabwzYeMsCIPDJIQ5+5g8+/o2CS
        slG674NohNzl7nuGXzelwviE/7weBMfDbKc1AqF+CkBWvWgmgxSCmdPBVoREIus+1bi
        BbprrExf09+a0j5R4k3TcoUbXK2Z2qzuYWVBzJ+w=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/simple;
        s=gdwg2y3kokkkj5a55z2ilkup5wp5hhxx; d=amazonses.com; t=1576064648;
        h=MIME-Version:Content-Type:Content-Transfer-Encoding:Date:From:To:Cc:Subject:In-Reply-To:References:Message-ID:Feedback-ID;
        bh=SsfCfJa0hJtH6mmOozBYFGjGWd8Fea0xhWkIg2GJsis=;
        b=TD3NrOgx7l6OCs/F7DRd/mNVcJon3xsI6P2OpEz073fSjJK71EBJMgbAAFYWRiNU
        /Qu+U2EdCpZskakkSa6dyvwM8qTqHvR1lKE6I7zJv4X320RDeBYMxrK9O0YFu61CwwM
        /vssd4WXORRj/IaK4RMVrZDB63iMey9uAxcXDBJs=
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Wed, 11 Dec 2019 11:44:08 +0000
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
        Venkat Gopalakrishnan <venkatg@codeaurora.org>,
        Tomas Winkler <tomas.winkler@intel.com>,
        open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2 1/3] scsi: ufs: Put SCSI host after remove it
In-Reply-To: <MN2PR04MB6991754758E2840B6D529112FC5A0@MN2PR04MB6991.namprd04.prod.outlook.com>
References: <1576054123-16417-1-git-send-email-cang@codeaurora.org>
 <0101016ef4259a7c-76bdf010-88b1-4309-ba24-8c874734184e-000000@us-west-2.amazonses.com>
 <MN2PR04MB699184D76E7F9BABA923043AFC5A0@MN2PR04MB6991.namprd04.prod.outlook.com>
 <0101016ef4a3e5f5-915372c8-5e1e-4db5-b3da-f97f7ca963e4-000000@us-west-2.amazonses.com>
 <MN2PR04MB6991754758E2840B6D529112FC5A0@MN2PR04MB6991.namprd04.prod.outlook.com>
Message-ID: <0101016ef4c605e5-295b1cc0-19d7-41e8-be2e-5d026f72dcec-000000@us-west-2.amazonses.com>
X-Sender: cang@codeaurora.org
User-Agent: Roundcube Webmail/1.3.9
X-SES-Outgoing: 2019.12.11-54.240.27.56
Feedback-ID: 1.us-west-2.CZuq2qbDmUIuT3qdvXlRHZZCpfZqZ4GtG9v3VKgRyF0=:AmazonSES
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2019-12-11 19:22, Avri Altman wrote:
>> 
>> 
>> On 2019-12-11 18:37, Avri Altman wrote:
>> >>
>> >> In ufshcd_remove(), after SCSI host is removed, put it once so that
>> >> its resources can be released.
>> >>
>> >> Signed-off-by: Can Guo <cang@codeaurora.org>
>> >
>> > This is not really part of this patchset, is it?
>> >
>> 
>> Hi Avri,
>> 
>> I put this change in the same patchset due to #1. The main patch has
>> dependency on it #2. Consider a scenario where platform driver is also 
>> compiled
>> as a module, say ufs_qcom.ko.
>>      In this case, we have two modules, ufs-qcom.ko and ufs-bsg.ko. If 
>> do insmod
>> ufs-qcom.ko
>>      then rmmod ufs-qcom.ko and do insmod ufs-qcom.ko again, without 
>> this
>> change, because scsi
>>      host was not release, the new scsi host will have a different 
>> host number,
>> meaning
>>      hba->host->host_no will be 1, but not 0. Now if do insmod 
>> ufs-bsg.ko now,
>> the ufs-bsg dev
>>      created in /dev/bsg/ will be ufs-bsg1, but not ufs-bsg0. If keep 
>> trying these
>> operations,
>>      the ufs-bsg device's name will be messed up. This change make 
>> sure after ufs-
>> qcom.ko is removed
>>      and installed back, its hba->host->host_no stays 0, so that 
>> ufs-bsg device
>> name stays same.
> Looks like we needed to manage the ufs-bsg nodes using an IDA, instead
> of host_no?
> 
> 

Marking one ufs-bsg dev with host_no still has its advantage. If we have 
more
than one hba host, we can find the right ufs-bsgX dev by reading the 
sg/sd/bsg
device's host->host_unique_id (through SCSI_IOCTL_GET_IDLUN for 
example).
But If ufs-bsg has its own ID, we will lost this "mapping".

Thanks,

Can Guo.

>> 
>> Thanks,
>> 
>> Can Guo.
>> 
>> >> ---
>> >>  drivers/scsi/ufs/ufshcd.c | 1 +
>> >>  1 file changed, 1 insertion(+)
>> >>
>> >> diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
>> >> index b5966fa..a86b0fd 100644
>> >> --- a/drivers/scsi/ufs/ufshcd.c
>> >> +++ b/drivers/scsi/ufs/ufshcd.c
>> >> @@ -8251,6 +8251,7 @@ void ufshcd_remove(struct ufs_hba *hba)
>> >>         ufs_bsg_remove(hba);
>> >>         ufs_sysfs_remove_nodes(hba->dev);
>> >>         scsi_remove_host(hba->host);
>> >> +       scsi_host_put(hba->host);
>> >>         /* disable interrupts */
>> >>         ufshcd_disable_intr(hba, hba->intr_mask);
>> >>         ufshcd_hba_stop(hba, true);
>> >> --
>> >> The Qualcomm Innovation Center, Inc. is a member of the Code Aurora
>> >> Forum, a Linux Foundation Collaborative Project
