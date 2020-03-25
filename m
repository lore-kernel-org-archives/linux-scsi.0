Return-Path: <SRS0=rA/a=5K=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 075ECC2BA18
	for <linux-scsi@archiver.kernel.org>; Wed, 25 Mar 2020 22:06:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D2FA92082F
	for <linux-scsi@archiver.kernel.org>; Wed, 25 Mar 2020 22:06:18 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="yWB9JtKV"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727564AbgCYWGS (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 25 Mar 2020 18:06:18 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:38812 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727357AbgCYWGR (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 25 Mar 2020 18:06:17 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 02PM3vtr109953;
        Wed, 25 Mar 2020 22:06:15 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : references : date : in-reply-to : message-id : mime-version :
 content-type; s=corp-2020-01-29;
 bh=c3VA1siqI2EbmauAibDJBX3KlDcH9PvGElFZzg2v1xQ=;
 b=yWB9JtKVgqQnjXYcN9rIG/fJDfA5APOjKpaj3+VL0xJhfA7d2xGg8+FHRtQ72G8QDvfO
 RiE2PVRLcy3PHKJj2g/HM6KeZvA7WBnamniU7DRqMN7HNblcSj3yJmy1baIoMTSTcXq8
 2caED+C5UtC7p3MIXAQEtWh7Xs9Di4UlXXs+WszdzLqqrxgCExc2DexzRHCs13gafKgu
 LYTE7wODESk+igymQtDsTnO/QYtqBHQ9dibF85q0tuPdkjfumT2lZ/ulNHhHSPfu4q5g
 aEMtDeTBKgvFkxcSNxRrDPEDd39xGMqNQEtBQSZqolt0KgK3AoSTf5jMzw+i83azYZG2 kw== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2120.oracle.com with ESMTP id 2ywavmccgc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 25 Mar 2020 22:06:15 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 02PM2Yg8140251;
        Wed, 25 Mar 2020 22:06:15 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3020.oracle.com with ESMTP id 30073bc63u-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 25 Mar 2020 22:06:15 +0000
Received: from abhmp0018.oracle.com (abhmp0018.oracle.com [141.146.116.24])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 02PM6EVh014367;
        Wed, 25 Mar 2020 22:06:14 GMT
Received: from ca-mkp.ca.oracle.com (/10.159.214.123)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 25 Mar 2020 15:06:13 -0700
To:     Bart Van Assche <bvanassche@acm.org>
Cc:     "Martin K. Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org
Subject: Re: [PATCH] scsi: core: Make MODE SENSE DBD a boolean
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
References: <20200325213608.6843-1-martin.petersen@oracle.com>
        <116e8e24-d442-6239-b401-dd3145f4e8e8@acm.org>
Date:   Wed, 25 Mar 2020 18:06:11 -0400
In-Reply-To: <116e8e24-d442-6239-b401-dd3145f4e8e8@acm.org> (Bart Van Assche's
        message of "Wed, 25 Mar 2020 14:45:48 -0700")
Message-ID: <yq1k138hyy4.fsf@oracle.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1.92 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9571 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 adultscore=0
 suspectscore=0 mlxscore=0 phishscore=0 bulkscore=0 spamscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2003250168
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9571 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 malwarescore=0
 priorityscore=1501 mlxscore=0 bulkscore=0 clxscore=1015 impostorscore=0
 phishscore=0 suspectscore=0 mlxlogscore=999 spamscore=0 lowpriorityscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2003020000
 definitions=main-2003250168
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Bart,

> On 2020-03-25 14:36, Martin K. Petersen wrote:
>>  	} else {
>>  		modepage = 8;
>> -		dbd = 0;
>> +		dbd = true;
>>  	}
>
> Is this change on purpose?

No, I probably triggered on the 8 in the modepage line above when I made
this change. Thanks for spotting!

-- 
Martin K. Petersen	Oracle Linux Engineering
