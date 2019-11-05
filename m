Return-Path: <SRS0=fi+p=Y5=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1AF74C49EAD
	for <linux-scsi@archiver.kernel.org>; Tue,  5 Nov 2019 09:39:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E46DF217F5
	for <linux-scsi@archiver.kernel.org>; Tue,  5 Nov 2019 09:39:09 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="Vl8wn86Z"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730889AbfKEJjG (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 5 Nov 2019 04:39:06 -0500
Received: from userp2120.oracle.com ([156.151.31.85]:60730 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730769AbfKEJjG (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 5 Nov 2019 04:39:06 -0500
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xA59crKN105088;
        Tue, 5 Nov 2019 09:38:53 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2019-08-05;
 bh=co+w0k79G3ndnVT1tw2oC6b5nHyZtabUCQzvllnx4dg=;
 b=Vl8wn86Z7TBfVgmOyWLrsHJVhFqfpWZA68lrnLDuEW4JBiN/O9rCX+UPVZPg4JGHwx7/
 ASYCraCunqDPyfllA5+UbogKpN/WF3P9tno3BAzmzDcA+g9RgCZdUwr0pev0kySL8+YV
 5h1g0CCWiSHxQlInsE+di4F5JqXarlWoxQLFMQ+qCDDF5ulVLBH31PBX+1vm5EmUb6/W
 p06lXZOUSeWf4ZVhm8JxSFumyI1QEooQz0bVMiQjSZYTocDZllRJaHnVj65sYK+aDN3q
 To8SUomhvgChIlJOqnw8Wxi8NXoRWRs1qAEt144F4wFaSpsrAqjCA8gAxiSF1cCuiV8H jw== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2120.oracle.com with ESMTP id 2w12er4t9n-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 05 Nov 2019 09:38:53 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xA59XTs4052977;
        Tue, 5 Nov 2019 09:36:53 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userp3020.oracle.com with ESMTP id 2w3160yr75-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 05 Nov 2019 09:36:52 +0000
Received: from abhmp0004.oracle.com (abhmp0004.oracle.com [141.146.116.10])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id xA59apol018864;
        Tue, 5 Nov 2019 09:36:51 GMT
Received: from kadam (/41.57.98.10)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 05 Nov 2019 01:36:50 -0800
Date:   Tue, 5 Nov 2019 12:36:41 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     Sumit Saxena <sumit.saxena@broadcom.com>
Cc:     Markus Elfring <Markus.Elfring@web.de>,
        Linux SCSI List <linux-scsi@vger.kernel.org>,
        "PDL,MEGARAIDLINUX" <megaraidlinux.pdl@broadcom.com>,
        "James E. J. Bottomley" <jejb@linux.ibm.com>,
        Kashyap Desai <kashyap.desai@broadcom.com>,
        Shivasharan S <shivasharan.srikanteshwara@broadcom.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        LKML <linux-kernel@vger.kernel.org>,
        kernel-janitors@vger.kernel.org,
        Chandrakanth Patil <chandrakanth.patil@broadcom.com>,
        YueHaibing <yuehaibing@huawei.com>
Subject: Re: [PATCH] scsi: megaraid_sas: Use common error handling code in
 megasas_mgmt_ioctl_fw()
Message-ID: <20191105093641.GE10409@kadam>
References: <d5c12f05-5a07-b698-ae60-2728330dd378@web.de>
 <CAL2rwxrdOVeO3RT_Y3mk3p-076eMMWm6VVF0C4yiYEWJ0TO5DQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAL2rwxrdOVeO3RT_Y3mk3p-076eMMWm6VVF0C4yiYEWJ0TO5DQ@mail.gmail.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9431 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1908290000 definitions=main-1911050082
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9431 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1011
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1908290000
 definitions=main-1911050083
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Tue, Nov 05, 2019 at 02:58:35PM +0530, Sumit Saxena wrote:
> On Fri, Nov 1, 2019 at 3:06 AM Markus Elfring <Markus.Elfring@web.de> wrote:
> >
> > From: Markus Elfring <elfring@users.sourceforge.net>
> > Date: Thu, 31 Oct 2019 22:23:02 +0100
> >
> > Move the same error code assignments so that such exception handling
> > can be better reused at the end of this function.
> >
> > This issue was detected by using the Coccinelle software.
> >
> > Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
> 
> Acked-by: Sumit Saxena <sumit.saxena@broadcom.com>
> 

The code was a lot better originally...  :(

regards,
dan carpenter

