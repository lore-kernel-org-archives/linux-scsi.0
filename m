Return-Path: <SRS0=VSHB=C7=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0B397C4363D
	for <linux-scsi@archiver.kernel.org>; Tue, 22 Sep 2020 16:07:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C159C2399A
	for <linux-scsi@archiver.kernel.org>; Tue, 22 Sep 2020 16:07:34 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="jgAv5Qib"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726746AbgIVQHe (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 22 Sep 2020 12:07:34 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:60906 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726340AbgIVQHe (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 22 Sep 2020 12:07:34 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 08MFn8U5145896;
        Tue, 22 Sep 2020 16:07:31 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=G2Nm4usBry4/hPAp63YfD293h2Gftx+AuTbYzzBsKXg=;
 b=jgAv5QibTxtmkmXKJlem7CdpVvXXHwpVdHPkT+vdpi6dtbodS741hG43K4RlWDemFYBA
 tdXQbfTKbO4iVKRNh7tTyEvFGhqlYNaSlfJNMLtZnlzeITmYMC0IU9BdLYw+t7WdpDaX
 rdoAdnqOD0LWLdG4VAok1HNA+H7tE1yoMOEpbgZxWbsD4qlzN7Xi2rCM+ESjmD3AlPiR
 d5Utj/6povn20Cf9L4MSmmkq3GcPgN2f7HVGb+Q6YS7I61R98BDTVmKtIf/v5DCjwuNv
 OhNajepjFyHNFXr8vH2YUD97QjsJeFXJLThSS51vMzAY8ClE6xJocPT5IlRmkgNqKUGp zA== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2120.oracle.com with ESMTP id 33ndnudsc8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Tue, 22 Sep 2020 16:07:31 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 08MG6N5V031816;
        Tue, 22 Sep 2020 16:07:31 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userp3020.oracle.com with ESMTP id 33nurt5np5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 22 Sep 2020 16:07:31 +0000
Received: from abhmp0001.oracle.com (abhmp0001.oracle.com [141.146.116.7])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 08MG7Tb3009713;
        Tue, 22 Sep 2020 16:07:29 GMT
Received: from [20.15.0.202] (/73.88.28.6)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 22 Sep 2020 09:07:28 -0700
Subject: Re: [PATCH 2/2] scsi sd: Allow user to config cmd retries
To:     Bart Van Assche <bvanassche@acm.org>, martin.petersen@oracle.com,
        linux-scsi@vger.kernel.org, james.bottomley@hansenpartnership.com
References: <1600714109-6178-1-git-send-email-michael.christie@oracle.com>
 <1600714109-6178-3-git-send-email-michael.christie@oracle.com>
 <947733d3-b591-1bd7-e4e3-b215c1ad743f@acm.org>
From:   Mike Christie <michael.christie@oracle.com>
Message-ID: <5ebaf757-f6ef-8922-3d91-290d996c0400@oracle.com>
Date:   Tue, 22 Sep 2020 11:07:27 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <947733d3-b591-1bd7-e4e3-b215c1ad743f@acm.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9752 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 malwarescore=0
 phishscore=0 mlxlogscore=999 bulkscore=0 mlxscore=0 suspectscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2009220123
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9752 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 lowpriorityscore=0 phishscore=0 adultscore=0 suspectscore=0 bulkscore=0
 clxscore=1015 impostorscore=0 mlxlogscore=999 mlxscore=0 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2009220122
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 9/21/20 10:22 PM, Bart Van Assche wrote:
> On 2020-09-21 11:48, Mike Christie wrote:
>> equivalent of a dm-mutlipath temp all paths down, or we just have to
>                      ^^^^^^^^^
>                      multipath?

Will fix.

> 
>> +static ssize_t
>> +max_retries_store(struct device *dev, struct device_attribute *attr,
>> +		  const char *buf, size_t count)
>> +{
>> +	struct scsi_disk *sdkp = to_scsi_disk(dev);
>> +	struct scsi_device *sdev = sdkp->device;
>> +	int retries;
>> +
>> +	if (sscanf(buf, "%d\n", &retries) != 1)
>> +		return -EINVAL;
> 
> Does the above code return 0 if a user uses echo -n to write into the
> max_retries attribute? If so, how about supporting echo -n?
> 
> Isn't kstrtoint() recommended over sscanf() in sysfs store callbacks?
> 

I'm not sure.

A dumb mistake on my part is that I had copied scsi_sysfs.c which uses sscanf but now that you mention it I see sd.c uses kstr*. I'll switch to kstr which also handles your \n comment too.
