Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 748EBC433EF
	for <linux-scsi@archiver.kernel.org>; Thu,  9 Jun 2022 12:03:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242679AbiFIMDh (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 9 Jun 2022 08:03:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36264 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242926AbiFIMDf (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 9 Jun 2022 08:03:35 -0400
Received: from esa5.hgst.iphmx.com (esa5.hgst.iphmx.com [216.71.153.144])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1EE6468FAD
        for <linux-scsi@vger.kernel.org>; Thu,  9 Jun 2022 05:03:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1654776212; x=1686312212;
  h=message-id:date:mime-version:subject:to:references:from:
   in-reply-to:content-transfer-encoding;
  bh=KhrCLwpq+259vZTYZRwZhSjsNBUfuaNbTg/2GAHxXsY=;
  b=QIZivzLN5pCKJQg5zSnHj2Dbsac4EmgkTniWUoipi5kKdhZBSmKw7NdP
   DhHZtL2rW0rfyCz84o4fQQTlSBRghjIHhSzWGw4BqodZncu9Q51+rXUuJ
   4ru1GX/UQ5HN2ODubPSCLVi1b+RFaBs4hwPxRadoK3Jn3sTwLLBwk1z9o
   HbPYT49w6cWX6l4gHQjcmL/CM9tJBWY6LKtXpfAnHBK72o5ekK2mPUkLy
   L72emlWMKuOInwZOBJQBMYOhT5o5Xl9hlVXGPExy61gBWinfKQlEE0XQg
   xbPcUl0Rx4UofinUdOuAvfsfLWI5iqUMvdt+WgbdT1kcB8j9wfXTiwDlJ
   Q==;
X-IronPort-AV: E=Sophos;i="5.91,287,1647273600"; 
   d="scan'208";a="202697458"
Received: from h199-255-45-15.hgst.com (HELO uls-op-cesaep02.wdc.com) ([199.255.45.15])
  by ob1.hgst.iphmx.com with ESMTP; 09 Jun 2022 20:03:32 +0800
IronPort-SDR: ZR0HYDUmmR7mj780wusr57evYem3ADvjKGhNG+emn0zCl9wYqjuR+8dB07Fxv8pvSJZmPUj40D
 APIwbBdc3tQsFFeO5Jyb7J5T99LiCkb4bf8mvW0ZuJDXgShxzIqS/tWiIyi3z6tSJuJAYrmKBm
 fRPIolohslS4g7maRl5WmeKv6MI3ccNd9GTHt8MEQ6hwrNshkoy5r/itmWjAiFLQaZ1UOsIL8v
 X/CXWl/4MAITn4eRDf8hGcbNMqZpuHpZKvDJBRiuO+d8FDTuaSVcEcnV4HiLopGwkzDZPDYOcj
 kMc/0vqO+AWDbdhHmAfxYptm
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 09 Jun 2022 04:22:20 -0700
IronPort-SDR: bKvLWf0tcDk90LTkpSjPbz8VKXcCV3yWM9SMcQvUVCv+pO+rAq/zF6/lw5S8nS0Co0oTSAUmWs
 A3SXhhcb6b8YVFEFjbjAaVwewrCU9qL06o7HdEODcynTDpmI399oA34giAqN7s07UuA3jmJ+pv
 Yp8VC/V1mwXK+yyTfiSpIgJMi0EhCO2CUozwjbe3samF5lBXQypEieDLF4ooTMk8PXqf9GbOrf
 U03UeYDPCXOBTar+h4gbRq6NW4XRXXii6a05UV2rbcp2nxPYc+Q7iNLaSy7hOnGIQ07v6c5/CD
 00w=
WDCIronportException: Internal
Received: from usg-ed-osssrv.wdc.com ([10.3.10.180])
  by uls-op-cesaip02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 09 Jun 2022 05:03:33 -0700
Received: from usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTP id 4LJjRS15Gjz1Rvlx
        for <linux-scsi@vger.kernel.org>; Thu,  9 Jun 2022 05:03:32 -0700 (PDT)
Authentication-Results: usg-ed-osssrv.wdc.com (amavisd-new); dkim=pass
        reason="pass (just generated, assumed good)"
        header.d=opensource.wdc.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=
        opensource.wdc.com; h=content-transfer-encoding:content-type
        :in-reply-to:organization:from:references:to:content-language
        :subject:user-agent:mime-version:date:message-id; s=dkim; t=
        1654776211; x=1657368212; bh=KhrCLwpq+259vZTYZRwZhSjsNBUfuaNbTg/
        2GAHxXsY=; b=Sl1/UD0JfWP9VXVpGh1fXbKfYoVemrQndF34zTfHDQvdhnu6gC6
        A8ruBvQQbyVRlPy8LXh53+684M5fkiie1zg/5rUDGIvGiTN6BVHrqwdia6JpuA34
        DwywElRTQ8NDOXkPoQn+1jvjjGXDQGHRNMSO9hmpz70ty+LzVvTu1og/8h2KekH1
        AaZxXjKmvXz+h9ymKQg9l0B0eCmDtOZGLbgPWgSoL6/1tUP0e0IRik9AM6iVovUc
        OTiZ7kHtwq2UJeVr+63QmAY4lwlHZaMzkpc0AFqQJOmsYl8uT7m8KWo8a/WymaF/
        sfQQiZSPK2z+Vfo9hpWWwDnHidXAWyO0q3g==
X-Virus-Scanned: amavisd-new at usg-ed-osssrv.wdc.com
Received: from usg-ed-osssrv.wdc.com ([127.0.0.1])
        by usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id 3wlLUCasLS_X for <linux-scsi@vger.kernel.org>;
        Thu,  9 Jun 2022 05:03:31 -0700 (PDT)
Received: from [10.225.163.72] (unknown [10.225.163.72])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTPSA id 4LJjRR2RNpz1Rvlc;
        Thu,  9 Jun 2022 05:03:31 -0700 (PDT)
Message-ID: <7d32cc0d-1ad7-dd6d-1158-09fb8273a62b@opensource.wdc.com>
Date:   Thu, 9 Jun 2022 21:03:30 +0900
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.10.0
Subject: Re: [PATCH 1/3] scsi: libsas: introduce struct smp_disc_resp
Content-Language: en-US
To:     John Garry <john.garry@huawei.com>, linux-scsi@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>
References: <20220609022456.409087-1-damien.lemoal@opensource.wdc.com>
 <20220609022456.409087-2-damien.lemoal@opensource.wdc.com>
 <9a4612db-7cc2-398d-f882-4190bc5d7759@huawei.com>
 <3a1ded4f-140e-57b7-732c-8c14a62e37eb@opensource.wdc.com>
 <59cb0ab7-c399-d2ff-6560-f3fe68a160aa@huawei.com>
From:   Damien Le Moal <damien.lemoal@opensource.wdc.com>
Organization: Western Digital Research
In-Reply-To: <59cb0ab7-c399-d2ff-6560-f3fe68a160aa@huawei.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 6/9/22 21:02, John Garry wrote:
> On 09/06/2022 12:59, Damien Le Moal wrote:
>> On 6/9/22 17:43, John Garry wrote:
>>>>    #define DISCOVER_REQ_SIZE  16
>>>> -#define DISCOVER_RESP_SIZE 56
>>>> +#define DISCOVER_RESP_SIZE sizeof(struct smp_disc_resp)
>>> I feel that it would be nice to get rid of these.
>>>
>>> Maybe something like:
>>>
>>> #define smp_execute_task_wrap(dev, req, resp)\
>>> smp_execute_task(dev, req, sizeof(*req), resp, DISCOVER_REQ_SIZE)
>>>
>>>
>>> static int sas_ex_phy_discover_helper(struct domain_device *dev, u8
>>> *disc_req, struct smp_disc_resp *disc_resp, int single)
>>> {
>>> 	res = smp_execute_task_wrap(dev, disc_req, disc_resp);
>>>
>>> We could even introduce a smp req struct to get rid of DISCOVER_REQ_SIZE
>>> - the (current) code would be a bit less cryptic then.
>> Yes, I think the req size needs a similar treatment too, and we can remove
>> all these REQ/RESP_SIZE macros. But for now, the req side does not bother
>> gcc and I do not see any warning, so I left it. This series is really
>> about getting rid of the warnings so that we can use CONFIG_WERROR.
>> There are some xfs warnings that needs to be taken care of too to be able
>> to use that one again though.
>>
>>> But no big deal. Looks ok apart from that.
>> If you agree to do the req cleanup as a followup series, 
> 
> ok, I'll assume that you can do it when you get a chance..

Yep, one more pile of patches added to the to-do list :)

> 
> can you send a
>> formal review please ?
>>
> Reviewed-by: John Garry <john.garry@huawei.com>

Thanks !


-- 
Damien Le Moal
Western Digital Research
