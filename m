Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C3ECAC76188
	for <linux-scsi@archiver.kernel.org>; Tue,  4 Apr 2023 23:30:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236450AbjDDXav (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 4 Apr 2023 19:30:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51254 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229973AbjDDXau (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 4 Apr 2023 19:30:50 -0400
X-Greylist: delayed 169 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Tue, 04 Apr 2023 16:30:50 PDT
Received: from wnew2-smtp.messagingengine.com (wnew2-smtp.messagingengine.com [64.147.123.27])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 06B60171A;
        Tue,  4 Apr 2023 16:30:49 -0700 (PDT)
Received: from compute2.internal (compute2.nyi.internal [10.202.2.46])
        by mailnew.west.internal (Postfix) with ESMTP id 31FC02B06716;
        Tue,  4 Apr 2023 19:18:41 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute2.internal (MEProxy); Tue, 04 Apr 2023 19:18:42 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fastmail.com; h=
        cc:cc:content-transfer-encoding:content-type:content-type:date
        :date:from:from:in-reply-to:in-reply-to:message-id:mime-version
        :references:reply-to:sender:subject:subject:to:to; s=fm2; t=
        1680650320; x=1680653920; bh=Dh/jNwxjYyR3YpziKbhDIW+cpNCUKNq7RU5
        ux1R/gic=; b=q5V2S59rH5jkx5zlsSCfiUImJuQixSIsU7cedybja9ADMiLFtFV
        ToS5U+4F2TygnB3tXBEmHcazEmsV6viFXUK/QmSWQG8U4AAXJwdaGgfVL9654u2m
        WBA2iSxif7a3ztZXcy4diSv2ufdH9QXmuv0zY5LnsveYJx+LB8LwGfdJU4QerS8U
        ozSWsfJr9Wu6eSUXq7IKP7VcKRvQcq9xlW3+NvHfzQKiu1SkUEZg24ma1eBG5sHR
        zAWW8v/XZmaHkMpPYbVr2Tg9naW0TEDIY5PgRANbhchdJ+2L8NbRDvxzRIuLjzeG
        JDBErgfQA5rCzWKrvBeY5Pt+XgmKlRe4sdw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:cc:content-transfer-encoding
        :content-type:content-type:date:date:feedback-id:feedback-id
        :from:from:in-reply-to:in-reply-to:message-id:mime-version
        :references:reply-to:sender:subject:subject:to:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=i3db14652.fm2;
         t=1680650320; x=1680653920; bh=Dh/jNwxjYyR3YpziKbhDIW+cpNCUKNq7
        RU5ux1R/gic=; b=DnpaVgehezZt6XRUm7fxSj+Yi74DH9MGh2041S2cXS/6dx2Y
        qi5YyySk5SkiqnMEJKF3QxOUYZVlTGTSUIJzoqex04jyKw0WVxwWtzIqDAxqdHj4
        WOWSRL/HQC3bnqYybZnhNXmMgswdlELbtaYwqo+W6EQL63NF1s2vwqeZYle8SewV
        ce/joO5ME77vcSLbgW/vR7t6E/17RzTBZFVhXdjK5GIHdZJSvfRFnuQu6pcvU/OK
        4+GVxqe6p4GazPlpaG8hQSuijghTeQunkrA6YsdBBeDepJje2IqbpDiRxqY++kSn
        o1IXRvG2FtotAmmZNi3USo/4d0pBBHFU3seLHA==
X-ME-Sender: <xms:T7AsZOhGqhftAi9KnSZ_t0aeV05JPij0hZwJRYlSlrtTekJ_e8Flpg>
    <xme:T7AsZPC8CuXQ_8IHeEsVlq5niGmL2T5CUg47OaIcyCpenfdfFtPcbcVXOjVsQeatL
    wh_pI7F1gx1RV8Dpv0>
X-ME-Received: <xmr:T7AsZGFq8m-iWriWNrLUQbe6wnpo51z_S12pPSC-S-6DbMFkW9bcIfjtNvvTdn9SdTeuxhNQiGZ77V7Xc1uU9kp5LvU7JvCL>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvhedrvdejtddgudejucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepkfffgggfuffvvehfhfgjtgfgsehtjeertddtfeejnecuhfhrohhmpeffrghm
    ihgvnhcunfgvucfoohgrlhcuoegulhgvmhhorghlsehfrghsthhmrghilhdrtghomheqne
    cuggftrfgrthhtvghrnhepteefiefhieetgfevhfegfeehffetteduieetudfgleetvdff
    udelveejfefhfeejnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilh
    hfrhhomhepughlvghmohgrlhesfhgrshhtmhgrihhlrdgtohhm
X-ME-Proxy: <xmx:T7AsZHTdGep7XbMvF9ciWoRW17Z_vfRc44HeTVo9iB1W6MQXf_qUqA>
    <xmx:T7AsZLxGLeV35LWE9NoOB0nI0-YxRatB87c2yQAz4UIaOS02pe-_vQ>
    <xmx:T7AsZF6iCgD2ziqnSVNG9nqM5gKWRNxgOKCb4PQyvm_jbJIvkZGUgg>
    <xmx:ULAsZJ4IJiknPsjBzOd-7aJN2WYRsciV0liGW9fsVhyENRfK-T_OdiG8TgE>
Feedback-ID: i3db14652:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Tue,
 4 Apr 2023 19:18:36 -0400 (EDT)
Message-ID: <83f26d2a-6577-50d9-9a76-0f95dfb05bca@fastmail.com>
Date:   Wed, 5 Apr 2023 08:18:34 +0900
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.9.1
Subject: Re: [PATCH v5 09/19] scsi: allow enabling and disabling command
 duration limits
To:     Igor Pylypiv <ipylypiv@google.com>, Niklas Cassel <nks@flawful.org>
Cc:     Jens Axboe <axboe@kernel.dk>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Bart Van Assche <bvanassche@acm.org>,
        Christoph Hellwig <hch@lst.de>, Hannes Reinecke <hare@suse.de>,
        Damien Le Moal <damien.lemoal@opensource.wdc.com>,
        linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org,
        linux-block@vger.kernel.org, Niklas Cassel <niklas.cassel@wdc.com>
References: <20230404182428.715140-1-nks@flawful.org>
 <20230404182428.715140-10-nks@flawful.org> <ZCx6dzyEfWYNaF6r@google.com>
Content-Language: en-US
From:   Damien Le Moal <dlemoal@fastmail.com>
In-Reply-To: <ZCx6dzyEfWYNaF6r@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 4/5/23 04:28, Igor Pylypiv wrote:
>> diff --git a/drivers/scsi/scsi_sysfs.c b/drivers/scsi/scsi_sysfs.c
>> index 4994148e685b..9a54b2c0fee7 100644
>> --- a/drivers/scsi/scsi_sysfs.c
>> +++ b/drivers/scsi/scsi_sysfs.c
>> @@ -1222,6 +1222,36 @@ static DEVICE_ATTR(queue_ramp_up_period, S_IRUGO | S_IWUSR,
>>  		   sdev_show_queue_ramp_up_period,
>>  		   sdev_store_queue_ramp_up_period);
>>  
>> +static ssize_t sdev_show_cdl_enable(struct device *dev,
>> +				    struct device_attribute *attr, char *buf)
>> +{
>> +	struct scsi_device *sdev = to_scsi_device(dev);
>> +
>> +	return sysfs_emit(buf, "%d\n", (int)sdev->cdl_enable);
>> +}
>> +
>> +static ssize_t sdev_store_cdl_enable(struct device *dev,
>> +				     struct device_attribute *attr,
>> +				     const char *buf, size_t count)
>> +{
>> +	int ret;
>> +	bool v;
>> +
>> +	if (!capable(CAP_SYS_ADMIN))
>> +		return -EACCES;
> CAP_SYS_ADMIN seems be too restrictive. NCQ PRIO (ncq_prio_enable) does not 
> require CAP_SYS_ADMIN. Since NCQ PRIO and CDL are mutually exclusive a user
> should be able to toggle both features.

Indeed, we can have CDL be the same as NCQ prio. We can remove this
SYS_CAP_ADMIN check.


