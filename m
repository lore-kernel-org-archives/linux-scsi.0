Return-Path: <SRS0=81Lx=ZL=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D5B32C432C3
	for <linux-scsi@archiver.kernel.org>; Tue, 19 Nov 2019 02:00:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9F4DD222F2
	for <linux-scsi@archiver.kernel.org>; Tue, 19 Nov 2019 02:00:21 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="bTKW7Euh";
	dkim=pass (1024-bit key) header.d=amazonses.com header.i=@amazonses.com header.b="QeXuzILQ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727014AbfKSCAS (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 18 Nov 2019 21:00:18 -0500
Received: from a27-188.smtp-out.us-west-2.amazonses.com ([54.240.27.188]:48322
        "EHLO a27-188.smtp-out.us-west-2.amazonses.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726761AbfKSCAS (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 18 Nov 2019 21:00:18 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/simple;
        s=zsmsymrwgfyinv5wlfyidntwsjeeldzt; d=codeaurora.org; t=1574128817;
        h=MIME-Version:Content-Type:Content-Transfer-Encoding:Date:From:To:Cc:Subject:In-Reply-To:References:Message-ID;
        bh=7V4ORWP4fmF4jElRRjqAY3TB3aDqmX0kyeDAD63NAXI=;
        b=bTKW7EuhSjXlKRDMjm7W+okWiYVbugJm9jJZVv2klzVKWL8Kxux0BfAkWuahy+a3
        VDX/wBKKKox8V1NdH5NDNWyYNAVW34ds8YOpmAzqrFVdnSzH5MOxK23XOksKEkP2fJz
        jgBnTfSFk2cDvA697vEJHLMwl4vgYpla9Y3O9HGA=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/simple;
        s=gdwg2y3kokkkj5a55z2ilkup5wp5hhxx; d=amazonses.com; t=1574128816;
        h=MIME-Version:Content-Type:Content-Transfer-Encoding:Date:From:To:Cc:Subject:In-Reply-To:References:Message-ID:Feedback-ID;
        bh=7V4ORWP4fmF4jElRRjqAY3TB3aDqmX0kyeDAD63NAXI=;
        b=QeXuzILQm7kHviFL/e1WbYMrNgz86RFtKHQMHZj2UPCVZqrQacAOmwd9NE35u+aF
        XpFc91shZwT9iQmU59E0yzvdxpNZUk2wbf7rBkK898/NnM+hqnz6PnJqQT1JIo/geOf
        E6EIuz4wJ5C7fStnoGJN3tKmCEmnqoJllQJ4nheQ=
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Tue, 19 Nov 2019 02:00:16 +0000
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
In-Reply-To: <MN2PR04MB6991121D72EA8E6DF7F6258AFC4D0@MN2PR04MB6991.namprd04.prod.outlook.com>
References: <1574049061-11417-1-git-send-email-cang@qti.qualcomm.com>
 <1574049061-11417-3-git-send-email-cang@qti.qualcomm.com>
 <MN2PR04MB6991121D72EA8E6DF7F6258AFC4D0@MN2PR04MB6991.namprd04.prod.outlook.com>
Message-ID: <0101016e816392e3-3a981572-cccc-4a0e-a462-8790ab7c11b7-000000@us-west-2.amazonses.com>
X-Sender: cang@codeaurora.org
User-Agent: Roundcube Webmail/1.3.9
X-SES-Outgoing: 2019.11.19-54.240.27.188
Feedback-ID: 1.us-west-2.CZuq2qbDmUIuT3qdvXlRHZZCpfZqZ4GtG9v3VKgRyF0=:AmazonSES
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2019-11-18 15:15, Avri Altman wrote:
>> 
>> From: Can Guo <cang@codeaurora.org>
>> 
>> Per UFS 3.0 JEDEC standard, the VCCQ2 min voltage is 1.7v and the VCCQ
>> voltage range is 1.14v ~ 1.26v. Update their hard codes accordingly to 
>> make
>> sure they work in a safe range compliant for ver 1.0/2.0/2.1/3.0 UFS 
>> devices.
> So to keep it safe, we need to use largest range:
> min_uV = min over all spec ranges, and max_uV = max over all spec 
> ranges.
> Meaning leave it as it is if we want to be backward compatible with 
> UFS1.0.
> 
> Thanks,
> Avri
> 

Hi Avri,

Sorry I don't quite follow you here.
Leaving it as it is means for UFS2.1 devices, when boot up, if we call
regulator_set_voltage(1.65, 1.95) to setup its VCCQ2, 
regulator_set_voltage() will
give you 1.65v on VCCQ2 if the voltage level of this regulator is wider, 
say (1.60, 1.95).
Meaning you will finally set 1.65v to VCCQ2. But 1.65v is out of spec 
for UFS v2.1 as it
requires min voltage to be 1.7v on VCCQ2. So, the smallest range is 
safe.
Of course, in real board design, the regulator's voltage level is 
limited/designed by power team
to be in a safe range, say (1.8, 1.92), so that calling 
regulator_set_voltage(1.65, 1.95) still gives
you 1.8v. But it does not mean the current hard codes are compliant for 
all UFS devices.

Best Regards,
Can Guo.

>> 
>> Signed-off-by: Can Guo <cang@codeaurora.org>
>> ---
>>  drivers/scsi/ufs/ufs.h | 4 ++--
>>  1 file changed, 2 insertions(+), 2 deletions(-)
>> 
>> diff --git a/drivers/scsi/ufs/ufs.h b/drivers/scsi/ufs/ufs.h index 
>> 385bac8..9df4f4d
>> 100644
>> --- a/drivers/scsi/ufs/ufs.h
>> +++ b/drivers/scsi/ufs/ufs.h
>> @@ -500,9 +500,9 @@ struct ufs_query_res {
>>  #define UFS_VREG_VCC_MAX_UV       3600000 /* uV */
>>  #define UFS_VREG_VCC_1P8_MIN_UV    1700000 /* uV */
>>  #define UFS_VREG_VCC_1P8_MAX_UV    1950000 /* uV */
>> -#define UFS_VREG_VCCQ_MIN_UV      1100000 /* uV */
>> +#define UFS_VREG_VCCQ_MIN_UV      1140000 /* uV */
>>  #define UFS_VREG_VCCQ_MAX_UV      1300000 /* uV */
>> -#define UFS_VREG_VCCQ2_MIN_UV     1650000 /* uV */
>> +#define UFS_VREG_VCCQ2_MIN_UV     1700000 /* uV */
>>  #define UFS_VREG_VCCQ2_MAX_UV     1950000 /* uV */
>> 
>>  /*
>> --
>> The Qualcomm Innovation Center, Inc. is a member of the Code Aurora 
>> Forum,
>> a Linux Foundation Collaborative Project
