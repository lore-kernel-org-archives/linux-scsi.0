Return-Path: <SRS0=d5MZ=CR=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 56B3BC2D0A7
	for <linux-scsi@archiver.kernel.org>; Tue,  8 Sep 2020 20:12:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E9C1621741
	for <linux-scsi@archiver.kernel.org>; Tue,  8 Sep 2020 20:12:12 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=ts.fujitsu.com header.i=@ts.fujitsu.com header.b="WSDkE+Sf"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730742AbgIHUKp (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 8 Sep 2020 16:10:45 -0400
Received: from mail3.bemta25.messagelabs.com ([195.245.230.82]:14003 "EHLO
        mail3.bemta25.messagelabs.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1730159AbgIHPPp (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 8 Sep 2020 11:15:45 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ts.fujitsu.com;
        s=200619tsfj; t=1599575493; i=@ts.fujitsu.com;
        bh=OWYDgE2xVfFjzK6blR/YjuqNB/gJdPmUk9ZGy7fbnfY=;
        h=Subject:To:References:From:Message-ID:Date:MIME-Version:
         In-Reply-To:Content-Type:Content-Transfer-Encoding;
        b=WSDkE+Sfg0CJKilDgRj9B3dnkkOeapR+bBF9tsRW/AEvBNRHgtpTa/rNSWJ3KaKdm
         oCmmm8FUqpfCDdclac2mgQVJ68Qf6H9hxJKsuf7cx2s0WYBF7pcgf4e1M7Mb07UAnt
         DQZ7Fdaq09/oajH7ygM27BassuOmVqgMjhQ7kAcBE0lEKd2za7LiIwSpD1mkoIza3l
         rtsT3nqsvF9d1RCOHJguGAFtpdXnQ1VBgar860j8lKrKTR+FiojLG0xRZvqHoeIii4
         kpGcQkJLuG8sag+IVA9LzBzEaL6mms1vNSNFonGRdaTzkZB+Glgrx07sGKlR0nJ+9d
         QOkr07ihXNsSg==
Received: from [100.112.199.122] (using TLSv1.2 with cipher DHE-RSA-AES256-GCM-SHA384 (256 bits))
        by server-2.bemta.az-b.eu-west-1.aws.symcld.net id C7/89-29177-5C5975F5; Tue, 08 Sep 2020 14:31:33 +0000
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrFIsWRWlGSWpSXmKPExsViZ8MRontkani
  8wczJehYb+zksuq/vYLNYfvwfk8XfSTdYLVqXvmVyYPWYNukUm8fHp7dYPD5vkgtgjmLNzEvK
  r0hgzXjau4a5YLZ0Rf+HTsYGxuOiXYxcHEICkxgl1vT/ZIJw+hklLmx5zdzFyMkhLJAg8ejQf
  zaQhIjAW0aJw9P/M4IkhAQKJFZeW8MKYrMJGEismHSfBcTmFXCUmNJ6DqyZRUBF4k3TAyCbg0
  NUIFzi2Qp/iBJBiZMzn4CVcwrYSex59g2snFnATGLe5odQtrjErSfzmSBseYntb+cwT2Dkm4W
  kfRaSlllIWmYhaVnAyLKK0SKpKDM9oyQ3MTNH19DAQNfQ0EjX0NJc19DYXC+xSjdJL7VUtzy1
  uETXUC+xvFivuDI3OSdFLy+1ZBMjMMBTCo527mD89eqD3iFGSQ4mJVHe1ZPC44X4kvJTKjMSi
  zPii0pzUosPMcpwcChJ8PoBY0ZIsCg1PbUiLTMHGG0waQkOHiUR3v9TgNK8xQWJucWZ6RCpU4
  zGHDuPzlvEzHFy1ZJFzEIsefl5qVLivCUgpQIgpRmleXCDYEngEqOslDAvIwMDgxBPQWpRbmY
  JqvwrRnEORiVh3p0gU3gy80rg9r0COoUJ6BQprVCQU0oSEVJSDUy6Tx7se5AaVfUjjvvt80UN
  7qnJk51TS9mX5/Nn/b53eCFP6jdn/m1layJTr0d1rowwrBI8NUNo9r9/W4TDao6mR6hvjo3Yt
  PNQfdShEyHGgpyBT0MX7P7y7kz/Noa4hAbximc1JsxKu+2WdXUUJ5vsv3wmOuz2DMfbkdlmxV
  5Jd/Td/Z+rpgg+K3p3tH/edLfNVg8/1B6bfd3oO9vCiMyX/1qe5xltkk+oXctn63viw+TiFI/
  9vyw/ffwguXS2mfrChjkb3/vVFbjm8E+JqpgXGX/RZK7NTMlZPfGXdQwPNTisbN6wuT5uy0kz
  uw1JRpMTDW61zH7u0qn5r0XoS6NPb8Bsr+bYxOl7/348za3EUpyRaKjFXFScCABX5roXfQMAA
  A==
X-Env-Sender: bstroesser@ts.fujitsu.com
X-Msg-Ref: server-9.tower-285.messagelabs.com!1599575492!24351!1
X-Originating-IP: [62.60.8.84]
X-SYMC-ESS-Client-Auth: outbound-route-from=pass
X-StarScan-Received: 
X-StarScan-Version: 9.50.3; banners=-,-,-
X-VirusChecked: Checked
Received: (qmail 2294 invoked from network); 8 Sep 2020 14:31:32 -0000
Received: from unknown (HELO mailhost3.uk.fujitsu.com) (62.60.8.84)
  by server-9.tower-285.messagelabs.com with ECDHE-RSA-AES256-GCM-SHA384 encrypted SMTP; 8 Sep 2020 14:31:32 -0000
Received: from x-serv01 ([172.17.38.52])
        by mailhost3.uk.fujitsu.com (8.14.5/8.14.5) with SMTP id 088EVVcs016502;
        Tue, 8 Sep 2020 15:31:31 +0100
Received: from [172.17.39.90] (unknown [172.17.39.90])
        by x-serv01 (Postfix) with ESMTP id C1D9F20355;
        Tue,  8 Sep 2020 16:31:18 +0200 (CEST)
Subject: Re: [PATCH v2] scsi: target: tcmu: add compat mode for 32bit
 userspace on 64bit kernel
To:     Mike Christie <michael.christie@oracle.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        James Bottomley <James.Bottomley@HansenPartnership.com>,
        linux-scsi@vger.kernel.org, target-devel@vger.kernel.org
References: <20200903174105.4571-1-bstroesser@ts.fujitsu.com>
 <8f276b52-f741-b00b-9b00-77fcd855c4fe@oracle.com>
From:   Bodo Stroesser <bstroesser@ts.fujitsu.com>
Message-ID: <79cd442a-2c7d-76e9-e82d-c40d2b57ecde@ts.fujitsu.com>
Date:   Tue, 8 Sep 2020 16:31:24 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.9.0
MIME-Version: 1.0
In-Reply-To: <8f276b52-f741-b00b-9b00-77fcd855c4fe@oracle.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2020-09-08 01:14, Mike Christie wrote:
> On 9/3/20 12:41 PM, Bodo Stroesser wrote:
>> +#ifdef TCMU_COMPAT
>> +static inline void compat_new_iov(struct iovec **iov, int *iov_cnt)
>> +{
>> +	struct compat_iovec **c_iov = (struct compat_iovec **)iov;
>> +
>> +	if (*iov_cnt != 0)
>> +		(*c_iov)++;
>> +	(*iov_cnt)++;
>> +
>> +	memset(*c_iov, 0, sizeof(struct compat_iovec));
>> +}
>> +
>> +static inline size_t compat_iov_tail(struct iovec *iov)
>> +{
>> +	struct compat_iovec *c_iov = (struct compat_iovec *)iov;
>> +
>> +	return (size_t)c_iov->iov_base + c_iov->iov_len;
>> +}
>> +#endif
>> +
>>   static void scatter_data_area(struct tcmu_dev *udev,
>>   	struct tcmu_cmd *tcmu_cmd, struct scatterlist *data_sg,
>>   	unsigned int data_nents, struct iovec **iov,
>> @@ -705,13 +763,41 @@ static void scatter_data_area(struct tcmu_dev *udev,
>>   			to_offset = get_block_offset_user(udev, dbi,
>>   					block_remaining);
>>   
>> +			copy_bytes = min_t(size_t, sg_remaining,
>> +					block_remaining);
>> +			if (copy_data) {
>> +				offset = DATA_BLOCK_SIZE - block_remaining;
>> +				memcpy(to + offset,
>> +				       from + sg->length - sg_remaining,
>> +				       copy_bytes);
>> +			}
>> +			sg_remaining -= copy_bytes;
>> +			block_remaining -= copy_bytes;
>> +
>>   			/*
>>   			 * The following code will gather and map the blocks
>>   			 * to the same iovec when the blocks are all next to
>>   			 * each other.
>>   			 */
>> -			copy_bytes = min_t(size_t, sg_remaining,
>> -					block_remaining);
>> +#ifdef TCMU_COMPAT
>> +			if (udev->compat) {
>> +				struct compat_iovec *c_iov;
>> +
>> +				if (*iov_cnt != 0 &&
>> +				    to_offset == compat_iov_tail(*iov)) {
>> +					c_iov = (struct compat_iovec *)*iov;
>> +					c_iov->iov_len += copy_bytes;
>> +				} else {
>> +					compat_new_iov(iov, iov_cnt);
>> +					c_iov = (struct compat_iovec *)*iov;
>> +					c_iov->iov_base =
>> +						(compat_uptr_t)to_offset;
>> +					c_iov->iov_len = copy_bytes;
>> +				}
>> +				continue;
>> +			}
>> +#endif
> 
> I think a couple one or two liner ifdefs in the middle of a function is something people look the other way on. Maybe here we went a little too wild though. If we are not going the callout route, I think it would be nicer here to separate this part into functions. In the ifdef with compat_new_iov/compat_iov_tail above this function, add a tcmu_compat_iov_set and move the code above there. Move the code below it that does the non compat code to a new function tcmu_iov_set. We will still need a ifdef for the tcmu_compat_iov_set somewhere, but it feels more organized.
> 

Ok. I agree.

To be honest, I already prepared a new patch series allowing to
have buffer chunks bigger than one page in data area of tcmu's
uio device. While tcmu still uses single page allocation, the
change allows to have shorter iovec lists, less buffer bits to
maintain, and if necessary allows userspace to choose buffer chunks
as big as max. expected IO data size, which from userspace perspective
makes every IO up to that chosen data size appear in a single
consecutive buffer (1 iovec only)

The first patches of that series already do some re-work and
optimization of queue_cmd_ring and scatter_data_area such, that we
end up with something very similar to what you suggest :)

So instead of this patch I'll soon send a short series consisting
of those 3 patches and a new version of the current patch.
I hope, that series will look more organized.

Thank you,
Bodo


