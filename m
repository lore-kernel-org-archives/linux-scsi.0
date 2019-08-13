Return-Path: <SRS0=/G9W=WJ=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1EE7FC31E40
	for <linux-scsi@archiver.kernel.org>; Tue, 13 Aug 2019 01:53:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D54CA20679
	for <linux-scsi@archiver.kernel.org>; Tue, 13 Aug 2019 01:53:05 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="K4nCztNc";
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="3WhrUA1l"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726463AbfHMBxF (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 12 Aug 2019 21:53:05 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:59570 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726236AbfHMBxF (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 12 Aug 2019 21:53:05 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x7D1nFYo006013;
        Tue, 13 Aug 2019 01:53:02 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : references : date : in-reply-to : message-id : mime-version :
 content-type; s=corp-2019-08-05;
 bh=teXYfRBwDoGWjDBh2naeW0sAKvtoFMGqz2zAV1pjKkc=;
 b=K4nCztNcBanS1BPJ+ezSnZpsVIr29Tg13hJ8E0VxjjhrwKRAc6uhfPamNL3f4CH6vfr6
 j8KJ5PUX//pY36WBnrvUgtHv59xn9CwfdGImEpIgEGL2qDj77HqFRqnVFjpm+GGLWES0
 zcyY1olk3xm+MwQHGOB+Ph5DcRJ9R1B7P0rHZF7rJoIHKSTU1wBoltecs390Z5w3K9MH
 RkPHfHU3KksiJpOCs5550HXtdlX5xwlMVu93W31ttWTP2h37tQj7wl5YCFwDe2AXURYR
 OwIRUt8GilzWw/c+PP0wTVJvMMniG7a9c/ghL/3KRyQIqFhgkY36HzdlIDD9WKslulrF xg== 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : references : date : in-reply-to : message-id : mime-version :
 content-type; s=corp-2018-07-02;
 bh=teXYfRBwDoGWjDBh2naeW0sAKvtoFMGqz2zAV1pjKkc=;
 b=3WhrUA1looegwvDo5inONr+Sq4P6hr1shb37keXF56LPy0zzFu8SN9bQ9jzOnn/OEZ1j
 gcRWjqxqMAWQNLXCAbsphWysHKOnh5mEKCs1uAdEis5sIjp7eLZTRFEHuw8zRgShQiWx
 SssLS/vveLK6YuOHSPV7VSFBbtGZkab2IMGkOxqxv6GE4magC9xz8wvVKO6HQQU0+IrV
 X8dk73mG7HxarIao6zqMNaBD1R4yTkan1fOytPekWqcBBXk4sAswaHffKziHN2nPpLSJ
 0a+U0pYOZ9xgtfA+MPNvaB0cdHvRxrEQA/j69/P89DAI3Cbu8viZUcjEqLdiBlKtpGUe MA== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2130.oracle.com with ESMTP id 2u9nbtb2qx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 13 Aug 2019 01:53:02 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x7D1nIOD093659;
        Tue, 13 Aug 2019 01:53:01 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userp3020.oracle.com with ESMTP id 2u9n9hjp0r-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 13 Aug 2019 01:53:01 +0000
Received: from abhmp0010.oracle.com (abhmp0010.oracle.com [141.146.116.16])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x7D1r0sT024859;
        Tue, 13 Aug 2019 01:53:00 GMT
Received: from ca-mkp.ca.oracle.com (/10.159.214.123)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 12 Aug 2019 18:53:00 -0700
To:     Chandrakanth Patil <chandrakanth.patil@broadcom.com>
Cc:     "Martin K. Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org,
        Kashyap Desai <kashyap.desai@broadcom.com>,
        Sumit Saxena <sumit.saxena@broadcom.com>,
        Kiran Kumar Kasturi <kiran-kumar.kasturi@broadcom.com>,
        Sankar Patra <sankar.patra@broadcom.com>,
        Sasikumar PC <sasikumar.pc@broadcom.com>,
        Shivasharan Srikanteshwara 
        <shivasharan.srikanteshwara@broadcom.com>,
        Anand Lodnoor <anand.lodnoor@broadcom.com>
Subject: Re: [PATCH] megaraid_sas: change sdev queue depth max vs optimal
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
References: <20190726073214.23820-1-chandrakanth.patil@broadcom.com>
        <yq1zhkke9c8.fsf@oracle.com>
        <06139ab3efab799a9d3148b1f04847b0@mail.gmail.com>
Date:   Mon, 12 Aug 2019 21:52:57 -0400
In-Reply-To: <06139ab3efab799a9d3148b1f04847b0@mail.gmail.com> (Chandrakanth
        Patil's message of "Thu, 8 Aug 2019 22:56:56 +0530")
Message-ID: <yq1h86l96h2.fsf@oracle.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1.92 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9347 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1906280000 definitions=main-1908130017
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9347 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1906280000
 definitions=main-1908130017
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Chandrakanth,

> The firmware provided queue depth provides optimum performance in most
> of the cases/workloads. And this patch provides the option to the user
> to go with max queue_depth or with optimum queue_depth.

I guess I'm just objecting to the notion that something is being
described as "optimum" when it clearly isn't.

Applied to 5.4/scsi-queue. Thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
