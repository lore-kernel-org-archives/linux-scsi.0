Return-Path: <SRS0=wj+1=BI=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B3D30C433E0
	for <linux-scsi@archiver.kernel.org>; Wed, 29 Jul 2020 14:44:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9474820809
	for <linux-scsi@archiver.kernel.org>; Wed, 29 Jul 2020 14:44:50 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="vzlCiuKB"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726588AbgG2Oor (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 29 Jul 2020 10:44:47 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:54366 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726353AbgG2Oor (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 29 Jul 2020 10:44:47 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 06TEgsaZ046823;
        Wed, 29 Jul 2020 14:44:36 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : mime-version :
 content-type; s=corp-2020-01-29;
 bh=4rEO8k4nNPfnY1pN/MMDY9F6Q2fLbVFIcq67BVaIyxk=;
 b=vzlCiuKBWeAv7hs3MtDK7rxllc6HbsR34ZvvE/neEYclt4oHjgnmL07um+sV8VqROE3n
 NOULNU0/vuPzzLvS+eJNrkHYzN2RiYYirGjAFkM18GQQGN+aMr14LKGEXfAg4SH9TNAK
 Ydt7eQWdBPz7j/MGZZYLDKhXk4TbCu2EOgy7WTvBhhpwnzcATb+FlFhWqyzO9i60an79
 n+Zm08jrW/At0xxMhbrt9rZg6Ai84Dv6xyWm3uEVpRH2BdsbUBB0rRVvNW/DWRtNEMS4
 WnkF8m4riK5+MWkkPtboXk6jrA1vdd1Xm7bfaCEO7LJUAOYxr0bx0jYZR0WUpnWrNQ1T /A== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2130.oracle.com with ESMTP id 32hu1je2bh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Wed, 29 Jul 2020 14:44:36 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 06TEglE8151910;
        Wed, 29 Jul 2020 14:44:35 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3030.oracle.com with ESMTP id 32hu5vv0m8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 29 Jul 2020 14:44:35 +0000
Received: from abhmp0002.oracle.com (abhmp0002.oracle.com [141.146.116.8])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 06TEiVvE025291;
        Wed, 29 Jul 2020 14:44:31 GMT
Received: from ca-mkp.ca.oracle.com (/10.159.214.123)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 29 Jul 2020 07:44:30 -0700
To:     Alan Stern <stern@rowland.harvard.edu>
Cc:     Martin Kepplinger <martin.kepplinger@puri.sm>,
        Bart Van Assche <bvanassche@acm.org>, jejb@linux.ibm.com,
        Can Guo <cang@codeaurora.org>, martin.petersen@oracle.com,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        kernel@puri.sm
Subject: Re: [PATCH] scsi: sd: add runtime pm to open / release
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq15za68k17.fsf@ca-mkp.ca.oracle.com>
References: <20200706164135.GE704149@rowland.harvard.edu>
        <d0ed766b-88b0-5ad5-9c10-a4c3b2f994e3@puri.sm>
        <20200728200243.GA1511887@rowland.harvard.edu>
        <f3958758-afce-8add-1692-2a3bbcc49f73@puri.sm>
        <20200729143213.GC1530967@rowland.harvard.edu>
Date:   Wed, 29 Jul 2020 10:44:26 -0400
In-Reply-To: <20200729143213.GC1530967@rowland.harvard.edu> (Alan Stern's
        message of "Wed, 29 Jul 2020 10:32:13 -0400")
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9696 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=1 malwarescore=0
 mlxscore=0 adultscore=0 spamscore=0 phishscore=0 mlxlogscore=848
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2007290100
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9696 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 clxscore=1011
 malwarescore=0 spamscore=0 suspectscore=1 bulkscore=0 priorityscore=1501
 phishscore=0 mlxlogscore=855 lowpriorityscore=0 impostorscore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2007290100
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Alan,

>> [   77.474632] sd 0:0:0:0: [sda] tag#0 UNKNOWN(0x2003) Result:
>> hostbyte=0x00 driverbyte=0x08 cmd_age=0s
>> [   77.474647] sd 0:0:0:0: [sda] tag#0 Sense Key : 0x6 [current]
>> [   77.474655] sd 0:0:0:0: [sda] tag#0 ASC=0x28 ASCQ=0x0
>> [   77.474667] sd 0:0:0:0: [sda] tag#0 CDB: opcode=0x28 28 00 00 00 60
>> 40 00 00 01 00
>
> This error report comes from the SCSI layer, not the block layer.

This the device telling us that the media (SD card?) has changed.

-- 
Martin K. Petersen	Oracle Linux Engineering
