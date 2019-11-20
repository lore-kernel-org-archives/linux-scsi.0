Return-Path: <SRS0=SaCo=ZM=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 16AB2C432C0
	for <linux-scsi@archiver.kernel.org>; Wed, 20 Nov 2019 04:14:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D8F812245C
	for <linux-scsi@archiver.kernel.org>; Wed, 20 Nov 2019 04:14:47 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="Qo8vScqx";
	dkim=pass (1024-bit key) header.d=amazonses.com header.i=@amazonses.com header.b="InwQXLwh"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727545AbfKTEOo (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 19 Nov 2019 23:14:44 -0500
Received: from a27-56.smtp-out.us-west-2.amazonses.com ([54.240.27.56]:39036
        "EHLO a27-56.smtp-out.us-west-2.amazonses.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727343AbfKTEOo (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 19 Nov 2019 23:14:44 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/simple;
        s=zsmsymrwgfyinv5wlfyidntwsjeeldzt; d=codeaurora.org; t=1574223283;
        h=MIME-Version:Content-Type:Content-Transfer-Encoding:Date:From:To:Cc:Subject:In-Reply-To:References:Message-ID;
        bh=sQkNXuDVsJ0tsz0h+83RhRvsNtFDcFeY7de5XccyV/E=;
        b=Qo8vScqxfHA9Q4ooy0gAv3ctisVHtZ/bvCgBemcoAta+TlCQyGQtN9gV6gxWw01E
        BYbgqiimoIEi+HNkEx6WUGEdHD1YLlMUhQjomvxtBuUsnpJ4o1i1iV3mTbi0mFpS1qc
        qqBqzgivaUP0pMGs/GhNO2wkIh4hMu3RjrOzi0js=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/simple;
        s=gdwg2y3kokkkj5a55z2ilkup5wp5hhxx; d=amazonses.com; t=1574223283;
        h=MIME-Version:Content-Type:Content-Transfer-Encoding:Date:From:To:Cc:Subject:In-Reply-To:References:Message-ID:Feedback-ID;
        bh=sQkNXuDVsJ0tsz0h+83RhRvsNtFDcFeY7de5XccyV/E=;
        b=InwQXLwhSUoSQHOniuON/CDxljrEZ51RI60W5t3yDU1H0uZW+HNcrnRWJXc6V4gz
        WKA/YRHpZnjxhTE43up5r8H4UA/prqfqxM8BgWUrnxneNSeUJPTIyomc/pDndpcnbJk
        y7Tx1EzXS7PIy/IhfvJ5Tu7HPJkuAXRxBRQGYB1k=
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Wed, 20 Nov 2019 04:14:43 +0000
From:   cang@codeaurora.org
To:     Avri Altman <Avri.Altman@wdc.com>
Cc:     Can Guo <cang@qti.qualcomm.com>, asutoshd@codeaurora.org,
        nguyenb@codeaurora.org, rnayak@codeaurora.org,
        linux-scsi@vger.kernel.org, kernel-team@android.com,
        saravanak@google.com, salyzyn@google.com,
        Alim Akhtar <alim.akhtar@samsung.com>,
        Pedro Sousa <pedrom.sousa@synopsys.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Tomas Winkler <tomas.winkler@intel.com>,
        open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2 2/4] scsi: ufs: Update VCCQ2 and VCCQ min/max voltage
 hard codes
In-Reply-To: <MN2PR04MB699170FFA7B2DD59014374D5FC4C0@MN2PR04MB6991.namprd04.prod.outlook.com>
References: <1574049061-11417-1-git-send-email-cang@qti.qualcomm.com>
 <1574049061-11417-3-git-send-email-cang@qti.qualcomm.com>
 <MN2PR04MB6991121D72EA8E6DF7F6258AFC4D0@MN2PR04MB6991.namprd04.prod.outlook.com>
 <0101016e8163937a-d539c90e-6df8-454a-969a-9e33e9ef35b6-000000@us-west-2.amazonses.com>
 <MN2PR04MB699170FFA7B2DD59014374D5FC4C0@MN2PR04MB6991.namprd04.prod.outlook.com>
Message-ID: <0101016e870503bb-b0e9294a-c6ea-46de-a8f3-19e11329410c-000000@us-west-2.amazonses.com>
X-Sender: cang@codeaurora.org
User-Agent: Roundcube Webmail/1.3.9
X-SES-Outgoing: 2019.11.20-54.240.27.56
Feedback-ID: 1.us-west-2.CZuq2qbDmUIuT3qdvXlRHZZCpfZqZ4GtG9v3VKgRyF0=:AmazonSES
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2019-11-19 20:41, Avri Altman wrote:
>> 
>> On 2019-11-18 15:15, Avri Altman wrote:
>> >>
>> >> From: Can Guo <cang@codeaurora.org>
>> >>
>> >> Per UFS 3.0 JEDEC standard, the VCCQ2 min voltage is 1.7v and the
>> >> VCCQ voltage range is 1.14v ~ 1.26v. Update their hard codes
>> >> accordingly to make sure they work in a safe range compliant for ver
>> >> 1.0/2.0/2.1/3.0 UFS devices.
>> > So to keep it safe, we need to use largest range:
>> > min_uV = min over all spec ranges, and max_uV = max over all spec
>> > ranges.
>> > Meaning leave it as it is if we want to be backward compatible with
>> > UFS1.0.
>> >
>> > Thanks,
>> > Avri
>> >
>> 
>> Hi Avri,
>> 
>> Sorry I don't quite follow you here.
>> Leaving it as it is means for UFS2.1 devices, when boot up, if we call
>> regulator_set_voltage(1.65, 1.95) to setup its VCCQ2,
>> regulator_set_voltage() will
>> give you 1.65v on VCCQ2 if the voltage level of this regulator is 
>> wider, say (1.60,
>> 1.95).
>> Meaning you will finally set 1.65v to VCCQ2. But 1.65v is out of spec 
>> for UFS
>> v2.1 as it requires min voltage to be 1.7v on VCCQ2. So, the smallest 
>> range is
>> safe.
>> Of course, in real board design, the regulator's voltage level is 
>> limited/designed
>> by power team to be in a safe range, say (1.8, 1.92), so that calling
>> regulator_set_voltage(1.65, 1.95) still gives you 1.8v. But it does 
>> not mean the
>> current hard codes are compliant for all UFS devices.
> You are correct - the narrowest the range the better - as long as you
> don't cross the limits of previous spec.
> So changing 1.1 -> 1.14  and 1.65 -> 1.7 is fine.
> While at it, Vccq max in UFS3.0 is 1.26, why not change 1.3 -> 1.26,
> like you indicated in your commit log?
> 
> Thanks,
> Avri
> 

Thank you Avri, sorry I missed the change to max voltage of VCCQ, I
will update it in the next version.

Best Regards,
Can Guo.

>> 
>> Best Regards,
>> Can Guo.
>> 
>> >>
>> >> Signed-off-by: Can Guo <cang@codeaurora.org>
>> >> ---
>> >>  drivers/scsi/ufs/ufs.h | 4 ++--
>> >>  1 file changed, 2 insertions(+), 2 deletions(-)
>> >>
>> >> diff --git a/drivers/scsi/ufs/ufs.h b/drivers/scsi/ufs/ufs.h index
>> >> 385bac8..9df4f4d
>> >> 100644
>> >> --- a/drivers/scsi/ufs/ufs.h
>> >> +++ b/drivers/scsi/ufs/ufs.h
>> >> @@ -500,9 +500,9 @@ struct ufs_query_res {
>> >>  #define UFS_VREG_VCC_MAX_UV       3600000 /* uV */
>> >>  #define UFS_VREG_VCC_1P8_MIN_UV    1700000 /* uV */
>> >>  #define UFS_VREG_VCC_1P8_MAX_UV    1950000 /* uV */
>> >> -#define UFS_VREG_VCCQ_MIN_UV      1100000 /* uV */
>> >> +#define UFS_VREG_VCCQ_MIN_UV      1140000 /* uV */
>> >>  #define UFS_VREG_VCCQ_MAX_UV      1300000 /* uV */
>> >> -#define UFS_VREG_VCCQ2_MIN_UV     1650000 /* uV */
>> >> +#define UFS_VREG_VCCQ2_MIN_UV     1700000 /* uV */
>> >>  #define UFS_VREG_VCCQ2_MAX_UV     1950000 /* uV */
>> >>
>> >>  /*
>> >> --
>> >> The Qualcomm Innovation Center, Inc. is a member of the Code Aurora
>> >> Forum, a Linux Foundation Collaborative Project
