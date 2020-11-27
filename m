Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4738FC2D0E4
	for <linux-scsi@archiver.kernel.org>; Fri, 27 Nov 2020 09:22:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C908C206D8
	for <linux-scsi@archiver.kernel.org>; Fri, 27 Nov 2020 09:22:02 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="lLAIN5yA"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727452AbgK0JVb (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 27 Nov 2020 04:21:31 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:13028 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726014AbgK0JVa (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 27 Nov 2020 04:21:30 -0500
Received: from pps.filterd (m0098420.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0AR92sIY043644;
        Fri, 27 Nov 2020 04:21:23 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=3+5uFdJAzDE4hZmH6EUh+WOYOUNSgrvapC3XLw32IjA=;
 b=lLAIN5yANAURYCJl0yBfWvtt3a+Pbq/yJRGKVD1TRzRd4oQDvcBsLf0N9e7Gm0BesOVy
 pn4szDUNuMqu+hdIGo79tHyVDTmayh+YGy6bK6Jrb4L6vU600OmdzXz58lnna4P1iLRi
 Km20hr+bdDI0UIli8Iun2FgmoEJXz4UkCNaS1ETXnap5LYYAsS2OD9/ogH/scIvRsDE2
 xMK7WeE9EyUg0ype3Pj4bLKDQzAgvWQy7u5xq6eSoVLYIGcJ/sa1+fSDAQAr1lCi8A+O
 EdMwRLlDhgQj96pWH98cGCeCOOHnzcx2+AAmPR2a/a5dwwSaSSXL9n4YNP/O3tbNbFUQ eQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 352we6j8dq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 27 Nov 2020 04:21:22 -0500
Received: from m0098420.ppops.net (m0098420.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 0AR93VLw046547;
        Fri, 27 Nov 2020 04:21:22 -0500
Received: from ppma04fra.de.ibm.com (6a.4a.5195.ip4.static.sl-reverse.com [149.81.74.106])
        by mx0b-001b2d01.pphosted.com with ESMTP id 352we6j8d4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 27 Nov 2020 04:21:22 -0500
Received: from pps.filterd (ppma04fra.de.ibm.com [127.0.0.1])
        by ppma04fra.de.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 0AR97Uot002117;
        Fri, 27 Nov 2020 09:21:20 GMT
Received: from b06cxnps4074.portsmouth.uk.ibm.com (d06relay11.portsmouth.uk.ibm.com [9.149.109.196])
        by ppma04fra.de.ibm.com with ESMTP id 352drkgdm6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 27 Nov 2020 09:21:20 +0000
Received: from d06av26.portsmouth.uk.ibm.com (d06av26.portsmouth.uk.ibm.com [9.149.105.62])
        by b06cxnps4074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 0AR9LHjC53674460
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 27 Nov 2020 09:21:17 GMT
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 8D9F2AE053;
        Fri, 27 Nov 2020 09:21:17 +0000 (GMT)
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 12C36AE04D;
        Fri, 27 Nov 2020 09:21:17 +0000 (GMT)
Received: from oc4120165700.ibm.com (unknown [9.145.51.25])
        by d06av26.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Fri, 27 Nov 2020 09:21:16 +0000 (GMT)
Subject: Re: [PATCH] scsi: zfcp: fix use-after-free in zfcp_unit_remove
To:     Benjamin Block <bblock@linux.ibm.com>,
        Qinglang Miao <miaoqinglang@huawei.com>
Cc:     Cornelia Huck <cohuck@redhat.com>,
        Heiko Carstens <hca@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-scsi@vger.kernel.org
References: <20201120074854.31754-1-miaoqinglang@huawei.com>
 <20201125170658.GB8578@t480-pf1aa2c2>
 <4c65bead-2553-171e-54d2-87a9de0330e8@huawei.com>
 <20201126091353.50cf6ab6.cohuck@redhat.com>
 <20201126094259.GE8578@t480-pf1aa2c2>
 <9ba663ad-97fe-6c2a-e15a-45f2de1f0af0@huawei.com>
 <20201126151242.GI8578@t480-pf1aa2c2>
From:   Steffen Maier <maier@linux.ibm.com>
Message-ID: <90356c8e-f523-1d16-45a2-0c8b9fae15c0@linux.ibm.com>
Date:   Fri, 27 Nov 2020 10:21:16 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.3.1
MIME-Version: 1.0
In-Reply-To: <20201126151242.GI8578@t480-pf1aa2c2>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.312,18.0.737
 definitions=2020-11-27_04:2020-11-26,2020-11-27 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 adultscore=0 bulkscore=0 mlxlogscore=999 lowpriorityscore=0 malwarescore=0
 clxscore=1011 suspectscore=0 mlxscore=0 spamscore=0 phishscore=0
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2011270052
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 11/26/20 4:12 PM, Benjamin Block wrote:
> On Thu, Nov 26, 2020 at 08:07:32PM +0800, Qinglang Miao wrote:
>> 在 2020/11/26 17:42, Benjamin Block 写道:
>>> On Thu, Nov 26, 2020 at 09:13:53AM +0100, Cornelia Huck wrote:
>>>> On Thu, 26 Nov 2020 09:27:41 +0800
>>>> Qinglang Miao <miaoqinglang@huawei.com> wrote:
>>>>> 在 2020/11/26 1:06, Benjamin Block 写道:
>>>>>> On Fri, Nov 20, 2020 at 03:48:54PM +0800, Qinglang Miao wrote:
> ....
>>> Let's go by example. If we assume the reference count of `unit->dev` is
>>> R, and the function starts with R = 1 (otherwise the deivce would've
>>> been freed already), we get:
>>>
>>>       int zfcp_unit_remove(struct zfcp_port *port, u64 fcp_lun)
>>>       {
>>>       	struct zfcp_unit *unit;
>>>       	struct scsi_device *sdev;
>>>       	write_lock_irq(&port->unit_list_lock);
>>> // unit->dev (R = 1)
>>>       	unit = _zfcp_unit_find(port, fcp_lun);
>>> // get_device(&unit->dev)
>>> // unit->dev (R = 2)
>>>       	if (unit)
>>>       		list_del(&unit->list);
>>>       	write_unlock_irq(&port->unit_list_lock);
>>>       	if (!unit)
>>>       		return -EINVAL;
>>>       	sdev = zfcp_unit_sdev(unit);
>>>       	if (sdev) {
>>>       		scsi_remove_device(sdev);
>>>       		scsi_device_put(sdev);
>>>       	}
>>> // unit->dev (R = 2)
>>>       	put_device(&unit->dev);
>>> // unit->dev (R = 1)
>>>       	device_unregister(&unit->dev);
>>> // unit->dev (R = 0)
>>>       	return 0;
>>>       }
>>>
>>> If we now apply this patch, we'd end up with R = 1 after
>>> `device_unregister()`, and the device would not be properly removed.
>>>
>>> If you still think that's wrong, then you'll need to better explain why.
>>>
>> Hi Banjamin and Cornelia,
>>
>> Your replies make me reliaze that I've been holding a mistake understanding
>> of put_device() as well as reference count.
>>
>> Thanks for you two's patient explanation !!
>>
>> BTW, should I send a v2 on these two patches to move the position of
>> put_device()?
> 
> Feel free to do so.
> 
> I think having the `put_device()` call after `device_unregister()` in
> both `zfcp_unit_remove()` and `zfcp_sysfs_port_remove_store()` is more
> natural, because it ought to be the last time we touch the object in
> both functions.

If you move put_device(), you could add a comment like we did here to explain 
which (hidden) get_device is undone:
https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/drivers/s390/scsi?id=ef4021fe5fd77ced0323cede27979d80a56211ca
("scsi: zfcp: fix to prevent port_remove with pure auto scan LUNs (only sdevs)")
So in this patch it could be:
	put_device(&unit->dev); /* undo _zfcp_unit_find() */
And in the other patch it could be:
	put_device(&port->dev); /* undo zfcp_get_port_by_wwpn() */
Then it would be clearer next time somebody looks at the code.

Especially for the other patch on zfcp_sysfs_port_remove_store() moving the 
put_device(&port->dev) to at least *after* the call of 
zfcp_erp_port_shutdown(port, 0, "syprs_1") would make the code cleaner to me. 
Along the idead of passing the port to zfcp_erp_port_shutdown with the 
reference we got from zfcp_get_port_by_wwpn(). That said, the current code is 
of course still correct as we currently have the port ref of the earlier 
device_register so passing the port to zfcp_erp_port_shutdown() is safe.

If we wanted to make the gets and puts nicely nested, then we could move the 
puts to just before the device_unregister, but that's bike shedding:
	device_register()   --+
	get_device() --+      |
	put_device() --+      |
	device_unregister() --+

Benjamin's suggested move location works for me, too. After all, the kdoc of 
device_unregister explicitly mentions the possibility that other refs might 
continue to exist after device_unregister was called:
	device_register()   --+
	get_device() ---------|--+
	device_unregister() --+  |
	put_device() ------------+

-- 
Mit freundlichen Gruessen / Kind regards
Steffen Maier

Linux on IBM Z Development

https://www.ibm.com/privacy/us/en/
IBM Deutschland Research & Development GmbH
Vorsitzender des Aufsichtsrats: Matthias Hartmann
Geschaeftsfuehrung: Dirk Wittkopp
Sitz der Gesellschaft: Boeblingen
Registergericht: Amtsgericht Stuttgart, HRB 243294
