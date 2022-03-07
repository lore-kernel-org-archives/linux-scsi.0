Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A90CBC433FE
	for <linux-scsi@archiver.kernel.org>; Mon,  7 Mar 2022 09:41:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237967AbiCGJm2 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 7 Mar 2022 04:42:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56664 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238576AbiCGJif (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 7 Mar 2022 04:38:35 -0500
Received: from esa2.hgst.iphmx.com (esa2.hgst.iphmx.com [68.232.143.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C0F7F48301
        for <linux-scsi@vger.kernel.org>; Mon,  7 Mar 2022 01:32:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1646645576; x=1678181576;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=llHiu1JSq+kMvM9/4AxtTinDlNJLIPMTZeOhiBuyEto=;
  b=l786gm77F2EI2eblZKtYVvi+0vcxdluRHp8PQh6PjdfK2eIP3ZhmfYto
   RZ6CEHX0KtNMgpm2ANi733lz2bk1mn7utiTdFDI+Gt7oSsnabHJrSwpe6
   6Gzodh/V5ZOAo4hXTE53MRn/SezlGjKsL8vLG2nhMSWT13tRzwFnZqCc3
   nh6TiYn4awlXJG6OMAiw71+CL0exobDTrq5COipKU/qUTu+z4rRPpwyoZ
   CeS56JyjmiIYa7sG5wxM0zhRT99KHFRlJ46JagTPA6qrXkNLYvvrocoOh
   oYx6LpDH/cGdVKVjFYHRPhEAL3qoVxd+mf+1Sn1PesJ+QvzObR+cTZPT2
   w==;
X-IronPort-AV: E=Sophos;i="5.90,161,1643644800"; 
   d="scan'208";a="298787710"
Received: from uls-op-cesaip02.wdc.com (HELO uls-op-cesaep02.wdc.com) ([199.255.45.15])
  by ob1.hgst.iphmx.com with ESMTP; 07 Mar 2022 17:31:42 +0800
IronPort-SDR: kDNPdzqtIKVDmoHX8QL/3n2Vkvfamzs8oqavOuHd6j3oI84AYbq9/yIAUkCpBB3YJlcNoISLCE
 uodRO8OhrmFe+gtAcEOIDIZAxd7w6t4Y9/OTCWikPPMPRQ7yYmrujRTW1SnzFKAMNGOiOvWGsB
 MmWfC+s9wyI90enqBTWNnne59gg9EMYj6BQgGrVwavQVlgtceqSGuTCfSDwv+aToKRXXTJcNQv
 ehyKuiUyR5au2mAc+PsXvbGTtp32XL8vlEH5DYEjJtkrksdhuALpE4dx55B5yLutC6KHO3+Ix8
 k5Ly89DauYhZja4yz7uqd4ZM
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Mar 2022 01:02:59 -0800
IronPort-SDR: odl5mv/4oF1jNboj+bcN6vRzpRz2DiBqR+NqjMjz2zpWdQMlmLp7acbkYwISlz4vwAwMi5kKSx
 UAKVsWFpUeVDIOgVPnq8yjbtwvoZpWaGUeNnPmgw+YaZ5wVsKpuQX23qWWMR3aR0BglI7PVwds
 0dWrS0whRpikYZLcyxzqjCfb4a+aM142GDBnEJMDQ9qAOGK5sFxSplduns6n1Ijh4n9VyqiMzI
 xVRUjR+t7n8puBibJJm9T+4TqrRIgzU3tMZ0Y5DJpbZevysXZog00nD3a2VLWTs4pIBGySBY0A
 ojM=
WDCIronportException: Internal
Received: from usg-ed-osssrv.wdc.com ([10.3.10.180])
  by uls-op-cesaip02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Mar 2022 01:31:42 -0800
Received: from usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTP id 4KBtWd69tpz1SHwl
        for <linux-scsi@vger.kernel.org>; Mon,  7 Mar 2022 01:31:41 -0800 (PST)
Authentication-Results: usg-ed-osssrv.wdc.com (amavisd-new); dkim=pass
        reason="pass (just generated, assumed good)"
        header.d=opensource.wdc.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=
        opensource.wdc.com; h=content-transfer-encoding:content-type
        :in-reply-to:organization:from:references:to:content-language
        :subject:user-agent:mime-version:date:message-id; s=dkim; t=
        1646645496; x=1649237497; bh=llHiu1JSq+kMvM9/4AxtTinDlNJLIPMTZeO
        hiBuyEto=; b=jw3Os9oPeCyK3yc6zDwwpccNXjjni6ZWen20MWdXaxyzww3xMZ8
        v8HMVbO9EO+OhbP2/Y1Fxmc8nCuhMaVrWnt1KQ6eL/DS96ExX+gqysh5hNWeWaJm
        n0ba7swySKd/WaX2k7smAvStEryAkmYtpSAXjCOR3yDHA9vTGQLXu3S4uU5YQwfz
        j9O6OtZg4LF1OrjWFRt0uIIwWHiEBLsFD+SxbflYg5fGDFLFHz+rUZltcxXrOqY/
        2LMkJ23L4KYrzEX+OIGnMRl5p+zcBsHbUn2qCBF+uWNrHLQk+cq9C16/0WvEC9nW
        C5YbJA6yk5WW9Rv3Oz8iHsW7ntXVKz8GrCQ==
X-Virus-Scanned: amavisd-new at usg-ed-osssrv.wdc.com
Received: from usg-ed-osssrv.wdc.com ([127.0.0.1])
        by usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id KhwyPQMAKUZH for <linux-scsi@vger.kernel.org>;
        Mon,  7 Mar 2022 01:31:36 -0800 (PST)
Received: from [10.225.163.91] (unknown [10.225.163.91])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTPSA id 4KBtWW3KWkz1Rvlx;
        Mon,  7 Mar 2022 01:31:35 -0800 (PST)
Message-ID: <4ebb7f96-2075-ce16-5950-7dade5ca1f1a@opensource.wdc.com>
Date:   Mon, 7 Mar 2022 18:31:33 +0900
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [PATCH v2 5/5] scsi: mpt3sas: fix adapter replyPostRegisterIndex
 handling
Content-Language: en-US
To:     Sreekanth Reddy <sreekanth.reddy@broadcom.com>
Cc:     linux-scsi <linux-scsi@vger.kernel.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Sathya Prakash <sathya.prakash@broadcom.com>,
        Suganath Prabu Subramani 
        <suganath-prabu.subramani@broadcom.com>,
        PDL-MPT-FUSIONLINUX <MPT-FusionLinux.pdl@broadcom.com>
References: <20220224233056.398054-1-damien.lemoal@opensource.wdc.com>
 <20220224233056.398054-6-damien.lemoal@opensource.wdc.com>
 <CAK=zhgosk4YHiKVriYAVNL8oApnA6MsEz9jvOo3imkCUpOpTRQ@mail.gmail.com>
From:   Damien Le Moal <damien.lemoal@opensource.wdc.com>
Organization: Western Digital Research
In-Reply-To: <CAK=zhgosk4YHiKVriYAVNL8oApnA6MsEz9jvOo3imkCUpOpTRQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 3/7/22 16:35, Sreekanth Reddy wrote:
> On Fri, Feb 25, 2022 at 5:01 AM Damien Le Moal
> <damien.lemoal@opensource.wdc.com> wrote:
>>
>> The replyPostRegisterIndex array of struct MPT3SAS_ADAPTER is regular
>> memory allocated from RAM, and not an IO mem resource. writel() should
>> thus not be used to assign values to the array entries. Replace the
>> writel() call modifying the array with direct assignements. This change
>> suppresses sparse warnings.
> 
> writel() is a must here.  replyPostRegisterIndex array is having the
> iommu address.
> and here the driver is writing the data to these iommu addresses retrieved from
> replyPostRegisterIndex array.

So the declaration of this array of wrong. it should be an array of
__iomem void * entries, not an array of resource_size_t * entries (which
by the way does not make sense to me since the use of the array is
clearly to store an address, not a pointer to an address).

How do you prefer this fixed ? I would rather not add local casts here
and fix the declaration of the replyPostRegisterIndex array.

> 
> Thanks,
> Sreekanth
> 
>>
>> Signed-off-by: Damien Le Moal <damien.lemoal@opensource.wdc.com>
>> ---
>>  drivers/scsi/mpt3sas/mpt3sas_base.c | 37 ++++++++++++++++++-----------
>>  1 file changed, 23 insertions(+), 14 deletions(-)
>>
>> diff --git a/drivers/scsi/mpt3sas/mpt3sas_base.c b/drivers/scsi/mpt3sas/mpt3sas_base.c
>> index 5efe4bd186db..4caa719b4ef4 100644
>> --- a/drivers/scsi/mpt3sas/mpt3sas_base.c
>> +++ b/drivers/scsi/mpt3sas/mpt3sas_base.c
>> @@ -1771,10 +1771,13 @@ _base_process_reply_queue(struct adapter_reply_queue *reply_q)
>>                  */
>>                 if (completed_cmds >= ioc->thresh_hold) {
>>                         if (ioc->combined_reply_queue) {
>> -                               writel(reply_q->reply_post_host_index |
>> -                                               ((msix_index  & 7) <<
>> -                                                MPI2_RPHI_MSIX_INDEX_SHIFT),
>> -                                   ioc->replyPostRegisterIndex[msix_index/8]);
>> +                               unsigned long idx =
>> +                                       reply_q->reply_post_host_index |
>> +                                       ((msix_index  & 7) <<
>> +                                        MPI2_RPHI_MSIX_INDEX_SHIFT);
>> +
>> +                               ioc->replyPostRegisterIndex[msix_index/8] =
>> +                                       (resource_size_t *) idx;
>>                         } else {
>>                                 writel(reply_q->reply_post_host_index |
>>                                                 (msix_index <<
>> @@ -1826,14 +1829,17 @@ _base_process_reply_queue(struct adapter_reply_queue *reply_q)
>>          * new reply host index value in ReplyPostIndex Field and msix_index
>>          * value in MSIxIndex field.
>>          */
>> -       if (ioc->combined_reply_queue)
>> -               writel(reply_q->reply_post_host_index | ((msix_index  & 7) <<
>> -                       MPI2_RPHI_MSIX_INDEX_SHIFT),
>> -                       ioc->replyPostRegisterIndex[msix_index/8]);
>> -       else
>> +       if (ioc->combined_reply_queue) {
>> +               unsigned long idx = reply_q->reply_post_host_index |
>> +                       ((msix_index  & 7) << MPI2_RPHI_MSIX_INDEX_SHIFT);
>> +
>> +               ioc->replyPostRegisterIndex[msix_index/8] =
>> +                       (resource_size_t *) idx;
>> +       } else {
>>                 writel(reply_q->reply_post_host_index | (msix_index <<
>>                         MPI2_RPHI_MSIX_INDEX_SHIFT),
>>                         &ioc->chip->ReplyPostHostIndex);
>> +       }
>>         atomic_dec(&reply_q->busy);
>>         return completed_cmds;
>>  }
>> @@ -8095,14 +8101,17 @@ _base_make_ioc_operational(struct MPT3SAS_ADAPTER *ioc)
>>
>>         /* initialize reply post host index */
>>         list_for_each_entry(reply_q, &ioc->reply_queue_list, list) {
>> -               if (ioc->combined_reply_queue)
>> -                       writel((reply_q->msix_index & 7)<<
>> -                          MPI2_RPHI_MSIX_INDEX_SHIFT,
>> -                          ioc->replyPostRegisterIndex[reply_q->msix_index/8]);
>> -               else
>> +               if (ioc->combined_reply_queue) {
>> +                       unsigned long idx =(reply_q->msix_index & 7) <<
>> +                               MPI2_RPHI_MSIX_INDEX_SHIFT;
>> +
>> +                       ioc->replyPostRegisterIndex[reply_q->msix_index/8] =
>> +                               (resource_size_t *) idx;
>> +               } else {
>>                         writel(reply_q->msix_index <<
>>                                 MPI2_RPHI_MSIX_INDEX_SHIFT,
>>                                 &ioc->chip->ReplyPostHostIndex);
>> +               }
>>
>>                 if (!_base_is_controller_msix_enabled(ioc))
>>                         goto skip_init_reply_post_host_index;
>> --
>> 2.35.1
>>


-- 
Damien Le Moal
Western Digital Research
