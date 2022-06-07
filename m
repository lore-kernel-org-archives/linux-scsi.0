Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D817DC43334
	for <linux-scsi@archiver.kernel.org>; Tue,  7 Jun 2022 00:42:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234011AbiFGAmg (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 6 Jun 2022 20:42:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52174 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233137AbiFGAme (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 6 Jun 2022 20:42:34 -0400
Received: from esa1.hgst.iphmx.com (esa1.hgst.iphmx.com [68.232.141.245])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EAA3714D36
        for <linux-scsi@vger.kernel.org>; Mon,  6 Jun 2022 17:42:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1654562550; x=1686098550;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=m0+yNmbRCrj0YqAb+g4pMS//ee70PjjqC+xkF3LUVJ8=;
  b=SlDEypTm+REyzm0gvMR7Fo/yljwM5OaXJHU5F+BoViupvBdByIs6jSph
   08+MPpsxTqubFCYB/4zdHM3mHbvZdQWt5HaPJVi0WedNCButJNSJbQjdW
   lXcfPrR112lPHKK0Ob8SU+ZJjHHgKX4uIyvhoBH8SvpP1dA2G6yNYsnYf
   aay3dXtWLU0l4cFlIcWmxnsO6JZOxLqPK7TVCbvDQuWVcBxLlSjV6ypUw
   EJ6c6AuoFWyA7eUx3pPHxIWPHxnGx6x2Tpw87Ah5zSsi/YMf3VnEcCOuR
   IL4vInn0vAdPqyvjXQ41U29Fxb4pNsnEQj2KxHAM7LLNSrCKk/dhfxlLO
   Q==;
X-IronPort-AV: E=Sophos;i="5.91,282,1647273600"; 
   d="scan'208";a="314473092"
Received: from h199-255-45-15.hgst.com (HELO uls-op-cesaep02.wdc.com) ([199.255.45.15])
  by ob1.hgst.iphmx.com with ESMTP; 07 Jun 2022 08:42:26 +0800
IronPort-SDR: gIAxEtTUxSTi+wgrrvhxRdD1J7wEXWxXM9Ze2IOHCcp7re5kbTuMVVHFKMWlnUX91HYrmgUlwE
 IaZL++edOFTYbYMkzhuNKGE5bJZx01vRDmDNe3BAB+aPKWJX4grHp9txdb1Hc2BgWjStQciG8e
 iTJpx2a7gfkfNnD7Lc3oOH4Eg4OblkCwA9CC/FFvQVHzX+SHiumEufYm5L5+MtpPOtnR+XA2jO
 3DL1XzRi3PQUXQn5fGd61/07bnJKk02sT1cAk96UBJf7Ob7SZHiTpaJrvLlJuSuSOAjAGPl2O4
 zincPS4xww2yOARv2R6VW5eo
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 06 Jun 2022 17:01:23 -0700
IronPort-SDR: 8eaZn+VP4gks521Qe82wrwvA60stHUO0oKPoTYzRrO0Mdy8z370vyJiB3duxGFPDO5Jib1JpI9
 Yb1D9cf1tjd9J7AbQdG2DnV3GWOmtPZrge3dtncbj+xnW1YqOCKkhVPA53QYKycjheE9K1H8GP
 cfrIdi0E6VzHVgUK2HT3mZUnIFQT+xBxbQYeNzUM1JJIWDxkPhQRmhp13I9tfXOtQv/O+G/6TF
 IheLEaxopWrXNw3RIwkYNLzoZ4egSoMzBk9OiNKYFCYNyxQvb6+L8sQ2hE3/UC3XTclCwdr2pe
 sI0=
WDCIronportException: Internal
Received: from usg-ed-osssrv.wdc.com ([10.3.10.180])
  by uls-op-cesaip02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 06 Jun 2022 17:42:26 -0700
Received: from usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTP id 4LHBQT67LNz1SVp3
        for <linux-scsi@vger.kernel.org>; Mon,  6 Jun 2022 17:42:25 -0700 (PDT)
Authentication-Results: usg-ed-osssrv.wdc.com (amavisd-new); dkim=pass
        reason="pass (just generated, assumed good)"
        header.d=opensource.wdc.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=
        opensource.wdc.com; h=content-transfer-encoding:content-type
        :in-reply-to:organization:from:references:to:content-language
        :subject:user-agent:mime-version:date:message-id; s=dkim; t=
        1654562545; x=1657154546; bh=m0+yNmbRCrj0YqAb+g4pMS//ee70PjjqC+x
        kF3LUVJ8=; b=P8bVub+2f7qdroJGi/5ooCZ30Z96wVX8F54pMY46jyJzN9aoZ58
        gNMlYONodwRr44zrD6O4NqelybGorqPmQeb233jvZDVSCPTLcFzYCf4RpmHyx+ih
        imnKOZudKBffoaFnUCsDpNGyPEWQtqKsiPqyuTx4AIgRi9njTMtCGR3LtHLjw4dy
        wCtQjQaO8NaIrfH9O2DkR4wyZ0g3luQsDZ3NWwdb16t8b1VRntXJEIixTmE1YqhE
        ed/n6uOQk9dL3c2y2aMVk8gAqJsVrbs84STSAjCG5wTkaIvUUdEt7enmGS0K889R
        nCGHFvJJ+dL6EWWivIIHVdZfgPuzWUGpmmQ==
X-Virus-Scanned: amavisd-new at usg-ed-osssrv.wdc.com
Received: from usg-ed-osssrv.wdc.com ([127.0.0.1])
        by usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id M5myhsfvTqZP for <linux-scsi@vger.kernel.org>;
        Mon,  6 Jun 2022 17:42:25 -0700 (PDT)
Received: from [10.89.82.246] (c02drav6md6t.dhcp.fujisawa.hgst.com [10.89.82.246])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTPSA id 4LHBQQ2Gqcz1Rvlc;
        Mon,  6 Jun 2022 17:42:22 -0700 (PDT)
Message-ID: <84bb2d37-4097-5122-7e88-33bd9bc7ed61@opensource.wdc.com>
Date:   Tue, 7 Jun 2022 09:42:21 +0900
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.9.1
Subject: Re: [RESEND PATCH] scsi: ufs: sysfs: support writing boot_lun attr
Content-Language: en-US
To:     Bart Van Assche <bvanassche@acm.org>,
        Avri Altman <Avri.Altman@wdc.com>,
        Caleb Connolly <caleb.connolly@linaro.org>,
        "a5b6@riseup.net" <a5b6@riseup.net>,
        Alim Akhtar <alim.akhtar@samsung.com>,
        "James E . J . Bottomley" <jejb@linux.ibm.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Cc:     "~postmarketos/upstreaming@lists.sr.ht" 
        <~postmarketos/upstreaming@lists.sr.ht>,
        "phone-devel@vger.kernel.org" <phone-devel@vger.kernel.org>
References: <20220525164013.93748-1-a5b6@riseup.net>
 <DM6PR04MB65750969ACD36EEEB48374DFFCD69@DM6PR04MB6575.namprd04.prod.outlook.com>
 <8d25171a-5d86-9acc-0f94-1a3c6efdb360@riseup.net>
 <DM6PR04MB65752422396C86EAD4591701FCD89@DM6PR04MB6575.namprd04.prod.outlook.com>
 <a7f46ad1-6d9e-a38e-31cc-29fddfa2b496@linaro.org>
 <DM6PR04MB65751A3B1D0BA4467CADDA93FCDF9@DM6PR04MB6575.namprd04.prod.outlook.com>
 <a4746c67-fa74-8af1-3f2d-7853e9fae8a6@acm.org>
 <3c400db6-d251-c4bd-b019-b9dc1d807212@opensource.wdc.com>
 <2677b02e-b2a3-7c79-2e62-acf1acbc8ff0@acm.org>
From:   Damien Le Moal <damien.lemoal@opensource.wdc.com>
Organization: Western Digital Research
In-Reply-To: <2677b02e-b2a3-7c79-2e62-acf1acbc8ff0@acm.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2022/06/06 22:16, Bart Van Assche wrote:
> On 6/5/22 19:48, Damien Le Moal wrote:
>> On 6/5/22 12:55, Bart Van Assche wrote:
>>> On 6/1/22 10:05, Avri Altman wrote:
>>>> As a design rule, sysfs attribute files should not be used to make
>>>> persistent modifications to a device configuration. This rule applies
>>>> to all subsystems and ufs is no different.
>>>
>>> Hmm ... where does that rule come from? I can't find it in
>>> Documentation/admin-guide/sysfs-rules.rst. Did I perhaps overlook something?
>>
>> I am not aware of any writable sysfs attribute file that can be used to
>> make persistent device configuration changes, at least in storage area.
>> I know of plenty that do change a device setting, but without saving this
>> setting to maintain it across power cycles. Do you know of any such
>> attribute ? I was under the impression that sysfs should not be used to
>> persistently reconfigure a device...
> 
> I don't think the above is sufficient as an argument to reject a new 
> patch that introduces a sysfs attribute that changes the device 
> configuration.

It depends if we can guarantee that the write access to the sysfs file is done
with the same security checks as for a passthrough command issued from user
space. I have not checked.

I would also argue that this particular feature is related to the boot device
management, which is not something we do in the kernel. There is no sysfs
interface to set the bootable flag of a partition on a disk, right ? That is
very similar to me. The kernel should not bother about that kind of interface.
User application tools can deal with that.

> 
> Thanks,
> 
> Bart.
> 


-- 
Damien Le Moal
Western Digital Research
