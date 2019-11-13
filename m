Return-Path: <SRS0=WAUG=ZF=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D7A85C43331
	for <linux-scsi@archiver.kernel.org>; Wed, 13 Nov 2019 02:56:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B0110204FD
	for <linux-scsi@archiver.kernel.org>; Wed, 13 Nov 2019 02:56:34 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="G8SM6vj8";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="opGwTT4D"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727239AbfKMC4b (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 12 Nov 2019 21:56:31 -0500
Received: from smtp.codeaurora.org ([198.145.29.96]:58938 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726979AbfKMC4a (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 12 Nov 2019 21:56:30 -0500
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id 9CF4560D97; Wed, 13 Nov 2019 02:56:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1573613787;
        bh=3LmheRk48+NlxHm6GMuvHg366H/NgNBzGqxNZzKBm7k=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=G8SM6vj8CUBqyoRrxd6bDn/pgy8xMxXFfFCBIMxBW7NXwz8B1ktTj/u2zoo3uAGSU
         OAjBxpGblMJcpbvdDh+yJvtqwbc2iXHGQkG5BdOPnGgLFlgOxcu0N4TvEf6Art5QyG
         PgSbfEHzfSOK0LRaZguKevocps3mFkBVBBlD4vL8=
Received: from mail.codeaurora.org (localhost.localdomain [127.0.0.1])
        by smtp.codeaurora.org (Postfix) with ESMTP id D77B4602EE;
        Wed, 13 Nov 2019 02:56:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1573613783;
        bh=3LmheRk48+NlxHm6GMuvHg366H/NgNBzGqxNZzKBm7k=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=opGwTT4DGOa7r5uChL2HiK08hNb6Ceb1S/UlZwdwhW6FznTvHTWyqD9j6V11GvDGI
         WoFCIwJVgTLBMnon4Mph+qdmkuUUxxIHxdYZpjbpErUhSGaQ83tP/mMrWIg8zLz2rq
         E/vv0ehN+GyJOa0uFEfeAMxC9E1VunFbLX1mogF8=
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Wed, 13 Nov 2019 10:56:22 +0800
From:   cang@codeaurora.org
To:     Avri Altman <Avri.Altman@wdc.com>
Cc:     asutoshd@codeaurora.org, nguyenb@codeaurora.org,
        rnayak@codeaurora.org, linux-scsi@vger.kernel.org,
        kernel-team@android.com, saravanak@google.com, salyzyn@google.com,
        Alim Akhtar <alim.akhtar@samsung.com>,
        Pedro Sousa <pedrom.sousa@synopsys.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Tomas Winkler <tomas.winkler@intel.com>,
        Subhash Jadavani <subhashj@codeaurora.org>,
        Stanley Chu <stanley.chu@mediatek.com>,
        open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v1 3/5] scsi: ufs: Update VCCQ2 and VCCQ min voltage hard
 codes
In-Reply-To: <MN2PR04MB6991D2D4444BB8E319CF916AFC770@MN2PR04MB6991.namprd04.prod.outlook.com>
References: <1573200932-384-1-git-send-email-cang@codeaurora.org>
 <1573200932-384-4-git-send-email-cang@codeaurora.org>
 <MN2PR04MB6991D2D4444BB8E319CF916AFC770@MN2PR04MB6991.namprd04.prod.outlook.com>
Message-ID: <b49ed789b22bc3caa2e7decfbd951c1d@codeaurora.org>
X-Sender: cang@codeaurora.org
User-Agent: Roundcube Webmail/1.2.5
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2019-11-12 15:56, Avri Altman wrote:
>> 
>> 
>> Per UFS 3.0 JEDEC standard, the VCCQ2 min voltage is 1.7v and the VCCQ 
>> min
>> voltage is 1.14v, update their hard codes accordingly.
>> 
>> Signed-off-by: Can Guo <cang@codeaurora.org>
> AFAIK, Vccq2 is 1.7 - 1.95 in UFS2.1 as well.
> Current constants applies to UFS1.1, as indicated in the original 
> patch.
> Vccq is <1.1 - 1.3> in UFS2.1,  and <1.14 - 1.26>, so need to update
> the max as well, and
> make the assignments in ufshcd_populate_vreg depends on 
> hba->ufs_version?
> 

Hi Avri,

Thank you for the comments. I will also update max voltage of VCCQ in 
next series.

BTW, making the assignments in ufshcd_populate_vregs depends on 
hba->ufs_version is
not practical. #1. hba->ufs_version is only get after vregs and clocks 
are ON,
which is way after ufshcd_populate_vregs. #2. hba->ufs_version is the 
version
of HCI, but we need to know the version of the connected UFS device.

The purpose of this change is to make sure the voltages of VCCQ and 
VCCQ2 work in
a safe range for all ver 1.1/2.0/2.1/3.0 UFS devices that can be 
connected to a host.

Best Regards,
Can Guo.

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
