Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2562EC2B9F4
	for <linux-scsi@archiver.kernel.org>; Tue, 22 Jun 2021 08:56:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 06D2E6108E
	for <linux-scsi@archiver.kernel.org>; Tue, 22 Jun 2021 08:56:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229663AbhFVI6v (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 22 Jun 2021 04:58:51 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:60146 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S229490AbhFVI6v (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 22 Jun 2021 04:58:51 -0400
Received: from pps.filterd (m0098420.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 15M8XmV1071463;
        Tue, 22 Jun 2021 04:56:26 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=Dxd0uQrMPyHW1PJcV7LCo5bf1t1PjYlkN/gyRY93hO4=;
 b=nncvjPxcqoo0dVJqSXKSeXCWkYJp+31wghUmxeyAgP9K9pyXMODEMKoZtHNx6GN2dXdW
 D2JecimxNgIcbK0NgPlJ+ZdfYMXA17Scdgkq2ozBVqpyutHdilPuJnyHVofLiFdTXu3H
 s3dg48sUbi3ZWyHlSMQx9ufwYOuoLMvXXNTkSqyTbgxJzKAGer5Wu0gcHMJnM2JxVavK
 tnl8ZW2nSdowdCfiq8gYNXtgsP+P+6M3QJMBunXYpPheNKJYYQBPTgh6+M1KDgimebhO
 8WqJonqkFhIJYmJ66JRRF4gl8A0rW528cTDF0EDdYvZ0pnfi6FBdsodPfrRZfqCj2Auw aQ== 
Received: from ppma04fra.de.ibm.com (6a.4a.5195.ip4.static.sl-reverse.com [149.81.74.106])
        by mx0b-001b2d01.pphosted.com with ESMTP id 39bahpbpdq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 22 Jun 2021 04:56:25 -0400
Received: from pps.filterd (ppma04fra.de.ibm.com [127.0.0.1])
        by ppma04fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 15M8q0WB011838;
        Tue, 22 Jun 2021 08:56:24 GMT
Received: from b06cxnps3074.portsmouth.uk.ibm.com (d06relay09.portsmouth.uk.ibm.com [9.149.109.194])
        by ppma04fra.de.ibm.com with ESMTP id 399878rqrx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 22 Jun 2021 08:56:23 +0000
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (b06wcsmtp001.portsmouth.uk.ibm.com [9.149.105.160])
        by b06cxnps3074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 15M8uL8G34865578
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 22 Jun 2021 08:56:21 GMT
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 97F31A4065;
        Tue, 22 Jun 2021 08:56:21 +0000 (GMT)
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 427E2A406A;
        Tue, 22 Jun 2021 08:56:21 +0000 (GMT)
Received: from oc7455500831.ibm.com (unknown [9.171.47.225])
        by b06wcsmtp001.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue, 22 Jun 2021 08:56:21 +0000 (GMT)
Subject: Re: [Patch 1/2] virtio_scsi: do not overwrite SCSI status
To:     hare@suse.de
Cc:     hch@lst.de, james.bottomley@hansenpartnership.com, jslaby@suse.com,
        linux-scsi@vger.kernel.org, martin.petersen@oracle.com
References: <20210610135833.46663-1-hare@suse.de>
 <20210618121437.761050-1-borntraeger@de.ibm.com>
From:   Christian Borntraeger <borntraeger@de.ibm.com>
Message-ID: <6c3fcaa9-1227-fbd3-3b8b-56c976c7b1db@de.ibm.com>
Date:   Tue, 22 Jun 2021 10:56:20 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <20210618121437.761050-1-borntraeger@de.ibm.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: KciaZAULzHzxS6zZx5I27JYY5Bih_Uo8
X-Proofpoint-GUID: KciaZAULzHzxS6zZx5I27JYY5Bih_Uo8
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.790
 definitions=2021-06-22_04:2021-06-21,2021-06-22 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 suspectscore=0 bulkscore=0
 malwarescore=0 impostorscore=0 mlxscore=0 clxscore=1015 spamscore=0
 mlxlogscore=598 phishscore=0 priorityscore=1501 adultscore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104190000 definitions=main-2106220054
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 18.06.21 14:14, Christian Borntraeger wrote:
> FWIW,
> I have just bisected a virtio-scsi failure to "scsi: Kill DRIVER_SENSE"
> and this patch "repairs" the problem.
> 

Any outlook when this lands in next? Having a broken virtio-scsi in next for 2 weeks now is
kind of painful.
