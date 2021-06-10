Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.9 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C7A46C47094
	for <linux-scsi@archiver.kernel.org>; Thu, 10 Jun 2021 06:24:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AF0C96128A
	for <linux-scsi@archiver.kernel.org>; Thu, 10 Jun 2021 06:24:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229989AbhFJG0A (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 10 Jun 2021 02:26:00 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:54854 "EHLO
        mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229778AbhFJGZ6 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 10 Jun 2021 02:25:58 -0400
Received: from epcas2p1.samsung.com (unknown [182.195.41.53])
        by mailout4.samsung.com (KnoxPortal) with ESMTP id 20210610062400epoutp04731ca7f43f209981aae38e9a04b6789a~HJGzAyTPU1383813838epoutp04R
        for <linux-scsi@vger.kernel.org>; Thu, 10 Jun 2021 06:24:00 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout4.samsung.com 20210610062400epoutp04731ca7f43f209981aae38e9a04b6789a~HJGzAyTPU1383813838epoutp04R
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1623306240;
        bh=vPnakGn46Ipdn6aWEJrZfY+RmQgSHUEkUcG4OXvgT60=;
        h=Subject:Reply-To:From:To:CC:In-Reply-To:Date:References:From;
        b=i/9Ya5sTXtVUyBA1Ee9v2VJQ3K3h56EwGjjQg8PYshJGS3R32ftPvejb0JbysZpKE
         61BqbvAl8BuvHav5WW4wRAvcGA0w3s4Op0x+kL3GjVwDqu6n8f+2K/VKZl/9kL17df
         PoCzqz2t7OSictWVlZI29nPSed5B6hFzKpL46uVw=
Received: from epsnrtp4.localdomain (unknown [182.195.42.165]) by
        epcas2p4.samsung.com (KnoxPortal) with ESMTP id
        20210610062358epcas2p4bebc3c21d9c834898bff4f1398b29f91~HJGxwIRvy3043130431epcas2p4j;
        Thu, 10 Jun 2021 06:23:58 +0000 (GMT)
Received: from epsmges2p4.samsung.com (unknown [182.195.40.191]) by
        epsnrtp4.localdomain (Postfix) with ESMTP id 4G0v7c1NXlz4x9QB; Thu, 10 Jun
        2021 06:23:56 +0000 (GMT)
X-AuditID: b6c32a48-4fbff700000025f5-fe-60c1affa878c
Received: from epcas2p3.samsung.com ( [182.195.41.55]) by
        epsmges2p4.samsung.com (Symantec Messaging Gateway) with SMTP id
        0E.E7.09717.AFFA1C06; Thu, 10 Jun 2021 15:23:54 +0900 (KST)
Mime-Version: 1.0
Subject: RE: Re: [PATCH v36 4/4] scsi: ufs: Add HPB 2.0 support
Reply-To: daejun7.park@samsung.com
Sender: Daejun Park <daejun7.park@samsung.com>
From:   Daejun Park <daejun7.park@samsung.com>
To:     Bart Van Assche <bvanassche@acm.org>,
        Daejun Park <daejun7.park@samsung.com>,
        Greg KH <gregkh@linuxfoundation.org>,
        "avri.altman@wdc.com" <avri.altman@wdc.com>,
        "jejb@linux.ibm.com" <jejb@linux.ibm.com>,
        "martin.petersen@oracle.com" <martin.petersen@oracle.com>,
        "asutoshd@codeaurora.org" <asutoshd@codeaurora.org>,
        "stanley.chu@mediatek.com" <stanley.chu@mediatek.com>,
        "cang@codeaurora.org" <cang@codeaurora.org>,
        "huobean@gmail.com" <huobean@gmail.com>,
        ALIM AKHTAR <alim.akhtar@samsung.com>
CC:     "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        JinHwan Park <jh.i.park@samsung.com>,
        Javier Gonzalez <javier.gonz@samsung.com>,
        Sung-Jun Park <sungjun07.park@samsung.com>,
        Jinyoung CHOI <j-young.choi@samsung.com>,
        Dukhyun Kwon <d_hyun.kwon@samsung.com>,
        Keoseong Park <keosung.park@samsung.com>,
        Jaemyung Lee <jaemyung.lee@samsung.com>,
        Jieon Seol <jieon.seol@samsung.com>
X-Priority: 3
X-Content-Kind-Code: NORMAL
In-Reply-To: <25912c0a-7f52-8b04-2ac1-6686aee01f87@acm.org>
X-CPGS-Detection: blocking_info_exchange
X-Drm-Type: N,general
X-Msg-Generator: Mail
X-Msg-Type: PERSONAL
X-Reply-Demand: N
Message-ID: <20210610062354epcms2p19ed22ed39a4e2fce53dafb8e51b1364f@epcms2p1>
Date:   Thu, 10 Jun 2021 15:23:54 +0900
X-CMS-MailID: 20210610062354epcms2p19ed22ed39a4e2fce53dafb8e51b1364f
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: AUTO_CONFIDENTIAL
X-CPGSPASS: Y
X-CPGSPASS: Y
CMS-TYPE: 102P
X-Brightmail-Tracker: H4sIAAAAAAAAA12Te0xTVxzHc+4t915YSi4V3BEXwKubwgRaRuEAxTl85BoUwWVZRibQwA0l
        68vewnQko1M3HMhDEsQAOifiAzs6UKCA8pyCROaQMaUCwzmWkAxksGzQQR2lZZr99znf8z2/
        1zmHwkWThDeVodZzOrVcyRBugsZu//BAq6kzRdxXL0bj5xoJdOuLXhJNLgwR6PTMAo5mTZdc
        0GSXP2rp7CRQzfj76FiViUCV/QYMFRQ1EOh657c4ejoyR6ILjxoxVGTLFaDGOQ/Uc3caoMGW
        SgLlPzQT6HKPDUPVDcMAfVlmFGxfyw7+GMsOFhZgbHP5KMkWX+gAbPtZI8kev9suYP+YsAjY
        whs1gJ2r92FzO/KxeLdEpUzBydM4nR+nTtWkZajTo5nYd5N3JEvDxJJASQQKZ/zUchUXzezc
        Gx+4O0O53CbjlyVXZi5L8XKeZ4K3yXSaTD3np9Dw+miG06YptRKJNoiXq/hMdXpQqkYVKRGL
        Q6TLzhSl4uSxIUJ7JeDwgLUPN4DvX8sDrhSkQ+EV2zyWB9woEW0G8LHxCZkHKEpIe8Al8xq7
        Zw39NjRPl5B2FtEMNA2Ukw49CFqeGIGdCXorLOv9mbTH8aSPCmBz95TAvsDp+zi8+SgXOLIJ
        4ZncCYGD18Omyw0ruisdBW+WLTo9W+D8pQLcwV5w+NoUucrP7nzl9HjCz8f6nR4POL7Q6tTX
        wTutM5iDc2DDiBXYi4D0SQC7my0ujo1g+NOJupUihPQ+WFtqXQkkoF+Hzzv+dAbdCeuam1cY
        p31h01Qlbp8KTvtDU0uwHSG9EX5nEay2Zaj7h/w/47Q7PNG99J9uPvers7Q3YO2CCSsGG8tf
        jLr8pVzlL3KdB3gNWMtpeVU6x4doQ1++3Xqw8uYDWDOomJoJ6gIYBboApHDGU5glaUsRCdPk
        Rz7hdJpkXaaS47uAdLnLU7i3V6pm+dOo9ckSaUhYmDhCiqRhIYh5VbjAfZoiotPleu4jjtNy
        utVzGOXqbcAiUyvdz94+eq/hUGfJljLD2N/G2k2UZtfFhBIhD1pl02++lyLKyiid95qNW19M
        npbszskeqWu7Hq5K0igtX382cCModmjxgVei28ODt+IW3Z9BmW9E46b9o2PbPtBJX6mKC7Bu
        1ohdZJK5t/qGEysTRqGvLWZXbNH2dkO2j4ey7cz9v36zxs/PUofPP85R6C0HD7zTbfvhQPr8
        Ymbk0+z8PbGGiuzwa9UP+pO29hQqEo+YD2HepZYY3pf4JiG4v8R7rHeoYl3qQM5e9w0ZaQXP
        hyPNzPRm1z0T8T5R1cM7PvY3Xi1aqlJJLobu//1DIMshlbkxG5qSwC/HbbelUQi7F84IeIVc
        EoDrePm/WllOk3wEAAA=
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20210607041650epcms2p29002c9d072738bbf21fb4acf31847e8e
References: <25912c0a-7f52-8b04-2ac1-6686aee01f87@acm.org>
        <20210607041650epcms2p29002c9d072738bbf21fb4acf31847e8e@epcms2p2>
        <20210607041927epcms2p707781de1678af1e1d0f4d88782125f7b@epcms2p7>
        <CGME20210607041650epcms2p29002c9d072738bbf21fb4acf31847e8e@epcms2p1>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi Bart,

>On 6/6/21 9:19 PM, Daejun Park wrote:
>> -What:                /sys/class/scsi_device/*/device/hpb_sysfs/hit_cnt
>> +What:                /sys/class/scsi_device/*/device/hpb_stat_sysfs/hit_cnt
>>  Date:                June 2021
>>  Contact:        Daejun Park <daejun7.park@samsung.com>
>>  Description:        This entry shows the number of reads that changed to HPB read.
>>  
>>                  The file is read only.
> 
>Is it really useful to have a suffix "_sysfs" for a directory that
>occurs in sysfs? If not, please leave it out.
> 
>Should "hpb_stat" perhaps be renamed into "hpb_stats"? An example of
>another directory with statistics is /sys/power/suspend_stats. The name
>of that directory also ends in "stats" (plural form).

OK, I will change it.

> 
>> +What:                /sys/bus/platform/drivers/ufshcd/*/attributes/max_data_size_hpb_single_cmd
>> +Date:                June 2021
>> +Contact:        Daejun Park <daejun7.park@samsung.com>
>> +Description:        This entry shows the maximum HPB data size for using single HPB
>> +                command.
>> +
>> +                ===  ========
>> +                00h  4KB
>> +                01h  8KB
>> +                02h  12KB
>> +                ...
>> +                FFh  1024KB
>> +                ===  ========
>> +
>> +                The file is read only.
> 
>This is not clear enough. What are the values reported through this
>sysfs attribute? Are that perhaps the values 00h .. FFh? Is the software
>that reads this attribute perhaps expected to convert this attribute
>from hex to int and next convert the int into a size in KB by using the
>above lookup table? That seems awkward to me. Please report the maximum
>data size directly, either in KB or in bytes.

We show the bMAX_DATA_SIZE_FOR_SINGLE_CMD value just like other existing
ufs sysfs attributes. In the case of sysfs for the bRefClkFreq value, it
shows the raw value read from the device, not the value converted to HZ.

>> diff --git a/drivers/scsi/ufs/ufshcd.h b/drivers/scsi/ufs/ufshcd.h
>> index f99059b31e0a..d902414e4a6f 100644
>> --- a/drivers/scsi/ufs/ufshcd.h
>> +++ b/drivers/scsi/ufs/ufshcd.h
>> @@ -652,6 +652,8 @@ struct ufs_hba_variant_params {
>>   * @srgn_size: device reported HPB sub-region size
>>   * @slave_conf_cnt: counter to check all lu finished initialization
>>   * @hpb_disabled: flag to check if HPB is disabled
>> + * @max_hpb_single_cmd: maximum size of single HPB command
>> + * @is_legacy: flag to check HPB 1.0
>>   */
>>  struct ufshpb_dev_info {
>>          int num_lu;
>> @@ -659,6 +661,8 @@ struct ufshpb_dev_info {
>>          int srgn_size;
>>          atomic_t slave_conf_cnt;
>>          bool hpb_disabled;
>> +        int max_hpb_single_cmd;
>> +        bool is_legacy;
>>  };
>>  #endif
> 
>Elsewhere in this patch I see that max_hpb_single_cmd is the value read
>from the bMAX_DATA_SIZE_FOR_SINGLE_CMD descriptor (one byte). Does this
>mean that the type of 'max_hpb_single_cmd' should be changed into
>uint8_t? Additionally, please make it clear in the comment block above
>struct ufshpb_dev_info that max_hpb_single_cmd is not a size in bytes.

OK, it will be u8 and the comments will be as follows.
@max_hpb_single_cmd: the value of bMAX_DATA_SIZE_FOR_SINGLE_CMD.

> 
>> +bool ufshpb_is_legacy(struct ufs_hba *hba)
>> +{
>> +        return hba->ufshpb_dev.is_legacy;
>> +}
> 
>Please add a comment above this function that explains what 'legacy'
>means in the context of HPB.

OK, I will add:
/* HPB version 1.0 is called as legacy version. */

> 
>> +static int ufshpb_execute_umap_req(struct ufshpb_lu *hpb,
>> +                                   struct ufshpb_req *umap_req,
>> +                                   struct ufshpb_region *rgn)
>> +{
>> +        struct request *req;
>> +        struct scsi_request *rq;
>> +
>> +        req = umap_req->req;
>> +        req->timeout = 0;
>> +        req->end_io_data = (void *)umap_req;
>> +        rq = scsi_req(req);
>> +        ufshpb_set_unmap_cmd(rq->cmd, rgn);
>> +        rq->cmd_len = HPB_WRITE_BUFFER_CMD_LENGTH;
>> +
>> +        blk_execute_rq_nowait(NULL, req, 1, ufshpb_umap_req_compl_fn);
>> +
>> +        return 0;
>> +}
> 
>This function always returns 0. Please change the return type from 'int'
>into 'void'.

Sure.

> 
>> +/* SYSFS functions */
>> +#define ufshpb_sysfs_param_show_func(__name)                                \
>> +static ssize_t __name##_show(struct device *dev,                        \
>> +        struct device_attribute *attr, char *buf)                        \
>> +{                                                                        \
>> +        struct scsi_device *sdev = to_scsi_device(dev);                        \
>> +        struct ufshpb_lu *hpb = ufshpb_get_hpb_data(sdev);                \
>> +        if (!hpb)                                                        \
>> +                return -ENODEV;                                                \
>> +                                                                        \
>> +        return sysfs_emit(buf, "%d\n", hpb->params.__name);                \
>> +}
> 
>Please leave a blank line between variable declarations and code.

OK, I will add it.

Thanks,
Daejun

>Thanks,
> 
>Bart.
> 
> 
>  
