Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0D52BC433EF
	for <linux-scsi@archiver.kernel.org>; Mon, 27 Sep 2021 17:37:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DA75260F4F
	for <linux-scsi@archiver.kernel.org>; Mon, 27 Sep 2021 17:37:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236635AbhI0RjW (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 27 Sep 2021 13:39:22 -0400
Received: from mail-pg1-f172.google.com ([209.85.215.172]:44931 "EHLO
        mail-pg1-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238446AbhI0Rhm (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 27 Sep 2021 13:37:42 -0400
Received: by mail-pg1-f172.google.com with SMTP id s11so18429252pgr.11
        for <linux-scsi@vger.kernel.org>; Mon, 27 Sep 2021 10:36:04 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=qnOJbRqHIxeWS8cMFkdElQg/D7ViOYbm5BG89+AIfZs=;
        b=BWelXmDSYPga5q3lzjvzuoRE8pAWGIvfqgjhon7IoYWT2q7aTeh9VUflnyLIq2Yq/D
         7xLK8jsYZVKjbgtf5ZZuqZiVCabFjRM7xjgG2pnTGoKdri0u+RBYCygyp2vRGwYgUX1l
         VCAFQq2tgzsGYp1ef67jfrcND4MRIHLZD9xhTrnVV0zTlo1HaKfqbjhDzGpk2rujF0vi
         FA2dr52u1fj5LymfJ1OQT+10kXs1CwJ+DPzOVpsGOwoM+bnvv9RNaEhM1cgEAQ8+m81J
         /AYQ71jMjyvb5zI2mGD1KYOpf7KlLLzqMCWK55yD+DGlFY+gSqARQO7MuPXp/LEtJDff
         Mh8Q==
X-Gm-Message-State: AOAM533hDWdYylioEOzJl2m0zsti3MPXrECkiKm/+0bXf8Mt4mTLH1Kz
        DR7vEC8qe9K5dOau7DPt4Ig=
X-Google-Smtp-Source: ABdhPJznEk/o1pq2oQeK4NdysLo5fc8GsJVvopNy97lEP/kN0IH96qy+BeWBOWMWvqcBMRtCaMWcBw==
X-Received: by 2002:a63:ef01:: with SMTP id u1mr744825pgh.336.1632764163833;
        Mon, 27 Sep 2021 10:36:03 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:eed8:744a:6ba3:d1b])
        by smtp.gmail.com with ESMTPSA id w206sm17692269pfc.45.2021.09.27.10.36.00
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 27 Sep 2021 10:36:03 -0700 (PDT)
Subject: Re: [PATCH 1/2] scsi: Register SCSI host sysfs attributes earlier
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, Christoph Hellwig <hch@lst.de>,
        Hannes Reinecke <hare@suse.com>,
        Damien Le Moal <damien.lemoal@opensource.wdc.com>,
        Doug Ledford <dledford@redhat.com>,
        Jason Gunthorpe <jgg@ziepe.ca>,
        Sathya Prakash <sathya.prakash@broadcom.com>,
        Sreekanth Reddy <sreekanth.reddy@broadcom.com>,
        Suganath Prabu Subramani 
        <suganath-prabu.subramani@broadcom.com>,
        Steffen Maier <maier@linux.ibm.com>,
        Benjamin Block <bblock@linux.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Adam Radford <aradford@gmail.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Adaptec OEM Raid Solutions <aacraid@microsemi.com>,
        Subbu Seetharaman <subbu.seetharaman@broadcom.com>,
        Ketan Mukadam <ketan.mukadam@broadcom.com>,
        Jitendra Bhivare <jitendra.bhivare@broadcom.com>,
        Anil Gurumurthy <anil.gurumurthy@qlogic.com>,
        Sudarsana Kalluru <sudarsana.kalluru@qlogic.com>,
        Saurav Kashyap <skashyap@marvell.com>,
        Javed Hasan <jhasan@marvell.com>,
        GR-QLogic-Storage-Upstream@marvell.com,
        Nilesh Javali <njavali@marvell.com>,
        Manish Rangankar <mrangankar@marvell.com>,
        "Manoj N. Kumar" <manoj@linux.ibm.com>,
        "Matthew R. Ochs" <mrochs@linux.ibm.com>,
        Uma Krishnan <ukrishn@linux.ibm.com>,
        Satish Kharat <satishkh@cisco.com>,
        Sesidhar Baddela <sebaddel@cisco.com>,
        Karan Tilak Kumar <kartilak@cisco.com>,
        John Garry <john.garry@huawei.com>,
        Don Brace <don.brace@microchip.com>,
        HighPoint Linux Team <linux@highpoint-tech.com>,
        Tyrel Datwyler <tyreld@linux.ibm.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Brian King <brking@us.ibm.com>,
        Artur Paszkiewicz <artur.paszkiewicz@intel.com>,
        James Smart <james.smart@broadcom.com>,
        Dick Kennedy <dick.kennedy@broadcom.com>,
        Kashyap Desai <kashyap.desai@broadcom.com>,
        Sumit Saxena <sumit.saxena@broadcom.com>,
        Shivasharan S <shivasharan.srikanteshwara@broadcom.com>,
        Hannes Reinecke <hare@kernel.org>,
        Jack Wang <jinpu.wang@cloud.ionos.com>,
        ching Huang <ching2048@areca.com.tw>,
        Jiapeng Chong <jiapeng.chong@linux.alibaba.com>,
        Yufen Yu <yuyufen@huawei.com>,
        Zhen Lei <thunder.leizhen@huawei.com>
References: <20210924232635.1637763-1-bvanassche@acm.org>
 <20210924232635.1637763-2-bvanassche@acm.org> <YU7llg2wj555lte8@kroah.com>
From:   Bart Van Assche <bvanassche@acm.org>
Message-ID: <9b4a1b11-45a8-0ff0-4597-021b8b271090@acm.org>
Date:   Mon, 27 Sep 2021 10:35:59 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <YU7llg2wj555lte8@kroah.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 9/25/21 2:02 AM, Greg Kroah-Hartman wrote:
> On Fri, Sep 24, 2021 at 04:26:34PM -0700, Bart Van Assche wrote:
>> diff --git a/drivers/scsi/hosts.c b/drivers/scsi/hosts.c
>> index 3f6f14f0cafb..f424aca6dc6e 100644
>> --- a/drivers/scsi/hosts.c
>> +++ b/drivers/scsi/hosts.c
>> @@ -480,7 +480,15 @@ struct Scsi_Host *scsi_host_alloc(struct scsi_host_template *sht, int privsize)
>>   	shost->shost_dev.parent = &shost->shost_gendev;
>>   	shost->shost_dev.class = &shost_class;
>>   	dev_set_name(&shost->shost_dev, "host%d", shost->host_no);
>> -	shost->shost_dev.groups = scsi_sysfs_shost_attr_groups;
>> +	shost->shost_dev.groups = shost->shost_dev_attr_groups;
>> +	shost->shost_dev_attr_groups[0] = &scsi_host_attr_group;
>> +	if (shost->hostt->shost_attrs) {
>> +		shost->shost_dev_attr_groups[1] =
>> +			&shost->shost_driver_attr_group;
>> +		shost->shost_driver_attr_group = (struct attribute_group){
>> +			.attrs = shost->hostt->shost_attrs,
>> +		};
> 
> Did you just allocate this off the stack?  What happens when the
> function returns and the stack data is returned?

The SCSI host data structure is allocated as follows:

	shost = kzalloc(sizeof(struct Scsi_Host) + privsize, GFP_KERNEL);

So the shost->shost_dev_attr_groups array exists in SLAB memory.

>> --- a/include/scsi/scsi_host.h
>> +++ b/include/scsi/scsi_host.h
>> @@ -476,7 +476,7 @@ struct scsi_host_template {
>>   	/*
>>   	 * Pointer to the sysfs class properties for this host, NULL terminated.
>>   	 */
>> -	struct device_attribute **shost_attrs;
>> +	struct attribute **shost_attrs;
> 
> Why isn't this "struct attribute_group **groups"?

I will make this change.

>> @@ -695,6 +695,8 @@ struct Scsi_Host {
>>   
>>   	/* ldm bits */
>>   	struct device		shost_gendev, shost_dev;
>> +	struct attribute_group  shost_driver_attr_group;
>> +	const struct attribute_group *shost_dev_attr_groups[3];
> 
> Why just 3?

I'm trying to avoid yet another dynamic memory allocation. One array entry
is for the SCSI core attribute group, the second array entry is for the
group with device driver attributes and the third entry is the NULL sentinel.

Thanks,

Bart.
