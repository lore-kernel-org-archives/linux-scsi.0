Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 33738C433EF
	for <linux-scsi@archiver.kernel.org>; Wed, 27 Apr 2022 03:03:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357339AbiD0DG1 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 26 Apr 2022 23:06:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49222 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232067AbiD0DG0 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 26 Apr 2022 23:06:26 -0400
Received: from nksmu.kylinos.cn (mailgw.kylinos.cn [123.150.8.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 025C6340C2;
        Tue, 26 Apr 2022 20:03:16 -0700 (PDT)
X-UUID: 2b590d7d9a4c4b11bbec5992426546b3-20220427
X-UUID: 2b590d7d9a4c4b11bbec5992426546b3-20220427
Received: from cs2c.com.cn [(172.17.111.24)] by nksmu.kylinos.cn
        (envelope-from <lienze@kylinos.cn>)
        (Generic MTA)
        with ESMTP id 339532612; Wed, 27 Apr 2022 11:01:43 +0800
X-ns-mid: postfix-6268B26F-7169302919
Received: from ubuntu (unknown [172.30.60.63])
        by cs2c.com.cn (NSMail) with ESMTPA id A8AAA3848664;
        Wed, 27 Apr 2022 03:03:11 +0000 (UTC)
Date:   Wed, 27 Apr 2022 11:03:11 +0800
From:   Enze Li <lienze@kylinos.cn>
To:     martin.petersen@oracle.com
Cc:     jejb@linux.ibm.com, lienze@kylinos.cn,
        linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
Subject: Re: [PATCH] scsi: sr: add handling of memory allocation failure in
 get_capabilities
Message-ID: <20220427110311.301172b9@ubuntu>
In-Reply-To: <yq1ilqwt3ml.fsf@ca-mkp.ca.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi Martin,

Thank you for the review.  I've fixed the issue you pointed out.
v2 of this patch is here:
https://lore.kernel.org/all/20220427025647.298358-1-lienze@kylinos.cn/

Thanks,
Enze

>Enze,
>
>> @@ -669,8 +669,9 @@ static int sr_probe(struct device *dev)
>>  
>>  	sdev->sector_size = 2048;	/* A guess, just in case */
>>  
>> -	/* FIXME: need to handle a get_capabilities failure properly
>> ?? */
>> -	get_capabilities(cd);
>> +	error = -ENOMEM;
>> +	if (get_capabilities(cd))
>> +		goto fail_put;
>
>Shouldn't this be 'goto fail_minor;'?
>
>-- 
>Martin K. Petersen	Oracle Linux Engineering
