Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DD0B4C77B7D
	for <linux-scsi@archiver.kernel.org>; Thu, 18 May 2023 19:22:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229942AbjERTWW (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 18 May 2023 15:22:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51326 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229493AbjERTWU (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 18 May 2023 15:22:20 -0400
Received: from mail-pg1-f173.google.com (mail-pg1-f173.google.com [209.85.215.173])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A3A25E52
        for <linux-scsi@vger.kernel.org>; Thu, 18 May 2023 12:22:18 -0700 (PDT)
Received: by mail-pg1-f173.google.com with SMTP id 41be03b00d2f7-51f6461af24so1586856a12.2
        for <linux-scsi@vger.kernel.org>; Thu, 18 May 2023 12:22:18 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684437738; x=1687029738;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=dTue8s2JQF/he/QccC9xtoLudEnum8Wl/eWHuhFe+Zk=;
        b=EZustFkYu3MQLuW4QeAeO5pbswhn/d+HeQbN1VztqTob3YKbVnfWlXG3nZPJXMuaV7
         CC/iEMAYb4ndjOoYbfy/jST8644W38+r7mUtibRrjtGnoSpGPnApB33vBw66pXqRNWn5
         Ll3VQiTDtvMNMd8ypQGjSq6Ner0yQLfEwsCpGzxo5F4cOLZ/YcZuifLMOCXPmCKQkg43
         1xRp7HcuVgm1fpLkCLUQESgX0gGq81bR3/vikveGXdRKr8vyBzK9+OBboUHyD7ULMSYW
         MnYPWVWPx9yw26ZCB+1/dz5ZLDFfio5J5hBVUQ8BeG+GAhyMz9pHrJ57Ytso1VQ9Z6h6
         H7mQ==
X-Gm-Message-State: AC+VfDzqfRfkEXOL6EZ9jtFy7k8aiRGeTjp0bz64TXw6e+cIJhaeRd2J
        W6gFqhEGxtJjIn3ShbOYIH0=
X-Google-Smtp-Source: ACHHUZ5INdwfC5NeGW5988O7WifQ3RV69yAwUd+DJPBf4tqCK4Izg5mgJ3SSuqHNNSFv49B/p4q3OQ==
X-Received: by 2002:a17:903:1ca:b0:1ad:e639:e673 with SMTP id e10-20020a17090301ca00b001ade639e673mr30807plh.53.1684437737942;
        Thu, 18 May 2023 12:22:17 -0700 (PDT)
Received: from [192.168.51.14] ([98.51.102.78])
        by smtp.gmail.com with ESMTPSA id je7-20020a170903264700b001a943c41c37sm1850170plb.7.2023.05.18.12.22.16
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 18 May 2023 12:22:17 -0700 (PDT)
Message-ID: <a6da705d-5858-2b73-dc93-a82b618a4ace@acm.org>
Date:   Thu, 18 May 2023 12:22:16 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.0
Subject: Re: [PATCH v3 2/4] scsi: core: Trace SCSI sense data
Content-Language: en-US
To:     Ming Lei <ming.lei@redhat.com>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        Christoph Hellwig <hch@lst.de>, linux-scsi@vger.kernel.org,
        Niklas Cassel <niklas.cassel@wdc.com>,
        Hannes Reinecke <hare@suse.de>,
        John Garry <john.g.garry@oracle.com>,
        Mike Christie <michael.christie@oracle.com>
References: <20230517230927.1091124-1-bvanassche@acm.org>
 <20230517230927.1091124-3-bvanassche@acm.org>
 <ZGV4kTms/igv9s0O@ovpn-8-16.pek2.redhat.com>
From:   Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <ZGV4kTms/igv9s0O@ovpn-8-16.pek2.redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 5/17/23 18:00, Ming Lei wrote:
> On Wed, May 17, 2023 at 04:09:25PM -0700, Bart Van Assche wrote:
>>   	TP_printk("host_no=%u channel=%u id=%u lun=%u data_sgl=%u prot_sgl=%u " \
>>   		  "prot_op=%s driver_tag=%d scheduler_tag=%d cmnd=(%s %s raw=%s) " \
>> -		  "result=(driver=%s host=%s message=%s status=%s)",
>> +		  "result=(driver=%s host=%s message=%s status=%s "
>> +		  "sense_key=%#x asc=%#x ascq=%#x)",
> 
> This way probably breaks userspace script or utility, maybe you can
> just append "sense(sense_key=%#x asc=%#x ascq=%#x)" only.

I will make this change.

Thanks,

Bart.

